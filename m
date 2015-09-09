From: akpm@linux-foundation.org
Subject: [folded-merged]
 dma-mapping-cosolidate-dma_mapping_error-fix.patch removed from -mm tree
Date: Wed, 09 Sep 2015 15:14:42 -0700
Message-ID: <55f0af52.E+y969WpJw/2jeOo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbbIIWOn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 18:14:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jcmvbkbc@gmail.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping-cosolidate-dma_mapping_error-fix
has been removed from the -mm tree.  Its filename was
     dma-mapping-cosolidate-dma_mapping_error-fix.patch

This patch was dropped because it was folded into dma-mapping-cosolidate-dma_mapping_error.patch

------------------------------------------------------
From: Max Filippov <jcmvbkbc@gmail.com>
Subject: dma-mapping-cosolidate-dma_mapping_error-fix

fix xtensa

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/dma-mapping.h |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN arch/xtensa/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error-fix arch/xtensa/include/asm/dma-mapping.h
--- a/arch/xtensa/include/asm/dma-mapping.h~dma-mapping-cosolidate-dma_mapping_error-fix
+++ a/arch/xtensa/include/asm/dma-mapping.h
@@ -33,15 +33,6 @@ static inline struct dma_map_ops *get_dm
 #include <asm-generic/dma-mapping-common.h>
 
 static inline int
-dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	debug_dma_mapping_error(dev, dma_addr);
-	return ops->mapping_error(dev, dma_addr);
-}
