From: akpm@linux-foundation.org
Subject: + sysctl-add-a-parent-entry-to-ctl_table-and-set-the-parent-entry.patch added to -mm tree
Date: Tue, 06 Feb 2007 16:39:27 -0800
Message-ID: <200702070039.l170dRK3002072@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56846 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933113AbXBGAjd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 19:39:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, jmorris@namei.org, sds@tycho.nsa.gov


The patch titled
     sysctl: add a parent entry to ctl_table and set the parent entry
has been added to the -mm tree.  Its filename is
     sysctl-add-a-parent-entry-to-ctl_table-and-set-the-parent-entry.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: add a parent entry to ctl_table and set the parent entry
From: Eric W. Biederman <ebiederm@xmission.com>

Add a parent entry into the ctl_table so you can walk the list of parents and
find the entire path to a ctl_table entry.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    1 +
 kernel/sysctl.c        |   10 ++++++++++
 2 files changed, 11 insertions(+)

diff -puN include/linux/sysctl.h~sysctl-add-a-parent-entry-to-ctl_table-and-set-the-parent-entry include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-add-a-parent-entry-to-ctl_table-and-set-the-parent-entry
+++ a/include/linux/sysctl.h
@@ -1023,6 +1023,7 @@ struct ctl_table 
 	int maxlen;
 	mode_t mode;
 	ctl_table *child;
+	ctl_table *parent;		/* Automatically set */
 	proc_handler *proc_handler;	/* Callback for text formatting */
 	ctl_handler *strategy;		/* Callback function for all r/w */
 	struct proc_dir_entry *de;	/* /proc control block */
diff -puN kernel/sysctl.c~sysctl-add-a-parent-entry-to-ctl_table-and-set-the-parent-entry kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-add-a-parent-entry-to-ctl_table-and-set-the-parent-entry
+++ a/kernel/sysctl.c
@@ -1278,6 +1278,15 @@ int do_sysctl_strategy (ctl_table *table
 }
 #endif /* CONFIG_SYSCTL_SYSCALL */
 
+static void sysctl_set_parent(struct ctl_table *parent, struct ctl_table *table)
+{
+	for (; table->ctl_name || table->procname; table++) {
+		table->parent = parent;
+		if (table->child)
+			sysctl_set_parent(table, table->child);
+	}
+}
+
 /**
  * register_sysctl_table - register a sysctl hierarchy
  * @table: the top-level table structure
@@ -1356,6 +1365,7 @@ struct ctl_table_header *register_sysctl
 	INIT_LIST_HEAD(&tmp->ctl_entry);
 	tmp->used = 0;
 	tmp->unregistering = NULL;
+	sysctl_set_parent(NULL, table);
 	spin_lock(&sysctl_lock);
 	list_add_tail(&tmp->ctl_entry, &root_table_header.ctl_entry);
 	spin_unlock(&sysctl_lock);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

x86_64-irq-simplfy-__assign_irq_vector.patch
x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration.patch
powerpc-rtas-msi-support.patch
kthread-api-conversion-for-dvb_frontend-and-av7110.patch
fix-i-oat-for-kexec.patch
bugfixes-pci-devices-get-assigned-redundant-irqs.patch
kexec-update-io-apic-dest-field-to-8-bit-for.patch
x86_64-survive-having-no-irq-mapping-for-a-vector.patch
vt-refactor-console-sak-processing.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
kill_pid_info-kill-acquired_tasklist_lock.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
sn2-use-static-proc_fops.patch
_proc_do_string-fix-short-reads.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
shm-make-sysv-ipc-shared-memory-use-stacked-files.patch
ipc-save-the-ipc-namespace-while-reading-proc-files.patch
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
sysctl-xfs-remove-unnecessary-insert_at_head-flag.patch
sysctl-c99-convert-xfs-ctl_tables.patch
sysctl-c99-convert-xfs-ctl_tables-fixes.patch
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
sysctl-add-a-parent-entry-to-ctl_table-and-set-the-parent-entry.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix.patch
sysctl-restore-the-selinux-path-based-label-lookup-for-sysctls.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-ntfs-fix.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
