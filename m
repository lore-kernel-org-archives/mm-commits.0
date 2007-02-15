From: akpm@linux-foundation.org
Subject: - sysctl-c99-convert-arch-ia64-kernel-perfmon-and-remove-abi-breakage.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:49:19 -0800
Message-ID: <200702150849.l1F8nJHc025117@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40488 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965615AbXBOIzq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:55:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, eranian@hpl.hp.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: C99 convert arch/ia64/kernel/perfmon and remove ABI breakage
has been removed from the -mm tree.  Its filename was
     sysctl-c99-convert-arch-ia64-kernel-perfmon-and-remove-abi-breakage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: C99 convert arch/ia64/kernel/perfmon and remove ABI breakage
From: Eric W. Biederman <ebiederm@xmission.com>

This convters the sysctl ctl_tables to use C99 initializers.  While I was
looking at it I discovered it was using a portion of the sysctl binary
addresses space under CTL_KERN KERN_OSTYPE which was completely inappropriate.
 So I completely removed all of the sysctl binary names, to remove and avoid
the ABI conflict.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Stephane Eranian <eranian@hpl.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/perfmon.c |   56 +++++++++++++++++++++++++++++------
 1 file changed, 47 insertions(+), 9 deletions(-)

diff -puN arch/ia64/kernel/perfmon.c~sysctl-c99-convert-arch-ia64-kernel-perfmon-and-remove-abi-breakage arch/ia64/kernel/perfmon.c
--- a/arch/ia64/kernel/perfmon.c~sysctl-c99-convert-arch-ia64-kernel-perfmon-and-remove-abi-breakage
+++ a/arch/ia64/kernel/perfmon.c
@@ -521,19 +521,57 @@ pfm_sysctl_t pfm_sysctl;
 EXPORT_SYMBOL(pfm_sysctl);
 
 static ctl_table pfm_ctl_table[]={
-	{1, "debug", &pfm_sysctl.debug, sizeof(int), 0666, NULL, &proc_dointvec, NULL,},
-	{2, "debug_ovfl", &pfm_sysctl.debug_ovfl, sizeof(int), 0666, NULL, &proc_dointvec, NULL,},
-	{3, "fastctxsw", &pfm_sysctl.fastctxsw, sizeof(int), 0600, NULL, &proc_dointvec, NULL,},
-	{4, "expert_mode", &pfm_sysctl.expert_mode, sizeof(int), 0600, NULL, &proc_dointvec, NULL,},
-	{ 0, },
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "debug",
+		.data		= &pfm_sysctl.debug,
+		.maxlen		= sizeof(int),
+		.mode		= 0666,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "debug_ovfl",
+		.data		= &pfm_sysctl.debug_ovfl,
+		.maxlen		= sizeof(int),
+		.mode		= 0666,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "fastctxsw",
+		.data		= &pfm_sysctl.fastctxsw,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	=  &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "expert_mode",
+		.data		= &pfm_sysctl.expert_mode,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= &proc_dointvec,
+	},
+	{}
 };
 static ctl_table pfm_sysctl_dir[] = {
-	{1, "perfmon", NULL, 0, 0755, pfm_ctl_table, },
- 	{0,},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "perfmon",
+		.mode		= 0755,
+		.child		= pfm_ctl_table,
+	},
+ 	{}
 };
 static ctl_table pfm_sysctl_root[] = {
-	{1, "kernel", NULL, 0, 0755, pfm_sysctl_dir, },
- 	{0,},
+	{
+		.ctl_name	= CTL_KERN,
+		.procname	= "kernel",
+		.mode		= 0755,
+		.child		= pfm_sysctl_dir,
+	},
+ 	{}
 };
 static struct ctl_table_header *pfm_sysctl_header;
 
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
