From: akpm@linux-foundation.org
Subject: - sysctl-c99-convert-arch-ia64-sn-kernel-xpc_mainc.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:49:17 -0800
Message-ID: <200702150849.l1F8nHCt025114@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40097 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965417AbXBOItV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:49:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: C99 Convert arch/ia64/sn/kernel/xpc_main.c
has been removed from the -mm tree.  Its filename was
     sysctl-c99-convert-arch-ia64-sn-kernel-xpc_mainc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: C99 Convert arch/ia64/sn/kernel/xpc_main.c
From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/sn/kernel/xpc_main.c |   86 +++++++++++++------------------
 1 file changed, 38 insertions(+), 48 deletions(-)

diff -puN arch/ia64/sn/kernel/xpc_main.c~sysctl-c99-convert-arch-ia64-sn-kernel-xpc_mainc arch/ia64/sn/kernel/xpc_main.c
--- a/arch/ia64/sn/kernel/xpc_main.c~sysctl-c99-convert-arch-ia64-sn-kernel-xpc_mainc
+++ a/arch/ia64/sn/kernel/xpc_main.c
@@ -101,67 +101,57 @@ static int xpc_disengage_request_max_tim
 
 static ctl_table xpc_sys_xpc_hb_dir[] = {
 	{
-		CTL_UNNUMBERED,
-		"hb_interval",
-		&xpc_hb_interval,
-		sizeof(int),
-		0644,
-		NULL,
-		&proc_dointvec_minmax,
-		&sysctl_intvec,
-		NULL,
-		&xpc_hb_min_interval,
-		&xpc_hb_max_interval
+		.ctl_name 	= CTL_UNNUMBERED,
+		.procname	= "hb_interval",
+		.data		= &xpc_hb_interval,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &xpc_hb_min_interval,
+		.extra2		= &xpc_hb_max_interval
 	},
 	{
-		CTL_UNNUMBERED,
-		"hb_check_interval",
-		&xpc_hb_check_interval,
-		sizeof(int),
-		0644,
-		NULL,
-		&proc_dointvec_minmax,
-		&sysctl_intvec,
-		NULL,
-		&xpc_hb_check_min_interval,
-		&xpc_hb_check_max_interval
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "hb_check_interval",
+		.data		= &xpc_hb_check_interval,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &xpc_hb_check_min_interval,
+		.extra2		= &xpc_hb_check_max_interval
 	},
-	{0}
+	{}
 };
 static ctl_table xpc_sys_xpc_dir[] = {
 	{
-		CTL_UNNUMBERED,
-		"hb",
-		NULL,
-		0,
-		0555,
-		xpc_sys_xpc_hb_dir
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "hb",
+		.mode		= 0555,
+		.child		= xpc_sys_xpc_hb_dir
 	},
 	{
-		CTL_UNNUMBERED,
-		"disengage_request_timelimit",
-		&xpc_disengage_request_timelimit,
-		sizeof(int),
-		0644,
-		NULL,
-		&proc_dointvec_minmax,
-		&sysctl_intvec,
-		NULL,
-		&xpc_disengage_request_min_timelimit,
-		&xpc_disengage_request_max_timelimit
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "disengage_request_timelimit",
+		.data		= &xpc_disengage_request_timelimit,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &xpc_disengage_request_min_timelimit,
+		.extra2		= &xpc_disengage_request_max_timelimit
 	},
-	{0}
+	{}
 };
 static ctl_table xpc_sys_dir[] = {
 	{
-		CTL_UNNUMBERED,
-		"xpc",
-		NULL,
-		0,
-		0555,
-		xpc_sys_xpc_dir
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "xpc",
+		.mode		= 0555,
+		.child		= xpc_sys_xpc_dir
 	},
-	{0}
+	{}
 };
 static struct ctl_table_header *xpc_sysctl;
 
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
