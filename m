From: akpm@linux-foundation.org
Subject: + signal-zap_pid_ns_processes-s-send_sig_noinfo-send_sig_forced.patch added to -mm tree
Date: Mon, 13 Feb 2012 16:46:23 -0800
Message-ID: <20120214004623.E0A81A00AA@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:45423 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2BNAqZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2012 19:46:25 -0500
Received: by mail-ww0-f74.google.com with SMTP id ds12so179742wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2012 16:46:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, anton.vorontsov@linaro.org, ebiederm@xmission.com, kosaki.motohiro@gmail.com, rientjes@google.com, tj@kernel.org


The patch titled
     Subject: signal: zap_pid_ns_processes: s/SEND_SIG_NOINFO/SEND_SIG_FORCED/
has been added to the -mm tree.  Its filename is
     signal-zap_pid_ns_processes-s-send_sig_noinfo-send_sig_forced.patch

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
Subject: signal: zap_pid_ns_processes: s/SEND_SIG_NOINFO/SEND_SIG_FORCED/

Change zap_pid_ns_processes() to use SEND_SIG_FORCED, it looks more clear
compared to SEND_SIG_NOINFO which relies on from_ancestor_ns logic
send_signal().

It is also more efficient if we need to kill a lot of tasks because it
doesn't alloc sigqueue.

While at it, add the __fatal_signal_pending(task) check as a minor
optimization.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN kernel/pid_namespace.c~signal-zap_pid_ns_processes-s-send_sig_noinfo-send_sig_forced kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~signal-zap_pid_ns_processes-s-send_sig_noinfo-send_sig_forced
+++ a/kernel/pid_namespace.c
@@ -168,13 +168,9 @@ void zap_pid_ns_processes(struct pid_nam
 	while (nr > 0) {
 		rcu_read_lock();
 
-		/*
-		 * Any nested-container's init processes won't ignore the
-		 * SEND_SIG_NOINFO signal, see send_signal()->si_fromuser().
-		 */
 		task = pid_task(find_vpid(nr), PIDTYPE_PID);
-		if (task)
-			send_sig_info(SIGKILL, SEND_SIG_NOINFO, task);
+		if (task && !__fatal_signal_pending(task))
+			send_sig_info(SIGKILL, SEND_SIG_FORCED, task);
 
 		rcu_read_unlock();
 
_
Subject: Subject: signal: zap_pid_ns_processes: s/SEND_SIG_NOINFO/SEND_SIG_FORCED/

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
signal-give-send_sig_forced-more-power-to-beat-signal_unkillable.patch
signal-cosmetic-s-from_ancestor_ns-force-in-prepare_signal-paths.patch
signal-oom_kill_task-use-send_sig_forced-instead-of-force_sig.patch
signal-zap_pid_ns_processes-s-send_sig_noinfo-send_sig_forced.patch
usermodehelper-use-umh_wait_proc-consistently.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch

