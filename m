From: akpm@linux-foundation.org
Subject: + x86-only-compile-8237a-if-config_isa_dma_api-is-enabled.patch added to -mm tree
Date: Thu, 03 Feb 2011 12:16:39 -0800
Message-ID: <201102032016.p13KGdun022365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751548Ab1BCURf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 15:17:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, bjorn.helgaas@hp.com, hpa@zytor.com, linux@arm.linux.org.uk, mingo@redhat.com, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     x86: only compile 8237A if CONFIG_ISA_DMA_API is enabled
has been added to the -mm tree.  Its filename is
     x86-only-compile-8237a-if-config_isa_dma_api-is-enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -41,12 +41,13 @@ obj-$(CONFIG_X86_32)	+= sys_i386_32.o i3
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
 obj-y			+= bootflag.o e820.o
-obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
+obj-y			+= pci-dma.o quirks.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
 obj-y			+= tsc.o io_delay.o rtc.o
 obj-y			+= pci-iommu_table.o
 obj-y			+= resource.o
 
+obj-$(CONFIG_ISA_DMA_API)	+= i8237.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
 obj-y				+= process.o
 obj-y				+= i387.o xsave.o
_

Patches currently in -mm which might be from rientjes@google.com are

x86-numa-add-error-handling-for-bad-cpu-to-node-mappings.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill.patch
oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure.patch
pnp-only-assign-ioresource_dma-if-config_isa_dma_api-is-enabled.patch
x86-only-compile-8237a-if-config_isa_dma_api-is-enabled.patch
x86-only-compile-floppy-driver-if-config_isa_dma_api-is-enabled.patch
x86-allow-config_isa_dma_api-to-be-disabled.patch
jbd-remove-dependency-on-__gfp_nofail.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch

