From: akpm@linux-foundation.org
Subject: +
 mm-mempolicy-skip-inaccessible-vmas-when-setting-mpol_mf_lazy.patch added
 to -mm tree
Date: Thu, 02 Oct 2014 13:22:40 -0700
Message-ID: <542db410.4XXz9DbOk1l6kevq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55324 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaJBUWk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Oct 2014 16:22:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, hughd@google.com, peterz@infradead.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mempolicy: skip inaccessible VMAs when setting MPOL_MF_LAZY
has been added to the -mm tree.  Its filename is
     mm-mempolicy-skip-inaccessible-vmas-when-setting-mpol_mf_lazy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-skip-inaccessible-vmas-when-setting-mpol_mf_lazy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-skip-inaccessible-vmas-when-setting-mpol_mf_lazy.patch

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
Subject: mm: mempolicy: skip inaccessible VMAs when setting MPOL_MF_LAZY

PROT_NUMA VMAs are skipped to avoid problems distinguishing between
present, prot_none and special entries.  MPOL_MF_LAZY is not visible from
userspace since commit a720094ded8c ("mm: mempolicy: Hide MPOL_NOOP and
MPOL_MF_LAZY from userspace for now") but it should still skip VMAs the
same way task_numa_work does.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mm-mempolicy-skip-inaccessible-vmas-when-setting-mpol_mf_lazy mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-skip-inaccessible-vmas-when-setting-mpol_mf_lazy
+++ a/mm/mempolicy.c
@@ -681,7 +681,9 @@ queue_pages_range(struct mm_struct *mm,
 		}
 
 		if (flags & MPOL_MF_LAZY) {
-			change_prot_numa(vma, start, endvma);
+			/* Similar to task_numa_work, skip inaccessible VMAs */
+			if (vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE))
+				change_prot_numa(vma, start, endvma);
 			goto next;
 		}
 
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-migrate-close-race-between-migration-completion-and-mprotect.patch
mm-numa-do-not-mark-ptes-pte_numa-when-splitting-huge-pages.patch
mm-page_alloc-fix-zone-allocation-fairness-on-up.patch
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

