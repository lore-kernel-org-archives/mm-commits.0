From: akpm@linux-foundation.org
Subject: + proc-smaps-show-amount-of-hwpoison-pages.patch added to -mm tree
Date: Mon, 30 Apr 2012 13:56:51 -0700
Message-ID: <20120430205651.53375A0A1C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:41989 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917Ab2D3U4x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Apr 2012 16:56:53 -0400
Received: by mail-we0-f202.google.com with SMTP id x9so168094wej.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Apr 2012 13:56:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, adobriyan@gmail.com, andi@firstfloor.org, xemul@parallels.com


The patch titled
     Subject: proc/smaps: show amount of hwpoison pages
has been added to the -mm tree.  Its filename is
     proc-smaps-show-amount-of-hwpoison-pages.patch

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
Subject: proc/smaps: show amount of hwpoison pages

Add the line "HWPoinson: <size> kB" into /proc/pid/smaps if
CONFIG_MEMORY_FAILURE=y and some HWPoison pages were found.  This may be
useful for searching applications which use a broken memory.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/proc/task_mmu.c~proc-smaps-show-amount-of-hwpoison-pages fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-smaps-show-amount-of-hwpoison-pages
+++ a/fs/proc/task_mmu.c
@@ -394,6 +394,7 @@ struct mem_size_stats {
 	unsigned long anonymous_thp;
 	unsigned long swap;
 	unsigned long nonlinear;
+	unsigned long hwpoison;
 	u64 pss;
 };
 
@@ -416,6 +417,8 @@ static void smaps_pte_entry(pte_t ptent,
 			mss->swap += ptent_size;
 		else if (is_migration_entry(swpent))
 			page = migration_entry_to_page(swpent);
+		else if (is_hwpoison_entry(swpent))
+			mss->hwpoison += ptent_size;
 	} else if (pte_file(ptent)) {
 		if (pte_to_pgoff(ptent) != pgoff)
 			mss->nonlinear += ptent_size;
@@ -430,6 +433,9 @@ static void smaps_pte_entry(pte_t ptent,
 	if (page->index != pgoff)
 		mss->nonlinear += ptent_size;
 
+	if (PageHWPoison(page))
+		mss->hwpoison += ptent_size;
+
 	mss->resident += ptent_size;
 	/* Accumulate the size in pages that have been accessed. */
 	if (pte_young(ptent) || PageReferenced(page))
@@ -535,6 +541,10 @@ static int show_smap(struct seq_file *m,
 		seq_printf(m, "Nonlinear:      %8lu kB\n",
 				mss.nonlinear >> 10);
 
+	if (IS_ENABLED(CONFIG_MEMORY_FAILURE) && mss.hwpoison)
+		seq_printf(m, "HWPoison:       %8lu kB\n",
+				mss.hwpoison >> 10);
+
 	if (m->count < m->size)  /* vma is copied successfully */
 		m->version = (vma != get_gate_vma(task->mm))
 			? vma->vm_start : 0;
_
Subject: Subject: proc/smaps: show amount of hwpoison pages

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

