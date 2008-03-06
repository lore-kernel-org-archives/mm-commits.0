From: akpm@linux-foundation.org
Subject: - parisc-fix-a-overflow-bug-on-32bit-architectures.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:21:20 -0800
Message-ID: <200803062221.m26MLLKl020712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759549AbYCFWXJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:23:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, grundler@parisc-linux.org, kyle@parisc-linux.org, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     parisc: fix a overflow bug on 32bit architectures
has been removed from the -mm tree.  Its filename was
     parisc-fix-a-overflow-bug-on-32bit-architectures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parisc: fix a overflow bug on 32bit architectures
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On 32bit2 boxes, boundary_size becomes zero due to a overflow and we
hit BUG_ON in iommu_is_span_boundary.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Kyle McMartin <kyle@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parisc/ccio-dma.c  |    4 ++--
 drivers/parisc/sba_iommu.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/parisc/ccio-dma.c~parisc-fix-a-overflow-bug-on-32bit-architectures drivers/parisc/ccio-dma.c
--- a/drivers/parisc/ccio-dma.c~parisc-fix-a-overflow-bug-on-32bit-architectures
+++ a/drivers/parisc/ccio-dma.c
@@ -366,8 +366,8 @@ ccio_alloc_range(struct ioc *ioc, struct
 	** ggg sacrifices another 710 to the computer gods.
 	*/
 
-	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1, 1 << IOVP_SHIFT);
-	boundary_size >>= IOVP_SHIFT;
+	boundary_size = ALIGN((unsigned long long)dma_get_seg_boundary(dev) + 1,
+			      1ULL << IOVP_SHIFT) >> IOVP_SHIFT;
 
 	if (pages_needed <= 8) {
 		/*
diff -puN drivers/parisc/sba_iommu.c~parisc-fix-a-overflow-bug-on-32bit-architectures drivers/parisc/sba_iommu.c
--- a/drivers/parisc/sba_iommu.c~parisc-fix-a-overflow-bug-on-32bit-architectures
+++ a/drivers/parisc/sba_iommu.c
@@ -341,8 +341,8 @@ sba_search_bitmap(struct ioc *ioc, struc
 	unsigned long shift;
 	int ret;
 
-	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1, 1 << IOVP_SHIFT);
-	boundary_size >>= IOVP_SHIFT;
+	boundary_size = ALIGN((unsigned long long)dma_get_seg_boundary(dev) + 1,
+			      1ULL << IOVP_SHIFT) >> IOVP_SHIFT;
 
 #if defined(ZX1_SUPPORT)
 	BUG_ON(ioc->ibase & ~IOVP_MASK);
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
git-scsi-misc.patch

