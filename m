From: akpm@linux-foundation.org
Subject: + exit-fix-oops-in-sync_mm_rss.patch added to -mm tree
Date: Tue, 30 Mar 2010 17:42:26 -0400
Message-ID: <201003310043.o2V0hZHA016503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755093Ab0CaAoZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Mar 2010 20:44:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, aarcange@redhat.com, minchan.kim@gmail.com, mst@redhat.com, riel@redhat.com, tlb@rapanden.dk


The patch titled
     mm: avoid null-pointer deref in sync_mm_rss()
has been added to the -mm tree.  Its filename is
     exit-fix-oops-in-sync_mm_rss.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: avoid null-pointer deref in sync_mm_rss()
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

- We weren't zeroing p->rss_stat[] at fork()

- Consequently sync_mm_rss() was dereferencing tsk->mm for kernel
  threads and was oopsing.

- Make __sync_task_rss_stat() static, too.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=15648

Reported-by: Troels Liebe Bentsen <tlb@rapanden.dk>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
"Michael S. Tsirkin" <mst@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>                            
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    3 ++-
 kernel/fork.c |    3 +++
 mm/memory.c   |    2 +-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff -puN kernel/exit.c~exit-fix-oops-in-sync_mm_rss kernel/exit.c
--- a/kernel/exit.c~exit-fix-oops-in-sync_mm_rss
+++ a/kernel/exit.c
@@ -953,7 +953,8 @@ NORET_TYPE void do_exit(long code)
 
 	acct_update_integrals(tsk);
 	/* sync mm's RSS info before statistics gathering */
-	sync_mm_rss(tsk, tsk->mm);
+	if (tsk->mm)
+		sync_mm_rss(tsk, tsk->mm);
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
 		hrtimer_cancel(&tsk->signal->real_timer);
diff -puN kernel/fork.c~exit-fix-oops-in-sync_mm_rss kernel/fork.c
--- a/kernel/fork.c~exit-fix-oops-in-sync_mm_rss
+++ a/kernel/fork.c
@@ -1052,6 +1052,9 @@ static struct task_struct *copy_process(
 	p->prev_utime = cputime_zero;
 	p->prev_stime = cputime_zero;
 #endif
+#if defined(SPLIT_RSS_COUNTING)
+	memset(&p->rss_stat, 0, sizeof(p->rss_stat));
+#endif
 
 	p->default_timer_slack_ns = current->timer_slack_ns;
 
diff -puN mm/memory.c~exit-fix-oops-in-sync_mm_rss mm/memory.c
--- a/mm/memory.c~exit-fix-oops-in-sync_mm_rss
+++ a/mm/memory.c
@@ -125,7 +125,7 @@ core_initcall(init_zero_pfn);
 
 #if defined(SPLIT_RSS_COUNTING)
 
-void __sync_task_rss_stat(struct task_struct *task, struct mm_struct *mm)
+static void __sync_task_rss_stat(struct task_struct *task, struct mm_struct *mm)
 {
 	int i;
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

linux-next.patch
exit-fix-oops-in-sync_mm_rss.patch
pagemap-fix-pfn-calculation-for-hugepage-v3.patch
memcg-fix-race-in-file_mapped-accounting.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm-remove-return-value-of-putback_lru_pages.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-badness-heuristic-rewrite.patch
oom-deprecate-oom_adj-tunable.patch
oom-replace-sysctls-with-quick-mode.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-remove-unnecessary-code-and-cleanup.patch
oom-default-to-killing-current-for-pagefault-ooms.patch
oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch
memcg-oom-wakeup-filter.patch
memcg-oom-wakeup-filter-update.patch
memcg-oom-notifier.patch
memcg-oom-notifier-update.patch
memcg-oom-kill-disable-and-oom-status.patch
memcg-oom-kill-disable-and-oom-status-update.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch

