From: akpm@linux-foundation.org
Subject: + cris-use-asm-generic-scatterlisth.patch added to -mm tree
Date: Tue, 06 Apr 2010 12:26:49 -0700
Message-ID: <201004061926.o36JQnja003477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753224Ab0DFT1B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Apr 2010 15:27:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     cris: use asm-generic/scatterlist.h
has been added to the -mm tree.  Its filename is
     cris-use-asm-generic-scatterlisth.patch

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
Subject: cris: use asm-generic/scatterlist.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/include/asm/scatterlist.h |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff -puN arch/cris/include/asm/scatterlist.h~cris-use-asm-generic-scatterlisth arch/cris/include/asm/scatterlist.h
--- a/arch/cris/include/asm/scatterlist.h~cris-use-asm-generic-scatterlisth
+++ a/arch/cris/include/asm/scatterlist.h
@@ -1,22 +1,7 @@
 #ifndef __ASM_CRIS_SCATTERLIST_H
 #define __ASM_CRIS_SCATTERLIST_H
 
-struct scatterlist {
-#ifdef CONFIG_DEBUG_SG
-	unsigned long sg_magic;
-#endif
-	char *  address;    /* Location data is to be transferred to */
-	unsigned int length;
-
-	/* The following is i386 highmem junk - not used by us */
-	unsigned long page_link;
-	unsigned int offset;/* for highmem, page offset */
-
-};
-
-#define sg_dma_address(sg)	((sg)->address)
-#define sg_dma_len(sg)		((sg)->length)
-/* i386 junk */
+#include <asm-generic/scatterlist.h>
 
 #define ISA_DMA_THRESHOLD (0x1fffffff)
 
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

