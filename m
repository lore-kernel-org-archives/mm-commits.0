From: akpm@linux-foundation.org
Subject: +
 dma-mapping-consolidate-dma_allocfree_attrscoherent-fix-fix-2.patch added
 to -mm tree
Date: Wed, 26 Aug 2015 10:57:01 -0700
Message-ID: <55ddfded.GyNGNrxVPlJEUUkA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148AbbHZR5D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Aug 2015 13:57:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jcmvbkbc@gmail.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping-consolidate-dma_allocfree_attrscoherent-fix-fix-2
has been added to the -mm tree.  Its filename is
     dma-mapping-consolidate-dma_allocfree_attrscoherent-fix-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-mapping-consolidate-dma_allocfree_attrscoherent-fix-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-mapping-consolidate-dma_allocfree_attrscoherent-fix-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Max Filippov <jcmvbkbc@gmail.com>
Subject: dma-mapping-consolidate-dma_allocfree_attrscoherent-fix-fix-2

fix xtensa

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/dma-mapping.h |   31 ------------------------
 1 file changed, 31 deletions(-)

diff -puN arch/xtensa/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent-fix-fix-2 arch/xtensa/include/asm/dma-mapping.h
--- a/arch/xtensa/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent-fix-fix-2
+++ a/arch/xtensa/include/asm/dma-mapping.h
@@ -34,37 +34,6 @@ static inline struct dma_map_ops *get_dm
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_attrs(d, s, h, f, NULL)
 #define dma_free_noncoherent(d, s, v, h) dma_free_attrs(d, s, v, h, NULL)
-#define dma_alloc_coherent(d, s, h, f) dma_alloc_attrs(d, s, h, f, NULL)
-#define dma_free_coherent(d, s, c, h) dma_free_attrs(d, s, c, h, NULL)
-
-static inline void *dma_alloc_attrs(struct device *dev, size_t size,
-				    dma_addr_t *dma_handle, gfp_t gfp,
-				    struct dma_attrs *attrs)
-{
-	void *ret;
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	if (dma_alloc_from_coherent(dev, size, dma_handle, &ret))
-		return ret;
-
-	ret = ops->alloc(dev, size, dma_handle, gfp, attrs);
-	debug_dma_alloc_coherent(dev, size, *dma_handle, ret);
-
-	return ret;
-}
-
-static inline void dma_free_attrs(struct device *dev, size_t size,
-				  void *vaddr, dma_addr_t dma_handle,
-				  struct dma_attrs *attrs)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	if (dma_release_from_coherent(dev, get_order(size), vaddr))
-		return;
