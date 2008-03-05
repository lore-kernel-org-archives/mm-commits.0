From: akpm@linux-foundation.org
Subject: + parisc-fix-a-overflow-bug-on-32bit-architectures.patch added to -mm tree
Date: Wed, 05 Mar 2008 00:20:24 -0500
Message-ID: <200803050521.m255L8oc016265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668AbYCEFYi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 00:24:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, grundler@parisc-linux.org, kyle@parisc-linux.org, matthew@wil.cx


The patch titled
     parisc: fix a overflow bug on 32bit architectures
has been added to the -mm tree.  Its filename is
     parisc-fix-a-overflow-bug-on-32bit-architectures.patch

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
alpha-convert-iommu-to-use-align.patch
alpha-iommu-had-better-access-to-the-free-space-bitmap-at-only-one-place.patch
alpha-make-iommu-respect-the-segment-boundary-limits.patch
alpha-remove-unused-debug_forcedac-define-in-iommu.patch
iommu-export-iommu_is_span_boundary-helper-function.patch
iommu-parisc-pass-struct-device-to-iommu_alloc_range.patch
iommu-parisc-make-the-iommus-respect-the-segment-boundary-limits.patch
parisc-fix-a-overflow-bug-on-32bit-architectures.patch
git-scsi-misc.patch
mpt-fusion-dont-oops-if-numphys==0.patch

