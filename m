From: akpm@linux-foundation.org
Subject: [merged] mm-thp-fix-bug-on-mm-nr_ptes.patch removed from -mm tree
Date: Tue, 06 Mar 2012 11:35:21 -0800
Message-ID: <20120306193521.7DAAFA02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:45293 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758745Ab2CFTfW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 14:35:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, davej@redhat.com, hughd@google.com, jwboyer@redhat.com, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: fix BUG on mm->nr_ptes
has been removed from the -mm tree.  Its filename was
     mm-thp-fix-bug-on-mm-nr_ptes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: thp: fix BUG on mm->nr_ptes

Dave Jones reports a few Fedora users hitting the BUG_ON(mm->nr_ptes...)
in exit_mmap() recently.

Quoting Hugh's discovery and explanation of the SMP race condition:

===
mm->nr_ptes had unusual locking: down_read mmap_sem plus
page_table_lock when incrementing, down_write mmap_sem (or mm_users 0)
when decrementing; whereas THP is careful to increment and decrement
it under page_table_lock.

Now most of those paths in THP also hold mmap_sem for read or write
(with appropriate checks on mm_users), but two do not: when
split_huge_page() is called by hwpoison_user_mappings(), and when
called by add_to_swap().

It's conceivable that the latter case is responsible for the
exit_mmap() BUG_ON mm->nr_ptes that has been reported on Fedora.
===

The simplest way to fix it without having to alter the locking is to make
split_huge_page() a noop in nr_ptes terms, so by counting the preallocated
pagetables that exists for every mapped hugepage.  It was an arbitrary
choice not to count them and either way is not wrong or right, because
they are not used but they're still allocated.

Reported-by: Dave Jones <davej@redhat.com>
Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: <stable@vger.kernel.org>	[3.0.x, 3.1.x, 3.2.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-fix-bug-on-mm-nr_ptes mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-fix-bug-on-mm-nr_ptes
+++ a/mm/huge_memory.c
@@ -671,6 +671,7 @@ static int __do_huge_pmd_anonymous_page(
 		set_pmd_at(mm, haddr, pmd, entry);
 		prepare_pmd_huge_pte(pgtable, mm);
 		add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
+		mm->nr_ptes++;
 		spin_unlock(&mm->page_table_lock);
 	}
 
@@ -789,6 +790,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 	pmd = pmd_mkold(pmd_wrprotect(pmd));
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 	prepare_pmd_huge_pte(pgtable, dst_mm);
+	dst_mm->nr_ptes++;
 
 	ret = 0;
 out_unlock:
@@ -887,7 +889,6 @@ static int do_huge_pmd_wp_page_fallback(
 	}
 	kfree(pages);
 
-	mm->nr_ptes++;
 	smp_wmb(); /* make pte visible before pmd */
 	pmd_populate(mm, pmd, pgtable);
 	page_remove_rmap(page);
@@ -1047,6 +1048,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 			VM_BUG_ON(page_mapcount(page) < 0);
 			add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 			VM_BUG_ON(!PageHead(page));
+			tlb->mm->nr_ptes--;
 			spin_unlock(&tlb->mm->page_table_lock);
 			tlb_remove_page(tlb, page);
 			pte_free(tlb->mm, pgtable);
@@ -1375,7 +1377,6 @@ static int __split_huge_page_map(struct 
 			pte_unmap(pte);
 		}
 
-		mm->nr_ptes++;
 		smp_wmb(); /* make pte visible before pmd */
 		/*
 		 * Up to this point the pmd is present and huge and
@@ -1988,7 +1989,6 @@ static void collapse_huge_page(struct mm
 	set_pmd_at(mm, address, pmd, _pmd);
 	update_mmu_cache(vma, address, _pmd);
 	prepare_pmd_huge_pte(pgtable, mm);
-	mm->nr_ptes--;
 	spin_unlock(&mm->page_table_lock);
 
 #ifndef CONFIG_NUMA
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
linux-next.patch
vmscan-reclaim-at-order-0-when-compaction-is-enabled.patch
vmscan-kswapd-carefully-call-compaction.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
vmscan-only-defer-compaction-for-failed-order-and-higher.patch
mm-compaction-make-compact_control-order-signed.patch
mm-compaction-make-compact_control-order-signed-fix.patch
hugetlbfs-fix-hugetlb_get_unmapped_area.patch
hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch
mm-search-from-free_area_cache-for-the-bigger-size.patch
pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
thp-optimize-away-unnecessary-page-table-locking.patch
thp-optimize-away-unnecessary-page-table-locking-fix.patch
pagemap-export-kpf_thp.patch
pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch
pagemap-introduce-data-structure-for-pagemap-entry.patch
mm-hugetlb-defer-freeing-pages-when-gathering-surplus-pages.patch
thp-transparent_hugepage=-can-also-be-specified-on-cmdline.patch
thp-allow-a-hwpoisoned-head-page-to-be-put-back-to-lru.patch
memcg-remove-unnecessary-thp-check-in-page-stat-accounting.patch

