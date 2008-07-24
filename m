From: akpm@linux-foundation.org
Subject: - mm-export-prep_compound_page-to-mm.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:23:11 -0700
Message-ID: <200807242323.m6ONNBmr010638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753499AbYGXXXf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:23:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, agl@us.ibm.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: export prep_compound_page to mm
has been removed from the -mm tree.  Its filename was
     mm-export-prep_compound_page-to-mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: export prep_compound_page to mm
From: Nick Piggin <npiggin@suse.de>

hugetlb will need to get compound pages from bootmem to handle the case of
them being greater than or equal to MAX_ORDER.  Export the constructor
function needed for this.

Acked-by: Adam Litke <agl@us.ibm.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    2 ++
 mm/page_alloc.c |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/internal.h~mm-export-prep_compound_page-to-mm mm/internal.h
--- a/mm/internal.h~mm-export-prep_compound_page-to-mm
+++ a/mm/internal.h
@@ -16,6 +16,8 @@
 void free_pgtables(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
 		unsigned long floor, unsigned long ceiling);
 
+extern void prep_compound_page(struct page *page, unsigned long order);
+
 static inline void set_page_count(struct page *page, int v)
 {
 	atomic_set(&page->_count, v);
diff -puN mm/page_alloc.c~mm-export-prep_compound_page-to-mm mm/page_alloc.c
--- a/mm/page_alloc.c~mm-export-prep_compound_page-to-mm
+++ a/mm/page_alloc.c
@@ -264,7 +264,7 @@ static void free_compound_page(struct pa
 	__free_pages_ok(page, compound_order(page));
 }
 
-static void prep_compound_page(struct page *page, unsigned long order)
+void prep_compound_page(struct page *page, unsigned long order)
 {
 	int i;
 	int nr_pages = 1 << order;
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

