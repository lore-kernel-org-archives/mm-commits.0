From: akpm@linux-foundation.org
Subject: + arm-use-asm-generic-scatterlisth.patch added to -mm tree
Date: Mon, 05 Apr 2010 13:50:46 -0700
Message-ID: <201004052050.o35KokYa008379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756368Ab0DEUut (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 16:50:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux@arm.linux.org.uk


The patch titled
     arm: use asm-generic/scatterlist.h
has been added to the -mm tree.  Its filename is
     arm-use-asm-generic-scatterlisth.patch

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
Subject: arm: use asm-generic/scatterlist.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/scatterlist.h |   20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff -puN arch/arm/include/asm/scatterlist.h~arm-use-asm-generic-scatterlisth arch/arm/include/asm/scatterlist.h
--- a/arch/arm/include/asm/scatterlist.h~arm-use-asm-generic-scatterlisth
+++ a/arch/arm/include/asm/scatterlist.h
@@ -4,24 +4,8 @@
 #include <asm/memory.h>
 #include <asm/types.h>
 
-struct scatterlist {
-#ifdef CONFIG_DEBUG_SG
-	unsigned long	sg_magic;
-#endif
-	unsigned long	page_link;
-	unsigned int	offset;		/* buffer offset		 */
-	dma_addr_t	dma_address;	/* dma address			 */
-	unsigned int	length;		/* length			 */
-};
+#include <asm-generic/scatterlist.h>
 
-/*
- * These macros should be used after a pci_map_sg call has been done
- * to get bus addresses of each of the SG entries and their lengths.
- * You should only work with the number of sg entries pci_map_sg
- * returns, or alternatively stop on the first sg_dma_len(sg) which
- * is 0.
- */
-#define sg_dma_address(sg)      ((sg)->dma_address)
-#define sg_dma_len(sg)          ((sg)->length)
+#undef ARCH_HAS_SG_CHAIN
 
 #endif /* _ASMARM_SCATTERLIST_H */
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
powerpc-use-asm-generic-scatterlisth.patch
arm-use-asm-generic-scatterlisth.patch
alpha-use-asm-generic-scatterlisth.patch

