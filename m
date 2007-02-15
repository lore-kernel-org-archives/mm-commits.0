From: akpm@linux-foundation.org
Subject: - sysctl-c99-convert-ctl_tables-entries-in-arch-ppc-kernel-ppc_htabc.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:49:38 -0800
Message-ID: <200702150849.l1F8ncSX025143@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40124 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965464AbXBOItl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:49:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     sysctl: C99 convert ctl_tables entries in arch/ppc/kernel/ppc_htab.c
has been removed from the -mm tree.  Its filename was
     sysctl-c99-convert-ctl_tables-entries-in-arch-ppc-kernel-ppc_htabc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: C99 convert ctl_tables entries in arch/ppc/kernel/ppc_htab.c
From: Eric W. Biederman <ebiederm@xmission.com>

And make the mode of the kernel directory 0555 no one is allowed to write to
sysctl directories.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ppc/kernel/ppc_htab.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN arch/ppc/kernel/ppc_htab.c~sysctl-c99-convert-ctl_tables-entries-in-arch-ppc-kernel-ppc_htabc arch/ppc/kernel/ppc_htab.c
--- a/arch/ppc/kernel/ppc_htab.c~sysctl-c99-convert-ctl_tables-entries-in-arch-ppc-kernel-ppc_htabc
+++ a/arch/ppc/kernel/ppc_htab.c
@@ -442,11 +442,16 @@ static ctl_table htab_ctl_table[]={
 		.mode		= 0644,
 		.proc_handler	= &proc_dol2crvec,
 	},
-	{ 0, },
+	{}
 };
 static ctl_table htab_sysctl_root[] = {
-	{ 1, "kernel", NULL, 0, 0755, htab_ctl_table, },
- 	{ 0,},
+	{
+		.ctl_name	= CTL_KERN,
+		.procname	= "kernel",
+		.mode		= 0555,
+		.child		= htab_ctl_table,
+	},
+	{}
 };
 
 static int __init
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
