From: akpm@linux-foundation.org
Subject: [merged]
 lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:41:36 -0700
Message-ID: <53ea6df0./AnKOr/rkDjXhphO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:61031 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080AbaHLTlh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:41:37 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so1920721obb.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:41:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lauraa@codeaurora.org, JBottomley@parallels.com, benh@kernel.crashing.org, fenghua.yu@intel.com, heiko.carstens@de.ibm.com, hpa@zytor.com, linux@arm.linux.org.uk, mingo@redhat.com, paulus@samba.org, schwidefsky@de.ibm.com, sfr@canb.auug.org.au, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/scatterlist: make ARCH_HAS_SG_CHAIN an actual Kconfig
has been removed from the -mm tree.  Its filename was
     lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laura Abbott <lauraa@codeaurora.org>
Subject: lib/scatterlist: make ARCH_HAS_SG_CHAIN an actual Kconfig

Rather than have architectures #define ARCH_HAS_SG_CHAIN in an
architecture specific scatterlist.h, make it a proper Kconfig option and
use that instead.  At same time, remove the header files are are now
mostly useless and just include asm-generic/scatterlist.h.

[sfr@canb.auug.org.au: powerpc files now need asm/dma.h]
Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>			[x86]
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>	[powerpc]
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig                        |    1 +
 arch/arm/include/asm/Kbuild             |    1 +
 arch/arm/include/asm/scatterlist.h      |   12 ------------
 arch/arm64/Kconfig                      |    1 +
 arch/ia64/Kconfig                       |    1 +
 arch/ia64/include/asm/Kbuild            |    1 +
 arch/ia64/include/asm/scatterlist.h     |    7 -------
 arch/powerpc/Kconfig                    |    1 +
 arch/powerpc/include/asm/Kbuild         |    1 +
 arch/powerpc/include/asm/scatterlist.h  |   17 -----------------
 arch/powerpc/mm/dma-noncoherent.c       |    1 +
 arch/powerpc/platforms/44x/warp.c       |    1 +
 arch/powerpc/platforms/52xx/efika.c     |    1 +
 arch/powerpc/platforms/amigaone/setup.c |    1 +
 arch/s390/Kconfig                       |    1 +
 arch/s390/include/asm/Kbuild            |    1 +
 arch/s390/include/asm/scatterlist.h     |    3 ---
 arch/sparc/Kconfig                      |    1 +
 arch/sparc/include/asm/Kbuild           |    1 +
 arch/sparc/include/asm/scatterlist.h    |    8 --------
 arch/um/include/asm/Kbuild              |    1 +
 arch/x86/Kconfig                        |    1 +
 arch/x86/include/asm/Kbuild             |    3 ++-
 arch/x86/include/asm/scatterlist.h      |    8 --------
 include/linux/scatterlist.h             |    2 +-
 include/scsi/scsi.h                     |    2 +-
 lib/Kconfig                             |    7 +++++++
 lib/scatterlist.c                       |    4 ++--
 28 files changed, 30 insertions(+), 60 deletions(-)

diff -puN arch/arm/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/arm/Kconfig
--- a/arch/arm/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/arm/Kconfig
@@ -83,6 +83,7 @@ config ARM
 	  <http://www.arm.linux.org.uk/>.
 
 config ARM_HAS_SG_CHAIN
+	select ARCH_HAS_SG_CHAIN
 	bool
 
 config NEED_SG_DMA_LENGTH
diff -puN arch/arm/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/arm/include/asm/Kbuild
--- a/arch/arm/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/arm/include/asm/Kbuild
@@ -22,6 +22,7 @@ generic-y += poll.h
 generic-y += preempt.h
 generic-y += resource.h
 generic-y += rwsem.h
+generic-y += scatterlist.h
 generic-y += sections.h
 generic-y += segment.h
 generic-y += sembuf.h
diff -puN arch/arm/include/asm/scatterlist.h~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig /dev/null
--- a/arch/arm/include/asm/scatterlist.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef _ASMARM_SCATTERLIST_H
-#define _ASMARM_SCATTERLIST_H
-
-#ifdef CONFIG_ARM_HAS_SG_CHAIN
-#define ARCH_HAS_SG_CHAIN
-#endif
-
-#include <asm/memory.h>
-#include <asm/types.h>
-#include <asm-generic/scatterlist.h>
-
-#endif /* _ASMARM_SCATTERLIST_H */
diff -puN arch/arm64/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/arm64/Kconfig
@@ -1,6 +1,7 @@
 config ARM64
 	def_bool y
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
+	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_SUPPORTS_ATOMIC_RMW
diff -puN arch/ia64/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/ia64/Kconfig
@@ -28,6 +28,7 @@ config IA64
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_VIRT_CPU_ACCOUNTING
+	select ARCH_HAS_SG_CHAIN
 	select VIRT_TO_BUS
 	select ARCH_DISCARD_MEMBLOCK
 	select GENERIC_IRQ_PROBE
diff -puN arch/ia64/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/ia64/include/asm/Kbuild
--- a/arch/ia64/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/ia64/include/asm/Kbuild
@@ -5,5 +5,6 @@ generic-y += hash.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
 generic-y += preempt.h
