From: akpm@linux-foundation.org
Subject: [merged] proc-pagemap-correctly-report-non-present-ptes-and-holes-between-vmas.patch removed from -mm tree
Date: Wed, 16 May 2012 11:46:43 -0700
Message-ID: <20120516184645.8AF67A028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:49913 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab2EPSqt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 May 2012 14:46:49 -0400
Received: by wibhn6 with SMTP id hn6so64924wib.1
        for <mm-commits@vger.kernel.org>; Wed, 16 May 2012 11:46:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, ak@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc/pid/pagemap: correctly report non-present ptes and holes between vmas
has been removed from the -mm tree.  Its filename was
     proc-pagemap-correctly-report-non-present-ptes-and-holes-between-vmas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: proc/pid/pagemap: correctly report non-present ptes and holes between vmas

Reset the current pagemap-entry if the current pte isn't present, or if
current vma is over.  Otherwise pagemap reports last entry again and
again.

non-present pte reporting was broken in commit v3.3-3738-g092b50b
("pagemap: introduce data structure for pagemap entry")

reporting for holes was broken in commit v3.3-3734-g5aaabe8
("pagemap: avoid splitting thp when reading /proc/pid/pagemap")

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Reported-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~proc-pagemap-correctly-report-non-present-ptes-and-holes-between-vmas fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-pagemap-correctly-report-non-present-ptes-and-holes-between-vmas
+++ a/fs/proc/task_mmu.c
@@ -747,6 +747,8 @@ static void pte_to_pagemap_entry(pagemap
 	else if (pte_present(pte))
 		*pme = make_pme(PM_PFRAME(pte_pfn(pte))
 				| PM_PSHIFT(PAGE_SHIFT) | PM_PRESENT);
+	else
+		*pme = make_pme(PM_NOT_PRESENT);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -761,6 +763,8 @@ static void thp_pmd_to_pagemap_entry(pag
 	if (pmd_present(pmd))
 		*pme = make_pme(PM_PFRAME(pmd_pfn(pmd) + offset)
 				| PM_PSHIFT(PAGE_SHIFT) | PM_PRESENT);
+	else
+		*pme = make_pme(PM_NOT_PRESENT);
 }
 #else
 static inline void thp_pmd_to_pagemap_entry(pagemap_entry_t *pme,
@@ -801,8 +805,10 @@ static int pagemap_pte_range(pmd_t *pmd,
 
 		/* check to see if we've left 'vma' behind
 		 * and need a new, higher one */
-		if (vma && (addr >= vma->vm_end))
+		if (vma && (addr >= vma->vm_end)) {
 			vma = find_vma(walk->mm, addr);
+			pme = make_pme(PM_NOT_PRESENT);
+		}
 
 		/* check that 'vma' actually covers this address,
 		 * and that it isn't a huge page vma */
@@ -830,6 +836,8 @@ static void huge_pte_to_pagemap_entry(pa
 	if (pte_present(pte))
 		*pme = make_pme(PM_PFRAME(pte_pfn(pte) + offset)
 				| PM_PSHIFT(PAGE_SHIFT) | PM_PRESENT);
+	else
+		*pme = make_pme(PM_NOT_PRESENT);
 }
 
 /* This function walks within one hugetlb entry in the single call */
@@ -839,7 +847,7 @@ static int pagemap_hugetlb_range(pte_t *
 {
 	struct pagemapread *pm = walk->private;
 	int err = 0;
-	pagemap_entry_t pme = make_pme(PM_NOT_PRESENT);
+	pagemap_entry_t pme;
 
 	for (; addr != end; addr += PAGE_SIZE) {
 		int offset = (addr & ~hmask) >> PAGE_SHIFT;
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

linux-next.patch
fs-proc-fix-abba-deadlock-in-case-of-execution-attempt-of-map_files-entries.patch
mm-remove-swap-token-code.patch
mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-do-not-stall-on-writeback-during-memory-compaction.patch
mm-vmscan-remove-reclaim_mode_t.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
kernel-cgroup-push-rcu-read-locking-from-css_is_ancestor-to-callsite.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy-fix.patch
bug-introduce-build_bug_on_invalid-macro.patch
bug-completely-remove-code-generated-by-disabled-vm_bug_on.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
mm-vmscan-store-priority-in-struct-scan_control.patch
mm-add-link-from-struct-lruvec-to-struct-zone.patch
mm-vmscan-push-lruvec-pointer-into-isolate_lru_pages.patch
mm-vmscan-push-zone-pointer-into-shrink_page_list.patch
mm-vmscan-remove-update_isolated_counts.patch
mm-vmscan-push-lruvec-pointer-into-putback_inactive_pages.patch
mm-vmscan-replace-zone_nr_lru_pages-with-get_lruvec_size.patch
mm-vmscan-push-lruvec-pointer-into-inactive_list_is_low.patch
mm-vmscan-push-lruvec-pointer-into-shrink_list.patch
mm-vmscan-push-lruvec-pointer-into-get_scan_count.patch
mm-vmscan-push-lruvec-pointer-into-should_continue_reclaim.patch
mm-vmscan-kill-struct-mem_cgroup_zone.patch
mm-memcg-get_lru_size-not-get_lruvec_size.patch
mm-trivial-cleanups-in-vmscanc.patch
mm-memcg-apply-add-del_page-to-lruvec.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-smaps-carefully-handle-migration-entries.patch
proc-smaps-show-amount-of-nonlinear-ptes-in-vma.patch
proc-smaps-show-amount-of-hwpoison-pages.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

