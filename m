From: akpm@linux-foundation.org
Subject: [merged]
 mm-numa-do-not-mark-ptes-pte_numa-when-splitting-huge-pages.patch removed
 from -mm tree
Date: Fri, 03 Oct 2014 11:04:25 -0700
Message-ID: <542ee529.jAidEvObiJ2HiVjt%akpm__503.375524613325$1412359488$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbaJCSE0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2014 14:04:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, davej@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, riel@redhat.com, sasha.levin@oracle.com, stable@vger.kernel.org, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: numa: do not mark PTEs pte_numa when splitting huge pages
has been removed from the -mm tree.  Its filename was
     mm-numa-do-not-mark-ptes-pte_numa-when-splitting-huge-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: numa: do not mark PTEs pte_numa when splitting huge pages

This patch reverts 1ba6e0b50b ("mm: numa: split_huge_page: transfer the
NUMA type from the pmd to the pte").  If a huge page is being split due a
protection change and the tail will be in a PROT_NONE vma then NUMA
hinting PTEs are temporarily created in the protected VMA.

 VM_RW|VM_PROTNONE
|-----------------|
      ^
      split here

In the specific case above, it should get fixed up by change_pte_range()
(but it does not - see below) but there is a window of opportunity for
weirdness to happen.  Similarly, if a huge page is shrunk and split during
a protection update but before pmd_numa is cleared then a pte_numa can be
left behind.

Instead of adding complexity trying to deal with the case, this patch will
not mark PTEs NUMA when splitting a huge page.  NUMA hinting faults will
not be triggered which is marginal in comparison to the complexity in
dealing with the corner cases during THP split.

Hugh said:

: You say "it should get fixed up by change_pte_range()".  Well, I agree it
: "should", but it does not: because once the pte has both _PAGE_NUMA and
: _PAGE_PROTNONE on it, then it fails our pte_numa() test, and so _PAGE_NUMA
: is not cleared, even if later replacing _PAGE_PROTNONE by _PAGE_PRESENT
: (whereupon the _PAGE_NUMA looks like _PAGE_SPECIAL).
: 
: This patch is clearly safe, and fixes a real bug, almost certainly the one
: seen by Sasha; but I still can't tie the ends together to see how it would
: explain the endless refaulting seen by Dave.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-numa-do-not-mark-ptes-pte_numa-when-splitting-huge-pages mm/huge_memory.c
--- a/mm/huge_memory.c~mm-numa-do-not-mark-ptes-pte_numa-when-splitting-huge-pages
+++ a/mm/huge_memory.c
@@ -1795,14 +1795,17 @@ static int __split_huge_page_map(struct
 		for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
 			pte_t *pte, entry;
 			BUG_ON(PageCompound(page+i));
+			/*
+			 * Note that pmd_numa is not transferred deliberately
+			 * to avoid any possibility that pte_numa leaks to
+			 * a PROT_NONE VMA by accident.
+			 */
 			entry = mk_pte(page + i, vma->vm_page_prot);
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 			if (!pmd_write(*pmd))
 				entry = pte_wrprotect(entry);
 			if (!pmd_young(*pmd))
 				entry = pte_mkold(entry);
-			if (pmd_numa(*pmd))
-				entry = pte_mknuma(entry);
 			pte = pte_offset_map(&_pmd, haddr);
 			BUG_ON(!pte_none(*pte));
 			set_pte_at(mm, haddr, pte, entry);
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-remove-misleading-arch_uses_numa_prot_none.patch
mm-page_alloc-determine-migratetype-only-once.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range-fix.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
mm-compaction-periodically-drop-lock-and-restore-irqs-in-scanners.patch
mm-compaction-skip-rechecks-when-lock-was-already-held.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
introduce-dump_vma.patch
introduce-dump_vma-fix.patch
introduce-vm_bug_on_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
mm-page_alloc-avoid-wakeup-kswapd-on-the-unintended-node.patch
mm-clean-up-zone-flags.patch
mm-compaction-fix-warning-of-flags-may-be-used-uninitialized.patch
mm-page_alloc-make-paranoid-check-in-move_freepages-a-vm_bug_on.patch
mm-page_alloc-default-node-ordering-on-64-bit-numa-zone-ordering-on-32-bit-v2.patch
mm-mempolicy-skip-inaccessible-vmas-when-setting-mpol_mf_lazy.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
x86-optimize-resource-lookups-for-ioremap.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
x86-use-optimized-ioresource-lookup-in-ioremap-function.patch
linux-next.patch

