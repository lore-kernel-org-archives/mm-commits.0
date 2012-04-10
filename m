From: akpm@linux-foundation.org
Subject: + mm-correctly-synchronize-rss-counters-at-exit-exec.patch added to -mm tree
Date: Tue, 10 Apr 2012 11:43:43 -0700
Message-ID: <20120410184343.77060A0358@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:64008 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758560Ab2DJSnq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Apr 2012 14:43:46 -0400
Received: by faaa19 with SMTP id a19so11821faa.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Apr 2012 11:43:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, markus@trippelsdorf.de, oleg@redhat.com


The patch titled
     From: Konstantin Khlebnikov <khlebnikov@openvz.org>
has been added to the -mm tree.  Its filename is
     mm-correctly-synchronize-rss-counters-at-exit-exec.patch

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
Subject: mm: correctly synchronize rss-counters at exit/exec

mm->rss_stat counters have per-task delta: task->rss_stat.  Before
changing task->mm pointer the kernel must flush this delta with
sync_mm_rss().

do_exit() already calls sync_mm_rss() to flush the rss-counters before
committing the rss statistics into task->signal->maxrss, taskstats, audit
and other stuff.  Unfortunately the kernel does this before calling
mm_release(), which can call put_user() for processing
task->clear_child_tid.  So at this point we can trigger page-faults and
task->rss_stat becomes non-zero again.  As a result mm->rss_stat becomes
inconsistent and check_mm() will print something like this:

| BUG: Bad rss-counter state mm:ffff88020813c380 idx:1 val:-1
| BUG: Bad rss-counter state mm:ffff88020813c380 idx:2 val:1

This patch moves sync_mm_rss() into mm_release(), and moves mm_release()
out of do_exit() and calls it earlier.  After mm_release() there should be
no pagefaults.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c     |    1 -
 kernel/exit.c |    9 +++++----
 kernel/fork.c |    8 ++++++++
 3 files changed, 13 insertions(+), 5 deletions(-)

diff -puN fs/exec.c~mm-correctly-synchronize-rss-counters-at-exit-exec fs/exec.c
--- a/fs/exec.c~mm-correctly-synchronize-rss-counters-at-exit-exec
+++ a/fs/exec.c
@@ -823,7 +823,6 @@ static int exec_mmap(struct mm_struct *m
 	/* Notify parent that we're no longer interested in the old VM */
 	tsk = current;
 	old_mm = current->mm;
-	sync_mm_rss(old_mm);
 	mm_release(tsk, old_mm);
 
 	if (old_mm) {
diff -puN kernel/exit.c~mm-correctly-synchronize-rss-counters-at-exit-exec kernel/exit.c
--- a/kernel/exit.c~mm-correctly-synchronize-rss-counters-at-exit-exec
+++ a/kernel/exit.c
@@ -423,6 +423,7 @@ void daemonize(const char *name, ...)
 	 * user space pages.  We don't need them, and if we didn't close them
 	 * they would be locked into memory.
 	 */
+	mm_release(current, current->mm);
 	exit_mm(current);
 	/*
 	 * We don't want to get frozen, in case system-wide hibernation
@@ -640,7 +641,6 @@ static void exit_mm(struct task_struct *
 	struct mm_struct *mm = tsk->mm;
 	struct core_state *core_state;
 
-	mm_release(tsk, mm);
 	if (!mm)
 		return;
 	/*
@@ -959,9 +959,10 @@ void do_exit(long code)
 				preempt_count());
 
 	acct_update_integrals(tsk);
-	/* sync mm's RSS info before statistics gathering */
-	if (tsk->mm)
-		sync_mm_rss(tsk->mm);
+
+	/* Release mm and sync mm's RSS info before statistics gathering */
+	mm_release(tsk, tsk->mm);
+
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
 		hrtimer_cancel(&tsk->signal->real_timer);
diff -puN kernel/fork.c~mm-correctly-synchronize-rss-counters-at-exit-exec kernel/fork.c
--- a/kernel/fork.c~mm-correctly-synchronize-rss-counters-at-exit-exec
+++ a/kernel/fork.c
@@ -780,6 +780,14 @@ void mm_release(struct task_struct *tsk,
 		}
 		tsk->clear_child_tid = NULL;
 	}
+
+	/*
+	 * Final rss-counter synchronization. After this point must be
+	 * no page-faults into this mm from current context, otherwise
+	 * mm->rss_stat will be inconsistent.
+	 */
+	if (mm)
+		sync_mm_rss(mm);
 }
 
 /*
_
Subject: From: Konstantin Khlebnikov <khlebnikov@openvz.org>

Patches currently in -mm which might be from khlebnikov@openvz.org are

linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
mm-correctly-synchronize-rss-counters-at-exit-exec-fix.patch
mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-remove-reclaim_mode_t.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch

