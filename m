From: akpm@linux-foundation.org
Subject: [failures] mm-correctly-synchronize-rss-counters-at-exit-exec.patch removed from -mm tree
Date: Fri, 08 Jun 2012 12:39:00 -0700
Message-ID: <20120608193901.B88ACA022F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:33187 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758102Ab2FHTjF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 15:39:05 -0400
Received: by lbbgp10 with SMTP id gp10so131660lbb.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 12:39:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, markus@trippelsdorf.de, oleg@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: correctly synchronize rss-counters at exit/exec
has been removed from the -mm tree.  Its filename was
     mm-correctly-synchronize-rss-counters-at-exit-exec.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

[akpm@linux-foundation.org: tweak comment]
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>		[3.4.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c     |    1 -
 kernel/exit.c |   13 ++++++++-----
 kernel/fork.c |    8 ++++++++
 3 files changed, 16 insertions(+), 6 deletions(-)

diff -puN fs/exec.c~mm-correctly-synchronize-rss-counters-at-exit-exec fs/exec.c
--- a/fs/exec.c~mm-correctly-synchronize-rss-counters-at-exit-exec
+++ a/fs/exec.c
@@ -819,7 +819,6 @@ static int exec_mmap(struct mm_struct *m
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
@@ -960,9 +960,13 @@ void do_exit(long code)
 				preempt_count());
 
 	acct_update_integrals(tsk);
-	/* sync mm's RSS info before statistics gathering */
-	if (tsk->mm)
-		sync_mm_rss(tsk->mm);
+
+	/* Set exit_code before complete_vfork_done() in mm_release() */
+	tsk->exit_code = code;
+
+	/* Release mm and sync mm's RSS info before statistics gathering */
+	mm_release(tsk, tsk->mm);
+
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
 		hrtimer_cancel(&tsk->signal->real_timer);
@@ -975,7 +979,6 @@ void do_exit(long code)
 		tty_audit_exit();
 	audit_free(tsk);
 
-	tsk->exit_code = code;
 	taskstats_exit(tsk, group_dead);
 
 	exit_mm(tsk);
diff -puN kernel/fork.c~mm-correctly-synchronize-rss-counters-at-exit-exec kernel/fork.c
--- a/kernel/fork.c~mm-correctly-synchronize-rss-counters-at-exit-exec
+++ a/kernel/fork.c
@@ -619,6 +619,14 @@ void mmput(struct mm_struct *mm)
 			module_put(mm->binfmt->module);
 		mmdrop(mm);
 	}
+
+	/*
+	 * Final rss-counter synchronization. After this point there must be
+	 * no pagefaults into this mm from the current context.  Otherwise
+	 * mm->rss_stat will be inconsistent.
+	 */
+	if (mm)
+		sync_mm_rss(mm);
 }
 EXPORT_SYMBOL_GPL(mmput);
 
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch

