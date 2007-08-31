From: akpm@linux-foundation.org
Subject: + dca-add-direct-cache-access-driver.patch added to -mm tree
Date: Fri, 31 Aug 2007 12:28:10 -0700
Message-ID: <200708311928.l7VJSBoO022933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33525 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486AbXHaT21 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 15:28:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shannon.nelson@intel.com, davem@davemloft.net


The patch titled
     DCA: Add Direct Cache Access driver
has been added to the -mm tree.  Its filename is
     dca-add-direct-cache-access-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: DCA: Add Direct Cache Access driver
From: Shannon Nelson <shannon.nelson@intel.com>

Direct Cache Access (DCA) is a method for warming the CPU cache before data
is used, with the intent of lessening the impact of cache misses.  This
patch adds a manager and interface for matching up client requests for DCA
services with devices that offer DCA services.

In order to use DCA, a module must do bus writes with the appropriate tag
bits set to trigger a cache read for a specific CPU.  However, different
CPUs and chipsets can require different sets of tag bits, and the methods
for determining the correct bits may be simple hardcoding or may be a
hardware specific magic incantation.  This interface is a way for DCA
clients to find the correct tag bits for the targeted CPU without needing
to know the specifics.

    [Dave Miller] use DEFINE_SPINLOCK()

Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/Kconfig         |    2 
 drivers/Makefile        |    1 
 drivers/dca/Kconfig     |   11 ++
 drivers/dca/Makefile    |    2 
 drivers/dca/dca-core.c  |  200 ++++++++++++++++++++++++++++++++++++++
 drivers/dca/dca-sysfs.c |   88 ++++++++++++++++
 include/linux/dca.h     |   47 ++++++++
 7 files changed, 351 insertions(+)

diff -puN drivers/Kconfig~dca-add-direct-cache-access-driver drivers/Kconfig
--- a/drivers/Kconfig~dca-add-direct-cache-access-driver
+++ a/drivers/Kconfig
@@ -86,6 +86,8 @@ source "drivers/rtc/Kconfig"
 
 source "drivers/dma/Kconfig"
 
+source "drivers/dca/Kconfig"
+
 source "drivers/auxdisplay/Kconfig"
 
 source "drivers/kvm/Kconfig"
diff -puN drivers/Makefile~dca-add-direct-cache-access-driver drivers/Makefile
--- a/drivers/Makefile~dca-add-direct-cache-access-driver
+++ a/drivers/Makefile
@@ -86,6 +86,7 @@ obj-$(CONFIG_CRYPTO)		+= crypto/
 obj-$(CONFIG_SUPERH)		+= sh/
 obj-$(CONFIG_GENERIC_TIME)	+= clocksource/
 obj-$(CONFIG_DMA_ENGINE)	+= dma/
+obj-$(CONFIG_DCA)		+= dca/
 obj-$(CONFIG_HID)		+= hid/
 obj-$(CONFIG_PPC_PS3)		+= ps3/
 obj-$(CONFIG_OF)		+= of/
