From: akpm@linux-foundation.org
Subject: - sysctl-c99-convert-xfs-ctl_tables.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:56:14 -0800
Message-ID: <200702112256.l1BMuEMO016395@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60697 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932901AbXBKW4T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:56:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, dgc@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: C99 convert xfs ctl_tables
has been removed from the -mm tree.  Its filename was
     sysctl-c99-convert-xfs-ctl_tables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: C99 convert xfs ctl_tables
From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: David Chinner <dgc@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/xfs/linux-2.6/xfs_sysctl.c |  260 ++++++++++++++++++++++----------
 1 file changed, 181 insertions(+), 79 deletions(-)

diff -puN fs/xfs/linux-2.6/xfs_sysctl.c~sysctl-c99-convert-xfs-ctl_tables fs/xfs/linux-2.6/xfs_sysctl.c
--- a/fs/xfs/linux-2.6/xfs_sysctl.c~sysctl-c99-convert-xfs-ctl_tables
+++ a/fs/xfs/linux-2.6/xfs_sysctl.c
@@ -55,95 +55,197 @@ xfs_stats_clear_proc_handler(
 #endif /* CONFIG_PROC_FS */
 
 STATIC ctl_table xfs_table[] = {
-	{XFS_RESTRICT_CHOWN, "restrict_chown", &xfs_params.restrict_chown.val,
-	sizeof(int), 0644, NULL, &proc_dointvec_minmax,
-	&sysctl_intvec, NULL,
-	&xfs_params.restrict_chown.min, &xfs_params.restrict_chown.max},
-
-	{XFS_SGID_INHERIT, "irix_sgid_inherit", &xfs_params.sgid_inherit.val,
-	sizeof(int), 0644, NULL, &proc_dointvec_minmax,
-	&sysctl_intvec, NULL,
-	&xfs_params.sgid_inherit.min, &xfs_params.sgid_inherit.max},
-
-	{XFS_SYMLINK_MODE, "irix_symlink_mode", &xfs_params.symlink_mode.val,
-	sizeof(int), 0644, NULL, &proc_dointvec_minmax,
-	&sysctl_intvec, NULL,
-	&xfs_params.symlink_mode.min, &xfs_params.symlink_mode.max},
-
-	{XFS_PANIC_MASK, "panic_mask", &xfs_params.panic_mask.val,
-	sizeof(int), 0644, NULL, &proc_dointvec_minmax,
-	&sysctl_intvec, NULL,
-	&xfs_params.panic_mask.min, &xfs_params.panic_mask.max},
-
-	{XFS_ERRLEVEL, "error_level", &xfs_params.error_level.val,
-	sizeof(int), 0644, NULL, &proc_dointvec_minmax,
-	&sysctl_intvec, NULL,
-	&xfs_params.error_level.min, &xfs_params.error_level.max},
-
-	{XFS_SYNCD_TIMER, "xfssyncd_centisecs", &xfs_params.syncd_timer.val,
-	sizeof(int), 0644, NULL, &proc_dointvec_minmax,
-	&sysctl_intvec, NULL,
-	&xfs_params.syncd_timer.min, &xfs_params.syncd_timer.max},
-
-	{XFS_INHERIT_SYNC, "inherit_sync", &xfs_params.inherit_sync.val,
-	sizeof(int), 0644, NULL, &proc_dointvec_minmax,
-	&sysctl_intvec, NULL,
-	&xfs_params.inherit_sync.min, &xfs_params.inherit_sync.max},
-
-	{XFS_INHERIT_NODUMP, "inherit_nodump", &xfs_params.inherit_nodump.val,
-	sizeof(int), 0644, NULL, &proc_dointvec_minmax,
-	&sysctl_intvec, NULL,
-	&xfs_params.inherit_nodump.min, &xfs_params.inherit_nodump.max},
-
-	{XFS_INHERIT_NOATIME, "inherit_noatime", &xfs_params.inherit_noatim.val,
-	sizeof(int), 0644, NULL, &proc_dointvec_minmax,
-	&sysctl_intvec, NULL,
-	&xfs_params.inherit_noatim.min, &xfs_params.inherit_noatim.max},
-
-	{XFS_BUF_TIMER, "xfsbufd_centisecs", &xfs_params.xfs_buf_timer.val,
-	sizeof(int), 0644, NULL, &proc_dointvec_minmax,
-	&sysctl_intvec, NULL,
-	&xfs_params.xfs_buf_timer.min, &xfs_params.xfs_buf_timer.max},
-
-	{XFS_BUF_AGE, "age_buffer_centisecs", &xfs_params.xfs_buf_age.val,
-	sizeof(int), 0644, NULL, &proc_dointvec_minmax,
-	&sysctl_intvec, NULL,
-	&xfs_params.xfs_buf_age.min, &xfs_params.xfs_buf_age.max},
-
-	{XFS_INHERIT_NOSYM, "inherit_nosymlinks", &xfs_params.inherit_nosym.val,
-	sizeof(int), 0644, NULL, &proc_dointvec_minmax,
-	&sysctl_intvec, NULL,
-	&xfs_params.inherit_nosym.min, &xfs_params.inherit_nosym.max},
-
-	{XFS_ROTORSTEP, "rotorstep", &xfs_params.rotorstep.val,
-	sizeof(int), 0644, NULL, &proc_dointvec_minmax,
-	&sysctl_intvec, NULL,
-	&xfs_params.rotorstep.min, &xfs_params.rotorstep.max},
-
-	{XFS_INHERIT_NODFRG, "inherit_nodefrag", &xfs_params.inherit_nodfrg.val,
-	sizeof(int), 0644, NULL, &proc_dointvec_minmax,
-	&sysctl_intvec, NULL,
-	&xfs_params.inherit_nodfrg.min, &xfs_params.inherit_nodfrg.max},
-
+	{
+		.ctl_name	= XFS_RESTRICT_CHOWN,
+		.procname	= "restrict_chown",
+		.data		= &xfs_params.restrict_chown.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &xfs_params.restrict_chown.min,
+		.extra2		= &xfs_params.restrict_chown.max
+	},
+	{
+		.ctl_name	= XFS_SGID_INHERIT,
+		.procname	= "irix_sgid_inherit",
+		.data		= &xfs_params.sgid_inherit.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &xfs_params.sgid_inherit.min,
+		.extra2		= &xfs_params.sgid_inherit.max
+	},
+	{
+		.ctl_name	= XFS_SYMLINK_MODE,
+		.procname	= "irix_symlink_mode",
+		.data		= &xfs_params.symlink_mode.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &xfs_params.symlink_mode.min,
+		.extra2		= &xfs_params.symlink_mode.max
+	},
+	{
+		.ctl_name	= XFS_PANIC_MASK,
+		.procname	= "panic_mask",
+		.data		= &xfs_params.panic_mask.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	=  &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &xfs_params.panic_mask.min,
+		.extra2		= &xfs_params.panic_mask.max
+	},
+
+	{
+		.ctl_name	= XFS_ERRLEVEL,
+		.procname	= "error_level",
+		.data		= &xfs_params.error_level.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &xfs_params.error_level.min,
+		.extra2		= &xfs_params.error_level.max
+	},
+	{
+		.ctl_name	= XFS_SYNCD_TIMER,
+		.procname	= "xfssyncd_centisecs",
+		.data		= &xfs_params.syncd_timer.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &xfs_params.syncd_timer.min,
+		.extra2		= &xfs_params.syncd_timer.max
+	},
+	{
+		.ctl_name	= XFS_INHERIT_SYNC,
+		.procname	= "inherit_sync",
+		.data		= &xfs_params.inherit_sync.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &xfs_params.inherit_sync.min,
+		.extra2		= &xfs_params.inherit_sync.max
+	},
+	{
+		.ctl_name	= XFS_INHERIT_NODUMP,
+		.procname	= "inherit_nodump",
+		.data		= &xfs_params.inherit_nodump.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec, NULL,
+		.extra1		= &xfs_params.inherit_nodump.min,
+		.extra2		= &xfs_params.inherit_nodump.max
+	},
+	{
+		.ctl_name	= XFS_INHERIT_NOATIME,
+		.procname	= "inherit_noatime",
+		.data		= &xfs_params.inherit_noatim.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec, NULL,
+		.extra1		= &xfs_params.inherit_noatim.min,
+		.extra2		= &xfs_params.inherit_noatim.max
+	},
+	{
+		.ctl_name	= XFS_BUF_TIMER,
+		.procname	= "xfsbufd_centisecs",
+		.data		= &xfs_params.xfs_buf_timer.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &xfs_params.xfs_buf_timer.min,
+		.extra2		= &xfs_params.xfs_buf_timer.max
+	},
+	{
+		.ctl_name	= XFS_BUF_AGE,
+		.procname	= "age_buffer_centisecs",
+		.data		= &xfs_params.xfs_buf_age.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec, NULL,
+		.extra1		= &xfs_params.xfs_buf_age.min,
+		.extra2		= &xfs_params.xfs_buf_age.max
+	},
+	{
+		.ctl_name	= XFS_INHERIT_NOSYM,
+		.procname	= "inherit_nosymlinks",
+		.data		= &xfs_params.inherit_nosym.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &xfs_params.inherit_nosym.min,
+		.extra2		= &xfs_params.inherit_nosym.max
+	},
+	{
+		.ctl_name	= XFS_ROTORSTEP,
+		.procname	= "rotorstep",
+		.data		= &xfs_params.rotorstep.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &xfs_params.rotorstep.min,
+		.extra2		= &xfs_params.rotorstep.max
+	},
+	{
+		.ctl_name	= XFS_INHERIT_NODFRG,
+		.procname	= "inherit_nodefrag",
+		.data		= &xfs_params.inherit_nodfrg.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &xfs_params.inherit_nodfrg.min,
+		.extra2		= &xfs_params.inherit_nodfrg.max
+	},
 	/* please keep this the last entry */
 #ifdef CONFIG_PROC_FS
-	{XFS_STATS_CLEAR, "stats_clear", &xfs_params.stats_clear.val,
-	sizeof(int), 0644, NULL, &xfs_stats_clear_proc_handler,
-	&sysctl_intvec, NULL,
-	&xfs_params.stats_clear.min, &xfs_params.stats_clear.max},
+	{
+		.ctl_name	= XFS_STATS_CLEAR,
+		.procname	= "stats_clear",
+		.data		= &xfs_params.stats_clear.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	=  &xfs_stats_clear_proc_handler,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &xfs_params.stats_clear.min,
+		.extra2		= &xfs_params.stats_clear.max
+	},
 #endif /* CONFIG_PROC_FS */
 
-	{0}
+	{}
 };
 
 STATIC ctl_table xfs_dir_table[] = {
-	{FS_XFS, "xfs", NULL, 0, 0555, xfs_table},
-	{0}
+	{
+		.ctl_name	= FS_XFS,
+		.procname	= "xfs",
+		.mode		= 0555,
+		.child		= xfs_table
+	},
+	{}
 };
 
 STATIC ctl_table xfs_root_table[] = {
-	{CTL_FS, "fs",  NULL, 0, 0555, xfs_dir_table},
-	{0}
+	{
+		.ctl_name	= CTL_FS,
+		.procname	= "fs",
+		.mode		= 0555,
+		.child		= xfs_dir_table
+	},
+	{}
 };
 
 void
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
