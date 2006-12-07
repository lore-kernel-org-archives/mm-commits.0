From: akpm@osdl.org
Subject: - hvcs-char-driver-janitoring-rm-compiler-warnings.patch removed from -mm tree
Date: Wed, 06 Dec 2006 19:32:27 -0800
Message-ID: <200612070332.kB73WRSb027459@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:42760 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968013AbWLGDdJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 22:33:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linas@austin.ibm.com, michael@ellerman.id.au, rsa@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     HVCS char driver janitoring: rm compiler warnings
has been removed from the -mm tree.  Its filename was
     hvcs-char-driver-janitoring-rm-compiler-warnings.patch

This patch was dropped because it was folded into hvcs-char-driver-janitoring-move-block-of-code.patch

------------------------------------------------------
Subject: HVCS char driver janitoring: rm compiler warnings
From: Linas Vepstas <linas@austin.ibm.com>

drivers/char/hvcs.c:1605: warning: ignoring return value of sysfs_create_group declared with attribute warn_unused_result
drivers/char/hvcs.c:1639: warning: ignoring return value of driver_create_file declared with attribute warn_unused_result

This is done primarily by restructuring the module_init error handling code.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: Ryan S. Arnold <rsa@us.ibm.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/hvcs.c |   95 +++++++++++++++++++-----------------------
 1 file changed, 44 insertions(+), 51 deletions(-)

diff -puN drivers/char/hvcs.c~hvcs-char-driver-janitoring-rm-compiler-warnings drivers/char/hvcs.c
--- a/drivers/char/hvcs.c~hvcs-char-driver-janitoring-rm-compiler-warnings
+++ a/drivers/char/hvcs.c
@@ -337,11 +337,6 @@ static int hvcs_open(struct tty_struct *
 static void hvcs_close(struct tty_struct *tty, struct file *filp);
 static void hvcs_hangup(struct tty_struct * tty);
 
-static void hvcs_create_device_attrs(struct hvcs_struct *hvcsd);
-static void hvcs_remove_device_attrs(struct vio_dev *vdev);
-static void hvcs_create_driver_attrs(void);
-static void hvcs_remove_driver_attrs(void);
-
 static int __devinit hvcs_probe(struct vio_dev *dev,
 		const struct vio_device_id *id);
 static int __devexit hvcs_remove(struct vio_dev *dev);
@@ -495,17 +490,6 @@ static struct attribute_group hvcs_attr_
 	.attrs = hvcs_attrs,
 };
 
