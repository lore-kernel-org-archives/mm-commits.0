From: akpm@osdl.org
Subject: + sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc.patch added to -mm tree
Date: Tue, 23 Jan 2007 19:13:29 -0800
Message-ID: <200701240313.l0O3DTMJ006953@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49218 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030183AbXAXDNb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 22:13:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com


The patch titled
     sysctl: C99 convert ctl_tables in drivers/parport/procfs.c
has been added to the -mm tree.  Its filename is
     sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: C99 convert ctl_tables in drivers/parport/procfs.c
From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/parport/procfs.c |  270 ++++++++++++++++++++++++++-----------
 1 file changed, 192 insertions(+), 78 deletions(-)

diff -puN drivers/parport/procfs.c~sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc drivers/parport/procfs.c
--- a/drivers/parport/procfs.c~sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc
+++ a/drivers/parport/procfs.c
@@ -233,12 +233,12 @@ static int do_hardware_modes (ctl_table 
 	return copy_to_user(result, buffer, len) ? -EFAULT : 0;
 }
 
-#define PARPORT_PORT_DIR(child) { 0, NULL, NULL, 0, 0555, child }
-#define PARPORT_PARPORT_DIR(child) { DEV_PARPORT, "parport", \
-                                     NULL, 0, 0555, child }
-#define PARPORT_DEV_DIR(child) { CTL_DEV, "dev", NULL, 0, 0555, child }
-#define PARPORT_DEVICES_ROOT_DIR  { DEV_PARPORT_DEVICES, "devices", \
-                                    NULL, 0, 0555, NULL }
+#define PARPORT_PORT_DIR(CHILD) { .ctl_name = 0, .procname = NULL, .mode = 0555, .child = CHILD }
+#define PARPORT_PARPORT_DIR(CHILD) { .ctl_name = DEV_PARPORT, .procname = "parport", \
+                                     .mode = 0555, .child = CHILD }
+#define PARPORT_DEV_DIR(CHILD) { .ctl_name = CTL_DEV, .procname = "dev", .mode = 0555, .child = CHILD }
+#define PARPORT_DEVICES_ROOT_DIR  { .ctl_name = DEV_PARPORT_DEVICES, .procname = "devices", \
+                                    .mode = 0555, .child = NULL }
 
 static const unsigned long parport_min_timeslice_value =
 PARPORT_MIN_TIMESLICE_VALUE;
