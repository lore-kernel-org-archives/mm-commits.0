From: akpm@linux-foundation.org
Subject: - stop-using-dma_xxbit_mask-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 01:46:43 -0700
Message-ID: <200710180846.l9I8khsY002747@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48980 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932138AbXJRIqr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 04:46:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jeremy@goop.org, mm-commits@vger.kernel.org


The patch titled
     stop-using-dma_xxbit_mask-fix
has been removed from the -mm tree.  Its filename was
     stop-using-dma_xxbit_mask-fix.patch

This patch was dropped because it was folded into stop-using-dma_xxbit_mask.patch

------------------------------------------------------
Subject: stop-using-dma_xxbit_mask-fix
From: Andrew Morton <akpm@linux-foundation.org>

jermy fix tit 4 me

Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/dma-mapping.h~stop-using-dma_xxbit_mask-fix include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~stop-using-dma_xxbit_mask-fix
+++ a/include/linux/dma-mapping.h
@@ -13,7 +13,7 @@ enum dma_data_direction {
 	DMA_NONE = 3,
 };
 
-#define DMA_BIT_MASK(n)	((1ULL<<(n))-1)
+#define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
 
 /*
  * NOTE: do not use the below macros in new code and do not add new definitions
@@ -21,7 +21,7 @@ enum dma_data_direction {
  *
  * Instead, just open-code DMA_BIT_MASK(n) within your driver
  */
-#define DMA_64BIT_MASK	(~0ULL)
+#define DMA_64BIT_MASK	DMA_BIT_MASK(64)
 #define DMA_48BIT_MASK	DMA_BIT_MASK(48)
 #define DMA_47BIT_MASK	DMA_BIT_MASK(47)
 #define DMA_40BIT_MASK	DMA_BIT_MASK(40)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
stop-using-dma_xxbit_mask.patch
stop-using-dma_xxbit_mask-fix.patch
powerpc-lock-bitops-fix.patch
fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch
fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
i-oat-tighten-descriptor-setup-performance-fix.patch
i-oat-add-completion-callback-for-async_tx-interface-use-fix.patch
i-oat-add-completion-callback-for-async_tx-interface-use-fix-fix.patch
