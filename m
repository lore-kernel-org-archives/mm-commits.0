From: akpm@linux-foundation.org
Subject: + mm-counters-fold-__sync_task_rss_stat-into-sync_mm_rss.patch added to -mm tree
Date: Wed, 07 Mar 2012 17:12:59 -0800
Message-ID: <20120308011259.C8B3DA00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:49767 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2CHBNA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Mar 2012 20:13:00 -0500
Received: by ggnd2 with SMTP id d2so884824ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Mar 2012 17:13:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     Subject: mm, counters: fold __sync_task_rss_stat() into sync_mm_rss()
has been added to the -mm tree.  Its filename is
     mm-counters-fold-__sync_task_rss_stat-into-sync_mm_rss.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, counters: fold __sync_task_rss_stat() into sync_mm_rss()

There's no difference between sync_mm_rss() and __sync_task_rss_stat(),
so fold the latter into the former.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN mm/memory.c~mm-counters-fold-__sync_task_rss_stat-into-sync_mm_rss mm/memory.c
--- a/mm/memory.c~mm-counters-fold-__sync_task_rss_stat-into-sync_mm_rss
+++ a/mm/memory.c
@@ -133,7 +133,7 @@ core_initcall(init_zero_pfn);
 
 #if defined(SPLIT_RSS_COUNTING)
 
-static void __sync_task_rss_stat(struct mm_struct *mm)
+void sync_mm_rss(struct mm_struct *mm)
 {
 	int i;
 
@@ -165,12 +165,7 @@ static void check_sync_rss_stat(struct t
 	if (unlikely(task != current))
 		return;
 	if (unlikely(task->rss_stat.events++ > TASK_RSS_EVENTS_THRESH))
-		__sync_task_rss_stat(task->mm);
-}
-
-void sync_mm_rss(struct mm_struct *mm)
-{
-	__sync_task_rss_stat(mm);
+		sync_mm_rss(task->mm);
 }
 #else /* SPLIT_RSS_COUNTING */
 
_
Subject: Subject: mm, counters: fold __sync_task_rss_stat() into sync_mm_rss()

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
slab-introduce-kmalloc_array.patch
mm-oom-avoid-looping-when-chosen-thread-detaches-its-mm.patch
mm-oom-fold-oom_kill_task-into-oom_kill_process.patch
mm-oom-do-not-emit-oom-killer-warning-if-chosen-thread-is-already-exiting.patch
mm-oom-introduce-independent-oom-killer-ratelimit-state.patch
mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode.patch
pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
thp-optimize-away-unnecessary-page-table-locking.patch
thp-optimize-away-unnecessary-page-table-locking-fix.patch
pagemap-export-kpf_thp.patch
pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch
pagemap-introduce-data-structure-for-pagemap-entry.patch
rmap-anon_vma_prepare-reduce-code-duplication-by-calling-anon_vma_chain_link.patch
rmap-remove-__anon_vma_link.patch
mm-oom-force-oom-kill-on-sysrqf.patch
mm-memcg-pass-charge-order-to-oom-killer.patch
cpuset-mm-reduce-large-amounts-of-memory-barrier-related-damage-v3.patch
mm-counters-remove-task-argument-to-sync_mm_rss-and-__sync_task_rss_stat.patch
mm-counters-fold-__sync_task_rss_stat-into-sync_mm_rss.patch
memcg-remove-unnecessary-thp-check-in-page-stat-accounting.patch
signal-give-send_sig_forced-more-power-to-beat-signal_unkillable.patch
signal-cosmetic-s-from_ancestor_ns-force-in-prepare_signal-paths.patch
signal-oom_kill_task-use-send_sig_forced-instead-of-force_sig.patch
signal-zap_pid_ns_processes-s-send_sig_noinfo-send_sig_forced.patch
usermodehelper-introduce-umh_completesub_info.patch
usermodehelper-implement-umh_killable.patch
usermodehelper-kill-umh_wait-renumber-umh_-constants.patch
usermodehelper-____call_usermodehelper-doesnt-need-do_exit.patch
kmod-introduce-call_modprobe-helper.patch
kmod-make-__request_module-killable.patch

