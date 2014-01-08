From: akpm@linux-foundation.org
Subject: + intel-iommu-fix-off-by-one-in-pagetable-freeing.patch added to
 -mm tree
Date: Tue, 07 Jan 2014 16:00:17 -0800
Message-ID: <52cc9511.jC2U/6IIJAXFlAOM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60597 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829AbaAHAAS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jan 2014 19:00:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, joro@8bytes.org, dwmw2@infradead.org, alex.williamson@redhat.com

Subject: + intel-iommu-fix-off-by-one-in-pagetable-freeing.patch added to -mm tree
To: alex.williamson@redhat.com,dwmw2@infradead.org,joro@8bytes.org,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 07 Jan 2014 16:00:17 -0800


The patch titled
     Subject: intel-iommu: fix off-by-one in pagetable freeing
has been added to the -mm tree.  Its filename is
     intel-iommu-fix-off-by-one-in-pagetable-freeing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/intel-iommu-fix-off-by-one-in-pagetable-freeing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/intel-iommu-fix-off-by-one-in-pagetable-freeing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Williamson <alex.williamson@redhat.com>
Subject: intel-iommu: fix off-by-one in pagetable freeing

dma_pte_free_level() has an off-by-one error when checking whether a pte
is completely covered by a range.  Take for example the case of attempting
to free pfn 0x0 - 0x1ff, ie.  512 entries covering the first 2M superpage.
 The level_size() is 0x200 and we test:

static void dma_pte_free_level(...
	...

	if (!(0 > 0 || 0x1ff < 0 + 0x200)) {
		...
	}

Clearly the 2nd test is true, which means we fail to take the branch to
clear and free the pagetable entry.  As a result, we're leaking pagetables
and failing to install new pages over the range.

This was found with a PCI device assigned to a QEMU guest using vfio-pci
without a VGA device present.  The first 1M of guest address space is
mapped with various combinations of 4K pages, but eventually the range is
entirely freed and replaced with a 2M contiguous mapping.  intel-iommu
errors out with something like:

ERROR: DMA PTE for vPFN 0x0 already set (to 5c2b8003 not 849c00083)

In this case 5c2b8003 is the pointer to the previous leaf page that was
neither freed nor cleared and 849c00083 is the superpage entry that we're
trying to replace it with.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/intel-iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/iommu/intel-iommu.c~intel-iommu-fix-off-by-one-in-pagetable-freeing drivers/iommu/intel-iommu.c
--- a/drivers/iommu/intel-iommu.c~intel-iommu-fix-off-by-one-in-pagetable-freeing
+++ a/drivers/iommu/intel-iommu.c
@@ -917,7 +917,7 @@ static void dma_pte_free_level(struct dm
 
 		/* If range covers entire pagetable, free it */
 		if (!(start_pfn > level_pfn ||
-		      last_pfn < level_pfn + level_size(level))) {
+		      last_pfn < level_pfn + level_size(level) - 1)) {
 			dma_clear_pte(pte);
 			domain_flush_cache(domain, pte, sizeof(*pte));
 			free_pgtable_page(level_pte);
_

Patches currently in -mm which might be from alex.williamson@redhat.com are

intel-iommu-fix-off-by-one-in-pagetable-freeing.patch
linux-next.patch

