From: akpm@linux-foundation.org
Subject: [merged] x86-only-compile-8237a-if-config_isa_dma_api-is-enabled.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:40:50 -0700
Message-ID: <201103232044.p2NKiQQQ029072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933479Ab1CWUou (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:44:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, bjorn.helgaas@hp.com, hpa@zytor.com, linux@arm.linux.org.uk, mingo@redhat.com, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     x86: only compile 8237A if CONFIG_ISA_DMA_API is enabled
has been removed from the -mm tree.  Its filename was
     x86-only-compile-8237a-if-config_isa_dma_api-is-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: only compile 8237A if CONFIG_ISA_DMA_API is enabled
From: David Rientjes <rientjes@google.com>

8237A utilizes the interface provided by CONFIG_ISA_DMA_API, specifically
claim_dma_lock() and release_dma_lock().  Thus, there's a strict
dependency on the config option and the module should only be loaded if
the kernel supports ISA-style DMA.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/Makefile~x86-only-compile-8237a-if-config_isa_dma_api-is-enabled arch/x86/kernel/Makefile
--- a/arch/x86/kernel/Makefile~x86-only-compile-8237a-if-config_isa_dma_api-is-enabled
+++ a/arch/x86/kernel/Makefile
@@ -41,7 +41,7 @@ obj-$(CONFIG_X86_32)	+= sys_i386_32.o i3
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
 obj-y			+= bootflag.o e820.o
-obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
+obj-y			+= pci-dma.o quirks.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
 obj-y			+= tsc.o io_delay.o rtc.o
 obj-y			+= pci-iommu_table.o
@@ -55,6 +55,7 @@ obj-$(CONFIG_X86_32)		+= tls.o
 obj-$(CONFIG_IA32_EMULATION)	+= tls.o
 obj-y				+= step.o
 obj-$(CONFIG_INTEL_TXT)		+= tboot.o
+obj-$(CONFIG_ISA_DMA_API)	+= i8237.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
 obj-y				+= acpi/
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
jbd-remove-dependency-on-__gfp_nofail.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-give-current-access-to-memory-reserves-if-its-trying-to-die.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist-v2.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_attch.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc-v2.patch
cpuset-hold-callback_mutex-in-cpuset_clone.patch
sysctl-add-some-missing-input-constraint-checks.patch

