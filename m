From: akpm@linux-foundation.org
Subject: - mm-speculative-page-references.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:16:01 -0700
Message-ID: <200807262116.m6QLG1WX019797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757755AbYGZVRN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:17:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, hugh@veritas.com, jeff@garzik.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, nishimura@mxp.nes.


The patch titled
     mm: speculative page references
has been removed from the -mm tree.  Its filename was
     mm-speculative-page-references.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: speculative page references
From: Nick Piggin <npiggin@suse.de>

If we can be sure that elevating the page_count on a pagecache page will
pin it, we can speculatively run this operation, and subsequently check to
see if we hit the right page rather than relying on holding a lock or
otherwise pinning a reference to the page.

This can be done if get_page/put_page behaves consistently throughout the
whole tree (ie.  if we "get" the page after it has been used for something
else, we must be able to free it with a put_page).

Actually, there is a period where the count behaves differently: when the
page is free or if it is a constituent page of a compound page.  We need
an atomic_inc_not_zero operation to ensure we don't try to grab the page
in either case.

This patch introduces the core locking protocol to the pagecache (ie. 
adds page_cache_get_speculative, and tweaks some update-side code to make
it work).

Thanks to Hugh for pointing out an improvement to the algorithm setting
page_count to zero when we have control of all references, in order to
hold off speculative getters.

[kamezawa.hiroyu@jp.fujitsu.com: fix migration_entry_wait()]
[hugh@veritas.com: fix add_to_page_cache]
[akpm@linux-foundation.org: repair a comment]
Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Reviewed-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/cassini.c   |   12 ++++
 include/linux/pagemap.h |  111 +++++++++++++++++++++++++++++++++++++-
 mm/filemap.c            |   32 ++++++----
 mm/migrate.c            |   20 ++++++
 mm/shmem.c              |    6 +-
 mm/swap_state.c         |   17 ++++-
 mm/vmscan.c             |   74 ++++++++++++++++++-------
 7 files changed, 227 insertions(+), 45 deletions(-)

