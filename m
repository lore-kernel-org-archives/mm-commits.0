From: akpm@osdl.org
Subject: + pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch added to -mm tree
Date: Wed, 13 Dec 2006 14:09:32 -0800
Message-ID: <200612132209.kBDM9W01021919@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48410 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbWLMWJu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:09:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, alan@lxorguk.ukuu.org.uk, oleg@tv-sign.ru


The patch titled
     pid: use struct pid for talking about process groups in exitc
has been added to the -mm tree.  Its filename is
     pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid: use struct pid for talking about process groups in exitc
From: Eric W. Biederman <ebiederm@xmission.com>

Modify has_stopped_jobs and will_become_orphan_pgrp to use struct pid based
process groups.  This reduces the number of hash tables looks ups and paves
the way for multiple pid spaces.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/exit.c |   42 ++++++++++++++++++++++--------------------
 1 files changed, 22 insertions(+), 20 deletions(-)

diff -puN kernel/exit.c~pid-use-struct-pid-for-talking-about-process-groups-in-exitc kernel/exit.c
--- a/kernel/exit.c~pid-use-struct-pid-for-talking-about-process-groups-in-exitc
+++ a/kernel/exit.c
@@ -210,22 +210,22 @@ struct pid *session_of_pgrp(struct pid *
  *
  * "I ask you, have you ever known what it is to be an orphan?"
  */
-static int will_become_orphaned_pgrp(int pgrp, struct task_struct *ignored_task)
+static int will_become_orphaned_pgrp(struct pid *pgrp, struct task_struct *ignored_task)
 {
 	struct task_struct *p;
 	int ret = 1;
 
-	do_each_task_pid(pgrp, PIDTYPE_PGID, p) {
+	do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
 		if (p == ignored_task
 				|| p->exit_state
 				|| is_init(p->real_parent))
 			continue;
-		if (process_group(p->real_parent) != pgrp &&
-		    process_session(p->real_parent) == process_session(p)) {
+		if (task_pgrp(p->real_parent) != pgrp &&
+		    task_session(p->real_parent) == task_session(p)) {
 			ret = 0;
 			break;
 		}
-	} while_each_task_pid(pgrp, PIDTYPE_PGID, p);
+	} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
 	return ret;	/* (sighing) "Often!" */
 }
 
@@ -234,23 +234,23 @@ int is_orphaned_pgrp(int pgrp)
 	int retval;
 
 	read_lock(&tasklist_lock);
-	retval = will_become_orphaned_pgrp(pgrp, NULL);
+	retval = will_become_orphaned_pgrp(find_pid(pgrp), NULL);
 	read_unlock(&tasklist_lock);
 
 	return retval;
 }
 
-static int has_stopped_jobs(int pgrp)
+static int has_stopped_jobs(struct pid *pgrp)
 {
 	int retval = 0;
 	struct task_struct *p;
 
-	do_each_task_pid(pgrp, PIDTYPE_PGID, p) {
+	do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
 		if (p->state != TASK_STOPPED)
 			continue;
 		retval = 1;
 		break;
-	} while_each_task_pid(pgrp, PIDTYPE_PGID, p);
+	} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
 	return retval;
 }
 
@@ -640,14 +640,14 @@ reparent_thread(struct task_struct *p, s
 	 * than we are, and it was the only connection
 	 * outside, so the child pgrp is now orphaned.
 	 */
-	if ((process_group(p) != process_group(father)) &&
-	    (process_session(p) == process_session(father))) {
-		int pgrp = process_group(p);
+	if ((task_pgrp(p) != task_pgrp(father)) &&
+	    (task_session(p) == task_session(father))) {
+		struct pid *pgrp = task_pgrp(p);
 
 		if (will_become_orphaned_pgrp(pgrp, NULL) &&
 		    has_stopped_jobs(pgrp)) {
-			__kill_pg_info(SIGHUP, SEND_SIG_PRIV, pgrp);
-			__kill_pg_info(SIGCONT, SEND_SIG_PRIV, pgrp);
+			__kill_pgrp_info(SIGHUP, SEND_SIG_PRIV, pgrp);
+			__kill_pgrp_info(SIGCONT, SEND_SIG_PRIV, pgrp);
 		}
 	}
 }
@@ -727,6 +727,7 @@ static void exit_notify(struct task_stru
 	int state;
 	struct task_struct *t;
 	struct list_head ptrace_dead, *_p, *_n;
+	struct pid *pgrp;
 
 	if (signal_pending(tsk) && !(tsk->signal->flags & SIGNAL_GROUP_EXIT)
 	    && !thread_group_empty(tsk)) {
@@ -779,12 +780,13 @@ static void exit_notify(struct task_stru
 	 
 	t = tsk->real_parent;
 	
-	if ((process_group(t) != process_group(tsk)) &&
-	    (process_session(t) == process_session(tsk)) &&
-	    will_become_orphaned_pgrp(process_group(tsk), tsk) &&
-	    has_stopped_jobs(process_group(tsk))) {
-		__kill_pg_info(SIGHUP, SEND_SIG_PRIV, process_group(tsk));
-		__kill_pg_info(SIGCONT, SEND_SIG_PRIV, process_group(tsk));
+	pgrp = task_pgrp(tsk);
+	if ((task_pgrp(t) != pgrp) &&
+	    (task_session(t) != task_session(tsk)) &&
+	    will_become_orphaned_pgrp(pgrp, tsk) &&
+	    has_stopped_jobs(pgrp)) {
+		__kill_pgrp_info(SIGHUP, SEND_SIG_PRIV, pgrp);
+		__kill_pgrp_info(SIGCONT, SEND_SIG_PRIV, pgrp);
 	}
 
 	/* Let father know we died 
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
revert-identifier-to-nsproxy.patch
vt-fix-comments-to-not-refer-to-kill_proc.patch
n_r3964-use-struct-pid-to-track-user-space-clients.patch
smbfs-make-conn_pid-a-struct-pid.patch
ncpfs-use-struct-pid-to-track-the-userspace-watchdog-process.patch
ncpfs-ensure-we-free-wdog_pid-on-parse_option-or-fill_inode-failure.patch
usbatm-update-to-use-the-kthread-api.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
vt-refactor-console-sak-processing.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
updated-i386-cleanup-apic-code.patch
updated-i386-rework-local-apic-calibration.patch
updated-dynticks-fix-nmi-watchdog.patch
clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch
pidhash-temporary-debug-checks.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

