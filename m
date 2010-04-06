From: akpm@linux-foundation.org
Subject: + mn10300-use-asm-generic-scatterlisth.patch added to -mm tree
Date: Tue, 06 Apr 2010 12:27:08 -0700
Message-ID: <201004061927.o36JR8Ve003510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756527Ab0DFT1Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Apr 2010 15:27:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, dhowells@redhat.com, yasutake.koichi@jp.panasonic.com


The patch titled
     mn10300: use asm-generic/scatterlist.h
has been added to the -mm tree.  Its filename is
     mn10300-use-asm-generic-scatterlisth.patch

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
Subject: mn10300: use asm-generic/scatterlist.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/include/asm/scatterlist.h |   39 -----------------------
 1 file changed, 1 insertion(+), 38 deletions(-)

diff -puN arch/mn10300/include/asm/scatterlist.h~mn10300-use-asm-generic-scatterlisth arch/mn10300/include/asm/scatterlist.h
--- a/arch/mn10300/include/asm/scatterlist.h~mn10300-use-asm-generic-scatterlisth
+++ a/arch/mn10300/include/asm/scatterlist.h
@@ -11,45 +11,8 @@
 #ifndef _ASM_SCATTERLIST_H
 #define _ASM_SCATTERLIST_H
 
-#include <asm/types.h>
-
-/*
- * Drivers must set either ->address or (preferred) page and ->offset
- * to indicate where data must be transferred to/from.
- *
- * Using page is recommended since it handles highmem data as well as
- * low mem. ->address is restricted to data which has a virtual mapping, and
- * it will go away in the future. Updating to page can be automated very
- * easily -- something like
- *
- * sg->address = some_ptr;
- *
- * can be rewritten as
- *
- * sg_set_page(virt_to_page(some_ptr));
- * sg->offset = (unsigned long) some_ptr & ~PAGE_MASK;
- *
- * and that's it. There's no excuse for not highmem enabling YOUR driver. /jens
- */
-struct scatterlist {
-#ifdef CONFIG_DEBUG_SG
-	unsigned long	sg_magic;
-#endif
-	unsigned long	page_link;
-	unsigned int	offset;		/* for highmem, page offset */
-	dma_addr_t	dma_address;
-	unsigned int	length;
-};
+#include <asm-generic/scatterlist.h>
 
 #define ISA_DMA_THRESHOLD (0x00ffffff)
 
-/*
- * These macros should be used after a pci_map_sg call has been done
- * to get bus addresses of each of the SG entries and their lengths.
- * You should only work with the number of sg entries pci_map_sg
- * returns.
- */
-#define sg_dma_address(sg)	((sg)->dma_address)
-#define sg_dma_len(sg)		((sg)->length)
-
 #endif /* _ASM_SCATTERLIST_H */
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