diff -puN /dev/null drivers/dca/Kconfig
--- /dev/null
+++ a/drivers/dca/Kconfig
@@ -0,0 +1,11 @@
+#
+# DCA server configuration
+#
+
+config DCA
+	tristate "DCA support for clients and providers"
+	default m
+	help
+	  This is a server to help modules that want to use Direct Cache
+	  Access to find DCA providers that will supply correct CPU tags.
+
diff -puN /dev/null drivers/dca/Makefile
--- /dev/null
+++ a/drivers/dca/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_DCA) += dca.o
+dca-objs := dca-core.o dca-sysfs.o
diff -puN /dev/null drivers/dca/dca-core.c
--- /dev/null
+++ a/drivers/dca/dca-core.c
@@ -0,0 +1,200 @@
+/*
+ * Copyright(c) 2007 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59
+ * Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called COPYING.
+ */
+
+/*
+ * This driver supports an interface for DCA clients and providers to meet.
+ */
+
+#include <linux/kernel.h>
+#include <linux/notifier.h>
+#include <linux/device.h>
+#include <linux/dca.h>
+
+MODULE_LICENSE("GPL");
+
+/* For now we're assuming a single, global, DCA provider for the system. */
+
+static DEFINE_SPINLOCK(dca_lock);
+
+static struct dca_provider *global_dca = NULL;
+
+/**
+ * dca_add_requester - add a dca client to the list
+ * @dev - the device that wants dca service
+ */
+int dca_add_requester(struct device *dev)
+{
+	int err, slot;
+
+	if (!global_dca)
+		return -ENODEV;
+
+	spin_lock(&dca_lock);
+	slot = global_dca->ops->add_requester(global_dca, dev);
+	spin_unlock(&dca_lock);
+	if (slot < 0)
+		return slot;
+
+	err = dca_sysfs_add_req(global_dca, dev, slot);
+	if (err) {
+		spin_lock(&dca_lock);
+		global_dca->ops->remove_requester(global_dca, dev);
+		spin_unlock(&dca_lock);
+		return err;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dca_add_requester);
+
+/**
+ * dca_remove_requester - remove a dca client from the list
+ * @dev - the device that wants dca service
+ */
+int dca_remove_requester(struct device *dev)
+{
+	int slot;
+	if (!global_dca)
+		return -ENODEV;
+
+	spin_lock(&dca_lock);
+	slot = global_dca->ops->remove_requester(global_dca, dev);
+	spin_unlock(&dca_lock);
+	if (slot < 0)
+		return slot;
+
+	dca_sysfs_remove_req(global_dca, slot);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dca_remove_requester);
+
+/**
+ * dca_get_tag - return the dca tag for the given cpu
+ * @cpu - the cpuid as returned by get_cpu()
+ */
+u8 dca_get_tag(int cpu)
+{
+	if (!global_dca)
+		return -ENODEV;
+	return global_dca->ops->get_tag(global_dca, cpu);
+}
+EXPORT_SYMBOL_GPL(dca_get_tag);
+
+/**
+ * alloc_dca_provider - get data struct for describing a dca provider
+ * @ops - pointer to struct of dca operation function pointers
+ * @priv_size - size of extra mem to be added for provider's needs
+ */
+struct dca_provider *alloc_dca_provider(struct dca_ops *ops, int priv_size)
+{
+	struct dca_provider *dca;
+	int alloc_size;
+
+	alloc_size = (sizeof(*dca) + priv_size);
+	dca = kzalloc(alloc_size, GFP_KERNEL);
+	if (!dca)
+		return NULL;
+	dca->ops = ops;
+
+	return dca;
+}
+EXPORT_SYMBOL_GPL(alloc_dca_provider);
+
+/**
+ * free_dca_provider - release the dca provider data struct
+ * @ops - pointer to struct of dca operation function pointers
+ * @priv_size - size of extra mem to be added for provider's needs
+ */
+void free_dca_provider(struct dca_provider *dca)
+{
+	kfree(dca);
+}
+EXPORT_SYMBOL_GPL(free_dca_provider);
+
+static BLOCKING_NOTIFIER_HEAD(dca_provider_chain);
+
+/**
+ * register_dca_provider - register a dca provider
+ * @dca - struct created by alloc_dca_provider()
+ * @dev - device providing dca services
+ */
+int register_dca_provider(struct dca_provider *dca, struct device *dev)
+{
+	int err;
+
+	if (global_dca)
+		return -EEXIST;
+	err = dca_sysfs_add_provider(dca, dev);
+	if (err)
+		return err;
+	global_dca = dca;
+	blocking_notifier_call_chain(&dca_provider_chain,
+				     DCA_PROVIDER_ADD, NULL);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(register_dca_provider);
+
+/**
+ * unregister_dca_provider - remove a dca provider
+ * @dca - struct created by alloc_dca_provider()
+ */
+void unregister_dca_provider(struct dca_provider *dca)
+{
+	if (!global_dca)
+		return;
+	blocking_notifier_call_chain(&dca_provider_chain,
+				     DCA_PROVIDER_REMOVE, NULL);
+	global_dca = NULL;
+	dca_sysfs_remove_provider(dca);
+}
+EXPORT_SYMBOL_GPL(unregister_dca_provider);
+
+/**
+ * dca_register_notify - register a client's notifier callback
+ */
+void dca_register_notify(struct notifier_block *nb)
+{
+	blocking_notifier_chain_register(&dca_provider_chain, nb);
+}
+EXPORT_SYMBOL_GPL(dca_register_notify);
+
+/**
+ * dca_unregister_notify - remove a client's notifier callback
+ */
+void dca_unregister_notify(struct notifier_block *nb)
+{
+	blocking_notifier_chain_unregister(&dca_provider_chain, nb);
+}
+EXPORT_SYMBOL_GPL(dca_unregister_notify);
+
+static int __init dca_init(void)
+{
+	return dca_sysfs_init();
+}
+
+static void __exit dca_exit(void)
+{
+	dca_sysfs_exit();
+}
+
+module_init(dca_init);
+module_exit(dca_exit);
+
diff -puN /dev/null drivers/dca/dca-sysfs.c
--- /dev/null
+++ a/drivers/dca/dca-sysfs.c
@@ -0,0 +1,88 @@
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/device.h>
+#include <linux/idr.h>
+#include <linux/kdev_t.h>
+#include <linux/err.h>
+#include <linux/dca.h>
+
+static struct class *dca_class;
+static struct idr dca_idr;
+static spinlock_t dca_idr_lock;
+
+int dca_sysfs_add_req(struct dca_provider *dca, struct device *dev, int slot)
+{
+	struct class_device *cd;
+
+	cd = class_device_create(dca_class, dca->cd, MKDEV(0, slot + 1),
+				 dev, "requester%d", slot);
+	if (IS_ERR(cd))
+		return PTR_ERR(cd);
+	return 0;
+}
+
+void dca_sysfs_remove_req(struct dca_provider *dca, int slot)
+{
+	class_device_destroy(dca_class, MKDEV(0, slot + 1));
+}
+
+int dca_sysfs_add_provider(struct dca_provider *dca, struct device *dev)
+{
+	struct class_device *cd;
+	int err = 0;
+
+idr_try_again:
+	if (!idr_pre_get(&dca_idr, GFP_KERNEL))
+		return -ENOMEM;
+	spin_lock(&dca_idr_lock);
+	err = idr_get_new(&dca_idr, dca, &dca->id);
+	spin_unlock(&dca_idr_lock);
+	switch (err) {
+	case 0:
+		break;
+	case -EAGAIN:
+		goto idr_try_again;
+	default:
+		return err;
+	}
+
+	cd = class_device_create(dca_class, NULL, MKDEV(0, 0),
+				 dev, "dca%d", dca->id);
+	if (IS_ERR(cd)) {
+		spin_lock(&dca_idr_lock);
+		idr_remove(&dca_idr, dca->id);
+		spin_unlock(&dca_idr_lock);
+		return PTR_ERR(cd);
+	}
+	dca->cd = cd;
+	return 0;
+}
+
+void dca_sysfs_remove_provider(struct dca_provider *dca)
+{
+	class_device_unregister(dca->cd);
+	dca->cd = NULL;
+	spin_lock(&dca_idr_lock);
+	idr_remove(&dca_idr, dca->id);
+	spin_unlock(&dca_idr_lock);
+}
+
+int __init dca_sysfs_init(void)
+{
+	idr_init(&dca_idr);
+	spin_lock_init(&dca_idr_lock);
+
+	dca_class = class_create(THIS_MODULE, "dca");
+	if (IS_ERR(dca_class)) {
+		idr_destroy(&dca_idr);
+		return PTR_ERR(dca_class);
+	}
+	return 0;
+}
+
+void __exit dca_sysfs_exit(void)
+{
+	class_destroy(dca_class);
+	idr_destroy(&dca_idr);
+}
+
diff -puN /dev/null include/linux/dca.h
--- /dev/null
+++ a/include/linux/dca.h
@@ -0,0 +1,47 @@
+#ifndef DCA_H
+#define DCA_H
+/* DCA Provider API */
+
+/* DCA Notifier Interface */
+void dca_register_notify(struct notifier_block *nb);
+void dca_unregister_notify(struct notifier_block *nb);
+
+#define DCA_PROVIDER_ADD     0x0001
+#define DCA_PROVIDER_REMOVE  0x0002
+
+struct dca_provider {
+	struct dca_ops		*ops;
+	struct class_device 	*cd;
+	int			 id;
+};
+
+struct dca_ops {
+	int	(*add_requester)    (struct dca_provider *, struct device *);
+	int	(*remove_requester) (struct dca_provider *, struct device *);
+	u8	(*get_tag)	    (struct dca_provider *, int cpu);
+};
+
+struct dca_provider *alloc_dca_provider(struct dca_ops *ops, int priv_size);
+void free_dca_provider(struct dca_provider *dca);
+int register_dca_provider(struct dca_provider *dca, struct device *dev);
+void unregister_dca_provider(struct dca_provider *dca);
+
+static inline void *dca_priv(struct dca_provider *dca)
+{
+	return (void *)dca + sizeof(struct dca_provider);
+}
+
+/* Requester API */
+int dca_add_requester(struct device *dev);
+int dca_remove_requester(struct device *dev);
+u8 dca_get_tag(int cpu);
+
+/* internal stuff */
+int __init dca_sysfs_init(void);
+void __exit dca_sysfs_exit(void);
+int dca_sysfs_add_provider(struct dca_provider *dca, struct device *dev);
+void dca_sysfs_remove_provider(struct dca_provider *dca);
+int dca_sysfs_add_req(struct dca_provider *dca, struct device *dev, int slot);
+void dca_sysfs_remove_req(struct dca_provider *dca, int slot);
+
+#endif /* DCA_H */
_

Patches currently in -mm which might be from shannon.nelson@intel.com are

i-oat-new-device-ids.patch
i-oat-rename-the-source-file.patch
i-oat-code-cleanup-from-checkpatch-output.patch
i-oat-split-pci-startup-from-dma-handling-code.patch
i-oat-add-support-for-msi-and-msi-x.patch
dca-add-direct-cache-access-driver.patch
i-oat-add-dca-services.patch
remove-unsafe-from-module-struct.patch
