From: akpm@linux-foundation.org
Subject: [merged] x86-allow-config_isa_dma_api-to-be-disabled.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:40:54 -0700
Message-ID: <201103232044.p2NKiUIb029078@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933478Ab1CWUou (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:44:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, bjorn.helgaas@hp.com, hpa@zytor.com, linux@arm.linux.org.uk, mingo@redhat.com, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     x86: allow CONFIG_ISA_DMA_API to be disabled
has been removed from the -mm tree.  Its filename was
     x86-allow-config_isa_dma_api-to-be-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -123,7 +123,7 @@ config NEED_SG_DMA_LENGTH
 	def_bool y
 
 config GENERIC_ISA_DMA
-	def_bool y
+	def_bool ISA_DMA_API
 
 config GENERIC_IOMAP
 	def_bool y
@@ -2002,9 +2002,13 @@ source "drivers/pci/pcie/Kconfig"
 
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

