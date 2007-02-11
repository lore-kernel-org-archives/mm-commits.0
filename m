From: akpm@linux-foundation.org
Subject: - vt-refactor-console-sak-processing.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:50:01 -0800
Message-ID: <200702112250.l1BMo1LN015806@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59958 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932734AbXBKWuI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:50:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     vt: refactor console SAK processing
has been removed from the -mm tree.  Its filename was
     vt-refactor-console-sak-processing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: vt: refactor console SAK processing
From: Eric W. Biederman <ebiederm@xmission.com>

This does several things.
- It moves looking up of the current foreground console into process
  context where we can safely take the semaphore that protects this
  operation.
- It uses the new flavor of work queue processing.
- This generates a factor of do_SAK, __do_SAK that runs immediately.
- This calls __do_SAK with the console semaphore held ensuring nothing
  else happens to the console while we process the SAK operation.
- With the console SAK processing moved into process context this
  patch removes the xchg operations that I used to attempt to attomically
  update struct pid, because of the strange locking used in the SAK processing.
  With SAK using the normal console semaphore nothing special is needed.

Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/keyboard.c        |   12 +++---------
 drivers/char/sysrq.c           |    6 +++---
 drivers/char/tty_io.c          |   13 +++++++++----
 drivers/char/vt_ioctl.c        |   28 ++++++++++++++++++++++++++--
 include/linux/console_struct.h |    3 +++
 include/linux/tty.h            |    1 +
 6 files changed, 45 insertions(+), 18 deletions(-)

