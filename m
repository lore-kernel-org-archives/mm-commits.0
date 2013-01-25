From: akpm@linux-foundation.org
Subject: + mm-rename-page-struct-field-helpers.patch added to -mm tree
Date: Thu, 24 Jan 2013 16:32:23 -0800
Message-ID: <20130125003223.9AE085A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:53311 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab3AYAcY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jan 2013 19:32:24 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so112785yhr.0
        for <mm-commits@vger.kernel.org>; Thu, 24 Jan 2013 16:32:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, akpm@linux-foundation.org


The patch titled
     Subject: mm: rename page struct field helpers
has been added to the -mm tree.  Its filename is
     mm-rename-page-struct-field-helpers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: rename page struct field helpers

The function names page_xchg_last_nid(), page_last_nid() and
reset_page_last_nid() were judged to be inconsistent so rename them to a
struct_field_op style pattern.  As it looked jarring to have
reset_page_mapcount() and page_nid_reset_last() beside each other in
memmap_init_zone(), this patch also renames reset_page_mapcount() to
page_mapcount_reset().  There are others like init_page_count() but as it
is used throughout the arch code a rename would likely cause more
conflicts than it is worth.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/zsmalloc/zsmalloc-main.c |    2 +-
 include/linux/mm.h                       |   20 ++++++++++----------
 mm/huge_memory.c                         |    2 +-
 mm/mempolicy.c                           |    2 +-
 mm/migrate.c                             |    4 ++--
 mm/mmzone.c                              |    4 ++--
 mm/page_alloc.c                          |   10 +++++-----
 mm/slob.c                                |    2 +-
 mm/slub.c                                |    2 +-
 9 files changed, 24 insertions(+), 24 deletions(-)

diff -puN /dev/null /dev/null
diff -puN drivers/staging/zsmalloc/zsmalloc-main.c~mm-rename-page-struct-field-helpers drivers/staging/zsmalloc/zsmalloc-main.c
--- a/drivers/staging/zsmalloc/zsmalloc-main.c~mm-rename-page-struct-field-helpers
+++ a/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -475,7 +475,7 @@ static void reset_page(struct page *page
 	set_page_private(page, 0);
 	page->mapping = NULL;
 	page->freelist = NULL;
-	reset_page_mapcount(page);
+	page_mapcount_reset(page);
 }
 
 static void free_zspage(struct page *first_page)
diff -puN include/linux/mm.h~mm-rename-page-struct-field-helpers include/linux/mm.h
--- a/include/linux/mm.h~mm-rename-page-struct-field-helpers
+++ a/include/linux/mm.h
@@ -367,7 +367,7 @@ static inline struct page *compound_head
  * both from it and to it can be tracked, using atomic_inc_and_test
  * and atomic_add_negative(-1).
  */
-static inline void reset_page_mapcount(struct page *page)
+static inline void page_mapcount_reset(struct page *page)
 {
 	atomic_set(&(page)->_mapcount, -1);
 }
