From: akpm@osdl.org
Subject: - cciss-set-sector_size-to-2048-for-performance.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:00:30 -0800
Message-ID: <200612072300.kB7N0Ur1029647@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51271 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163598AbWLGXAq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:00:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.miller@hp.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cciss: set sector_size to 2048 for performance
has been removed from the -mm tree.  Its filename was
     cciss-set-sector_size-to-2048-for-performance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cciss: set sector_size to 2048 for performance
From: Mike Miller <mike.miller@hp.com>

Change the blk_queue_max_sectors from 512 to 2048.  This helps increase
performance.

[akpm@osdl.org: s/sector_size/max_sectors/]
Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/cciss.c |   12 +++++++++---
 drivers/block/cciss.h |    1 +
 2 files changed, 10 insertions(+), 3 deletions(-)

diff -puN drivers/block/cciss.c~cciss-set-sector_size-to-2048-for-performance drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-set-sector_size-to-2048-for-performance
+++ a/drivers/block/cciss.c
@@ -269,6 +269,7 @@ static int cciss_proc_get_info(char *buf
 		       "Firmware Version: %c%c%c%c\n"
 		       "IRQ: %d\n"
 		       "Logical drives: %d\n"
+		       "Max sectors: %d\n"
 		       "Current Q depth: %d\n"
 		       "Current # commands on controller: %d\n"
 		       "Max Q depth since init: %d\n"
@@ -279,7 +280,9 @@ static int cciss_proc_get_info(char *buf
 		       (unsigned long)h->board_id,
 		       h->firm_ver[0], h->firm_ver[1], h->firm_ver[2],
 		       h->firm_ver[3], (unsigned int)h->intr[SIMPLE_MODE_INT],
-		       h->num_luns, h->Qdepth, h->commands_outstanding,
+		       h->num_luns,
+		       h->cciss_max_sectors,
+		       h->Qdepth, h->commands_outstanding,
 		       h->maxQsinceinit, h->max_outstanding, h->maxSG);
 
 	pos += size;
@@ -1395,7 +1398,7 @@ static void cciss_update_drive_info(int 
 		/* This is a limit in the driver and could be eliminated. */
 		blk_queue_max_phys_segments(disk->queue, MAXSGENTRIES);
 
-		blk_queue_max_sectors(disk->queue, 512);
+		blk_queue_max_sectors(disk->queue, h->cciss_max_sectors);
 
 		blk_queue_softirq_done(disk->queue, cciss_softirq_done);
 
@@ -3347,6 +3350,9 @@ static int __devinit cciss_init_one(stru
 	hba[i]->access.set_intr_mask(hba[i], CCISS_INTR_ON);
 
 	cciss_procinit(i);
+
+	hba[i]->cciss_max_sectors = 2048;
+
 	hba[i]->busy_initializing = 0;
 
 	for (j = 0; j < NWD; j++) {	/* mfm */
@@ -3371,7 +3377,7 @@ static int __devinit cciss_init_one(stru
 		/* This is a limit in the driver and could be eliminated. */
 		blk_queue_max_phys_segments(q, MAXSGENTRIES);
 
-		blk_queue_max_sectors(q, 512);
+		blk_queue_max_sectors(q, hba[i]->cciss_max_sectors);
 
 		blk_queue_softirq_done(q, cciss_softirq_done);
 
diff -puN drivers/block/cciss.h~cciss-set-sector_size-to-2048-for-performance drivers/block/cciss.h
--- a/drivers/block/cciss.h~cciss-set-sector_size-to-2048-for-performance
+++ a/drivers/block/cciss.h
@@ -77,6 +77,7 @@ struct ctlr_info 
 	unsigned int intr[4];
 	unsigned int msix_vector;
 	unsigned int msi_vector;
+	int 	cciss_max_sectors;
 	BYTE	cciss_read;
 	BYTE	cciss_write;
 	BYTE	cciss_read_capacity;
_

Patches currently in -mm which might be from mike.miller@hp.com are

origin.patch

