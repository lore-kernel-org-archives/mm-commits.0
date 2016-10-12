From: akpm@linux-foundation.org
Subject: + z3fold-add-shrinker.patch added to -mm tree
Date: Wed, 12 Oct 2016 16:01:19 -0700
Message-ID: <57fec0bf.KSqKYzGzHFZxOWWT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40673 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933150AbcJLXZu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 19:25:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalywool@gmail.com, david@fromorbit.com, ddstreet@ieee.org, sjenning@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold.c: add shrinker
has been added to the -mm tree.  Its filename is
     z3fold-add-shrinker.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/z3fold-add-shrinker.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/z3fold-add-shrinker.patch

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
Subject: mm/z3fold.c: add shrinker

This patch implements shrinker for z3fold.  This shrinker implementation
does not free up any pages directly but it allows for a denser placement
of compressed objects which results in less actual pages consumed and
therefore a higher compression ratio.

Link: http://lkml.kernel.org/r/20161012223851.0474f69cfdd6ad990e3b1dae@gmail.com
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |  157 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 132 insertions(+), 25 deletions(-)

diff -puN mm/z3fold.c~z3fold-add-shrinker mm/z3fold.c
--- a/mm/z3fold.c~z3fold-add-shrinker
+++ a/mm/z3fold.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/zpool.h>
+#include <linux/shrinker.h>
 
 /*****************
  * Structures
@@ -69,8 +70,10 @@ struct z3fold_ops {
  * @lru:	list tracking the z3fold pages in LRU order by most recently
  *		added buddy.
  * @pages_nr:	number of z3fold pages in the pool.
+ * @unbuddied_nr:	number of unbuddied z3fold pages in the pool.
  * @ops:	pointer to a structure of user defined operations specified at
  *		pool creation time.
+ * @shrinker:	shrinker structure to optimize page layout in background
  *
  * This structure is allocated at pool creation time and maintains metadata
  * pertaining to a particular z3fold pool.
@@ -81,9 +84,11 @@ struct z3fold_pool {
 	struct list_head buddied;
 	struct list_head lru;
 	u64 pages_nr;
+	u64 unbuddied_nr;
 	const struct z3fold_ops *ops;
 	struct zpool *zpool;
 	const struct zpool_ops *zpool_ops;
+	struct shrinker shrinker;
 };
 
 enum buddy {
@@ -134,6 +139,9 @@ static int size_to_chunks(size_t size)
 #define for_each_unbuddied_list(_iter, _begin) \
 	for ((_iter) = (_begin); (_iter) < NCHUNKS; (_iter)++)
 
+#define for_each_unbuddied_list_down(_iter, _end) \
+	for ((_iter) = (_end); (_iter) > 0; (_iter)--)
+
 /* Initializes the z3fold header of a newly allocated z3fold page */
 static struct z3fold_header *init_z3fold_page(struct page *page)
 {
@@ -209,6 +217,100 @@ static int num_free_chunks(struct z3fold
 	return nfree;
 }
 
+/* Has to be called with lock held */
+static int z3fold_compact_page(struct z3fold_header *zhdr, bool sync)
+{
+	struct page *page = virt_to_page(zhdr);
+	void *beg = zhdr;
+
+
+	if (!test_bit(MIDDLE_CHUNK_MAPPED, &page->private)) {
+		if (zhdr->middle_chunks != 0 &&
+		    zhdr->first_chunks == 0 &&
+		    zhdr->last_chunks == 0) {
+			memmove(beg + ZHDR_SIZE_ALIGNED,
+				beg + (zhdr->start_middle << CHUNK_SHIFT),
+				zhdr->middle_chunks << CHUNK_SHIFT);
+			zhdr->first_chunks = zhdr->middle_chunks;
+			zhdr->middle_chunks = 0;
+			zhdr->start_middle = 0;
+			zhdr->first_num++;
+			return 1;
+		}
+		if (sync)
+			goto out;
+
+		/* moving data is expensive, so let's only do that if
+		 * there's substantial gain (2+ chunks)
+		 */
+		if (zhdr->middle_chunks != 0 && zhdr->first_chunks != 0 &&
+		    zhdr->last_chunks == 0 &&
+		    zhdr->start_middle > zhdr->first_chunks + 2) {
+			unsigned short new_start = zhdr->first_chunks + 1;
+			memmove(beg + (new_start << CHUNK_SHIFT),
+				beg + (zhdr->start_middle << CHUNK_SHIFT),
+				zhdr->middle_chunks << CHUNK_SHIFT);
+			zhdr->start_middle = new_start;
+			return 1;
+		}
+		if (zhdr->middle_chunks != 0 && zhdr->last_chunks != 0 &&
+		    zhdr->first_chunks == 0 &&
+		    zhdr->middle_chunks + zhdr->last_chunks <=
+		    NCHUNKS - zhdr->start_middle - 2) {
+			unsigned short new_start = NCHUNKS - zhdr->last_chunks -
+				zhdr->middle_chunks;
+			memmove(beg + (new_start << CHUNK_SHIFT),
+				beg + (zhdr->start_middle << CHUNK_SHIFT),
+				zhdr->middle_chunks << CHUNK_SHIFT);
+			zhdr->start_middle = new_start;
+			return 1;
+		}
+	}
+out:
+	return 0;
+}
+
+static unsigned long z3fold_shrink_count(struct shrinker *shrink,
+				struct shrink_control *sc)
+{
+	struct z3fold_pool *pool = container_of(shrink, struct z3fold_pool,
+						shrinker);
+
+	return pool->unbuddied_nr;
+}
+
+static unsigned long z3fold_shrink_scan(struct shrinker *shrink,
+				struct shrink_control *sc)
+{
+	struct z3fold_pool *pool = container_of(shrink, struct z3fold_pool,
+						shrinker);
+	struct z3fold_header *zhdr;
+	int i, nr_to_scan = sc->nr_to_scan;
+
+	spin_lock(&pool->lock);
+
+	for_each_unbuddied_list_down(i, NCHUNKS - 3) {
+		if (!list_empty(&pool->unbuddied[i])) {
+			zhdr = list_first_entry(&pool->unbuddied[i],
+						struct z3fold_header, buddy);
+			if (z3fold_compact_page(zhdr, false)) {
+				int nchunks = num_free_chunks(zhdr);
+				list_del(&zhdr->buddy);
+				list_add(&zhdr->buddy,
+					&pool->unbuddied[nchunks]);
+			}
+			if (!--nr_to_scan)
+				break;
+			spin_unlock(&pool->lock);
+			cond_resched();
+			spin_lock(&pool->lock);
+		}
+	}
+	spin_unlock(&pool->lock);
+	return 0;
+}
+
+
 /*****************
  * API Functions
 *****************/
@@ -228,15 +330,26 @@ static struct z3fold_pool *z3fold_create
 
 	pool = kzalloc(sizeof(struct z3fold_pool), gfp);
 	if (!pool)
-		return NULL;
+		goto out;
 	spin_lock_init(&pool->lock);
 	for_each_unbuddied_list(i, 0)
 		INIT_LIST_HEAD(&pool->unbuddied[i]);
 	INIT_LIST_HEAD(&pool->buddied);
 	INIT_LIST_HEAD(&pool->lru);
+	pool->shrinker.count_objects = z3fold_shrink_count;
+	pool->shrinker.scan_objects = z3fold_shrink_scan;
+	pool->shrinker.seeks = DEFAULT_SEEKS;
+	if (register_shrinker(&pool->shrinker))
+		goto out_free;
 	pool->pages_nr = 0;
+	pool->unbuddied_nr = 0;
 	pool->ops = ops;
 	return pool;
+
+out_free:
+	kfree(pool);
+out:
+	return NULL;
 }
 
 /**
@@ -247,31 +360,10 @@ static struct z3fold_pool *z3fold_create
  */
 static void z3fold_destroy_pool(struct z3fold_pool *pool)
 {
+	unregister_shrinker(&pool->shrinker);
 	kfree(pool);
 }
 
