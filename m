From: akpm@linux-foundation.org
Subject: [patch 038/124] z3fold: add kref refcounting
Date: Fri, 24 Feb 2017 14:57:26 -0800
Message-ID: <58b0ba56.Qcu6pnELoQDWOgGf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38048 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751455AbdBXW51 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:57:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vitalywool@gmail.com, ddstreet@ieee.org

From: Vitaly Wool <vitalywool@gmail.com>
Subject: z3fold: add kref refcounting

With both coming and already present locking optimizations, introducing
kref to reference-count z3fold objects is the right thing to do. 
Moreover, it makes buddied list no longer necessary, and allows for a
simpler handling of headless pages.

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/20170131214650.8ea78033d91ded233f552bc0@gmail.com
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Reviewed-by: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |  155 ++++++++++++++++++++++----------------------------
 1 file changed, 69 insertions(+), 86 deletions(-)

diff -puN mm/z3fold.c~z3fold-add-kref-refcounting mm/z3fold.c
--- a/mm/z3fold.c~z3fold-add-kref-refcounting
+++ a/mm/z3fold.c
@@ -52,6 +52,7 @@ enum buddy {
  *			z3fold page, except for HEADLESS pages
  * @buddy:	links the z3fold page into the relevant list in the pool
  * @page_lock:		per-page lock
+ * @refcount:		reference cound for the z3fold page
  * @first_chunks:	the size of the first buddy in chunks, 0 if free
  * @middle_chunks:	the size of the middle buddy in chunks, 0 if free
  * @last_chunks:	the size of the last buddy in chunks, 0 if free
@@ -60,6 +61,7 @@ enum buddy {
 struct z3fold_header {
 	struct list_head buddy;
 	spinlock_t page_lock;
+	struct kref refcount;
 	unsigned short first_chunks;
 	unsigned short middle_chunks;
 	unsigned short last_chunks;
@@ -95,8 +97,6 @@ struct z3fold_header {
  * @unbuddied:	array of lists tracking z3fold pages that contain 2- buddies;
  *		the lists each z3fold page is added to depends on the size of
  *		its free region.
- * @buddied:	list tracking the z3fold pages that contain 3 buddies;
- *		these z3fold pages are full
  * @lru:	list tracking the z3fold pages in LRU order by most recently
  *		added buddy.
  * @pages_nr:	number of z3fold pages in the pool.
@@ -109,7 +109,6 @@ struct z3fold_header {
 struct z3fold_pool {
 	spinlock_t lock;
 	struct list_head unbuddied[NCHUNKS];
-	struct list_head buddied;
 	struct list_head lru;
 	atomic64_t pages_nr;
 	const struct z3fold_ops *ops;
@@ -121,8 +120,7 @@ struct z3fold_pool {
  * Internal z3fold page flags
  */
 enum z3fold_page_flags {
-	UNDER_RECLAIM = 0,
-	PAGE_HEADLESS,
+	PAGE_HEADLESS = 0,
 	MIDDLE_CHUNK_MAPPED,
 };
 
@@ -146,11 +144,11 @@ static struct z3fold_header *init_z3fold
 	struct z3fold_header *zhdr = page_address(page);
 
 	INIT_LIST_HEAD(&page->lru);
-	clear_bit(UNDER_RECLAIM, &page->private);
 	clear_bit(PAGE_HEADLESS, &page->private);
 	clear_bit(MIDDLE_CHUNK_MAPPED, &page->private);
 
 	spin_lock_init(&zhdr->page_lock);
+	kref_init(&zhdr->refcount);
 	zhdr->first_chunks = 0;
 	zhdr->middle_chunks = 0;
 	zhdr->last_chunks = 0;
@@ -161,9 +159,24 @@ static struct z3fold_header *init_z3fold
 }
 
 /* Resets the struct page fields and frees the page */
-static void free_z3fold_page(struct z3fold_header *zhdr)
+static void free_z3fold_page(struct page *page)
 {
-	__free_page(virt_to_page(zhdr));
+	__free_page(page);
+}
+
+static void release_z3fold_page(struct kref *ref)
+{
+	struct z3fold_header *zhdr;
+	struct page *page;
+
+	zhdr = container_of(ref, struct z3fold_header, refcount);
+	page = virt_to_page(zhdr);
+
+	if (!list_empty(&zhdr->buddy))
+		list_del(&zhdr->buddy);
+	if (!list_empty(&page->lru))
+		list_del(&page->lru);
+	free_z3fold_page(page);
 }
 
 /* Lock a z3fold page */
@@ -178,7 +191,6 @@ static inline void z3fold_page_unlock(st
 	spin_unlock(&zhdr->page_lock);
 }
 
-
 /*
  * Encodes the handle of a particular buddy within a z3fold page
  * Pool lock should be held as this function accesses first_num
@@ -257,7 +269,6 @@ static struct z3fold_pool *z3fold_create
 	spin_lock_init(&pool->lock);
 	for_each_unbuddied_list(i, 0)
 		INIT_LIST_HEAD(&pool->unbuddied[i]);
-	INIT_LIST_HEAD(&pool->buddied);
 	INIT_LIST_HEAD(&pool->lru);
 	atomic64_set(&pool->pages_nr, 0);
 	pool->ops = ops;
@@ -378,6 +389,7 @@ static int z3fold_alloc(struct z3fold_po
 				spin_unlock(&pool->lock);
 				continue;
 			}
+			kref_get(&zhdr->refcount);
 			list_del_init(&zhdr->buddy);
 			spin_unlock(&pool->lock);
 
@@ -394,10 +406,12 @@ static int z3fold_alloc(struct z3fold_po
 			else if (zhdr->middle_chunks == 0)
 				bud = MIDDLE;
 			else {
+				z3fold_page_unlock(zhdr);
 				spin_lock(&pool->lock);
-				list_add(&zhdr->buddy, &pool->buddied);
+				if (kref_put(&zhdr->refcount,
+					     release_z3fold_page))
+					atomic64_dec(&pool->pages_nr);
 				spin_unlock(&pool->lock);
-				z3fold_page_unlock(zhdr);
 				pr_err("No free chunks in unbuddied\n");
 				WARN_ON(1);
 				continue;
@@ -438,9 +452,6 @@ found:
 		/* Add to unbuddied list */
 		freechunks = num_free_chunks(zhdr);
 		list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
-	} else {
-		/* Add to buddied list */
-		list_add(&zhdr->buddy, &pool->buddied);
 	}
 
 headless:
@@ -504,52 +515,29 @@ static void z3fold_free(struct z3fold_po
 		}
 	}
 
-	if (test_bit(UNDER_RECLAIM, &page->private)) {
-		/* z3fold page is under reclaim, reclaim will free */
-		if (bud != HEADLESS)
-			z3fold_page_unlock(zhdr);
-		return;
-	}
-
-	/* Remove from existing buddy list */
-	if (bud != HEADLESS) {
-		spin_lock(&pool->lock);
-		/*
-		 * this object may have been removed from its list by
-		 * z3fold_alloc(). In that case we just do nothing,
-		 * z3fold_alloc() will allocate an object and add the page
-		 * to the relevant list.
-		 */
-		if (!list_empty(&zhdr->buddy)) {
-			list_del(&zhdr->buddy);
-		} else {
-			spin_unlock(&pool->lock);
-			z3fold_page_unlock(zhdr);
-			return;
-		}
-		spin_unlock(&pool->lock);
-	}
-
-	if (bud == HEADLESS ||
-	    (zhdr->first_chunks == 0 && zhdr->middle_chunks == 0 &&
-			zhdr->last_chunks == 0)) {
-		/* z3fold page is empty, free */
+	if (bud == HEADLESS) {
 		spin_lock(&pool->lock);
 		list_del(&page->lru);
 		spin_unlock(&pool->lock);
-		clear_bit(PAGE_HEADLESS, &page->private);
-		if (bud != HEADLESS)
-			z3fold_page_unlock(zhdr);
-		free_z3fold_page(zhdr);
+		free_z3fold_page(page);
 		atomic64_dec(&pool->pages_nr);
 	} else {
-		z3fold_compact_page(zhdr);
-		/* Add to the unbuddied list */
+		if (zhdr->first_chunks != 0 || zhdr->middle_chunks != 0 ||
+		    zhdr->last_chunks != 0) {
+			z3fold_compact_page(zhdr);
+			/* Add to the unbuddied list */
+			spin_lock(&pool->lock);
+			if (!list_empty(&zhdr->buddy))
+				list_del(&zhdr->buddy);
+			freechunks = num_free_chunks(zhdr);
+			list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
+			spin_unlock(&pool->lock);
+		}
+		z3fold_page_unlock(zhdr);
 		spin_lock(&pool->lock);
-		freechunks = num_free_chunks(zhdr);
-		list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
+		if (kref_put(&zhdr->refcount, release_z3fold_page))
+			atomic64_dec(&pool->pages_nr);
 		spin_unlock(&pool->lock);
-		z3fold_page_unlock(zhdr);
 	}
 
 }
@@ -608,13 +596,13 @@ static int z3fold_reclaim_page(struct z3
 			return -EINVAL;
 		}
 		page = list_last_entry(&pool->lru, struct page, lru);
-		list_del(&page->lru);
+		list_del_init(&page->lru);
 
-		/* Protect z3fold page against free */
-		set_bit(UNDER_RECLAIM, &page->private);
 		zhdr = page_address(page);
 		if (!test_bit(PAGE_HEADLESS, &page->private)) {
-			list_del(&zhdr->buddy);
+			if (!list_empty(&zhdr->buddy))
+				list_del_init(&zhdr->buddy);
+			kref_get(&zhdr->refcount);
 			spin_unlock(&pool->lock);
 			z3fold_page_lock(zhdr);
 			/*
@@ -655,30 +643,19 @@ static int z3fold_reclaim_page(struct z3
 				goto next;
 		}
 next:
-		if (!test_bit(PAGE_HEADLESS, &page->private))
-			z3fold_page_lock(zhdr);
-		clear_bit(UNDER_RECLAIM, &page->private);
-		if ((test_bit(PAGE_HEADLESS, &page->private) && ret == 0) ||
-		    (zhdr->first_chunks == 0 && zhdr->last_chunks == 0 &&
-		     zhdr->middle_chunks == 0)) {
-			/*
-			 * All buddies are now free, free the z3fold page and
-			 * return success.
-			 */
-			if (!test_and_clear_bit(PAGE_HEADLESS, &page->private))
-				z3fold_page_unlock(zhdr);
-			free_z3fold_page(zhdr);
-			atomic64_dec(&pool->pages_nr);
-			return 0;
-		}  else if (!test_bit(PAGE_HEADLESS, &page->private)) {
-			if (zhdr->first_chunks != 0 &&
-			    zhdr->last_chunks != 0 &&
-			    zhdr->middle_chunks != 0) {
-				/* Full, add to buddied list */
-				spin_lock(&pool->lock);
-				list_add(&zhdr->buddy, &pool->buddied);
-				spin_unlock(&pool->lock);
+		if (test_bit(PAGE_HEADLESS, &page->private)) {
+			if (ret == 0) {
+				free_z3fold_page(page);
+				return 0;
 			} else {
+				spin_lock(&pool->lock);
+			}
+		} else {
+			z3fold_page_lock(zhdr);
+			if ((zhdr->first_chunks || zhdr->last_chunks ||
+			     zhdr->middle_chunks) &&
+			    !(zhdr->first_chunks && zhdr->last_chunks &&
+			      zhdr->middle_chunks)) {
 				z3fold_compact_page(zhdr);
 				/* add to unbuddied list */
 				spin_lock(&pool->lock);
@@ -687,13 +664,19 @@ next:
 					 &pool->unbuddied[freechunks]);
 				spin_unlock(&pool->lock);
 			}
-		}
