From: akpm@linux-foundation.org
Subject: + signal-oom_kill_task-use-send_sig_forced-instead-of-force_sig.patch added to -mm tree
Date: Mon, 13 Feb 2012 16:46:21 -0800
Message-ID: <20120214004622.0966DA00AA@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:41934 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab2BNAqX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2012 19:46:23 -0500
Received: by yhgm50 with SMTP id m50so655974yhg.1
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2012 16:46:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, anton.vorontsov@linaro.org, ebiederm@xmission.com, kosaki.motohiro@gmail.com, rientjes@google.com, tj@kernel.org


The patch titled
     Subject: signal: oom_kill_task: use SEND_SIG_FORCED instead of force_sig()
has been added to the -mm tree.  Its filename is
     signal-oom_kill_task-use-send_sig_forced-instead-of-force_sig.patch

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
Subject: signal: oom_kill_task: use SEND_SIG_FORCED instead of force_sig()

Change oom_kill_task() to use do_send_sig_info(SEND_SIG_FORCED) instead of
force_sig(SIGKILL).  With the recent changes we do not need force_ to kill
the CLONE_NEWPID tasks.

And this is more correct.  force_sig() can race with the exiting thread
even if oom_kill_task() checks p->mm != NULL, while do_send_sig_info(group
=> true) kille the whole process.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~signal-oom_kill_task-use-send_sig_forced-instead-of-force_sig mm/oom_kill.c
--- a/mm/oom_kill.c~signal-oom_kill_task-use-send_sig_forced-instead-of-force_sig
+++ a/mm/oom_kill.c
@@ -517,11 +517,11 @@ static void oom_kill_process(struct task
 			pr_err("Kill process %d (%s) sharing same memory\n",
 				task_pid_nr(p), p->comm);
 			task_unlock(p);
-			force_sig(SIGKILL, p);
+			do_send_sig_info(SIGKILL, SEND_SIG_FORCED, p, true);
 		}
 
 	set_tsk_thread_flag(victim, TIF_MEMDIE);
-	force_sig(SIGKILL, victim);
+	do_send_sig_info(SIGKILL, SEND_SIG_FORCED, victim, true);
 }
 #undef K
 
_
Subject: Subject: signal: oom_kill_task: use SEND_SIG_FORCED instead of force_sig()

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

