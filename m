From: akpm@linux-foundation.org
Subject: + signal-give-send_sig_forced-more-power-to-beat-signal_unkillable.patch added to -mm tree
Date: Mon, 13 Feb 2012 16:46:16 -0800
Message-ID: <20120214004617.5C75EA00AA@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:45423 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab2BNAqU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2012 19:46:20 -0500
Received: by wgbds12 with SMTP id ds12so179742wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2012 16:46:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, anton.vorontsov@linaro.org, ebiederm@xmission.com, kosaki.motohiro@gmail.com, rientjes@google.com, tj@kernel.org


The patch titled
     Subject: signal: give SEND_SIG_FORCED more power to beat SIGNAL_UNKILLABLE
has been added to the -mm tree.  Its filename is
     signal-give-send_sig_forced-more-power-to-beat-signal_unkillable.patch

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
Subject: signal: give SEND_SIG_FORCED more power to beat SIGNAL_UNKILLABLE

force_sig_info() and friends have the special semantics for synchronous
signals, this interface should not be used if the target is not current. 
And it needs the fixes, in particular the clearing of SIGNAL_UNKILLABLE is
not exactly right.

However there are callers which have to use force_ exactly because it
clears SIGNAL_UNKILLABLE and thus it can kill the CLONE_NEWPID tasks,
although this is almost always is wrong by various reasons.

With this patch SEND_SIG_FORCED ignores SIGNAL_UNKILLABLE, like we do if
the signal comes from the ancestor namespace.

This makes the naming in prepare_signal() paths insane, fixed by the next
cleanup.

Note: this only affects SIGKILL/SIGSTOP, but this is enough for
force_sig() abusers.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/signal.c~signal-give-send_sig_forced-more-power-to-beat-signal_unkillable kernel/signal.c
--- a/kernel/signal.c~signal-give-send_sig_forced-more-power-to-beat-signal_unkillable
+++ a/kernel/signal.c
@@ -1059,7 +1059,8 @@ static int __send_signal(int sig, struct
 	assert_spin_locked(&t->sighand->siglock);
 
 	result = TRACE_SIGNAL_IGNORED;
-	if (!prepare_signal(sig, t, from_ancestor_ns))
+	if (!prepare_signal(sig, t,
+			from_ancestor_ns || (info == SEND_SIG_FORCED)))
 		goto ret;
 
 	pending = group ? &t->signal->shared_pending : &t->pending;
_
Subject: Subject: signal: give SEND_SIG_FORCED more power to beat SIGNAL_UNKILLABLE

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

