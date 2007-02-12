From: akpm@linux-foundation.org
Subject: - pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:45:23 -0800
Message-ID: <200702122245.l1CMjNaa013707@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45098 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030295AbXBLWp2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:45:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, alan@lxorguk.ukuu.org.uk, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     pid: replace is_orphaned_pgrp with is_current_pgrp_orphaned
has been removed from the -mm tree.  Its filename was
     pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pid: replace is_orphaned_pgrp with is_current_pgrp_orphaned
From: Eric W. Biederman <ebiederm@xmission.com>

Every call to is_orphaned_pgrp passed in process_group(current) which is racy
with respect to another thread changing our process group.  It didn't bite us
because we were dealing with integers and the worse we would get would be a
stale answer.

In switching the checks to use struct pid to be a little more efficient and
prepare the way for pid namespaces this race became apparent.

So I simplified the calls to the more specialized is_current_pgrp_orphaned so
I didn't have to worry about making logic changes to avoid the race.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_tty.c  |    2 +-
 drivers/char/tty_io.c |    2 +-
 include/linux/tty.h   |    2 +-
 kernel/exit.c         |    4 ++--
 kernel/signal.c       |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/char/n_tty.c~pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned
+++ a/drivers/char/n_tty.c
@@ -1188,7 +1188,7 @@ static int job_control(struct tty_struct
 			printk("read_chan: tty->pgrp <= 0!\n");
 		else if (process_group(current) != tty->pgrp) {
 			if (is_ignored(SIGTTIN) ||
-			    is_orphaned_pgrp(process_group(current)))
+			    is_current_pgrp_orphaned())
 				return -EIO;
 			kill_pg(process_group(current), SIGTTIN, 1);
 			return -ERESTARTSYS;
diff -puN drivers/char/tty_io.c~pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned
+++ a/drivers/char/tty_io.c
@@ -1118,7 +1118,7 @@ int tty_check_change(struct tty_struct *
 		return 0;
 	if (is_ignored(SIGTTOU))
 		return 0;
-	if (is_orphaned_pgrp(process_group(current)))
+	if (is_current_pgrp_orphaned())
 		return -EIO;
 	(void) kill_pg(process_group(current), SIGTTOU, 1);
 	return -ERESTARTSYS;
diff -puN include/linux/tty.h~pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned include/linux/tty.h
--- a/include/linux/tty.h~pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned
+++ a/include/linux/tty.h
@@ -303,7 +303,7 @@ extern int tty_read_raw_data(struct tty_
 			     int buflen);
 extern void tty_write_message(struct tty_struct *tty, char *msg);
 
-extern int is_orphaned_pgrp(int pgrp);
+extern int is_current_pgrp_orphaned(void);
 extern int is_ignored(int sig);
 extern int tty_signal(int sig, struct tty_struct *tty);
 extern void tty_hangup(struct tty_struct * tty);
diff -puN kernel/exit.c~pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned kernel/exit.c
--- a/kernel/exit.c~pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned
+++ a/kernel/exit.c
@@ -229,12 +229,12 @@ static int will_become_orphaned_pgrp(str
 	return ret;	/* (sighing) "Often!" */
 }
 
-int is_orphaned_pgrp(int pgrp)
+int is_current_pgrp_orphaned(void)
 {
 	int retval;
 
 	read_lock(&tasklist_lock);
-	retval = will_become_orphaned_pgrp(find_pid(pgrp), NULL);
+	retval = will_become_orphaned_pgrp(task_pgrp(current), NULL);
 	read_unlock(&tasklist_lock);
 
 	return retval;
diff -puN kernel/signal.c~pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned kernel/signal.c
--- a/kernel/signal.c~pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned
+++ a/kernel/signal.c
@@ -1909,7 +1909,7 @@ relock:
 
 				/* signals can be posted during this window */
 
-				if (is_orphaned_pgrp(process_group(current)))
+				if (is_current_pgrp_orphaned())
 					goto relock;
 
 				spin_lock_irq(&current->sighand->siglock);
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
