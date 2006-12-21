From: akpm@osdl.org
Subject: + fix-reparenting-to-the-same-thread-group.patch added to -mm tree
Date: Thu, 21 Dec 2006 14:11:32 -0800
Message-ID: <200612212211.kBLMBW1M006559@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:46247 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423109AbWLUWLe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 17:11:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com


The patch titled
     Fix reparenting to the same thread group
has been added to the -mm tree.  Its filename is
     fix-reparenting-to-the-same-thread-group.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix reparenting to the same thread group
From: Eric W. Biederman <ebiederm@xmission.com>

This patch fixes the case when we reparent to a different thread in the
same thread group.  This modifies the code so that we do not send signals
and do not change the signal to send to SIGCHLD unless we have change the
thread group of our parents.  It also suppresses sending pdeath_sig in this
case as well since the result of getppid doesn't change.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/exit.c |   37 ++++++++++++++++++++++---------------
 1 files changed, 22 insertions(+), 15 deletions(-)

diff -puN kernel/exit.c~fix-reparenting-to-the-same-thread-group kernel/exit.c
--- a/kernel/exit.c~fix-reparenting-to-the-same-thread-group
+++ a/kernel/exit.c
@@ -595,14 +595,6 @@ choose_new_parent(struct task_struct *p,
 static void
 reparent_thread(struct task_struct *p, struct task_struct *father, int traced)
 {
-	/* We don't want people slaying init.  */
-	if (p->exit_signal != -1)
-		p->exit_signal = SIGCHLD;
-
-	if (p->pdeath_signal)
-		/* We already hold the tasklist_lock here.  */
-		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
-
 	/* Move the child from its dying parent to the new one.  */
 	if (unlikely(traced)) {
 		/* Preserve ptrace links if someone else is tracing this child.  */
@@ -618,13 +610,7 @@ reparent_thread(struct task_struct *p, s
 		p->parent = p->real_parent;
 		add_parent(p);
 
-		/* If we'd notified the old parent about this child's death,
-		 * also notify the new parent.
-		 */
-		if (p->exit_state == EXIT_ZOMBIE && p->exit_signal != -1 &&
-		    thread_group_empty(p))
-			do_notify_parent(p, p->exit_signal);
-		else if (p->state == TASK_TRACED) {
+		if (p->state == TASK_TRACED) {
 			/*
 			 * If it was at a trace stop, turn it into
 			 * a normal stop since it's no longer being
@@ -634,6 +620,27 @@ reparent_thread(struct task_struct *p, s
 		}
 	}
 
+	/* If this is a threaded reparent there is no need to
+	 * notify anyone anything has happened.
+	 */
+	if (!traced && p->real_parent->group_leader == father->group_leader)
+		return;
+
+	/* We don't want people slaying init.  */
+	if (p->exit_signal != -1)
+		p->exit_signal = SIGCHLD;
+
+	if (p->pdeath_signal)
+		/* We already hold the tasklist_lock here.  */
+		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
+
+	/* If we'd notified the old parent about this child's death,
+	 * also notify the new parent.
+	 */
+	if (!traced && p->exit_state == EXIT_ZOMBIE &&
+	    p->exit_signal != -1 && thread_group_empty(p))
+		do_notify_parent(p, p->exit_signal);
+
 	/*
 	 * process group orphan check
 	 * Case ii: Our child is in a different pgrp
_

Patches currently in -mm which might be from ebiederm@xmission.com are

fix-reparenting-to-the-same-thread-group.patch
kthread-api-conversion-for-dvb_frontend-and-av7110.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
vt-refactor-console-sak-processing.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
kill_pid_info-kill-acquired_tasklist_lock.patch
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
i386-apic-clean-up-the-apic-code.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
dynticks-i386-prepare-nmi-watchdog.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

