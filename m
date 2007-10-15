From: akpm@linux-foundation.org
Subject: - sparc-fix-build-due-to-termios-changes.patch removed from -mm tree
Date: Mon, 15 Oct 2007 16:42:16 -0700
Message-ID: <200710152342.l9FNgHXV031377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36271 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754006AbXJOXmT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 19:42:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     SPARC: fix build due to termios changes
has been removed from the -mm tree.  Its filename was
     sparc-fix-build-due-to-termios-changes.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: SPARC: fix build due to termios changes
From: David Miller <davem@davemloft.net>

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-sparc/termios.h   |    5 +++++
 include/asm-sparc64/termios.h |    5 +++++
 2 files changed, 10 insertions(+)

diff -puN include/asm-sparc64/termios.h~sparc-fix-build-due-to-termios-changes include/asm-sparc64/termios.h
--- a/include/asm-sparc64/termios.h~sparc-fix-build-due-to-termios-changes
+++ a/include/asm-sparc64/termios.h
@@ -145,6 +145,11 @@ struct winsize {
 	err; \
 })
 
+#define user_termios_to_kernel_termios_1(k, u) \
+	user_termios_to_kernel_termios(k, u)
+#define kernel_termios_to_user_termios_1(u, k) \
+	kernel_termios_to_user_termios(u, k)
+
 #endif	/* __KERNEL__ */
 
 #endif /* _SPARC64_TERMIOS_H */
diff -puN include/asm-sparc/termios.h~sparc-fix-build-due-to-termios-changes include/asm-sparc/termios.h
--- a/include/asm-sparc/termios.h~sparc-fix-build-due-to-termios-changes
+++ a/include/asm-sparc/termios.h
@@ -142,6 +142,11 @@ struct winsize {
 	0; \
 })
 
+#define user_termios_to_kernel_termios_1(k, u) \
+	user_termios_to_kernel_termios(k, u)
+#define kernel_termios_to_user_termios_1(u, k) \
+	kernel_termios_to_user_termios(u, k)
+
 #endif	/* __KERNEL__ */
 
 #endif /* _SPARC_TERMIOS_H */
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
git-net.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
net-dccp-fix-link-error-with-config_sysctl.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
git-scsi-misc.patch
git-block.patch
sparc-fix-build-due-to-termios-changes.patch
sparc-support-for-new-termios.patch
sparc-support-for-new-termios-checkpatch-fixes.patch
git-wireless.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-sparc64.patch
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
remove-dma_cache_wbackinvwback_inv-functions.patch
lockdep-annotate-kprobes-irq-fiddling.patch
lockdep-annotate-kprobes-irq-fiddling-fix.patch
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
update-dma-mapping-documentation.patch
sysctl-fix-neighbour-table-sysctls.patch
sysctl-ipv6-route-flushing-kill-binary-path.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
sysctl-remove-broken-netfilter-binary-sysctls.patch
sysctl-update-sysctl_checks-list-of-binary-paths.patch
bitops-introduce-lock-ops.patch
