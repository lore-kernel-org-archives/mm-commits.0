From: akpm@linux-foundation.org
Subject: - sysctl-c99-convert-ctl_tables-in-arch-x86_64-mm-initc.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:49:50 -0800
Message-ID: <200702150849.l1F8noK9025162@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40154 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965481AbXBOItx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:49:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     sysctl: C99 convert ctl_tables in arch/x86_64/mm/init.c
has been removed from the -mm tree.  Its filename was
     sysctl-c99-convert-ctl_tables-in-arch-x86_64-mm-initc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: C99 convert ctl_tables in arch/x86_64/mm/init.c
From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/init.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff -puN arch/x86_64/mm/init.c~sysctl-c99-convert-ctl_tables-in-arch-x86_64-mm-initc arch/x86_64/mm/init.c
--- a/arch/x86_64/mm/init.c~sysctl-c99-convert-ctl_tables-in-arch-x86_64-mm-initc
+++ a/arch/x86_64/mm/init.c
@@ -711,15 +711,25 @@ int kern_addr_valid(unsigned long addr) 
 extern int exception_trace, page_fault_trace;
 
 static ctl_table debug_table2[] = {
-	{ 99, "exception-trace", &exception_trace, sizeof(int), 0644, NULL,
-	  proc_dointvec },
-	{ 0, }
+	{
+		.ctl_name	= 99,
+		.procname	= "exception-trace",
+		.data		= &exception_trace,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec
+	},
+	{}
 }; 
 
 static ctl_table debug_root_table2[] = { 
-	{ .ctl_name = CTL_DEBUG, .procname = "debug", .mode = 0555, 
-	   .child = debug_table2 }, 
-	{ 0 }, 
+	{
+		.ctl_name = CTL_DEBUG,
+		.procname = "debug",
+		.mode = 0555,
+		.child = debug_table2
+	},
+	{}
 }; 
 
 static __init int x8664_sysctl_init(void)
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
