From: akpm@linux-foundation.org
Subject: + powerpc-vio-more-fallout-from-dma_mapping_error-api-change.patch added to -mm tree
Date: Sun, 27 Jul 2008 12:22:49 -0700
Message-ID: <200807271922.m6RJMnpc000974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757447AbYG0TWy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jul 2008 15:22:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au


The patch titled
     powerpc/vio: more fallout from dma_mapping_error API change
has been added to the -mm tree.  Its filename is
     powerpc-vio-more-fallout-from-dma_mapping_error-api-change.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc/vio: more fallout from dma_mapping_error API change
From: Stephen Rothwell <sfr@canb.auug.org.au>

arch/powerpc/kernel/vio.c:533: error: too few arguments to function 'dma_mapping_error'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/vio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/kernel/vio.c~powerpc-vio-more-fallout-from-dma_mapping_error-api-change arch/powerpc/kernel/vio.c
--- a/arch/powerpc/kernel/vio.c~powerpc-vio-more-fallout-from-dma_mapping_error-api-change
+++ a/arch/powerpc/kernel/vio.c
@@ -530,7 +530,7 @@ static dma_addr_t vio_dma_iommu_map_sing
 	}
 
 	ret = dma_iommu_ops.map_single(dev, vaddr, size, direction, attrs);
-	if (unlikely(dma_mapping_error(ret))) {
+	if (unlikely(dma_mapping_error(dev, ret))) {
 		vio_cmo_dealloc(viodev, roundup(size, IOMMU_PAGE_SIZE));
 		atomic_inc(&viodev->cmo.allocs_failed);
 	}
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
powerpc-ibmveth-fix-multiple-errors-with-dma_mapping_error-conversion.patch
powerpc-vio-more-fallout-from-dma_mapping_error-api-change.patch
linux-next.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch

