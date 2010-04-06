From: akpm@linux-foundation.org
Subject: + asm-generic-remove-arch_has_sg_chain-in-scatterlisth.patch added to -mm tree
Date: Tue, 06 Apr 2010 12:26:44 -0700
Message-ID: <201004061926.o36JQj9Y003471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753224Ab0DFT0t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Apr 2010 15:26:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp


The patch titled
     asm-generic: remove ARCH_HAS_SG_CHAIN in scatterlist.h
has been added to the -mm tree.  Its filename is
     asm-generic-remove-arch_has_sg_chain-in-scatterlisth.patch

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
Subject: asm-generic: remove ARCH_HAS_SG_CHAIN in scatterlist.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

There are more architectures that don't support ARCH_HAS_SG_CHAIN than
those that support it.  This removes removes ARCH_HAS_SG_CHAIN in
asm-generic/scatterlist.h and lets arhictectures to define it.

It's clearer than defining ARCH_HAS_SG_CHAIN asm-generic/scatterlist.h and
undefing it in arhictectures that don't support it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/scatterlist.h      |    4 +---
 arch/arm/include/asm/scatterlist.h        |    3 ---
 arch/ia64/include/asm/scatterlist.h       |    4 ++--
 arch/microblaze/include/asm/scatterlist.h |    4 ++--
 arch/powerpc/include/asm/scatterlist.h    |    1 +
 arch/sparc/include/asm/scatterlist.h      |    5 +++--
 arch/x86/include/asm/scatterlist.h        |    5 +++--
 include/asm-generic/scatterlist.h         |    2 --
 8 files changed, 12 insertions(+), 16 deletions(-)

diff -puN arch/alpha/include/asm/scatterlist.h~asm-generic-remove-arch_has_sg_chain-in-scatterlisth arch/alpha/include/asm/scatterlist.h
--- a/arch/alpha/include/asm/scatterlist.h~asm-generic-remove-arch_has_sg_chain-in-scatterlisth
+++ a/arch/alpha/include/asm/scatterlist.h
@@ -1,10 +1,8 @@
 #ifndef _ALPHA_SCATTERLIST_H
 #define _ALPHA_SCATTERLIST_H
 
-#define ISA_DMA_THRESHOLD (~0UL)
-
 #include <asm-generic/scatterlist.h>
 
-#undef ARCH_HAS_SG_CHAIN
+#define ISA_DMA_THRESHOLD (~0UL)
 
 #endif /* !(_ALPHA_SCATTERLIST_H) */
diff -puN arch/arm/include/asm/scatterlist.h~asm-generic-remove-arch_has_sg_chain-in-scatterlisth arch/arm/include/asm/scatterlist.h
--- a/arch/arm/include/asm/scatterlist.h~asm-generic-remove-arch_has_sg_chain-in-scatterlisth
+++ a/arch/arm/include/asm/scatterlist.h
@@ -3,9 +3,6 @@
 
 #include <asm/memory.h>
 #include <asm/types.h>
-
 #include <asm-generic/scatterlist.h>
 
-#undef ARCH_HAS_SG_CHAIN
-
 #endif /* _ASMARM_SCATTERLIST_H */
diff -puN arch/ia64/include/asm/scatterlist.h~asm-generic-remove-arch_has_sg_chain-in-scatterlisth arch/ia64/include/asm/scatterlist.h
--- a/arch/ia64/include/asm/scatterlist.h~asm-generic-remove-arch_has_sg_chain-in-scatterlisth
+++ a/arch/ia64/include/asm/scatterlist.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_IA64_SCATTERLIST_H
 #define _ASM_IA64_SCATTERLIST_H
 
+#include <asm-generic/scatterlist.h>
 /*
  * It used to be that ISA_DMA_THRESHOLD had something to do with the
  * DMA-limits of ISA-devices.  Nowadays, its only remaining use (apart
@@ -10,7 +11,6 @@
  * that's 4GB - 1.
  */
 #define ISA_DMA_THRESHOLD	0xffffffff
-
-#include <asm-generic/scatterlist.h>
+#define ARCH_HAS_SG_CHAIN
 
 #endif /* _ASM_IA64_SCATTERLIST_H */
