From: akpm@linux-foundation.org
Subject: - sysctl-c99-convert-arch-frv-kernel-pmc.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:49:10 -0800
Message-ID: <200702150849.l1F8nANQ025105@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40090 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965441AbXBOItS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:49:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: C99 convert arch/frv/kernel/pm.c
has been removed from the -mm tree.  Its filename was
     sysctl-c99-convert-arch-frv-kernel-pmc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: C99 convert arch/frv/kernel/pm.c
From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/pm.c |   50 +++++++++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff -puN arch/frv/kernel/pm.c~sysctl-c99-convert-arch-frv-kernel-pmc arch/frv/kernel/pm.c
--- a/arch/frv/kernel/pm.c~sysctl-c99-convert-arch-frv-kernel-pmc
+++ a/arch/frv/kernel/pm.c
@@ -401,17 +401,53 @@ static int cm_sysctl(ctl_table *table, i
 
 static struct ctl_table pm_table[] =
 {
-	{CTL_PM_SUSPEND, "suspend", NULL, 0, 0200, NULL, &sysctl_pm_do_suspend},
-	{CTL_PM_CMODE, "cmode", &clock_cmode_current, sizeof(int), 0644, NULL, &cmode_procctl, &cmode_sysctl, NULL},
-	{CTL_PM_P0, "p0", &clock_p0_current, sizeof(int), 0644, NULL, &p0_procctl, &p0_sysctl, NULL},
-	{CTL_PM_CM, "cm", &clock_cm_current, sizeof(int), 0644, NULL, &cm_procctl, &cm_sysctl, NULL},
-	{0}
+	{
+		.ctl_name	= CTL_PM_SUSPEND,
+		.procname	= "suspend",
+		.data		= NULL,
+		.maxlen		= 0,
+		.mode		= 0200,
+		.proc_handler	= &sysctl_pm_do_suspend,
+	},
+	{
+		.ctl_name	= CTL_PM_CMODE,
+		.procname	= "cmode",
+		.data		= &clock_cmode_current,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &cmode_procctl,
+		.strategy	= &cmode_sysctl,
+	},
+	{
+		.ctl_name	= CTL_PM_P0,
+		.procname	= "p0",
+		.data		= &clock_p0_current,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &p0_procctl,
+		.strategy	= &p0_sysctl,
+	},
+	{
+		.ctl_name	= CTL_PM_CM,
+		.procname	= "cm",
+		.data		= &clock_cm_current,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &cm_procctl,
+		.strategy	= &cm_sysctl,
+	},
+	{ .ctl_name = 0}
 };
 
 static struct ctl_table pm_dir_table[] =
 {
-	{CTL_PM, "pm", NULL, 0, 0555, pm_table},
-	{0}
+	{
+		.ctl_name	= CTL_PM,
+		.procname	= "pm",
+		.mode		= 0555,
+		.child		= pm_table,
+	},
+	{ .ctl_name = 0}
 };
 
 /*
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
