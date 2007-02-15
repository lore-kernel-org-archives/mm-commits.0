From: akpm@linux-foundation.org
Subject: - sysctl-mips-au1000-remove-sys_sysctl-support.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:49:22 -0800
Message-ID: <200702150849.l1F8nMuu025120@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40411 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965588AbXBOIwj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:52:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     sysctl: mips/au1000: remove sys_sysctl support
has been removed from the -mm tree.  Its filename was
     sysctl-mips-au1000-remove-sys_sysctl-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: mips/au1000: remove sys_sysctl support
From: Eric W. Biederman <ebiederm@xmission.com>

The assignment of binary numbers for sys_sysctl use was in shambles and
despite requiring methods.  Nothing was implemented on the sys_sysctl side.

So this patch gives a mercy killing to the sys_sysctl support for
powermanagment on mips/au1000.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/au1000/common/power.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff -puN arch/mips/au1000/common/power.c~sysctl-mips-au1000-remove-sys_sysctl-support arch/mips/au1000/common/power.c
--- a/arch/mips/au1000/common/power.c~sysctl-mips-au1000-remove-sys_sysctl-support
+++ a/arch/mips/au1000/common/power.c
@@ -62,12 +62,6 @@ extern unsigned long save_local_and_disa
 extern void restore_local_and_enable(int controller, unsigned long mask);
 extern void local_enable_irq(unsigned int irq_nr);
 
-/* Quick acpi hack. This will have to change! */
-#define	CTL_ACPI 9999
-#define	ACPI_S1_SLP_TYP 19
-#define	ACPI_SLEEP 21
-
-
 static DEFINE_SPINLOCK(pm_lock);
 
 /* We need to save/restore a bunch of core registers that are
@@ -425,14 +419,14 @@ static int pm_do_freq(ctl_table * ctl, i
 
 
 static struct ctl_table pm_table[] = {
-	{ACPI_S1_SLP_TYP, "suspend", NULL, 0, 0600, NULL, &pm_do_suspend},
-	{ACPI_SLEEP, "sleep", NULL, 0, 0600, NULL, &pm_do_sleep},
-	{CTL_ACPI, "freq", NULL, 0, 0600, NULL, &pm_do_freq},
+	{CTL_UNNUMBERED, "suspend", NULL, 0, 0600, NULL, &pm_do_suspend},
+	{CTL_UNNUMBERED, "sleep", NULL, 0, 0600, NULL, &pm_do_sleep},
+	{CTL_UNNUMBERED, "freq", NULL, 0, 0600, NULL, &pm_do_freq},
 	{0}
 };
 
 static struct ctl_table pm_dir_table[] = {
-	{CTL_ACPI, "pm", NULL, 0, 0555, pm_table},
+	{CTL_UNNUMBERED, "pm", NULL, 0, 0555, pm_table},
 	{0}
 };
 
@@ -441,7 +435,7 @@ static struct ctl_table pm_dir_table[] =
  */
 static int __init pm_init(void)
 {
-	register_sysctl_table(pm_dir_table, 1);
+	register_sysctl_table(pm_dir_table, 0);
 	return 0;
 }
 
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