diff -puN drivers/net/cassini.c~mm-speculative-page-references drivers/net/cassini.c
--- a/drivers/net/cassini.c~mm-speculative-page-references
+++ a/drivers/net/cassini.c
@@ -576,6 +576,18 @@ static void cas_spare_recover(struct cas
 	list_for_each_safe(elem, tmp, &list) {
 		cas_page_t *page = list_entry(elem, cas_page_t, list);
 
+		/*
+		 * With the lockless pagecache, cassini buffering scheme gets
+		 * slightly less accurate: we might find that a page has an
+		 * elevated reference count here, due to a speculative ref,
+		 * and skip it as in-use. Ideally we would be able to reclaim
+		 * it. However this would be such a rare case, it doesn't
+		 * matter too much as we should pick it up the next time round.
+		 *
+		 * Importantly, if we find that the page has a refcount of 1
+		 * here (our refcount), then we know it is definitely not inuse
+		 * so we can reuse it.
+		 */
 		if (page_count(page->buffer) > 1)
 			continue;
 
diff -puN include/linux/pagemap.h~mm-speculative-page-references include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-speculative-page-references
+++ a/include/linux/pagemap.h
@@ -12,6 +12,7 @@
 #include <asm/uaccess.h>
 #include <linux/gfp.h>
 #include <linux/bitops.h>
+#include <linux/hardirq.h> /* for in_interrupt() */
 
 /*
  * Bits in mapping->flags.  The lower __GFP_BITS_SHIFT bits are the page
@@ -62,6 +63,98 @@ static inline void mapping_set_gfp_mask(
 #define page_cache_release(page)	put_page(page)
 void release_pages(struct page **pages, int nr, int cold);
 
+/*
+ * speculatively take a reference to a page.
+ * If the page is free (_count == 0), then _count is untouched, and 0
+ * is returned. Otherwise, _count is incremented by 1 and 1 is returned.
+ *
+ * This function must be called inside the same rcu_read_lock() section as has
+ * been used to lookup the page in the pagecache radix-tree (or page table):
+ * this allows allocators to use a synchronize_rcu() to stabilize _count.
+ *
+ * Unless an RCU grace period has passed, the count of all pages coming out
+ * of the allocator must be considered unstable. page_count may return higher
+ * than expected, and put_page must be able to do the right thing when the
+ * page has been finished with, no matter what it is subsequently allocated
+ * for (because put_page is what is used here to drop an invalid speculative
+ * reference).
+ *
+ * This is the interesting part of the lockless pagecache (and lockless
+ * get_user_pages) locking protocol, where the lookup-side (eg. find_get_page)
+ * has the following pattern:
+ * 1. find page in radix tree
+ * 2. conditionally increment refcount
+ * 3. check the page is still in pagecache (if no, goto 1)
+ *
+ * Remove-side that cares about stability of _count (eg. reclaim) has the
+ * following (with tree_lock held for write):
+ * A. atomically check refcount is correct and set it to 0 (atomic_cmpxchg)
+ * B. remove page from pagecache
+ * C. free the page
+ *
+ * There are 2 critical interleavings that matter:
+ * - 2 runs before A: in this case, A sees elevated refcount and bails out
+ * - A runs before 2: in this case, 2 sees zero refcount and retries;
+ *   subsequently, B will complete and 1 will find no page, causing the
+ *   lookup to return NULL.
+ *
+ * It is possible that between 1 and 2, the page is removed then the exact same
+ * page is inserted into the same position in pagecache. That's OK: the
+ * old find_get_page using tree_lock could equally have run before or after
+ * such a re-insertion, depending on order that locks are granted.
+ *
+ * Lookups racing against pagecache insertion isn't a big problem: either 1
+ * will find the page or it will not. Likewise, the old find_get_page could run
+ * either before the insertion or afterwards, depending on timing.
+ */
+static inline int page_cache_get_speculative(struct page *page)
+{
+	VM_BUG_ON(in_interrupt());
+
+#if !defined(CONFIG_SMP) && defined(CONFIG_CLASSIC_RCU)
+# ifdef CONFIG_PREEMPT
+	VM_BUG_ON(!in_atomic());
+# endif
+	/*
+	 * Preempt must be disabled here - we rely on rcu_read_lock doing
+	 * this for us.
+	 *
+	 * Pagecache won't be truncated from interrupt context, so if we have
+	 * found a page in the radix tree here, we have pinned its refcount by
+	 * disabling preempt, and hence no need for the "speculative get" that
+	 * SMP requires.
+	 */
+	VM_BUG_ON(page_count(page) == 0);
+	atomic_inc(&page->_count);
+
+#else
+	if (unlikely(!get_page_unless_zero(page))) {
+		/*
+		 * Either the page has been freed, or will be freed.
+		 * In either case, retry here and the caller should
+		 * do the right thing (see comments above).
+		 */
+		return 0;
+	}
+#endif
+	VM_BUG_ON(PageTail(page));
+
+	return 1;
+}
+
+static inline int page_freeze_refs(struct page *page, int count)
+{
+	return likely(atomic_cmpxchg(&page->_count, count, 0) == count);
+}
+
+static inline void page_unfreeze_refs(struct page *page, int count)
+{
+	VM_BUG_ON(page_count(page) != 0);
+	VM_BUG_ON(count == 0);
+
+	atomic_set(&page->_count, count);
+}
+
 #ifdef CONFIG_NUMA
 extern struct page *__page_cache_alloc(gfp_t gfp);
 #else
@@ -133,7 +226,7 @@ static inline struct page *read_mapping_
 	return read_cache_page(mapping, index, filler, data);
 }
 
-int add_to_page_cache(struct page *page, struct address_space *mapping,
+int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
 				pgoff_t index, gfp_t gfp_mask);
 int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 				pgoff_t index, gfp_t gfp_mask);
