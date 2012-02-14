From: akpm@linux-foundation.org
Subject: + signal-cosmetic-s-from_ancestor_ns-force-in-prepare_signal-paths.patch added to -mm tree
Date: Mon, 13 Feb 2012 16:46:19 -0800
Message-ID: <20120214004619.F339EA00AA@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:32790 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab2BNAqW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2012 19:46:22 -0500
Received: by eaaf13 with SMTP id f13so167364eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2012 16:46:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, anton.vorontsov@linaro.org, ebiederm@xmission.com, kosaki.motohiro@gmail.com, rientjes@google.com, tj@kernel.org


The patch titled
     Subject: signal: cosmetic, s/from_ancestor_ns/force/ in prepare_signal() paths
has been added to the -mm tree.  Its filename is
     signal-cosmetic-s-from_ancestor_ns-force-in-prepare_signal-paths.patch

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
Subject: signal: cosmetic, s/from_ancestor_ns/force/ in prepare_signal() paths

Cosmetic, rename the from_ancestor_ns argument in prepare_signal() paths. 
After the previous change it doesn't match the reality.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN kernel/signal.c~signal-cosmetic-s-from_ancestor_ns-force-in-prepare_signal-paths kernel/signal.c
--- a/kernel/signal.c~signal-cosmetic-s-from_ancestor_ns-force-in-prepare_signal-paths
+++ a/kernel/signal.c
@@ -58,21 +58,20 @@ static int sig_handler_ignored(void __us
 		(handler == SIG_DFL && sig_kernel_ignore(sig));
 }
 
-static int sig_task_ignored(struct task_struct *t, int sig,
-		int from_ancestor_ns)
+static int sig_task_ignored(struct task_struct *t, int sig, bool force)
 {
 	void __user *handler;
 
 	handler = sig_handler(t, sig);
 
 	if (unlikely(t->signal->flags & SIGNAL_UNKILLABLE) &&
-			handler == SIG_DFL && !from_ancestor_ns)
+			handler == SIG_DFL && !force)
 		return 1;
 
 	return sig_handler_ignored(handler, sig);
 }
 
-static int sig_ignored(struct task_struct *t, int sig, int from_ancestor_ns)
+static int sig_ignored(struct task_struct *t, int sig, bool force)
 {
 	/*
 	 * Blocked signals are never ignored, since the
@@ -82,7 +81,7 @@ static int sig_ignored(struct task_struc
 	if (sigismember(&t->blocked, sig) || sigismember(&t->real_blocked, sig))
 		return 0;
 
-	if (!sig_task_ignored(t, sig, from_ancestor_ns))
+	if (!sig_task_ignored(t, sig, force))
 		return 0;
 
 	/*
@@ -855,7 +854,7 @@ static void ptrace_trap_notify(struct ta
  * Returns true if the signal should be actually delivered, otherwise
  * it should be dropped.
  */
-static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
+static int prepare_signal(int sig, struct task_struct *p, bool force)
 {
 	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
@@ -915,7 +914,7 @@ static int prepare_signal(int sig, struc
 		}
 	}
 
-	return !sig_ignored(p, sig, from_ancestor_ns);
+	return !sig_ignored(p, sig, force);
 }
 
 /*
@@ -1602,7 +1601,7 @@ int send_sigqueue(struct sigqueue *q, st
 
 	ret = 1; /* the signal is ignored */
 	result = TRACE_SIGNAL_IGNORED;
-	if (!prepare_signal(sig, t, 0))
+	if (!prepare_signal(sig, t, false))
 		goto out;
 
 	ret = 0;
_
Subject: Subject: signal: cosmetic, s/from_ancestor_ns/force/ in prepare_signal() paths

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

