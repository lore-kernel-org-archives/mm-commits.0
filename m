From: akpm@osdl.org
Subject: - s390-preparatory-cleanup-in-common-i-o-layer.patch removed from -mm tree
Date: Wed, 06 Dec 2006 14:23:35 -0800
Message-ID: <200612062223.kB6MNZ2c018542@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48324 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937736AbWLFWYU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 17:24:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cornelia.huck@de.ibm.com, greg@kroah.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390: Preparatory cleanup in common I/O layer
has been removed from the -mm tree.  Its filename was
     s390-preparatory-cleanup-in-common-i-o-layer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: s390: Preparatory cleanup in common I/O layer
From: Cornelia Huck <cornelia.huck@de.ibm.com>

Some preparations for the dynamic subchannel mapping patch.

- Move adding subchannel attributes to css_register_subchannel().
- Don't call device_trigger_reprobe() for non-operational devices.
- Introduce io_subchannel_create_ccwdev().

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/s390/cio/css.c        |   13 ++--
 drivers/s390/cio/css.h        |    2 
 drivers/s390/cio/device.c     |  102 +++++++++++++++++++-------------
 drivers/s390/cio/device_fsm.c |    3 
 4 files changed, 75 insertions(+), 45 deletions(-)

diff -puN drivers/s390/cio/css.c~s390-preparatory-cleanup-in-common-i-o-layer drivers/s390/cio/css.c
--- a/drivers/s390/cio/css.c~s390-preparatory-cleanup-in-common-i-o-layer
+++ a/drivers/s390/cio/css.c
@@ -135,14 +135,19 @@ css_register_subchannel(struct subchanne
 	sch->dev.parent = &css[0]->device;
 	sch->dev.bus = &css_bus_type;
 	sch->dev.release = &css_subchannel_release;
-	
+
 	/* make it known to the system */
 	ret = css_sch_device_register(sch);
-	if (ret)
+	if (ret) {
 		printk (KERN_WARNING "%s: could not register %s\n",
 			__func__, sch->dev.bus_id);
-	else
-		css_get_ssd_info(sch);
+		return ret;
+	}
+	css_get_ssd_info(sch);
+	ret = subchannel_add_files(&sch->dev);
+	if (ret)
+		printk(KERN_WARNING "%s: could not add attributes to %s\n",
+		       __func__, sch->dev.bus_id);
 	return ret;
 }
 
diff -puN drivers/s390/cio/css.h~s390-preparatory-cleanup-in-common-i-o-layer drivers/s390/cio/css.h
--- a/drivers/s390/cio/css.h~s390-preparatory-cleanup-in-common-i-o-layer
+++ a/drivers/s390/cio/css.h
@@ -187,4 +187,6 @@ extern int need_rescan;
 
 extern struct workqueue_struct *slow_path_wq;
 extern struct work_struct slow_path_work;
+
+int subchannel_add_files (struct device *);
 #endif
diff -puN drivers/s390/cio/device.c~s390-preparatory-cleanup-in-common-i-o-layer drivers/s390/cio/device.c
--- a/drivers/s390/cio/device.c~s390-preparatory-cleanup-in-common-i-o-layer
+++ a/drivers/s390/cio/device.c
@@ -294,6 +294,16 @@ online_show (struct device *dev, struct 
 	return sprintf(buf, cdev->online ? "1\n" : "0\n");
 }
 
+static void ccw_device_unregister(void *data)
+{
+	struct ccw_device *cdev;
+
+	cdev = (struct ccw_device *)data;
+	if (test_and_clear_bit(1, &cdev->private->registered))
+		device_unregister(&cdev->dev);
+	put_device(&cdev->dev);
+}
+
 static void
 ccw_device_remove_disconnected(struct ccw_device *cdev)
 {
@@ -498,8 +508,7 @@ static struct attribute_group subch_attr
 	.attrs = subch_attrs,
 };
 
-static inline int
-subchannel_add_files (struct device *dev)
+int subchannel_add_files (struct device *dev)
 {
 	return sysfs_create_group(&dev->kobj, &subch_attr_group);
 }
@@ -673,6 +682,54 @@ ccw_device_release(struct device *dev)
 	kfree(cdev);
 }
 
