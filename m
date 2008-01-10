From: akpm@linux-foundation.org
Subject: + memstick-initial-commit-for-sony-memorystick-support.patch added to -mm tree
Date: Thu, 10 Jan 2008 01:00:59 -0800
Message-ID: <200801100900.m0A90djg013966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43598 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752663AbYAJJAs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 04:00:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oakad@yahoo.com


The patch titled
     memstick: initial commit for Sony MemoryStick support
has been added to the -mm tree.  Its filename is
     memstick-initial-commit-for-sony-memorystick-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: initial commit for Sony MemoryStick support
From: Alex Dubov <oakad@yahoo.com>

Sony MemoryStick cards are used in many products manufactured by Sony. 
They are available both as storage and as IO expansion cards.  Currently,
only MemoryStick Pro storage cards are supported via TI FlashMedia
MemoryStick interface.

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                         |    7 
 drivers/Kconfig                     |    2 
 drivers/Makefile                    |    1 
 drivers/memstick/Kconfig            |   26 
 drivers/memstick/Makefile           |   11 
 drivers/memstick/core/Kconfig       |   26 
 drivers/memstick/core/Makefile      |   11 
 drivers/memstick/core/memstick.c    |  557 ++++++++++
 drivers/memstick/core/mspro_block.c | 1376 ++++++++++++++++++++++++++
 drivers/memstick/host/Kconfig       |   22 
 drivers/memstick/host/Makefile      |   10 
 drivers/memstick/host/tifm_ms.c     |  684 ++++++++++++
 drivers/misc/tifm_7xx1.c            |   17 
 drivers/misc/tifm_core.c            |    7 
 include/linux/memstick.h            |  289 +++++
 include/linux/tifm.h                |    4 
 16 files changed, 3050 insertions(+)

diff -puN drivers/Kconfig~memstick-initial-commit-for-sony-memorystick-support drivers/Kconfig
--- a/drivers/Kconfig~memstick-initial-commit-for-sony-memorystick-support
+++ a/drivers/Kconfig
@@ -76,6 +76,8 @@ source "drivers/usb/Kconfig"
 
 source "drivers/mmc/Kconfig"
 
+source "drivers/memstick/Kconfig"
+
 source "drivers/leds/Kconfig"
 
 source "drivers/infiniband/Kconfig"
diff -puN drivers/Makefile~memstick-initial-commit-for-sony-memorystick-support drivers/Makefile
--- a/drivers/Makefile~memstick-initial-commit-for-sony-memorystick-support
+++ a/drivers/Makefile
@@ -76,6 +76,7 @@ obj-$(CONFIG_LGUEST_GUEST)	+= lguest/
 obj-$(CONFIG_CPU_FREQ)		+= cpufreq/
 obj-$(CONFIG_CPU_IDLE)		+= cpuidle/
 obj-$(CONFIG_MMC)		+= mmc/
+obj-$(CONFIG_MEMSTICK)		+= memstick/
 obj-$(CONFIG_NEW_LEDS)		+= leds/
 obj-$(CONFIG_INFINIBAND)	+= infiniband/
 obj-$(CONFIG_SGI_SN)		+= sn/
