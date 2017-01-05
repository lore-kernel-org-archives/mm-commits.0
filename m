From: akpm@linux-foundation.org
Subject: [to-be-updated] z3fold-make-pages_nr-atomic.patch removed from
 -mm tree
Date: Wed, 04 Jan 2017 17:27:29 -0800
Message-ID: <586da101.LO5bHDBx6E9UDLHy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55254 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967683AbdAECWb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 21:22:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalywool@gmail.com, ddstreet@ieee.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold.c: make pages_nr atomic
has been removed from the -mm tree.  Its filename was
     z3fold-make-pages_nr-atomic.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vitaly Wool <vitalywool@gmail.com>
Subject: mm/z3fold.c: make pages_nr atomic

Convert pages_nr per-pool counter to atomic64_t.

Link: http://lkml.kernel.org/r/20161103220058.3017148c790b352c0ec521d4@gmail.com
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Acked-by: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff -puN mm/z3fold.c~z3fold-make-pages_nr-atomic mm/z3fold.c
--- a/mm/z3fold.c~z3fold-make-pages_nr-atomic
+++ a/mm/z3fold.c
@@ -80,7 +80,7 @@ struct z3fold_pool {
 	struct list_head unbuddied[NCHUNKS];
 	struct list_head buddied;
 	struct list_head lru;
-	u64 pages_nr;
+	atomic64_t pages_nr;
 	const struct z3fold_ops *ops;
 	struct zpool *zpool;
 	const struct zpool_ops *zpool_ops;
@@ -238,7 +238,7 @@ static struct z3fold_pool *z3fold_create
 		INIT_LIST_HEAD(&pool->unbuddied[i]);
 	INIT_LIST_HEAD(&pool->buddied);
 	INIT_LIST_HEAD(&pool->lru);
-	pool->pages_nr = 0;
+	atomic64_set(&pool->pages_nr, 0);
 	pool->ops = ops;
 	return pool;
 }
@@ -350,7 +350,7 @@ static int z3fold_alloc(struct z3fold_po
 	if (!page)
 		return -ENOMEM;
 	spin_lock(&pool->lock);
-	pool->pages_nr++;
+	atomic64_inc(&pool->pages_nr);
 	zhdr = init_z3fold_page(page);
 
 	if (bud == HEADLESS) {
@@ -443,10 +443,9 @@ static void z3fold_free(struct z3fold_po
 		return;
 	}
 
-	if (bud != HEADLESS) {
-		/* Remove from existing buddy list */
+	/* Remove from existing buddy list */
+	if (bud != HEADLESS)
 		list_del(&zhdr->buddy);
-	}
 
 	if (bud == HEADLESS ||
 	    (zhdr->first_chunks == 0 && zhdr->middle_chunks == 0 &&
@@ -455,7 +454,7 @@ static void z3fold_free(struct z3fold_po
 		list_del(&page->lru);
 		clear_bit(PAGE_HEADLESS, &page->private);
 		free_z3fold_page(zhdr);
-		pool->pages_nr--;
+		atomic64_dec(&pool->pages_nr);
 	} else {
 		z3fold_compact_page(zhdr);
 		/* Add to the unbuddied list */
@@ -573,7 +572,7 @@ next:
 			 */
 			clear_bit(PAGE_HEADLESS, &page->private);
 			free_z3fold_page(zhdr);
-			pool->pages_nr--;
+			atomic64_dec(&pool->pages_nr);
 			spin_unlock(&pool->lock);
 			return 0;
 		}  else if (!test_bit(PAGE_HEADLESS, &page->private)) {
@@ -676,12 +675,11 @@ static void z3fold_unmap(struct z3fold_p
  * z3fold_get_pool_size() - gets the z3fold pool size in pages
  * @pool:	pool whose size is being queried
  *
- * Returns: size in pages of the given pool.  The pool lock need not be
- * taken to access pages_nr.
+ * Returns: size in pages of the given pool.
  */
 static u64 z3fold_get_pool_size(struct z3fold_pool *pool)
 {
-	return pool->pages_nr;
+	return atomic64_read(&pool->pages_nr);
 }
 
 /*****************
_

Patches currently in -mm which might be from vitalywool@gmail.com are

z3fold-extend-compaction-function.patch
z3fold-use-per-page-spinlock.patch
z3fold-discourage-use-of-pages-that-werent-compacted.patch
z3fold-fix-header-size-related-issues.patch
z3fold-fix-locking-issues.patch

