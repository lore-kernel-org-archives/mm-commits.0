From: akpm@linux-foundation.org
Subject: [merged]
 mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch removed
 from -mm tree
Date: Fri, 04 Apr 2014 12:31:25 -0700
Message-ID: <533f088d.U1Gt3GrDNqj6x6XC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494AbaDDTb1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:31:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, vbabka@suse.cz, tj@kernel.org, semenzato@google.com, rmallon@gmail.com, riel@redhat.com, peterz@infradead.org, ozgun@citusdata.com, minchan@kernel.org, mgorman@suse.de, metin@citusdata.com, kosaki.motohiro@jp.fujitsu.com, klamm@yandex-team.ru, jack@suse.cz, hughd@google.com, hch@infradead.org, gthelen@google.com, david@fromorbit.com, bob.liu@oracle.com, aarcange@redhat.com, hannes@cmpxchg.org

Subject: [merged] mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch removed from -mm tree
To: hannes@cmpxchg.org,aarcange@redhat.com,bob.liu@oracle.com,david@fromorbit.com,gthelen@google.com,hch@infradead.org,hughd@google.com,jack@suse.cz,klamm@yandex-team.ru,kosaki.motohiro@jp.fujitsu.com,metin@citusdata.com,mgorman@suse.de,minchan@kernel.org,ozgun@citusdata.com,peterz@infradead.org,riel@redhat.com,rmallon@gmail.com,semenzato@google.com,tj@kernel.org,vbabka@suse.cz,walken@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:31:25 -0700


The patch titled
     Subject: mm + fs: prepare for non-page entries in page cache radix trees
has been removed from the -mm tree.  Its filename was
     mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm + fs: prepare for non-page entries in page cache radix trees

shmem mappings already contain exceptional entries where swap slot
information is remembered.

To be able to store eviction information for regular page cache, prepare
every site dealing with the radix trees directly to handle entries other
than pages.

The common lookup functions will filter out non-page entries and return
NULL for page cache holes, just as before.  But provide a raw version of
the API which returns non-page entries as well, and switch shmem over to
use it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Luigi Semenzato <semenzato@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Metin Doslu <metin@citusdata.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ozgun Erdogan <ozgun@citusdata.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <klamm@yandex-team.ru>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/compression.c   |    2 
 include/linux/mm.h       |    8 +
 include/linux/pagemap.h  |   15 +-
 include/linux/pagevec.h  |    5 
 include/linux/shmem_fs.h |    1 
 mm/filemap.c             |  202 ++++++++++++++++++++++++++++++++-----
 mm/mincore.c             |   20 ++-
 mm/readahead.c           |    2 
 mm/shmem.c               |   99 +++---------------
 mm/swap.c                |   51 +++++++++
 mm/truncate.c            |   74 +++++++++++--
 11 files changed, 349 insertions(+), 130 deletions(-)

diff -puN fs/btrfs/compression.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees fs/btrfs/compression.c
--- a/fs/btrfs/compression.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees
+++ a/fs/btrfs/compression.c
@@ -472,7 +472,7 @@ static noinline int add_ra_bio_pages(str
 		rcu_read_lock();
 		page = radix_tree_lookup(&mapping->page_tree, pg_index);
 		rcu_read_unlock();
-		if (page) {
+		if (page && !radix_tree_exceptional_entry(page)) {
 			misses++;
 			if (misses > 4)
 				break;
diff -puN include/linux/mm.h~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees include/linux/mm.h
--- a/include/linux/mm.h~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees
+++ a/include/linux/mm.h
@@ -1041,6 +1041,14 @@ extern void show_free_areas(unsigned int
 extern bool skip_free_areas_node(unsigned int flags, int nid);
 
 int shmem_zero_setup(struct vm_area_struct *);
+#ifdef CONFIG_SHMEM
+bool shmem_mapping(struct address_space *mapping);
+#else
+static inline bool shmem_mapping(struct address_space *mapping)
+{
+	return false;
+}
+#endif
 
 extern int can_do_mlock(void);
 extern int user_shm_lock(size_t, struct user_struct *);
diff -puN include/linux/pagemap.h~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees
+++ a/include/linux/pagemap.h
@@ -248,12 +248,15 @@ pgoff_t page_cache_next_hole(struct addr
 pgoff_t page_cache_prev_hole(struct address_space *mapping,
 			     pgoff_t index, unsigned long max_scan);
 
-extern struct page * find_get_page(struct address_space *mapping,
-				pgoff_t index);
-extern struct page * find_lock_page(struct address_space *mapping,
-				pgoff_t index);
-extern struct page * find_or_create_page(struct address_space *mapping,
-				pgoff_t index, gfp_t gfp_mask);
+struct page *find_get_entry(struct address_space *mapping, pgoff_t offset);
+struct page *find_get_page(struct address_space *mapping, pgoff_t offset);
+struct page *find_lock_entry(struct address_space *mapping, pgoff_t offset);
+struct page *find_lock_page(struct address_space *mapping, pgoff_t offset);
+struct page *find_or_create_page(struct address_space *mapping, pgoff_t index,
+				 gfp_t gfp_mask);
+unsigned find_get_entries(struct address_space *mapping, pgoff_t start,
+			  unsigned int nr_entries, struct page **entries,
+			  pgoff_t *indices);
 unsigned find_get_pages(struct address_space *mapping, pgoff_t start,
 			unsigned int nr_pages, struct page **pages);
 unsigned find_get_pages_contig(struct address_space *mapping, pgoff_t start,
diff -puN include/linux/pagevec.h~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees include/linux/pagevec.h
--- a/include/linux/pagevec.h~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees
+++ a/include/linux/pagevec.h
@@ -22,6 +22,11 @@ struct pagevec {
 
 void __pagevec_release(struct pagevec *pvec);
 void __pagevec_lru_add(struct pagevec *pvec);
+unsigned pagevec_lookup_entries(struct pagevec *pvec,
+				struct address_space *mapping,
+				pgoff_t start, unsigned nr_entries,
+				pgoff_t *indices);
+void pagevec_remove_exceptionals(struct pagevec *pvec);
 unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
 		pgoff_t start, unsigned nr_pages);
 unsigned pagevec_lookup_tag(struct pagevec *pvec,
diff -puN include/linux/shmem_fs.h~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees
+++ a/include/linux/shmem_fs.h
@@ -51,6 +51,7 @@ extern struct file *shmem_kernel_file_se
 					    unsigned long flags);
 extern int shmem_zero_setup(struct vm_area_struct *);
 extern int shmem_lock(struct file *file, int lock, struct user_struct *user);
+extern bool shmem_mapping(struct address_space *mapping);
 extern void shmem_unlock_mapping(struct address_space *mapping);
 extern struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
 					pgoff_t index, gfp_t gfp_mask);
diff -puN mm/filemap.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees mm/filemap.c
--- a/mm/filemap.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees
+++ a/mm/filemap.c
@@ -446,6 +446,29 @@ int replace_page_cache_page(struct page
 }
 EXPORT_SYMBOL_GPL(replace_page_cache_page);
 
+static int page_cache_tree_insert(struct address_space *mapping,
+				  struct page *page)
+{
+	void **slot;
+	int error;
+
+	slot = radix_tree_lookup_slot(&mapping->page_tree, page->index);
+	if (slot) {
+		void *p;
+
+		p = radix_tree_deref_slot_protected(slot, &mapping->tree_lock);
+		if (!radix_tree_exceptional_entry(p))
+			return -EEXIST;
+		radix_tree_replace_slot(slot, page);
+		mapping->nrpages++;
+		return 0;
+	}
+	error = radix_tree_insert(&mapping->page_tree, page->index, page);
+	if (!error)
+		mapping->nrpages++;
+	return error;
+}
+
 /**
  * add_to_page_cache_locked - add a locked page to the pagecache
  * @page:	page to add
@@ -480,11 +503,10 @@ int add_to_page_cache_locked(struct page
 	page->index = offset;
 
 	spin_lock_irq(&mapping->tree_lock);
-	error = radix_tree_insert(&mapping->page_tree, offset, page);
+	error = page_cache_tree_insert(mapping, page);
 	radix_tree_preload_end();
 	if (unlikely(error))
 		goto err_insert;
-	mapping->nrpages++;
 	__inc_zone_page_state(page, NR_FILE_PAGES);
 	spin_unlock_irq(&mapping->tree_lock);
 	trace_mm_filemap_add_to_page_cache(page);
@@ -712,7 +734,10 @@ pgoff_t page_cache_next_hole(struct addr
 	unsigned long i;
 
 	for (i = 0; i < max_scan; i++) {
-		if (!radix_tree_lookup(&mapping->page_tree, index))
+		struct page *page;
+
+		page = radix_tree_lookup(&mapping->page_tree, index);
+		if (!page || radix_tree_exceptional_entry(page))
 			break;
 		index++;
 		if (index == 0)
@@ -750,7 +775,10 @@ pgoff_t page_cache_prev_hole(struct addr
 	unsigned long i;
 
 	for (i = 0; i < max_scan; i++) {
-		if (!radix_tree_lookup(&mapping->page_tree, index))
+		struct page *page;
+
+		page = radix_tree_lookup(&mapping->page_tree, index);
+		if (!page || radix_tree_exceptional_entry(page))
 			break;
 		index--;
 		if (index == ULONG_MAX)
@@ -762,14 +790,19 @@ pgoff_t page_cache_prev_hole(struct addr
 EXPORT_SYMBOL(page_cache_prev_hole);
 
 /**
- * find_get_page - find and get a page reference
+ * find_get_entry - find and get a page cache entry
  * @mapping: the address_space to search
- * @offset: the page index
+ * @offset: the page cache index
+ *
+ * Looks up the page cache slot at @mapping & @offset.  If there is a
+ * page cache page, it is returned with an increased refcount.
+ *
+ * If the slot holds a shadow entry of a previously evicted page, it
+ * is returned.
  *
- * Is there a pagecache struct page at the given (mapping, offset) tuple?
- * If yes, increment its refcount and return it; if no, return NULL.
+ * Otherwise, %NULL is returned.
  */
-struct page *find_get_page(struct address_space *mapping, pgoff_t offset)
+struct page *find_get_entry(struct address_space *mapping, pgoff_t offset)
 {
 	void **pagep;
 	struct page *page;
@@ -810,24 +843,50 @@ out:
 
 	return page;
 }
-EXPORT_SYMBOL(find_get_page);
+EXPORT_SYMBOL(find_get_entry);
 
 /**
- * find_lock_page - locate, pin and lock a pagecache page
+ * find_get_page - find and get a page reference
  * @mapping: the address_space to search
  * @offset: the page index
  *
- * Locates the desired pagecache page, locks it, increments its reference
- * count and returns its address.
+ * Looks up the page cache slot at @mapping & @offset.  If there is a
+ * page cache page, it is returned with an increased refcount.
  *
- * Returns zero if the page was not present. find_lock_page() may sleep.
+ * Otherwise, %NULL is returned.
  */
-struct page *find_lock_page(struct address_space *mapping, pgoff_t offset)
+struct page *find_get_page(struct address_space *mapping, pgoff_t offset)
+{
+	struct page *page = find_get_entry(mapping, offset);
+
+	if (radix_tree_exceptional_entry(page))
+		page = NULL;
+	return page;
+}
+EXPORT_SYMBOL(find_get_page);
+
+/**
+ * find_lock_entry - locate, pin and lock a page cache entry
+ * @mapping: the address_space to search
+ * @offset: the page cache index
+ *
+ * Looks up the page cache slot at @mapping & @offset.  If there is a
+ * page cache page, it is returned locked and with an increased
+ * refcount.
+ *
+ * If the slot holds a shadow entry of a previously evicted page, it
+ * is returned.
+ *
+ * Otherwise, %NULL is returned.
+ *
+ * find_lock_entry() may sleep.
+ */
+struct page *find_lock_entry(struct address_space *mapping, pgoff_t offset)
 {
 	struct page *page;
 
 repeat:
-	page = find_get_page(mapping, offset);
+	page = find_get_entry(mapping, offset);
 	if (page && !radix_tree_exception(page)) {
 		lock_page(page);
 		/* Has the page been truncated? */
@@ -840,6 +899,29 @@ repeat:
 	}
 	return page;
 }
+EXPORT_SYMBOL(find_lock_entry);
+
+/**
+ * find_lock_page - locate, pin and lock a pagecache page
+ * @mapping: the address_space to search
+ * @offset: the page index
+ *
+ * Looks up the page cache slot at @mapping & @offset.  If there is a
+ * page cache page, it is returned locked and with an increased
+ * refcount.
+ *
+ * Otherwise, %NULL is returned.
+ *
+ * find_lock_page() may sleep.
+ */
+struct page *find_lock_page(struct address_space *mapping, pgoff_t offset)
+{
+	struct page *page = find_lock_entry(mapping, offset);
+
+	if (radix_tree_exceptional_entry(page))
+		page = NULL;
+	return page;
+}
 EXPORT_SYMBOL(find_lock_page);
 
 /**
@@ -848,16 +930,18 @@ EXPORT_SYMBOL(find_lock_page);
  * @index: the page's index into the mapping
  * @gfp_mask: page allocation mode
  *
- * Locates a page in the pagecache.  If the page is not present, a new page
- * is allocated using @gfp_mask and is added to the pagecache and to the VM's
- * LRU list.  The returned page is locked and has its reference count
- * incremented.
+ * Looks up the page cache slot at @mapping & @offset.  If there is a
+ * page cache page, it is returned locked and with an increased
+ * refcount.
+ *
+ * If the page is not present, a new page is allocated using @gfp_mask
+ * and added to the page cache and the VM's LRU list.  The page is
+ * returned locked and with an increased refcount.
  *
- * find_or_create_page() may sleep, even if @gfp_flags specifies an atomic
- * allocation!
+ * On memory exhaustion, %NULL is returned.
  *
- * find_or_create_page() returns the desired page's address, or zero on
- * memory exhaustion.
+ * find_or_create_page() may sleep, even if @gfp_flags specifies an
+ * atomic allocation!
  */
 struct page *find_or_create_page(struct address_space *mapping,
 		pgoff_t index, gfp_t gfp_mask)
@@ -890,6 +974,76 @@ repeat:
 EXPORT_SYMBOL(find_or_create_page);
 
 /**
+ * find_get_entries - gang pagecache lookup
+ * @mapping:	The address_space to search
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
+ *
+ * Any shadow entries of evicted pages are included in the returned
+ * array.
+ *
+ * find_get_entries() returns the number of pages and shadow entries
+ * which were found.
+ */
+unsigned find_get_entries(struct address_space *mapping,
+			  pgoff_t start, unsigned int nr_entries,
+			  struct page **entries, pgoff_t *indices)
+{
+	void **slot;
+	unsigned int ret = 0;
+	struct radix_tree_iter iter;
+
+	if (!nr_entries)
+		return 0;
+
+	rcu_read_lock();
+restart:
+	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
+		struct page *page;
+repeat:
+		page = radix_tree_deref_slot(slot);
+		if (unlikely(!page))
+			continue;
+		if (radix_tree_exception(page)) {
+			if (radix_tree_deref_retry(page))
+				goto restart;
+			/*
+			 * Otherwise, we must be storing a swap entry
+			 * here as an exceptional entry: so return it
+			 * without attempting to raise page count.
+			 */
+			goto export;
+		}
+		if (!page_cache_get_speculative(page))
+			goto repeat;
+
+		/* Has the page moved? */
+		if (unlikely(page != *slot)) {
+			page_cache_release(page);
+			goto repeat;
+		}
+export:
+		indices[ret] = iter.index;
+		entries[ret] = page;
+		if (++ret == nr_entries)
+			break;
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+/**
  * find_get_pages - gang pagecache lookup
  * @mapping:	The address_space to search
  * @start:	The starting page index
diff -puN mm/mincore.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees mm/mincore.c
--- a/mm/mincore.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees
+++ a/mm/mincore.c
@@ -70,13 +70,21 @@ static unsigned char mincore_page(struct
 	 * any other file mapping (ie. marked !present and faulted in with
 	 * tmpfs's .fault). So swapped out tmpfs mappings are tested here.
 	 */
-	page = find_get_page(mapping, pgoff);
 #ifdef CONFIG_SWAP
-	/* shmem/tmpfs may return swap: account for swapcache page too. */
-	if (radix_tree_exceptional_entry(page)) {
-		swp_entry_t swap = radix_to_swp_entry(page);
-		page = find_get_page(swap_address_space(swap), swap.val);
-	}
+	if (shmem_mapping(mapping)) {
+		page = find_get_entry(mapping, pgoff);
+		/*
+		 * shmem/tmpfs may return swap: account for swapcache
+		 * page too.
+		 */
+		if (radix_tree_exceptional_entry(page)) {
+			swp_entry_t swp = radix_to_swp_entry(page);
+			page = find_get_page(swap_address_space(swp), swp.val);
+		}
+	} else
+		page = find_get_page(mapping, pgoff);
+#else
+	page = find_get_page(mapping, pgoff);
 #endif
 	if (page) {
 		present = PageUptodate(page);
diff -puN mm/readahead.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees mm/readahead.c
--- a/mm/readahead.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees
+++ a/mm/readahead.c
@@ -179,7 +179,7 @@ __do_page_cache_readahead(struct address
 		rcu_read_lock();
 		page = radix_tree_lookup(&mapping->page_tree, page_offset);
 		rcu_read_unlock();
-		if (page)
+		if (page && !radix_tree_exceptional_entry(page))
 			continue;
 
 		page = page_cache_alloc_readahead(mapping);
diff -puN mm/shmem.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees mm/shmem.c
--- a/mm/shmem.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees
+++ a/mm/shmem.c
@@ -329,56 +329,6 @@ static void shmem_delete_from_page_cache
 }
 
 /*
- * Like find_get_pages, but collecting swap entries as well as pages.
- */
-static unsigned shmem_find_get_pages_and_swap(struct address_space *mapping,
-					pgoff_t start, unsigned int nr_pages,
-					struct page **pages, pgoff_t *indices)
-{
-	void **slot;
-	unsigned int ret = 0;
-	struct radix_tree_iter iter;
-
-	if (!nr_pages)
-		return 0;
-
-	rcu_read_lock();
-restart:
-	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
-		struct page *page;
-repeat:
-		page = radix_tree_deref_slot(slot);
-		if (unlikely(!page))
-			continue;
-		if (radix_tree_exception(page)) {
-			if (radix_tree_deref_retry(page))
-				goto restart;
-			/*
-			 * Otherwise, we must be storing a swap entry
-			 * here as an exceptional entry: so return it
-			 * without attempting to raise page count.
-			 */
-			goto export;
-		}
-		if (!page_cache_get_speculative(page))
-			goto repeat;
-
-		/* Has the page moved? */
-		if (unlikely(page != *slot)) {
-			page_cache_release(page);
-			goto repeat;
-		}
-export:
-		indices[ret] = iter.index;
-		pages[ret] = page;
-		if (++ret == nr_pages)
-			break;
-	}
-	rcu_read_unlock();
-	return ret;
-}
-
-/*
  * Remove swap entry from radix tree, free the swap and its page cache.
  */
 static int shmem_free_swap(struct address_space *mapping,
@@ -396,21 +346,6 @@ static int shmem_free_swap(struct addres
 }
 
 /*
- * Pagevec may contain swap entries, so shuffle up pages before releasing.
- */
-static void shmem_deswap_pagevec(struct pagevec *pvec)
-{
-	int i, j;
-
-	for (i = 0, j = 0; i < pagevec_count(pvec); i++) {
-		struct page *page = pvec->pages[i];
-		if (!radix_tree_exceptional_entry(page))
-			pvec->pages[j++] = page;
-	}
-	pvec->nr = j;
-}
-
-/*
  * SysV IPC SHM_UNLOCK restore Unevictable pages to their evictable lists.
  */
 void shmem_unlock_mapping(struct address_space *mapping)
@@ -428,12 +363,12 @@ void shmem_unlock_mapping(struct address
 		 * Avoid pagevec_lookup(): find_get_pages() returns 0 as if it
 		 * has finished, if it hits a row of PAGEVEC_SIZE swap entries.
 		 */
-		pvec.nr = shmem_find_get_pages_and_swap(mapping, index,
-					PAGEVEC_SIZE, pvec.pages, indices);
+		pvec.nr = find_get_entries(mapping, index,
+					   PAGEVEC_SIZE, pvec.pages, indices);
 		if (!pvec.nr)
 			break;
 		index = indices[pvec.nr - 1] + 1;
-		shmem_deswap_pagevec(&pvec);
+		pagevec_remove_exceptionals(&pvec);
 		check_move_unevictable_pages(pvec.pages, pvec.nr);
 		pagevec_release(&pvec);
 		cond_resched();
@@ -465,9 +400,9 @@ static void shmem_undo_range(struct inod
 	pagevec_init(&pvec, 0);
 	index = start;
 	while (index < end) {
-		pvec.nr = shmem_find_get_pages_and_swap(mapping, index,
-				min(end - index, (pgoff_t)PAGEVEC_SIZE),
-							pvec.pages, indices);
+		pvec.nr = find_get_entries(mapping, index,
+			min(end - index, (pgoff_t)PAGEVEC_SIZE),
+			pvec.pages, indices);
 		if (!pvec.nr)
 			break;
 		mem_cgroup_uncharge_start();
@@ -496,7 +431,7 @@ static void shmem_undo_range(struct inod
 			}
 			unlock_page(page);
 		}
-		shmem_deswap_pagevec(&pvec);
+		pagevec_remove_exceptionals(&pvec);
 		pagevec_release(&pvec);
 		mem_cgroup_uncharge_end();
 		cond_resched();
@@ -534,9 +469,10 @@ static void shmem_undo_range(struct inod
 	index = start;
 	for ( ; ; ) {
 		cond_resched();
-		pvec.nr = shmem_find_get_pages_and_swap(mapping, index,
+
+		pvec.nr = find_get_entries(mapping, index,
 				min(end - index, (pgoff_t)PAGEVEC_SIZE),
-							pvec.pages, indices);
+				pvec.pages, indices);
 		if (!pvec.nr) {
 			if (index == start || unfalloc)
 				break;
@@ -544,7 +480,7 @@ static void shmem_undo_range(struct inod
 			continue;
 		}
 		if ((index == start || unfalloc) && indices[0] >= end) {
-			shmem_deswap_pagevec(&pvec);
+			pagevec_remove_exceptionals(&pvec);
 			pagevec_release(&pvec);
 			break;
 		}
@@ -573,7 +509,7 @@ static void shmem_undo_range(struct inod
 			}
 			unlock_page(page);
 		}
-		shmem_deswap_pagevec(&pvec);
+		pagevec_remove_exceptionals(&pvec);
 		pagevec_release(&pvec);
 		mem_cgroup_uncharge_end();
 		index++;
@@ -1079,7 +1015,7 @@ static int shmem_getpage_gfp(struct inod
 		return -EFBIG;
 repeat:
 	swap.val = 0;
-	page = find_lock_page(mapping, index);
+	page = find_lock_entry(mapping, index);
 	if (radix_tree_exceptional_entry(page)) {
 		swap = radix_to_swp_entry(page);
 		page = NULL;
@@ -1416,6 +1352,11 @@ static struct inode *shmem_get_inode(str
 	return inode;
 }
 
+bool shmem_mapping(struct address_space *mapping)
+{
+	return mapping->backing_dev_info == &shmem_backing_dev_info;
+}
+
 #ifdef CONFIG_TMPFS
 static const struct inode_operations shmem_symlink_inode_operations;
 static const struct inode_operations shmem_short_symlink_operations;
@@ -1728,7 +1669,7 @@ static pgoff_t shmem_seek_hole_data(stru
 	pagevec_init(&pvec, 0);
 	pvec.nr = 1;		/* start small: we may be there already */
 	while (!done) {
-		pvec.nr = shmem_find_get_pages_and_swap(mapping, index,
+		pvec.nr = find_get_entries(mapping, index,
 					pvec.nr, pvec.pages, indices);
 		if (!pvec.nr) {
 			if (whence == SEEK_DATA)
@@ -1755,7 +1696,7 @@ static pgoff_t shmem_seek_hole_data(stru
 				break;
 			}
 		}
-		shmem_deswap_pagevec(&pvec);
+		pagevec_remove_exceptionals(&pvec);
 		pagevec_release(&pvec);
 		pvec.nr = PAGEVEC_SIZE;
 		cond_resched();
diff -puN mm/swap.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees mm/swap.c
--- a/mm/swap.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees
+++ a/mm/swap.c
@@ -948,6 +948,57 @@ void __pagevec_lru_add(struct pagevec *p
 EXPORT_SYMBOL(__pagevec_lru_add);
 
 /**
+ * pagevec_lookup_entries - gang pagecache lookup
+ * @pvec:	Where the resulting entries are placed
+ * @mapping:	The address_space to search
+ * @start:	The starting entry index
+ * @nr_entries:	The maximum number of entries
+ * @indices:	The cache indices corresponding to the entries in @pvec
+ *
+ * pagevec_lookup_entries() will search for and return a group of up
+ * to @nr_entries pages and shadow entries in the mapping.  All
+ * entries are placed in @pvec.  pagevec_lookup_entries() takes a
+ * reference against actual pages in @pvec.
+ *
+ * The search returns a group of mapping-contiguous entries with
+ * ascending indexes.  There may be holes in the indices due to
+ * not-present entries.
+ *
+ * pagevec_lookup_entries() returns the number of entries which were
+ * found.
+ */
+unsigned pagevec_lookup_entries(struct pagevec *pvec,
+				struct address_space *mapping,
+				pgoff_t start, unsigned nr_pages,
+				pgoff_t *indices)
+{
+	pvec->nr = find_get_entries(mapping, start, nr_pages,
+				    pvec->pages, indices);
+	return pagevec_count(pvec);
+}
+
+/**
+ * pagevec_remove_exceptionals - pagevec exceptionals pruning
+ * @pvec:	The pagevec to prune
+ *
+ * pagevec_lookup_entries() fills both pages and exceptional radix
+ * tree entries into the pagevec.  This function prunes all
+ * exceptionals from @pvec without leaving holes, so that it can be
+ * passed on to page-only pagevec operations.
+ */
+void pagevec_remove_exceptionals(struct pagevec *pvec)
+{
+	int i, j;
+
+	for (i = 0, j = 0; i < pagevec_count(pvec); i++) {
+		struct page *page = pvec->pages[i];
+		if (!radix_tree_exceptional_entry(page))
+			pvec->pages[j++] = page;
+	}
+	pvec->nr = j;
+}
+
+/**
  * pagevec_lookup - gang pagecache lookup
  * @pvec:	Where the resulting pages are placed
  * @mapping:	The address_space to search
diff -puN mm/truncate.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees mm/truncate.c
--- a/mm/truncate.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees
+++ a/mm/truncate.c
@@ -22,6 +22,22 @@
 #include <linux/cleancache.h>
 #include "internal.h"
 
+static void clear_exceptional_entry(struct address_space *mapping,
+				    pgoff_t index, void *entry)
+{
+	/* Handled by shmem itself */
+	if (shmem_mapping(mapping))
+		return;
+
+	spin_lock_irq(&mapping->tree_lock);
+	/*
+	 * Regular page slots are stabilized by the page lock even
+	 * without the tree itself locked.  These unlocked entries
+	 * need verification under the tree lock.
+	 */
+	radix_tree_delete_item(&mapping->page_tree, index, entry);
+	spin_unlock_irq(&mapping->tree_lock);
+}
 
 /**
  * do_invalidatepage - invalidate part or all of a page
@@ -208,6 +224,7 @@ void truncate_inode_pages_range(struct a
 	unsigned int	partial_start;	/* inclusive */
 	unsigned int	partial_end;	/* exclusive */
 	struct pagevec	pvec;
+	pgoff_t		indices[PAGEVEC_SIZE];
 	pgoff_t		index;
 	int		i;
 
@@ -238,17 +255,23 @@ void truncate_inode_pages_range(struct a
 
 	pagevec_init(&pvec, 0);
 	index = start;
-	while (index < end && pagevec_lookup(&pvec, mapping, index,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE))) {
+	while (index < end && pagevec_lookup_entries(&pvec, mapping, index,
+			min(end - index, (pgoff_t)PAGEVEC_SIZE),
+			indices)) {
 		mem_cgroup_uncharge_start();
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 
 			/* We rely upon deletion not changing page->index */
-			index = page->index;
+			index = indices[i];
 			if (index >= end)
 				break;
 
+			if (radix_tree_exceptional_entry(page)) {
+				clear_exceptional_entry(mapping, index, page);
+				continue;
+			}
+
 			if (!trylock_page(page))
 				continue;
 			WARN_ON(page->index != index);
@@ -259,6 +282,7 @@ void truncate_inode_pages_range(struct a
 			truncate_inode_page(mapping, page);
 			unlock_page(page);
 		}
+		pagevec_remove_exceptionals(&pvec);
 		pagevec_release(&pvec);
 		mem_cgroup_uncharge_end();
 		cond_resched();
@@ -307,14 +331,16 @@ void truncate_inode_pages_range(struct a
 	index = start;
 	for ( ; ; ) {
 		cond_resched();
-		if (!pagevec_lookup(&pvec, mapping, index,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE))) {
+		if (!pagevec_lookup_entries(&pvec, mapping, index,
+			min(end - index, (pgoff_t)PAGEVEC_SIZE),
+			indices)) {
 			if (index == start)
 				break;
 			index = start;
 			continue;
 		}
-		if (index == start && pvec.pages[0]->index >= end) {
+		if (index == start && indices[0] >= end) {
+			pagevec_remove_exceptionals(&pvec);
 			pagevec_release(&pvec);
 			break;
 		}
@@ -323,16 +349,22 @@ void truncate_inode_pages_range(struct a
 			struct page *page = pvec.pages[i];
 
 			/* We rely upon deletion not changing page->index */
-			index = page->index;
+			index = indices[i];
 			if (index >= end)
 				break;
 
+			if (radix_tree_exceptional_entry(page)) {
+				clear_exceptional_entry(mapping, index, page);
+				continue;
+			}
+
 			lock_page(page);
 			WARN_ON(page->index != index);
 			wait_on_page_writeback(page);
 			truncate_inode_page(mapping, page);
 			unlock_page(page);
 		}
+		pagevec_remove_exceptionals(&pvec);
 		pagevec_release(&pvec);
 		mem_cgroup_uncharge_end();
 		index++;
@@ -375,6 +407,7 @@ EXPORT_SYMBOL(truncate_inode_pages);
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
 		pgoff_t start, pgoff_t end)
 {
+	pgoff_t indices[PAGEVEC_SIZE];
 	struct pagevec pvec;
 	pgoff_t index = start;
 	unsigned long ret;
@@ -390,17 +423,23 @@ unsigned long invalidate_mapping_pages(s
 	 */
 
 	pagevec_init(&pvec, 0);
-	while (index <= end && pagevec_lookup(&pvec, mapping, index,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
+	while (index <= end && pagevec_lookup_entries(&pvec, mapping, index,
+			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1,
+			indices)) {
 		mem_cgroup_uncharge_start();
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 
 			/* We rely upon deletion not changing page->index */
-			index = page->index;
+			index = indices[i];
 			if (index > end)
 				break;
 
+			if (radix_tree_exceptional_entry(page)) {
+				clear_exceptional_entry(mapping, index, page);
+				continue;
+			}
+
 			if (!trylock_page(page))
 				continue;
 			WARN_ON(page->index != index);
@@ -414,6 +453,7 @@ unsigned long invalidate_mapping_pages(s
 				deactivate_page(page);
 			count += ret;
 		}
+		pagevec_remove_exceptionals(&pvec);
 		pagevec_release(&pvec);
 		mem_cgroup_uncharge_end();
 		cond_resched();
@@ -481,6 +521,7 @@ static int do_launder_page(struct addres
 int invalidate_inode_pages2_range(struct address_space *mapping,
 				  pgoff_t start, pgoff_t end)
 {
+	pgoff_t indices[PAGEVEC_SIZE];
 	struct pagevec pvec;
 	pgoff_t index;
 	int i;
@@ -491,17 +532,23 @@ int invalidate_inode_pages2_range(struct
 	cleancache_invalidate_inode(mapping);
 	pagevec_init(&pvec, 0);
 	index = start;
-	while (index <= end && pagevec_lookup(&pvec, mapping, index,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
+	while (index <= end && pagevec_lookup_entries(&pvec, mapping, index,
+			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1,
+			indices)) {
 		mem_cgroup_uncharge_start();
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 
 			/* We rely upon deletion not changing page->index */
-			index = page->index;
+			index = indices[i];
 			if (index > end)
 				break;
 
+			if (radix_tree_exceptional_entry(page)) {
+				clear_exceptional_entry(mapping, index, page);
+				continue;
+			}
+
 			lock_page(page);
 			WARN_ON(page->index != index);
 			if (page->mapping != mapping) {
@@ -539,6 +586,7 @@ int invalidate_inode_pages2_range(struct
 				ret = ret2;
 			unlock_page(page);
 		}
+		pagevec_remove_exceptionals(&pvec);
 		pagevec_release(&pvec);
 		mem_cgroup_uncharge_end();
 		cond_resched();
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
fork-collapse-copy_flags-into-copy_process.patch
mm-mempolicy-rename-slab_node-for-clarity.patch
mm-mempolicy-remove-per-process-flag.patch
res_counter-remove-interface-for-locked-charging-and-uncharging.patch
mm-vmallocc-enhance-vm_map_ram-comment.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
mm-memcg-remove-unnecessary-preemption-disabling.patch
mm-memcg-remove-mem_cgroup_move_account_page_stat.patch
mm-memcg-inline-mem_cgroup_charge_common.patch
mm-memcg-push-mm-handling-out-to-page-cache-charge-function.patch
memcg-remove-unnecessary-mm-check-from-try_get_mem_cgroup_from_mm.patch
memcg-get_mem_cgroup_from_mm.patch
memcg-get_mem_cgroup_from_mm-fix.patch
memcg-do-not-replicate-get_mem_cgroup_from_mm-in-__mem_cgroup_try_charge.patch
memcg-sanitize-__mem_cgroup_try_charge-call-protocol.patch
memcg-sanitize-__mem_cgroup_try_charge-call-protocol-fix.patch
memcg-rename-high-level-charging-functions.patch
mm-page_alloc-spill-to-remote-nodes-before-waking-kswapd.patch
linux-next.patch
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch
debugging-keep-track-of-page-owners.patch

