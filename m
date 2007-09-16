From: akpm@linux-foundation.org
Subject: + introduce-dma_mask_none-as-a-signal-for-unable-to-do.patch added to -mm tree
Date: Sun, 16 Sep 2007 12:30:42 -0700
Message-ID: <200709161930.l8GJUgt3029388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48289 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751312AbXIPTbq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 15:31:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, htejun@gmail.com, jgarzik@pobox.com, linux@dominikbrodowski.net, protasnb@gmail.com, rmk@arm.linux.org.uk


The patch titled
     introduce DMA_MASK_NONE as a signal for unable to do DMA
has been added to the -mm tree.  Its filename is
     introduce-dma_mask_none-as-a-signal-for-unable-to-do.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: introduce DMA_MASK_NONE as a signal for unable to do DMA
From: James Bottomley <James.Bottomley@SteelEye.com>

Some devices are incapable of DMA and need to be recognised as such. 
Introduce a NONE dma mask to facilitate this plus an inline function:
is_device_dma_capable() to check this.

Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Natalie Protasevich <protasnb@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-mapping.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN include/linux/dma-mapping.h~introduce-dma_mask_none-as-a-signal-for-unable-to-do include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~introduce-dma_mask_none-as-a-signal-for-unable-to-do
+++ a/include/linux/dma-mapping.h
@@ -24,6 +24,8 @@ enum dma_data_direction {
 #define DMA_28BIT_MASK	0x000000000fffffffULL
 #define DMA_24BIT_MASK	0x0000000000ffffffULL
 
+#define DMA_MASK_NONE	0x0ULL
+
 static inline int valid_dma_direction(int dma_direction)
 {
 	return ((dma_direction == DMA_BIDIRECTIONAL) ||
@@ -31,6 +33,11 @@ static inline int valid_dma_direction(in
 		(dma_direction == DMA_FROM_DEVICE));
 }
 
+static inline int is_device_dma_capable(struct device *dev)
+{
+	return dev->dma_mask != NULL && *dev->dma_mask != DMA_MASK_NONE;
+}
+
 #ifdef CONFIG_HAS_DMA
 #include <asm/dma-mapping.h>
 #else
_

Patches currently in -mm which might be from James.Bottomley@SteelEye.com are

origin.patch
git-libata-all.patch
introduce-dma_mask_none-as-a-signal-for-unable-to-do.patch
pcmcia-use-dma_mask_none-for-the-default-for-all.patch
git-scsi-misc.patch
