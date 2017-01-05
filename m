From: akpm@linux-foundation.org
Subject: + mm-z3foldc-make-pages_nr-atomic.patch added to -mm tree
Date: Wed, 04 Jan 2017 17:29:21 -0800
Message-ID: <586da171.rpsTu9Ad7InIW1wT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43730 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933960AbdAEB2F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 20:28:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalywool@gmail.com, ddstreet@ieee.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold.c: make pages_nr atomic
has been added to the -mm tree.  Its filename is
     mm-z3foldc-make-pages_nr-atomic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-z3foldc-make-pages_nr-atomic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-z3foldc-make-pages_nr-atomic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vitaly Wool <vitalywool@gmail.com>
Subject: mm/z3fold.c: make pages_nr atomic

Convert pages_nr per-pool counter to atomic64_t so that we won't have
to care about locking for reading/updating it.

Link: http://lkml.kernel.org/r/20161226013322.5dddf36ff0de51e44ba6f4a7@gmail.com
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff -puN mm/z3fold.c~mm-z3foldc-make-pages_nr-atomic mm/z3fold.c
--- a/mm/z3fold.c~mm-z3foldc-make-pages_nr-atomic
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

mm-z3foldc-make-pages_nr-atomic.patch
mm-z3foldc-extend-compaction-function.patch
z3fold-use-per-page-spinlock.patch
z3fold-fix-header-size-related-issues.patch
z3fold-add-kref-refcounting.patch

