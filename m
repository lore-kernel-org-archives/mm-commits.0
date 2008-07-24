From: akpm@linux-foundation.org
Subject: - hugetlb-support-boot-allocate-different-sizes.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:23:16 -0700
Message-ID: <200807242323.m6ONNGbi010647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754134AbYGXXX0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:23:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, abh@cray.com, agl@us.ibm.com, ak@suse.de, nacc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: support boot allocate different sizes
has been removed from the -mm tree.  Its filename was
     hugetlb-support-boot-allocate-different-sizes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: support boot allocate different sizes
From: Nick Piggin <npiggin@suse.de>

Make some infrastructure changes to allow boot-time allocation of
different hugepage page sizes.

- move all basic hstate initialisation into hugetlb_add_hstate
- create a new function hugetlb_hstate_alloc_pages() to do the
  actual initial page allocations. Call this function early in
  order to allocate giant pages from bootmem.
- Check for multiple hugepages= parameters

Acked-by: Adam Litke <agl@us.ibm.com>
Acked-by: Nishanth Aravamudan <nacc@us.ibm.com>
Acked-by: Andrew Hastings <abh@cray.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-support-boot-allocate-different-sizes mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-support-boot-allocate-different-sizes
+++ a/mm/hugetlb.c
@@ -981,15 +981,10 @@ static void __init gather_bootmem_preall
 	}
 }
 
-static void __init hugetlb_init_one_hstate(struct hstate *h)
+static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
 {
 	unsigned long i;
 
-	for (i = 0; i < MAX_NUMNODES; ++i)
-		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
-
-	h->hugetlb_next_nid = first_node(node_online_map);
-
 	for (i = 0; i < h->max_huge_pages; ++i) {
 		if (h->order >= MAX_ORDER) {
 			if (!alloc_bootmem_huge_page(h))
@@ -997,7 +992,7 @@ static void __init hugetlb_init_one_hsta
 		} else if (!alloc_fresh_huge_page(h))
 			break;
 	}
-	h->max_huge_pages = h->free_huge_pages = h->nr_huge_pages = i;
+	h->max_huge_pages = i;
 }
 
 static void __init hugetlb_init_hstates(void)
@@ -1005,7 +1000,9 @@ static void __init hugetlb_init_hstates(
 	struct hstate *h;
 
 	for_each_hstate(h) {
-		hugetlb_init_one_hstate(h);
+		/* oversize hugepages were init'ed in early boot */
+		if (h->order < MAX_ORDER)
+			hugetlb_hstate_alloc_pages(h);
 	}
 }
 
@@ -1301,6 +1298,8 @@ module_init(hugetlb_init);
 void __init hugetlb_add_hstate(unsigned order)
 {
 	struct hstate *h;
+	unsigned long i;
+
 	if (size_to_hstate(PAGE_SIZE << order)) {
 		printk(KERN_WARNING "hugepagesz= specified twice, ignoring\n");
 		return;
@@ -1310,15 +1309,21 @@ void __init hugetlb_add_hstate(unsigned 
 	h = &hstates[max_hstate++];
 	h->order = order;
 	h->mask = ~((1ULL << (order + PAGE_SHIFT)) - 1);
+	h->nr_huge_pages = 0;
+	h->free_huge_pages = 0;
+	for (i = 0; i < MAX_NUMNODES; ++i)
+		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
+	h->hugetlb_next_nid = first_node(node_online_map);
 	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
 					huge_page_size(h)/1024);
-	hugetlb_init_one_hstate(h);
+
 	parsed_hstate = h;
 }
 
 static int __init hugetlb_setup(char *s)
 {
 	unsigned long *mhp;
+	static unsigned long *last_mhp;
 
 	/*
 	 * !max_hstate means we haven't parsed a hugepagesz= parameter yet,
@@ -1329,9 +1334,25 @@ static int __init hugetlb_setup(char *s)
 	else
 		mhp = &parsed_hstate->max_huge_pages;
 
+	if (mhp == last_mhp) {
+		printk(KERN_WARNING "hugepages= specified twice without "
+			"interleaving hugepagesz=, ignoring\n");
+		return 1;
+	}
+
 	if (sscanf(s, "%lu", mhp) <= 0)
 		*mhp = 0;
 
+	/*
+	 * Global state is always initialized later in hugetlb_init.
+	 * But we need to allocate >= MAX_ORDER hstates here early to still
+	 * use the bootmem allocator.
+	 */
+	if (max_hstate && parsed_hstate->order >= MAX_ORDER)
+		hugetlb_hstate_alloc_pages(parsed_hstate);
+
+	last_mhp = mhp;
+
 	return 1;
 }
 __setup("hugepages=", hugetlb_setup);
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
x86-support-1gb-hugepages-with-get_user_pages_lockless.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-speculative-page-references-fix-add_to_page_cache.patch
mm-speculative-page-references-fix-add_to_page_cache-fix.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
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

