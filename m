From: akpm@linux-foundation.org
Subject: - pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:45:33 -0800
Message-ID: <200702122245.l1CMjXqP013720@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45121 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965440AbXBLWph (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:45:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, alan@lxorguk.ukuu.org.uk, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     pid: remove the now unused kill_pg kill_pg_info and __kill_pg_info
has been removed from the -mm tree.  Its filename was
     pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pid: remove the now unused kill_pg kill_pg_info and __kill_pg_info
From: Eric W. Biederman <ebiederm@xmission.com>

Now that I have changed all of the in-tree users remove the old version of
these functions.  This should make it clear to any out of tree users that they
should be using kill_pgrp kill_pgrp_info or __kill_pgrp_info instead.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    3 ---
 kernel/signal.c       |   27 ---------------------------
 2 files changed, 30 deletions(-)

diff -puN include/linux/sched.h~pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info include/linux/sched.h
--- a/include/linux/sched.h~pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info
+++ a/include/linux/sched.h
@@ -1329,14 +1329,11 @@ extern int kill_pid_info(int sig, struct
 extern int kill_pid_info_as_uid(int, struct siginfo *, struct pid *, uid_t, uid_t, u32);
 extern int kill_pgrp(struct pid *pid, int sig, int priv);
 extern int kill_pid(struct pid *pid, int sig, int priv);
-extern int __kill_pg_info(int sig, struct siginfo *info, pid_t pgrp);
-extern int kill_pg_info(int, struct siginfo *, pid_t);
 extern void do_notify_parent(struct task_struct *, int);
 extern void force_sig(int, struct task_struct *);
 extern void force_sig_specific(int, struct task_struct *);
 extern int send_sig(int, struct task_struct *, int);
 extern void zap_other_threads(struct task_struct *p);
-extern int kill_pg(pid_t, int, int);
 extern int kill_proc(pid_t, int, int);
 extern struct sigqueue *sigqueue_alloc(void);
 extern void sigqueue_free(struct sigqueue *);
diff -puN kernel/signal.c~pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info kernel/signal.c
--- a/kernel/signal.c~pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info
+++ a/kernel/signal.c
@@ -1096,26 +1096,6 @@ int kill_pgrp_info(int sig, struct sigin
 	return retval;
 }
 
-int __kill_pg_info(int sig, struct siginfo *info, pid_t pgrp)
-{
-	if (pgrp <= 0)
-		return -EINVAL;
-
-	return __kill_pgrp_info(sig, info, find_pid(pgrp));
-}
-
-int
-kill_pg_info(int sig, struct siginfo *info, pid_t pgrp)
-{
-	int retval;
-
-	read_lock(&tasklist_lock);
-	retval = __kill_pg_info(sig, info, pgrp);
-	read_unlock(&tasklist_lock);
-
-	return retval;
-}
-
 int kill_pid_info(int sig, struct siginfo *info, struct pid *pid)
 {
 	int error;
@@ -1315,12 +1295,6 @@ int kill_pid(struct pid *pid, int sig, i
 EXPORT_SYMBOL(kill_pid);
 
 int
-kill_pg(pid_t pgrp, int sig, int priv)
-{
-	return kill_pg_info(sig, __si_special(priv), pgrp);
-}
-
-int
 kill_proc(pid_t pid, int sig, int priv)
 {
 	return kill_proc_info(sig, __si_special(priv), pid);
@@ -1959,7 +1933,6 @@ EXPORT_SYMBOL(recalc_sigpending);
 EXPORT_SYMBOL_GPL(dequeue_signal);
 EXPORT_SYMBOL(flush_signals);
 EXPORT_SYMBOL(force_sig);
-EXPORT_SYMBOL(kill_pg);
 EXPORT_SYMBOL(kill_proc);
 EXPORT_SYMBOL(ptrace_notify);
 EXPORT_SYMBOL(send_sig);
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
