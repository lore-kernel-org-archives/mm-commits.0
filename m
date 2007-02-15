From: akpm@linux-foundation.org
Subject: - sysctl-c99-convert-arch-sh64-kernel-trapsc-and-remove-abi-breakage.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:49:41 -0800
Message-ID: <200702150849.l1F8nf9i025150@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40129 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965469AbXBOItp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:49:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     sysctl: C99 convert arch/sh64/kernel/traps.c and remove ABI breakage
has been removed from the -mm tree.  Its filename was
     sysctl-c99-convert-arch-sh64-kernel-trapsc-and-remove-abi-breakage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: C99 convert arch/sh64/kernel/traps.c and remove ABI breakage
From: Eric W. Biederman <ebiederm@xmission.com>

While doing the C99 conversion I notices that the top level sh64 directory was
using the binary number for CTL_KERN.  That is a no-no so I removed the
support for the sysctl binary interface only leaving sysctl /proc support.

At least the sysctl tables were placed at the end of the list so user space
did not see this mistake.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh64/kernel/traps.c |   49 ++++++++++++++++++++++++++++---------
 1 file changed, 38 insertions(+), 11 deletions(-)

diff -puN arch/sh64/kernel/traps.c~sysctl-c99-convert-arch-sh64-kernel-trapsc-and-remove-abi-breakage arch/sh64/kernel/traps.c
--- a/arch/sh64/kernel/traps.c~sysctl-c99-convert-arch-sh64-kernel-trapsc-and-remove-abi-breakage
+++ a/arch/sh64/kernel/traps.c
@@ -910,25 +910,52 @@ static int misaligned_fixup(struct pt_re
 }
 
 static ctl_table unaligned_table[] = {
-	{1, "kernel_reports", &kernel_mode_unaligned_fixup_count,
-		sizeof(int), 0644, NULL, &proc_dointvec},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "kernel_reports",
+		.data		= &kernel_mode_unaligned_fixup_count,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec
+	},
 #if defined(CONFIG_SH64_USER_MISALIGNED_FIXUP)
-	{2, "user_reports", &user_mode_unaligned_fixup_count,
-		sizeof(int), 0644, NULL, &proc_dointvec},
-	{3, "user_enable", &user_mode_unaligned_fixup_enable,
-		sizeof(int), 0644, NULL, &proc_dointvec},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "user_reports",
+		.data		= &user_mode_unaligned_fixup_count,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "user_enable",
+		.data		= &user_mode_unaligned_fixup_enable,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec},
 #endif
-	{0}
+	{}
 };
 
 static ctl_table unaligned_root[] = {
-	{1, "unaligned_fixup", NULL, 0, 0555, unaligned_table},
-	{0}
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "unaligned_fixup",
+		.mode		= 0555,
+		unaligned_table
+	},
+	{}
 };
 
 static ctl_table sh64_root[] = {
-	{1, "sh64", NULL, 0, 0555, unaligned_root},
-	{0}
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sh64",
+		.mode		= 0555,
+		.child		= unaligned_root
+	},
+	{}
 };
 static struct ctl_table_header *sysctl_header;
 static int __init init_sysctl(void)
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
