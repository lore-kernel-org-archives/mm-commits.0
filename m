From: akpm@linux-foundation.org
Subject: + mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v2.patch
 added to -mm tree
Date: Thu, 16 Mar 2017 13:52:15 -0700
Message-ID: <58cafaff.eCrwjjRlqxBIz5sN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52822 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751663AbdCPVDs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2017 17:03:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, SCheung@nvidia.com, ebaskakov@nvidia.com, jhubbard@nvidia.com, mhairgrove@nvidia.com, sgutti@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm/devmem: dummy HMM device for ZONE_DEVICE memory
has been added to the -mm tree.  Its filename is
     mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jérôme Glisse <jglisse@redhat.com>
Subject: mm/hmm/devmem: dummy HMM device for ZONE_DEVICE memory

This introduces a dummy HMM device class so device driver can use it to
create hmm_device for the sole purpose of registering device memory.  It
is usefull to device driver that want to manage multiple physical device
memory under same struct device umbrella.

Link: http://lkml.kernel.org/r/1489680335-6594-17-git-send-email-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Evgeny Baskakov <ebaskakov@nvidia.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Mark Hairgrove <mhairgrove@nvidia.com>
Signed-off-by: Sherry Cheung <SCheung@nvidia.com>
Signed-off-by: Subhash Gutti <sgutti@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hmm.h |   22 +++++++++
 mm/hmm.c            |   96 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 117 insertions(+), 1 deletion(-)

diff -puN include/linux/hmm.h~mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v2 include/linux/hmm.h
--- a/include/linux/hmm.h~mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v2
+++ a/include/linux/hmm.h
@@ -79,11 +79,11 @@
 
 #if IS_ENABLED(CONFIG_HMM)
 
+#include <linux/device.h>
 #include <linux/migrate.h>
 #include <linux/memremap.h>
 #include <linux/completion.h>
 
-
 struct hmm;
 
 /*
@@ -433,6 +433,26 @@ static inline unsigned long hmm_devmem_p
 
 	return drvdata[1];
 }
+
+
+/*
+ * struct hmm_device - fake device to hang device memory onto
+ *
+ * @device: device struct
+ * @minor: device minor number
+ */
+struct hmm_device {
+	struct device		device;
+	unsigned		minor;
+};
+
+/*
+ * Device driver that wants to handle multiple devices memory through a single
+ * fake device can use hmm_device to do so. This is purely a helper and it
+ * is not needed to make use of any HMM functionality.
+ */
+struct hmm_device *hmm_device_new(void *drvdata);
+void hmm_device_put(struct hmm_device *hmm_device);
 #endif /* IS_ENABLED(CONFIG_HMM_DEVMEM) */
 
 
diff -puN mm/hmm.c~mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v2 mm/hmm.c
--- a/mm/hmm.c~mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v2
+++ a/mm/hmm.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/mmzone.h>
+#include <linux/module.h>
 #include <linux/pagemap.h>
 #include <linux/swapops.h>
 #include <linux/hugetlb.h>
@@ -1132,4 +1133,99 @@ int hmm_devmem_fault_range(struct hmm_de
 	return 0;
 }
 EXPORT_SYMBOL(hmm_devmem_fault_range);
+
+/*
+ * A device driver that wants to handle multiple devices memory through a
+ * single fake device can use hmm_device to do so. This is purely a helper
+ * and it is not needed to make use of any HMM functionality.
+ */
+#define HMM_DEVICE_MAX 256
+
+static DECLARE_BITMAP(hmm_device_mask, HMM_DEVICE_MAX);
+static DEFINE_SPINLOCK(hmm_device_lock);
+static struct class *hmm_device_class;
+static dev_t hmm_device_devt;
+
+static void hmm_device_release(struct device *device)
+{
+	struct hmm_device *hmm_device;
+
+	hmm_device = container_of(device, struct hmm_device, device);
+	spin_lock(&hmm_device_lock);
+	clear_bit(hmm_device->minor, hmm_device_mask);
+	spin_unlock(&hmm_device_lock);
+
+	kfree(hmm_device);
+}
+
+struct hmm_device *hmm_device_new(void *drvdata)
+{
+	struct hmm_device *hmm_device;
+	int ret;
+
+	hmm_device = kzalloc(sizeof(*hmm_device), GFP_KERNEL);
+	if (!hmm_device)
+		return ERR_PTR(-ENOMEM);
+
+	ret = alloc_chrdev_region(&hmm_device->device.devt,0,1,"hmm_device");
+	if (ret < 0) {
+		kfree(hmm_device);
+		return NULL;
+	}
+
+	spin_lock(&hmm_device_lock);
+	hmm_device->minor=find_first_zero_bit(hmm_device_mask,HMM_DEVICE_MAX);
+	if (hmm_device->minor >= HMM_DEVICE_MAX) {
+		spin_unlock(&hmm_device_lock);
+		kfree(hmm_device);
+		return NULL;
+	}
+	set_bit(hmm_device->minor, hmm_device_mask);
+	spin_unlock(&hmm_device_lock);
+
+	dev_set_name(&hmm_device->device, "hmm_device%d", hmm_device->minor);
+	hmm_device->device.devt = MKDEV(MAJOR(hmm_device_devt),
+					hmm_device->minor);
+	hmm_device->device.release = hmm_device_release;
+	dev_set_drvdata(&hmm_device->device, drvdata);
+	hmm_device->device.class = hmm_device_class;
+	device_initialize(&hmm_device->device);
+
+	return hmm_device;
+}
+EXPORT_SYMBOL(hmm_device_new);
+
+void hmm_device_put(struct hmm_device *hmm_device)
+{
+	put_device(&hmm_device->device);
+}
+EXPORT_SYMBOL(hmm_device_put);
+
+static int __init hmm_init(void)
+{
+	int ret;
+
+	ret = alloc_chrdev_region(&hmm_device_devt, 0,
+				  HMM_DEVICE_MAX,
+				  "hmm_device");
+	if (ret)
+		return ret;
+
+	hmm_device_class = class_create(THIS_MODULE, "hmm_device");
+	if (IS_ERR(hmm_device_class)) {
+		unregister_chrdev_region(hmm_device_devt, HMM_DEVICE_MAX);
+		return PTR_ERR(hmm_device_class);
+	}
+	return 0;
+}
+
+static void __exit hmm_exit(void)
+{
+	unregister_chrdev_region(hmm_device_devt, HMM_DEVICE_MAX);
+	class_destroy(hmm_device_class);
+}
+
+module_init(hmm_init);
+module_exit(hmm_exit);
+MODULE_LICENSE("GPL");
 #endif /* IS_ENABLED(CONFIG_HMM_DEVMEM) */
_

Patches currently in -mm which might be from jglisse@redhat.com are

mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3.patch
mm-put_page-move-ref-decrement-to-put_zone_device_page.patch
mm-zone_device-free-page-callback-when-page-is-freed-v3.patch
mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3.patch
mm-zone_device-x86-add-support-for-un-addressable-device-memory.patch
mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback.patch
mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v4.patch
mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages.patch
mm-hmm-heterogeneous-memory-management-hmm-for-short.patch
mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers.patch
mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v2.patch
mm-hmm-mirror-device-page-fault-handler.patch
mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration.patch
mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry.patch
mm-hmm-devmem-device-memory-hotplug-using-zone_device.patch
mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v2.patch

