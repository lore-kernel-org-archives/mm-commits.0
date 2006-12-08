From: akpm@osdl.org
Subject: - pktcdvd-reusability-of-procfs-functions.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:00:14 -0800
Message-ID: <200612082000.kB8K0Exs001717@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56564 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426198AbWLHUAY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:00:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balagi@justmail.de, petero2@telia.com, mm-commits@vger.kernel.org


The patch titled
     pktcdvd: reusability of procfs functions
has been removed from the -mm tree.  Its filename was
     pktcdvd-reusability-of-procfs-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pktcdvd: reusability of procfs functions
From: Thomas Maier <balagi@justmail.de>

This patch makes some of the procfs functions reusable (for
coming sysfs patch e.g.):
pkt_setup_dev()
pkt_remove_dev()
...

Signed-off-by: Thomas Maier <balagi@justmail.de>
Signed-off-by: Peter Osterlund <petero2@telia.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/pktcdvd.c |   72 +++++++++++++++++++++++---------------
 1 file changed, 45 insertions(+), 27 deletions(-)

diff -puN drivers/block/pktcdvd.c~pktcdvd-reusability-of-procfs-functions drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~pktcdvd-reusability-of-procfs-functions
+++ a/drivers/block/pktcdvd.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (C) 2000 Jens Axboe <axboe@suse.de>
  * Copyright (C) 2001-2004 Peter Osterlund <petero2@telia.com>
+ * Copyright (C) 2006 Thomas Maier <balagi@justmail.de>
  *
  * May be copied or modified under the terms of the GNU General Public
  * License.  See linux/COPYING for more information.
@@ -2436,36 +2437,33 @@ static struct block_device_operations pk
 /*
  * Set up mapping from pktcdvd device to CD-ROM device.
  */
