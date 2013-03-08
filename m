From: akpm@linux-foundation.org
Subject: + coredump-introduce-dump_interrupted.patch added to -mm tree
Date: Fri, 08 Mar 2013 13:20:58 -0800
Message-ID: <20130308212058.D51EF31C1B7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:33346 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab3CHVVA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Mar 2013 16:21:00 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so149292vbi.3
        for <mm-commits@vger.kernel.org>; Fri, 08 Mar 2013 13:20:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, msb@chromium.org, nhorman@redhat.com, rjw@sisk.pl, tj@kernel.org


The patch titled
     Subject: coredump: introduce dump_interrupted()
has been added to the -mm tree.  Its filename is
     coredump-introduce-dump_interrupted.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: coredump: introduce dump_interrupted()

By discussion with Mandeep.

Change dump_write(), dump_seek() and do_coredump() to check
signal_pending() and abort if it is true.

We add the new trivial helper, dump_interrupted(), to document that this
probably needs more work and to simplify the potential freezer changes. 
Perhaps it will have more callers.

Ideally it should do try_to_freeze() but then we need the unpleasant
changes in dump_write() and wait_for_dump_helpers().  So far we simply
accept the fact that the freezer can truncate a core-dump but at least you
can reliably suspend.

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
@@ -636,7 +647,7 @@ void do_coredump(siginfo_t *siginfo)
 	if (displaced)
 		put_files_struct(displaced);
 
-	core_dumped = binfmt->core_dump(&cprm);
+	core_dumped = !dump_interrupted() && binfmt->core_dump(&cprm);
 
 	if (ispipe && core_pipe_limit)
 		wait_for_dump_helpers(cprm.file);
@@ -664,7 +675,9 @@ fail:
  */
 int dump_write(struct file *file, const void *addr, int nr)
 {
-	return access_ok(VERIFY_READ, addr, nr) && file->f_op->write(file, addr, nr, &file->f_pos) == nr;
+	return !dump_interrupted() &&
+		access_ok(VERIFY_READ, addr, nr) &&
+		file->f_op->write(file, addr, nr, &file->f_pos) == nr;
 }
 EXPORT_SYMBOL(dump_write);
 
@@ -673,7 +686,8 @@ int dump_seek(struct file *file, loff_t
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

thinkpad-acpi-kill-hotkey_thread_mutex.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
ptrace-add-ability-to-retrieve-signals-without-removing-from-a-queue-v4.patch
selftest-add-a-test-case-for-ptrace_peeksiginfo.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-introduce-dump_interrupted.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
coredump-change-wait_for_dump_helpers-to-use-wait_event_interruptible.patch