@@ -141,6 +234,22 @@ extern void remove_from_page_cache(struc
 extern void __remove_from_page_cache(struct page *page);
 
 /*
+ * Like add_to_page_cache_locked, but used to add newly allocated pages:
+ * the page is new, so we can just run SetPageLocked() against it.
+ */
+static inline int add_to_page_cache(struct page *page,
+		struct address_space *mapping, pgoff_t offset, gfp_t gfp_mask)
+{
+	int error;
+
+	SetPageLocked(page);
+	error = add_to_page_cache_locked(page, mapping, offset, gfp_mask);
+	if (unlikely(error))
+		ClearPageLocked(page);
+	return error;
+}
+
+/*
  * Return byte-offset into filesystem object for page.
  */
 static inline loff_t page_offset(struct page *page)
diff -puN mm/filemap.c~mm-speculative-page-references mm/filemap.c
--- a/mm/filemap.c~mm-speculative-page-references
+++ a/mm/filemap.c
@@ -442,39 +442,43 @@ int filemap_write_and_wait_range(struct 
 }
 
 /**
- * add_to_page_cache - add newly allocated pagecache pages
+ * add_to_page_cache_locked - add a locked page to the pagecache
  * @page:	page to add
  * @mapping:	the page's address_space
  * @offset:	page index
  * @gfp_mask:	page allocation mode
  *
- * This function is used to add newly allocated pagecache pages;
- * the page is new, so we can just run SetPageLocked() against it.
- * The other page state flags were set by rmqueue().
- *
+ * This function is used to add a page to the pagecache. It must be locked.
  * This function does not add the page to the LRU.  The caller must do that.
  */
-int add_to_page_cache(struct page *page, struct address_space *mapping,
+int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
 		pgoff_t offset, gfp_t gfp_mask)
 {
-	int error = mem_cgroup_cache_charge(page, current->mm,
+	int error;
+
+	VM_BUG_ON(!PageLocked(page));
+
+	error = mem_cgroup_cache_charge(page, current->mm,
 					gfp_mask & ~__GFP_HIGHMEM);
 	if (error)
 		goto out;
 
 	error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
 	if (error == 0) {
+		page_cache_get(page);
+		page->mapping = mapping;
+		page->index = offset;
+
 		write_lock_irq(&mapping->tree_lock);
 		error = radix_tree_insert(&mapping->page_tree, offset, page);
-		if (!error) {
-			page_cache_get(page);
-			SetPageLocked(page);
-			page->mapping = mapping;
-			page->index = offset;
+		if (likely(!error)) {
 			mapping->nrpages++;
 			__inc_zone_page_state(page, NR_FILE_PAGES);
-		} else
+		} else {
+			page->mapping = NULL;
 			mem_cgroup_uncharge_cache_page(page);
+			page_cache_release(page);
+		}
 
 		write_unlock_irq(&mapping->tree_lock);
 		radix_tree_preload_end();
@@ -483,7 +487,7 @@ int add_to_page_cache(struct page *page,
 out:
 	return error;
 }
-EXPORT_SYMBOL(add_to_page_cache);
+EXPORT_SYMBOL(add_to_page_cache_locked);
 
 int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 				pgoff_t offset, gfp_t gfp_mask)
diff -puN mm/migrate.c~mm-speculative-page-references mm/migrate.c
--- a/mm/migrate.c~mm-speculative-page-references
+++ a/mm/migrate.c
@@ -285,7 +285,15 @@ void migration_entry_wait(struct mm_stru
 
 	page = migration_entry_to_page(entry);
 
-	get_page(page);
+	/*
+	 * Once radix-tree replacement of page migration started, page_count
+	 * *must* be zero. And, we don't want to call wait_on_page_locked()
+	 * against a page without get_page().
+	 * So, we use get_page_unless_zero(), here. Even failed, page fault
+	 * will occur again.
+	 */
+	if (!get_page_unless_zero(page))
+		goto out;
 	pte_unmap_unlock(ptep, ptl);
 	wait_on_page_locked(page);
 	put_page(page);
@@ -305,6 +313,7 @@ out:
 static int migrate_page_move_mapping(struct address_space *mapping,
 		struct page *newpage, struct page *page)
 {
+	int expected_count;
 	void **pslot;
 
 	if (!mapping) {
@@ -319,12 +328,18 @@ static int migrate_page_move_mapping(str
 	pslot = radix_tree_lookup_slot(&mapping->page_tree,
  					page_index(page));
 
-	if (page_count(page) != 2 + !!PagePrivate(page) ||
+	expected_count = 2 + !!PagePrivate(page);
+	if (page_count(page) != expected_count ||
 			(struct page *)radix_tree_deref_slot(pslot) != page) {
 		write_unlock_irq(&mapping->tree_lock);
 		return -EAGAIN;
 	}
 
+	if (!page_freeze_refs(page, expected_count)) {
+		write_unlock_irq(&mapping->tree_lock);
+		return -EAGAIN;
+	}
+
 	/*
 	 * Now we know that no one else is looking at the page.
 	 */
@@ -338,6 +353,7 @@ static int migrate_page_move_mapping(str
 
 	radix_tree_replace_slot(pslot, newpage);
 
+	page_unfreeze_refs(page, expected_count);
 	/*
 	 * Drop cache reference from old page.
 	 * We know this isn't the last reference.
diff -puN mm/shmem.c~mm-speculative-page-references mm/shmem.c
--- a/mm/shmem.c~mm-speculative-page-references
+++ a/mm/shmem.c
@@ -936,7 +936,7 @@ found:
 	spin_lock(&info->lock);
 	ptr = shmem_swp_entry(info, idx, NULL);
 	if (ptr && ptr->val == entry.val) {
-		error = add_to_page_cache(page, inode->i_mapping,
+		error = add_to_page_cache_locked(page, inode->i_mapping,
 						idx, GFP_NOWAIT);
 		/* does mem_cgroup_uncharge_cache_page on error */
 	} else	/* we must compensate for our precharge above */
@@ -1301,8 +1301,8 @@ repeat:
 			SetPageUptodate(filepage);
 			set_page_dirty(filepage);
 			swap_free(swap);
-		} else if (!(error = add_to_page_cache(
-				swappage, mapping, idx, GFP_NOWAIT))) {
+		} else if (!(error = add_to_page_cache_locked(swappage, mapping,
+					idx, GFP_NOWAIT))) {
 			info->flags |= SHMEM_PAGEIN;
 			shmem_swp_set(info, entry, 0);
 			shmem_swp_unmap(entry);
diff -puN mm/swap_state.c~mm-speculative-page-references mm/swap_state.c
--- a/mm/swap_state.c~mm-speculative-page-references
+++ a/mm/swap_state.c
@@ -64,7 +64,7 @@ void show_swap_cache_info(void)
 }
 
 /*
- * add_to_swap_cache resembles add_to_page_cache on swapper_space,
+ * add_to_swap_cache resembles add_to_page_cache_locked on swapper_space,
  * but sets SwapCache flag and private instead of mapping and index.
  */
 int add_to_swap_cache(struct page *page, swp_entry_t entry, gfp_t gfp_mask)
@@ -76,19 +76,26 @@ int add_to_swap_cache(struct page *page,
 	BUG_ON(PagePrivate(page));
 	error = radix_tree_preload(gfp_mask);
 	if (!error) {
+		page_cache_get(page);
+		SetPageSwapCache(page);
+		set_page_private(page, entry.val);
+
 		write_lock_irq(&swapper_space.tree_lock);
 		error = radix_tree_insert(&swapper_space.page_tree,
 						entry.val, page);
-		if (!error) {
-			page_cache_get(page);
-			SetPageSwapCache(page);
-			set_page_private(page, entry.val);
+		if (likely(!error)) {
 			total_swapcache_pages++;
 			__inc_zone_page_state(page, NR_FILE_PAGES);
 			INC_CACHE_INFO(add_total);
 		}
 		write_unlock_irq(&swapper_space.tree_lock);
 		radix_tree_preload_end();
+
+		if (unlikely(error)) {
+			set_page_private(page, 0UL);
+			ClearPageSwapCache(page);
+			page_cache_release(page);
+		}
 	}
 	return error;
 }
diff -puN mm/vmscan.c~mm-speculative-page-references mm/vmscan.c
--- a/mm/vmscan.c~mm-speculative-page-references
+++ a/mm/vmscan.c
@@ -391,12 +391,10 @@ static pageout_t pageout(struct page *pa
 }
 
 /*
- * Attempt to detach a locked page from its ->mapping.  If it is dirty or if
- * someone else has a ref on the page, abort and return 0.  If it was
- * successfully detached, return 1.  Assumes the caller has a single ref on
- * this page.
+ * Same as remove_mapping, but if the page is removed from the mapping, it
+ * gets returned with a refcount of 0.
  */
-int remove_mapping(struct address_space *mapping, struct page *page)
+static int __remove_mapping(struct address_space *mapping, struct page *page)
 {
 	BUG_ON(!PageLocked(page));
 	BUG_ON(mapping != page_mapping(page));
@@ -427,24 +425,24 @@ int remove_mapping(struct address_space 
 	 * Note that if SetPageDirty is always performed via set_page_dirty,
 	 * and thus under tree_lock, then this ordering is not required.
 	 */
-	if (unlikely(page_count(page) != 2))
+	if (!page_freeze_refs(page, 2))
 		goto cannot_free;
-	smp_rmb();
-	if (unlikely(PageDirty(page)))
+	/* note: atomic_cmpxchg in page_freeze_refs provides the smp_rmb */
+	if (unlikely(PageDirty(page))) {
+		page_unfreeze_refs(page, 2);
 		goto cannot_free;
+	}
 
 	if (PageSwapCache(page)) {
 		swp_entry_t swap = { .val = page_private(page) };
 		__delete_from_swap_cache(page);
 		write_unlock_irq(&mapping->tree_lock);
 		swap_free(swap);
-		__put_page(page);	/* The pagecache ref */
-		return 1;
+	} else {
+		__remove_from_page_cache(page);
+		write_unlock_irq(&mapping->tree_lock);
 	}
 
-	__remove_from_page_cache(page);
-	write_unlock_irq(&mapping->tree_lock);
-	__put_page(page);
 	return 1;
 
 cannot_free:
@@ -453,6 +451,26 @@ cannot_free:
 }
 
 /*
+ * Attempt to detach a locked page from its ->mapping.  If it is dirty or if
+ * someone else has a ref on the page, abort and return 0.  If it was
+ * successfully detached, return 1.  Assumes the caller has a single ref on
+ * this page.
+ */
+int remove_mapping(struct address_space *mapping, struct page *page)
+{
+	if (__remove_mapping(mapping, page)) {
+		/*
+		 * Unfreezing the refcount with 1 rather than 2 effectively
+		 * drops the pagecache ref for us without requiring another
+		 * atomic operation.
+		 */
+		page_unfreeze_refs(page, 1);
+		return 1;
+	}
+	return 0;
+}
+
+/*
  * shrink_page_list() returns the number of reclaimed pages
  */
 static unsigned long shrink_page_list(struct list_head *page_list,
@@ -598,18 +616,34 @@ static unsigned long shrink_page_list(st
 		if (PagePrivate(page)) {
 			if (!try_to_release_page(page, sc->gfp_mask))
 				goto activate_locked;
-			if (!mapping && page_count(page) == 1)
-				goto free_it;
+			if (!mapping && page_count(page) == 1) {
+				unlock_page(page);
+				if (put_page_testzero(page))
+					goto free_it;
+				else {
+					/*
+					 * rare race with speculative reference.
+					 * the speculative reference will free
+					 * this page shortly, so we may
+					 * increment nr_reclaimed here (and
+					 * leave it off the LRU).
+					 */
+					nr_reclaimed++;
+					continue;
+				}
+			}
 		}
 
-		if (!mapping || !remove_mapping(mapping, page))
+		if (!mapping || !__remove_mapping(mapping, page))
 			goto keep_locked;
 
-free_it:
 		unlock_page(page);
+free_it:
 		nr_reclaimed++;
-		if (!pagevec_add(&freed_pvec, page))
-			__pagevec_release_nonlru(&freed_pvec);
+		if (!pagevec_add(&freed_pvec, page)) {
+			__pagevec_free(&freed_pvec);
+			pagevec_reinit(&freed_pvec);
+		}
 		continue;
 
 activate_locked:
@@ -623,7 +657,7 @@ keep:
 	}
 	list_splice(&ret_pages, page_list);
 	if (pagevec_count(&freed_pvec))
-		__pagevec_release_nonlru(&freed_pvec);
+		__pagevec_free(&freed_pvec);
 	count_vm_events(PGACTIVATE, pgactivate);
 	return nr_reclaimed;
 }
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
powerpc-implement-pte_special.patch
powerpc-implement-pte_special-update.patch
powerpc-lockless-get_user_pages.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

