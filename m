From: akpm@linux-foundation.org
Subject: + proc-pagemap-correctly-report-non-present-ptes-and-holes-between-vmas.patch added to -mm tree
Date: Mon, 30 Apr 2012 14:04:28 -0700
Message-ID: <20120430210428.9C783A036E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:43643 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab2D3VEb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Apr 2012 17:04:31 -0400
Received: by wejx9 with SMTP id x9so168346wej.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Apr 2012 14:04:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, ak@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, xemul@parallels.com


The patch titled
     Subject: proc/pid/pagemap: correctly report non-present ptes and holes between vmas
has been added to the -mm tree.  Its filename is
     proc-pagemap-correctly-report-non-present-ptes-and-holes-between-vmas.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: proc/pid/pagemap: correctly report non-present ptes and holes between vmas

Patches currently in -mm which might be from khlebnikov@openvz.org are

linux-next.patch
proc-pagemap-correctly-report-non-present-ptes-and-holes-between-vmas.patch
mm-remove-swap-token-code.patch
mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-do-not-stall-on-writeback-during-memory-compaction.patch
mm-vmscan-remove-reclaim_mode_t.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
kernel-cgroup-push-rcu-read-locking-from-css_is_ancestor-to-callsite.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy-fix.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-smaps-carefully-handle-migration-entries.patch
proc-smaps-show-amount-of-nonlinear-ptes-in-vma.patch
proc-smaps-show-amount-of-hwpoison-pages.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

