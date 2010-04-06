From: akpm@linux-foundation.org
Subject: + parisc-use-asm-generic-scatterlisth.patch added to -mm tree
Date: Tue, 06 Apr 2010 12:27:11 -0700
Message-ID: <201004061927.o36JRCiw003513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756527Ab0DFT1b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Apr 2010 15:27:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, deller@gmx.de, jejb@parisc-linux.org, kyle@mcmartin.ca


The patch titled
     parisc: use asm-generic/scatterlist.h
has been added to the -mm tree.  Its filename is
     parisc-use-asm-generic-scatterlisth.patch

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
Subject: parisc: use asm-generic/scatterlist.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

parisc uses iova and iova_length in scatterlist structure instead of
dma_address and dma_length.  However, the accessor are used so we can
convert parisc to use asm-generic/scatterlist.h easily.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/Kconfig                   |    3 +++
 arch/parisc/include/asm/scatterlist.h |   20 ++------------------
 2 files changed, 5 insertions(+), 18 deletions(-)

diff -puN arch/parisc/Kconfig~parisc-use-asm-generic-scatterlisth arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~parisc-use-asm-generic-scatterlisth
+++ a/arch/parisc/Kconfig
@@ -94,6 +94,9 @@ config STACKTRACE_SUPPORT
 config NEED_DMA_MAP_STATE
 	def_bool y
 
+config NEED_SG_DMA_LENGTH
+	def_bool y
+
 config ISA_DMA_API
 	bool
 
diff -puN arch/parisc/include/asm/scatterlist.h~parisc-use-asm-generic-scatterlisth arch/parisc/include/asm/scatterlist.h
--- a/arch/parisc/include/asm/scatterlist.h~parisc-use-asm-generic-scatterlisth
+++ a/arch/parisc/include/asm/scatterlist.h
@@ -3,25 +3,9 @@
 
 #include <asm/page.h>
 #include <asm/types.h>
-
-struct scatterlist {
-#ifdef CONFIG_DEBUG_SG
-	unsigned long sg_magic;
-#endif
-	unsigned long page_link;
-	unsigned int offset;
-
-	unsigned int length;
-
-	/* an IOVA can be 64-bits on some PA-Risc platforms. */
-	dma_addr_t iova;	/* I/O Virtual Address */
-	__u32      iova_length; /* bytes mapped */
-};
-
-#define sg_virt_addr(sg) ((unsigned long)sg_virt(sg))
-#define sg_dma_address(sg) ((sg)->iova)
-#define sg_dma_len(sg)     ((sg)->iova_length)
+#include <asm-generic/scatterlist.h>
 
 #define ISA_DMA_THRESHOLD (~0UL)
+#define sg_virt_addr(sg) ((unsigned long)sg_virt(sg))
 
 #endif /* _ASM_PARISC_SCATTERLIST_H */
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

