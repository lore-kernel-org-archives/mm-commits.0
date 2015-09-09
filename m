From: akpm@linux-foundation.org
Subject: [folded-merged]
 dma-mapping-consolidate-dma_allocfree_attrscoherent-fix.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 15:13:27 -0700
Message-ID: <55f0af07.rTVAu1nVk/zQ4vWU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56759 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbbIIWN2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 18:13:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, hch@lst.de, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MIPS: Netlogic: Fix build error
has been removed from the -mm tree.  Its filename was
     dma-mapping-consolidate-dma_allocfree_attrscoherent-fix.patch

This patch was dropped because it was folded into dma-mapping-consolidate-dma_allocfree_attrscoherent.patch

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: MIPS: Netlogic: Fix build error

The variable 'ret' is no longer used in nlm_dma_alloc_coherent()
and causes the following build error.

arch/mips/netlogic/common/nlm-dma.c: In function 'nlm_dma_alloc_coherent':
arch/mips/netlogic/common/nlm-dma.c:50:8: error: unused variable 'ret'

Fixes: e4d0d18739dc ("dma-mapping: consolidate dma_{alloc,free}_{attrs,coherent}")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/netlogic/common/nlm-dma.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN arch/mips/netlogic/common/nlm-dma.c~dma-mapping-consolidate-dma_allocfree_attrscoherent-fix arch/mips/netlogic/common/nlm-dma.c
--- a/arch/mips/netlogic/common/nlm-dma.c~dma-mapping-consolidate-dma_allocfree_attrscoherent-fix
+++ a/arch/mips/netlogic/common/nlm-dma.c
@@ -47,8 +47,6 @@ static char *nlm_swiotlb;
 static void *nlm_dma_alloc_coherent(struct device *dev, size_t size,
 	dma_addr_t *dma_handle, gfp_t gfp, struct dma_attrs *attrs)
 {
-	void *ret;
