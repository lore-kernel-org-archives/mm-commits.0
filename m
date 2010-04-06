From: akpm@linux-foundation.org
Subject: + avr32-use-asm-generic-scatterlisth.patch added to -mm tree
Date: Tue, 06 Apr 2010 12:26:46 -0700
Message-ID: <201004061926.o36JQkNL003474@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753224Ab0DFT0w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Apr 2010 15:26:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, hskinnemoen@atmel.com


The patch titled
     avr32: use asm-generic/scatterlist.h
has been added to the -mm tree.  Its filename is
     avr32-use-asm-generic-scatterlisth.patch

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
Subject: avr32: use asm-generic/scatterlist.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/include/asm/scatterlist.h |   20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff -puN arch/avr32/include/asm/scatterlist.h~avr32-use-asm-generic-scatterlisth arch/avr32/include/asm/scatterlist.h
--- a/arch/avr32/include/asm/scatterlist.h~avr32-use-asm-generic-scatterlisth
+++ a/arch/avr32/include/asm/scatterlist.h
@@ -1,25 +1,7 @@
 #ifndef __ASM_AVR32_SCATTERLIST_H
 #define __ASM_AVR32_SCATTERLIST_H
 
-#include <asm/types.h>
-
-struct scatterlist {
-#ifdef CONFIG_DEBUG_SG
-   unsigned long	sg_magic;
-#endif
-    unsigned long	page_link;
-    unsigned int	offset;
-    dma_addr_t		dma_address;
-    unsigned int	length;
-};
-
-/* These macros should be used after a pci_map_sg call has been done
- * to get bus addresses of each of the SG entries and their lengths.
- * You should only work with the number of sg entries pci_map_sg
- * returns.
- */
-#define sg_dma_address(sg)	((sg)->dma_address)
-#define sg_dma_len(sg)		((sg)->length)
+#include <asm-generic/scatterlist.h>
 
 #define ISA_DMA_THRESHOLD (0xffffffff)
 
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