-/* Has to be called with lock held */
-static int z3fold_compact_page(struct z3fold_header *zhdr)
-{
-	struct page *page = virt_to_page(zhdr);
-	void *beg = zhdr;
-
-
-	if (!test_bit(MIDDLE_CHUNK_MAPPED, &page->private) &&
-	    zhdr->middle_chunks != 0 &&
-	    zhdr->first_chunks == 0 && zhdr->last_chunks == 0) {
-		memmove(beg + ZHDR_SIZE_ALIGNED,
-			beg + (zhdr->start_middle << CHUNK_SHIFT),
-			zhdr->middle_chunks << CHUNK_SHIFT);
-		zhdr->first_chunks = zhdr->middle_chunks;
-		zhdr->middle_chunks = 0;
-		zhdr->start_middle = 0;
-		zhdr->first_num++;
-		return 1;
-	}
-	return 0;
-}
-
 /**
  * z3fold_alloc() - allocates a region of a given size
  * @pool:	z3fold pool from which to allocate
@@ -334,6 +426,7 @@ static int z3fold_alloc(struct z3fold_po
 					continue;
 				}
 				list_del(&zhdr->buddy);
+				pool->unbuddied_nr--;
 				goto found;
 			}
 		}
@@ -369,6 +462,7 @@ found:
 		/* Add to unbuddied list */
 		freechunks = num_free_chunks(zhdr);
 		list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
