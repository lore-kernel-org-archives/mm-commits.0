From: akpm@linux-foundation.org
Subject: [merged] coredump-introduce-dump_interrupted.patch removed from -mm tree
Date: Tue, 07 May 2013 10:49:33 -0700
Message-ID: <20130507174933.89D5A31C324@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:37519 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759445Ab3EGRte (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:49:34 -0400
Received: by mail-qc0-f202.google.com with SMTP id d1so85382qcz.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:49:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, msb@chromium.org, nhorman@redhat.com, rjw@sisk.pl, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: introduce dump_interrupted()
has been removed from the -mm tree.  Its filename was
     coredump-introduce-dump_interrupted.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: coredump: introduce dump_interrupted()

By discussion with Mandeep.

Change dump_write(), dump_seek() and do_coredump() to check
signal_pending() and abort if it is true.  dump_seek() does this only
before f_op->llseek(), otherwise it relies on dump_write().

We need this change to ensure that the coredump won't delay suspend, and
to ensure it reacts to SIGKILL "quickly enough", a core dump can take a
lot of time.  In particular this can help oom-killer.

We add the new trivial helper, dump_interrupted() to add the comments and
to simplify the potential freezer changes.  Perhaps it will have more
callers.

Ideally it should do try_to_freeze() but then we need the unpleasant
changes in dump_write() and wait_for_dump_helpers().  It is not trivial to
change dump_write() to restart if f_op->write() fails because of
freezing().  We need to handle the short writes, we need to clear
TIF_SIGPENDING (and we can't rely on recalc_sigpending() unless we change
it to check PF_DUMPCORE).  And if the buggy f_op->write() sets
TIF_SIGPENDING we can not distinguish this case from the race with
freeze_task() + __thaw_task().

So we simply accept the fact that the freezer can truncate a core-dump but
at least you can reliably suspend.  Hopefully we can tolerate this
unlikely case and the necessary complications doesn't worth a trouble. 
But if we decide to make the coredumping freezable later we can do this on
top of this change.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Neil Horman <nhorman@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff -puN fs/coredump.c~coredump-introduce-dump_interrupted fs/coredump.c
--- a/fs/coredump.c~coredump-introduce-dump_interrupted
+++ a/fs/coredump.c
@@ -418,6 +418,17 @@ static void coredump_finish(struct mm_st
 	mm->core_state = NULL;
 }
 
+static bool dump_interrupted(void)
+{
+	/*
+	 * SIGKILL or freezing() interrupt the coredumping. Perhaps we
+	 * can do try_to_freeze() and check __fatal_signal_pending(),
+	 * but then we need to teach dump_write() to restart and clear
+	 * TIF_SIGPENDING.
+	 */
+	return signal_pending(current);
+}
+
 static void wait_for_dump_helpers(struct file *file)
 {
 	struct pipe_inode_info *pipe;
@@ -641,7 +652,7 @@ void do_coredump(siginfo_t *siginfo)
 		goto close_fail;
 	if (displaced)
 		put_files_struct(displaced);
-	core_dumped = binfmt->core_dump(&cprm);
+	core_dumped = !dump_interrupted() && binfmt->core_dump(&cprm);
 
 	if (ispipe && core_pipe_limit)
 		wait_for_dump_helpers(cprm.file);
@@ -669,7 +680,9 @@ fail:
  */
 int dump_write(struct file *file, const void *addr, int nr)
 {
-	return access_ok(VERIFY_READ, addr, nr) && file->f_op->write(file, addr, nr, &file->f_pos) == nr;
+	return !dump_interrupted() &&
+		access_ok(VERIFY_READ, addr, nr) &&
+		file->f_op->write(file, addr, nr, &file->f_pos) == nr;
 }
 EXPORT_SYMBOL(dump_write);
 
@@ -678,7 +691,8 @@ int dump_seek(struct file *file, loff_t
 	int ret = 1;
 
 	if (file->f_op->llseek && file->f_op->llseek != no_llseek) {
-		if (file->f_op->llseek(file, off, SEEK_CUR) < 0)
+		if (dump_interrupted() ||
+		    file->f_op->llseek(file, off, SEEK_CUR) < 0)
 			return 0;
 	} else {
 		char *buf = (char *)get_zeroed_page(GFP_KERNEL);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch

