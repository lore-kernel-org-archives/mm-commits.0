From: akpm@linux-foundation.org
Subject: +
 mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix-fix.patch
 added to -mm tree
Date: Wed, 12 Mar 2014 13:06:41 -0700
Message-ID: <5320be51.UsMK4uQXJDSiAYXS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57628 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaCLUGm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Mar 2014 16:06:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, minchan@kernel.org, mel@csn.ul.ie, hughd@google.com, hannes@cmpxchg.org

Subject: + mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix-fix.patch added to -mm tree
To: hannes@cmpxchg.org,hughd@google.com,mel@csn.ul.ie,minchan@kernel.org,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 12 Mar 2014 13:06:41 -0700


The patch titled
     Subject: mm: __find_get_page() -> find_get_entry()
has been added to the -mm tree.  Its filename is
     mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: __find_get_page() -> find_get_entry()

__find_get_page() -> find_get_entry()
__find_lock_page() -> find_lock_entry()
__find_get_pages() -> find_get_entries()
__pagevec_lookup() -> pagevec_lookup_entries()

Also update and fix stale kerneldocs and revert gratuitous whitespace
changes.

Based on feedback from Mel Gorman.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    8 ++--
 include/linux/pagevec.h |    6 ++-
 mm/filemap.c            |   65 +++++++++++++++++++-------------------
 mm/mincore.c            |    2 -
 mm/shmem.c              |   12 +++----
 mm/swap.c               |   31 +++++++++---------
 mm/truncate.c           |    8 ++--
 7 files changed, 70 insertions(+), 62 deletions(-)

diff -puN include/linux/pagemap.h~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix-fix include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix-fix
+++ a/include/linux/pagemap.h
@@ -248,14 +248,14 @@ pgoff_t page_cache_next_hole(struct addr
 pgoff_t page_cache_prev_hole(struct address_space *mapping,
 			     pgoff_t index, unsigned long max_scan);
 
-struct page *__find_get_page(struct address_space *mapping, pgoff_t offset);
+struct page *find_get_entry(struct address_space *mapping, pgoff_t offset);
 struct page *find_get_page(struct address_space *mapping, pgoff_t offset);
-struct page *__find_lock_page(struct address_space *mapping, pgoff_t offset);
+struct page *find_lock_entry(struct address_space *mapping, pgoff_t offset);
 struct page *find_lock_page(struct address_space *mapping, pgoff_t offset);
 struct page *find_or_create_page(struct address_space *mapping, pgoff_t index,
 				 gfp_t gfp_mask);
-unsigned __find_get_pages(struct address_space *mapping, pgoff_t start,
-			  unsigned int nr_pages, struct page **pages,
+unsigned find_get_entries(struct address_space *mapping, pgoff_t start,
+			  unsigned int nr_entries, struct page **entries,
 			  pgoff_t *indices);
 unsigned find_get_pages(struct address_space *mapping, pgoff_t start,
 			unsigned int nr_pages, struct page **pages);
diff -puN include/linux/pagevec.h~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix-fix include/linux/pagevec.h
--- a/include/linux/pagevec.h~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix-fix
+++ a/include/linux/pagevec.h
@@ -22,8 +22,10 @@ struct pagevec {
 
 void __pagevec_release(struct pagevec *pvec);
 void __pagevec_lru_add(struct pagevec *pvec);
-unsigned __pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
-			  pgoff_t start, unsigned nr_pages, pgoff_t *indices);
+unsigned pagevec_lookup_entries(struct pagevec *pvec,
+				struct address_space *mapping,
+				pgoff_t start, unsigned nr_entries,
+				pgoff_t *indices);
 void pagevec_remove_exceptionals(struct pagevec *pvec);
 unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
 		pgoff_t start, unsigned nr_pages);
diff -puN mm/filemap.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix-fix mm/filemap.c
--- a/mm/filemap.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix-fix
+++ a/mm/filemap.c
@@ -790,9 +790,9 @@ pgoff_t page_cache_prev_hole(struct addr
 EXPORT_SYMBOL(page_cache_prev_hole);
 
 /**
- * __find_get_page - find and get a page reference
+ * find_get_entry - find and get a page cache entry
  * @mapping: the address_space to search
- * @offset: the page index
+ * @offset: the page cache index
  *
  * Looks up the page cache slot at @mapping & @offset.  If there is a
  * page cache page, it is returned with an increased refcount.
@@ -802,7 +802,7 @@ EXPORT_SYMBOL(page_cache_prev_hole);
  *
  * Otherwise, %NULL is returned.
  */
-struct page *__find_get_page(struct address_space *mapping, pgoff_t offset)
+struct page *find_get_entry(struct address_space *mapping, pgoff_t offset)
 {
 	void **pagep;
 	struct page *page;
@@ -843,7 +843,7 @@ out:
 
 	return page;
 }
-EXPORT_SYMBOL(__find_get_page);
+EXPORT_SYMBOL(find_get_entry);
 
 /**
  * find_get_page - find and get a page reference
@@ -857,7 +857,7 @@ EXPORT_SYMBOL(__find_get_page);
  */
 struct page *find_get_page(struct address_space *mapping, pgoff_t offset)
 {
-	struct page *page = __find_get_page(mapping, offset);
+	struct page *page = find_get_entry(mapping, offset);
 
 	if (radix_tree_exceptional_entry(page))
 		page = NULL;
@@ -866,9 +866,9 @@ struct page *find_get_page(struct addres
 EXPORT_SYMBOL(find_get_page);
 
 /**
- * __find_lock_page - locate, pin and lock a pagecache page
+ * find_lock_entry - locate, pin and lock a page cache entry
  * @mapping: the address_space to search
- * @offset: the page index
+ * @offset: the page cache index
  *
  * Looks up the page cache slot at @mapping & @offset.  If there is a
  * page cache page, it is returned locked and with an increased
@@ -879,13 +879,14 @@ EXPORT_SYMBOL(find_get_page);
  *
  * Otherwise, %NULL is returned.
  *
- * __find_lock_page() may sleep.
+ * find_lock_entry() may sleep.
  */
-struct page *__find_lock_page(struct address_space *mapping, pgoff_t offset)
+struct page *find_lock_entry(struct address_space *mapping, pgoff_t offset)
 {
 	struct page *page;
+
 repeat:
-	page = __find_get_page(mapping, offset);
+	page = find_get_entry(mapping, offset);
 	if (page && !radix_tree_exception(page)) {
 		lock_page(page);
 		/* Has the page been truncated? */
@@ -898,7 +899,7 @@ repeat:
 	}
 	return page;
 }
-EXPORT_SYMBOL(__find_lock_page);
+EXPORT_SYMBOL(find_lock_entry);
 
 /**
  * find_lock_page - locate, pin and lock a pagecache page
@@ -915,7 +916,7 @@ EXPORT_SYMBOL(__find_lock_page);
  */
 struct page *find_lock_page(struct address_space *mapping, pgoff_t offset)
 {
-	struct page *page = __find_lock_page(mapping, offset);
+	struct page *page = find_lock_entry(mapping, offset);
 
 	if (radix_tree_exceptional_entry(page))
 		page = NULL;
@@ -973,35 +974,37 @@ repeat:
 EXPORT_SYMBOL(find_or_create_page);
 
 /**
- * __find_get_pages - gang pagecache lookup
+ * find_get_entries - gang pagecache lookup
  * @mapping:	The address_space to search
- * @start:	The starting page index
- * @nr_pages:	The maximum number of pages
- * @pages:	Where the resulting entries are placed
- * @indices:	The cache indices corresponding to the entries in @pages
- *
- * __find_get_pages() will search for and return a group of up to
- * @nr_pages pages in the mapping.  The pages are placed at @pages.
- * __find_get_pages() takes a reference against the returned pages.
- *
- * The search returns a group of mapping-contiguous pages with ascending
- * indexes.  There may be holes in the indices due to not-present pages.
+ * @start:	The starting page cache index
+ * @nr_entries:	The maximum number of entries
+ * @entries:	Where the resulting entries are placed
+ * @indices:	The cache indices corresponding to the entries in @entries
+ *
+ * find_get_entries() will search for and return a group of up to
+ * @nr_entries entries in the mapping.  The entries are placed at
+ * @entries.  find_get_entries() takes a reference against any actual
+ * pages it returns.
+ *
+ * The search returns a group of mapping-contiguous page cache entries
+ * with ascending indexes.  There may be holes in the indices due to
+ * not-present pages.
  *
  * Any shadow entries of evicted pages are included in the returned
  * array.
  *
- * __find_get_pages() returns the number of pages and shadow entries
+ * find_get_entries() returns the number of pages and shadow entries
  * which were found.
  */
-unsigned __find_get_pages(struct address_space *mapping,
-			  pgoff_t start, unsigned int nr_pages,
-			  struct page **pages, pgoff_t *indices)
+unsigned find_get_entries(struct address_space *mapping,
+			  pgoff_t start, unsigned int nr_entries,
+			  struct page **entries, pgoff_t *indices)
 {
 	void **slot;
 	unsigned int ret = 0;
 	struct radix_tree_iter iter;
 
-	if (!nr_pages)
+	if (!nr_entries)
 		return 0;
 
 	rcu_read_lock();
@@ -1032,8 +1035,8 @@ repeat:
 		}
 export:
 		indices[ret] = iter.index;
-		pages[ret] = page;
-		if (++ret == nr_pages)
+		entries[ret] = page;
+		if (++ret == nr_entries)
 			break;
 	}
 	rcu_read_unlock();
diff -puN mm/mincore.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix-fix mm/mincore.c
--- a/mm/mincore.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix-fix
+++ a/mm/mincore.c
@@ -72,7 +72,7 @@ static unsigned char mincore_page(struct
 	 */
 #ifdef CONFIG_SWAP
 	if (shmem_mapping(mapping)) {
-		page = __find_get_page(mapping, pgoff);
+		page = find_get_entry(mapping, pgoff);
 		/*
 		 * shmem/tmpfs may return swap: account for swapcache
 		 * page too.
diff -puN mm/shmem.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix-fix mm/shmem.c
--- a/mm/shmem.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix-fix
+++ a/mm/shmem.c
@@ -363,8 +363,8 @@ void shmem_unlock_mapping(struct address
 		 * Avoid pagevec_lookup(): find_get_pages() returns 0 as if it
 		 * has finished, if it hits a row of PAGEVEC_SIZE swap entries.
 		 */
-		pvec.nr = __find_get_pages(mapping, index,
-					PAGEVEC_SIZE, pvec.pages, indices);
+		pvec.nr = find_get_entries(mapping, index,
+					   PAGEVEC_SIZE, pvec.pages, indices);
 		if (!pvec.nr)
 			break;
 		index = indices[pvec.nr - 1] + 1;
@@ -400,7 +400,7 @@ static void shmem_undo_range(struct inod
 	pagevec_init(&pvec, 0);
 	index = start;
 	while (index < end) {
-		pvec.nr = __find_get_pages(mapping, index,
+		pvec.nr = find_get_entries(mapping, index,
 			min(end - index, (pgoff_t)PAGEVEC_SIZE),
 			pvec.pages, indices);
 		if (!pvec.nr)
@@ -470,7 +470,7 @@ static void shmem_undo_range(struct inod
 	for ( ; ; ) {
 		cond_resched();
 
-		pvec.nr = __find_get_pages(mapping, index,
+		pvec.nr = find_get_entries(mapping, index,
 				min(end - index, (pgoff_t)PAGEVEC_SIZE),
 				pvec.pages, indices);
 		if (!pvec.nr) {
@@ -1015,7 +1015,7 @@ static int shmem_getpage_gfp(struct inod
 		return -EFBIG;
 repeat:
 	swap.val = 0;
-	page = __find_lock_page(mapping, index);
+	page = find_lock_entry(mapping, index);
 	if (radix_tree_exceptional_entry(page)) {
 		swap = radix_to_swp_entry(page);
 		page = NULL;
@@ -1669,7 +1669,7 @@ static pgoff_t shmem_seek_hole_data(stru
 	pagevec_init(&pvec, 0);
 	pvec.nr = 1;		/* start small: we may be there already */
 	while (!done) {
-		pvec.nr = __find_get_pages(mapping, index,
+		pvec.nr = find_get_entries(mapping, index,
 					pvec.nr, pvec.pages, indices);
 		if (!pvec.nr) {
 			if (whence == SEEK_DATA)
diff -puN mm/swap.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix-fix mm/swap.c
--- a/mm/swap.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix-fix
+++ a/mm/swap.c
@@ -948,28 +948,31 @@ void __pagevec_lru_add(struct pagevec *p
 EXPORT_SYMBOL(__pagevec_lru_add);
 
 /**
- * __pagevec_lookup - gang pagecache lookup
+ * pagevec_lookup_entries - gang pagecache lookup
  * @pvec:	Where the resulting entries are placed
  * @mapping:	The address_space to search
  * @start:	The starting entry index
- * @nr_pages:	The maximum number of entries
+ * @nr_entries:	The maximum number of entries
  * @indices:	The cache indices corresponding to the entries in @pvec
  *
- * __pagevec_lookup() will search for and return a group of up to
- * @nr_pages pages and shadow entries in the mapping.  All entries are
- * placed in @pvec.  __pagevec_lookup() takes a reference against
- * actual pages in @pvec.
+ * pagevec_lookup_entries() will search for and return a group of up
+ * to @nr_entries pages and shadow entries in the mapping.  All
+ * entries are placed in @pvec.  pagevec_lookup_entries() takes a
+ * reference against actual pages in @pvec.
  *
  * The search returns a group of mapping-contiguous entries with
  * ascending indexes.  There may be holes in the indices due to
  * not-present entries.
  *
- * __pagevec_lookup() returns the number of entries which were found.
+ * pagevec_lookup_entries() returns the number of entries which were
+ * found.
  */
-unsigned __pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
-			  pgoff_t start, unsigned nr_pages, pgoff_t *indices)
+unsigned pagevec_lookup_entries(struct pagevec *pvec,
+				struct address_space *mapping,
+				pgoff_t start, unsigned nr_pages,
+				pgoff_t *indices)
 {
-	pvec->nr = __find_get_pages(mapping, start, nr_pages,
+	pvec->nr = find_get_entries(mapping, start, nr_pages,
 				    pvec->pages, indices);
 	return pagevec_count(pvec);
 }
@@ -978,10 +981,10 @@ unsigned __pagevec_lookup(struct pagevec
  * pagevec_remove_exceptionals - pagevec exceptionals pruning
  * @pvec:	The pagevec to prune
  *
- * __pagevec_lookup() fills both pages and exceptional radix tree
- * entries into the pagevec.  This function prunes all exceptionals
- * from @pvec without leaving holes, so that it can be passed on to
- * page-only pagevec operations.
+ * pagevec_lookup_entries() fills both pages and exceptional radix
+ * tree entries into the pagevec.  This function prunes all
+ * exceptionals from @pvec without leaving holes, so that it can be
+ * passed on to page-only pagevec operations.
  */
 void pagevec_remove_exceptionals(struct pagevec *pvec)
 {
diff -puN mm/truncate.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix-fix mm/truncate.c
--- a/mm/truncate.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix-fix
+++ a/mm/truncate.c
@@ -255,7 +255,7 @@ void truncate_inode_pages_range(struct a
 
 	pagevec_init(&pvec, 0);
 	index = start;
-	while (index < end && __pagevec_lookup(&pvec, mapping, index,
+	while (index < end && pagevec_lookup_entries(&pvec, mapping, index,
 			min(end - index, (pgoff_t)PAGEVEC_SIZE),
 			indices)) {
 		mem_cgroup_uncharge_start();
@@ -331,7 +331,7 @@ void truncate_inode_pages_range(struct a
 	index = start;
 	for ( ; ; ) {
 		cond_resched();
-		if (!__pagevec_lookup(&pvec, mapping, index,
+		if (!pagevec_lookup_entries(&pvec, mapping, index,
 			min(end - index, (pgoff_t)PAGEVEC_SIZE),
 			indices)) {
 			if (index == start)
@@ -423,7 +423,7 @@ unsigned long invalidate_mapping_pages(s
 	 */
 
 	pagevec_init(&pvec, 0);
-	while (index <= end && __pagevec_lookup(&pvec, mapping, index,
+	while (index <= end && pagevec_lookup_entries(&pvec, mapping, index,
 			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1,
 			indices)) {
 		mem_cgroup_uncharge_start();
@@ -532,7 +532,7 @@ int invalidate_inode_pages2_range(struct
 	cleancache_invalidate_inode(mapping);
 	pagevec_init(&pvec, 0);
 	index = start;
-	while (index <= end && __pagevec_lookup(&pvec, mapping, index,
+	while (index <= end && pagevec_lookup_entries(&pvec, mapping, index,
 			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1,
 			indices)) {
 		mem_cgroup_uncharge_start();
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-vmstat-fix-up-zone-state-accounting.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix-fix.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
lib-radix_tree-tree-node-interface-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
drop_caches-add-some-documentation-and-info-message.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
fork-collapse-copy_flags-into-copy_process.patch
mm-mempolicy-rename-slab_node-for-clarity.patch
mm-mempolicy-remove-per-process-flag.patch
res_counter-remove-interface-for-locked-charging-and-uncharging.patch
mm-vmallocc-enhance-vm_map_ram-comment.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
linux-next.patch
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch
debugging-keep-track-of-page-owners.patch

