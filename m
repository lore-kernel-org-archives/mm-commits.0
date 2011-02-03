From: akpm@linux-foundation.org
Subject: + x86-allow-config_isa_dma_api-to-be-disabled.patch added to -mm tree
Date: Thu, 03 Feb 2011 12:16:43 -0800
Message-ID: <201102032016.p13KGheh022375@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751051Ab1BCURc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 15:17:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, bjorn.helgaas@hp.com, hpa@zytor.com, linux@arm.linux.org.uk, mingo@redhat.com, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     x86: allow CONFIG_ISA_DMA_API to be disabled
has been added to the -mm tree.  Its filename is
     x86-allow-config_isa_dma_api-to-be-disabled.patch

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
Subject: x86: allow CONFIG_ISA_DMA_API to be disabled
From: David Rientjes <rientjes@google.com>

Not all 64-bit systems require ISA-style DMA, so allow it to be
configurable.  x86 utilizes the generic ISA DMA allocator from
kernel/dma.c, so require it only when CONFIG_ISA_DMA_API is enabled.

Disabling CONFIG_ISA_DMA_API is dependent on x86_64 since those machines
do not have ISA slots and benefit the most from disabling the option (and
on CONFIG_EXPERT as required by H.  Peter Anvin).

When disabled, this also avoids declaring claim_dma_lock(),
release_dma_lock(), request_dma(), and free_dma() since those interfaces
will no longer be provided.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig           |   10 +++++++---
 arch/x86/include/asm/dma.h |    6 +++++-
 2 files changed, 12 insertions(+), 4 deletions(-)

diff -puN arch/x86/Kconfig~x86-allow-config_isa_dma_api-to-be-disabled arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-allow-config_isa_dma_api-to-be-disabled
+++ a/arch/x86/Kconfig
@@ -120,7 +120,7 @@ config NEED_SG_DMA_LENGTH
 	def_bool y
 
 config GENERIC_ISA_DMA
-	def_bool y
+	def_bool ISA_DMA_API
 
 config GENERIC_IOMAP
 	def_bool y
@@ -2001,9 +2001,13 @@ source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pci/Kconfig"
 
-# x86_64 have no ISA slots, but do have ISA-style DMA.
+# x86_64 have no ISA slots, but can have ISA-style DMA.
 config ISA_DMA_API
-	def_bool y
+	bool "ISA-style DMA support" if (X86_64 && EXPERT)
+	default y
+	help
+	  Enables ISA-style DMA support for devices requiring such controllers.
+	  If unsure, say Y.
 
 if X86_32
 
diff -puN arch/x86/include/asm/dma.h~x86-allow-config_isa_dma_api-to-be-disabled arch/x86/include/asm/dma.h
--- a/arch/x86/include/asm/dma.h~x86-allow-config_isa_dma_api-to-be-disabled
+++ a/arch/x86/include/asm/dma.h
@@ -151,6 +151,7 @@
 #define DMA_AUTOINIT		0x10
 
 
+#ifdef CONFIG_ISA_DMA_API
 extern spinlock_t  dma_spin_lock;
 
 static inline unsigned long claim_dma_lock(void)
@@ -164,6 +165,7 @@ static inline void release_dma_lock(unsi
 {
 	spin_unlock_irqrestore(&dma_spin_lock, flags);
 }
+#endif /* CONFIG_ISA_DMA_API */
 
 /* enable/disable a specific DMA channel */
 static inline void enable_dma(unsigned int dmanr)
@@ -303,9 +305,11 @@ static inline int get_dma_residue(unsign
 }
 
 
-/* These are in kernel/dma.c: */
+/* These are in kernel/dma.c because x86 uses CONFIG_GENERIC_ISA_DMA */
+#ifdef CONFIG_ISA_DMA_API
 extern int request_dma(unsigned int dmanr, const char *device_id);
 extern void free_dma(unsigned int dmanr);
+#endif
 
 /* From PCI */
 
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

