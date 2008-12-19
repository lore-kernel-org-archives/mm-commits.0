From: akpm@linux-foundation.org
Subject: - cciss-simplify-parameters-to-deregister_disk-function.patch removed from -mm tree
Date: Fri, 19 Dec 2008 12:04:44 -0800
Message-ID: <200812192004.mBJK4ig0010538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752426AbYLSUE5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Dec 2008 15:04:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cca.cpqcorp.net, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cciss: simplify parameters to deregister_disk function
has been removed from the -mm tree.  Its filename was
     cciss-simplify-parameters-to-deregister_disk-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: simplify parameters to deregister_disk function
From: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>

Simplify parameters to deregister_disk function.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/block/cciss.c~cciss-simplify-parameters-to-deregister_disk-function drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-simplify-parameters-to-deregister_disk-function
+++ a/drivers/block/cciss.c
@@ -164,7 +164,7 @@ static int cciss_getgeo(struct block_dev
 
 static int cciss_revalidate(struct gendisk *disk);
 static int rebuild_lun_table(ctlr_info_t *h, int first_time);
-static int deregister_disk(struct gendisk *disk, drive_info_struct *drv,
+static int deregister_disk(ctlr_info_t *h, int drv_index,
 			   int clear_all);
 
 static void cciss_read_capacity(int ctlr, int logvol, int withirq,
@@ -1479,8 +1479,7 @@ static void cciss_update_drive_info(int 
 		 * which keeps the interrupt handler from starting
 		 * the queue.
 		 */
-		ret = deregister_disk(h->gendisk[drv_index],
-				      &h->drv[drv_index], 0);
+		ret = deregister_disk(h, drv_index, 0);
 		h->drv[drv_index].busy_configuring = 0;
 	}
 
@@ -1693,8 +1692,7 @@ static int rebuild_lun_table(ctlr_info_t
 			spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
 			h->drv[i].busy_configuring = 1;
 			spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
-			return_code = deregister_disk(h->gendisk[i],
-				&h->drv[i], 1);
+			return_code = deregister_disk(h, i, 1);
 			h->drv[i].busy_configuring = 0;
 		}
 	}
@@ -1764,15 +1762,19 @@ mem_msg:
  *             the highest_lun should be left unchanged and the LunID
  *             should not be cleared.
 */
-static int deregister_disk(struct gendisk *disk, drive_info_struct *drv,
+static int deregister_disk(ctlr_info_t *h, int drv_index,
 			   int clear_all)
 {
 	int i;
-	ctlr_info_t *h = get_host(disk);
+	struct gendisk *disk;
+	drive_info_struct *drv;
 
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
+	drv = &h->drv[drv_index];
+	disk = h->gendisk[drv_index];
+
 	/* make sure logical volume is NOT is use */
 	if (clear_all || (h->gendisk[0] == disk)) {
 		if (drv->usage_count > 1)
_

Patches currently in -mm which might be from scameron@beardog.cca.cpqcorp.net are

linux-next.patch
cciss-fix-problem-that-deleting-multiple-logical-drives-could-cause-a-panic.patch

