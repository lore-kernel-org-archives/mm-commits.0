From: akpm@linux-foundation.org
Subject: - pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:45:21 -0800
Message-ID: <200702122245.l1CMjLXE013704@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45118 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965437AbXBLWpg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:45:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, alan@lxorguk.ukuu.org.uk, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     pid: use struct pid for talking about process groups in exitc
has been removed from the -mm tree.  Its filename was
     pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pid: use struct pid for talking about process groups in exitc
From: Eric W. Biederman <ebiederm@xmission.com>

Modify has_stopped_jobs and will_become_orphan_pgrp to use struct pid based
process groups.  This reduces the number of hash tables looks ups and paves
the way for multiple pid spaces.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

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
 
@@ -648,14 +648,14 @@ reparent_thread(struct task_struct *p, s
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
@@ -735,6 +735,7 @@ static void exit_notify(struct task_stru
 	int state;
 	struct task_struct *t;
 	struct list_head ptrace_dead, *_p, *_n;
+	struct pid *pgrp;
 
 	if (signal_pending(tsk) && !(tsk->signal->flags & SIGNAL_GROUP_EXIT)
 	    && !thread_group_empty(tsk)) {
@@ -787,12 +788,13 @@ static void exit_notify(struct task_stru
 	 
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
powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
bugfixes-pci-devices-get-assigned-redundant-irqs.patch
git-v9fs.patch
x86_64-irq-simplfy-__assign_irq_vector.patch
x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
allow-access-to-proc-pid-fd-after-setuid-update-2.patch
shm-make-sysv-ipc-shared-memory-use-stacked-files.patch
i386-apic-clean-up-the-apic-code.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
sysctl-x25-remove-unnecessary-insert_at_head-from-register_sysctl_table.patch
sysctl-move-ctl_sunrpc-to-sysctlh-where-it-belongs.patch
sysctl-sunrpc-remove-unnecessary-insert_at_head-flag.patch
sysctl-sunrpc-dont-unnecessarily-set-ctl_table-de.patch
sysctl-rose-remove-unnecessary-insert_at_head-flag.patch
sysctl-netrom-remove-unnecessary-insert_at_head-flag.patch
sysctl-llc-remove-unnecessary-insert_at_head-flag.patch
sysctl-ipx-remove-unnecessary-insert_at_head-flag.patch
sysctl-decnet-remove-unnecessary-insert_at_head-flag.patch
sysctl-dccp-remove-unnecessary-insert_at_head-flag.patch
sysctl-ax25-remove-unnecessary-insert_at_head-flag.patch
sysctl-atalk-remove-unnecessary-insert_at_head-flag.patch
sysctl-scsi-remove-unnecessary-insert_at_head-flag.patch
sysctl-md-remove-unnecessary-insert_at_head-flag.patch
sysctl-mac_hid-remove-unnecessary-insert_at_head-flag.patch
sysctl-ipmi-remove-unnecessary-insert_at_head-flag.patch
sysctl-cdrom-remove-unnecessary-insert_at_head-flag.patch
sysctl-cdrom-dont-set-de-owner.patch
sysctl-move-ctl_pm-into-sysctlh-where-it-belongs.patch
sysctl-frv-pm-remove-unnecessary-insert_at_head-flag.patch
sysctl-move-ctl_frv-into-sysctlh-where-it-belongs.patch
sysctl-frv-remove-unnecessary-insert_at_head-flag.patch
sysctl-c99-convert-arch-frv-kernel-pmc.patch
sysctl-c99-convert-arch-frv-kernel-sysctlc.patch
sysctl-sn-remove-sysctl-abi-breakage.patch
sysctl-c99-convert-arch-ia64-sn-kernel-xpc_mainc.patch
sysctl-c99-convert-arch-ia64-kernel-perfmon-and-remove-abi-breakage.patch
sysctl-mips-au1000-remove-sys_sysctl-support.patch
sysctl-c99-convert-the-ctl_tables-in-arch-mips-au1000-common-powerc.patch
sysctl-c99-convert-arch-mips-lasat-sysctlc-and-remove-abi-breakage.patch
sysctl-s390-move-sysctl-definitions-to-sysctlh.patch
sysctl-s390-remove-unnecessary-use-of-insert_at_head.patch
sysctl-c99-convert-ctl_tables-in-arch-powerpc-kernel-idlec.patch
sysctl-c99-convert-ctl_tables-entries-in-arch-ppc-kernel-ppc_htabc.patch
sysctl-c99-convert-arch-sh64-kernel-trapsc-and-remove-abi-breakage.patch
sysctl-x86_64-remove-unnecessary-use-of-insert_at_head.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-ia32-ia32_binfmtc.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-kernel-vsyscallc.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-mm-initc.patch
sysctl-remove-sys_sysctl-support-from-the-hpet-timer-driver.patch
sysctl-remove-sys_sysctl-support-from-drivers-char-rtcc.patch
sysctl-register-the-sysctl-number-used-by-the-arlan-driver.patch
sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc.patch
sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc-fix.patch
sysctl-c99-convert-coda-ctl_tables-and-remove-binary-sysctls.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support-fix.patch
sysctl-register-the-ocfs2-sysctl-numbers.patch
sysctl-move-init_irq_proc-into-init-main-where-it-belongs.patch
sysctl-move-utsname-sysctls-to-their-own-file.patch
sysctl-move-utsname-sysctls-to-their-own-file-fix-2.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file-fix.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file-fix-2.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry-warning-fix.patch
sysctl-remove-support-for-ctl_any.patch
sysctl-remove-support-for-directory-strategy-routines.patch
sysctl-remove-insert_at_head-from-register_sysctl.patch
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl-warning-fix.patch
sysctl-allow-sysctl_perm-to-be-called-from-outside-of-sysctlc.patch
sysctl-reimplement-the-sysctl-proc-support.patch
sysctl-reimplement-the-sysctl-proc-support-fix.patch
sysctl-reimplement-the-sysctl-proc-support-warning-fix.patch
sysctl-reimplement-the-sysctl-proc-support-fix-2.patch
sysctl-reimplement-the-sysctl-proc-support-fix-3.patch
sysctl-reimplement-the-sysctl-proc-support-fix-4.patch
sysctl-add-a-parent-entry-to-ctl_table-and-set-the-parent-entry.patch
sysctl-add-a-parent-entry-to-ctl_table-and-set-the-parent-entry-fix.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix-2.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-ntfs-fix.patch
sysctl-fix-the-selinux_sysctl_get_sid.patch
selinux-enhance-selinux-to-always-ignore-private-inodes.patch
sysctl-hide-the-sysctl-proc-inodes-from-selinux.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
