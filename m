From: akpm@linux-foundation.org
Subject: - alpha-iommu-had-better-access-to-the-free-space-bitmap-at-only-one-place.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:44:54 -0800
Message-ID: <200803050744.m257isnY021544@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764765AbYCEHpa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:45:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: IOMMU had better access to the free space bitmap at only one place
has been removed from the -mm tree.  Its filename was
     alpha-iommu-had-better-access-to-the-free-space-bitmap-at-only-one-place.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: IOMMU had better access to the free space bitmap at only one place
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

iommu_arena_find_pages duplicates the code to access to the bitmap for free
space management.  This patch convert the IOMMU code to have only one place to
access the bitmap, in the popular way that other IOMMUs (e.g.  POWER and
SPARC) do.

This patch is preparation for modifications to fix the IOMMU segment boundary
problem.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/pci_iommu.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff -puN arch/alpha/kernel/pci_iommu.c~alpha-iommu-had-better-access-to-the-free-space-bitmap-at-only-one-place arch/alpha/kernel/pci_iommu.c
--- a/arch/alpha/kernel/pci_iommu.c~alpha-iommu-had-better-access-to-the-free-space-bitmap-at-only-one-place
+++ a/arch/alpha/kernel/pci_iommu.c
@@ -132,12 +132,15 @@ iommu_arena_find_pages(struct pci_iommu_
 {
 	unsigned long *ptes;
 	long i, p, nent;
+	int pass = 0;
 
 	/* Search forward for the first mask-aligned sequence of N free ptes */
 	ptes = arena->ptes;
 	nent = arena->size >> PAGE_SHIFT;
 	p = ALIGN(arena->next_entry, mask + 1);
 	i = 0;
+
+again:
 	while (i < n && p+i < nent) {
 		if (ptes[p+i])
 			p = ALIGN(p + i + 1, mask + 1), i = 0;
@@ -146,19 +149,18 @@ iommu_arena_find_pages(struct pci_iommu_
 	}
 
 	if (i < n) {
-                /* Reached the end.  Flush the TLB and restart the
-                   search from the beginning.  */
-		alpha_mv.mv_pci_tbi(arena->hose, 0, -1);
-
-		p = 0, i = 0;
-		while (i < n && p+i < nent) {
-			if (ptes[p+i])
-				p = ALIGN(p + i + 1, mask + 1), i = 0;
-			else
-				i = i + 1;
-		}
