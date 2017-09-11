From: akpm@linux-foundation.org
Subject: [merged]
 mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v3.patch removed from
 -mm tree
Date: Mon, 11 Sep 2017 12:39:15 -0700
Message-ID: <20170911193915.MNOtkoxeP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48958 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbdIKTjR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:39:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, bsingharora@gmail.com, dan.j.williams@intel.com, dnellans@nvidia.com, ebaskakov@nvidia.com, hannes@cmpxchg.org, jglisse@redhat.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, liubo95@huawei.com, mhairgrove@nvidia.com, mhocko@kernel.org, mm-commits@vger.kernel.org, paulmck@linux.vnet.ibm.com, ross.zwisler@linux.intel.com, SCheung@nvidia.com, sgutti@nvidia.com, vdavydov.dev@gmail.com


The patch titled
     Subject: mm/hmm/devmem: dummy HMM device for ZONE_DEVICE memory
has been removed from the -mm tree.  Its filename was
     mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jérôme Glisse <jglisse@redhat.com>
Subject: mm/hmm/devmem: dummy HMM device for ZONE_DEVICE memory

This introduce a dummy HMM device class so device driver can use it to
create hmm_device for the sole purpose of registering device memory.  It
is useful to device driver that want to manage multiple physical device
memory under same struct device umbrella.

Link: http://lkml.kernel.org/r/20170817000548.32038-13-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Evgeny Baskakov <ebaskakov@nvidia.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Mark Hairgrove <mhairgrove@nvidia.com>
Signed-off-by: Sherry Cheung <SCheung@nvidia.com>
Signed-off-by: Subhash Gutti <sgutti@nvidia.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Nellans <dnellans@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Bob Liu <liubo95@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hmm.h |   22 ++++++++++-
 mm/hmm.c            |   81 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 102 insertions(+), 1 deletion(-)

diff -puN include/linux/hmm.h~mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v3 include/linux/hmm.h
--- a/include/linux/hmm.h~mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v3
+++ a/include/linux/hmm.h
@@ -72,11 +72,11 @@
 
 #if IS_ENABLED(CONFIG_HMM)
 
+#include <linux/device.h>
 #include <linux/migrate.h>
 #include <linux/memremap.h>
 #include <linux/completion.h>
 
-
 struct hmm;
 
 /*
@@ -474,6 +474,26 @@ static inline unsigned long hmm_devmem_p
 
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
+	unsigned int		minor;
+};
+
+/*
+ * A device driver that wants to handle multiple devices memory through a
+ * single fake device can use hmm_device to do so. This is purely a helper and
+ * it is not strictly needed, in order to make use of any HMM functionality.
+ */
+struct hmm_device *hmm_device_new(void *drvdata);
+void hmm_device_put(struct hmm_device *hmm_device);
 #endif /* IS_ENABLED(CONFIG_DEVICE_PRIVATE) */
 
 
diff -puN mm/hmm.c~mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v3 mm/hmm.c
--- a/mm/hmm.c~mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v3
+++ a/mm/hmm.c
@@ -19,6 +19,7 @@
  */
 #include <linux/mm.h>
 #include <linux/hmm.h>
+#include <linux/init.h>
 #include <linux/rmap.h>
 #include <linux/swap.h>
 #include <linux/slab.h>
@@ -1096,4 +1097,84 @@ void hmm_devmem_remove(struct hmm_devmem
 	devm_release_mem_region(device, start, size);
 }
 EXPORT_SYMBOL(hmm_devmem_remove);
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
+
+	hmm_device = kzalloc(sizeof(*hmm_device), GFP_KERNEL);
+	if (!hmm_device)
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock(&hmm_device_lock);
+	hmm_device->minor = find_first_zero_bit(hmm_device_mask, HMM_DEVICE_MAX);
+	if (hmm_device->minor >= HMM_DEVICE_MAX) {
+		spin_unlock(&hmm_device_lock);
+		kfree(hmm_device);
+		return ERR_PTR(-EBUSY);
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
+device_initcall(hmm_init);
 #endif /* IS_ENABLED(CONFIG_DEVICE_PRIVATE) */
_

Patches currently in -mm which might be from jglisse@redhat.com are


