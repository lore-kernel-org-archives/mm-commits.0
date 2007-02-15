From: akpm@linux-foundation.org
Subject: - sysctl-x86_64-remove-unnecessary-use-of-insert_at_head.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:49:44 -0800
Message-ID: <200702150849.l1F8nifR025153@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40135 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965466AbXBOIts (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:49:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     sysctl: x86_64: remove unnecessary use of insert_at_head
has been removed from the -mm tree.  Its filename was
     sysctl-x86_64-remove-unnecessary-use-of-insert_at_head.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: x86_64: remove unnecessary use of insert_at_head
From: Eric W. Biederman <ebiederm@xmission.com>

The only sysctl x86_64 provides are not provided elsewhere, so insert_at_head
is unnecessary.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/ia32/ia32_binfmt.c |    2 +-
 arch/x86_64/mm/init.c          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/ia32/ia32_binfmt.c~sysctl-x86_64-remove-unnecessary-use-of-insert_at_head arch/x86_64/ia32/ia32_binfmt.c
--- a/arch/x86_64/ia32/ia32_binfmt.c~sysctl-x86_64-remove-unnecessary-use-of-insert_at_head
+++ a/arch/x86_64/ia32/ia32_binfmt.c
@@ -357,7 +357,7 @@ static ctl_table abi_root_table2[] = { 
 
 static __init int ia32_binfmt_init(void)
 { 
-	register_sysctl_table(abi_root_table2, 1);
+	register_sysctl_table(abi_root_table2, 0);
 	return 0;
 }
 __initcall(ia32_binfmt_init);
diff -puN arch/x86_64/mm/init.c~sysctl-x86_64-remove-unnecessary-use-of-insert_at_head arch/x86_64/mm/init.c
--- a/arch/x86_64/mm/init.c~sysctl-x86_64-remove-unnecessary-use-of-insert_at_head
+++ a/arch/x86_64/mm/init.c
@@ -724,7 +724,7 @@ static ctl_table debug_root_table2[] = {
 
 static __init int x8664_sysctl_init(void)
 { 
-	register_sysctl_table(debug_root_table2, 1);
+	register_sysctl_table(debug_root_table2, 0);
 	return 0;
 }
 __initcall(x8664_sysctl_init);
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
