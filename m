From: akpm@linux-foundation.org
Subject: + alpha-convert-iommu-to-use-align.patch added to -mm tree
Date: Wed, 27 Feb 2008 16:43:24 -0800
Message-ID: <200802280043.m1S0hOit007321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46653 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759047AbYB1Anp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 19:43:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     alpha: convert IOMMU to use ALIGN()
has been added to the -mm tree.  Its filename is
     alpha-convert-iommu-to-use-align.patch

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

git-scsi-misc.patch
alpha-convert-iommu-to-use-align.patch
alpha-iommu-had-better-access-to-the-free-space-bitmap-at-only-one-place.patch
alpha-make-iommu-respect-the-segment-boundary-limits.patch
alpha-remove-unused-debug_forcedac-define-in-iommu.patch
mpt-fusion-dont-oops-if-numphys==0.patch
