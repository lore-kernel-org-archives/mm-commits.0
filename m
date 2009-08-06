From: akpm@linux-foundation.org
Subject: [to-be-updated] cciss-remove-logical-drive-sysfs-entries-during-driver-cleanup.patch removed from -mm tree
Date: Thu, 06 Aug 2009 16:27:38 -0700
Message-ID: <200908062327.n76NRdu9009893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754096AbZHFX1o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2009 19:27:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrew.patterson@hp.com, jens.axboe@oracle.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: remove logical drive sysfs entries during driver cleanup
has been removed from the -mm tree.  Its filename was
     cciss-remove-logical-drive-sysfs-entries-during-driver-cleanup.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: remove logical drive sysfs entries during driver cleanup
From: Andrew Patterson <andrew.patterson@hp.com>

Sysfs entries for logical drives need to be removed when a drive is
deleted during driver cleanup.

Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/block/cciss.c~cciss-remove-logical-drive-sysfs-entries-during-driver-cleanup drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-remove-logical-drive-sysfs-entries-during-driver-cleanup
+++ a/drivers/block/cciss.c
@@ -1977,7 +1977,6 @@ static int rebuild_lun_table(ctlr_info_t
 			h->drv[i].busy_configuring = 1;
 			spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
 			return_code = deregister_disk(h, i, 1);
-			cciss_destroy_ld_sysfs_entry(&h->drv[i]);
 			h->drv[i].busy_configuring = 0;
 		}
 	}
@@ -2118,6 +2117,7 @@ static int deregister_disk(ctlr_info_t *
 				 * indicate that this element of the drive
 				 * array is free.
 				 */
+	cciss_destroy_ld_sysfs_entry(drv);
 
 	if (clear_all) {
 		/* check to see if it was the last disk */
@@ -4141,6 +4141,9 @@ static void __devexit cciss_remove_one(s
 			if (q)
 				blk_cleanup_queue(q);
 		}
+		if (hba[i]->drv[j].raid_level != -1)
+			cciss_destroy_ld_sysfs_entry(&hba[i]->drv[j]);
+
 	}
 
 #ifdef CONFIG_CISS_SCSI_TAPE
_

Patches currently in -mm which might be from andrew.patterson@hp.com are

origin.patch
cciss-remove-logical-drive-sysfs-entries-during-driver-cleanup.patch
cciss-use-mutex-instead-of-flag-to-indicate-busy-initializing.patch
cciss-use-only-one-scan-thread.patch
cciss-kick-off-logical-drive-topology-rescan-through-sysfs.patch

