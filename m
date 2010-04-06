From: akpm@linux-foundation.org
Subject: + asm-generic-add-need_sg_dma_length-to-define-sg_dma_len.patch added to -mm tree
Date: Mon, 05 Apr 2010 17:00:45 -0700
Message-ID: <201004060000.o3600jcB017005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756856Ab0DFABM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 20:01:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, arnd@arndb.de, benh@kernel.crashing.org, hpa@zytor.com, ink@jurassic.park.msu.ru, linux@arm.linux.org.uk, mattst88@gmail.com, mingo@elte.hu, paulus@samba.org, rth@twiddle.net, tglx@linutronix.de


The patch titled
     asm-generic: add NEED_SG_DMA_LENGTH to define sg_dma_len()
has been added to the -mm tree.  Its filename is
     asm-generic-add-need_sg_dma_length-to-define-sg_dma_len.patch

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
Subject: asm-generic: add NEED_SG_DMA_LENGTH to define sg_dma_len()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

There are only two ways to define sg_dma_len(); use sg->dma_length or
sg->length.  This patch introduces NEED_SG_DMA_LENGTH that enables
architectures to choose sg->dma_length or sg->length.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig                    |    3 +++
 arch/sh/Kconfig                      |    3 +++
 arch/sparc/Kconfig                   |    3 +++
 arch/sparc/include/asm/scatterlist.h |    2 --
 arch/x86/Kconfig                     |    3 +++
 include/asm-generic/scatterlist.h    |   13 +++++--------
 6 files changed, 17 insertions(+), 10 deletions(-)

diff -puN arch/ia64/Kconfig~asm-generic-add-need_sg_dma_length-to-define-sg_dma_len arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~asm-generic-add-need_sg_dma_length-to-define-sg_dma_len
+++ a/arch/ia64/Kconfig
@@ -56,6 +56,9 @@ config MMU
 config NEED_DMA_MAP_STATE
 	def_bool y
 
+config NEED_SG_DMA_LENGTH
+	def_bool y
+
 config SWIOTLB
        bool
 
diff -puN arch/sh/Kconfig~asm-generic-add-need_sg_dma_length-to-define-sg_dma_len arch/sh/Kconfig
--- a/arch/sh/Kconfig~asm-generic-add-need_sg_dma_length-to-define-sg_dma_len
+++ a/arch/sh/Kconfig
@@ -183,6 +183,9 @@ config DMA_NONCOHERENT
 config NEED_DMA_MAP_STATE
 	def_bool DMA_NONCOHERENT
 
+config NEED_SG_DMA_LENGTH
+	def_bool y
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff -puN arch/sparc/Kconfig~asm-generic-add-need_sg_dma_length-to-define-sg_dma_len arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~asm-generic-add-need_sg_dma_length-to-define-sg_dma_len
+++ a/arch/sparc/Kconfig
@@ -127,6 +127,9 @@ config ZONE_DMA
 config NEED_DMA_MAP_STATE
 	def_bool y
 
+config NEED_SG_DMA_LENGTH
+	def_bool y
+
 config GENERIC_ISA_DMA
 	bool
 	default y if SPARC32
diff -puN arch/sparc/include/asm/scatterlist.h~asm-generic-add-need_sg_dma_length-to-define-sg_dma_len arch/sparc/include/asm/scatterlist.h
--- a/arch/sparc/include/asm/scatterlist.h~asm-generic-add-need_sg_dma_length-to-define-sg_dma_len
+++ a/arch/sparc/include/asm/scatterlist.h
@@ -1,8 +1,6 @@
 #ifndef _SPARC_SCATTERLIST_H
 #define _SPARC_SCATTERLIST_H
 
-#define sg_dma_len(sg)     	((sg)->dma_length)
-
 #define ISA_DMA_THRESHOLD	(~0UL)
 
 #include <asm-generic/scatterlist.h>
diff -puN arch/x86/Kconfig~asm-generic-add-need_sg_dma_length-to-define-sg_dma_len arch/x86/Kconfig
--- a/arch/x86/Kconfig~asm-generic-add-need_sg_dma_length-to-define-sg_dma_len
+++ a/arch/x86/Kconfig
@@ -102,6 +102,9 @@ config SBUS
 config NEED_DMA_MAP_STATE
        def_bool (X86_64 || DMAR || DMA_API_DEBUG)
 
+config NEED_SG_DMA_LENGTH
+	def_bool X86_64
+
 config GENERIC_ISA_DMA
 	def_bool y
 
diff -puN include/asm-generic/scatterlist.h~asm-generic-add-need_sg_dma_length-to-define-sg_dma_len include/asm-generic/scatterlist.h
--- a/include/asm-generic/scatterlist.h~asm-generic-add-need_sg_dma_length-to-define-sg_dma_len
+++ a/include/asm-generic/scatterlist.h
@@ -11,7 +11,9 @@ struct scatterlist {
 	unsigned int	offset;
 	unsigned int	length;
 	dma_addr_t	dma_address;
+#ifdef CONFIG_NEED_SG_DMA_LENGTH
 	unsigned int	dma_length;
+#endif
 };
 
 /*
@@ -22,17 +24,12 @@ struct scatterlist {
  * is 0.
  */
 #define sg_dma_address(sg)	((sg)->dma_address)
-#ifndef sg_dma_len
-/*
- * Normally, you have an iommu on 64 bit machines, but not on 32 bit
- * machines. Architectures that are differnt should override this.
- */
-#if __BITS_PER_LONG == 64
+
+#ifdef CONFIG_NEED_SG_DMA_LENGTH
 #define sg_dma_len(sg)		((sg)->dma_length)
 #else
 #define sg_dma_len(sg)		((sg)->length)
-#endif /* 64 bit */
-#endif /* sg_dma_len */
+#endif
 
 #define ARCH_HAS_SG_CHAIN
 
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
arch-x86-kernel-pci-nommuc-dont-initialise-sg-dma_length.patch
x86_32-use-asm-generic-scatterlisth.patch
powerpc-use-asm-generic-scatterlisth.patch
arm-use-asm-generic-scatterlisth.patch
alpha-use-asm-generic-scatterlisth.patch