+generic-y += scatterlist.h
 generic-y += trace_clock.h
 generic-y += vtime.h
diff -puN arch/ia64/include/asm/scatterlist.h~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig /dev/null
--- a/arch/ia64/include/asm/scatterlist.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _ASM_IA64_SCATTERLIST_H
-#define _ASM_IA64_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-#define ARCH_HAS_SG_CHAIN
-
-#endif /* _ASM_IA64_SCATTERLIST_H */
diff -puN arch/powerpc/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/powerpc/Kconfig
@@ -111,6 +111,7 @@ config PPC
 	select HAVE_DMA_API_DEBUG
 	select HAVE_OPROFILE
 	select HAVE_DEBUG_KMEMLEAK
+	select ARCH_HAS_SG_CHAIN
 	select GENERIC_ATOMIC64 if PPC32
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select HAVE_PERF_EVENTS
diff -puN arch/powerpc/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/powerpc/include/asm/Kbuild
--- a/arch/powerpc/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/powerpc/include/asm/Kbuild
@@ -4,5 +4,6 @@ generic-y += hash.h
 generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += rwsem.h
+generic-y += scatterlist.h
 generic-y += trace_clock.h
 generic-y += vtime.h
diff -puN arch/powerpc/include/asm/scatterlist.h~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig /dev/null
--- a/arch/powerpc/include/asm/scatterlist.h
+++ /dev/null
@@ -1,17 +0,0 @@
-#ifndef _ASM_POWERPC_SCATTERLIST_H
-#define _ASM_POWERPC_SCATTERLIST_H
-/*
- * Copyright (C) 2001 PPC64 Team, IBM Corp
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#include <asm/dma.h>
-#include <asm-generic/scatterlist.h>
-
-#define ARCH_HAS_SG_CHAIN
-
-#endif /* _ASM_POWERPC_SCATTERLIST_H */
diff -puN arch/powerpc/mm/dma-noncoherent.c~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/powerpc/mm/dma-noncoherent.c
--- a/arch/powerpc/mm/dma-noncoherent.c~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/powerpc/mm/dma-noncoherent.c
@@ -33,6 +33,7 @@
 #include <linux/export.h>
 
 #include <asm/tlbflush.h>
+#include <asm/dma.h>
 
 #include "mmu_decl.h"
 
diff -puN arch/powerpc/platforms/44x/warp.c~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/powerpc/platforms/44x/warp.c
--- a/arch/powerpc/platforms/44x/warp.c~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/powerpc/platforms/44x/warp.c
@@ -25,6 +25,7 @@
 #include <asm/time.h>
 #include <asm/uic.h>
 #include <asm/ppc4xx.h>
