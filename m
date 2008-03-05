From: akpm@linux-foundation.org
Subject: - alpha-convert-iommu-to-use-align.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:44:49 -0800
Message-ID: <200803050744.m257in09021541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764805AbYCEHpd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:45:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: convert IOMMU to use ALIGN()
has been removed from the -mm tree.  Its filename was
     alpha-convert-iommu-to-use-align.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: convert IOMMU to use ALIGN()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This patch is preparation for modifications to fix the IOMMU segment boundary
problem.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/pci_iommu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/alpha/kernel/pci_iommu.c~alpha-convert-iommu-to-use-align arch/alpha/kernel/pci_iommu.c
--- a/arch/alpha/kernel/pci_iommu.c~alpha-convert-iommu-to-use-align
+++ a/arch/alpha/kernel/pci_iommu.c
@@ -136,11 +136,11 @@ iommu_arena_find_pages(struct pci_iommu_
 	/* Search forward for the first mask-aligned sequence of N free ptes */
 	ptes = arena->ptes;
 	nent = arena->size >> PAGE_SHIFT;
-	p = (arena->next_entry + mask) & ~mask;
+	p = ALIGN(arena->next_entry, mask + 1);
 	i = 0;
 	while (i < n && p+i < nent) {
 		if (ptes[p+i])
-			p = (p + i + 1 + mask) & ~mask, i = 0;
+			p = ALIGN(p + i + 1, mask + 1), i = 0;
 		else
 			i = i + 1;
 	}
@@ -153,7 +153,7 @@ iommu_arena_find_pages(struct pci_iommu_
 		p = 0, i = 0;
 		while (i < n && p+i < nent) {
 			if (ptes[p+i])
-				p = (p + i + 1 + mask) & ~mask, i = 0;
+				p = ALIGN(p + i + 1, mask + 1), i = 0;
 			else
 				i = i + 1;
 		}
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

parisc-fix-a-overflow-bug-on-32bit-architectures.patch
git-scsi-misc.patch
mpt-fusion-dont-oops-if-numphys==0.patch

