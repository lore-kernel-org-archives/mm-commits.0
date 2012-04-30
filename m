From: akpm@linux-foundation.org
Subject: + proc-smaps-carefully-handle-migration-entries.patch added to -mm tree
Date: Mon, 30 Apr 2012 13:56:44 -0700
Message-ID: <20120430205645.75705A0A1C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:41989 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920Ab2D3U4s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Apr 2012 16:56:48 -0400
Received: by wejx9 with SMTP id x9so168094wej.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Apr 2012 13:56:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, adobriyan@gmail.com, andi@firstfloor.org, xemul@parallels.com


The patch titled
     Subject: proc/smaps: carefully handle migration entries
has been added to the -mm tree.  Its filename is
     proc-smaps-carefully-handle-migration-entries.patch

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
Subject: proc/smaps: carefully handle migration entries

Currently smaps reports migration entries as "swap", as result "swap" can
appears in shared mapping.

This patch converts migration entries into pages and handles them as usual.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN fs/proc/task_mmu.c~proc-smaps-carefully-handle-migration-entries fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-smaps-carefully-handle-migration-entries
+++ a/fs/proc/task_mmu.c
@@ -402,18 +402,20 @@ static void smaps_pte_entry(pte_t ptent,
 {
 	struct mem_size_stats *mss = walk->private;
 	struct vm_area_struct *vma = mss->vma;
-	struct page *page;
+	struct page *page = NULL;
 	int mapcount;
 
-	if (is_swap_pte(ptent)) {
-		mss->swap += ptent_size;
-		return;
-	}
+	if (pte_present(ptent)) {
+		page = vm_normal_page(vma, addr, ptent);
+	} else if (is_swap_pte(ptent)) {
+		swp_entry_t swpent = pte_to_swp_entry(ptent);
 
-	if (!pte_present(ptent))
-		return;
+		if (!non_swap_entry(swpent))
+			mss->swap += ptent_size;
+		else if (is_migration_entry(swpent))
+			page = migration_entry_to_page(swpent);
+	}
 
-	page = vm_normal_page(vma, addr, ptent);
 	if (!page)
 		return;
 
_
Subject: Subject: proc/smaps: carefully handle migration entries

Patches currently in -mm which might be from khlebnikov@openvz.org are

linux-next.patch
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
proc-smaps-carefully-handle-migration-entries.patch
proc-smaps-show-amount-of-nonlinear-ptes-in-vma.patch
proc-smaps-show-amount-of-hwpoison-pages.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