+static struct ccw_device * io_subchannel_allocate_dev(struct subchannel *sch)
+{
+	struct ccw_device *cdev;
+
+	cdev  = kzalloc(sizeof(*cdev), GFP_KERNEL);
+	if (cdev) {
+		cdev->private = kzalloc(sizeof(struct ccw_device_private),
+					GFP_KERNEL | GFP_DMA);
+		if (cdev->private)
+			return cdev;
+	}
+	kfree(cdev);
+	return ERR_PTR(-ENOMEM);
+}
+
+static int io_subchannel_initialize_dev(struct subchannel *sch,
+					struct ccw_device *cdev)
+{
+	atomic_set(&cdev->private->onoff, 0);
+	cdev->dev.parent = &sch->dev;
+	cdev->dev.release = ccw_device_release;
+	INIT_LIST_HEAD(&cdev->private->kick_work.entry);
+	/* Do first half of device_register. */
+	device_initialize(&cdev->dev);
+	if (!get_device(&sch->dev)) {
+		if (cdev->dev.release)
+			cdev->dev.release(&cdev->dev);
+		return -ENODEV;
+	}
+	return 0;
+}
+
+static struct ccw_device * io_subchannel_create_ccwdev(struct subchannel *sch)
+{
+	struct ccw_device *cdev;
+	int ret;
+
+	cdev = io_subchannel_allocate_dev(sch);
+	if (!IS_ERR(cdev)) {
+		ret = io_subchannel_initialize_dev(sch, cdev);
+		if (ret) {
+			kfree(cdev);
+			cdev = ERR_PTR(ret);
+		}
+	}
+	return cdev;
+}
+
 /*
  * Register recognized device.
  */
@@ -719,11 +776,6 @@ io_subchannel_register(void *data)
 			wake_up(&ccw_device_init_wq);
 		return;
 	}
-
-	ret = subchannel_add_files(cdev->dev.parent);
-	if (ret)
-		printk(KERN_WARNING "%s: could not add attributes to %s\n",
-		       __func__, sch->dev.bus_id);
 	put_device(&cdev->dev);
 out:
 	cdev->private->flags.recog_done = 1;
@@ -843,7 +895,6 @@ io_subchannel_probe (struct subchannel *
 		cdev = sch->dev.driver_data;
 		device_initialize(&cdev->dev);
 		ccw_device_register(cdev);
-		subchannel_add_files(&sch->dev);
 		/*
 		 * Check if the device is already online. If it is
 		 * the reference count needs to be corrected
@@ -856,27 +907,9 @@ io_subchannel_probe (struct subchannel *
 			get_device(&cdev->dev);
 		return 0;
 	}
-	cdev = kzalloc (sizeof(*cdev), GFP_KERNEL);
-	if (!cdev)
-		return -ENOMEM;
-	cdev->private = kzalloc(sizeof(struct ccw_device_private),
-				GFP_KERNEL | GFP_DMA);
-	if (!cdev->private) {
-		kfree(cdev);
-		return -ENOMEM;
-	}
-	atomic_set(&cdev->private->onoff, 0);
-	cdev->dev.parent = &sch->dev;
-	cdev->dev.release = ccw_device_release;
-	INIT_LIST_HEAD(&cdev->private->kick_work.entry);
-	/* Do first half of device_register. */
-	device_initialize(&cdev->dev);
-
-	if (!get_device(&sch->dev)) {
-		if (cdev->dev.release)
-			cdev->dev.release(&cdev->dev);
-		return -ENODEV;
-	}
+	cdev = io_subchannel_create_ccwdev(sch);
+	if (IS_ERR(cdev))
+		return PTR_ERR(cdev);
 
 	rc = io_subchannel_recog(cdev, sch);
 	if (rc) {
@@ -890,17 +923,6 @@ io_subchannel_probe (struct subchannel *
 	return rc;
 }
 
-static void
-ccw_device_unregister(void *data)
-{
-	struct ccw_device *cdev;
-
-	cdev = (struct ccw_device *)data;
-	if (test_and_clear_bit(1, &cdev->private->registered))
-		device_unregister(&cdev->dev);
-	put_device(&cdev->dev);
-}
-
 static int
 io_subchannel_remove (struct subchannel *sch)
 {
diff -puN drivers/s390/cio/device_fsm.c~s390-preparatory-cleanup-in-common-i-o-layer drivers/s390/cio/device_fsm.c
--- a/drivers/s390/cio/device_fsm.c~s390-preparatory-cleanup-in-common-i-o-layer
+++ a/drivers/s390/cio/device_fsm.c
@@ -1104,7 +1104,8 @@ device_trigger_reprobe(struct subchannel
 	/* Update some values. */
 	if (stsch(sch->schid, &sch->schib))
 		return;
-
+	if (!sch->schib.pmcw.dnv)
+		return;
 	/*
 	 * The pim, pam, pom values may not be accurate, but they are the best
 	 * we have before performing device selection :/
_

Patches currently in -mm which might be from cornelia.huck@de.ibm.com are

origin.patch
driver-core-per-subsystem-multithreaded-probing.patch
driver-core-dont-fail-attaching-the-device-if-it.patch
git-s390.patch
tty-switch-to-ktermios-sclp-fix.patch

