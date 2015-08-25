From: akpm@linux-foundation.org
Subject: + dma-mapping-consolidate-dma_allocfree_attrscoherent-fix.patch
 added to -mm tree
Date: Tue, 25 Aug 2015 13:23:25 -0700
Message-ID: <55dccebd.Upv8nAok58cMQdRi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34077 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbbHYUX0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Aug 2015 16:23:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, hch@lst.de, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MIPS: Netlogic: Fix build error
has been added to the -mm tree.  Its filename is
     dma-mapping-consolidate-dma_allocfree_attrscoherent-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-mapping-consolidate-dma_allocfree_attrscoherent-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-mapping-consolidate-dma_allocfree_attrscoherent-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
