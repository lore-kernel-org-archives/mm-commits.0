From: akpm@linux-foundation.org
Subject: + sparc-fix-build-due-to-termios-changes.patch added to -mm tree
Date: Fri, 14 Sep 2007 19:35:40 -0700
Message-ID: <200709150235.l8F2Ze7i003377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44235 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755405AbXIOCfn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 22:35:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net


The patch titled
     SPARC: fix build due to termios changes
has been added to the -mm tree.  Its filename is
     sparc-fix-build-due-to-termios-changes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

futex_compat-fix-list-traversal-bugs.patch
tty-termios-locking-functions-break-with-new-termios.patch
sparc64-and-others-fix-tty_ioctlc-build.patch
cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
git-powerpc.patch
infiniband-work-around-gcc-slub-problem.patch
git-net.patch
git-net-fix-pcnet32c.patch
net-atm-lecc-printk-warning-fix.patch
net-myri10ge-force-select-inet_lro.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
pktgen-srcmac-fix.patch
net-sctp-socketc-make-3-variables-static.patch
e1000e-incorporate-napi_struct-changes-from-net-2624git.patch
git-scsi-misc.patch
git-block.patch
sparc-fix-build-due-to-termios-changes.patch
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
futex_compat-simplify-pointer-magic.patch
futex_compat-update-to-match-native-version.patch
remove-dma_cache_wbackinvwback_inv-functions.patch
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
