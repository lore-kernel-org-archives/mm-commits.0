From: akpm@linux-foundation.org
Subject: - powerpc-vio-more-fallout-from-dma_mapping_error-api-change.patch removed from -mm tree
Date: Mon, 28 Jul 2008 14:11:10 -0700
Message-ID: <200807282111.m6SLBAFd027652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761089AbYG1VLo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 17:11:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     powerpc/vio: more fallout from dma_mapping_error API change
has been removed from the -mm tree.  Its filename was
     powerpc-vio-more-fallout-from-dma_mapping_error-api-change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch

