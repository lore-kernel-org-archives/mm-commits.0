From: akpm@linux-foundation.org
Subject: - pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:45:18 -0800
Message-ID: <200702122245.l1CMjI6t013701@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45086 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030290AbXBLWpW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:45:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, alan@lxorguk.ukuu.org.uk, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     pid: make session_of_pgrp use struct pid instead of pid_t
has been removed from the -mm tree.  Its filename was
     pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pid: make session_of_pgrp use struct pid instead of pid_t
From: Eric W. Biederman <ebiederm@xmission.com>

To properly implement a pid namespace I need to deal exclusively in terms of
struct pid, because pid_t values become ambiguous.

To this end session_of_pgrp is transformed to take and return a struct pid
pointer.  To avoid the need to worry about reference counting I now require my
caller to hold the appropriate locks.  Leaving callers repsonsible for
increasing the reference count if they need access to the result outside of
the locks.

Since session_of_pgrp currently only has one caller and that caller simply
uses only test the result for equality with another process group, the locking
change means I don't actually have to acquire the tasklist_lock at all.

tiocspgrp is also modified to take and release the lock.  The logic there is a
little more complicated but nothing I won't need when I convert pgrp of a tty
to a struct pid pointer.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c  |   24 +++++++++++++++++-------
 include/linux/kernel.h |    3 ++-
 kernel/exit.c          |   16 +++++++---------
 3 files changed, 26 insertions(+), 17 deletions(-)

diff -puN drivers/char/tty_io.c~pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t
+++ a/drivers/char/tty_io.c
@@ -2990,7 +2990,8 @@ static int tiocgpgrp(struct tty_struct *
 
 static int tiocspgrp(struct tty_struct *tty, struct tty_struct *real_tty, pid_t __user *p)
 {
-	pid_t pgrp;
+	struct pid *pgrp;
+	pid_t pgrp_nr;
 	int retval = tty_check_change(real_tty);
 
 	if (retval == -EIO)
@@ -3001,14 +3002,23 @@ static int tiocspgrp(struct tty_struct *
 	    (current->signal->tty != real_tty) ||
 	    (real_tty->session != process_session(current)))
 		return -ENOTTY;
-	if (get_user(pgrp, p))
+	if (get_user(pgrp_nr, p))
 		return -EFAULT;
-	if (pgrp < 0)
+	if (pgrp_nr < 0)
 		return -EINVAL;
-	if (session_of_pgrp(pgrp) != process_session(current))
-		return -EPERM;
-	real_tty->pgrp = pgrp;
-	return 0;
+	rcu_read_lock();
+	pgrp = find_pid(pgrp_nr);
+	retval = -ESRCH;
+	if (!pgrp)
+		goto out_unlock;
+	retval = -EPERM;
+	if (session_of_pgrp(pgrp) != task_session(current))
+		goto out_unlock;
+	retval = 0;
+	real_tty->pgrp = pgrp_nr;
+out_unlock:
+	rcu_read_unlock();
+	return retval;
 }
 
 /**
diff -puN include/linux/kernel.h~pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t include/linux/kernel.h
--- a/include/linux/kernel.h~pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t
+++ a/include/linux/kernel.h
@@ -134,7 +134,8 @@ extern unsigned long long memparse(char 
 extern int core_kernel_text(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
 extern int kernel_text_address(unsigned long addr);
-extern int session_of_pgrp(int pgrp);
+struct pid;
+extern struct pid *session_of_pgrp(struct pid *pgrp);
 
 extern void dump_thread(struct pt_regs *regs, struct user *dump);
 
diff -puN kernel/exit.c~pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t kernel/exit.c
--- a/kernel/exit.c~pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t
+++ a/kernel/exit.c
@@ -185,21 +185,19 @@ repeat:
  * This checks not only the pgrp, but falls back on the pid if no
  * satisfactory pgrp is found. I dunno - gdb doesn't work correctly
  * without this...
+ *
+ * The caller must hold rcu lock or the tasklist lock.
  */
-int session_of_pgrp(int pgrp)
+struct pid *session_of_pgrp(struct pid *pgrp)
 {
 	struct task_struct *p;
-	int sid = 0;
-
-	read_lock(&tasklist_lock);
+	struct pid *sid = NULL;
 
-	p = find_task_by_pid_type(PIDTYPE_PGID, pgrp);
+	p = pid_task(pgrp, PIDTYPE_PGID);
 	if (p == NULL)
-		p = find_task_by_pid(pgrp);
+		p = pid_task(pgrp, PIDTYPE_PID);
 	if (p != NULL)
-		sid = process_session(p);
-
-	read_unlock(&tasklist_lock);
+		sid = task_session(p);
 
 	return sid;
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
