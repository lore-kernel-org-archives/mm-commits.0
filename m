From: akpm@linux-foundation.org
Subject: - fix-futex-compat-bug.patch removed from -mm tree
Date: Mon, 10 Sep 2007 12:29:15 -0700
Message-ID: <200709101929.l8AJTFmS006821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46680 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757297AbXIJTaA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Sep 2007 15:30:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, arnd@arndb.de, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Fix futex compat bug
has been removed from the -mm tree.  Its filename was
     fix-futex-compat-bug.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Fix futex compat bug
From: David Miller <davem@davemloft.net>

The futex list traversal on the compat side appears to have
a bug.

It's loop termination condition compares:

	while (compat_ptr(uentry) != &head->list)

But that can't be right because "uentry" has the special
"pi" indicator bit still potentially set at bit 0.  This
is cleared by fetch_robust_entry() into the "entry"
return value.

What this seems to mean is that the list won't terminate
when list iteration gets back to the the head.  And we'll
also process the list head like a normal entry, which could
cause all kinds of problems.

So we should check for equality with "entry".  That pointer
is of the non-compat type so we have to do a little casting
to keep the compiler and sparse happy.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex_compat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/futex_compat.c~fix-futex-compat-bug kernel/futex_compat.c
--- a/kernel/futex_compat.c~fix-futex-compat-bug
+++ a/kernel/futex_compat.c
@@ -64,7 +64,7 @@ void compat_exit_robust_list(struct task
 	if (upending)
 		handle_futex_death((void __user *)pending + futex_offset, curr, pip);
 
-	while (compat_ptr(uentry) != &head->list) {
+	while (entry != (struct robust_list *) &head->list) {
 		/*
 		 * A pending lock might already be on the list, so
 		 * dont process it twice:
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
fix-futex-compat-bug.patch
cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
git-powerpc.patch
infiniband-work-around-gcc-slub-problem.patch
git-net.patch
net-atm-lecc-printk-warning-fix.patch
e1000e-incorporate-napi_struct-changes-from-net-2624git.patch
git-scsi-misc.patch
git-block.patch
try-parent-numa_node-at-first-before-using-default.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
i386-optimize-memset-of-6-and-8-bytes.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
sparc64-sparsemem_vmemmap-support.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch
i-oat-new-device-ids.patch
i-oat-rename-the-source-file.patch
i-oat-code-cleanup-from-checkpatch-output.patch
i-oat-split-pci-startup-from-dma-handling-code.patch
i-oat-add-support-for-msi-and-msi-x.patch
dca-add-direct-cache-access-driver.patch
i-oat-add-dca-services.patch
unexport-asm-shmparamh.patch
kconfig-make-instrumentation-support-non-experimental.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
sysctl-fix-neighbour-table-sysctls.patch
sysctl-ipv6-route-flushing-kill-binary-path.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
sysctl-remove-broken-netfilter-binary-sysctls.patch
sysctl-update-sysctl_checks-list-of-binary-paths.patch
bitops-introduce-lock-ops.patch
