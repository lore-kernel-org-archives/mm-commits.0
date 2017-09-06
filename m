From: akpm@linux-foundation.org
Subject: [patch 049/119] mm: make pagevec_lookup() update index
Date: Wed, 06 Sep 2017 16:21:18 -0700
Message-ID: <20170906232118.0tvzYytcd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49872 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753570AbdIFXVT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:21:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Jan Kara <jack@suse.cz>
Subject: mm: make pagevec_lookup() update index

Make pagevec_lookup() (and underlying find_get_pages()) update index to
the next page where iteration should continue.  Most callers want this and
also pagevec_lookup_tag() already does this.

Link: http://lkml.kernel.org/r/20170726114704.7626-3-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c             |   10 ++++------
 fs/ext4/file.c          |    4 +---
 fs/ext4/inode.c         |    8 ++------
 fs/fscache/page.c       |    5 ++---
 fs/hugetlbfs/inode.c    |   17 ++++++++---------
 fs/nilfs2/page.c        |    3 +--
 fs/ramfs/file-nommu.c   |    2 +-
 include/linux/pagemap.h |    2 +-
 include/linux/pagevec.h |    2 +-
 mm/filemap.c            |   11 ++++++++---
 mm/swap.c               |    5 +++--
 11 files changed, 32 insertions(+), 37 deletions(-)

diff -puN fs/buffer.c~mm-make-pagevec_lookup-update-index fs/buffer.c
--- a/fs/buffer.c~mm-make-pagevec_lookup-update-index
+++ a/fs/buffer.c
@@ -1633,13 +1633,12 @@ void clean_bdev_aliases(struct block_dev
 
 	end = (block + len - 1) >> (PAGE_SHIFT - bd_inode->i_blkbits);
 	pagevec_init(&pvec, 0);
-	while (index <= end && pagevec_lookup(&pvec, bd_mapping, index,
+	while (index <= end && pagevec_lookup(&pvec, bd_mapping, &index,
 			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 
-			index = page->index;
-			if (index > end)
+			if (page->index > end)
 				break;
 			if (!page_has_buffers(page))
 				continue;
@@ -1670,7 +1669,6 @@ unlock_page:
 		}
 		pagevec_release(&pvec);
 		cond_resched();
-		index++;
 	}
 }
 EXPORT_SYMBOL(clean_bdev_aliases);
@@ -3552,7 +3550,8 @@ page_cache_seek_hole_data(struct inode *
 		unsigned want, nr_pages, i;
 
 		want = min_t(unsigned, end - index, PAGEVEC_SIZE);
-		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, index, want);
+		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, &index,
+					  want);
 		if (nr_pages == 0)
 			break;
 
@@ -3594,7 +3593,6 @@ page_cache_seek_hole_data(struct inode *
 		if (nr_pages < want)
 			break;
 
-		index = pvec.pages[i - 1]->index + 1;
 		pagevec_release(&pvec);
 	} while (index < end);
 
diff -puN fs/ext4/file.c~mm-make-pagevec_lookup-update-index fs/ext4/file.c
--- a/fs/ext4/file.c~mm-make-pagevec_lookup-update-index
+++ a/fs/ext4/file.c
@@ -468,7 +468,7 @@ static int ext4_find_unwritten_pgoff(str
 		unsigned long nr_pages;
 
 		num = min_t(pgoff_t, end - index, PAGEVEC_SIZE - 1) + 1;
-		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, index,
+		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, &index,
 					  (pgoff_t)num);
 		if (nr_pages == 0)
 			break;
@@ -536,8 +536,6 @@ next:
 		/* The no. of pages is less than our desired, we are done. */
 		if (nr_pages < num)
 			break;
-
-		index = pvec.pages[i - 1]->index + 1;
 		pagevec_release(&pvec);
 	} while (index <= end);
 
diff -puN fs/ext4/inode.c~mm-make-pagevec_lookup-update-index fs/ext4/inode.c
--- a/fs/ext4/inode.c~mm-make-pagevec_lookup-update-index
+++ a/fs/ext4/inode.c
@@ -1720,7 +1720,7 @@ static void mpage_release_unused_pages(s
 
 	pagevec_init(&pvec, 0);
 	while (index <= end) {
-		nr_pages = pagevec_lookup(&pvec, mapping, index, PAGEVEC_SIZE);
+		nr_pages = pagevec_lookup(&pvec, mapping, &index, PAGEVEC_SIZE);
 		if (nr_pages == 0)
 			break;
 		for (i = 0; i < nr_pages; i++) {
@@ -1737,7 +1737,6 @@ static void mpage_release_unused_pages(s
 			}
 			unlock_page(page);
 		}
-		index = pvec.pages[nr_pages - 1]->index + 1;
 		pagevec_release(&pvec);
 	}
 }
