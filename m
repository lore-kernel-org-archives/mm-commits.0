From: akpm@linux-foundation.org
Subject: + signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch added to -mm tree
Date: Mon, 10 Mar 2008 12:34:02 -0700
Message-ID: <200803101934.m2AJY2qa001745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751543AbYCJTfP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 15:35:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, oleg@tv-sign.ru, roland@redhat.com


The patch titled
     signals: fold complete_signal() into send_signal/do_send_sigqueue
has been added to the -mm tree.  Its filename is
     signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: fold complete_signal() into send_signal/do_send_sigqueue
From: Pavel Emelyanov <xemul@openvz.org>

Factor out complete_signal() callsites.  This change completely unifies the
helpers sending the specific/group signals.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   46 +++++++++++-----------------------------------
 1 file changed, 11 insertions(+), 35 deletions(-)

diff -puN kernel/signal.c~signals-fold-complete_signal-into-send_signal-do_send_sigqueue kernel/signal.c
--- a/kernel/signal.c~signals-fold-complete_signal-into-send_signal-do_send_sigqueue
+++ a/kernel/signal.c
@@ -826,7 +826,8 @@ static int send_signal(int sig, struct s
 
 out_set:
 	sigaddset(&pending->signal, sig);
-	return 1;
+	complete_signal(sig, t, group);
+	return 0;
 }
 
 int print_fatal_signals;
@@ -861,17 +862,16 @@ static int __init setup_print_fatal_sign
 
 __setup("print-fatal-signals=", setup_print_fatal_signals);
 
+int
+__group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
+{
+	return send_signal(sig, info, p, 1);
+}
+
 static int
 specific_send_sig_info(int sig, struct siginfo *info, struct task_struct *t)
 {
-	int ret;
-
-	ret = send_signal(sig, info, t, 0);
-	if (ret <= 0)
-		return ret;
-
-	complete_signal(sig, t, 0);
-	return 0;
+	return send_signal(sig, info, t, 0);
 }
 
 /*
@@ -914,24 +914,6 @@ force_sig_specific(int sig, struct task_
 	force_sig_info(sig, SEND_SIG_FORCED, t);
 }
 
-int
-__group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
-{
-	int ret;
-
-	/*
-	 * Put this signal on the shared-pending queue, or fail with EAGAIN.
-	 * We always use the shared queue for process-wide signals,
-	 * to avoid several races.
-	 */
-	ret = send_signal(sig, info, p, 1);
-	if (ret <= 0)
-		return ret;
-
-	complete_signal(sig, p, 1);
-	return 0;
-}
-
 /*
  * Nuke all other threads in the group.
  */
@@ -1263,6 +1245,7 @@ static int do_send_sigqueue(int sig, str
 {
 	struct sigpending *pending;
 
+	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
 	handle_stop_signal(sig, t);
 
 	if (unlikely(!list_empty(&q->list))) {
@@ -1283,6 +1266,7 @@ static int do_send_sigqueue(int sig, str
 	pending = group ? &t->signal->shared_pending : &t->pending;
 	list_add_tail(&q->list, &pending->list);
 	sigaddset(&pending->signal, sig);
+	complete_signal(sig, t, group);
 
 	return 0;
 }
@@ -1292,8 +1276,6 @@ int send_sigqueue(int sig, struct sigque
 	unsigned long flags;
 	int ret = -1;
 
-	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
-
 	/*
 	 * The rcu based delayed sighand destroy makes it possible to
 	 * run this without tasklist lock held. The task struct itself
@@ -1307,8 +1289,6 @@ int send_sigqueue(int sig, struct sigque
 
 	ret = do_send_sigqueue(sig, q, p, 0);
 
-	complete_signal(sig, p, 0);
-
 	unlock_task_sighand(p, &flags);
 out_err:
 	return ret;
@@ -1320,15 +1300,11 @@ send_group_sigqueue(int sig, struct sigq
 	unsigned long flags;
 	int ret;
 
-	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
-
 	/* Since it_lock is held, p->sighand cannot be NULL. */
 	spin_lock_irqsave(&p->sighand->siglock, flags);
 
 	ret = do_send_sigqueue(sig, q, p, 1);
 
-	complete_signal(sig, p, 1);
-
 	spin_unlock_irqrestore(&p->sighand->siglock, flags);
 
 	return ret;
_

Patches currently in -mm which might be from xemul@openvz.org are

git-kgdb-light.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-getpid-and-set_tid_address-fast-system-calls-for-pid-namespaces.patch
git-udf.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time.patch
memory-controller-make-memory-resource-control-aware-of-boot-options.patch
devscontrol-avoid-magic-constants-in-drivers-base-mapc.patch
devscontrol-clean-up-get_gendisk-a-bit.patch
devscontrol-add-a-mode-on-the-struct-probe.patch
devscontrol-make-kobj_lookup-return-the-mappings-permissions.patch
devscontrol-make-use-of-permissions-returned-by-kobj_lookup.patch
devscontrol-extend-the-drivers-base-mapc-functionality.patch
devscontrol-provide-functions-to-manipulate-char-device-mappings.patch
devscontrol-provide-functions-to-manipulate-block-device-mappings.patch
devscontrol-devices-accessibility-control-group-itself.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-use-__group_complete_signal-for-the-specific-signals-too.patch
signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch
signals-unify-send_sigqueue-send_group_sigqueue-completely.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
deprecate-find_task_by_pid-warning-fix.patch
pidns-make-pid-level-and-pid_ns-level-unsigned.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

