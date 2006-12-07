From: akpm@osdl.org
Subject: - hvcs-char-driver-janitoring-move-block-of-code.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:05:22 -0800
Message-ID: <200612072305.kB7N5MEU030149@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52935 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163834AbWLGXJF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:09:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linas@austin.ibm.com, michael@ellerman.id.au, rsa@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     HVCS char driver janitoring: move block of code
has been removed from the -mm tree.  Its filename was
     hvcs-char-driver-janitoring-move-block-of-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: HVCS char driver janitoring: move block of code
From: Linas Vepstas <linas@austin.ibm.com>

Move a block of code from the bottom of the file to the top, which is needed
to enable the cleanup.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: Ryan S. Arnold <rsa@us.ibm.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/hvcs.c |  426 ++++++++++++++++++++----------------------
 1 file changed, 210 insertions(+), 216 deletions(-)

diff -puN drivers/char/hvcs.c~hvcs-char-driver-janitoring-move-block-of-code drivers/char/hvcs.c
--- a/drivers/char/hvcs.c~hvcs-char-driver-janitoring-move-block-of-code
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
@@ -353,6 +348,172 @@ static void __exit hvcs_module_exit(void
 #define HVCS_TRY_WRITE	0x00000004
 #define HVCS_READ_MASK	(HVCS_SCHED_READ | HVCS_QUICK_READ)
 
+static inline struct hvcs_struct *from_vio_dev(struct vio_dev *viod)
+{
+	return viod->dev.driver_data;
+}
+/* The sysfs interface for the driver and devices */
+
+static ssize_t hvcs_partner_vtys_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct vio_dev *viod = to_vio_dev(dev);
+	struct hvcs_struct *hvcsd = from_vio_dev(viod);
+	unsigned long flags;
+	int retval;
+
+	spin_lock_irqsave(&hvcsd->lock, flags);
+	retval = sprintf(buf, "%X\n", hvcsd->p_unit_address);
+	spin_unlock_irqrestore(&hvcsd->lock, flags);
+	return retval;
+}
+static DEVICE_ATTR(partner_vtys, S_IRUGO, hvcs_partner_vtys_show, NULL);
+
+static ssize_t hvcs_partner_clcs_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct vio_dev *viod = to_vio_dev(dev);
+	struct hvcs_struct *hvcsd = from_vio_dev(viod);
+	unsigned long flags;
+	int retval;
+
+	spin_lock_irqsave(&hvcsd->lock, flags);
+	retval = sprintf(buf, "%s\n", &hvcsd->p_location_code[0]);
+	spin_unlock_irqrestore(&hvcsd->lock, flags);
+	return retval;
+}
+static DEVICE_ATTR(partner_clcs, S_IRUGO, hvcs_partner_clcs_show, NULL);
+
+static ssize_t hvcs_current_vty_store(struct device *dev, struct device_attribute *attr, const char * buf,
+		size_t count)
+{
+	/*
+	 * Don't need this feature at the present time because firmware doesn't
+	 * yet support multiple partners.
+	 */
+	printk(KERN_INFO "HVCS: Denied current_vty change: -EPERM.\n");
+	return -EPERM;
+}
+
+static ssize_t hvcs_current_vty_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct vio_dev *viod = to_vio_dev(dev);
+	struct hvcs_struct *hvcsd = from_vio_dev(viod);
+	unsigned long flags;
+	int retval;
+
+	spin_lock_irqsave(&hvcsd->lock, flags);
+	retval = sprintf(buf, "%s\n", &hvcsd->p_location_code[0]);
+	spin_unlock_irqrestore(&hvcsd->lock, flags);
+	return retval;
+}
+
+static DEVICE_ATTR(current_vty,
+	S_IRUGO | S_IWUSR, hvcs_current_vty_show, hvcs_current_vty_store);
+
+static ssize_t hvcs_vterm_state_store(struct device *dev, struct device_attribute *attr, const char *buf,
+		size_t count)
+{
+	struct vio_dev *viod = to_vio_dev(dev);
+	struct hvcs_struct *hvcsd = from_vio_dev(viod);
+	unsigned long flags;
+
+	/* writing a '0' to this sysfs entry will result in the disconnect. */
+	if (simple_strtol(buf, NULL, 0) != 0)
+		return -EINVAL;
+
+	spin_lock_irqsave(&hvcsd->lock, flags);
+
+	if (hvcsd->open_count > 0) {
+		spin_unlock_irqrestore(&hvcsd->lock, flags);
+		printk(KERN_INFO "HVCS: vterm state unchanged.  "
+				"The hvcs device node is still in use.\n");
+		return -EPERM;
+	}
+
+	if (hvcsd->connected == 0) {
+		spin_unlock_irqrestore(&hvcsd->lock, flags);
+		printk(KERN_INFO "HVCS: vterm state unchanged. The"
+				" vty-server is not connected to a vty.\n");
+		return -EPERM;
+	}
+
+	hvcs_partner_free(hvcsd);
+	printk(KERN_INFO "HVCS: Closed vty-server@%X and"
+			" partner vty@%X:%d connection.\n",
+			hvcsd->vdev->unit_address,
+			hvcsd->p_unit_address,
+			(uint32_t)hvcsd->p_partition_ID);
+
+	spin_unlock_irqrestore(&hvcsd->lock, flags);
+	return count;
+}
+
+static ssize_t hvcs_vterm_state_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct vio_dev *viod = to_vio_dev(dev);
+	struct hvcs_struct *hvcsd = from_vio_dev(viod);
+	unsigned long flags;
+	int retval;
+
+	spin_lock_irqsave(&hvcsd->lock, flags);
+	retval = sprintf(buf, "%d\n", hvcsd->connected);
+	spin_unlock_irqrestore(&hvcsd->lock, flags);
+	return retval;
+}
+static DEVICE_ATTR(vterm_state, S_IRUGO | S_IWUSR,
+		hvcs_vterm_state_show, hvcs_vterm_state_store);
+
+static ssize_t hvcs_index_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct vio_dev *viod = to_vio_dev(dev);
+	struct hvcs_struct *hvcsd = from_vio_dev(viod);
+	unsigned long flags;
+	int retval;
+
+	spin_lock_irqsave(&hvcsd->lock, flags);
+	retval = sprintf(buf, "%d\n", hvcsd->index);
+	spin_unlock_irqrestore(&hvcsd->lock, flags);
+	return retval;
+}
+
+static DEVICE_ATTR(index, S_IRUGO, hvcs_index_show, NULL);
+
+static struct attribute *hvcs_attrs[] = {
+	&dev_attr_partner_vtys.attr,
+	&dev_attr_partner_clcs.attr,
+	&dev_attr_current_vty.attr,
+	&dev_attr_vterm_state.attr,
+	&dev_attr_index.attr,
+	NULL,
+};
+
+static struct attribute_group hvcs_attr_group = {
+	.attrs = hvcs_attrs,
+};
+
+static ssize_t hvcs_rescan_show(struct device_driver *ddp, char *buf)
+{
+	/* A 1 means it is updating, a 0 means it is done updating */
+	return snprintf(buf, PAGE_SIZE, "%d\n", hvcs_rescan_status);
+}
+
+static ssize_t hvcs_rescan_store(struct device_driver *ddp, const char * buf,
+		size_t count)
+{
+	if ((simple_strtol(buf, NULL, 0) != 1)
+		&& (hvcs_rescan_status != 0))
+		return -EINVAL;
+
+	hvcs_rescan_status = 1;
+	printk(KERN_INFO "HVCS: rescanning partner info for all"
+		" vty-servers.\n");
+	hvcs_rescan_devices_list();
+	hvcs_rescan_status = 0;
+	return count;
+}
+
+static DRIVER_ATTR(rescan,
+	S_IRUGO | S_IWUSR, hvcs_rescan_show, hvcs_rescan_store);
+
 static void hvcs_kick(void)
 {
 	hvcs_kicked = 1;
@@ -575,7 +736,7 @@ static void destroy_hvcs_struct(struct k
 	spin_unlock_irqrestore(&hvcsd->lock, flags);
 	spin_unlock(&hvcs_structs_lock);
 
-	hvcs_remove_device_attrs(vdev);
+	sysfs_remove_group(&vdev->dev.kobj, &hvcs_attr_group);
 
 	kfree(hvcsd);
 }
@@ -608,6 +769,7 @@ static int __devinit hvcs_probe(
 {
 	struct hvcs_struct *hvcsd;
 	int index;
+	int retval;
 
 	if (!dev || !id) {
 		printk(KERN_ERR "HVCS: probed with invalid parameter.\n");
@@ -658,14 +820,16 @@ static int __devinit hvcs_probe(
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
 
@@ -1354,8 +1518,10 @@ static int __init hvcs_module_init(void)
 	if (!hvcs_tty_driver)
 		return -ENOMEM;
 
-	if (hvcs_alloc_index_list(num_ttys_to_alloc))
-		return -ENOMEM;
+	if (hvcs_alloc_index_list(num_ttys_to_alloc)) {
+		rc = -ENOMEM;
+		goto index_fail;
+	}
 
 	hvcs_tty_driver->owner = THIS_MODULE;
 
@@ -1385,41 +1551,57 @@ static int __init hvcs_module_init(void)
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
 
@@ -1441,7 +1623,7 @@ static void __exit hvcs_module_exit(void
 	hvcs_pi_buff = NULL;
 	spin_unlock(&hvcs_pi_lock);
 
-	hvcs_remove_driver_attrs();
+	driver_remove_file(&hvcs_vio_driver.driver, &driver_attr_rescan);
 
 	vio_unregister_driver(&hvcs_vio_driver);
 
@@ -1456,191 +1638,3 @@ static void __exit hvcs_module_exit(void
 
 module_init(hvcs_module_init);
 module_exit(hvcs_module_exit);
-
-static inline struct hvcs_struct *from_vio_dev(struct vio_dev *viod)
-{
-	return viod->dev.driver_data;
-}
-/* The sysfs interface for the driver and devices */
-
-static ssize_t hvcs_partner_vtys_show(struct device *dev, struct device_attribute *attr, char *buf)
-{
-	struct vio_dev *viod = to_vio_dev(dev);
-	struct hvcs_struct *hvcsd = from_vio_dev(viod);
-	unsigned long flags;
-	int retval;
-
-	spin_lock_irqsave(&hvcsd->lock, flags);
-	retval = sprintf(buf, "%X\n", hvcsd->p_unit_address);
-	spin_unlock_irqrestore(&hvcsd->lock, flags);
-	return retval;
-}
-static DEVICE_ATTR(partner_vtys, S_IRUGO, hvcs_partner_vtys_show, NULL);
-
-static ssize_t hvcs_partner_clcs_show(struct device *dev, struct device_attribute *attr, char *buf)
-{
-	struct vio_dev *viod = to_vio_dev(dev);
-	struct hvcs_struct *hvcsd = from_vio_dev(viod);
-	unsigned long flags;
-	int retval;
-
-	spin_lock_irqsave(&hvcsd->lock, flags);
-	retval = sprintf(buf, "%s\n", &hvcsd->p_location_code[0]);
-	spin_unlock_irqrestore(&hvcsd->lock, flags);
-	return retval;
-}
-static DEVICE_ATTR(partner_clcs, S_IRUGO, hvcs_partner_clcs_show, NULL);
-
-static ssize_t hvcs_current_vty_store(struct device *dev, struct device_attribute *attr, const char * buf,
-		size_t count)
-{
-	/*
-	 * Don't need this feature at the present time because firmware doesn't
-	 * yet support multiple partners.
-	 */
-	printk(KERN_INFO "HVCS: Denied current_vty change: -EPERM.\n");
-	return -EPERM;
-}
-
-static ssize_t hvcs_current_vty_show(struct device *dev, struct device_attribute *attr, char *buf)
-{
-	struct vio_dev *viod = to_vio_dev(dev);
-	struct hvcs_struct *hvcsd = from_vio_dev(viod);
-	unsigned long flags;
-	int retval;
-
-	spin_lock_irqsave(&hvcsd->lock, flags);
-	retval = sprintf(buf, "%s\n", &hvcsd->p_location_code[0]);
-	spin_unlock_irqrestore(&hvcsd->lock, flags);
-	return retval;
-}
-
-static DEVICE_ATTR(current_vty,
-	S_IRUGO | S_IWUSR, hvcs_current_vty_show, hvcs_current_vty_store);
-
-static ssize_t hvcs_vterm_state_store(struct device *dev, struct device_attribute *attr, const char *buf,
-		size_t count)
-{
-	struct vio_dev *viod = to_vio_dev(dev);
-	struct hvcs_struct *hvcsd = from_vio_dev(viod);
-	unsigned long flags;
-
-	/* writing a '0' to this sysfs entry will result in the disconnect. */
-	if (simple_strtol(buf, NULL, 0) != 0)
-		return -EINVAL;
-
-	spin_lock_irqsave(&hvcsd->lock, flags);
-
-	if (hvcsd->open_count > 0) {
-		spin_unlock_irqrestore(&hvcsd->lock, flags);
-		printk(KERN_INFO "HVCS: vterm state unchanged.  "
-				"The hvcs device node is still in use.\n");
-		return -EPERM;
-	}
-
-	if (hvcsd->connected == 0) {
-		spin_unlock_irqrestore(&hvcsd->lock, flags);
-		printk(KERN_INFO "HVCS: vterm state unchanged. The"
-				" vty-server is not connected to a vty.\n");
-		return -EPERM;
-	}
-
-	hvcs_partner_free(hvcsd);
-	printk(KERN_INFO "HVCS: Closed vty-server@%X and"
-			" partner vty@%X:%d connection.\n",
-			hvcsd->vdev->unit_address,
-			hvcsd->p_unit_address,
-			(uint32_t)hvcsd->p_partition_ID);
-
-	spin_unlock_irqrestore(&hvcsd->lock, flags);
-	return count;
-}
-
-static ssize_t hvcs_vterm_state_show(struct device *dev, struct device_attribute *attr, char *buf)
-{
-	struct vio_dev *viod = to_vio_dev(dev);
-	struct hvcs_struct *hvcsd = from_vio_dev(viod);
-	unsigned long flags;
-	int retval;
-
-	spin_lock_irqsave(&hvcsd->lock, flags);
-	retval = sprintf(buf, "%d\n", hvcsd->connected);
-	spin_unlock_irqrestore(&hvcsd->lock, flags);
-	return retval;
-}
-static DEVICE_ATTR(vterm_state, S_IRUGO | S_IWUSR,
-		hvcs_vterm_state_show, hvcs_vterm_state_store);
-
-static ssize_t hvcs_index_show(struct device *dev, struct device_attribute *attr, char *buf)
-{
-	struct vio_dev *viod = to_vio_dev(dev);
-	struct hvcs_struct *hvcsd = from_vio_dev(viod);
-	unsigned long flags;
-	int retval;
-
-	spin_lock_irqsave(&hvcsd->lock, flags);
-	retval = sprintf(buf, "%d\n", hvcsd->index);
-	spin_unlock_irqrestore(&hvcsd->lock, flags);
-	return retval;
-}
-
-static DEVICE_ATTR(index, S_IRUGO, hvcs_index_show, NULL);
-
-static struct attribute *hvcs_attrs[] = {
-	&dev_attr_partner_vtys.attr,
-	&dev_attr_partner_clcs.attr,
-	&dev_attr_current_vty.attr,
-	&dev_attr_vterm_state.attr,
-	&dev_attr_index.attr,
-	NULL,
-};
-
-static struct attribute_group hvcs_attr_group = {
-	.attrs = hvcs_attrs,
-};
-
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
-static ssize_t hvcs_rescan_show(struct device_driver *ddp, char *buf)
-{
-	/* A 1 means it is updating, a 0 means it is done updating */
-	return snprintf(buf, PAGE_SIZE, "%d\n", hvcs_rescan_status);
-}
-
-static ssize_t hvcs_rescan_store(struct device_driver *ddp, const char * buf,
-		size_t count)
-{
-	if ((simple_strtol(buf, NULL, 0) != 1)
-		&& (hvcs_rescan_status != 0))
-		return -EINVAL;
-
-	hvcs_rescan_status = 1;
-	printk(KERN_INFO "HVCS: rescanning partner info for all"
-		" vty-servers.\n");
-	hvcs_rescan_devices_list();
-	hvcs_rescan_status = 0;
-	return count;
-}
-static DRIVER_ATTR(rescan,
-	S_IRUGO | S_IWUSR, hvcs_rescan_show, hvcs_rescan_store);
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
spidernet-dma-coalescing.patch
spidernet-add-net_ratelimit-to-suppress-long-output.patch
spidernet-rx-locking.patch
spidernet-refactor-rx-refill.patch
spidernet-rx-skb-mem-leak.patch
spidernet-another-skb-mem-leak.patch
spidernet-cleanup-return-codes.patch
spidernet-rx-refill.patch
spidernet-merge-error-branches.patch
spidernet-remove-unused-variable.patch
spidernet-rx-chain-tail.patch
spidernet-turn-rx-irq-back-on.patch
spidernet-memory-barrier.patch
spidernet-avoid-possible-rx-chain-corruption.patch
spidernet-rx-debugging-printout.patch
spidernet-rework-rx-linked-list.patch

