From: akpm@linux-foundation.org
Subject: + mm-consistent-truncate-and-invalidate-loops.patch added to -mm tree
Date: Thu, 09 Jun 2011 15:42:42 -0700
Message-ID: <201106092242.p59MggoD005065@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756994Ab1FIWnM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 18:43:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com


The patch titled
     mm: consistent truncate and invalidate loops
has been added to the -mm tree.  Its filename is
     mm-consistent-truncate-and-invalidate-loops.patch

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
Subject: mm: consistent truncate and invalidate loops
From: Hugh Dickins <hughd@google.com>

Make the pagevec_lookup loops in truncate_inode_pages_range(),
invalidate_mapping_pages() and invalidate_inode_pages2_range() more
consistent with each other.

They were relying upon page->index of an unlocked page, but apologizing
for it: accept it, embrace it, add comments and WARN_ONs, and simplify the
index handling.

invalidate_inode_pages2_range() had special handling for a wrapped
page->index + 1 = 0 case; but MAX_LFS_FILESIZE doesn't let us anywhere
near there, and a corrupt page->index in the radix_tree could cause more
trouble than that would catch.  Remove that wrapped handling.

invalidate_inode_pages2_range() uses min() to limit the pagevec_lookup
when near the end of the range: copy that into the other two, although
it's less useful than you might think (it limits the use of the buffer,
rather than the indices looked up).

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c  |    2 
 mm/truncate.c |  110 ++++++++++++++++++++----------------------------
 2 files changed, 49 insertions(+), 63 deletions(-)