-static void hvcs_create_device_attrs(struct hvcs_struct *hvcsd)
-{
-	struct vio_dev *vdev = hvcsd->vdev;
-	sysfs_create_group(&vdev->dev.kobj, &hvcs_attr_group);
-}
-
-static void hvcs_remove_device_attrs(struct vio_dev *vdev)
-{
-	sysfs_remove_group(&vdev->dev.kobj, &hvcs_attr_group);
-}
-
 static ssize_t hvcs_rescan_show(struct device_driver *ddp, char *buf)
 {
 	/* A 1 means it is updating, a 0 means it is done updating */
@@ -752,7 +736,7 @@ static void destroy_hvcs_struct(struct k
 	spin_unlock_irqrestore(&hvcsd->lock, flags);
 	spin_unlock(&hvcs_structs_lock);
 
-	hvcs_remove_device_attrs(vdev);
+	sysfs_remove_group(&vdev->dev.kobj, &hvcs_attr_group);
 
 	kfree(hvcsd);
 }
@@ -785,6 +769,7 @@ static int __devinit hvcs_probe(
 {
 	struct hvcs_struct *hvcsd;
 	int index;
+	int retval;
 
 	if (!dev || !id) {
 		printk(KERN_ERR "HVCS: probed with invalid parameter.\n");
@@ -835,14 +820,16 @@ static int __devinit hvcs_probe(
 	 * the hvcs_struct has been added to the devices list then the user app
 	 * will get -ENODEV.
 	 */
-
 	spin_lock(&hvcs_structs_lock);
-
 	list_add_tail(&(hvcsd->next), &hvcs_structs);
-
 	spin_unlock(&hvcs_structs_lock);
 
-	hvcs_create_device_attrs(hvcsd);
+	retval = sysfs_create_group(&dev->dev.kobj, &hvcs_attr_group);
+	if (retval) {
+		printk(KERN_ERR "HVCS: Can't create sysfs attrs for vty-server@%X\n",
+		       hvcsd->vdev->unit_address);
+		return retval;
+	}
 
 	printk(KERN_INFO "HVCS: vty-server@%X added to the vio bus.\n", dev->unit_address);
 
@@ -1531,8 +1518,10 @@ static int __init hvcs_module_init(void)
 	if (!hvcs_tty_driver)
 		return -ENOMEM;
 
-	if (hvcs_alloc_index_list(num_ttys_to_alloc))
-		return -ENOMEM;
+	if (hvcs_alloc_index_list(num_ttys_to_alloc)) {
+		rc = -ENOMEM;
+		goto index_fail;
+	}
 
 	hvcs_tty_driver->owner = THIS_MODULE;
 
@@ -1562,41 +1551,57 @@ static int __init hvcs_module_init(void)
 	 * dynamically assigned major and minor numbers for our devices.
 	 */
 	if (tty_register_driver(hvcs_tty_driver)) {
-		printk(KERN_ERR "HVCS: registration "
-			" as a tty driver failed.\n");
-		hvcs_free_index_list();
-		put_tty_driver(hvcs_tty_driver);
-		return -EIO;
+		printk(KERN_ERR "HVCS: registration as a tty driver failed.\n");
+		rc = -EIO;
+		goto register_fail;
 	}
 
 	hvcs_pi_buff = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!hvcs_pi_buff) {
-		tty_unregister_driver(hvcs_tty_driver);
-		hvcs_free_index_list();
-		put_tty_driver(hvcs_tty_driver);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto buff_alloc_fail;
 	}
 
 	hvcs_task = kthread_run(khvcsd, NULL, "khvcsd");
 	if (IS_ERR(hvcs_task)) {
 		printk(KERN_ERR "HVCS: khvcsd creation failed.  Driver not loaded.\n");
-		kfree(hvcs_pi_buff);
-		tty_unregister_driver(hvcs_tty_driver);
-		hvcs_free_index_list();
-		put_tty_driver(hvcs_tty_driver);
-		return -EIO;
+		rc = -EIO;
+		goto kthread_fail;
 	}
 
 	rc = vio_register_driver(&hvcs_vio_driver);
+	if (rc) {
+		printk(KERN_ERR "HVCS: can't register vio driver\n");
+		goto vio_fail;
+	}
 
 	/*
 	 * This needs to be done AFTER the vio_register_driver() call or else
 	 * the kobjects won't be initialized properly.
 	 */
-	hvcs_create_driver_attrs();
+	rc = driver_create_file(&(hvcs_vio_driver.driver), &driver_attr_rescan);
+	if (rc) {
+		printk(KERN_ERR "HVCS: sysfs attr create failed\n");
+		goto attr_fail;
+	}
 
 	printk(KERN_INFO "HVCS: driver module inserted.\n");
 
+	return 0;
+
+attr_fail:
+	vio_unregister_driver(&hvcs_vio_driver);
+vio_fail:
+	kthread_stop(hvcs_task);
+kthread_fail:
+	kfree(hvcs_pi_buff);
+buff_alloc_fail:
+	tty_unregister_driver(hvcs_tty_driver);
+register_fail:
+	hvcs_free_index_list();
+index_fail:
+	put_tty_driver(hvcs_tty_driver);
+	hvcs_tty_driver = NULL;
 	return rc;
 }
 
@@ -1618,7 +1623,7 @@ static void __exit hvcs_module_exit(void
 	hvcs_pi_buff = NULL;
 	spin_unlock(&hvcs_pi_lock);
 
-	hvcs_remove_driver_attrs();
+	driver_remove_file(&hvcs_vio_driver.driver, &driver_attr_rescan);
 
 	vio_unregister_driver(&hvcs_vio_driver);
 
@@ -1633,15 +1638,3 @@ static void __exit hvcs_module_exit(void
 
 module_init(hvcs_module_init);
 module_exit(hvcs_module_exit);
-
-static void hvcs_create_driver_attrs(void)
-{
-	struct device_driver *driverfs = &(hvcs_vio_driver.driver);
-	driver_create_file(driverfs, &driver_attr_rescan);
-}
-
-static void hvcs_remove_driver_attrs(void)
-{
-	struct device_driver *driverfs = &(hvcs_vio_driver.driver);
-	driver_remove_file(driverfs, &driver_attr_rescan);
-}
_

Patches currently in -mm which might be from linas@austin.ibm.com are

origin.patch
hvcs-char-driver-janitoring-move-block-of-code.patch
hvcs-char-driver-janitoring-rm-compiler-warnings.patch