@@ -658,28 +658,28 @@ static inline int page_to_nid(const stru
 
 #ifdef CONFIG_NUMA_BALANCING
 #ifdef LAST_NID_NOT_IN_PAGE_FLAGS
-static inline int page_xchg_last_nid(struct page *page, int nid)
+static inline int page_nid_xchg_last(struct page *page, int nid)
 {
 	return xchg(&page->_last_nid, nid);
 }
 
-static inline int page_last_nid(struct page *page)
+static inline int page_nid_last(struct page *page)
 {
 	return page->_last_nid;
 }
-static inline void reset_page_last_nid(struct page *page)
+static inline void page_nid_reset_last(struct page *page)
 {
 	page->_last_nid = -1;
 }
 #else
-static inline int page_last_nid(struct page *page)
+static inline int page_nid_last(struct page *page)
 {
 	return (page->flags >> LAST_NID_PGSHIFT) & LAST_NID_MASK;
 }
 
-extern int page_xchg_last_nid(struct page *page, int nid);
+extern int page_nid_xchg_last(struct page *page, int nid);
 
-static inline void reset_page_last_nid(struct page *page)
+static inline void page_nid_reset_last(struct page *page)
 {
 	int nid = (1 << LAST_NID_SHIFT) - 1;
 
@@ -688,17 +688,17 @@ static inline void reset_page_last_nid(s
 }
 #endif /* LAST_NID_NOT_IN_PAGE_FLAGS */
 #else
-static inline int page_xchg_last_nid(struct page *page, int nid)
+static inline int page_nid_xchg_last(struct page *page, int nid)
 {
 	return page_to_nid(page);
 }
 
-static inline int page_last_nid(struct page *page)
+static inline int page_nid_last(struct page *page)
 {
 	return page_to_nid(page);
 }
 
-static inline void reset_page_last_nid(struct page *page)
+static inline void page_nid_reset_last(struct page *page)
 {
 }
 #endif
diff -puN mm/huge_memory.c~mm-rename-page-struct-field-helpers mm/huge_memory.c
--- a/mm/huge_memory.c~mm-rename-page-struct-field-helpers
+++ a/mm/huge_memory.c
@@ -1639,7 +1639,7 @@ static void __split_huge_page_refcount(s
 		page_tail->mapping = page->mapping;
 
 		page_tail->index = page->index + i;
-		page_xchg_last_nid(page_tail, page_last_nid(page));
+		page_nid_xchg_last(page_tail, page_nid_last(page));
 
 		BUG_ON(!PageAnon(page_tail));
 		BUG_ON(!PageUptodate(page_tail));
diff -puN mm/mempolicy.c~mm-rename-page-struct-field-helpers mm/mempolicy.c
--- a/mm/mempolicy.c~mm-rename-page-struct-field-helpers
+++ a/mm/mempolicy.c
@@ -2316,7 +2316,7 @@ int mpol_misplaced(struct page *page, st
 		 * it less likely we act on an unlikely task<->page
 		 * relation.
 		 */
-		last_nid = page_xchg_last_nid(page, polnid);
+		last_nid = page_nid_xchg_last(page, polnid);
 		if (last_nid != polnid)
 			goto out;
 	}
diff -puN mm/migrate.c~mm-rename-page-struct-field-helpers mm/migrate.c
--- a/mm/migrate.c~mm-rename-page-struct-field-helpers
+++ a/mm/migrate.c
@@ -1497,7 +1497,7 @@ static struct page *alloc_misplaced_dst_
 					  __GFP_NOWARN) &
 					 ~GFP_IOFS, 0);
 	if (newpage)
-		page_xchg_last_nid(newpage, page_last_nid(page));
+		page_nid_xchg_last(newpage, page_nid_last(page));
 
 	return newpage;
 }
