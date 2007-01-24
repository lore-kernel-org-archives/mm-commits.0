From: akpm@osdl.org
Subject: + sysctl-c99-convert-arch-mips-lasat-sysctlc-and-remove-abi-breakage.patch added to -mm tree
Date: Tue, 23 Jan 2007 19:13:03 -0800
Message-ID: <200701240313.l0O3D3Ib006900@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49311 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030234AbXAXDQV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 22:16:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, ralf@linux-mips.org


The patch titled
     sysctl: C99 convert arch/mips/lasat/sysctl.c and remove ABI breakage
has been added to the -mm tree.  Its filename is
     sysctl-c99-convert-arch-mips-lasat-sysctlc-and-remove-abi-breakage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: C99 convert arch/mips/lasat/sysctl.c and remove ABI breakage
From: Eric W. Biederman <ebiederm@xmission.com>

While C99 converting the ctl_table initializers I realized that the binary
sysctl numbers were in conflict with the binary values under CTL_KERN. 
Including CTL_KERN KERN_VERSION as used by glibc.  So I just removed the
sysctl binary interface for these values, as it was unsupportable.

Luckily these sysctl were inserted at the end of the sysctl list so this bug
was not visible to userspace.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/mips/lasat/sysctl.c |  145 +++++++++++++++++++++++++++++--------
 1 file changed, 116 insertions(+), 29 deletions(-)

diff -puN arch/mips/lasat/sysctl.c~sysctl-c99-convert-arch-mips-lasat-sysctlc-and-remove-abi-breakage arch/mips/lasat/sysctl.c
--- a/arch/mips/lasat/sysctl.c~sysctl-c99-convert-arch-mips-lasat-sysctlc-and-remove-abi-breakage
+++ a/arch/mips/lasat/sysctl.c
@@ -302,42 +302,129 @@ extern int lasat_boot_to_service;
 #ifdef CONFIG_SYSCTL
 
 static ctl_table lasat_table[] = {
-	{LASAT_CPU_HZ, "cpu-hz", &lasat_board_info.li_cpu_hz, sizeof(int),
-	 0444, NULL, &proc_dointvec, &sysctl_intvec},
-	{LASAT_BUS_HZ, "bus-hz", &lasat_board_info.li_bus_hz, sizeof(int),
-	 0444, NULL, &proc_dointvec, &sysctl_intvec},
-	{LASAT_MODEL, "bmid", &lasat_board_info.li_bmid, sizeof(int),
-	 0444, NULL, &proc_dointvec, &sysctl_intvec},
-	{LASAT_PRID, "prid", &lasat_board_info.li_prid, sizeof(int),
-	 0644, NULL, &proc_lasat_eeprom_value, &sysctl_lasat_eeprom_value},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "cpu-hz",
+		.data		= &lasat_board_info.li_cpu_hz,
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= &proc_dointvec,
+		.strategy	= &sysctl_intvec
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "bus-hz",
+		.data		= &lasat_board_info.li_bus_hz,
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= &proc_dointvec,
+		.strategy	= &sysctl_intvec
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "bmid",
+		.data		= &lasat_board_info.li_bmid,
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= &proc_dointvec,
+		.strategy	= &sysctl_intvec
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "prid",
+		.data		= &lasat_board_info.li_prid,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_lasat_eeprom_value,
+		.strategy	= &sysctl_lasat_eeprom_value
+	},
 #ifdef CONFIG_INET
-	{LASAT_IPADDR, "ipaddr", &lasat_board_info.li_eeprom_info.ipaddr, sizeof(int),
-	 0644, NULL, &proc_lasat_ip, &sysctl_lasat_intvec},
-	{LASAT_NETMASK, "netmask", &lasat_board_info.li_eeprom_info.netmask, sizeof(int),
-	 0644, NULL, &proc_lasat_ip, &sysctl_lasat_intvec},
-	{LASAT_BCAST, "bcastaddr", &lasat_bcastaddr,
-		sizeof(lasat_bcastaddr), 0600, NULL,
-		&proc_dostring, &sysctl_string},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "ipaddr",
+		.data		= &lasat_board_info.li_eeprom_info.ipaddr,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_lasat_ip,
+		.strategy	= &sysctl_lasat_intvec
+	},
+	{
+		.ctl_name	= LASAT_NETMASK,
+		.procname	= "netmask",
+		.data		= &lasat_board_info.li_eeprom_info.netmask,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_lasat_ip,
+		.strategy	= &sysctl_lasat_intvec
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "bcastaddr",
+		.data		= &lasat_bcastaddr,
+		.maxlen		= sizeof(lasat_bcastaddr),
+		.mode		= 0600,
+		.proc_handler	= &proc_dostring,
+		.strategy	= &sysctl_string
+	},
 #endif
-	{LASAT_PASSWORD, "passwd_hash", &lasat_board_info.li_eeprom_info.passwd_hash, sizeof(lasat_board_info.li_eeprom_info.passwd_hash),
-	 0600, NULL, &proc_dolasatstring, &sysctl_lasatstring},
-	{LASAT_SBOOT, "boot-service", &lasat_boot_to_service, sizeof(int),
-	 0644, NULL, &proc_dointvec, &sysctl_intvec},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "passwd_hash",
+		.data		= &lasat_board_info.li_eeprom_info.passwd_hash,
+		.maxlen		= sizeof(lasat_board_info.li_eeprom_info.passwd_hash),
+		.mode		= 0600,
+		.proc_handler	= &proc_dolasatstring,
+		.strategy	= &sysctl_lasatstring
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "boot-service",
+		.data		= &lasat_boot_to_service,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+		.strategy	= &sysctl_intvec
+	},
 #ifdef CONFIG_DS1603
-	{LASAT_RTC, "rtc", &rtctmp, sizeof(int),
-	 0644, NULL, &proc_dolasatrtc, &sysctl_lasat_rtc},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "rtc",
+		.data		= &rtctmp,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dolasatrtc,
+		.strategy	= &sysctl_lasat_rtc
+	},
 #endif
-	{LASAT_NAMESTR, "namestr", &lasat_board_info.li_namestr, sizeof(lasat_board_info.li_namestr),
-	 0444, NULL, &proc_dostring, &sysctl_string},
-	{LASAT_TYPESTR, "typestr", &lasat_board_info.li_typestr, sizeof(lasat_board_info.li_typestr),
-	 0444, NULL, &proc_dostring, &sysctl_string},
-	{0}
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "namestr",
+		.data		= &lasat_board_info.li_namestr,
+		.maxlen		= sizeof(lasat_board_info.li_namestr),
+		.mode		= 0444,
+		.proc_handler	=  &proc_dostring,
+		.strategy	= &sysctl_string
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "typestr",
+		.data		= &lasat_board_info.li_typestr,
+		.maxlen		= sizeof(lasat_board_info.li_typestr),
+		.mode		= 0444,
+		.proc_handler	= &proc_dostring,
+		.strategy	= &sysctl_string
+	},
+	{}
 };
 
-#define CTL_LASAT 1	// CTL_ANY ???
 static ctl_table lasat_root_table[] = {
-	{ CTL_LASAT, "lasat", NULL, 0, 0555, lasat_table },
-	{ 0 }
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "lasat",
+		.mode		=  0555,
+		.child		= lasat_table
+	},
+	{}
 };
 
 static int __init lasat_register_sysctl(void)
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