diff -puN drivers/char/keyboard.c~vt-refactor-console-sak-processing drivers/char/keyboard.c
--- a/drivers/char/keyboard.c~vt-refactor-console-sak-processing
+++ a/drivers/char/keyboard.c
@@ -595,15 +595,9 @@ static void fn_spawn_con(struct vc_data 
 
 static void fn_SAK(struct vc_data *vc)
 {
-	struct tty_struct *tty = vc->vc_tty;
-
-	/*
-	 * SAK should also work in all raw modes and reset
-	 * them properly.
-	 */
-	if (tty)
-		do_SAK(tty);
-	reset_vc(vc);
+	struct work_struct *SAK_work = &vc_cons[fg_console].SAK_work;
+	PREPARE_WORK(SAK_work, vc_SAK);
+	schedule_work(SAK_work);
 }
 
 static void fn_null(struct vc_data *vc)
diff -puN drivers/char/sysrq.c~vt-refactor-console-sak-processing drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~vt-refactor-console-sak-processing
+++ a/drivers/char/sysrq.c
@@ -88,9 +88,9 @@ static struct sysrq_key_op sysrq_logleve
 #ifdef CONFIG_VT
 static void sysrq_handle_SAK(int key, struct tty_struct *tty)
 {
-	if (tty)
-		do_SAK(tty);
-	reset_vc(vc_cons[fg_console].d);
+	struct work_struct *SAK_work = &vc_cons[fg_console].SAK_work;
+	PREPARE_WORK(SAK_work, vc_SAK);
+	schedule_work(SAK_work);
 }
 static struct sysrq_key_op sysrq_SAK_op = {
 	.handler	= sysrq_handle_SAK,
diff -puN drivers/char/tty_io.c~vt-refactor-console-sak-processing drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~vt-refactor-console-sak-processing
+++ a/drivers/char/tty_io.c
@@ -3324,10 +3324,8 @@ int tty_ioctl(struct inode * inode, stru
  * Nasty bug: do_SAK is being called in interrupt context.  This can
  * deadlock.  We punt it up to process context.  AKPM - 16Mar2001
  */
-static void __do_SAK(struct work_struct *work)
+void __do_SAK(struct tty_struct *tty)
 {
-	struct tty_struct *tty =
-		container_of(work, struct tty_struct, SAK_work);
 #ifdef TTY_SOFT_SAK
 	tty_hangup(tty);
 #else
@@ -3394,6 +3392,13 @@ static void __do_SAK(struct work_struct 
 #endif
 }
 
+static void do_SAK_work(struct work_struct *work)
+{
+	struct tty_struct *tty =
+		container_of(work, struct tty_struct, SAK_work);
+	__do_SAK(tty);
+}
+
 /*
  * The tq handling here is a little racy - tty->SAK_work may already be queued.
  * Fortunately we don't need to worry, because if ->SAK_work is already queued,
@@ -3404,7 +3409,7 @@ void do_SAK(struct tty_struct *tty)
 {
 	if (!tty)
 		return;
-	PREPARE_WORK(&tty->SAK_work, __do_SAK);
+	PREPARE_WORK(&tty->SAK_work, do_SAK_work);
 	schedule_work(&tty->SAK_work);
 }
 
diff -puN drivers/char/vt_ioctl.c~vt-refactor-console-sak-processing drivers/char/vt_ioctl.c
--- a/drivers/char/vt_ioctl.c~vt-refactor-console-sak-processing
+++ a/drivers/char/vt_ioctl.c
@@ -672,7 +672,8 @@ int vt_ioctl(struct tty_struct *tty, str
 		vc->vt_mode = tmp;
 		/* the frsig is ignored, so we set it to 0 */
 		vc->vt_mode.frsig = 0;
-		put_pid(xchg(&vc->vt_pid, get_pid(task_pid(current))));
+		put_pid(vc->vt_pid);
+		vc->vt_pid = get_pid(task_pid(current));
 		/* no switch is required -- saw@shade.msu.ru */
 		vc->vt_newvt = -1;
 		release_console_sem();
@@ -1063,12 +1064,35 @@ void reset_vc(struct vc_data *vc)
 	vc->vt_mode.relsig = 0;
 	vc->vt_mode.acqsig = 0;
 	vc->vt_mode.frsig = 0;
-	put_pid(xchg(&vc->vt_pid, NULL));
+	put_pid(vc->vt_pid);
+	vc->vt_pid = NULL;
 	vc->vt_newvt = -1;
 	if (!in_interrupt())    /* Via keyboard.c:SAK() - akpm */
 		reset_palette(vc);
 }
 
+void vc_SAK(struct work_struct *work)
+{
+	struct vc *vc_con =
+		container_of(work, struct vc, SAK_work);
+	struct vc_data *vc;
+	struct tty_struct *tty;
+
+	acquire_console_sem();
+	vc = vc_con->d;
+	if (vc) {
+		tty = vc->vc_tty;
+		/*
+		 * SAK should also work in all raw modes and reset
+		 * them properly.
+		 */
+		if (tty)
+			__do_SAK(tty);
+		reset_vc(vc);
+	}
+	release_console_sem();
+}
+
 /*
  * Performs the back end of a vt switch
  */
diff -puN include/linux/console_struct.h~vt-refactor-console-sak-processing include/linux/console_struct.h
--- a/include/linux/console_struct.h~vt-refactor-console-sak-processing
+++ a/include/linux/console_struct.h
@@ -11,6 +11,7 @@
 
 #include <linux/wait.h>
 #include <linux/vt.h>
+#include <linux/workqueue.h>
 
 struct vt_struct;
 
@@ -103,6 +104,7 @@ struct vc_data {
 
 struct vc {
 	struct vc_data *d;
+	struct work_struct SAK_work;
 
 	/* might add  scrmem, vt_struct, kbd  at some time,
 	   to have everything in one place - the disadvantage
@@ -110,6 +112,7 @@ struct vc {
 };
 
 extern struct vc vc_cons [MAX_NR_CONSOLES];
+extern void vc_SAK(struct work_struct *work);
 
 #define CUR_DEF		0
 #define CUR_NONE	1
diff -puN include/linux/tty.h~vt-refactor-console-sak-processing include/linux/tty.h
--- a/include/linux/tty.h~vt-refactor-console-sak-processing
+++ a/include/linux/tty.h
@@ -291,6 +291,7 @@ extern void tty_vhangup(struct tty_struc
 extern void tty_unhangup(struct file *filp);
 extern int tty_hung_up_p(struct file * filp);
 extern void do_SAK(struct tty_struct *tty);
+extern void __do_SAK(struct tty_struct *tty);
 extern void disassociate_ctty(int priv);
 extern void tty_flip_buffer_push(struct tty_struct *tty);
 extern speed_t tty_get_baud_rate(struct tty_struct *tty);
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
ipc-save-the-ipc-namespace-while-reading-proc-files.patch
kexec-fix-references-to-init-in-documentation-for-kexe.patch
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
i386-rework-local-apic-timer-calibration.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
edac-e752x-bit-mask-fix.patch
edac-e752x-byte-access-fix.patch
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