+#include <asm/dma.h>
 
 
 static __initdata struct of_device_id warp_of_bus[] = {
diff -puN arch/powerpc/platforms/52xx/efika.c~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/powerpc/platforms/52xx/efika.c
--- a/arch/powerpc/platforms/52xx/efika.c~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/powerpc/platforms/52xx/efika.c
@@ -13,6 +13,7 @@
 #include <generated/utsrelease.h>
 #include <linux/pci.h>
 #include <linux/of.h>
+#include <asm/dma.h>
 #include <asm/prom.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
diff -puN arch/powerpc/platforms/amigaone/setup.c~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/powerpc/platforms/amigaone/setup.c
--- a/arch/powerpc/platforms/amigaone/setup.c~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/powerpc/platforms/amigaone/setup.c
@@ -24,6 +24,7 @@
 #include <asm/i8259.h>
 #include <asm/time.h>
 #include <asm/udbg.h>
+#include <asm/dma.h>
 
 extern void __flush_disable_L1(void);
 
diff -puN arch/s390/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/s390/Kconfig
--- a/arch/s390/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/s390/Kconfig
@@ -145,6 +145,7 @@ config S390
 	select TTY
 	select VIRT_CPU_ACCOUNTING
 	select VIRT_TO_BUS
+	select ARCH_HAS_SG_CHAIN
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
diff -puN arch/s390/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/s390/include/asm/Kbuild
--- a/arch/s390/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/s390/include/asm/Kbuild
@@ -4,4 +4,5 @@ generic-y += clkdev.h
 generic-y += hash.h
 generic-y += mcs_spinlock.h
 generic-y += preempt.h
+generic-y += scatterlist.h
 generic-y += trace_clock.h
diff -puN arch/s390/include/asm/scatterlist.h~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig /dev/null
--- a/arch/s390/include/asm/scatterlist.h
+++ /dev/null
@@ -1,3 +0,0 @@
-#include <asm-generic/scatterlist.h>
-
-#define ARCH_HAS_SG_CHAIN
diff -puN arch/sparc/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/sparc/Kconfig
@@ -42,6 +42,7 @@ config SPARC
 	select MODULES_USE_ELF_RELA
 	select ODD_RT_SIGACTION
 	select OLD_SIGSUSPEND
+	select ARCH_HAS_SG_CHAIN
 
 config SPARC32
 	def_bool !64BIT
diff -puN arch/sparc/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/sparc/include/asm/Kbuild
--- a/arch/sparc/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/sparc/include/asm/Kbuild
@@ -15,6 +15,7 @@ generic-y += mcs_spinlock.h
 generic-y += module.h
 generic-y += mutex.h
 generic-y += preempt.h
+generic-y += scatterlist.h
 generic-y += serial.h
 generic-y += trace_clock.h
 generic-y += types.h
diff -puN arch/sparc/include/asm/scatterlist.h~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig /dev/null
--- a/arch/sparc/include/asm/scatterlist.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _SPARC_SCATTERLIST_H
-#define _SPARC_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#define ARCH_HAS_SG_CHAIN
-
-#endif /* !(_SPARC_SCATTERLIST_H) */
diff -puN arch/um/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/um/include/asm/Kbuild
--- a/arch/um/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/um/include/asm/Kbuild
@@ -21,6 +21,7 @@ generic-y += param.h
 generic-y += pci.h
 generic-y += percpu.h
 generic-y += preempt.h
+generic-y += scatterlist.h
 generic-y += sections.h
 generic-y += switch_to.h
 generic-y += topology.h
diff -puN arch/x86/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/x86/Kconfig
--- a/arch/x86/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/x86/Kconfig
@@ -96,6 +96,7 @@ config X86
 	select IRQ_FORCED_THREADING
 	select HAVE_BPF_JIT if X86_64
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
+	select ARCH_HAS_SG_CHAIN
 	select CLKEVT_I8253
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
diff -puN arch/x86/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/x86/include/asm/Kbuild
--- a/arch/x86/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/x86/include/asm/Kbuild
@@ -5,6 +5,7 @@ genhdr-y += unistd_64.h
 genhdr-y += unistd_x32.h
 
 generic-y += clkdev.h
-generic-y += early_ioremap.h
 generic-y += cputime.h
+generic-y += early_ioremap.h
 generic-y += mcs_spinlock.h
+generic-y += scatterlist.h
diff -puN arch/x86/include/asm/scatterlist.h~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig /dev/null
--- a/arch/x86/include/asm/scatterlist.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _ASM_X86_SCATTERLIST_H
-#define _ASM_X86_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#define ARCH_HAS_SG_CHAIN
-
-#endif /* _ASM_X86_SCATTERLIST_H */
diff -puN include/linux/scatterlist.h~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig include/linux/scatterlist.h
--- a/include/linux/scatterlist.h~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/include/linux/scatterlist.h
@@ -136,7 +136,7 @@ static inline void sg_set_buf(struct sca
 static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
 			    struct scatterlist *sgl)
 {
-#ifndef ARCH_HAS_SG_CHAIN
+#ifndef CONFIG_ARCH_HAS_SG_CHAIN
 	BUG();
 #endif
 
diff -puN include/scsi/scsi.h~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig include/scsi/scsi.h
--- a/include/scsi/scsi.h~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/include/scsi/scsi.h
@@ -31,7 +31,7 @@ enum scsi_timeouts {
  * Like SCSI_MAX_SG_SEGMENTS, but for archs that have sg chaining. This limit
  * is totally arbitrary, a setting of 2048 will get you at least 8mb ios.
  */
-#ifdef ARCH_HAS_SG_CHAIN
+#ifdef CONFIG_ARCH_HAS_SG_CHAIN
 #define SCSI_MAX_SG_CHAIN_SEGMENTS	2048
 #else
 #define SCSI_MAX_SG_CHAIN_SEGMENTS	SCSI_MAX_SG_SEGMENTS
diff -puN lib/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig lib/Kconfig
--- a/lib/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/lib/Kconfig
@@ -508,4 +508,11 @@ config UCS2_STRING
 
 source "lib/fonts/Kconfig"
 
+#
+# sg chaining option
+#
+
+config ARCH_HAS_SG_CHAIN
+	def_bool n
+
 endmenu
diff -puN lib/scatterlist.c~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig lib/scatterlist.c
--- a/lib/scatterlist.c~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/lib/scatterlist.c
@@ -73,7 +73,7 @@ EXPORT_SYMBOL(sg_nents);
  **/
 struct scatterlist *sg_last(struct scatterlist *sgl, unsigned int nents)
 {
-#ifndef ARCH_HAS_SG_CHAIN
+#ifndef CONFIG_ARCH_HAS_SG_CHAIN
 	struct scatterlist *ret = &sgl[nents - 1];
 #else
 	struct scatterlist *sg, *ret = NULL;
@@ -255,7 +255,7 @@ int __sg_alloc_table(struct sg_table *ta
 
 	if (nents == 0)
 		return -EINVAL;
-#ifndef ARCH_HAS_SG_CHAIN
+#ifndef CONFIG_ARCH_HAS_SG_CHAIN
 	if (WARN_ON_ONCE(nents > max_ents))
 		return -EINVAL;
 #endif
_

Patches currently in -mm which might be from lauraa@codeaurora.org are

origin.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

