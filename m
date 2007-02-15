From: akpm@linux-foundation.org
Subject: - sysctl-c99-convert-ctl_tables-in-arch-x86_64-kernel-vsyscallc.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:49:48 -0800
Message-ID: <200702150849.l1F8nmZ2025159@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40149 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965478AbXBOItw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:49:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     sysctl: C99 convert ctl_tables in arch/x86_64/kernel/vsyscall.c
has been removed from the -mm tree.  Its filename was
     sysctl-c99-convert-ctl_tables-in-arch-x86_64-kernel-vsyscallc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: C99 convert ctl_tables in arch/x86_64/kernel/vsyscall.c
From: Eric W. Biederman <ebiederm@xmission.com>

Basically everything was done but I removed all element initializers from the
trailing entries to make it clear the entire last entry should be zero filled.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/vsyscall.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/kernel/vsyscall.c~sysctl-c99-convert-ctl_tables-in-arch-x86_64-kernel-vsyscallc arch/x86_64/kernel/vsyscall.c
--- a/arch/x86_64/kernel/vsyscall.c~sysctl-c99-convert-ctl_tables-in-arch-x86_64-kernel-vsyscallc
+++ a/arch/x86_64/kernel/vsyscall.c
@@ -235,13 +235,13 @@ static ctl_table kernel_table2[] = {
 	  .data = &sysctl_vsyscall, .maxlen = sizeof(int), .mode = 0644,
 	  .strategy = vsyscall_sysctl_nostrat,
 	  .proc_handler = vsyscall_sysctl_change },
-	{ 0, }
+	{}
 };
 
 static ctl_table kernel_root_table2[] = {
 	{ .ctl_name = CTL_KERN, .procname = "kernel", .mode = 0555,
 	  .child = kernel_table2 },
-	{ 0 },
+	{}
 };
 
 #endif
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
