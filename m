From: akpm@linux-foundation.org
Subject: [to-be-updated] z3fold-use-per-page-read-write-lock.patch removed from -mm tree
Date: Wed, 09 Nov 2016 16:33:29 -0800
Message-ID: <5823c059.UB9kl2lTqHXzZhRp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49932 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751498AbcKJAda (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2016 19:33:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalywool@gmail.com, andi@firstfloor.org, ddstreet@ieee.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold.c: use per-page spinlock
has been removed from the -mm tree.  Its filename was
     z3fold-use-per-page-read-write-lock.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vitaly Wool <vitalywool@gmail.com>
Subject: mm/z3fold.c: use per-page spinlock

Most of z3fold operations are in-page, such as modifying z3fold page
header or moving z3fold objects within a page.  Taking per-pool spinlock
to protect per-page objects is therefore suboptimal, and the idea of
having a per-page spinlock (or rwlock) has been around for some time. 
However, adding one directly to the z3fold header makes the latter quite
big on some systems so that it won't fit in a signle chunk.

This patch implements spinlock-based per-page locking mechanism which is
lightweight enough to fit into the z3fold header.

Link: http://lkml.kernel.org/r/20161109115531.81d2a3fd4313236d483510f0@gmail.com
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>,
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |  139 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 99 insertions(+), 40 deletions(-)

diff -puN mm/z3fold.c~z3fold-use-per-page-read-write-lock mm/z3fold.c
--- a/mm/z3fold.c~z3fold-use-per-page-read-write-lock
+++ a/mm/z3fold.c
@@ -98,6 +98,7 @@ enum buddy {
  * struct z3fold_header - z3fold page metadata occupying the first chunk of each
  *			z3fold page, except for HEADLESS pages
  * @buddy:	links the z3fold page into the relevant list in the pool
+ * @page_lock:		per-page lock
  * @first_chunks:	the size of the first buddy in chunks, 0 if free
  * @middle_chunks:	the size of the middle buddy in chunks, 0 if free
  * @last_chunks:	the size of the last buddy in chunks, 0 if free
@@ -105,6 +106,7 @@ enum buddy {
  */
 struct z3fold_header {
 	struct list_head buddy;
+	spinlock_t page_lock;
 	unsigned short first_chunks;
 	unsigned short middle_chunks;
 	unsigned short last_chunks;
@@ -144,6 +146,7 @@ static struct z3fold_header *init_z3fold
 	clear_bit(PAGE_HEADLESS, &page->private);
 	clear_bit(MIDDLE_CHUNK_MAPPED, &page->private);
 
+	spin_lock_init(&zhdr->page_lock);
 	zhdr->first_chunks = 0;
 	zhdr->middle_chunks = 0;
 	zhdr->last_chunks = 0;
@@ -159,6 +162,19 @@ static void free_z3fold_page(struct z3fo
 	__free_page(virt_to_page(zhdr));
 }
 
+/* Lock a z3fold page */
+static inline void z3fold_page_lock(struct z3fold_header *zhdr)
+{
+	spin_lock(&zhdr->page_lock);
+}
+
+/* Unlock a z3fold page */
+static inline void z3fold_page_unlock(struct z3fold_header *zhdr)
+{
+	spin_unlock(&zhdr->page_lock);
+}
+
+
 /*
  * Encodes the handle of a particular buddy within a z3fold page
  * Pool lock should be held as this function accesses first_num
@@ -347,50 +363,60 @@ static int z3fold_alloc(struct z3fold_po
 		bud = HEADLESS;
 	else {
 		chunks = size_to_chunks(size);
-		spin_lock(&pool->lock);
 
 		/* First, try to find an unbuddied z3fold page. */
 		zhdr = NULL;
 		for_each_unbuddied_list(i, chunks) {
-			if (!list_empty(&pool->unbuddied[i])) {
-				zhdr = list_first_entry(&pool->unbuddied[i],
+			spin_lock(&pool->lock);
+			zhdr = list_first_entry_or_null(&pool->unbuddied[i],
 						struct z3fold_header, buddy);
-				page = virt_to_page(zhdr);
-				if (zhdr->first_chunks == 0) {
-					if (zhdr->middle_chunks != 0 &&
-					    chunks >= zhdr->start_middle)
-						bud = LAST;
-					else
-						bud = FIRST;
-				} else if (zhdr->last_chunks == 0)
+			if (!zhdr) {
+				spin_unlock(&pool->lock);
+				continue;
+			}
+			list_del_init(&zhdr->buddy);
+			spin_unlock(&pool->lock);
+
+			page = virt_to_page(zhdr);
+			z3fold_page_lock(zhdr);
+			if (zhdr->first_chunks == 0) {
+				if (zhdr->middle_chunks != 0 &&
+				    chunks >= zhdr->start_middle)
 					bud = LAST;
-				else if (zhdr->middle_chunks == 0)
-					bud = MIDDLE;
-				else {
-					pr_err("No free chunks in unbuddied\n");
-					WARN_ON(1);
-					continue;
-				}
-				list_del(&zhdr->buddy);
-				goto found;
+				else
+					bud = FIRST;
+			} else if (zhdr->last_chunks == 0)
+				bud = LAST;
+			else if (zhdr->middle_chunks == 0)
+				bud = MIDDLE;
+			else {
+				spin_lock(&pool->lock);
+				list_add(&zhdr->buddy, &pool->buddied);
+				spin_unlock(&pool->lock);
+				z3fold_page_unlock(zhdr);
+				pr_err("No free chunks in unbuddied\n");
+				WARN_ON(1);
+				continue;
 			}
+			goto found;
 		}
 		bud = FIRST;
-		spin_unlock(&pool->lock);
 	}
 
 	/* Couldn't find unbuddied z3fold page, create new one */
 	page = alloc_page(gfp);
 	if (!page)
 		return -ENOMEM;
-	spin_lock(&pool->lock);
+
 	atomic64_inc(&pool->pages_nr);
 	zhdr = init_z3fold_page(page);
 
 	if (bud == HEADLESS) {
 		set_bit(PAGE_HEADLESS, &page->private);
+		spin_lock(&pool->lock);
 		goto headless;
 	}
+	z3fold_page_lock(zhdr);
 
 found:
 	if (bud == FIRST)
@@ -402,6 +428,7 @@ found:
 		zhdr->start_middle = zhdr->first_chunks + 1;
 	}
 
+	spin_lock(&pool->lock);
 	if (zhdr->first_chunks == 0 || zhdr->last_chunks == 0 ||
 			zhdr->middle_chunks == 0) {
 		/* Add to unbuddied list */
@@ -421,6 +448,8 @@ headless:
 
 	*handle = encode_handle(zhdr, bud);
 	spin_unlock(&pool->lock);
+	if (bud != HEADLESS)
+		z3fold_page_unlock(zhdr);
 
 	return 0;
 }
@@ -442,7 +471,6 @@ static void z3fold_free(struct z3fold_po
 	struct page *page;
 	enum buddy bud;
 
-	spin_lock(&pool->lock);
 	zhdr = handle_to_z3fold_header(handle);
 	page = virt_to_page(zhdr);
 
@@ -450,6 +478,7 @@ static void z3fold_free(struct z3fold_po
 		/* HEADLESS page stored */
 		bud = HEADLESS;
 	} else {
+		z3fold_page_lock(zhdr);
 		bud = handle_to_buddy(handle);
 
 		switch (bud) {
@@ -466,37 +495,59 @@ static void z3fold_free(struct z3fold_po
 		default:
 			pr_err("%s: unknown bud %d\n", __func__, bud);
 			WARN_ON(1);
-			spin_unlock(&pool->lock);
+			z3fold_page_unlock(zhdr);
 			return;
 		}
 	}
 
 	if (test_bit(UNDER_RECLAIM, &page->private)) {
 		/* z3fold page is under reclaim, reclaim will free */
-		spin_unlock(&pool->lock);
+		if (bud != HEADLESS)
+			z3fold_page_unlock(zhdr);
 		return;
 	}
 
 	/* Remove from existing buddy list */
-	if (bud != HEADLESS)
-		list_del(&zhdr->buddy);
+	if (bud != HEADLESS) {
+		spin_lock(&pool->lock);
+		/*
+		 * this object may have been removed from its list by
+		 * z3fold_alloc(). In that case we just do nothing,
+		 * z3fold_alloc() will allocate an object and add the page
+		 * to the relevant list.
+		 */
+		if (!list_empty(&zhdr->buddy)) {
+			list_del(&zhdr->buddy);
+		} else {
+			spin_unlock(&pool->lock);
+			z3fold_page_unlock(zhdr);
+			return;
+		}
+		spin_unlock(&pool->lock);
+	}
 
 	if (bud == HEADLESS ||
 	    (zhdr->first_chunks == 0 && zhdr->middle_chunks == 0 &&
 			zhdr->last_chunks == 0)) {
 		/* z3fold page is empty, free */
+		spin_lock(&pool->lock);
 		list_del(&page->lru);
+		spin_unlock(&pool->lock);
 		clear_bit(PAGE_HEADLESS, &page->private);
+		if (bud != HEADLESS)
+			z3fold_page_unlock(zhdr);
 		free_z3fold_page(zhdr);
 		atomic64_dec(&pool->pages_nr);
 	} else {
 		z3fold_compact_page(zhdr);
 		/* Add to the unbuddied list */
+		spin_lock(&pool->lock);
 		freechunks = num_free_chunks(zhdr);
 		list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
+		spin_unlock(&pool->lock);
+		z3fold_page_unlock(zhdr);
 	}
 
-	spin_unlock(&pool->lock);
 }
 
 /**
@@ -557,8 +608,11 @@ static int z3fold_reclaim_page(struct z3
 		zhdr = page_address(page);
 		if (!test_bit(PAGE_HEADLESS, &page->private)) {
 			list_del(&zhdr->buddy);
+			spin_unlock(&pool->lock);
+			z3fold_page_lock(zhdr);
+
 			/*
-			 * We need encode the handles before unlocking, since
+			 * We need to encode the handles before unlocking, since
 			 * we can race with free that will set
 			 * (first|last)_chunks to 0
 			 */
@@ -571,13 +625,13 @@ static int z3fold_reclaim_page(struct z3
 				middle_handle = encode_handle(zhdr, MIDDLE);
 			if (zhdr->last_chunks)
 				last_handle = encode_handle(zhdr, LAST);
+			z3fold_page_unlock(zhdr);
 		} else {
 			first_handle = encode_handle(zhdr, HEADLESS);
 			last_handle = middle_handle = 0;
+			spin_unlock(&pool->lock);
 		}
 
-		spin_unlock(&pool->lock);
-
 		/* Issue the eviction callback(s) */
 		if (middle_handle) {
 			ret = pool->ops->evict(pool, middle_handle);
@@ -595,7 +649,8 @@ static int z3fold_reclaim_page(struct z3
 				goto next;
 		}
 next:
-		spin_lock(&pool->lock);
+		if (!test_bit(PAGE_HEADLESS, &page->private))
+			z3fold_page_lock(zhdr);
 		clear_bit(UNDER_RECLAIM, &page->private);
 		if ((test_bit(PAGE_HEADLESS, &page->private) && ret == 0) ||
 		    (zhdr->first_chunks == 0 && zhdr->last_chunks == 0 &&
@@ -605,19 +660,22 @@ next:
 			 * return success.
 			 */
 			clear_bit(PAGE_HEADLESS, &page->private);
+			if (!test_bit(PAGE_HEADLESS, &page->private))
+				z3fold_page_unlock(zhdr);
 			free_z3fold_page(zhdr);
 			atomic64_dec(&pool->pages_nr);
-			spin_unlock(&pool->lock);
 			return 0;
 		}  else if (!test_bit(PAGE_HEADLESS, &page->private)) {
 			if (zhdr->first_chunks != 0 &&
 			    zhdr->last_chunks != 0 &&
 			    zhdr->middle_chunks != 0) {
 				/* Full, add to buddied list */
+				spin_lock(&pool->lock);
 				list_add(&zhdr->buddy, &pool->buddied);
 			} else {
 				z3fold_compact_page(zhdr);
 				/* add to unbuddied list */
+				spin_lock(&pool->lock);
 				freechunks = num_free_chunks(zhdr);
 				list_add(&zhdr->buddy,
 					 &pool->unbuddied[freechunks]);
@@ -628,6 +686,8 @@ next:
 		list_add(&page->lru, &pool->lru);
 	}
 	spin_unlock(&pool->lock);
+	if (!test_bit(PAGE_HEADLESS, &page->private))
+		z3fold_page_unlock(zhdr);
 	return -EAGAIN;
 }
 
@@ -648,7 +708,6 @@ static void *z3fold_map(struct z3fold_po
 	void *addr;
 	enum buddy buddy;
 
-	spin_lock(&pool->lock);
 	zhdr = handle_to_z3fold_header(handle);
 	addr = zhdr;
 	page = virt_to_page(zhdr);
@@ -656,6 +715,7 @@ static void *z3fold_map(struct z3fold_po
 	if (test_bit(PAGE_HEADLESS, &page->private))
 		goto out;
 
+	z3fold_page_lock(zhdr);
 	buddy = handle_to_buddy(handle);
 	switch (buddy) {
 	case FIRST:
@@ -674,8 +734,9 @@ static void *z3fold_map(struct z3fold_po
 		addr = NULL;
 		break;
 	}
+
+	z3fold_page_unlock(zhdr);
 out:
-	spin_unlock(&pool->lock);
 	return addr;
 }
 
@@ -690,19 +751,17 @@ static void z3fold_unmap(struct z3fold_p
 	struct page *page;
 	enum buddy buddy;
 
-	spin_lock(&pool->lock);
 	zhdr = handle_to_z3fold_header(handle);
 	page = virt_to_page(zhdr);
 
-	if (test_bit(PAGE_HEADLESS, &page->private)) {
-		spin_unlock(&pool->lock);
+	if (test_bit(PAGE_HEADLESS, &page->private))
 		return;
-	}
 
+	z3fold_page_lock(zhdr);
 	buddy = handle_to_buddy(handle);
 	if (buddy == MIDDLE)
 		clear_bit(MIDDLE_CHUNK_MAPPED, &page->private);
-	spin_unlock(&pool->lock);
+	z3fold_page_unlock(zhdr);
 }
 
 /**
_

Patches currently in -mm which might be from vitalywool@gmail.com are

z3fold-make-pages_nr-atomic.patch
z3fold-extend-compaction-function.patch