-static int pkt_setup_dev(struct pkt_ctrl_command *ctrl_cmd)
+static int pkt_setup_dev(dev_t dev, dev_t* pkt_dev)
 {
 	int idx;
 	int ret = -ENOMEM;
 	struct pktcdvd_device *pd;
 	struct gendisk *disk;
-	dev_t dev = new_decode_dev(ctrl_cmd->dev);
+
+	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
 
 	for (idx = 0; idx < MAX_WRITERS; idx++)
 		if (!pkt_devs[idx])
 			break;
 	if (idx == MAX_WRITERS) {
 		printk(DRIVER_NAME": max %d writers supported\n", MAX_WRITERS);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto out_mutex;
 	}
 
 	pd = kzalloc(sizeof(struct pktcdvd_device), GFP_KERNEL);
 	if (!pd)
-		return ret;
+		goto out_mutex;
 
 	pd->rb_pool = mempool_create_kmalloc_pool(PKT_RB_POOL_SIZE,
 						  sizeof(struct pkt_rb_node));
 	if (!pd->rb_pool)
 		goto out_mem;
 
-	disk = alloc_disk(1);
-	if (!disk)
-		goto out_mem;
-	pd->disk = disk;
-
 	INIT_LIST_HEAD(&pd->cdrw.pkt_free_list);
 	INIT_LIST_HEAD(&pd->cdrw.pkt_active_list);
 	spin_lock_init(&pd->cdrw.active_list_lock);
@@ -2476,11 +2474,15 @@ static int pkt_setup_dev(struct pkt_ctrl
 	init_waitqueue_head(&pd->wqueue);
 	pd->bio_queue = RB_ROOT;
 
+	disk = alloc_disk(1);
+	if (!disk)
+		goto out_mem;
+	pd->disk = disk;
 	disk->major = pktdev_major;
 	disk->first_minor = idx;
 	disk->fops = &pktcdvd_ops;
 	disk->flags = GENHD_FL_REMOVABLE;
-	sprintf(disk->disk_name, DRIVER_NAME"%d", idx);
+	strcpy(disk->disk_name, pd->name);
 	disk->private_data = pd;
 	disk->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!disk->queue)
@@ -2492,8 +2494,12 @@ static int pkt_setup_dev(struct pkt_ctrl
 		goto out_new_dev;
 
 	add_disk(disk);
+
 	pkt_devs[idx] = pd;
-	ctrl_cmd->pkt_dev = new_encode_dev(pd->pkt_dev);
+	if (pkt_dev)
+		*pkt_dev = pd->pkt_dev;
+
+	mutex_unlock(&ctl_mutex);
 	return 0;
 
 out_new_dev:
@@ -2504,17 +2510,22 @@ out_mem:
 	if (pd->rb_pool)
 		mempool_destroy(pd->rb_pool);
 	kfree(pd);
+out_mutex:
+	mutex_unlock(&ctl_mutex);
+	printk(DRIVER_NAME": setup of pktcdvd device failed\n");
 	return ret;
 }
 
 /*
  * Tear down mapping from pktcdvd device to CD-ROM device.
  */
-static int pkt_remove_dev(struct pkt_ctrl_command *ctrl_cmd)
+static int pkt_remove_dev(dev_t pkt_dev)
 {
 	struct pktcdvd_device *pd;
 	int idx;
-	dev_t pkt_dev = new_decode_dev(ctrl_cmd->pkt_dev);
+	int ret = 0;
+
+	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
 
 	for (idx = 0; idx < MAX_WRITERS; idx++) {
 		pd = pkt_devs[idx];
@@ -2523,12 +2534,14 @@ static int pkt_remove_dev(struct pkt_ctr
 	}
 	if (idx == MAX_WRITERS) {
 		DPRINTK(DRIVER_NAME": dev not setup\n");
-		return -ENXIO;
+		ret = -ENXIO;
+		goto out;
 	}
 
-	if (pd->refcnt > 0)
-		return -EBUSY;
-
+	if (pd->refcnt > 0) {
+		ret = -EBUSY;
+		goto out;
+	}
 	if (!IS_ERR(pd->cdrw.thread))
 		kthread_stop(pd->cdrw.thread);
 
@@ -2547,12 +2560,19 @@ static int pkt_remove_dev(struct pkt_ctr
 
 	/* This is safe: open() is still holding a reference. */
 	module_put(THIS_MODULE);
-	return 0;
+
+out:
+	mutex_unlock(&ctl_mutex);
+	return ret;
 }
 
 static void pkt_get_status(struct pkt_ctrl_command *ctrl_cmd)
 {
-	struct pktcdvd_device *pd = pkt_find_dev_from_minor(ctrl_cmd->dev_index);
+	struct pktcdvd_device *pd;
+
+	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
+
+	pd = pkt_find_dev_from_minor(ctrl_cmd->dev_index);
 	if (pd) {
 		ctrl_cmd->dev = new_encode_dev(pd->bdev->bd_dev);
 		ctrl_cmd->pkt_dev = new_encode_dev(pd->pkt_dev);
@@ -2561,6 +2581,8 @@ static void pkt_get_status(struct pkt_ct
 		ctrl_cmd->pkt_dev = 0;
 	}
 	ctrl_cmd->num_devices = MAX_WRITERS;
+
+	mutex_unlock(&ctl_mutex);
 }
 
 static int pkt_ctl_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
@@ -2568,6 +2590,7 @@ static int pkt_ctl_ioctl(struct inode *i
 	void __user *argp = (void __user *)arg;
 	struct pkt_ctrl_command ctrl_cmd;
 	int ret = 0;
+	dev_t pkt_dev = 0;
 
 	if (cmd != PACKET_CTRL_CMD)
 		return -ENOTTY;
@@ -2579,21 +2602,16 @@ static int pkt_ctl_ioctl(struct inode *i
 	case PKT_CTRL_CMD_SETUP:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
-		mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
-		ret = pkt_setup_dev(&ctrl_cmd);
-		mutex_unlock(&ctl_mutex);
+		ret = pkt_setup_dev(new_decode_dev(ctrl_cmd.dev), &pkt_dev);
+		ctrl_cmd.pkt_dev = new_encode_dev(pkt_dev);
 		break;
 	case PKT_CTRL_CMD_TEARDOWN:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
-		mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
-		ret = pkt_remove_dev(&ctrl_cmd);
-		mutex_unlock(&ctl_mutex);
+		ret = pkt_remove_dev(new_decode_dev(ctrl_cmd.pkt_dev));
 		break;
 	case PKT_CTRL_CMD_STATUS:
-		mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
 		pkt_get_status(&ctrl_cmd);
-		mutex_unlock(&ctl_mutex);
 		break;
 	default:
 		return -ENOTTY;
_

Patches currently in -mm which might be from balagi@justmail.de are

origin.patch
pktcdvd-reusability-of-procfs-functions.patch
pktcdvd-make-procfs-interface-optional.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait.patch
pktcdvd-add-sysfs-and-debugfs-interface.patch