diff -puN /dev/null drivers/memstick/core/Kconfig
--- /dev/null
+++ a/drivers/memstick/core/Kconfig
@@ -0,0 +1,26 @@
+#
+# MemoryStick core configuration
+#
+
+comment "MemoryStick drivers"
+
+config MEMSTICK_UNSAFE_RESUME
+        bool "Allow unsafe resume (DANGEROUS)"
+        help
+          If you say Y here, the MemoryStick layer will assume that all
+          cards stayed in their respective slots during the suspend. The
+          normal behaviour is to remove them at suspend and
+          redetecting them at resume. Breaking this assumption will
+          in most cases result in data corruption.
+
+          This option is usually just for embedded systems which use
+          a MemoryStick card for rootfs. Most people should say N here.
+
+config MSPRO_BLOCK
+	tristate "MemoryStick Pro block device driver"
+	depends on BLOCK
+	help
+	  Say Y here to enable the MemoryStick Pro block device driver
+	  support. This provides a block device driver, which you can use
+	  to mount the filesystem. Almost everyone wishing MemoryStick
+	  support should say Y or M here.
diff -puN /dev/null drivers/memstick/core/Makefile
--- /dev/null
+++ a/drivers/memstick/core/Makefile
@@ -0,0 +1,11 @@
+#
+# Makefile for the kernel MemoryStick core.
+#
+
+ifeq ($(CONFIG_MEMSTICK_DEBUG),y)
+	EXTRA_CFLAGS		+= -DDEBUG
+endif
+
+obj-$(CONFIG_MEMSTICK)		+= memstick.o
+
+obj-$(CONFIG_MSPRO_BLOCK)	+= mspro_block.o
diff -puN /dev/null drivers/memstick/core/memstick.c
--- /dev/null
+++ a/drivers/memstick/core/memstick.c
@@ -0,0 +1,557 @@
+/*
+ *  Sony MemoryStick support
+ *
+ *  Copyright (C) 2007 Alex Dubov <oakad@yahoo.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Special thanks to Carlos Corbacho for providing various MemoryStick cards
+ * that made this driver possible.
+ *
+ */
+
+#include <linux/tifm.h>
+#include <linux/memstick.h>
+#include <linux/idr.h>
+#include <linux/scatterlist.h>
+#include <linux/fs.h>
+
+#define DRIVER_NAME "memstick"
+#define DRIVER_VERSION "0.2"
+
+static unsigned int cmd_retries = 3;
+module_param(cmd_retries, uint, 0644);
+
+static struct workqueue_struct *workqueue;
+static DEFINE_IDR(memstick_host_idr);
+static DEFINE_SPINLOCK(memstick_host_lock);
+
+static int memstick_dev_match(struct memstick_dev *card,
+			      struct memstick_device_id *id)
+{
+	if (id->match_flags & MEMSTICK_MATCH_ALL) {
+		if ((id->type == card->id.type)
+		    && (id->category == card->id.category)
+		    && (id->class == card->id.class))
+			return 1;
+	}
+
+	return 0;
+}
+
+static int memstick_bus_match(struct device *dev, struct device_driver *drv)
+{
+	struct memstick_dev *card = container_of(dev, struct memstick_dev,
+						 dev);
+	struct memstick_driver *ms_drv = container_of(drv,
+						      struct memstick_driver,
+						      driver);
+	struct memstick_device_id *ids = ms_drv->id_table;
+
+	if (ids) {
+		while (ids->match_flags) {
+			if (memstick_dev_match(card, ids))
+				return 1;
+			++ids;
+		}
+	}
+	return 0;
+}
+
+static int memstick_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	struct memstick_dev *card = container_of(dev, struct memstick_dev,
+						  dev);
+
+	if (add_uevent_var(env, "MEMSTICK_TYPE=%02X", card->id.type))
+		return -ENOMEM;
+
+	if (add_uevent_var(env, "MEMSTICK_CATEGORY=%02X", card->id.category))
+		return -ENOMEM;
+
+	if (add_uevent_var(env, "MEMSTICK_CLASS=%02X", card->id.class))
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int memstick_device_probe(struct device *dev)
+{
+	struct memstick_dev *card = container_of(dev, struct memstick_dev,
+						 dev);
+	struct memstick_driver *drv = container_of(dev->driver,
+						   struct memstick_driver,
+						   driver);
+	int rc = -ENODEV;
+
+	get_device(dev);
+	if (dev->driver && drv->probe) {
+		rc = drv->probe(card);
+		if (!rc)
+			return 0;
+	}
+	put_device(dev);
+	return rc;
+}
+
+static int memstick_device_remove(struct device *dev)
+{
+	struct memstick_dev *card = container_of(dev, struct memstick_dev,
+						  dev);
+	struct memstick_driver *drv = container_of(dev->driver,
+						   struct memstick_driver,
+						   driver);
+
+	if (dev->driver && drv->remove) {
+		drv->remove(card);
+		card->dev.driver = NULL;
+	}
+
+	put_device(dev);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+
+static int memstick_device_suspend(struct device *dev, pm_message_t state)
+{
+	struct memstick_dev *card = container_of(dev, struct memstick_dev,
+						  dev);
+	struct memstick_driver *drv = container_of(dev->driver,
+						   struct memstick_driver,
+						   driver);
+
+	if (dev->driver && drv->suspend)
+		return drv->suspend(card, state);
+	return 0;
+}
+
+static int memstick_device_resume(struct device *dev)
+{
+	struct memstick_dev *card = container_of(dev, struct memstick_dev,
+						  dev);
+	struct memstick_driver *drv = container_of(dev->driver,
+						   struct memstick_driver,
+						   driver);
+
+	if (dev->driver && drv->resume)
+		return drv->resume(card);
+	return 0;
+}
+
+#else
+
+#define memstick_device_suspend NULL
+#define memstick_device_resume NULL
+
+#endif /* CONFIG_PM */
+
+#define MEMSTICK_ATTR(name, format)                                           \
+static ssize_t name##_show(struct device *dev, struct device_attribute *attr, \
+			    char *buf)                                        \
+{                                                                             \
+	struct memstick_dev *card = container_of(dev, struct memstick_dev,    \
+						 dev);                        \
+	return sprintf(buf, format, card->id.name);                           \
+}
+
+MEMSTICK_ATTR(type, "%02X");
+MEMSTICK_ATTR(category, "%02X");
+MEMSTICK_ATTR(class, "%02X");
+
+#define MEMSTICK_ATTR_RO(name) __ATTR(name, S_IRUGO, name##_show, NULL)
+
+static struct device_attribute memstick_dev_attrs[] = {
+	MEMSTICK_ATTR_RO(type),
+	MEMSTICK_ATTR_RO(category),
+	MEMSTICK_ATTR_RO(class),
+	__ATTR_NULL
+};
+
+static struct bus_type memstick_bus_type = {
+	.name           = "memstick",
+	.dev_attrs      = memstick_dev_attrs,
+	.match          = memstick_bus_match,
+	.uevent         = memstick_uevent,
+	.probe          = memstick_device_probe,
+	.remove         = memstick_device_remove,
+	.suspend        = memstick_device_suspend,
+	.resume         = memstick_device_resume
+};
+
+static void memstick_free(struct class_device *cdev)
+{
+	struct memstick_host *host = container_of(cdev, struct memstick_host,
+						  cdev);
+	kfree(host);
+}
+
+static struct class memstick_host_class = {
+	.name       = "memstick_host",
+	.release    = memstick_free
+};
+
+static void memstick_free_card(struct device *dev)
+{
+	struct memstick_dev *card = container_of(dev, struct memstick_dev,
+						 dev);
+	kfree(card);
+}
+
+static int memstick_dummy_check(struct memstick_dev *card)
+{
+	return 0;
+}
+
+void memstick_detect_change(struct memstick_host *host)
+{
+	queue_work(workqueue, &host->media_checker);
+}
+EXPORT_SYMBOL(memstick_detect_change);
+
+int memstick_next_req(struct memstick_host *host, struct memstick_request **mrq)
+{
+	int rc = -ENXIO;
+
+	if ((*mrq) && (*mrq)->error && host->retries) {
+		(*mrq)->error = rc;
+		host->retries--;
+		return 0;
+	}
+
+	if (host->card && host->card->next_request)
+		rc = host->card->next_request(host->card, mrq);
+
+	if (!rc)
+		host->retries = cmd_retries;
+	else
+		*mrq = NULL;
+
+	return rc;
+}
+EXPORT_SYMBOL(memstick_next_req);
+
+void memstick_new_req(struct memstick_host *host)
+{
+	host->retries = cmd_retries;
+	host->request(host);
+}
+EXPORT_SYMBOL(memstick_new_req);
+
+void memstick_init_req_sg(struct memstick_request *mrq, unsigned char tpc,
+			  struct scatterlist *sg)
+{
+	mrq->tpc = tpc;
+	if (tpc & 8)
+		mrq->data_dir = WRITE;
+	else
+		mrq->data_dir = READ;
+
+	mrq->sg = *sg;
+	mrq->io_type = MEMSTICK_IO_SG;
+
+	if (tpc == MS_TPC_SET_CMD || tpc == MS_TPC_EX_SET_CMD)
+		mrq->need_card_int = 1;
+	else
+		mrq->need_card_int = 0;
+
+	mrq->get_int_reg = 0;
+}
+EXPORT_SYMBOL(memstick_init_req_sg);
+
+void memstick_init_req(struct memstick_request *mrq, unsigned char tpc,
+		       void *buf, size_t length)
+{
+	mrq->tpc = tpc;
+	if (tpc & 8)
+		mrq->data_dir = WRITE;
+	else
+		mrq->data_dir = READ;
+
+	mrq->data_len = length > sizeof(mrq->data) ? sizeof(mrq->data) : length;
+	if (mrq->data_dir == WRITE)
+		memcpy(mrq->data, buf, mrq->data_len);
+
+	mrq->io_type = MEMSTICK_IO_VAL;
+
+	if (tpc == MS_TPC_SET_CMD || tpc == MS_TPC_EX_SET_CMD)
+		mrq->need_card_int = 1;
+	else
+		mrq->need_card_int = 0;
+
+	mrq->get_int_reg = 0;
+}
+EXPORT_SYMBOL(memstick_init_req);
+
+static int h_memstick_read_dev_id(struct memstick_dev *card,
+				  struct memstick_request **mrq)
+{
+	struct ms_id_register id_reg;
+
+	if (!(*mrq)) {
+		memstick_init_req(&card->current_mrq, MS_TPC_READ_REG, NULL,
+				  sizeof(struct ms_id_register));
+		*mrq = &card->current_mrq;
+		return 0;
+	} else {
+		if (!(*mrq)->error) {
+			memcpy(&id_reg, (*mrq)->data, sizeof(id_reg));
+			card->id = (struct memstick_device_id){
+				.match_flags = MEMSTICK_MATCH_ALL,
+				.type = id_reg.type,
+				.category = id_reg.category,
+				.class = id_reg.class
+			};
+		}
+		complete(&card->mrq_complete);
+		return -EAGAIN;
+	}
+}
+
+static int h_memstick_set_rw_addr(struct memstick_dev *card,
+				  struct memstick_request **mrq)
+{
+	if (!(*mrq)) {
+		memstick_init_req(&card->current_mrq, MS_TPC_SET_RW_REG_ADRS,
+				  (char *)&card->reg_addr,
+				  sizeof(card->reg_addr));
+		*mrq = &card->current_mrq;
+		return 0;
+	} else {
+		complete(&card->mrq_complete);
+		return -EAGAIN;
+	}
+}
+
+int memstick_set_rw_addr(struct memstick_dev *card)
+{
+	card->next_request = h_memstick_set_rw_addr;
+	memstick_new_req(card->host);
+	wait_for_completion(&card->mrq_complete);
+
+	return card->current_mrq.error;
+}
+EXPORT_SYMBOL(memstick_set_rw_addr);
+
+static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
+{
+	struct memstick_dev *card = kzalloc(sizeof(struct memstick_dev),
+					    GFP_KERNEL);
+	struct memstick_dev *old_card = host->card;
+	struct ms_id_register id_reg;
+
+	if (card) {
+		card->host = host;
+		snprintf(card->dev.bus_id, sizeof(card->dev.bus_id),
+			 "%s", host->cdev.class_id);
+		card->dev.parent = host->cdev.dev;
+		card->dev.bus = &memstick_bus_type;
+		card->dev.release = memstick_free_card;
+		card->check = memstick_dummy_check;
+
+		card->reg_addr = (struct ms_register_addr){
+			offsetof(struct ms_register, id),
+			sizeof(id_reg),
+			offsetof(struct ms_register, id),
+			sizeof(id_reg)
+		};
+
+		init_completion(&card->mrq_complete);
+
+		host->card = card;
+		if (memstick_set_rw_addr(card))
+			goto err_out;
+
+		card->next_request = h_memstick_read_dev_id;
+		memstick_new_req(host);
+		wait_for_completion(&card->mrq_complete);
+
+		if (card->current_mrq.error)
+			goto err_out;
+	}
+	host->card = old_card;
+	return card;
+err_out:
+	host->card = old_card;
+	kfree(card);
+	return NULL;
+}
+
+static void memstick_power_on(struct memstick_host *host)
+{
+	host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_ON);
+	host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_SERIAL);
+	msleep(1);
+}
+
+static void memstick_check(struct work_struct *work)
+{
+	struct memstick_host *host = container_of(work, struct memstick_host,
+						  media_checker);
+	struct memstick_dev *card;
+
+	dev_dbg(host->cdev.dev, "memstick_check started\n");
+	mutex_lock(&host->lock);
+	if (!host->card)
+		memstick_power_on(host);
+
+	card = memstick_alloc_card(host);
+
+	if (!card) {
+		if (host->card) {
+			device_unregister(&host->card->dev);
+			host->card = NULL;
+		}
+	} else {
+		dev_dbg(host->cdev.dev, "new card %02x, %02x, %02x\n",
+			card->id.type, card->id.category, card->id.class);
+		if (host->card) {
+			if (memstick_set_rw_addr(host->card)
+			    || !memstick_dev_match(host->card, &card->id)
+			    || !(host->card->check(host->card))) {
+				device_unregister(&host->card->dev);
+				host->card = NULL;
+			}
+		}
+
+		if (!host->card) {
+			host->card = card;
+			if (device_register(&card->dev)) {
+				kfree(host->card);
+				host->card = NULL;
+			}
+		} else
+			kfree(card);
+	}
+
+	if (!host->card)
+		host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_OFF);
+
+	mutex_unlock(&host->lock);
+	dev_dbg(host->cdev.dev, "memstick_check finished\n");
+}
+
+struct memstick_host *memstick_alloc_host(unsigned int extra,
+					  struct device *dev)
+{
+	struct memstick_host *host;
+
+	host = kzalloc(sizeof(struct memstick_host) + extra, GFP_KERNEL);
+	if (host) {
+		mutex_init(&host->lock);
+		INIT_WORK(&host->media_checker, memstick_check);
+		host->cdev.class = &memstick_host_class;
+		host->cdev.dev = dev;
+		class_device_initialize(&host->cdev);
+	}
+	return host;
+}
+EXPORT_SYMBOL(memstick_alloc_host);
+
+int memstick_add_host(struct memstick_host *host)
+{
+	int rc;
+
+	if (!idr_pre_get(&memstick_host_idr, GFP_KERNEL))
+		return -ENOMEM;
+
+	spin_lock(&memstick_host_lock);
+	rc = idr_get_new(&memstick_host_idr, host, &host->id);
+	spin_unlock(&memstick_host_lock);
+	if (rc)
+		return rc;
+
+	snprintf(host->cdev.class_id, BUS_ID_SIZE,
+		 "memstick%u", host->id);
+
+	rc = class_device_add(&host->cdev);
+	if (rc) {
+		spin_lock(&memstick_host_lock);
+		idr_remove(&memstick_host_idr, host->id);
+		spin_unlock(&memstick_host_lock);
+		return rc;
+	}
+
+	host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_OFF);
+	memstick_detect_change(host);
+	return 0;
+}
+EXPORT_SYMBOL(memstick_add_host);
+
+void memstick_remove_host(struct memstick_host *host)
+{
+	flush_workqueue(workqueue);
+	mutex_lock(&host->lock);
+	if (host->card)
+		device_unregister(&host->card->dev);
+	host->card = NULL;
+	host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_OFF);
+	mutex_unlock(&host->lock);
+
+	spin_lock(&memstick_host_lock);
+	idr_remove(&memstick_host_idr, host->id);
+	spin_unlock(&memstick_host_lock);
+	class_device_del(&host->cdev);
+}
+EXPORT_SYMBOL(memstick_remove_host);
+
+void memstick_free_host(struct memstick_host *host)
+{
+	mutex_destroy(&host->lock);
+	class_device_put(&host->cdev);
+}
+EXPORT_SYMBOL(memstick_free_host);
+
+int memstick_register_driver(struct memstick_driver *drv)
+{
+	drv->driver.bus = &memstick_bus_type;
+
+	return driver_register(&drv->driver);
+}
+EXPORT_SYMBOL(memstick_register_driver);
+
+void memstick_unregister_driver(struct memstick_driver *drv)
+{
+	driver_unregister(&drv->driver);
+}
+EXPORT_SYMBOL(memstick_unregister_driver);
+
+
+static int __init memstick_init(void)
+{
+	int rc;
+
+	workqueue = create_freezeable_workqueue("kmemstick");
+	if (!workqueue)
+		return -ENOMEM;
+
+	rc = bus_register(&memstick_bus_type);
+	if (!rc)
+		rc = class_register(&memstick_host_class);
+
+	if (!rc)
+		return 0;
+
+	bus_unregister(&memstick_bus_type);
+	destroy_workqueue(workqueue);
+
+	return rc;
+}
+
+static void __exit memstick_exit(void)
+{
+	class_unregister(&memstick_host_class);
+	bus_unregister(&memstick_bus_type);
+	destroy_workqueue(workqueue);
+	idr_destroy(&memstick_host_idr);
+}
+
+module_init(memstick_init);
+module_exit(memstick_exit);
+
+MODULE_AUTHOR("Alex Dubov");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Sony MemoryStick core driver");
+MODULE_VERSION(DRIVER_VERSION);
diff -puN /dev/null drivers/memstick/core/mspro_block.c
--- /dev/null
+++ a/drivers/memstick/core/mspro_block.c
@@ -0,0 +1,1376 @@
+/*
+ *  Sony MemoryStick Pro storage support
+ *
+ *  Copyright (C) 2007 Alex Dubov <oakad@yahoo.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Special thanks to Carlos Corbacho for providing various MemoryStick cards
+ * that made this driver possible.
+ *
+ */
+
+#include <linux/blkdev.h>
+#include <linux/scatterlist.h>
+#include <linux/idr.h>
+#include <linux/hdreg.h>
+#include <linux/kthread.h>
+#include <linux/memstick.h>
+
+#define DRIVER_NAME "mspro_block"
+#define DRIVER_VERSION "0.2"
+
+static int major;
+module_param(major, int, 0644);
+
+#define MSPRO_BLOCK_MAX_SEGS  32
+#define MSPRO_BLOCK_MAX_PAGES ((2 << 16) - 1)
+
+#define MSPRO_BLOCK_SIGNATURE        0xa5c3
+#define MSPRO_BLOCK_MAX_ATTRIBUTES   41
+
+enum {
+	MSPRO_BLOCK_ID_SYSINFO         = 0x10,
+	MSPRO_BLOCK_ID_MODELNAME       = 0x15,
+	MSPRO_BLOCK_ID_MBR             = 0x20,
+	MSPRO_BLOCK_ID_PBR16           = 0x21,
+	MSPRO_BLOCK_ID_PBR32           = 0x22,
+	MSPRO_BLOCK_ID_SPECFILEVALUES1 = 0x25,
+	MSPRO_BLOCK_ID_SPECFILEVALUES2 = 0x26,
+	MSPRO_BLOCK_ID_DEVINFO         = 0x30
+};
+
+struct mspro_sys_attr {
+	size_t                  size;
+	unsigned char           *data;
+	unsigned char           id;
+	char                    name[32];
+	struct device_attribute sys_attr;
+};
+
+struct mspro_attr_entry {
+	unsigned int  address;
+	unsigned int  size;
+	unsigned char id;
+	unsigned char reserved[3];
+} __attribute__((packed));
+
+struct mspro_attribute {
+	unsigned short          signature;
+	unsigned short          version;
+	unsigned char           count;
+	unsigned char           reserved[11];
+	struct mspro_attr_entry entries[];
+} __attribute__((packed));
+
+struct mspro_sys_info {
+	unsigned char  class;
+	unsigned char  reserved0;
+	unsigned short block_size;
+	unsigned short block_count;
+	unsigned short user_block_count;
+	unsigned short page_size;
+	unsigned char  reserved1[2];
+	unsigned char  assembly_date[8];
+	unsigned int   serial_number;
+	unsigned char  assembly_maker_code;
+	unsigned char  assembly_model_code[3];
+	unsigned short memory_maker_code;
+	unsigned short memory_model_code;
+	unsigned char  reserved2[4];
+	unsigned char  vcc;
+	unsigned char  vpp;
+	unsigned short controller_number;
+	unsigned short controller_function;
+	unsigned short start_sector;
+	unsigned short unit_size;
+	unsigned char  ms_sub_class;
+	unsigned char  reserved3[4];
+	unsigned char  interface_type;
+	unsigned short controller_code;
+	unsigned char  format_type;
+	unsigned char  reserved4;
+	unsigned char  device_type;
+	unsigned char  reserved5[7];
+	unsigned char  mspro_id[16];
+	unsigned char  reserved6[16];
+} __attribute__((packed));
+
+struct mspro_mbr {
+	unsigned char boot_partition;
+	unsigned char start_head;
+	unsigned char start_sector;
+	unsigned char start_cylinder;
+	unsigned char partition_type;
+	unsigned char end_head;
+	unsigned char end_sector;
+	unsigned char end_cylinder;
+	unsigned int  start_sectors;
+	unsigned int  sectors_per_partition;
+} __attribute__((packed));
+
+struct mspro_devinfo {
+	unsigned short cylinders;
+	unsigned short heads;
+	unsigned short bytes_per_track;
+	unsigned short bytes_per_sector;
+	unsigned short sectors_per_track;
+	unsigned char  reserved[6];
+} __attribute__((packed));
+
+struct mspro_block_data {
+	struct memstick_dev   *card;
+	unsigned int          usage_count;
+	struct gendisk        *disk;
+	struct request_queue  *queue;
+	spinlock_t            q_lock;
+	wait_queue_head_t     q_wait;
+	struct task_struct    *q_thread;
+
+	unsigned short        page_size;
+	unsigned short        cylinders;
+	unsigned short        heads;
+	unsigned short        sectors_per_track;
+
+	unsigned char         system;
+	unsigned char         read_only:1,
+			      active:1,
+			      has_request:1,
+			      data_dir:1;
+	unsigned char         transfer_cmd;
+
+	int                   (*mrq_handler)(struct memstick_dev *card,
+					     struct memstick_request **mrq);
+
+	unsigned char         attr_count;
+	struct mspro_sys_attr *attributes;
+
+	struct scatterlist    req_sg[MSPRO_BLOCK_MAX_SEGS];
+	unsigned int          seg_count;
+	unsigned int          current_seg;
+	unsigned short        current_page;
+};
+
+static DEFINE_IDR(mspro_block_disk_idr);
+static DEFINE_MUTEX(mspro_block_disk_lock);
+
+/*** Block device ***/
+
+static int mspro_block_bd_open(struct inode *inode, struct file *filp)
+{
+	struct gendisk *disk = inode->i_bdev->bd_disk;
+	struct mspro_block_data *msb = disk->private_data;
+	int rc = -ENXIO;
+
+	mutex_lock(&mspro_block_disk_lock);
+
+	if (msb && msb->card) {
+		msb->usage_count++;
+		if ((filp->f_mode & FMODE_WRITE) && msb->read_only)
+			rc = -EROFS;
+		else
+			rc = 0;
+	}
+
+	mutex_unlock(&mspro_block_disk_lock);
+
+	return rc;
+}
+
+
+static int mspro_block_disk_release(struct gendisk *disk)
+{
+	struct mspro_block_data *msb = disk->private_data;
+	int disk_id = disk->first_minor >> MEMSTICK_PART_SHIFT;
+
+	mutex_lock(&mspro_block_disk_lock);
+
+	if (msb->usage_count) {
+		msb->usage_count--;
+		if (!msb->usage_count) {
+			kfree(msb);
+			disk->private_data = NULL;
+			idr_remove(&mspro_block_disk_idr, disk_id);
+			put_disk(disk);
+		}
+	}
+
+	mutex_unlock(&mspro_block_disk_lock);
+
+	return 0;
+}
+
+static int mspro_block_bd_release(struct inode *inode, struct file *filp)
+{
+	struct gendisk *disk = inode->i_bdev->bd_disk;
+	return mspro_block_disk_release(disk);
+}
+
+static int mspro_block_bd_getgeo(struct block_device *bdev,
+				 struct hd_geometry *geo)
+{
+	struct mspro_block_data *msb = bdev->bd_disk->private_data;
+
+	geo->heads = msb->heads;
+	geo->sectors = msb->sectors_per_track;
+	geo->cylinders = msb->cylinders;
+
+	return 0;
+}
+
+static struct block_device_operations ms_block_bdops = {
+	.open    = mspro_block_bd_open,
+	.release = mspro_block_bd_release,
+	.getgeo  = mspro_block_bd_getgeo,
+	.owner   = THIS_MODULE
+};
+
+/*** Information ***/
+
+static const char *mspro_block_attr_name(unsigned char tag)
+{
+	switch (tag) {
+	case MSPRO_BLOCK_ID_SYSINFO:
+		return "attr_sysinfo";
+	case MSPRO_BLOCK_ID_MODELNAME:
+		return "attr_modelname";
+	case MSPRO_BLOCK_ID_MBR:
+		return "attr_mbr";
+	case MSPRO_BLOCK_ID_PBR16:
+		return "attr_pbr16";
+	case MSPRO_BLOCK_ID_PBR32:
+		return "attr_pbr32";
+	case MSPRO_BLOCK_ID_SPECFILEVALUES1:
+		return "attr_specfilevalues1";
+	case MSPRO_BLOCK_ID_SPECFILEVALUES2:
+		return "attr_specfilevalues2";
+	case MSPRO_BLOCK_ID_DEVINFO:
+		return "attr_devinfo";
+	default:
+		return NULL;
+	};
+}
+
+typedef ssize_t (*sysfs_show_t)(struct device *dev,
+				struct device_attribute *attr,
+				char *buffer);
+
+static ssize_t mspro_block_attr_show_default(struct device *dev,
+					     struct device_attribute *attr,
+					     char *buffer)
+{
+	struct mspro_sys_attr *x_attr = container_of(attr,
+						     struct mspro_sys_attr,
+						     sys_attr);
+
+	ssize_t cnt, rc = 0;
+
+	for (cnt = 0; cnt < x_attr->size; cnt++) {
+		if (cnt && !(cnt % 16)) {
+			if (PAGE_SIZE - rc)
+				buffer[rc++] = '\n';
+		}
+
+		rc += snprintf(buffer + rc, PAGE_SIZE - rc, "%02x ",
+			       x_attr->data[cnt]);
+	}
+	return rc;
+}
+
+static ssize_t mspro_block_attr_show_sysinfo(struct device *dev,
+					     struct device_attribute *attr,
+					     char *buffer)
+{
+	struct mspro_sys_attr *x_attr = container_of(attr,
+						     struct mspro_sys_attr,
+						     sys_attr);
+	struct mspro_sys_info *x_sys = (struct mspro_sys_info *)x_attr->data;
+	ssize_t rc = 0;
+
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "class: %x\n",
+		       x_sys->class);
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "block size: %x\n",
+		       be16_to_cpu(x_sys->block_size));
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "block count: %x\n",
+		       be16_to_cpu(x_sys->block_count));
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "user block count: %x\n",
+		       be16_to_cpu(x_sys->user_block_count));
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "page size: %x\n",
+		       be16_to_cpu(x_sys->page_size));
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "assembly date: "
+		       "%d %04u-%02u-%02u %02u:%02u:%02u\n",
+		       x_sys->assembly_date[0],
+		       be16_to_cpu(*(unsigned short *)&x_sys->assembly_date[1]),
+		       x_sys->assembly_date[3], x_sys->assembly_date[4],
+		       x_sys->assembly_date[5], x_sys->assembly_date[6],
+		       x_sys->assembly_date[7]);
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "serial number: %x\n",
+		       be32_to_cpu(x_sys->serial_number));
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "assembly maker code: %x\n",
+		       x_sys->assembly_maker_code);
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "assembly model code: "
+		       "%02x%02x%02x\n", x_sys->assembly_model_code[0],
+		       x_sys->assembly_model_code[1],
+		       x_sys->assembly_model_code[2]);
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "memory maker code: %x\n",
+		       be16_to_cpu(x_sys->memory_maker_code));
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "memory model code: %x\n",
+		       be16_to_cpu(x_sys->memory_model_code));
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "vcc: %x\n",
+		       x_sys->vcc);
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "vpp: %x\n",
+		       x_sys->vpp);
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "controller number: %x\n",
+		       be16_to_cpu(x_sys->controller_number));
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "controller function: %x\n",
+		       be16_to_cpu(x_sys->controller_function));
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "start sector: %x\n",
+		       be16_to_cpu(x_sys->start_sector));
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "unit size: %x\n",
+		       be16_to_cpu(x_sys->unit_size));
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "sub class: %x\n",
+		       x_sys->ms_sub_class);
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "interface type: %x\n",
+		       x_sys->interface_type);
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "controller code: %x\n",
+		       be16_to_cpu(x_sys->controller_code));
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "format type: %x\n",
+		       x_sys->format_type);
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "device type: %x\n",
+		       x_sys->device_type);
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "mspro id: %s\n",
+		       x_sys->mspro_id);
+	return rc;
+}
+
+static ssize_t mspro_block_attr_show_modelname(struct device *dev,
+					       struct device_attribute *attr,
+					       char *buffer)
+{
+	struct mspro_sys_attr *x_attr = container_of(attr,
+						     struct mspro_sys_attr,
+						     sys_attr);
+
+	return snprintf(buffer, PAGE_SIZE, "%s", x_attr->data);
+}
+
+static ssize_t mspro_block_attr_show_mbr(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buffer)
+{
+	struct mspro_sys_attr *x_attr = container_of(attr,
+						     struct mspro_sys_attr,
+						     sys_attr);
+	struct mspro_mbr *x_mbr = (struct mspro_mbr *)x_attr->data;
+	ssize_t rc = 0;
+
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "boot partition: %x\n",
+		       x_mbr->boot_partition);
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "start head: %x\n",
+		       x_mbr->start_head);
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "start sector: %x\n",
+		       x_mbr->start_sector);
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "start cylinder: %x\n",
+		       x_mbr->start_cylinder);
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "partition type: %x\n",
+		       x_mbr->partition_type);
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "end head: %x\n",
+		       x_mbr->end_head);
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "end sector: %x\n",
+		       x_mbr->end_sector);
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "end cylinder: %x\n",
+		       x_mbr->end_cylinder);
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "start sectors: %x\n",
+		       x_mbr->start_sectors);
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc,
+		       "sectors per partition: %x\n",
+		       x_mbr->sectors_per_partition);
+	return rc;
+}
+
+static ssize_t mspro_block_attr_show_devinfo(struct device *dev,
+					     struct device_attribute *attr,
+					     char *buffer)
+{
+	struct mspro_sys_attr *x_attr = container_of(attr,
+						     struct mspro_sys_attr,
+						     sys_attr);
+	struct mspro_devinfo *x_devinfo = (struct mspro_devinfo *)x_attr->data;
+	ssize_t rc = 0;
+
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "cylinders: %x\n",
+		       be16_to_cpu(x_devinfo->cylinders));
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "heads: %x\n",
+		       be16_to_cpu(x_devinfo->heads));
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "bytes per track: %x\n",
+		       be16_to_cpu(x_devinfo->bytes_per_track));
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "bytes per sector: %x\n",
+		       be16_to_cpu(x_devinfo->bytes_per_sector));
+	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "sectors per track: %x\n",
+		       be16_to_cpu(x_devinfo->sectors_per_track));
+	return rc;
+}
+
+static sysfs_show_t mspro_block_attr_show(unsigned char tag)
+{
+	switch (tag) {
+	case MSPRO_BLOCK_ID_SYSINFO:
+		return mspro_block_attr_show_sysinfo;
+	case MSPRO_BLOCK_ID_MODELNAME:
+		return mspro_block_attr_show_modelname;
+	case MSPRO_BLOCK_ID_MBR:
+		return mspro_block_attr_show_mbr;
+	case MSPRO_BLOCK_ID_DEVINFO:
+		return mspro_block_attr_show_devinfo;
+	default:
+		return mspro_block_attr_show_default;
+	}
+}
+
+static int mspro_block_sysfs_register(struct memstick_dev *card)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	int cnt, rc = 0;
+
+	for (cnt = 0; cnt < msb->attr_count; cnt++) {
+		rc = device_create_file(&card->dev,
+					&msb->attributes[cnt].sys_attr);
+
+		if (rc) {
+			if (cnt) {
+				for (cnt--; cnt >= 0; cnt--)
+					device_remove_file(&card->dev,
+							   &msb->attributes[cnt]
+								.sys_attr);
+			}
+			break;
+		}
+	}
+	return rc;
+}
+
+static void mspro_block_sysfs_unregister(struct memstick_dev *card)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	int cnt;
+
+	for (cnt = 0; cnt < msb->attr_count; cnt++)
+		device_remove_file(&card->dev, &msb->attributes[cnt].sys_attr);
+}
+
+/*** Protocol handlers ***/
+
+static int h_mspro_block_req_init(struct memstick_dev *card,
+				  struct memstick_request **mrq)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+
+	*mrq = &card->current_mrq;
+	card->next_request = msb->mrq_handler;
+	return 0;
+}
+
+static int h_mspro_block_default(struct memstick_dev *card,
+				 struct memstick_request **mrq)
+{
+	complete(&card->mrq_complete);
+	if (!(*mrq)->error)
+		return -EAGAIN;
+	else
+		return (*mrq)->error;
+}
+
+static int h_mspro_block_get_ro(struct memstick_dev *card,
+				struct memstick_request **mrq)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+
+	if ((*mrq)->error) {
+		complete(&card->mrq_complete);
+		return (*mrq)->error;
+	}
+
+	if ((*mrq)->data[offsetof(struct ms_status_register, status0)]
+	    & MEMSTICK_STATUS0_WP)
+		msb->read_only = 1;
+	else
+		msb->read_only = 0;
+
+	complete(&card->mrq_complete);
+	return -EAGAIN;
+}
+
+static int h_mspro_block_wait_for_ced(struct memstick_dev *card,
+				      struct memstick_request **mrq)
+{
+	if ((*mrq)->error) {
+		complete(&card->mrq_complete);
+		return (*mrq)->error;
+	}
+
+	dev_dbg(&card->dev, "wait for ced: value %x\n", (*mrq)->data[0]);
+
+	if ((*mrq)->data[0] & (MEMSTICK_INT_CMDNAK | MEMSTICK_INT_ERR)) {
+		card->current_mrq.error = -EFAULT;
+		complete(&card->mrq_complete);
+		return card->current_mrq.error;
+	}
+
+	if (!((*mrq)->data[0] & MEMSTICK_INT_CED))
+		return 0;
+	else {
+		card->current_mrq.error = 0;
+		complete(&card->mrq_complete);
+		return -EAGAIN;
+	}
+}
+
+static int h_mspro_block_transfer_data(struct memstick_dev *card,
+				       struct memstick_request **mrq)
+{
+	struct memstick_host *host = card->host;
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	unsigned char t_val = 0;
+	struct scatterlist t_sg = { 0 };
+	size_t t_offset;
+
+	if ((*mrq)->error) {
+		complete(&card->mrq_complete);
+		return (*mrq)->error;
+	}
+
+	switch ((*mrq)->tpc) {
+	case MS_TPC_WRITE_REG:
+		memstick_init_req(*mrq, MS_TPC_SET_CMD, &msb->transfer_cmd, 1);
+		(*mrq)->get_int_reg = 1;
+		return 0;
+	case MS_TPC_SET_CMD:
+		t_val = (*mrq)->int_reg;
+		memstick_init_req(*mrq, MS_TPC_GET_INT, NULL, 1);
+		if (host->caps & MEMSTICK_CAP_AUTO_GET_INT)
+			goto has_int_reg;
+		return 0;
+	case MS_TPC_GET_INT:
+		t_val = (*mrq)->data[0];
+has_int_reg:
+		if (t_val & (MEMSTICK_INT_CMDNAK | MEMSTICK_INT_ERR)) {
+			t_val = MSPRO_CMD_STOP;
+			memstick_init_req(*mrq, MS_TPC_SET_CMD, &t_val, 1);
+			card->next_request = h_mspro_block_default;
+			return 0;
+		}
+
+		if (msb->current_page
+		    == (msb->req_sg[msb->current_seg].length
+			/ msb->page_size)) {
+			msb->current_page = 0;
+			msb->current_seg++;
+
+			if (msb->current_seg == msb->seg_count) {
+				if (t_val & MEMSTICK_INT_CED) {
+					complete(&card->mrq_complete);
+					return -EAGAIN;
+				} else {
+					card->next_request
+						= h_mspro_block_wait_for_ced;
+					memstick_init_req(*mrq, MS_TPC_GET_INT,
+							  NULL, 1);
+					return 0;
+				}
+			}
+		}
+
+		if (!(t_val & MEMSTICK_INT_BREQ)) {
+			memstick_init_req(*mrq, MS_TPC_GET_INT, NULL, 1);
+			return 0;
+		}
+
+		t_offset = msb->req_sg[msb->current_seg].offset;
+		t_offset += msb->current_page * msb->page_size;
+
+		sg_set_page(&t_sg,
+			    nth_page(sg_page(&(msb->req_sg[msb->current_seg])),
+				     t_offset >> PAGE_SHIFT),
+			    msb->page_size, offset_in_page(t_offset));
+
+		memstick_init_req_sg(*mrq, msb->data_dir == READ
+					   ? MS_TPC_READ_LONG_DATA
+					   : MS_TPC_WRITE_LONG_DATA,
+				     &t_sg);
+		(*mrq)->get_int_reg = 1;
+		return 0;
+	case MS_TPC_READ_LONG_DATA:
+	case MS_TPC_WRITE_LONG_DATA:
+		msb->current_page++;
+		if (host->caps & MEMSTICK_CAP_AUTO_GET_INT) {
+			t_val = (*mrq)->int_reg;
+			goto has_int_reg;
+		} else {
+			memstick_init_req(*mrq, MS_TPC_GET_INT, NULL, 1);
+			return 0;
+		}
+
+	default:
+		BUG();
+	}
+}
+
+/*** Data transfer ***/
+
+static void mspro_block_process_request(struct memstick_dev *card,
+					struct request *req)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	struct mspro_param_register param;
+	int rc, chunk, cnt;
+	unsigned short page_count;
+	sector_t t_sec;
+	unsigned long flags;
+
+	do {
+		page_count = 0;
+		msb->current_seg = 0;
+		msb->seg_count = blk_rq_map_sg(req->q, req, msb->req_sg);
+
+		if (msb->seg_count) {
+			msb->current_page = 0;
+			for (rc = 0; rc < msb->seg_count; rc++)
+				page_count += msb->req_sg[rc].length
+					      / msb->page_size;
+
+			t_sec = req->sector;
+			sector_div(t_sec, msb->page_size >> 9);
+			param = (struct mspro_param_register) {
+				.system = msb->system,
+				.data_count = cpu_to_be16(page_count),
+				.data_address = cpu_to_be32((uint32_t)t_sec),
+				.cmd_param = 0
+			};
+
+			msb->data_dir = rq_data_dir(req);
+			msb->transfer_cmd = msb->data_dir == READ
+					    ? MSPRO_CMD_READ_DATA
+					    : MSPRO_CMD_WRITE_DATA;
+
+			dev_dbg(&card->dev, "data transfer: cmd %x, "
+				"lba %x, count %x\n", msb->transfer_cmd,
+				be32_to_cpu(param.data_address),
+				page_count);
+
+			card->next_request = h_mspro_block_req_init;
+			msb->mrq_handler = h_mspro_block_transfer_data;
+			memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG,
+					  &param, sizeof(param));
+			memstick_new_req(card->host);
+			wait_for_completion(&card->mrq_complete);
+			rc = card->current_mrq.error;
+
+			if (rc || (card->current_mrq.tpc == MSPRO_CMD_STOP)) {
+				for (cnt = 0; cnt < msb->current_seg; cnt++)
+					page_count += msb->req_sg[cnt].length
+						      / msb->page_size;
+
+				if (msb->current_page)
+					page_count += msb->current_page - 1;
+
+				if (page_count && (msb->data_dir == READ))
+					rc = msb->page_size * page_count;
+				else
+					rc = -EIO;
+			} else
+				rc = msb->page_size * page_count;
+		} else
+			rc = -EFAULT;
+
+		spin_lock_irqsave(&msb->q_lock, flags);
+		if (rc >= 0)
+			chunk = end_that_request_chunk(req, 1, rc);
+		else
+			chunk = end_that_request_first(req, rc,
+						       req->current_nr_sectors);
+
+		dev_dbg(&card->dev, "end chunk %d, %d\n", rc, chunk);
+		if (!chunk) {
+			add_disk_randomness(req->rq_disk);
+			blkdev_dequeue_request(req);
+			end_that_request_last(req, rc > 0 ? 1 : rc);
+		}
+		spin_unlock_irqrestore(&msb->q_lock, flags);
+	} while (chunk);
+
+}
+
+static int mspro_block_has_request(struct mspro_block_data *msb)
+{
+	int rc = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&msb->q_lock, flags);
+	if (kthread_should_stop() || msb->has_request)
+		rc = 1;
+	spin_unlock_irqrestore(&msb->q_lock, flags);
+	return rc;
+}
+
+static int mspro_block_queue_thread(void *data)
+{
+	struct memstick_dev *card = data;
+	struct memstick_host *host = card->host;
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	struct request *req;
+	unsigned long flags;
+
+	while (1) {
+		wait_event(msb->q_wait, mspro_block_has_request(msb));
+		dev_dbg(&card->dev, "thread iter\n");
+
+		spin_lock_irqsave(&msb->q_lock, flags);
+		req = elv_next_request(msb->queue);
+		dev_dbg(&card->dev, "next req %p\n", req);
+		if (!req) {
+			msb->has_request = 0;
+			if (kthread_should_stop()) {
+				spin_unlock_irqrestore(&msb->q_lock, flags);
+				break;
+			}
+		} else
+			msb->has_request = 1;
+		spin_unlock_irqrestore(&msb->q_lock, flags);
+
+		if (req) {
+			mutex_lock(&host->lock);
+			mspro_block_process_request(card, req);
+			mutex_unlock(&host->lock);
+		}
+	}
+	dev_dbg(&card->dev, "thread finished\n");
+	return 0;
+}
+
+static void mspro_block_request(struct request_queue *q)
+{
+	struct memstick_dev *card = q->queuedata;
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	struct request *req = NULL;
+
+	if (!msb->q_thread) {
+		for (req = elv_next_request(q); req;
+		     req = elv_next_request(q)) {
+			while (end_that_request_chunk(req, -ENODEV,
+						      req->current_nr_sectors
+						      << 9)) {}
+			end_that_request_last(req, -ENODEV);
+		}
+	} else {
+		msb->has_request = 1;
+		wake_up_all(&msb->q_wait);
+	}
+}
+
+/*** Initialization ***/
+
+static int mspro_block_wait_for_ced(struct memstick_dev *card)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+
+	card->next_request = h_mspro_block_req_init;
+	msb->mrq_handler = h_mspro_block_wait_for_ced;
+	memstick_init_req(&card->current_mrq, MS_TPC_GET_INT, NULL, 1);
+	memstick_new_req(card->host);
+	wait_for_completion(&card->mrq_complete);
+	return card->current_mrq.error;
+}
+
+static int mspro_block_switch_to_parallel(struct memstick_dev *card)
+{
+	struct memstick_host *host = card->host;
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	struct mspro_param_register param = {
+		.system = 0,
+		.data_count = 0,
+		.data_address = 0,
+		.cmd_param = 0
+	};
+
+	card->next_request = h_mspro_block_req_init;
+	msb->mrq_handler = h_mspro_block_default;
+	memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG, &param,
+			  sizeof(param));
+	memstick_new_req(host);
+	wait_for_completion(&card->mrq_complete);
+	if (card->current_mrq.error)
+		return card->current_mrq.error;
+
+	msb->system = 0;
+	host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_PARALLEL);
+
+	card->next_request = h_mspro_block_req_init;
+	msb->mrq_handler = h_mspro_block_default;
+	memstick_init_req(&card->current_mrq, MS_TPC_GET_INT, NULL, 1);
+	memstick_new_req(card->host);
+	wait_for_completion(&card->mrq_complete);
+
+	if (card->current_mrq.error) {
+		msb->system = 0x80;
+		host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_SERIAL);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int mspro_block_read_attributes(struct memstick_dev *card)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	struct mspro_param_register param = {
+		.system = msb->system,
+		.data_count = cpu_to_be16(1),
+		.data_address = 0,
+		.cmd_param = 0
+	};
+	struct mspro_attribute *attr = NULL;
+	unsigned char *buffer = NULL;
+	int cnt, rc;
+	unsigned int addr;
+	unsigned short page_count;
+
+	attr = kmalloc(msb->page_size, GFP_KERNEL);
+	if (!attr)
+		return -ENOMEM;
+
+	sg_init_one(&msb->req_sg[0], attr, msb->page_size);
+	msb->seg_count = 1;
+	msb->current_seg = 0;
+	msb->current_page = 0;
+	msb->data_dir = READ;
+	msb->transfer_cmd = MSPRO_CMD_READ_ATRB;
+
+	card->next_request = h_mspro_block_req_init;
+	msb->mrq_handler = h_mspro_block_transfer_data;
+	memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG, &param,
+			  sizeof(param));
+	memstick_new_req(card->host);
+	wait_for_completion(&card->mrq_complete);
+	if (card->current_mrq.error) {
+		rc = card->current_mrq.error;
+		goto out_free_attr;
+	}
+
+	if (be16_to_cpu(attr->signature) != MSPRO_BLOCK_SIGNATURE) {
+		printk(KERN_ERR "%s: unrecognized device signature %x\n",
+		       card->dev.bus_id, be16_to_cpu(attr->signature));
+		rc = -ENODEV;
+		goto out_free_attr;
+	}
+
+	if (attr->count > MSPRO_BLOCK_MAX_ATTRIBUTES) {
+		printk(KERN_WARNING "%s: way too many attribute entries\n",
+		       card->dev.bus_id);
+		msb->attr_count = MSPRO_BLOCK_MAX_ATTRIBUTES;
+	} else
+		msb->attr_count = attr->count;
+
+	msb->attributes = kzalloc(msb->attr_count
+				  * sizeof(struct mspro_sys_attr),
+				  GFP_KERNEL);
+	if (!msb->attributes) {
+		msb->attr_count = 0;
+		rc = -ENOMEM;
+		goto out_free_attr;
+	}
+
+	buffer = kmalloc(msb->page_size, GFP_KERNEL);
+	if (!buffer) {
+		rc = -ENOMEM;
+		goto out_free_attr;
+	}
+	memcpy(buffer, (char *)attr, msb->page_size);
+	page_count = 1;
+
+	for (cnt = 0; cnt < msb->attr_count; cnt++) {
+		addr = be32_to_cpu(attr->entries[cnt].address);
+		rc = be32_to_cpu(attr->entries[cnt].size);
+		dev_dbg(&card->dev, "adding attribute %d: id %x, address %x, "
+			"size %x\n", cnt, attr->entries[cnt].id, addr, rc);
+		msb->attributes[cnt].id = attr->entries[cnt].id;
+		if (mspro_block_attr_name(attr->entries[cnt].id))
+			snprintf(msb->attributes[cnt].name,
+				 sizeof(msb->attributes[cnt].name), "%s",
+				 mspro_block_attr_name(attr->entries[cnt].id));
+		else
+			snprintf(msb->attributes[cnt].name,
+				 sizeof(msb->attributes[cnt].name),
+				 "attr_x%02x",
+				 attr->entries[cnt].id);
+
+		msb->attributes[cnt].sys_attr
+			= (struct device_attribute){
+				.attr = {
+					.name = msb->attributes[cnt].name,
+					.mode = S_IRUGO,
+					.owner = THIS_MODULE
+				},
+				.show = mspro_block_attr_show(
+						msb->attributes[cnt].id),
+				.store = NULL
+			};
+
+		if (!rc)
+			continue;
+
+		msb->attributes[cnt].size = rc;
+		msb->attributes[cnt].data = kmalloc(rc, GFP_KERNEL);
+		if (!msb->attributes[cnt].data) {
+			rc = -ENOMEM;
+			goto out_free_buffer;
+		}
+
+		if (((addr / msb->page_size)
+		     == be32_to_cpu(param.data_address))
+		    && (((addr + rc - 1) / msb->page_size)
+			== be32_to_cpu(param.data_address))) {
+			memcpy(msb->attributes[cnt].data,
+			       buffer + addr % msb->page_size,
+			       rc);
+			continue;
+		}
+
+		if (page_count <= (rc / msb->page_size)) {
+			kfree(buffer);
+			page_count = (rc / msb->page_size) + 1;
+			buffer = kmalloc(page_count * msb->page_size,
+					 GFP_KERNEL);
+			if (!buffer) {
+				rc = -ENOMEM;
+				goto out_free_attr;
+			}
+		}
+
+		param = (struct mspro_param_register){
+			.system = msb->system,
+			.data_count = cpu_to_be16((rc / msb->page_size) + 1),
+			.data_address = cpu_to_be32(addr / msb->page_size),
+			.cmd_param = 0
+		};
+
+		sg_init_one(&msb->req_sg[0], buffer,
+			    be16_to_cpu(param.data_count) * msb->page_size);
+		msb->seg_count = 1;
+		msb->current_seg = 0;
+		msb->current_page = 0;
+		msb->data_dir = READ;
+		msb->transfer_cmd = MSPRO_CMD_READ_ATRB;
+
+		dev_dbg(&card->dev, "reading attribute pages %x, %x\n",
+			be32_to_cpu(param.data_address),
+			be16_to_cpu(param.data_count));
+
+		card->next_request = h_mspro_block_req_init;
+		msb->mrq_handler = h_mspro_block_transfer_data;
+		memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG,
+				  (char *)&param, sizeof(param));
+		memstick_new_req(card->host);
+		wait_for_completion(&card->mrq_complete);
+		if (card->current_mrq.error) {
+			rc = card->current_mrq.error;
+			goto out_free_buffer;
+		}
+
+		memcpy(msb->attributes[cnt].data,
+		       buffer + addr % msb->page_size,
+		       rc);
+	}
+
+	rc = 0;
+out_free_buffer:
+	kfree(buffer);
+out_free_attr:
+	kfree(attr);
+	return rc;
+}
+
+static int mspro_block_init_card(struct memstick_dev *card)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	struct memstick_host *host = card->host;
+	int rc = 0;
+
+	msb->system = 0x80;
+	card->reg_addr = (struct ms_register_addr){
+		offsetof(struct mspro_register, status),
+		sizeof(struct ms_status_register),
+		offsetof(struct mspro_register, param),
+		sizeof(struct mspro_param_register)
+	};
+
+	if (memstick_set_rw_addr(card))
+		return -EIO;
+
+	if (host->caps & MEMSTICK_CAP_PARALLEL) {
+		if (mspro_block_switch_to_parallel(card))
+			printk(KERN_WARNING "%s: could not switch to "
+			       "parallel interface\n", card->dev.bus_id);
+	}
+
+	rc = mspro_block_wait_for_ced(card);
+	if (rc)
+		return rc;
+	dev_dbg(&card->dev, "card activated\n");
+
+	card->next_request = h_mspro_block_req_init;
+	msb->mrq_handler = h_mspro_block_get_ro;
+	memstick_init_req(&card->current_mrq, MS_TPC_READ_REG, NULL,
+			  sizeof(struct ms_status_register));
+	memstick_new_req(card->host);
+	wait_for_completion(&card->mrq_complete);
+	if (card->current_mrq.error)
+		return card->current_mrq.error;
+
+	dev_dbg(&card->dev, "card r/w status %d\n", msb->read_only ? 0 : 1);
+
+	msb->page_size = 512;
+	rc = mspro_block_read_attributes(card);
+	if (rc)
+		return rc;
+
+	dev_dbg(&card->dev, "attributes loaded\n");
+	return 0;
+
+}
+
+static int mspro_block_init_disk(struct memstick_dev *card)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	struct memstick_host *host = card->host;
+	struct mspro_devinfo *dev_info = NULL;
+	struct mspro_sys_info *sys_info = NULL;
+	int rc, disk_id;
+	u64 limit = BLK_BOUNCE_HIGH;
+	unsigned long capacity;
+
+	if (host->cdev.dev->dma_mask && *(host->cdev.dev->dma_mask))
+		limit = *(host->cdev.dev->dma_mask);
+
+	for (rc = 0; rc < msb->attr_count; rc++) {
+		if (msb->attributes[rc].id == MSPRO_BLOCK_ID_DEVINFO)
+			dev_info = (struct mspro_devinfo *)msb->attributes[rc]
+							       .data;
+		if (msb->attributes[rc].id == MSPRO_BLOCK_ID_SYSINFO)
+			sys_info = (struct mspro_sys_info *)msb->attributes[rc]
+								.data;
+	}
+
+	if (!dev_info || !sys_info)
+		return -ENODEV;
+
+	msb->cylinders = be16_to_cpu(dev_info->cylinders);
+	msb->heads = be16_to_cpu(dev_info->heads);
+	msb->sectors_per_track = be16_to_cpu(dev_info->sectors_per_track);
+
+	msb->page_size = be16_to_cpu(sys_info->unit_size);
+
+	if (!idr_pre_get(&mspro_block_disk_idr, GFP_KERNEL))
+		return -ENOMEM;
+
+	mutex_lock(&mspro_block_disk_lock);
+	rc = idr_get_new(&mspro_block_disk_idr, card, &disk_id);
+	mutex_unlock(&mspro_block_disk_lock);
+
+	if (rc)
+		return rc;
+
+	if ((disk_id << MEMSTICK_PART_SHIFT) > 255) {
+		rc = -ENOSPC;
+		goto out_release_id;
+	}
+
+	msb->disk = alloc_disk(1 << MEMSTICK_PART_SHIFT);
+	if (!msb->disk) {
+		rc = -ENOMEM;
+		goto out_release_id;
+	}
+
+	spin_lock_init(&msb->q_lock);
+	init_waitqueue_head(&msb->q_wait);
+
+	msb->queue = blk_init_queue(mspro_block_request, &msb->q_lock);
+	if (!msb->queue) {
+		rc = -ENOMEM;
+		goto out_put_disk;
+	}
+
+	msb->queue->queuedata = card;
+
+	blk_queue_bounce_limit(msb->queue, limit);
+	blk_queue_max_sectors(msb->queue, MSPRO_BLOCK_MAX_PAGES);
+	blk_queue_max_phys_segments(msb->queue, MSPRO_BLOCK_MAX_SEGS);
+	blk_queue_max_hw_segments(msb->queue, MSPRO_BLOCK_MAX_SEGS);
+	blk_queue_max_segment_size(msb->queue,
+				   MSPRO_BLOCK_MAX_PAGES * msb->page_size);
+
+	msb->disk->major = major;
+	msb->disk->first_minor = disk_id << MEMSTICK_PART_SHIFT;
+	msb->disk->fops = &ms_block_bdops;
+	msb->usage_count = 1;
+	msb->disk->private_data = msb;
+	msb->disk->queue = msb->queue;
+	msb->disk->driverfs_dev = &card->dev;
+
+	sprintf(msb->disk->disk_name, "mspblk%d", disk_id);
+
+	blk_queue_hardsect_size(msb->queue, msb->page_size);
+
+	capacity = be16_to_cpu(sys_info->user_block_count);
+	capacity *= be16_to_cpu(sys_info->block_size);
+	capacity *= msb->page_size >> 9;
+	set_capacity(msb->disk, capacity);
+	dev_dbg(&card->dev, "capacity set %ld\n", capacity);
+	msb->q_thread = kthread_run(mspro_block_queue_thread, card,
+				    DRIVER_NAME"d");
+	if (IS_ERR(msb->q_thread))
+		goto out_put_disk;
+
+	mutex_unlock(&host->lock);
+	add_disk(msb->disk);
+	mutex_lock(&host->lock);
+	msb->active = 1;
+	return 0;
+
+out_put_disk:
+	put_disk(msb->disk);
+out_release_id:
+	mutex_lock(&mspro_block_disk_lock);
+	idr_remove(&mspro_block_disk_idr, disk_id);
+	mutex_unlock(&mspro_block_disk_lock);
+	return rc;
+}
+
+static void mspro_block_data_clear(struct mspro_block_data *msb)
+{
+	int cnt;
+
+	for (cnt = 0; cnt < msb->attr_count; cnt++)
+		kfree(msb->attributes[cnt].data);
+
+	kfree(msb->attributes);
+	msb->card = NULL;
+}
+
+static int mspro_block_check_card(struct memstick_dev *card)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+
+	return (msb->active == 1);
+}
+
+static int mspro_block_probe(struct memstick_dev *card)
+{
+	struct mspro_block_data *msb;
+	int rc = 0;
+
+	msb = kzalloc(sizeof(struct mspro_block_data), GFP_KERNEL);
+	if (!msb)
+		return -ENOMEM;
+	memstick_set_drvdata(card, msb);
+	msb->card = card;
+
+	rc = mspro_block_init_card(card);
+
+	if (rc)
+		goto out_free;
+
+	rc = mspro_block_sysfs_register(card);
+	if (rc)
+		goto out_free;
+
+	rc = mspro_block_init_disk(card);
+	if (!rc) {
+		card->check = mspro_block_check_card;
+		return 0;
+	}
+
+	mspro_block_sysfs_unregister(card);
+out_free:
+	memstick_set_drvdata(card, NULL);
+	mspro_block_data_clear(msb);
+	kfree(msb);
+	return rc;
+}
+
+static void mspro_block_remove(struct memstick_dev *card)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	struct task_struct *q_thread = NULL;
+	unsigned long flags;
+
+	del_gendisk(msb->disk);
+	dev_dbg(&card->dev, "mspro block remove\n");
+	spin_lock_irqsave(&msb->q_lock, flags);
+	q_thread = msb->q_thread;
+	msb->q_thread = NULL;
+	msb->active = 0;
+	spin_unlock_irqrestore(&msb->q_lock, flags);
+
+	if (q_thread) {
+		mutex_unlock(&card->host->lock);
+		kthread_stop(q_thread);
+		mutex_lock(&card->host->lock);
+	}
+
+	dev_dbg(&card->dev, "queue thread stopped\n");
+
+	blk_cleanup_queue(msb->queue);
+
+	mspro_block_sysfs_unregister(card);
+
+	mutex_lock(&mspro_block_disk_lock);
+	mspro_block_data_clear(msb);
+	mutex_unlock(&mspro_block_disk_lock);
+
+	mspro_block_disk_release(msb->disk);
+	memstick_set_drvdata(card, NULL);
+}
+
+#ifdef CONFIG_PM
+
+static int mspro_block_suspend(struct memstick_dev *card, pm_message_t state)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	struct task_struct *q_thread = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&msb->q_lock, flags);
+	q_thread = msb->q_thread;
+	msb->q_thread = NULL;
+	msb->active = 0;
+	blk_stop_queue(msb->queue);
+	spin_unlock_irqrestore(&msb->q_lock, flags);
+
+	if (q_thread)
+		kthread_stop(q_thread);
+
+	return 0;
+}
+
+static int mspro_block_resume(struct memstick_dev *card)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	unsigned long flags;
+	int rc = 0;
+
+#ifdef CONFIG_MEMSTICK_UNSAFE_RESUME
+
+	struct mspro_block_data *new_msb;
+	struct memstick_host *host = card->host;
+	unsigned char cnt;
+
+	mutex_lock(&host->lock);
+	new_msb = kzalloc(sizeof(struct mspro_block_data), GFP_KERNEL);
+	if (!new_msb) {
+		rc = -ENOMEM;
+		goto out_unlock;
+	}
+
+	new_msb->card = card;
+	memstick_set_drvdata(card, new_msb);
+	if (mspro_block_init_card(card))
+		goto out_free;
+
+	for (cnt = 0; cnt < new_msb->attr_count; cnt++) {
+		if (new_msb->attributes[cnt].id == MSPRO_BLOCK_ID_SYSINFO
+		    && cnt < msb->attr_count
+		    && msb->attributes[cnt].id == MSPRO_BLOCK_ID_SYSINFO) {
+			if (memcmp(new_msb->attributes[cnt].data,
+				   msb->attributes[cnt].data,
+				   msb->attributes[cnt].size))
+				break;
+
+			memstick_set_drvdata(card, msb);
+			msb->q_thread = kthread_run(mspro_block_queue_thread,
+						    card, DRIVER_NAME"d");
+			if (IS_ERR(msb->q_thread))
+				msb->q_thread = NULL;
+			else
+				msb->active = 1;
+
+			break;
+		}
+	}
+
+out_free:
+	memstick_set_drvdata(card, msb);
+	mspro_block_data_clear(new_msb);
+	kfree(new_msb);
+out_unlock:
+	mutex_unlock(&host->lock);
+
+#endif /* CONFIG_MEMSTICK_UNSAFE_RESUME */
+
+	spin_lock_irqsave(&msb->q_lock, flags);
+	blk_start_queue(msb->queue);
+	spin_unlock_irqrestore(&msb->q_lock, flags);
+	return rc;
+}
+
+#else
+
+#define mspro_block_suspend NULL
+#define mspro_block_resume NULL
+
+#endif /* CONFIG_PM */
+
+static struct memstick_device_id mspro_block_id_tbl[] = {
+	{MEMSTICK_MATCH_ALL, MEMSTICK_TYPE_PRO, MEMSTICK_CATEGORY_STORAGE_DUO,
+	 MEMSTICK_CLASS_GENERIC_DUO},
+	{}
+};
+
+
+static struct memstick_driver mspro_block_driver = {
+	.driver = {
+		.name  = DRIVER_NAME,
+		.owner = THIS_MODULE
+	},
+	.id_table = mspro_block_id_tbl,
+	.probe    = mspro_block_probe,
+	.remove   = mspro_block_remove,
+	.suspend  = mspro_block_suspend,
+	.resume   = mspro_block_resume
+};
+
+static int __init mspro_block_init(void)
+{
+	int rc = -ENOMEM;
+
+	rc = register_blkdev(major, DRIVER_NAME);
+	if (rc < 0) {
+		printk(KERN_ERR DRIVER_NAME ": failed to register "
+		       "major %d, error %d\n", major, rc);
+		return rc;
+	}
+	if (!major)
+		major = rc;
+
+	rc = memstick_register_driver(&mspro_block_driver);
+	if (rc)
+		unregister_blkdev(major, DRIVER_NAME);
+	return rc;
+}
+
+static void __exit mspro_block_exit(void)
+{
+	memstick_unregister_driver(&mspro_block_driver);
+	unregister_blkdev(major, DRIVER_NAME);
+	idr_destroy(&mspro_block_disk_idr);
+}
+
+module_init(mspro_block_init);
+module_exit(mspro_block_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Alex Dubov");
+MODULE_DESCRIPTION("Sony MemoryStickPro block device driver");
+MODULE_DEVICE_TABLE(memstick, mspro_block_id_tbl);
+MODULE_VERSION(DRIVER_VERSION);
diff -puN /dev/null drivers/memstick/host/Kconfig
--- /dev/null
+++ a/drivers/memstick/host/Kconfig
@@ -0,0 +1,22 @@
+#
+# MemoryStick host controller drivers
+#
+
+comment "MemoryStick Host Controller Drivers"
+
+config MEMSTICK_TIFM_MS
+	tristate "TI Flash Media MemoryStick Interface support  (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && PCI
+	select TIFM_CORE
+	help
+	  Say Y here if you want to be able to access MemoryStick cards with
+	  the Texas Instruments(R) Flash Media card reader, found in many
+	  laptops.
+	  This option 'selects' (turns on, enables) 'TIFM_CORE', but you
+	  probably also need appropriate card reader host adapter, such as
+	  'Misc devices: TI Flash Media PCI74xx/PCI76xx host adapter support
+	  (TIFM_7XX1)'.
+
+          To compile this driver as a module, choose M here: the
+	  module will be called tifm_ms.
+
diff -puN /dev/null drivers/memstick/host/Makefile
--- /dev/null
+++ a/drivers/memstick/host/Makefile
@@ -0,0 +1,10 @@
+#
+# Makefile for MemoryStick host controller drivers
+#
+
+ifeq ($(CONFIG_MEMSTICK_DEBUG),y)
+	EXTRA_CFLAGS		+= -DDEBUG
+endif
+
+obj-$(CONFIG_MEMSTICK_TIFM_MS)	+= tifm_ms.o
+
diff -puN /dev/null drivers/memstick/host/tifm_ms.c
--- /dev/null
+++ a/drivers/memstick/host/tifm_ms.c
@@ -0,0 +1,684 @@
+/*
+ *  TI FlashMedia driver
+ *
+ *  Copyright (C) 2007 Alex Dubov <oakad@yahoo.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Special thanks to Carlos Corbacho for providing various MemoryStick cards
+ * that made this driver possible.
+ *
+ */
+
+#include <linux/tifm.h>
+#include <linux/memstick.h>
+#include <linux/highmem.h>
+#include <linux/log2.h>
+#include <asm/io.h>
+
+#define DRIVER_NAME "tifm_ms"
+#define DRIVER_VERSION "0.1"
+
+static int no_dma;
+module_param(no_dma, bool, 0644);
+
+#define TIFM_MS_TIMEOUT      0x00100
+#define TIFM_MS_BADCRC       0x00200
+#define TIFM_MS_EOTPC        0x01000
+#define TIFM_MS_INT          0x02000
+
+/* The meaning of the bit majority in this constant is unknown. */
+#define TIFM_MS_SERIAL       0x04010
+
+#define TIFM_MS_SYS_LATCH    0x00100
+#define TIFM_MS_SYS_NOT_RDY  0x00800
+#define TIFM_MS_SYS_DATA     0x10000
+
+/* Hardware flags */
+enum {
+	CMD_READY  = 0x0001,
+	FIFO_READY = 0x0002,
+	CARD_READY = 0x0004,
+	DATA_CARRY = 0x0008
+};
+
+struct tifm_ms {
+	struct tifm_dev         *dev;
+	unsigned short          eject:1,
+				no_dma:1;
+	unsigned short          cmd_flags;
+	unsigned int            mode_mask;
+	unsigned int            block_pos;
+	unsigned long           timeout_jiffies;
+
+	struct timer_list       timer;
+	struct memstick_request *req;
+	unsigned int            io_word;
+};
+
+static void tifm_ms_read_fifo(struct tifm_ms *host, unsigned int fifo_offset,
+			      struct page *pg, unsigned int page_off,
+			      unsigned int length)
+{
+	struct tifm_dev *sock = host->dev;
+	unsigned int cnt = 0, off = 0;
+	unsigned char *buf = kmap_atomic(pg, KM_BIO_DST_IRQ) + page_off;
+
+	if (host->cmd_flags & DATA_CARRY) {
+		while ((fifo_offset & 3) && length) {
+			buf[off++] = host->io_word & 0xff;
+			host->io_word >>= 8;
+			length--;
+			fifo_offset++;
+		}
+		if (!(fifo_offset & 3))
+			host->cmd_flags &= ~DATA_CARRY;
+		if (!length)
+			return;
+	}
+
+	do {
+		host->io_word = readl(sock->addr + SOCK_FIFO_ACCESS
+				      + fifo_offset);
+		cnt = 4;
+		while (length && cnt) {
+			buf[off++] = (host->io_word >> 8) & 0xff;
+			cnt--;
+			length--;
+		}
+		fifo_offset += 4 - cnt;
+	} while (length);
+
+	if (cnt)
+		host->cmd_flags |= DATA_CARRY;
+
+	kunmap_atomic(buf - page_off, KM_BIO_DST_IRQ);
+}
+
+static void tifm_ms_write_fifo(struct tifm_ms *host, unsigned int fifo_offset,
+			       struct page *pg, unsigned int page_off,
+			       unsigned int length)
+{
+	struct tifm_dev *sock = host->dev;
+	unsigned int cnt = 0, off = 0;
+	unsigned char *buf = kmap_atomic(pg, KM_BIO_SRC_IRQ) + page_off;
+
+	if (host->cmd_flags & DATA_CARRY) {
+		while (fifo_offset & 3) {
+			host->io_word |= buf[off++] << (8 * (fifo_offset & 3));
+			length--;
+			fifo_offset++;
+		}
+		if (!(fifo_offset & 3)) {
+			writel(host->io_word, sock->addr + SOCK_FIFO_ACCESS
+			       + fifo_offset - 4);
+
+			host->cmd_flags &= ~DATA_CARRY;
+		}
+		if (!length)
+			return;
+	}
+
+	do {
+		cnt = 4;
+		host->io_word = 0;
+		while (length && cnt) {
+			host->io_word |= buf[off++] << (4 - cnt);
+			cnt--;
+			length--;
+		}
+		fifo_offset += 4 - cnt;
+		if (!cnt)
+			writel(host->io_word, sock->addr + SOCK_FIFO_ACCESS
+					      + fifo_offset - 4);
+
+	} while (length);
+
+	if (cnt)
+		host->cmd_flags |= DATA_CARRY;
+
+	kunmap_atomic(buf - page_off, KM_BIO_SRC_IRQ);
+}
+
+static void tifm_ms_move_block(struct tifm_ms *host, unsigned int length)
+{
+	unsigned int t_size;
+	unsigned int off = host->req->sg.offset + host->block_pos;
+	unsigned int p_off, p_cnt;
+	struct page *pg;
+	unsigned long flags;
+
+	dev_dbg(&host->dev->dev, "moving block\n");
+	local_irq_save(flags);
+	t_size = length;
+	while (t_size) {
+		pg = nth_page(sg_page(&host->req->sg), off >> PAGE_SHIFT);
+		p_off = offset_in_page(off);
+		p_cnt = PAGE_SIZE - p_off;
+		p_cnt = min(p_cnt, t_size);
+
+		if (host->req->data_dir == WRITE)
+			tifm_ms_write_fifo(host, length - t_size,
+					   pg, p_off, p_cnt);
+		else
+			tifm_ms_read_fifo(host, length - t_size,
+					  pg, p_off, p_cnt);
+
+		t_size -= p_cnt;
+	}
+	local_irq_restore(flags);
+}
+
+static int tifm_ms_transfer_data(struct tifm_ms *host, int skip)
+{
+	struct tifm_dev *sock = host->dev;
+	unsigned int length = host->req->sg.length - host->block_pos;
+
+	if (!length)
+		return 1;
+
+	if (length > TIFM_FIFO_SIZE)
+		length = TIFM_FIFO_SIZE;
+
+	if (!skip) {
+		tifm_ms_move_block(host, length);
+		host->block_pos += length;
+	}
+
+	if ((host->req->data_dir == READ)
+	    && (host->block_pos == host->req->sg.length))
+		return 1;
+
+	writel(ilog2(length) - 2, sock->addr + SOCK_FIFO_PAGE_SIZE);
+	if (host->req->data_dir == WRITE)
+		writel((1 << 8) | TIFM_DMA_TX, sock->addr + SOCK_DMA_CONTROL);
+	else
+		writel((1 << 8), sock->addr + SOCK_DMA_CONTROL);
+
+	return 0;
+}
+
+static int tifm_ms_issue_cmd(struct tifm_ms *host)
+{
+	struct tifm_dev *sock = host->dev;
+	unsigned char *data;
+	unsigned int data_len = 0, cmd = 0, cmd_mask = 0, cnt, tval = 0;
+
+	host->cmd_flags = 0;
+
+	if (host->req->io_type == MEMSTICK_IO_SG) {
+		if (!host->no_dma) {
+			if (1 != tifm_map_sg(sock, &host->req->sg, 1,
+					     host->req->data_dir == READ
+					     ? PCI_DMA_FROMDEVICE
+					     : PCI_DMA_TODEVICE)) {
+				host->req->error = -ENOMEM;
+				return host->req->error;
+			}
+			data_len = sg_dma_len(&host->req->sg);
+		} else
+			data_len = host->req->sg.length;
+
+		writel(TIFM_FIFO_INT_SETALL,
+		       sock->addr + SOCK_DMA_FIFO_INT_ENABLE_CLEAR);
+		writel(TIFM_FIFO_ENABLE,
+		       sock->addr + SOCK_FIFO_CONTROL);
+		writel(TIFM_FIFO_INTMASK,
+		       sock->addr + SOCK_DMA_FIFO_INT_ENABLE_SET);
+
+		if (!host->no_dma) {
+			writel(ilog2(data_len) - 2,
+			       sock->addr + SOCK_FIFO_PAGE_SIZE);
+			writel(sg_dma_address(&host->req->sg),
+			       sock->addr + SOCK_DMA_ADDRESS);
+			if (host->req->data_dir == WRITE)
+				writel((1 << 8) | TIFM_DMA_TX | TIFM_DMA_EN,
+				       sock->addr + SOCK_DMA_CONTROL);
+			else
+				writel((1 << 8) | TIFM_DMA_EN,
+				       sock->addr + SOCK_DMA_CONTROL);
+		} else {
+			tifm_ms_transfer_data(host,
+					      host->req->data_dir == READ);
+		}
+
+		cmd_mask = readl(sock->addr + SOCK_MS_SYSTEM);
+		cmd_mask |= TIFM_MS_SYS_DATA | TIFM_MS_SYS_NOT_RDY;
+		writel(cmd_mask, sock->addr + SOCK_MS_SYSTEM);
+	} else if (host->req->io_type == MEMSTICK_IO_VAL) {
+		data = host->req->data;
+		data_len = host->req->data_len;
+
+		cmd_mask = host->mode_mask | 0x2607; /* unknown constant */
+
+		if (host->req->data_dir == WRITE) {
+			cmd_mask |= TIFM_MS_SYS_LATCH;
+			writel(cmd_mask, sock->addr + SOCK_MS_SYSTEM);
+			for (cnt = 0; (data_len - cnt) >= 4; cnt += 4) {
+				writel(TIFM_MS_SYS_LATCH
+				       | readl(sock->addr + SOCK_MS_SYSTEM),
+				       sock->addr + SOCK_MS_SYSTEM);
+				__raw_writel(*(unsigned int *)(data + cnt),
+					     sock->addr + SOCK_MS_DATA);
+				dev_dbg(&sock->dev, "writing %x\n",
+					*(int *)(data + cnt));
+			}
+			switch (data_len - cnt) {
+			case 3:
+				tval |= data[cnt + 2] << 16;
+			case 2:
+				tval |= data[cnt + 1] << 8;
+			case 1:
+				tval |= data[cnt];
+				writel(TIFM_MS_SYS_LATCH
+				       | readl(sock->addr + SOCK_MS_SYSTEM),
+				       sock->addr + SOCK_MS_SYSTEM);
+				writel(tval, sock->addr + SOCK_MS_DATA);
+				dev_dbg(&sock->dev, "writing %x\n", tval);
+			}
+
+			writel(TIFM_MS_SYS_LATCH
+			       | readl(sock->addr + SOCK_MS_SYSTEM),
+			       sock + SOCK_MS_SYSTEM);
+			writel(0, sock->addr + SOCK_MS_DATA);
+			dev_dbg(&sock->dev, "writing %x\n", 0);
+
+		} else
+			writel(cmd_mask, sock->addr + SOCK_MS_SYSTEM);
+
+		cmd_mask = readl(sock->addr + SOCK_MS_SYSTEM);
+		cmd_mask &= ~TIFM_MS_SYS_DATA;
+		cmd_mask |= TIFM_MS_SYS_NOT_RDY;
+		dev_dbg(&sock->dev, "mask %x\n", cmd_mask);
+		writel(cmd_mask, sock->addr + SOCK_MS_SYSTEM);
+	} else
+		BUG();
+
+	mod_timer(&host->timer, jiffies + host->timeout_jiffies);
+	writel(TIFM_CTRL_LED | readl(sock->addr + SOCK_CONTROL),
+	       sock->addr + SOCK_CONTROL);
+	host->req->error = 0;
+
+	cmd = (host->req->tpc & 0xf) << 12;
+	cmd |= data_len;
+	writel(cmd, sock->addr + SOCK_MS_COMMAND);
+
+	dev_dbg(&sock->dev, "executing TPC %x, %x\n", cmd, cmd_mask);
+	return 0;
+}
+
+static void tifm_ms_complete_cmd(struct tifm_ms *host)
+{
+	struct tifm_dev *sock = host->dev;
+	struct memstick_host *msh = tifm_get_drvdata(sock);
+	unsigned int tval = 0, data_len;
+	unsigned char *data;
+	int rc;
+
+	del_timer(&host->timer);
+	if (host->req->io_type == MEMSTICK_IO_SG) {
+		if (!host->no_dma)
+			tifm_unmap_sg(sock, &host->req->sg, 1,
+				      host->req->data_dir == READ
+				      ? PCI_DMA_FROMDEVICE
+				      : PCI_DMA_TODEVICE);
+	} else if (host->req->io_type == MEMSTICK_IO_VAL) {
+		writel(~TIFM_MS_SYS_DATA & readl(sock->addr + SOCK_MS_SYSTEM),
+		       sock->addr + SOCK_MS_SYSTEM);
+
+		data = host->req->data;
+		data_len = host->req->data_len;
+
+		if (host->req->data_dir == READ) {
+			for (rc = 0; (data_len - rc) >= 4; rc += 4)
+				*(int *)(data + rc)
+					= __raw_readl(sock->addr
+						      + SOCK_MS_DATA);
+
+			if (data_len - rc)
+				tval = readl(sock->addr + SOCK_MS_DATA);
+			switch (data_len - rc) {
+			case 3:
+				data[rc + 2] = (tval >> 16) & 0xff;
+			case 2:
+				data[rc + 1] = (tval >> 8) & 0xff;
+			case 1:
+				data[rc] = tval & 0xff;
+			}
+			readl(sock->addr + SOCK_MS_DATA);
+		}
+	}
+
+	writel((~TIFM_CTRL_LED) & readl(sock->addr + SOCK_CONTROL),
+	       sock->addr + SOCK_CONTROL);
+
+	do {
+		rc = memstick_next_req(msh, &host->req);
+	} while (!rc && tifm_ms_issue_cmd(host));
+}
+
+static int tifm_ms_check_status(struct tifm_ms *host)
+{
+	if (!host->req->error) {
+		if (!(host->cmd_flags & CMD_READY))
+			return 1;
+		if ((host->req->io_type == MEMSTICK_IO_SG)
+		    && !(host->cmd_flags & FIFO_READY))
+			return 1;
+		if (host->req->need_card_int
+		    && !(host->cmd_flags & CARD_READY))
+			return 1;
+	}
+	return 0;
+}
+
+/* Called from interrupt handler */
+static void tifm_ms_data_event(struct tifm_dev *sock)
+{
+	struct tifm_ms *host;
+	unsigned int fifo_status = 0;
+	int rc = 1;
+
+	spin_lock(&sock->lock);
+	host = memstick_priv((struct memstick_host *)tifm_get_drvdata(sock));
+	fifo_status = readl(sock->addr + SOCK_DMA_FIFO_STATUS);
+	dev_dbg(&sock->dev, "data event: fifo_status %x, flags %x\n",
+		fifo_status, host->cmd_flags);
+
+	if (host->req) {
+		if (fifo_status & TIFM_FIFO_READY) {
+			if (!host->no_dma || tifm_ms_transfer_data(host, 0)) {
+				host->cmd_flags |= FIFO_READY;
+				rc = tifm_ms_check_status(host);
+			}
+		}
+	}
+
+	writel(fifo_status, sock->addr + SOCK_DMA_FIFO_STATUS);
+	if (!rc)
+		tifm_ms_complete_cmd(host);
+
+	spin_unlock(&sock->lock);
+}
+
+
+/* Called from interrupt handler */
+static void tifm_ms_card_event(struct tifm_dev *sock)
+{
+	struct tifm_ms *host;
+	unsigned int host_status = 0;
+	int rc = 1;
+
+	spin_lock(&sock->lock);
+	host = memstick_priv((struct memstick_host *)tifm_get_drvdata(sock));
+	host_status = readl(sock->addr + SOCK_MS_STATUS);
+	dev_dbg(&sock->dev, "host event: host_status %x, flags %x\n",
+		host_status, host->cmd_flags);
+
+	if (host->req) {
+		if (host_status & TIFM_MS_TIMEOUT)
+			host->req->error = -ETIME;
+		else if (host_status & TIFM_MS_BADCRC)
+			host->req->error = -EILSEQ;
+
+		if (host->req->error) {
+			writel(TIFM_FIFO_INT_SETALL,
+			       sock->addr + SOCK_DMA_FIFO_INT_ENABLE_CLEAR);
+			writel(TIFM_DMA_RESET, sock->addr + SOCK_DMA_CONTROL);
+		}
+
+		if (host_status & TIFM_MS_EOTPC)
+			host->cmd_flags |= CMD_READY;
+		if (host_status & TIFM_MS_INT)
+			host->cmd_flags |= CARD_READY;
+
+		rc = tifm_ms_check_status(host);
+
+	}
+
+	writel(TIFM_MS_SYS_NOT_RDY | readl(sock->addr + SOCK_MS_SYSTEM),
+	       sock->addr + SOCK_MS_SYSTEM);
+	writel((~TIFM_MS_SYS_DATA) & readl(sock->addr + SOCK_MS_SYSTEM),
+	       sock->addr + SOCK_MS_SYSTEM);
+
+	if (!rc)
+		tifm_ms_complete_cmd(host);
+
+	spin_unlock(&sock->lock);
+	return;
+}
+
+static void tifm_ms_request(struct memstick_host *msh)
+{
+	struct tifm_ms *host = memstick_priv(msh);
+	struct tifm_dev *sock = host->dev;
+	unsigned long flags;
+	int rc;
+
+	spin_lock_irqsave(&sock->lock, flags);
+	if (host->req) {
+		printk(KERN_ERR "%s : unfinished request detected\n",
+		       sock->dev.bus_id);
+		spin_unlock_irqrestore(&sock->lock, flags);
+		tifm_eject(host->dev);
+		return;
+	}
+
+	if (host->eject) {
+		do {
+			rc = memstick_next_req(msh, &host->req);
+			if (!rc)
+				host->req->error = -ETIME;
+		} while (!rc);
+		spin_unlock_irqrestore(&sock->lock, flags);
+		return;
+	}
+
+	do {
+		rc = memstick_next_req(msh, &host->req);
+	} while (!rc && tifm_ms_issue_cmd(host));
+
+	spin_unlock_irqrestore(&sock->lock, flags);
+	return;
+}
+
+static void tifm_ms_set_param(struct memstick_host *msh,
+			      enum memstick_param param,
+			      int value)
+{
+	struct tifm_ms *host = memstick_priv(msh);
+	struct tifm_dev *sock = host->dev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sock->lock, flags);
+
+	switch (param) {
+	case MEMSTICK_POWER:
+		/* this is set by card detection mechanism */
+		break;
+	case MEMSTICK_INTERFACE:
+		if (value == MEMSTICK_SERIAL) {
+			host->mode_mask = TIFM_MS_SERIAL;
+			writel((~TIFM_CTRL_FAST_CLK)
+			       & readl(sock->addr + SOCK_CONTROL),
+			       sock->addr + SOCK_CONTROL);
+		} else if (value == MEMSTICK_PARALLEL) {
+			host->mode_mask = 0;
+			writel(TIFM_CTRL_FAST_CLK
+			       | readl(sock->addr + SOCK_CONTROL),
+			       sock->addr + SOCK_CONTROL);
+		}
+		break;
+	};
+
+	spin_unlock_irqrestore(&sock->lock, flags);
+}
+
+static void tifm_ms_abort(unsigned long data)
+{
+	struct tifm_ms *host = (struct tifm_ms *)data;
+
+	dev_dbg(&host->dev->dev, "status %x\n",
+		readl(host->dev->addr + SOCK_MS_STATUS));
+	printk(KERN_ERR
+	       "%s : card failed to respond for a long period of time "
+	       "(%x, %x)\n",
+	       host->dev->dev.bus_id, host->req ? host->req->tpc : 0,
+	       host->cmd_flags);
+
+	tifm_eject(host->dev);
+}
+
+static int tifm_ms_initialize_host(struct tifm_ms *host)
+{
+	struct tifm_dev *sock = host->dev;
+	struct memstick_host *msh = tifm_get_drvdata(sock);
+
+	host->mode_mask = TIFM_MS_SERIAL;
+	writel(0x8000, sock->addr + SOCK_MS_SYSTEM);
+	writel(0x0200 | TIFM_MS_SYS_NOT_RDY, sock->addr + SOCK_MS_SYSTEM);
+	writel(0xffffffff, sock->addr + SOCK_MS_STATUS);
+	if (tifm_has_ms_pif(sock))
+		msh->caps |= MEMSTICK_CAP_PARALLEL;
+
+	return 0;
+}
+
+static int tifm_ms_probe(struct tifm_dev *sock)
+{
+	struct memstick_host *msh;
+	struct tifm_ms *host;
+	int rc = -EIO;
+
+	if (!(TIFM_SOCK_STATE_OCCUPIED
+	      & readl(sock->addr + SOCK_PRESENT_STATE))) {
+		printk(KERN_WARNING "%s : card gone, unexpectedly\n",
+		       sock->dev.bus_id);
+		return rc;
+	}
+
+	msh = memstick_alloc_host(sizeof(struct tifm_ms), &sock->dev);
+	if (!msh)
+		return -ENOMEM;
+
+	host = memstick_priv(msh);
+	tifm_set_drvdata(sock, msh);
+	host->dev = sock;
+	host->timeout_jiffies = msecs_to_jiffies(1000);
+	host->no_dma = no_dma;
+
+	setup_timer(&host->timer, tifm_ms_abort, (unsigned long)host);
+
+	msh->request = tifm_ms_request;
+	msh->set_param = tifm_ms_set_param;
+	sock->card_event = tifm_ms_card_event;
+	sock->data_event = tifm_ms_data_event;
+	rc = tifm_ms_initialize_host(host);
+
+	if (!rc)
+		rc = memstick_add_host(msh);
+	if (!rc)
+		return 0;
+
+	memstick_free_host(msh);
+	return rc;
+}
+
+static void tifm_ms_remove(struct tifm_dev *sock)
+{
+	struct memstick_host *msh = tifm_get_drvdata(sock);
+	struct tifm_ms *host = memstick_priv(msh);
+	int rc = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sock->lock, flags);
+	host->eject = 1;
+	if (host->req) {
+		del_timer(&host->timer);
+		writel(TIFM_FIFO_INT_SETALL,
+		       sock->addr + SOCK_DMA_FIFO_INT_ENABLE_CLEAR);
+		writel(TIFM_DMA_RESET, sock->addr + SOCK_DMA_CONTROL);
+		if ((host->req->io_type == MEMSTICK_IO_SG) && !host->no_dma)
+			tifm_unmap_sg(sock, &host->req->sg, 1,
+				      host->req->data_dir == READ
+				      ? PCI_DMA_TODEVICE
+				      : PCI_DMA_FROMDEVICE);
+		host->req->error = -ETIME;
+
+		do {
+			rc = memstick_next_req(msh, &host->req);
+			if (!rc)
+				host->req->error = -ETIME;
+		} while (!rc);
+	}
+	spin_unlock_irqrestore(&sock->lock, flags);
+
+	memstick_remove_host(msh);
+
+	writel(0x0200 | TIFM_MS_SYS_NOT_RDY, sock->addr + SOCK_MS_SYSTEM);
+	writel(0xffffffff, sock->addr + SOCK_MS_STATUS);
+
+	memstick_free_host(msh);
+}
+
+#ifdef CONFIG_PM
+
+static int tifm_ms_suspend(struct tifm_dev *sock, pm_message_t state)
+{
+	return 0;
+}
+
+static int tifm_ms_resume(struct tifm_dev *sock)
+{
+	struct memstick_host *msh = tifm_get_drvdata(sock);
+	struct tifm_ms *host = memstick_priv(msh);
+
+	tifm_ms_initialize_host(host);
+	memstick_detect_change(msh);
+
+	return 0;
+}
+
+#else
+
+#define tifm_ms_suspend NULL
+#define tifm_ms_resume NULL
+
+#endif /* CONFIG_PM */
+
+static struct tifm_device_id tifm_ms_id_tbl[] = {
+	{ TIFM_TYPE_MS }, { 0 }
+};
+
+static struct tifm_driver tifm_ms_driver = {
+	.driver = {
+		.name  = DRIVER_NAME,
+		.owner = THIS_MODULE
+	},
+	.id_table = tifm_ms_id_tbl,
+	.probe    = tifm_ms_probe,
+	.remove   = tifm_ms_remove,
+	.suspend  = tifm_ms_suspend,
+	.resume   = tifm_ms_resume
+};
+
+static int __init tifm_ms_init(void)
+{
+	return tifm_register_driver(&tifm_ms_driver);
+}
+
+static void __exit tifm_ms_exit(void)
+{
+	tifm_unregister_driver(&tifm_ms_driver);
+}
+
+MODULE_AUTHOR("Alex Dubov");
+MODULE_DESCRIPTION("TI FlashMedia MemoryStick driver");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(tifm, tifm_ms_id_tbl);
+MODULE_VERSION(DRIVER_VERSION);
+
+module_init(tifm_ms_init);
+module_exit(tifm_ms_exit);
diff -puN /dev/null drivers/memstick/Kconfig
--- /dev/null
+++ a/drivers/memstick/Kconfig
@@ -0,0 +1,26 @@
+#
+# MemoryStick subsystem configuration
+#
+
+menuconfig MEMSTICK
+	tristate "Sony MemoryStick card support (EXPERIMENTAL)"
+	help
+	  Sony MemoryStick is a proprietary storage/extension card protocol.
+
+	  If you want MemoryStick support, you should say Y here and also
+	  to the specific driver for your MMC interface.
+
+if MEMSTICK
+
+config MEMSTICK_DEBUG
+	bool "MemoryStick debugging"
+	help
+	  This is an option for use by developers; most people should
+	  say N here.  This enables MemoryStick core and driver debugging.
+
+
+source "drivers/memstick/core/Kconfig"
+
+source "drivers/memstick/host/Kconfig"
+
+endif # MEMSTICK
diff -puN /dev/null drivers/memstick/Makefile
--- /dev/null
+++ a/drivers/memstick/Makefile
@@ -0,0 +1,11 @@
+#
+# Makefile for the kernel MemoryStick device drivers.
+#
+
+ifeq ($(CONFIG_MEMSTICK_DEBUG),y)
+	EXTRA_CFLAGS		+= -DDEBUG
+endif
+
+obj-$(CONFIG_MEMSTICK)		+= core/
+obj-$(CONFIG_MEMSTICK)		+= host/
+
diff -puN drivers/misc/tifm_7xx1.c~memstick-initial-commit-for-sony-memorystick-support drivers/misc/tifm_7xx1.c
--- a/drivers/misc/tifm_7xx1.c~memstick-initial-commit-for-sony-memorystick-support
+++ a/drivers/misc/tifm_7xx1.c
@@ -302,6 +302,21 @@ static int tifm_7xx1_resume(struct pci_d
 
 #endif /* CONFIG_PM */
 
+static int tifm_7xx1_dummy_has_ms_pif(struct tifm_adapter *fm,
+				      struct tifm_dev *sock)
+{
+	return 0;
+}
+
+static int tifm_7xx1_has_ms_pif(struct tifm_adapter *fm, struct tifm_dev *sock)
+{
+	if (((fm->num_sockets == 4) && (sock->socket_id == 2))
+	    || ((fm->num_sockets == 2) && (sock->socket_id == 0)))
+		return 1;
+
+	return 0;
+}
+
 static int tifm_7xx1_probe(struct pci_dev *dev,
 			   const struct pci_device_id *dev_id)
 {
@@ -336,6 +351,7 @@ static int tifm_7xx1_probe(struct pci_de
 
 	INIT_WORK(&fm->media_switcher, tifm_7xx1_switch_media);
 	fm->eject = tifm_7xx1_eject;
+	fm->has_ms_pif = tifm_7xx1_has_ms_pif;
 	pci_set_drvdata(dev, fm);
 
 	fm->addr = ioremap(pci_resource_start(dev, 0),
@@ -377,6 +393,7 @@ static void tifm_7xx1_remove(struct pci_
 	int cnt;
 
 	fm->eject = tifm_7xx1_dummy_eject;
+	fm->has_ms_pif = tifm_7xx1_dummy_has_ms_pif;
 	writel(TIFM_IRQ_SETALL, fm->addr + FM_CLEAR_INTERRUPT_ENABLE);
 	mmiowb();
 	free_irq(dev->irq, fm);
diff -puN drivers/misc/tifm_core.c~memstick-initial-commit-for-sony-memorystick-support drivers/misc/tifm_core.c
--- a/drivers/misc/tifm_core.c~memstick-initial-commit-for-sony-memorystick-support
+++ a/drivers/misc/tifm_core.c
@@ -284,6 +284,13 @@ void tifm_eject(struct tifm_dev *sock)
 }
 EXPORT_SYMBOL(tifm_eject);
 
+int tifm_has_ms_pif(struct tifm_dev *sock)
+{
+	struct tifm_adapter *fm = dev_get_drvdata(sock->dev.parent);
+	return fm->has_ms_pif(fm, sock);
+}
+EXPORT_SYMBOL(tifm_has_ms_pif);
+
 int tifm_map_sg(struct tifm_dev *sock, struct scatterlist *sg, int nents,
 		int direction)
 {
diff -puN /dev/null include/linux/memstick.h
--- /dev/null
+++ a/include/linux/memstick.h
@@ -0,0 +1,289 @@
+/*
+ *  Sony MemoryStick support
+ *
+ *  Copyright (C) 2007 Alex Dubov <oakad@yahoo.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef _MEMSTICK_H
+#define _MEMSTICK_H
+
+#include <linux/workqueue.h>
+
+struct ms_status_register {
+	unsigned char reserved;
+	unsigned char interrupt;
+#define MEMSTICK_INT_CMDNAK             0x0001
+#define MEMSTICK_INT_BREQ               0x0020
+#define MEMSTICK_INT_ERR                0x0040
+#define MEMSTICK_INT_CED                0x0080
+
+	unsigned char status0;
+#define MEMSTICK_STATUS0_WP             0x0001
+#define MEMSTICK_STATUS0_SL             0x0002
+#define MEMSTICK_STATUS0_BF             0x0010
+#define MEMSTICK_STATUS0_BE             0x0020
+#define MEMSTICK_STATUS0_FB0            0x0040
+#define MEMSTICK_STATUS0_MB             0x0080
+
+	unsigned char status1;
+#define MEMSTICK_STATUS1_UCFG           0x0001
+#define MEMSTICK_STATUS1_FGER           0x0002
+#define MEMSTICK_STATUS1_UCEX           0x0004
+#define MEMSTICK_STATUS1_EXER           0x0008
+#define MEMSTICK_STATUS1_UCDT           0x0010
+#define MEMSTICK_STATUS1_DTER           0x0020
+#define MEMSTICK_STATUS1_FBI            0x0040
+#define MEMSTICK_STATUS1_MB             0x0080
+} __attribute__((packed));
+
+struct ms_id_register {
+	unsigned char type;
+	unsigned char reserved;
+	unsigned char category;
+	unsigned char class;
+} __attribute__((packed));
+
+struct ms_param_register {
+	unsigned char system;
+	unsigned char block_address_msb;
+	unsigned short block_address;
+	unsigned char cp;
+#define MEMSTICK_CP_BLOCK               0x0000
+#define MEMSTICK_CP_PAGE                0x0020
+#define MEMSTICK_CP_EXTRA               0x0040
+#define MEMSTICK_CP_OVERWRITE           0x0080
+
+	unsigned char page_address;
+} __attribute__((packed));
+
+struct ms_extra_data_register {
+	unsigned char  overwrite_flag;
+#define MEMSTICK_OVERWRITE_UPDATA       0x0010
+#define MEMSTICK_OVERWRITE_PAGE         0x0060
+#define MEMSTICK_OVERWRITE_BLOCK        0x0080
+
+	unsigned char  management_flag;
+#define MEMSTICK_MANAGEMENT_SYSTEM      0x0004
+#define MEMSTICK_MANAGEMENT_TRANS_TABLE 0x0008
+#define MEMSTICK_MANAGEMENT_COPY        0x0010
+#define MEMSTICK_MANAGEMENT_ACCESS      0x0020
+
+	unsigned short logical_address;
+} __attribute__((packed));
+
+struct ms_register {
+	struct ms_status_register     status;
+	struct ms_id_register         id;
+	unsigned char                 reserved[8];
+	struct ms_param_register      param;
+	struct ms_extra_data_register extra_data;
+} __attribute__((packed));
+
+struct mspro_param_register {
+	unsigned char  system;
+	unsigned short data_count;
+	unsigned int   data_address;
+	unsigned char  cmd_param;
+} __attribute__((packed));
+
+struct mspro_register {
+	struct ms_status_register    status;
+	struct ms_id_register        id;
+	unsigned char                reserved[8];
+	struct mspro_param_register  param;
+} __attribute__((packed));
+
+struct ms_register_addr {
+	unsigned char r_offset;
+	unsigned char r_length;
+	unsigned char w_offset;
+	unsigned char w_length;
+} __attribute__((packed));
+
+enum {
+	MS_TPC_READ_LONG_DATA   = 0x02,
+	MS_TPC_READ_SHORT_DATA  = 0x03,
+	MS_TPC_READ_REG         = 0x04,
+	MS_TPC_READ_IO_DATA     = 0x05, /* unverified */
+	MS_TPC_GET_INT          = 0x07,
+	MS_TPC_SET_RW_REG_ADRS  = 0x08,
+	MS_TPC_EX_SET_CMD       = 0x09,
+	MS_TPC_WRITE_IO_DATA    = 0x0a, /* unverified */
+	MS_TPC_WRITE_REG        = 0x0b,
+	MS_TPC_WRITE_SHORT_DATA = 0x0c,
+	MS_TPC_WRITE_LONG_DATA  = 0x0d,
+	MS_TPC_SET_CMD          = 0x0e
+};
+
+enum {
+	MS_CMD_BLOCK_END     = 0x33,
+	MS_CMD_RESET         = 0x3c,
+	MS_CMD_BLOCK_WRITE   = 0x55,
+	MS_CMD_SLEEP         = 0x5a,
+	MS_CMD_BLOCK_ERASE   = 0x99,
+	MS_CMD_BLOCK_READ    = 0xaa,
+	MS_CMD_CLEAR_BUF     = 0xc3,
+	MS_CMD_FLASH_STOP    = 0xcc,
+	MSPRO_CMD_FORMAT     = 0x10,
+	MSPRO_CMD_SLEEP      = 0x11,
+	MSPRO_CMD_READ_DATA  = 0x20,
+	MSPRO_CMD_WRITE_DATA = 0x21,
+	MSPRO_CMD_READ_ATRB  = 0x24,
+	MSPRO_CMD_STOP       = 0x25,
+	MSPRO_CMD_ERASE      = 0x26,
+	MSPRO_CMD_SET_IBA    = 0x46,
+	MSPRO_CMD_SET_IBD    = 0x47
+/*
+	MSPRO_CMD_RESET
+	MSPRO_CMD_WAKEUP
+	MSPRO_CMD_IN_IO_DATA
+	MSPRO_CMD_OUT_IO_DATA
+	MSPRO_CMD_READ_IO_ATRB
+	MSPRO_CMD_IN_IO_FIFO
+	MSPRO_CMD_OUT_IO_FIFO
+	MSPRO_CMD_IN_IOM
+	MSPRO_CMD_OUT_IOM
+*/
+};
+
+#define MEMSTICK_PART_SHIFT 3
+
+enum memstick_param { MEMSTICK_POWER = 1, MEMSTICK_INTERFACE };
+
+#define MEMSTICK_POWER_OFF 0
+#define MEMSTICK_POWER_ON  1
+
+#define MEMSTICK_SERIAL   0
+#define MEMSTICK_PARALLEL 1
+
+struct memstick_host;
+struct memstick_driver;
+
+#define MEMSTICK_MATCH_ALL            0x01
+
+#define MEMSTICK_TYPE_LEGACY          0xff
+#define MEMSTICK_TYPE_DUO             0x00
+#define MEMSTICK_TYPE_PRO             0x01
+
+#define MEMSTICK_CATEGORY_STORAGE     0xff
+#define MEMSTICK_CATEGORY_STORAGE_DUO 0x00
+
+#define MEMSTICK_CLASS_GENERIC        0xff
+#define MEMSTICK_CLASS_GENERIC_DUO    0x00
+
+
+struct memstick_device_id {
+	unsigned char match_flags;
+	unsigned char type;
+	unsigned char category;
+	unsigned char class;
+};
+
+struct memstick_request {
+	unsigned char tpc;
+	unsigned char data_dir:1,
+		      need_card_int:1,
+		      get_int_reg:1,
+		      io_type:2;
+#define               MEMSTICK_IO_NONE 0
+#define               MEMSTICK_IO_VAL  1
+#define               MEMSTICK_IO_SG   2
+
+	unsigned char int_reg;
+	int           error;
+	union {
+		struct scatterlist sg;
+		struct {
+			unsigned char data_len;
+			unsigned char data[15];
+		};
+	};
+};
+
+struct memstick_dev {
+	struct memstick_device_id id;
+	struct memstick_host     *host;
+	struct ms_register_addr  reg_addr;
+	struct completion        mrq_complete;
+	struct memstick_request  current_mrq;
+
+	int                      (*check)(struct memstick_dev *card);
+	int                      (*next_request)(struct memstick_dev *card,
+						 struct memstick_request **mrq);
+
+	struct device            dev;
+};
+
+struct memstick_host {
+	struct mutex        lock;
+	unsigned int        id;
+	unsigned int        caps;
+#define MEMSTICK_CAP_PARALLEL      1
+#define MEMSTICK_CAP_AUTO_GET_INT  2
+
+	struct work_struct  media_checker;
+	struct class_device cdev;
+
+	struct memstick_dev *card;
+	unsigned int        retries;
+
+	void                (*request)(struct memstick_host *host);
+	void                (*set_param)(struct memstick_host *host,
+					 enum memstick_param param,
+					 int value);
+	unsigned long       private[0] ____cacheline_aligned;
+};
+
+struct memstick_driver {
+	struct memstick_device_id *id_table;
+	int                       (*probe)(struct memstick_dev *card);
+	void                      (*remove)(struct memstick_dev *card);
+	int                       (*suspend)(struct memstick_dev *card,
+					     pm_message_t state);
+	int                       (*resume)(struct memstick_dev *card);
+
+	struct device_driver      driver;
+};
+
+int memstick_register_driver(struct memstick_driver *drv);
+void memstick_unregister_driver(struct memstick_driver *drv);
+
+struct memstick_host *memstick_alloc_host(unsigned int extra,
+					  struct device *dev);
+
+int memstick_add_host(struct memstick_host *host);
+void memstick_remove_host(struct memstick_host *host);
+void memstick_free_host(struct memstick_host *host);
+void memstick_detect_change(struct memstick_host *host);
+
+void memstick_init_req_sg(struct memstick_request *mrq, unsigned char tpc,
+			  struct scatterlist *sg);
+void memstick_init_req(struct memstick_request *mrq, unsigned char tpc,
+		       void *buf, size_t length);
+int memstick_next_req(struct memstick_host *host,
+		      struct memstick_request **mrq);
+void memstick_new_req(struct memstick_host *host);
+
+int memstick_set_rw_addr(struct memstick_dev *card);
+
+inline void *memstick_priv(struct memstick_host *host)
+{
+	return (void *)host->private;
+}
+
+inline void *memstick_get_drvdata(struct memstick_dev *card)
+{
+	return dev_get_drvdata(&card->dev);
+}
+
+inline void memstick_set_drvdata(struct memstick_dev *card, void *data)
+{
+	dev_set_drvdata(&card->dev, data);
+}
+
+#endif
diff -puN include/linux/tifm.h~memstick-initial-commit-for-sony-memorystick-support include/linux/tifm.h
--- a/include/linux/tifm.h~memstick-initial-commit-for-sony-memorystick-support
+++ a/include/linux/tifm.h
@@ -72,6 +72,7 @@ enum {
 #define TIFM_FIFO_READY           0x00000001
 #define TIFM_FIFO_INT_SETALL      0x0000ffff
 #define TIFM_FIFO_INTMASK         0x00000005
+#define TIFM_FIFO_SIZE            0x00000200
 
 #define TIFM_DMA_RESET            0x00000002
 #define TIFM_DMA_TX               0x00008000
@@ -124,6 +125,8 @@ struct tifm_adapter {
 
 	void                (*eject)(struct tifm_adapter *fm,
 				     struct tifm_dev *sock);
+	int                 (*has_ms_pif)(struct tifm_adapter *fm,
+					  struct tifm_dev *sock);
 
 	struct tifm_dev     *sockets[0];
 };
@@ -141,6 +144,7 @@ struct tifm_dev *tifm_alloc_device(struc
 int tifm_register_driver(struct tifm_driver *drv);
 void tifm_unregister_driver(struct tifm_driver *drv);
 void tifm_eject(struct tifm_dev *sock);
+int tifm_has_ms_pif(struct tifm_dev *sock);
 int tifm_map_sg(struct tifm_dev *sock, struct scatterlist *sg, int nents,
 		int direction);
 void tifm_unmap_sg(struct tifm_dev *sock, struct scatterlist *sg, int nents,
diff -puN MAINTAINERS~memstick-initial-commit-for-sony-memorystick-support MAINTAINERS
--- a/MAINTAINERS~memstick-initial-commit-for-sony-memorystick-support
+++ a/MAINTAINERS
@@ -3522,6 +3522,13 @@ L:	linux-acpi@vger.kernel.org
 W:	http://www.linux.it/~malattia/wiki/index.php/Sony_drivers
 S:	Maintained
 
+SONY MEMORYSTICK CARD SUPPORT
+P:	Alex Dubov
+M:	oakad@yahoo.com
+L:	linux-kernel@vger.kernel.org
+W:	http://tifmxx.berlios.de/
+S:	Maintained
+
 SOUND
 P:	Jaroslav Kysela
 M:	perex@perex.cz
_

Patches currently in -mm which might be from oakad@yahoo.com are

memstick-initial-commit-for-sony-memorystick-support.patch
