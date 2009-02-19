From: akpm@linux-foundation.org
Subject: + replace-all-dma_48bit_mask-macro-with-dma_bit_mask48.patch added to -mm tree
Date: Thu, 19 Feb 2009 15:14:23 -0800
Message-ID: <200902192314.n1JNENr4029786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753516AbZBSXO4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 18:14:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yanghy@cn.fujitsu.com


The patch titled
     dma-mapping: replace all DMA_48BIT_MASK macro with DMA_BIT_MASK(48)
has been added to the -mm tree.  Its filename is
     replace-all-dma_48bit_mask-macro-with-dma_bit_mask48.patch

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
Subject: dma-mapping: replace all DMA_48BIT_MASK macro with DMA_BIT_MASK(48)
From: Yang Hongyang <yanghy@cn.fujitsu.com>

Replace all DMA_48BIT_MASK macro with DMA_BIT_MASK(48)

Signed-off-by: Yang Hongyang<yanghy@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/dl2k.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/dl2k.c~replace-all-dma_48bit_mask-macro-with-dma_bit_mask48 drivers/net/dl2k.c
--- a/drivers/net/dl2k.c~replace-all-dma_48bit_mask-macro-with-dma_bit_mask48
+++ a/drivers/net/dl2k.c
@@ -714,7 +714,7 @@ rio_interrupt (int irq, void *dev_instan
 
 static inline dma_addr_t desc_to_dma(struct netdev_desc *desc)
 {
-	return le64_to_cpu(desc->fraginfo) & DMA_48BIT_MASK;
+	return le64_to_cpu(desc->fraginfo) & DMA_BIT_MASK(48);
 }
 
 static void
_

Patches currently in -mm which might be from yanghy@cn.fujitsu.com are

replace-all-dma_64bit_mask-macro-with-dma_bit_mask64.patch
replace-all-dma_48bit_mask-macro-with-dma_bit_mask48.patch
replace-all-dma_40bit_mask-macro-with-dma_bit_mask40.patch
replace-all-dma_39bit_mask-macro-with-dma_bit_mask39.patch
replace-all-dma_35bit_mask-macro-with-dma_bit_mask35.patch
replace-all-dma_32bit_mask-macro-with-dma_bit_mask32.patch
replace-all-dma_31bit_mask-macro-with-dma_bit_mask31.patch
replace-all-dma_30bit_mask-macro-with-dma_bit_mask30.patch
replace-all-dma_28bit_mask-macro-with-dma_bit_mask28.patch
replace-all-dma_24bit_mask-macro-with-dma_bit_mask24.patch
update-the-old-macro-dma_nbit_mask-related-documentations.patch