@@ -263,50 +263,118 @@ struct parport_sysctl_table {
 };
 
 static const struct parport_sysctl_table parport_sysctl_template = {
-	NULL,
+	.sysctl_header = NULL,
         {
-		{ DEV_PARPORT_SPINTIME, "spintime",
-		  NULL, sizeof(int), 0644, NULL,
-		  &proc_dointvec_minmax, NULL, NULL,
-		  (void*) &parport_min_spintime_value,
-		  (void*) &parport_max_spintime_value },
-		{ DEV_PARPORT_BASE_ADDR, "base-addr",
-		  NULL, 0, 0444, NULL,
-		  &do_hardware_base_addr },
-		{ DEV_PARPORT_IRQ, "irq",
-		  NULL, 0, 0444, NULL,
-		  &do_hardware_irq },
-		{ DEV_PARPORT_DMA, "dma",
-		  NULL, 0, 0444, NULL,
-		  &do_hardware_dma },
-		{ DEV_PARPORT_MODES, "modes",
-		  NULL, 0, 0444, NULL,
-		  &do_hardware_modes },
+		{
+			.ctl_name	= DEV_PARPORT_SPINTIME,
+			.procname	= "spintime",
+			.data		= NULL,
+			.maxlen		= sizeof(int),
+			.mode		= 0644,
+			.proc_handler	= &proc_dointvec_minmax,
+			.extra1		= (void*) &parport_min_spintime_value,
+			.extra2		= (void*) &parport_max_spintime_value
+		},
+		{
+			.ctl_name	= DEV_PARPORT_BASE_ADDR,
+			.procname	= "base-addr",
+			.data		= NULL,
+			.maxlen		= 0,
+			.mode		= 0444,
+			.proc_handler	= &do_hardware_base_addr
+		},
+		{
+			.ctl_name	= DEV_PARPORT_IRQ,
+			.procname	= "irq",
+			.data		= NULL,
+			.maxlen		= 0,
+			.mode		= 0444,
+			.proc_handler	= &do_hardware_irq
+		},
+		{
+			.ctl_name	= DEV_PARPORT_DMA,
+			.procname	= "dma",
+			.data		= NULL,
+			.maxlen		= 0,
+			.mode		= 0444,
+			.proc_handler	= &do_hardware_dma
+		},
+		{
+			.ctl_name	= DEV_PARPORT_MODES,
+			.procname	= "modes",
+			.data		= NULL,
+			.maxlen		= 0,
+			.mode		= 0444,
+			.proc_handler	= &do_hardware_modes
+		},
 		PARPORT_DEVICES_ROOT_DIR,
 #ifdef CONFIG_PARPORT_1284
-		{ DEV_PARPORT_AUTOPROBE, "autoprobe",
-		  NULL, 0, 0444, NULL,
-		  &do_autoprobe },
-		{ DEV_PARPORT_AUTOPROBE + 1, "autoprobe0",
-		 NULL, 0, 0444, NULL,
-		 &do_autoprobe },
-		{ DEV_PARPORT_AUTOPROBE + 2, "autoprobe1",
-		  NULL, 0, 0444, NULL,
-		  &do_autoprobe },
-		{ DEV_PARPORT_AUTOPROBE + 3, "autoprobe2",
-		  NULL, 0, 0444, NULL,
-		  &do_autoprobe },
-		{ DEV_PARPORT_AUTOPROBE + 4, "autoprobe3",
-		  NULL, 0, 0444, NULL,
-		  &do_autoprobe },
+		{
+			.ctl_name	= DEV_PARPORT_AUTOPROBE,
+			.procname	= "autoprobe",
+			.data		= NULL,
+			.maxlen		= 0,
+			.mode		= 0444,
+			.proc_handler	= &do_autoprobe
+		},
+		{
+			.ctl_name	= DEV_PARPORT_AUTOPROBE + 1,
+			.procname	= "autoprobe0",
+			.data		= NULL,
+			.maxlen		= 0,
+			.maxlen		= 0444,
+			.proc_handler	=  &do_autoprobe
+		},
+		{
+			.ctl_name	= DEV_PARPORT_AUTOPROBE + 2,
+			.procname	= "autoprobe1",
+			.data		= NULL,
+			.maxlen		= 0,
+			.mode		= 0444,
+			.proc_handler	= &do_autoprobe
+		},
+		{
+			.ctl_name	= DEV_PARPORT_AUTOPROBE + 3,
+			.procname	= "autoprobe2",
+			.data		= NULL,
+			.maxlen		= 0,
+			.mode		= 0444,
+			.proc_handler	= &do_autoprobe
+		},
+		{
+			.ctl_name	= DEV_PARPORT_AUTOPROBE + 4,
+			.procname	= "autoprobe3",
+			.data		= NULL,
+			.maxlen		= 0,
+			.mode		= 0444,
+			.proc_handler	= &do_autoprobe
+		},
 #endif /* IEEE 1284 support */
-		{0}
+		{}
 	},
-	{ {DEV_PARPORT_DEVICES_ACTIVE, "active", NULL, 0, 0444, NULL,
-	  &do_active_device }, {0}},
-	{ PARPORT_PORT_DIR(NULL), {0}},
-	{ PARPORT_PARPORT_DIR(NULL), {0}},
-	{ PARPORT_DEV_DIR(NULL), {0}}
+	{
+		{
+			.ctl_name	= DEV_PARPORT_DEVICES_ACTIVE,
+			.procname	= "active",
+			.data		= NULL,
+			.maxlen		= 0,
+			.mode		= 0444,
+			.proc_handler	= &do_active_device
+		},
+		{}
+	},
+	{
+		PARPORT_PORT_DIR(NULL),
+		{}
+	},
+	{
+		PARPORT_PARPORT_DIR(NULL),
+		{}
+	},
+	{
+		PARPORT_DEV_DIR(NULL),
+		{}
+	}
 };
 
 struct parport_device_sysctl_table
@@ -322,19 +390,46 @@ struct parport_device_sysctl_table
 
 static const struct parport_device_sysctl_table
 parport_device_sysctl_template = {
-	NULL,
+	.sysctl_header = NULL,
+	{
+		{
+			.ctl_name 	= DEV_PARPORT_DEVICE_TIMESLICE,
+			.procname 	= "timeslice",
+			.data		= NULL,
+			.maxlen		= sizeof(int),
+			.mode		= 0644,
+			.proc_handler	= &proc_doulongvec_ms_jiffies_minmax,
+			.extra1		= (void*) &parport_min_timeslice_value,
+			.extra2		= (void*) &parport_max_timeslice_value
+		},
+	},
 	{
-		{ DEV_PARPORT_DEVICE_TIMESLICE, "timeslice",
-		  NULL, sizeof(int), 0644, NULL,
-		  &proc_doulongvec_ms_jiffies_minmax, NULL, NULL,
-		  (void*) &parport_min_timeslice_value,
-		  (void*) &parport_max_timeslice_value },
-	},
-	{ {0, NULL, NULL, 0, 0555, NULL}, {0}},
-	{ PARPORT_DEVICES_ROOT_DIR, {0}},
-	{ PARPORT_PORT_DIR(NULL), {0}},
-	{ PARPORT_PARPORT_DIR(NULL), {0}},
-	{ PARPORT_DEV_DIR(NULL), {0}}
+		{
+			.ctl_name	= 0,
+			.procname	= NULL,
+			.data		= NULL,
+			.maxlen		= 0,
+			.mode		= 0555,
+			.child		= NULL
+		},
+		{}
+	},
+	{
+		PARPORT_DEVICES_ROOT_DIR,
+		{}
+	},
+	{
+		PARPORT_PORT_DIR(NULL),
+		{}
+	},
+	{
+		PARPORT_PARPORT_DIR(NULL),
+		{}
+	},
+	{
+		PARPORT_DEV_DIR(NULL),
+		{}
+	}
 };
 
 struct parport_default_sysctl_table
