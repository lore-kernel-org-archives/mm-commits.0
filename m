From: akpm@linux-foundation.org
Subject: - pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:45:29 -0800
Message-ID: <200702122245.l1CMjTRk013713@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45110 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030292AbXBLWpe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:45:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, alan@lxorguk.ukuu.org.uk, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     pid: replace do/while_each_task_pid with do/while_each_pid_task
has been removed from the -mm tree.  Its filename was
     pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pid: replace do/while_each_task_pid with do/while_each_pid_task
From: Eric W. Biederman <ebiederm@xmission.com>

There isn't any real advantage to this change except that it allows the old
functions to be removed.  Which is easier on maintenance and puts the code in
a more uniform style.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ioprio.c         |   18 ++++++++++++------
 kernel/capability.c |    8 +++++---
 kernel/sys.c        |   40 ++++++++++++++++++++++++----------------
 3 files changed, 41 insertions(+), 25 deletions(-)

diff -puN fs/ioprio.c~pid-replace-do-while_each_task_pid-with-do-while_each_pid_task fs/ioprio.c
--- a/fs/ioprio.c~pid-replace-do-while_each_task_pid-with-do-while_each_pid_task
+++ a/fs/ioprio.c
@@ -60,6 +60,7 @@ asmlinkage long sys_ioprio_set(int which
 	int data = IOPRIO_PRIO_DATA(ioprio);
 	struct task_struct *p, *g;
 	struct user_struct *user;
+	struct pid *pgrp;
 	int ret;
 
 	switch (class) {
@@ -98,12 +99,14 @@ asmlinkage long sys_ioprio_set(int which
 			break;
 		case IOPRIO_WHO_PGRP:
 			if (!who)
-				who = process_group(current);
-			do_each_task_pid(who, PIDTYPE_PGID, p) {
+				pgrp = task_pgrp(current);
+			else
+				pgrp = find_pid(who);
+			do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
 				ret = set_task_ioprio(p, ioprio);
 				if (ret)
 					break;
-			} while_each_task_pid(who, PIDTYPE_PGID, p);
+			} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
 			break;
 		case IOPRIO_WHO_USER:
 			if (!who)
@@ -167,6 +170,7 @@ asmlinkage long sys_ioprio_get(int which
 {
 	struct task_struct *g, *p;
 	struct user_struct *user;
+	struct pid *pgrp;
 	int ret = -ESRCH;
 	int tmpio;
 
@@ -182,8 +186,10 @@ asmlinkage long sys_ioprio_get(int which
 			break;
 		case IOPRIO_WHO_PGRP:
 			if (!who)
-				who = process_group(current);
-			do_each_task_pid(who, PIDTYPE_PGID, p) {
+				pgrp = task_pgrp(current);
+			else
+				pgrp = find_pid(who);
+			do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
 				tmpio = get_task_ioprio(p);
 				if (tmpio < 0)
 					continue;
@@ -191,7 +197,7 @@ asmlinkage long sys_ioprio_get(int which
 					ret = tmpio;
 				else
 					ret = ioprio_best(ret, tmpio);
-			} while_each_task_pid(who, PIDTYPE_PGID, p);
+			} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
 			break;
 		case IOPRIO_WHO_USER:
 			if (!who)
diff -puN kernel/capability.c~pid-replace-do-while_each_task_pid-with-do-while_each_pid_task kernel/capability.c
--- a/kernel/capability.c~pid-replace-do-while_each_task_pid-with-do-while_each_pid_task
+++ a/kernel/capability.c
@@ -92,15 +92,17 @@ out:
  * cap_set_pg - set capabilities for all processes in a given process
  * group.  We call this holding task_capability_lock and tasklist_lock.
  */
-static inline int cap_set_pg(int pgrp, kernel_cap_t *effective,
+static inline int cap_set_pg(int pgrp_nr, kernel_cap_t *effective,
 			      kernel_cap_t *inheritable,
 			      kernel_cap_t *permitted)
 {
 	struct task_struct *g, *target;
 	int ret = -EPERM;
 	int found = 0;
+	struct pid *pgrp;
 
-	do_each_task_pid(pgrp, PIDTYPE_PGID, g) {
+	pgrp = find_pid(pgrp_nr);
+	do_each_pid_task(pgrp, PIDTYPE_PGID, g) {
 		target = g;
 		while_each_thread(g, target) {
 			if (!security_capset_check(target, effective,
@@ -113,7 +115,7 @@ static inline int cap_set_pg(int pgrp, k
 			}
 			found = 1;
 		}
-	} while_each_task_pid(pgrp, PIDTYPE_PGID, g);
+	} while_each_pid_task(pgrp, PIDTYPE_PGID, g);
 
 	if (!found)
 	     ret = 0;
diff -puN kernel/sys.c~pid-replace-do-while_each_task_pid-with-do-while_each_pid_task kernel/sys.c
--- a/kernel/sys.c~pid-replace-do-while_each_task_pid-with-do-while_each_pid_task
+++ a/kernel/sys.c
@@ -596,6 +596,7 @@ asmlinkage long sys_setpriority(int whic
 	struct task_struct *g, *p;
 	struct user_struct *user;
 	int error = -EINVAL;
+	struct pid *pgrp;
 
 	if (which > 2 || which < 0)
 		goto out;
@@ -610,18 +611,21 @@ asmlinkage long sys_setpriority(int whic
 	read_lock(&tasklist_lock);
 	switch (which) {
 		case PRIO_PROCESS:
-			if (!who)
-				who = current->pid;
-			p = find_task_by_pid(who);
+			if (who)
+				p = find_task_by_pid(who);
+			else
+				p = current;
 			if (p)
 				error = set_one_prio(p, niceval, error);
 			break;
 		case PRIO_PGRP:
-			if (!who)
-				who = process_group(current);
-			do_each_task_pid(who, PIDTYPE_PGID, p) {
+			if (who)
+				pgrp = find_pid(who);
+			else
+				pgrp = task_pgrp(current);
+			do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
 				error = set_one_prio(p, niceval, error);
-			} while_each_task_pid(who, PIDTYPE_PGID, p);
+			} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
 			break;
 		case PRIO_USER:
 			user = current->user;
@@ -656,6 +660,7 @@ asmlinkage long sys_getpriority(int whic
 	struct task_struct *g, *p;
 	struct user_struct *user;
 	long niceval, retval = -ESRCH;
+	struct pid *pgrp;
 
 	if (which > 2 || which < 0)
 		return -EINVAL;
@@ -663,9 +668,10 @@ asmlinkage long sys_getpriority(int whic
 	read_lock(&tasklist_lock);
 	switch (which) {
 		case PRIO_PROCESS:
-			if (!who)
-				who = current->pid;
-			p = find_task_by_pid(who);
+			if (who)
+				p = find_task_by_pid(who);
+			else
+				p = current;
 			if (p) {
 				niceval = 20 - task_nice(p);
 				if (niceval > retval)
@@ -673,13 +679,15 @@ asmlinkage long sys_getpriority(int whic
 			}
 			break;
 		case PRIO_PGRP:
-			if (!who)
-				who = process_group(current);
-			do_each_task_pid(who, PIDTYPE_PGID, p) {
+			if (who)
+				pgrp = find_pid(who);
+			else
+				pgrp = task_pgrp(current);
+			do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
 				niceval = 20 - task_nice(p);
 				if (niceval > retval)
 					retval = niceval;
-			} while_each_task_pid(who, PIDTYPE_PGID, p);
+			} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
 			break;
 		case PRIO_USER:
 			user = current->user;
@@ -1388,7 +1396,7 @@ asmlinkage long sys_setpgid(pid_t pid, p
 
 	if (p->real_parent == group_leader) {
 		err = -EPERM;
-		if (process_session(p) != process_session(group_leader))
+		if (task_session(p) != task_session(group_leader))
 			goto out;
 		err = -EACCES;
 		if (p->did_exec)
@@ -1407,7 +1415,7 @@ asmlinkage long sys_setpgid(pid_t pid, p
 		struct task_struct *g =
 			find_task_by_pid_type(PIDTYPE_PGID, pgid);
 
-		if (!g || process_session(g) != process_session(group_leader))
+		if (!g || task_session(g) != task_session(group_leader))
 			goto out;
 	}
 
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
