From: akpm@linux-foundation.org
Subject: [folded-merged] dma-mapping-consolidate-dma_set_mask-fix.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 15:15:29 -0700
Message-ID: <55f0af81.PJoKMyOyGRFGfXg4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbbIIWP3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 18:15:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jcmvbkbc@gmail.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping-consolidate-dma_set_mask-fix
has been removed from the -mm tree.  Its filename was
     dma-mapping-consolidate-dma_set_mask-fix.patch

This patch was dropped because it was folded into dma-mapping-consolidate-dma_set_mask.patch

------------------------------------------------------
From: Max Filippov <jcmvbkbc@gmail.com>
Subject: dma-mapping-consolidate-dma_set_mask-fix

fix xtensa

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/dma-mapping.h |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN arch/xtensa/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask-fix arch/xtensa/include/asm/dma-mapping.h
--- a/arch/xtensa/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_set_mask-fix
+++ a/arch/xtensa/include/asm/dma-mapping.h
@@ -32,17 +32,6 @@ static inline struct dma_map_ops *get_dm
 
 #include <asm-generic/dma-mapping-common.h>
 
-static inline int
-dma_set_mask(struct device *dev, u64 mask)
-{
-	if(!dev->dma_mask || !dma_supported(dev, mask))
-		return -EIO;
-
-	*dev->dma_mask = mask;
-
-	return 0;
-}