diff -puN arch/microblaze/include/asm/scatterlist.h~asm-generic-remove-arch_has_sg_chain-in-scatterlisth arch/microblaze/include/asm/scatterlist.h
--- a/arch/microblaze/include/asm/scatterlist.h~asm-generic-remove-arch_has_sg_chain-in-scatterlisth
+++ a/arch/microblaze/include/asm/scatterlist.h
@@ -1,3 +1,3 @@
-#define ISA_DMA_THRESHOLD	(~0UL)
-
 #include <asm-generic/scatterlist.h>
+
+#define ISA_DMA_THRESHOLD	(~0UL)
diff -puN arch/powerpc/include/asm/scatterlist.h~asm-generic-remove-arch_has_sg_chain-in-scatterlisth arch/powerpc/include/asm/scatterlist.h
--- a/arch/powerpc/include/asm/scatterlist.h~asm-generic-remove-arch_has_sg_chain-in-scatterlisth
+++ a/arch/powerpc/include/asm/scatterlist.h
@@ -15,5 +15,6 @@
 #ifdef __powerpc64__
 #define ISA_DMA_THRESHOLD	(~0UL)
 #endif
+#define ARCH_HAS_SG_CHAIN
 
 #endif /* _ASM_POWERPC_SCATTERLIST_H */
diff -puN arch/sparc/include/asm/scatterlist.h~asm-generic-remove-arch_has_sg_chain-in-scatterlisth arch/sparc/include/asm/scatterlist.h
--- a/arch/sparc/include/asm/scatterlist.h~asm-generic-remove-arch_has_sg_chain-in-scatterlisth
+++ a/arch/sparc/include/asm/scatterlist.h
@@ -1,8 +1,9 @@
 #ifndef _SPARC_SCATTERLIST_H
 #define _SPARC_SCATTERLIST_H
 
-#define ISA_DMA_THRESHOLD	(~0UL)
-
 #include <asm-generic/scatterlist.h>
 
+#define ISA_DMA_THRESHOLD	(~0UL)
+#define ARCH_HAS_SG_CHAIN
+
 #endif /* !(_SPARC_SCATTERLIST_H) */
diff -puN arch/x86/include/asm/scatterlist.h~asm-generic-remove-arch_has_sg_chain-in-scatterlisth arch/x86/include/asm/scatterlist.h
--- a/arch/x86/include/asm/scatterlist.h~asm-generic-remove-arch_has_sg_chain-in-scatterlisth
+++ a/arch/x86/include/asm/scatterlist.h
@@ -1,8 +1,9 @@
 #ifndef _ASM_X86_SCATTERLIST_H
 #define _ASM_X86_SCATTERLIST_H
 
-#define ISA_DMA_THRESHOLD (0x00ffffff)
-
 #include <asm-generic/scatterlist.h>
 
+#define ISA_DMA_THRESHOLD (0x00ffffff)
+#define ARCH_HAS_SG_CHAIN
+
 #endif /* _ASM_X86_SCATTERLIST_H */
diff -puN include/asm-generic/scatterlist.h~asm-generic-remove-arch_has_sg_chain-in-scatterlisth include/asm-generic/scatterlist.h
--- a/include/asm-generic/scatterlist.h~asm-generic-remove-arch_has_sg_chain-in-scatterlisth
+++ a/include/asm-generic/scatterlist.h
@@ -31,6 +31,4 @@ struct scatterlist {
 #define sg_dma_len(sg)		((sg)->length)
 #endif
 
-#define ARCH_HAS_SG_CHAIN
-
 #endif /* __ASM_GENERIC_SCATTERLIST_H */
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch
asm-generic-remove-isa_dma_threshold-in-scatterlisth.patch
asm-generic-add-need_sg_dma_length-to-define-sg_dma_len.patch
x86_32-use-asm-generic-scatterlisth.patch
powerpc-use-asm-generic-scatterlisth.patch
arm-use-asm-generic-scatterlisth.patch
alpha-use-asm-generic-scatterlisth.patch
asm-generic-remove-arch_has_sg_chain-in-scatterlisth.patch
avr32-use-asm-generic-scatterlisth.patch
cris-use-asm-generic-scatterlisth.patch
h8300-use-asm-generic-scatterlisth.patch
m32r-use-use-asm-generic-scatterlisth.patch
m68k-use-asm-generic-scatterlisth.patch
mips-use-use-asm-generic-scatterlisth.patch
xtensa-use-use-asm-generic-scatterlisth.patch
blackfin-use-use-asm-generic-scatterlisth.patch
frv-use-asm-generic-scatterlisth.patch
mn10300-use-asm-generic-scatterlisth.patch
parisc-use-asm-generic-scatterlisth.patch