+		pool->unbuddied_nr++;
 	} else {
 		/* Add to buddied list */
 		list_add(&zhdr->buddy, &pool->buddied);
@@ -412,6 +506,11 @@ static void z3fold_free(struct z3fold_po
 		/* HEADLESS page stored */
 		bud = HEADLESS;
 	} else {
+		if (zhdr->first_chunks == 0 ||
+		    zhdr->middle_chunks == 0 ||
+		    zhdr->last_chunks == 0)
+			pool->unbuddied_nr--;
+
 		bud = handle_to_buddy(handle);
 
 		switch (bud) {
@@ -428,6 +527,7 @@ static void z3fold_free(struct z3fold_po
 		default:
 			pr_err("%s: unknown bud %d\n", __func__, bud);
 			WARN_ON(1);
+			pool->unbuddied_nr++;
 			spin_unlock(&pool->lock);
 			return;
 		}
@@ -453,10 +553,11 @@ static void z3fold_free(struct z3fold_po
 		free_z3fold_page(zhdr);
 		pool->pages_nr--;
 	} else {
-		z3fold_compact_page(zhdr);
+		z3fold_compact_page(zhdr, true);
 		/* Add to the unbuddied list */
 		freechunks = num_free_chunks(zhdr);
 		list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
+		pool->unbuddied_nr++;
 	}
 
 	spin_unlock(&pool->lock);
@@ -520,6 +621,11 @@ static int z3fold_reclaim_page(struct z3
 		zhdr = page_address(page);
 		if (!test_bit(PAGE_HEADLESS, &page->private)) {
 			list_del(&zhdr->buddy);
+			if (zhdr->first_chunks == 0 ||
+			    zhdr->middle_chunks == 0 ||
+			    zhdr->last_chunks == 0)
+				pool->unbuddied_nr--;
+
 			/*
 			 * We need encode the handles before unlocking, since
 			 * we can race with free that will set
@@ -579,11 +685,12 @@ next:
 				/* Full, add to buddied list */
 				list_add(&zhdr->buddy, &pool->buddied);
 			} else {
-				z3fold_compact_page(zhdr);
+				z3fold_compact_page(zhdr, true);
 				/* add to unbuddied list */
 				freechunks = num_free_chunks(zhdr);
 				list_add(&zhdr->buddy,
 					 &pool->unbuddied[freechunks]);
+				pool->unbuddied_nr++;
 			}
 		}
 
_

Patches currently in -mm which might be from vitalywool@gmail.com are

z3fold-add-shrinker.patch