@@ -1681,7 +1681,7 @@ int migrate_misplaced_transhuge_page(str
 	if (!new_page)
 		goto out_fail;
 
-	page_xchg_last_nid(new_page, page_last_nid(page));
+	page_nid_xchg_last(new_page, page_nid_last(page));
 
 	isolated = numamigrate_isolate_page(pgdat, page);
 	if (!isolated) {
diff -puN mm/mmzone.c~mm-rename-page-struct-field-helpers mm/mmzone.c
--- a/mm/mmzone.c~mm-rename-page-struct-field-helpers
+++ a/mm/mmzone.c
@@ -98,14 +98,14 @@ void lruvec_init(struct lruvec *lruvec)
 }
 
 #if defined(CONFIG_NUMA_BALANCING) && !defined(LAST_NID_NOT_IN_PAGE_FLAGS)
-int page_xchg_last_nid(struct page *page, int nid)
+int page_nid_xchg_last(struct page *page, int nid)
 {
 	unsigned long old_flags, flags;
 	int last_nid;
 
 	do {
 		old_flags = flags = page->flags;
-		last_nid = page_last_nid(page);
+		last_nid = page_nid_last(page);
 
 		flags &= ~(LAST_NID_MASK << LAST_NID_PGSHIFT);
 		flags |= (nid & LAST_NID_MASK) << LAST_NID_PGSHIFT;
diff -puN mm/page_alloc.c~mm-rename-page-struct-field-helpers mm/page_alloc.c
--- a/mm/page_alloc.c~mm-rename-page-struct-field-helpers
+++ a/mm/page_alloc.c
@@ -291,7 +291,7 @@ static void bad_page(struct page *page)
 
 	/* Don't complain about poisoned pages */
 	if (PageHWPoison(page)) {
-		reset_page_mapcount(page); /* remove PageBuddy */
+		page_mapcount_reset(page); /* remove PageBuddy */
 		return;
 	}
 
@@ -323,7 +323,7 @@ static void bad_page(struct page *page)
 	dump_stack();
 out:
 	/* Leave bad fields for debug, except PageBuddy could make trouble */
-	reset_page_mapcount(page); /* remove PageBuddy */
+	page_mapcount_reset(page); /* remove PageBuddy */
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
 
@@ -609,7 +609,7 @@ static inline int free_pages_check(struc
 		bad_page(page);
 		return 1;
 	}
-	reset_page_last_nid(page);
+	page_nid_reset_last(page);
 	if (page->flags & PAGE_FLAGS_CHECK_AT_PREP)
 		page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	return 0;
@@ -3889,8 +3889,8 @@ void __meminit memmap_init_zone(unsigned
 		set_page_links(page, zone, nid, pfn);
 		mminit_verify_page_links(page, zone, nid, pfn);
 		init_page_count(page);
-		reset_page_mapcount(page);
-		reset_page_last_nid(page);
+		page_mapcount_reset(page);
+		page_nid_reset_last(page);
 		SetPageReserved(page);
 		/*
 		 * Mark the block movable so that blocks are reserved for
diff -puN mm/slob.c~mm-rename-page-struct-field-helpers mm/slob.c
--- a/mm/slob.c~mm-rename-page-struct-field-helpers
+++ a/mm/slob.c
@@ -360,7 +360,7 @@ static void slob_free(void *block, int s
 			clear_slob_page_free(sp);
 		spin_unlock_irqrestore(&slob_lock, flags);
 		__ClearPageSlab(sp);
-		reset_page_mapcount(sp);
+		page_mapcount_reset(sp);
 		slob_free_pages(b, 0);
 		return;
 	}
diff -puN mm/slub.c~mm-rename-page-struct-field-helpers mm/slub.c
--- a/mm/slub.c~mm-rename-page-struct-field-helpers
+++ a/mm/slub.c
@@ -1408,7 +1408,7 @@ static void __free_slab(struct kmem_cach
 	__ClearPageSlab(page);
 
 	memcg_release_pages(s, order);
-	reset_page_mapcount(page);
+	page_mapcount_reset(page);
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += pages;
 	__free_memcg_kmem_pages(page, order);
_

Patches currently in -mm which might be from mgorman@suse.de are

linux-next.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mm-compaction-do-not-accidentally-skip-pageblocks-in-the-migrate-scanner.patch
mm-huge_memory-use-new-hashtable-implementation.patch
mmksm-use-new-hashtable-implementation.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-avoid-calling-pgdat_balanced-needlessly.patch
mm-dont-wait-on-congested-zones-in-balance_pgdat.patch
mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate.patch
mm-set-zone-present_pages-to-number-of-existing-pages-in-the-zone.patch
mm-increase-totalram_pages-when-free-pages-allocated-by-bootmem-allocator.patch
mm-numa-fix-minor-typo-in-numa_next_scan.patch
mm-numa-take-thp-into-account-when-migrating-pages-for-numa-balancing.patch
mm-numa-handle-side-effects-in-count_vm_numa_events-for-config_numa_balancing.patch
mm-move-page-flags-layout-to-separate-header.patch
mm-fold-page-_last_nid-into-page-flags-where-possible.patch
mm-numa-cleanup-flow-of-transhuge-page-migration.patch
mm-uninline-page_xchg_last_nid.patch
mm-init-report-on-last-nid-information-stored-in-page-flags.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
mm-memmap_init_zone-performance-improvement.patch
mm-rename-page-struct-field-helpers.patch

