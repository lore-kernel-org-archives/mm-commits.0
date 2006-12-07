From: akpm@osdl.org
Subject: - cciss-add-support-for-1024-logical-volumes.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:00:37 -0800
Message-ID: <200612072300.kB7N0bkZ029661@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51317 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163740AbWLGXA4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:00:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.miller@hp.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cciss: add support for 1024 logical volumes
has been removed from the -mm tree.  Its filename was
     cciss-add-support-for-1024-logical-volumes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cciss: add support for 1024 logical volumes
From: Mike Miller <mike.miller@hp.com>

Add the support for a large number of logical volumes.  We will soon have
hardware that support up to 1024 logical volumes.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/cciss.c       |  114 ++++++++++++++++++++++------------
 drivers/block/cciss.h       |    3 
 drivers/block/cciss_cmd.h   |    2 
 include/linux/cciss_ioctl.h |    2 
 4 files changed, 80 insertions(+), 41 deletions(-)

diff -puN drivers/block/cciss.c~cciss-add-support-for-1024-logical-volumes drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-add-support-for-1024-logical-volumes
+++ a/drivers/block/cciss.c
@@ -1315,6 +1315,11 @@ static void cciss_update_drive_info(int 
 	/* if it's the controller it's already added */
 	if (drv_index) {
 		disk->queue = blk_init_queue(do_cciss_request, &h->lock);
+		sprintf(disk->disk_name, "cciss/c%dd%d", ctlr, drv_index);
+		disk->major = h->major;
+		disk->first_minor = drv_index << NWD_SHIFT;
+		disk->fops = &cciss_fops;
+		disk->private_data = &h->drv[drv_index];
 
 		/* Set up queue information */
 		disk->queue->backing_dev_info.ra_pages = READ_AHEAD;
@@ -1393,11 +1398,6 @@ static int rebuild_lun_table(ctlr_info_t
 
 	/* Set busy_configuring flag for this operation */
 	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
-	if (h->num_luns >= CISS_MAX_LUN) {
-		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
-		return -EINVAL;
-	}
-
 	if (h->busy_configuring) {
 		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
 		return -EBUSY;
@@ -1430,17 +1430,8 @@ static int rebuild_lun_table(ctlr_info_t
 					      0, 0, TYPE_CMD);
 
 		if (return_code == IO_OK) {
-			listlength |=
-			    (0xff & (unsigned int)(ld_buff->LUNListLength[0]))
-			    << 24;
-			listlength |=
-			    (0xff & (unsigned int)(ld_buff->LUNListLength[1]))
-			    << 16;
-			listlength |=
-			    (0xff & (unsigned int)(ld_buff->LUNListLength[2]))
-			    << 8;
-			listlength |=
-			    0xff & (unsigned int)(ld_buff->LUNListLength[3]);
+			listlength =
+				be32_to_cpu(*(__u32 *) ld_buff->LUNListLength);
 		} else {	/* reading number of logical volumes failed */
 			printk(KERN_WARNING "cciss: report logical volume"
 			       " command failed\n");
@@ -1491,6 +1482,14 @@ static int rebuild_lun_table(ctlr_info_t
 				if (drv_index == -1)
 					goto freeret;
 
+				/*Check if the gendisk needs to be allocated */
+				if (!h->gendisk[drv_index]){
+					h->gendisk[drv_index] = alloc_disk(1 << NWD_SHIFT);
+					if (!h->gendisk[drv_index]){
+						printk(KERN_ERR "cciss: could not allocate new disk %d\n", drv_index);
+						goto mem_msg;
+					}
+				}
 			}
 			h->drv[drv_index].LunID = lunid;
 			cciss_update_drive_info(ctlr, drv_index);
@@ -1528,6 +1527,7 @@ static int rebuild_lun_table(ctlr_info_t
 static int deregister_disk(struct gendisk *disk, drive_info_struct *drv,
 			   int clear_all)
 {
+	int i;
 	ctlr_info_t *h = get_host(disk);
 
 	if (!capable(CAP_SYS_RAWIO))
@@ -1551,9 +1551,35 @@ static int deregister_disk(struct gendis
 				del_gendisk(disk);
 			if (q) {
 				blk_cleanup_queue(q);
+				/* Set drv->queue to NULL so that we do not try
+				 * to call blk_start_queue on this queue in the
+				 * interrupt handler
+				 */
 				drv->queue = NULL;
 			}
+			/* If clear_all is set then we are deleting the logical
+			 * drive, not just refreshing its info.  For drives
+			 * other than disk 0 we will call put_disk.  We do not
+			 * do this for disk 0 as we need it to be able to
+			 * configure the controller.
+			*/
+			if (clear_all){
+				/* This isn't pretty, but we need to find the
+				 * disk in our array and NULL our the pointer.
+				 * This is so that we will call alloc_disk if
+				 * this index is used again later.
+				*/
+				for (i=0; i < CISS_MAX_LUN; i++){
+					if(h->gendisk[i] == disk){
+						h->gendisk[i] = NULL;
+						break;
+					}
+				}
+				put_disk(disk);
+			}
 		}
+	} else {
+		set_capacity(disk, 0);
 	}
 
 	--h->num_luns;
@@ -3119,13 +3145,7 @@ geo_inq:
 /* Returns -1 if no free entries are left.  */
 static int alloc_cciss_hba(void)
 {
-	struct gendisk *disk[NWD];
-	int i, n;
-	for (n = 0; n < NWD; n++) {
-		disk[n] = alloc_disk(1 << NWD_SHIFT);
-		if (!disk[n])
-			goto out;
-	}
+	int i;
 
 	for (i = 0; i < MAX_CTLR; i++) {
 		if (!hba[i]) {
@@ -3133,20 +3153,18 @@ static int alloc_cciss_hba(void)
 			p = kzalloc(sizeof(ctlr_info_t), GFP_KERNEL);
 			if (!p)
 				goto Enomem;
-			for (n = 0; n < NWD; n++)
-				p->gendisk[n] = disk[n];
+			p->gendisk[0] = alloc_disk(1 << NWD_SHIFT);
+			if (!p->gendisk[0])
+				goto Enomem;
 			hba[i] = p;
 			return i;
 		}
 	}
 	printk(KERN_WARNING "cciss: This driver supports a maximum"
 	       " of %d controllers.\n", MAX_CTLR);
-	goto out;
-      Enomem:
+	return -1;
+Enomem:
 	printk(KERN_ERR "cciss: out of memory.\n");
-      out:
-	while (n--)
-		put_disk(disk[n]);
 	return -1;
 }
 
@@ -3156,7 +3174,7 @@ static void free_hba(int i)
 	int n;
 
 	hba[i] = NULL;
-	for (n = 0; n < NWD; n++)
+	for (n = 0; n < CISS_MAX_LUN; n++)
 		put_disk(p->gendisk[n]);
 	kfree(p);
 }
@@ -3169,9 +3187,8 @@ static void free_hba(int i)
 static int __devinit cciss_init_one(struct pci_dev *pdev,
 				    const struct pci_device_id *ent)
 {
-	request_queue_t *q;
 	int i;
-	int j;
+	int j = 0;
 	int rc;
 	int dac;
 
@@ -3283,16 +3300,29 @@ static int __devinit cciss_init_one(stru
 
 	hba[i]->busy_initializing = 0;
 
-	for (j = 0; j < NWD; j++) {	/* mfm */
+	do {
 		drive_info_struct *drv = &(hba[i]->drv[j]);
 		struct gendisk *disk = hba[i]->gendisk[j];
+		request_queue_t *q;
+
+		/* Check if the disk was allocated already */
+		if (!disk){
+			hba[i]->gendisk[j] = alloc_disk(1 << NWD_SHIFT);
+			disk = hba[i]->gendisk[j];
+		}
+
+		/* Check that the disk was able to be allocated */
+		if (!disk) {
+			printk(KERN_ERR "cciss: unable to allocate memory for disk %d\n", j);
+			goto clean4;
+		}
 
 		q = blk_init_queue(do_cciss_request, &hba[i]->lock);
 		if (!q) {
 			printk(KERN_ERR
 			       "cciss:  unable to allocate queue for disk %d\n",
 			       j);
-			break;
+			goto clean4;
 		}
 		drv->queue = q;
 
@@ -3324,7 +3354,8 @@ static int __devinit cciss_init_one(stru
 		blk_queue_hardsect_size(q, drv->block_size);
 		set_capacity(disk, drv->nr_blocks);
 		add_disk(disk);
-	}
+		j++;
+	} while (j <= hba[i]->highest_lun);
 
 	return 1;
 
@@ -3347,6 +3378,15 @@ static int __devinit cciss_init_one(stru
 	unregister_blkdev(hba[i]->major, hba[i]->devname);
       clean1:
 	hba[i]->busy_initializing = 0;
+	/* cleanup any queues that may have been initialized */
+	for (j=0; j <= hba[i]->highest_lun; j++){
+		drive_info_struct *drv = &(hba[i]->drv[j]);
+		if (drv->queue)
+			blk_cleanup_queue(drv->queue);
+	}
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
 	free_hba(i);
 	return -1;
 }
@@ -3394,7 +3434,7 @@ static void __devexit cciss_remove_one(s
 	remove_proc_entry(hba[i]->devname, proc_cciss);
 
 	/* remove it from the disk list */
-	for (j = 0; j < NWD; j++) {
+	for (j = 0; j < CISS_MAX_LUN; j++) {
 		struct gendisk *disk = hba[i]->gendisk[j];
 		if (disk) {
 			request_queue_t *q = disk->queue;
diff -puN drivers/block/cciss.h~cciss-add-support-for-1024-logical-volumes drivers/block/cciss.h
--- a/drivers/block/cciss.h~cciss-add-support-for-1024-logical-volumes
+++ a/drivers/block/cciss.h
@@ -6,7 +6,6 @@
 #include "cciss_cmd.h"
 
 
-#define NWD		16
 #define NWD_SHIFT	4
 #define MAX_PART	(1 << NWD_SHIFT)
 
@@ -112,7 +111,7 @@ struct ctlr_info 
 	int			next_to_run;
 
 	// Disk structures we need to pass back
-	struct gendisk   *gendisk[NWD];
+	struct gendisk   *gendisk[CISS_MAX_LUN];
 #ifdef CONFIG_CISS_SCSI_TAPE
 	void *scsi_ctlr; /* ptr to structure containing scsi related stuff */
 	/* list of block side commands the scsi error handling sucked up */
diff -puN drivers/block/cciss_cmd.h~cciss-add-support-for-1024-logical-volumes drivers/block/cciss_cmd.h
--- a/drivers/block/cciss_cmd.h~cciss-add-support-for-1024-logical-volumes
+++ a/drivers/block/cciss_cmd.h
@@ -89,7 +89,7 @@ typedef union _u64bit
 //###########################################################################
 //STRUCTURES
 //###########################################################################
-#define CISS_MAX_LUN	16	
+#define CISS_MAX_LUN	1024
 #define CISS_MAX_PHYS_LUN	1024
 // SCSI-3 Cmmands 
 
diff -puN include/linux/cciss_ioctl.h~cciss-add-support-for-1024-logical-volumes include/linux/cciss_ioctl.h
--- a/include/linux/cciss_ioctl.h~cciss-add-support-for-1024-logical-volumes
+++ a/include/linux/cciss_ioctl.h
@@ -80,7 +80,7 @@ typedef __u32 DriverVer_type;
 #define HWORD __u16
 #define DWORD __u32
 
-#define CISS_MAX_LUN	16	
+#define CISS_MAX_LUN	1024
 
 #define LEVEL2LUN   1   // index into Target(x) structure, due to byte swapping
 #define LEVEL3LUN   0
_

Patches currently in -mm which might be from mike.miller@hp.com are

origin.patch

