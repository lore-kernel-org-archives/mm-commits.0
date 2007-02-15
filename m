From: akpm@linux-foundation.org
Subject: - sysctl-c99-convert-arch-mips-lasat-sysctlc-and-remove-abi-breakage.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:49:26 -0800
Message-ID: <200702150849.l1F8nQ4Q025129@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40414 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965592AbXBOIwo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:52:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     sysctl: C99 convert arch/mips/lasat/sysctl.c and remove ABI breakage
has been removed from the -mm tree.  Its filename was
     sysctl-c99-convert-arch-mips-lasat-sysctlc-and-remove-abi-breakage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

origin.patch
powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
git-v9fs.patch
x86_64-irq-simplfy-__assign_irq_vector.patch
x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
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
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
