From: akpm@linux-foundation.org
Subject: + coredump-sanitize-the-setting-of-signal-group_exit_code.patch added to -mm tree
Date: Wed, 20 Feb 2013 15:13:25 -0800
Message-ID: <20130220231325.A19935A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:56909 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab3BTXN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Feb 2013 18:13:27 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so849644yhz.3
        for <mm-commits@vger.kernel.org>; Wed, 20 Feb 2013 15:13:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, mingo@redhat.com, msb@chromium.org, nhorman@redhat.com, rjw@sisk.pl, roland@hack.frob.com, tj@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: coredump: sanitize the setting of signal->group_exit_code
has been added to the -mm tree.  Its filename is
     coredump-sanitize-the-setting-of-signal-group_exit_code.patch

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
Subject: coredump: sanitize the setting of signal->group_exit_code

Now that the coredumping process can be SIGKILL'ed, the setting of
->group_exit_code in do_coredump() can race with complete_signal() and
SIGKILL or 0x80 can be "lost", or wait(status) can report status ==
SIGKILL | 0x80.

But the main problem is that it is not clear to me what should we do if
binfmt->core_dump() succeeds but SIGKILL was sent, that is why this patch
comes as a separate change.

This patch adds 0x80 if ->core_dump() succeeds and the process was not
killed.  But perhaps we can (should?) re-set ->group_exit_code changed by
SIGKILL back to "siginfo->si_signo |= 0x80" in case when core_dumped == T.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Tested-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Neil Horman <nhorman@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN fs/coredump.c~coredump-sanitize-the-setting-of-signal-group_exit_code fs/coredump.c
--- a/fs/coredump.c~coredump-sanitize-the-setting-of-signal-group_exit_code
+++ a/fs/coredump.c
@@ -390,12 +390,14 @@ static int coredump_wait(int exit_code, 
 	return core_waiters;
 }
 
-static void coredump_finish(struct mm_struct *mm)
+static void coredump_finish(struct mm_struct *mm, bool core_dumped)
 {
 	struct core_thread *curr, *next;
 	struct task_struct *task;
 
 	spin_lock_irq(&current->sighand->siglock);
+	if (core_dumped && !__fatal_signal_pending(current))
+		current->signal->group_exit_code |= 0x80;
 	current->signal->group_exit_task = NULL;
 	current->signal->flags = SIGNAL_GROUP_EXIT;
 	spin_unlock_irq(&current->sighand->siglock);
@@ -480,6 +482,7 @@ void do_coredump(siginfo_t *siginfo)
 	int ispipe;
 	struct files_struct *displaced;
 	bool need_nonrelative = false;
+	bool core_dumped = false;
 	static atomic_t core_dump_count = ATOMIC_INIT(0);
 	struct coredump_params cprm = {
 		.siginfo = siginfo,
@@ -632,9 +635,8 @@ void do_coredump(siginfo_t *siginfo)
 		goto close_fail;
 	if (displaced)
 		put_files_struct(displaced);
-	retval = binfmt->core_dump(&cprm);
-	if (retval)
-		current->signal->group_exit_code |= 0x80;
+
+	core_dumped = binfmt->core_dump(&cprm);
 
 	if (ispipe && core_pipe_limit)
 		wait_for_dump_helpers(cprm.file);
@@ -647,7 +649,7 @@ fail_dropcount:
 fail_unlock:
 	kfree(cn.corename);
 fail_corename:
-	coredump_finish(mm);
+	coredump_finish(mm, core_dumped);
 	revert_creds(old_cred);
 fail_creds:
 	put_cred(cred);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
signal-allow-to-send-any-siginfo-to-itself.patch
kernel-signalc-fix-suboptimal-printk-usage.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
vfork-dont-freezer_count-for-in-kernel-users-of-clone_vfork.patch
lockdep-check-that-no-locks-held-at-freeze-time.patch
lockdep-check-that-no-locks-held-at-freeze-time-fix.patch
coredump-cleanup-the-waiting-for-coredump_finish-code.patch
coredump-use-a-freezable_schedule-for-the-coredump_finish-wait.patch
coredump-abort-core-dump-piping-only-due-to-a-fatal-signal.patch

