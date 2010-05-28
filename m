From: akpm@linux-foundation.org
Subject: + block-bd_start_claiming-cleanup.patch added to -mm tree
Date: Fri, 28 May 2010 14:35:39 -0700
Message-ID: <201005282135.o4SLZdKJ015896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759239Ab0E1Vfq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 May 2010 17:35:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, jens.axboe@oracle.com, tj@kernel.org


The patch titled
     block: bd_start_claiming() cleanup
has been added to the -mm tree.  Its filename is
     block-bd_start_claiming-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: bd_start_claiming() cleanup
From: Nick Piggin <npiggin@suse.de>

I don't like the subtle multi-context code in bd_claim (ie.  detects where
it has been called based on bd_claiming).  It seems clearer to just
require a new function to finish a 2-part claim.

Also improve commentary in bd_start_claiming as to how it should be used.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |   72 +++++++++++++++++++++++++++++++----------------
 1 file changed, 48 insertions(+), 24 deletions(-)

diff -puN fs/block_dev.c~block-bd_start_claiming-cleanup fs/block_dev.c
--- a/fs/block_dev.c~block-bd_start_claiming-cleanup
+++ a/fs/block_dev.c
@@ -706,8 +706,13 @@ retry:
  * @bdev is about to be opened exclusively.  Check @bdev can be opened
  * exclusively and mark that an exclusive open is in progress.  Each
  * successful call to this function must be matched with a call to
- * either bd_claim() or bd_abort_claiming().  If this function
- * succeeds, the matching bd_claim() is guaranteed to succeed.
+ * either bd_finish_claiming() or bd_abort_claiming() (which do not
+ * fail).
+ *
+ * This function is used to gain exclusive access to the block device
+ * without actually causing other exclusive open attempts to fail. It
+ * should be used when the open sequence itself requires exclusive
+ * access but may subsequently fail.
  *
  * CONTEXT:
  * Might sleep.
@@ -783,15 +788,47 @@ static void bd_abort_claiming(struct blo
 	__bd_abort_claiming(whole, holder);		/* releases bdev_lock */
 }
 
+/* increment holders when we have a legitimate claim. requires bdev_lock */
+static void __bd_claim(struct block_device *bdev, struct block_device *whole,
+					void *holder)
+{
+	/* note that for a whole device bd_holders
+	 * will be incremented twice, and bd_holder will
+	 * be set to bd_claim before being set to holder
+	 */
+	whole->bd_holders++;
+	whole->bd_holder = bd_claim;
+	bdev->bd_holders++;
+	bdev->bd_holder = holder;
+}
+
+/**
+ * bd_finish_claiming - finish claiming a block device
+ * @bdev: block device of interest (passed to bd_start_claiming())
+ * @whole: whole block device returned by bd_start_claiming()
+ * @holder: holder trying to claim @bdev
+ *
+ * Finish a claiming block started by bd_start_claiming().
+ *
+ * CONTEXT:
+ * Grabs and releases bdev_lock.
+ */
+static void bd_finish_claiming(struct block_device *bdev,
+				struct block_device *whole, void *holder)
+{
+	spin_lock(&bdev_lock);
+	BUG_ON(whole->bd_claiming != holder);
+	BUG_ON(!bd_may_claim(bdev, whole, holder));
+	__bd_claim(bdev, whole, holder);
+	__bd_abort_claiming(whole, holder); /* not actually an abort */
+}
+
 /**
  * bd_claim - claim a block device
  * @bdev: block device to claim
  * @holder: holder trying to claim @bdev
  *
- * Try to claim @bdev which must have been opened successfully.  This
- * function may be called with or without preceding
- * blk_start_claiming().  In the former case, this function is always
- * successful and terminates the claiming block.
+ * Try to claim @bdev which must have been opened successfully.
  *
  * CONTEXT:
  * Might sleep.
@@ -807,23 +844,10 @@ int bd_claim(struct block_device *bdev, 
 	might_sleep();
 
 	spin_lock(&bdev_lock);
-
 	res = bd_prepare_to_claim(bdev, whole, holder);
-	if (res == 0) {
-		/* note that for a whole device bd_holders
-		 * will be incremented twice, and bd_holder will
-		 * be set to bd_claim before being set to holder
-		 */
-		whole->bd_holders++;
-		whole->bd_holder = bd_claim;
-		bdev->bd_holders++;
-		bdev->bd_holder = holder;
-	}
-
-	if (whole->bd_claiming)
-		__bd_abort_claiming(whole, holder);	/* releases bdev_lock */
-	else
-		spin_unlock(&bdev_lock);
+	if (res == 0)
+		__bd_claim(bdev, whole, holder);
+	spin_unlock(&bdev_lock);
 
 	return res;
 }
@@ -1477,7 +1501,7 @@ static int blkdev_open(struct inode * in
 
 	if (whole) {
 		if (res == 0)
-			BUG_ON(bd_claim(bdev, filp) != 0);
+			bd_finish_claiming(bdev, whole, filp);
 		else
 			bd_abort_claiming(whole, filp);
 	}
@@ -1713,7 +1737,7 @@ struct block_device *open_bdev_exclusive
 	if ((mode & FMODE_WRITE) && bdev_read_only(bdev))
 		goto out_blkdev_put;
 
-	BUG_ON(bd_claim(bdev, holder) != 0);
+	bd_finish_claiming(bdev, whole, holder);
 	return bdev;
 
 out_blkdev_put:
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
block-bd_start_claiming-fix-module-refcount.patch
block-bd_start_claiming-cleanup.patch
fs-splicec-fix-mapping_gfp_mask-usage.patch
reiser4.patch

