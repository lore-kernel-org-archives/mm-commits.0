From: akpm@linux-foundation.org
Subject: + alpha-fix-iommu-related-boot-panic.patch added to -mm tree
Date: Sun, 09 Mar 2008 11:51:33 -0700
Message-ID: <200803091851.m29IpYrv013090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967AbYCISwA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 9 Mar 2008 14:52:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, mingo@elte.hu, rct@frus.com, rth@twiddle.net, tomof@acm.org


The patch titled
     alpha: fix iommu-related boot panic
has been added to the -mm tree.  Its filename is
     alpha-fix-iommu-related-boot-panic.patch

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
Subject: alpha: fix iommu-related boot panic
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Fix boot panic due to a typo in the recent iommu patchset from FUJITA Tomonori
<tomof@acm.org> - dma_get_max_seg_size() instead of dma_get_seg_boundary(). 
This also removes a couple of unnecessary BUG_ON() and ALIGN() macros.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Reported-by: Bob Tracy <rct@frus.com>
Tested-by: Bob Tracy <rct@frus.com>
Acked-by: FUJITA Tomonori <tomof@acm.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/pci_iommu.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN arch/alpha/kernel/pci_iommu.c~alpha-fix-iommu-related-boot-panic arch/alpha/kernel/pci_iommu.c
--- a/arch/alpha/kernel/pci_iommu.c~alpha-fix-iommu-related-boot-panic
+++ a/arch/alpha/kernel/pci_iommu.c
@@ -144,15 +144,14 @@ iommu_arena_find_pages(struct device *de
 	unsigned long base;
 	unsigned long boundary_size;
 
-	BUG_ON(arena->dma_base & ~PAGE_MASK);
 	base = arena->dma_base >> PAGE_SHIFT;
-	if (dev)
-		boundary_size = ALIGN(dma_get_max_seg_size(dev) + 1, PAGE_SIZE)
-			>> PAGE_SHIFT;
-	else
-		boundary_size = ALIGN(1UL << 32, PAGE_SIZE) >> PAGE_SHIFT;