diff -puN mm/filemap.c~mm-consistent-truncate-and-invalidate-loops mm/filemap.c
--- a/mm/filemap.c~mm-consistent-truncate-and-invalidate-loops
+++ a/mm/filemap.c
@@ -131,6 +131,7 @@ void __delete_from_page_cache(struct pag
 
 	radix_tree_delete(&mapping->page_tree, page->index);
 	page->mapping = NULL;
+	/* Leave page->index set: truncation lookup relies upon it */
 	mapping->nrpages--;
 	__dec_zone_page_state(page, NR_FILE_PAGES);
 	if (PageSwapBacked(page))
@@ -486,6 +487,7 @@ int add_to_page_cache_locked(struct page
 			spin_unlock_irq(&mapping->tree_lock);
 		} else {
 			page->mapping = NULL;
+			/* Leave page->index set: truncation relies upon it */
 			spin_unlock_irq(&mapping->tree_lock);
 			mem_cgroup_uncharge_cache_page(page);
 			page_cache_release(page);
diff -puN mm/truncate.c~mm-consistent-truncate-and-invalidate-loops mm/truncate.c
--- a/mm/truncate.c~mm-consistent-truncate-and-invalidate-loops
+++ a/mm/truncate.c
@@ -199,9 +199,6 @@ int invalidate_inode_page(struct page *p
  * The first pass will remove most pages, so the search cost of the second pass
  * is low.
  *
- * When looking at page->index outside the page lock we need to be careful to
- * copy it into a local to avoid races (it could change at any time).
- *
  * We pass down the cache-hot hint to the page freeing code.  Even if the
  * mapping is large, it is probably the case that the final pages are the most
  * recently touched, and freeing happens in ascending file offset order.
@@ -210,10 +207,10 @@ void truncate_inode_pages_range(struct a
 				loff_t lstart, loff_t lend)
 {
 	const pgoff_t start = (lstart + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
-	pgoff_t end;
 	const unsigned partial = lstart & (PAGE_CACHE_SIZE - 1);
 	struct pagevec pvec;
-	pgoff_t next;
+	pgoff_t index;
+	pgoff_t end;
 	int i;
 
 	cleancache_flush_inode(mapping);
@@ -224,24 +221,21 @@ void truncate_inode_pages_range(struct a
 	end = (lend >> PAGE_CACHE_SHIFT);
 
 	pagevec_init(&pvec, 0);
-	next = start;
-	while (next <= end &&
-	       pagevec_lookup(&pvec, mapping, next, PAGEVEC_SIZE)) {
+	index = start;
+	while (index <= end && pagevec_lookup(&pvec, mapping, index,
+			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
 		mem_cgroup_uncharge_start();
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
-			pgoff_t page_index = page->index;
 
-			if (page_index > end) {
-				next = page_index;
+			/* We rely upon deletion not changing page->index */
+			index = page->index;
+			if (index > end)
 				break;
-			}
 
-			if (page_index > next)
-				next = page_index;
-			next++;
 			if (!trylock_page(page))
 				continue;
+			WARN_ON(page->index != index);
 			if (PageWriteback(page)) {
 				unlock_page(page);
 				continue;
@@ -252,6 +246,7 @@ void truncate_inode_pages_range(struct a
 		pagevec_release(&pvec);
 		mem_cgroup_uncharge_end();
 		cond_resched();
+		index++;
 	}
 
 	if (partial) {
@@ -264,13 +259,14 @@ void truncate_inode_pages_range(struct a
 		}
 	}
 
-	next = start;
+	index = start;
 	for ( ; ; ) {
 		cond_resched();
-		if (!pagevec_lookup(&pvec, mapping, next, PAGEVEC_SIZE)) {
-			if (next == start)
+		if (!pagevec_lookup(&pvec, mapping, index,
+			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
+			if (index == start)
 				break;
-			next = start;
+			index = start;
 			continue;
 		}
 		if (pvec.pages[0]->index > end) {
@@ -281,18 +277,20 @@ void truncate_inode_pages_range(struct a
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 
-			if (page->index > end)
+			/* We rely upon deletion not changing page->index */
+			index = page->index;
+			if (index > end)
 				break;
+
 			lock_page(page);
+			WARN_ON(page->index != index);
 			wait_on_page_writeback(page);
 			truncate_inode_page(mapping, page);
-			if (page->index > next)
-				next = page->index;
-			next++;
 			unlock_page(page);
 		}
 		pagevec_release(&pvec);
 		mem_cgroup_uncharge_end();
+		index++;
 	}
 	cleancache_flush_inode(mapping);
 }
@@ -328,35 +326,26 @@ unsigned long invalidate_mapping_pages(s
 		pgoff_t start, pgoff_t end)
 {
 	struct pagevec pvec;
-	pgoff_t next = start;
+	pgoff_t index = start;
 	unsigned long ret;
 	unsigned long count = 0;
 	int i;
 
 	pagevec_init(&pvec, 0);
-	while (next <= end &&
-			pagevec_lookup(&pvec, mapping, next, PAGEVEC_SIZE)) {
+	while (index <= end && pagevec_lookup(&pvec, mapping, index,
+			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
 		mem_cgroup_uncharge_start();
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
-			pgoff_t index;
-			int lock_failed;
-
-			lock_failed = !trylock_page(page);
 
-			/*
-			 * We really shouldn't be looking at the ->index of an
-			 * unlocked page.  But we're not allowed to lock these
-			 * pages.  So we rely upon nobody altering the ->index
-			 * of this (pinned-by-us) page.
-			 */
+			/* We rely upon deletion not changing page->index */
 			index = page->index;
-			if (index > next)
-				next = index;
-			next++;
-			if (lock_failed)
-				continue;
+			if (index > end)
+				break;
 
+			if (!trylock_page(page))
+				continue;
+			WARN_ON(page->index != index);
 			ret = invalidate_inode_page(page);
 			unlock_page(page);
 			/*
@@ -366,12 +355,11 @@ unsigned long invalidate_mapping_pages(s
 			if (!ret)
 				deactivate_page(page);
 			count += ret;
-			if (next > end)
-				break;
 		}
 		pagevec_release(&pvec);
 		mem_cgroup_uncharge_end();
 		cond_resched();
+		index++;
 	}
 	return count;
 }
@@ -437,37 +425,32 @@ int invalidate_inode_pages2_range(struct
 				  pgoff_t start, pgoff_t end)
 {
 	struct pagevec pvec;
-	pgoff_t next;
+	pgoff_t index;
 	int i;
 	int ret = 0;
 	int ret2 = 0;
 	int did_range_unmap = 0;
-	int wrapped = 0;
 
 	cleancache_flush_inode(mapping);
 	pagevec_init(&pvec, 0);
-	next = start;
-	while (next <= end && !wrapped &&
-		pagevec_lookup(&pvec, mapping, next,
-			min(end - next, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
+	index = start;
+	while (index <= end && pagevec_lookup(&pvec, mapping, index,
+			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
 		mem_cgroup_uncharge_start();
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
-			pgoff_t page_index;
+
+			/* We rely upon deletion not changing page->index */
+			index = page->index;
+			if (index > end)
+				break;
 
 			lock_page(page);
+			WARN_ON(page->index != index);
 			if (page->mapping != mapping) {
 				unlock_page(page);
 				continue;
 			}
-			page_index = page->index;
-			next = page_index + 1;
-			if (next == 0)
-				wrapped = 1;
-			if (page_index > end) {
-				unlock_page(page);
-				break;
-			}
 			wait_on_page_writeback(page);
 			if (page_mapped(page)) {
 				if (!did_range_unmap) {
@@ -475,9 +458,9 @@ int invalidate_inode_pages2_range(struct
 					 * Zap the rest of the file in one hit.
 					 */
 					unmap_mapping_range(mapping,
-					   (loff_t)page_index<<PAGE_CACHE_SHIFT,
-					   (loff_t)(end - page_index + 1)
-							<< PAGE_CACHE_SHIFT,
+					   (loff_t)index << PAGE_CACHE_SHIFT,
+					   (loff_t)(1 + end - index)
+							 << PAGE_CACHE_SHIFT,
 					    0);
 					did_range_unmap = 1;
 				} else {
@@ -485,8 +468,8 @@ int invalidate_inode_pages2_range(struct
 					 * Just zap this page
 					 */
 					unmap_mapping_range(mapping,
-					  (loff_t)page_index<<PAGE_CACHE_SHIFT,
-					  PAGE_CACHE_SIZE, 0);
+					   (loff_t)index << PAGE_CACHE_SHIFT,
+					   PAGE_CACHE_SIZE, 0);
 				}
 			}
 			BUG_ON(page_mapped(page));
@@ -502,6 +485,7 @@ int invalidate_inode_pages2_range(struct
 		pagevec_release(&pvec);
 		mem_cgroup_uncharge_end();
 		cond_resched();
+		index++;
 	}
 	cleancache_flush_inode(mapping);
 	return ret;
_

Patches currently in -mm which might be from hughd@google.com are

mm-fix-wrong-kunmap_atomic-pointer.patch
mm-migratec-dont-account-swapcache-as-shmem.patch
linux-next.patch
mm-move-vmtruncate_range-to-truncatec.patch
mm-move-shmem-prototypes-to-shmem_fsh.patch
tmpfs-take-control-of-its-truncate_range.patch
tmpfs-add-shmem_read_mapping_page_gfp.patch
drm-ttm-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_truncate_range.patch
drm-i915-more-struct_mutex-locking.patch
mm-cleanup-descriptions-of-filler-arg.patch
mm-truncate-functions-are-in-truncatec.patch
mm-tidy-vmtruncate_range-and-related-functions.patch
mm-consistent-truncate-and-invalidate-loops.patch
mm-pincer-in-truncate_inode_pages_range.patch
tmpfs-no-need-to-use-i_lock.patch
prio_tree-debugging-patch.patch