@@ -351,28 +446,47 @@ extern int parport_default_spintime;
 
 static struct parport_default_sysctl_table
 parport_default_sysctl_table = {
-	NULL,
+	.sysctl_header	= NULL,
 	{
-		{ DEV_PARPORT_DEFAULT_TIMESLICE, "timeslice",
-		  &parport_default_timeslice,
-		  sizeof(parport_default_timeslice), 0644, NULL,
-		  &proc_doulongvec_ms_jiffies_minmax, NULL, NULL,
-		  (void*) &parport_min_timeslice_value,
-		  (void*) &parport_max_timeslice_value },
-		{ DEV_PARPORT_DEFAULT_SPINTIME, "spintime",
-		  &parport_default_spintime,
-		  sizeof(parport_default_spintime), 0644, NULL,
-		  &proc_dointvec_minmax, NULL, NULL,
-		  (void*) &parport_min_spintime_value,
-		  (void*) &parport_max_spintime_value },
-		{0}
-	},
-	{ { DEV_PARPORT_DEFAULT, "default", NULL, 0, 0555,
-	    parport_default_sysctl_table.vars },{0}},
-	{
-	PARPORT_PARPORT_DIR(parport_default_sysctl_table.default_dir), 
-	{0}},
-	{ PARPORT_DEV_DIR(parport_default_sysctl_table.parport_dir), {0}}
+		{
+			.ctl_name	= DEV_PARPORT_DEFAULT_TIMESLICE,
+			.procname	= "timeslice",
+			.data		= &parport_default_timeslice,
+			.maxlen		= sizeof(parport_default_timeslice),
+			.mode		= 0644,
+			.proc_handler	= &proc_doulongvec_ms_jiffies_minmax,
+			.extra1		= (void*) &parport_min_timeslice_value,
+			.extra2		= (void*) &parport_max_timeslice_value
+		},
+		{
+			.ctl_name	= DEV_PARPORT_DEFAULT_SPINTIME,
+			.procname	= "spintime",
+			.data		= &parport_default_spintime,
+			.maxlen		= sizeof(parport_default_spintime),
+			.mode		= 0644,
+			.proc_handler	= &proc_dointvec_minmax,
+			.extra1		= (void*) &parport_min_spintime_value,
+			.extra2		= (void*) &parport_max_spintime_value
+		},
+		{}
+	},
+	{
+		{
+			.ctl_name	= DEV_PARPORT_DEFAULT,
+			.procname	= "default",
+			.mode		= 0555,
+			.child		= parport_default_sysctl_table.vars
+		},
+		{}
+	},
+	{
+		PARPORT_PARPORT_DIR(parport_default_sysctl_table.default_dir),
+		{}
+	},
+	{
+		PARPORT_DEV_DIR(parport_default_sysctl_table.parport_dir),
+		{}
+	}
 };
 
 
_

Patches currently in -mm which might be from ebiederm@xmission.com are

kthread-api-conversion-for-dvb_frontend-and-av7110.patch
vt-refactor-console-sak-processing.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
kill_pid_info-kill-acquired_tasklist_lock.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
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
edac-e752x-bit-mask-fix.patch
edac-e752x-byte-access-fix.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
user-namespace-add-the-framework-fix.patch
user-ns-add-user_namespace-ptr-to-vfsmount.patch
user-ns-hook-permission.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-shared-mounts.patch
user_ns-handle-file-sigio.patch
user_ns-handle-file-sigio-fix.patch
user-ns-implement-user-ns-unshare.patch
user-ns-implement-user-ns-unshare-tidy.patch
user-ns-implement-user-ns-unshare-remove-config_user_ns.patch
remove-find_attach_pid.patch
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
sysctl-c99-convert-coda-ctl_tables-and-remove-binary-sysctls.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support.patch
sysctl-register-the-ocfs2-sysctl-numbers.patch
sysctl-move-init_irq_proc-into-init-main-where-it-belongs.patch
sysctl-move-utsname-sysctls-to-their-own-file.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry.patch
sysctl-remove-support-for-ctl_any.patch
sysctl-remove-support-for-directory-strategy-routines.patch
sysctl-remove-insert_at_head-from-register_sysctl.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl.patch
sysctl-allow-sysctl_perm-to-be-called-from-outside-of-sysctlc.patch
sysctl-reimplement-the-sysctl-proc-support.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
