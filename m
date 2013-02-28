From: akpm@linux-foundation.org
Subject: [merged] block-fix-synchronization-and-limit-check-in-blk_alloc_devt.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:13:12 -0800
Message-ID: <20130228201312.B968931C0A0__42432.8528963544$1362082425$gmane$org@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:62413 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757194Ab3B1UNN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:13:13 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so244965ggn.2
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:13:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, axboe@kernel.dk, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: block: fix synchronization and limit check in blk_alloc_devt()
has been removed from the -mm tree.  Its filename was
     block-fix-synchronization-and-limit-check-in-blk_alloc_devt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: block: fix synchronization and limit check in blk_alloc_devt()

idr allocation in blk_alloc_devt() wasn't synchronized against lookup
and removal, and its limit check was off by one - 1 << MINORBITS is
the number of minors allowed, not the maximum allowed minor.

Add locking and rename MAX_EXT_DEVT to NR_EXT_DEVT and fix limit
checking.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN block/genhd.c~block-fix-synchronization-and-limit-check-in-blk_alloc_devt block/genhd.c
--- a/block/genhd.c~block-fix-synchronization-and-limit-check-in-blk_alloc_devt
+++ a/block/genhd.c
@@ -26,7 +26,7 @@ static DEFINE_MUTEX(block_class_lock);
 struct kobject *block_depr;
 
 /* for extended dynamic devt allocation, currently only one major is used */
-#define MAX_EXT_DEVT		(1 << MINORBITS)
+#define NR_EXT_DEVT		(1 << MINORBITS)
 
 /* For extended devt allocation.  ext_devt_mutex prevents look up
  * results from going away underneath its user.
@@ -425,19 +425,16 @@ int blk_alloc_devt(struct hd_struct *par
 			return -ENOMEM;
 		mutex_lock(&ext_devt_mutex);
 		rc = idr_get_new(&ext_devt_idr, part, &idx);
+		if (!rc && idx >= NR_EXT_DEVT) {
+			idr_remove(&ext_devt_idr, idx);
+			rc = -EBUSY;
+		}
 		mutex_unlock(&ext_devt_mutex);
 	} while (rc == -EAGAIN);
 
 	if (rc)
 		return rc;
 
-	if (idx > MAX_EXT_DEVT) {
-		mutex_lock(&ext_devt_mutex);
-		idr_remove(&ext_devt_idr, idx);
-		mutex_unlock(&ext_devt_mutex);
-		return -EBUSY;
-	}