@@ -2348,7 +2347,7 @@ static int mpage_map_and_submit_buffers(
 
 	pagevec_init(&pvec, 0);
 	while (start <= end) {
-		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, start,
+		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, &start,
 					  PAGEVEC_SIZE);
 		if (nr_pages == 0)
 			break;
@@ -2357,8 +2356,6 @@ static int mpage_map_and_submit_buffers(
 
 			if (page->index > end)
 				break;
-			/* Up to 'end' pages must be contiguous */
-			BUG_ON(page->index != start);
 			bh = head = page_buffers(page);
 			do {
 				if (lblk < mpd->map.m_lblk)
@@ -2403,7 +2400,6 @@ static int mpage_map_and_submit_buffers(
 				pagevec_release(&pvec);
 				return err;
 			}
-			start++;
 		}
 		pagevec_release(&pvec);
 	}
diff -puN fs/fscache/page.c~mm-make-pagevec_lookup-update-index fs/fscache/page.c
--- a/fs/fscache/page.c~mm-make-pagevec_lookup-update-index
+++ a/fs/fscache/page.c
@@ -1178,11 +1178,10 @@ void __fscache_uncache_all_inode_pages(s
 	pagevec_init(&pvec, 0);
 	next = 0;
 	do {
-		if (!pagevec_lookup(&pvec, mapping, next, PAGEVEC_SIZE))
+		if (!pagevec_lookup(&pvec, mapping, &next, PAGEVEC_SIZE))
 			break;
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
-			next = page->index;
 			if (PageFsCache(page)) {
 				__fscache_wait_on_page_write(cookie, page);
 				__fscache_uncache_page(cookie, page);
@@ -1190,7 +1189,7 @@ void __fscache_uncache_all_inode_pages(s
 		}
 		pagevec_release(&pvec);
 		cond_resched();
-	} while (++next);
+	} while (next);
 
 	_leave("");
 }
diff -puN fs/hugetlbfs/inode.c~mm-make-pagevec_lookup-update-index fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-make-pagevec_lookup-update-index
+++ a/fs/hugetlbfs/inode.c
@@ -401,7 +401,7 @@ static void remove_inode_hugepages(struc
 	const pgoff_t end = lend >> huge_page_shift(h);
 	struct vm_area_struct pseudo_vma;
 	struct pagevec pvec;
-	pgoff_t next;
+	pgoff_t next, index;
 	int i, freed = 0;
 	long lookup_nr = PAGEVEC_SIZE;
 	bool truncate_op = (lend == LLONG_MAX);
@@ -420,7 +420,7 @@ static void remove_inode_hugepages(struc
 		/*
 		 * When no more pages are found, we are done.
 		 */
-		if (!pagevec_lookup(&pvec, mapping, next, lookup_nr))
+		if (!pagevec_lookup(&pvec, mapping, &next, lookup_nr))
 			break;
 
 		for (i = 0; i < pagevec_count(&pvec); ++i) {
@@ -432,13 +432,13 @@ static void remove_inode_hugepages(struc
 			 * only possible in the punch hole case as end is
 			 * max page offset in the truncate case.
 			 */
-			next = page->index;
-			if (next >= end)
+			index = page->index;
+			if (index >= end)
 				break;
 
 			hash = hugetlb_fault_mutex_hash(h, current->mm,
 							&pseudo_vma,
-							mapping, next, 0);
+							mapping, index, 0);
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 			/*
@@ -455,8 +455,8 @@ static void remove_inode_hugepages(struc
 
 				i_mmap_lock_write(mapping);
 				hugetlb_vmdelete_list(&mapping->i_mmap,
-					next * pages_per_huge_page(h),
-					(next + 1) * pages_per_huge_page(h));
+					index * pages_per_huge_page(h),
+					(index + 1) * pages_per_huge_page(h));
 				i_mmap_unlock_write(mapping);
 			}
 
@@ -475,14 +475,13 @@ static void remove_inode_hugepages(struc
 			freed++;
 			if (!truncate_op) {
 				if (unlikely(hugetlb_unreserve_pages(inode,
-							next, next + 1, 1)))
+							index, index + 1, 1)))
 					hugetlb_fix_reserve_counts(inode);
 			}
 
 			unlock_page(page);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		}
-		++next;
 		huge_pagevec_release(&pvec);
 		cond_resched();
 	}
diff -puN fs/nilfs2/page.c~mm-make-pagevec_lookup-update-index fs/nilfs2/page.c
--- a/fs/nilfs2/page.c~mm-make-pagevec_lookup-update-index
+++ a/fs/nilfs2/page.c
@@ -312,10 +312,9 @@ void nilfs_copy_back_pages(struct addres
 
 	pagevec_init(&pvec, 0);
 repeat:
-	n = pagevec_lookup(&pvec, smap, index, PAGEVEC_SIZE);
+	n = pagevec_lookup(&pvec, smap, &index, PAGEVEC_SIZE);
 	if (!n)
 		return;
-	index = pvec.pages[n - 1]->index + 1;
 
 	for (i = 0; i < pagevec_count(&pvec); i++) {
 		struct page *page = pvec.pages[i], *dpage;
diff -puN fs/ramfs/file-nommu.c~mm-make-pagevec_lookup-update-index fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~mm-make-pagevec_lookup-update-index
+++ a/fs/ramfs/file-nommu.c
@@ -228,7 +228,7 @@ static unsigned long ramfs_nommu_get_unm
 	if (!pages)
 		goto out_free;
 
-	nr = find_get_pages(inode->i_mapping, pgoff, lpages, pages);
+	nr = find_get_pages(inode->i_mapping, &pgoff, lpages, pages);
 	if (nr != lpages)
 		goto out_free_pages; /* leave if some pages were missing */
 
diff -puN include/linux/pagemap.h~mm-make-pagevec_lookup-update-index include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-make-pagevec_lookup-update-index
+++ a/include/linux/pagemap.h
@@ -353,7 +353,7 @@ struct page *find_lock_entry(struct addr
 unsigned find_get_entries(struct address_space *mapping, pgoff_t start,
 			  unsigned int nr_entries, struct page **entries,
 			  pgoff_t *indices);
-unsigned find_get_pages(struct address_space *mapping, pgoff_t start,
+unsigned find_get_pages(struct address_space *mapping, pgoff_t *start,
 			unsigned int nr_pages, struct page **pages);
 unsigned find_get_pages_contig(struct address_space *mapping, pgoff_t start,
 			       unsigned int nr_pages, struct page **pages);
diff -puN include/linux/pagevec.h~mm-make-pagevec_lookup-update-index include/linux/pagevec.h
--- a/include/linux/pagevec.h~mm-make-pagevec_lookup-update-index
+++ a/include/linux/pagevec.h
@@ -28,7 +28,7 @@ unsigned pagevec_lookup_entries(struct p
 				pgoff_t *indices);
 void pagevec_remove_exceptionals(struct pagevec *pvec);
 unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
-		pgoff_t start, unsigned nr_pages);
+		pgoff_t *start, unsigned nr_pages);
 unsigned pagevec_lookup_tag(struct pagevec *pvec,
 		struct address_space *mapping, pgoff_t *index, int tag,
 		unsigned nr_pages);
diff -puN mm/filemap.c~mm-make-pagevec_lookup-update-index mm/filemap.c
--- a/mm/filemap.c~mm-make-pagevec_lookup-update-index
+++ a/mm/filemap.c
@@ -403,7 +403,7 @@ bool filemap_range_has_page(struct addre
 		return false;
 
 	pagevec_init(&pvec, 0);
-	if (!pagevec_lookup(&pvec, mapping, index, 1))
+	if (!pagevec_lookup(&pvec, mapping, &index, 1))
 		return false;
 	ret = (pvec.pages[0]->index <= end);
 	pagevec_release(&pvec);
@@ -1569,10 +1569,11 @@ export:
  *
  * The search returns a group of mapping-contiguous pages with ascending
  * indexes.  There may be holes in the indices due to not-present pages.
+ * We also update @start to index the next page for the traversal.
  *
  * find_get_pages() returns the number of pages which were found.
  */
-unsigned find_get_pages(struct address_space *mapping, pgoff_t start,
+unsigned find_get_pages(struct address_space *mapping, pgoff_t *start,
 			    unsigned int nr_pages, struct page **pages)
 {
 	struct radix_tree_iter iter;
@@ -1583,7 +1584,7 @@ unsigned find_get_pages(struct address_s
 		return 0;
 
 	rcu_read_lock();
-	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
+	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, *start) {
 		struct page *head, *page;
 repeat:
 		page = radix_tree_deref_slot(slot);
@@ -1625,6 +1626,10 @@ repeat:
 	}
 
 	rcu_read_unlock();
+
+	if (ret)
+		*start = pages[ret - 1]->index + 1;
+
 	return ret;
 }
 
diff -puN mm/swap.c~mm-make-pagevec_lookup-update-index mm/swap.c
--- a/mm/swap.c~mm-make-pagevec_lookup-update-index
+++ a/mm/swap.c
@@ -957,12 +957,13 @@ void pagevec_remove_exceptionals(struct
  * reference against the pages in @pvec.
  *
  * The search returns a group of mapping-contiguous pages with ascending
- * indexes.  There may be holes in the indices due to not-present pages.
+ * indexes.  There may be holes in the indices due to not-present pages. We
+ * also update @start to index the next page for the traversal.
  *
  * pagevec_lookup() returns the number of pages which were found.
  */
 unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
-		pgoff_t start, unsigned nr_pages)
+		pgoff_t *start, unsigned nr_pages)
 {
 	pvec->nr = find_get_pages(mapping, start, nr_pages, pvec->pages);
 	return pagevec_count(pvec);
_
