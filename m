From: akpm@linux-foundation.org
Subject: + alpha-agp-update-fixes-compile-failure.patch added to -mm tree
Date: Wed, 23 Sep 2009 14:33:08 -0700
Message-ID: <200909232133.n8NLX8AG002771@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645AbZIWVei (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 17:34:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, airlied@linux.ie, rth@twiddle.net, stable@kernel.org


The patch titled
     alpha: AGP update (fixes compile failure)
has been added to the -mm tree.  Its filename is
     alpha-agp-update-fixes-compile-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: AGP update (fixes compile failure)
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

This brings Alpha AGP platforms in sync with the change to struct
agp_memory (unsigned long *memory => struct page **pages).

Only compile tested (I don't have titan/marvel hardware), but this change
looks pretty straightforward, so hopefully it's ok.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Dave Airlie <airlied@linux.ie>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/core_marvel.c |    2 +-
 arch/alpha/kernel/core_titan.c  |    2 +-
 arch/alpha/kernel/pci_impl.h    |    2 +-
 arch/alpha/kernel/pci_iommu.c   |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/alpha/kernel/core_marvel.c~alpha-agp-update-fixes-compile-failure arch/alpha/kernel/core_marvel.c
--- a/arch/alpha/kernel/core_marvel.c~alpha-agp-update-fixes-compile-failure
+++ a/arch/alpha/kernel/core_marvel.c
@@ -1016,7 +1016,7 @@ marvel_agp_bind_memory(alpha_agp_info *a
 {
 	struct marvel_agp_aperture *aper = agp->aperture.sysdata;
 	return iommu_bind(aper->arena, aper->pg_start + pg_start, 
-			  mem->page_count, mem->memory);
+			  mem->page_count, mem->pages);
 }
 
 static int 
diff -puN arch/alpha/kernel/core_titan.c~alpha-agp-update-fixes-compile-failure arch/alpha/kernel/core_titan.c
--- a/arch/alpha/kernel/core_titan.c~alpha-agp-update-fixes-compile-failure
+++ a/arch/alpha/kernel/core_titan.c
@@ -680,7 +680,7 @@ titan_agp_bind_memory(alpha_agp_info *ag
 {
 	struct titan_agp_aperture *aper = agp->aperture.sysdata;
 	return iommu_bind(aper->arena, aper->pg_start + pg_start, 
-			  mem->page_count, mem->memory);
+			  mem->page_count, mem->pages);
 }
 
 static int 
diff -puN arch/alpha/kernel/pci_impl.h~alpha-agp-update-fixes-compile-failure arch/alpha/kernel/pci_impl.h
--- a/arch/alpha/kernel/pci_impl.h~alpha-agp-update-fixes-compile-failure
+++ a/arch/alpha/kernel/pci_impl.h
@@ -198,7 +198,7 @@ extern unsigned long size_for_memory(uns
 
 extern int iommu_reserve(struct pci_iommu_arena *, long, long);
 extern int iommu_release(struct pci_iommu_arena *, long, long);
-extern int iommu_bind(struct pci_iommu_arena *, long, long, unsigned long *);
+extern int iommu_bind(struct pci_iommu_arena *, long, long, struct page **);
 extern int iommu_unbind(struct pci_iommu_arena *, long, long);
 
 
diff -puN arch/alpha/kernel/pci_iommu.c~alpha-agp-update-fixes-compile-failure arch/alpha/kernel/pci_iommu.c
--- a/arch/alpha/kernel/pci_iommu.c~alpha-agp-update-fixes-compile-failure
+++ a/arch/alpha/kernel/pci_iommu.c
@@ -876,7 +876,7 @@ iommu_release(struct pci_iommu_arena *ar
 
 int
 iommu_bind(struct pci_iommu_arena *arena, long pg_start, long pg_count, 
-	   unsigned long *physaddrs)
+	   struct page **pages)
 {
 	unsigned long flags;
 	unsigned long *ptes;
@@ -896,7 +896,7 @@ iommu_bind(struct pci_iommu_arena *arena
 	}
 		
 	for(i = 0, j = pg_start; i < pg_count; i++, j++)
-		ptes[j] = mk_iommu_pte(physaddrs[i]);
+		ptes[j] = mk_iommu_pte(page_to_phys(pages[i]));
 
 	spin_unlock_irqrestore(&arena->lock, flags);
 
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

origin.patch
alpha-agp-update-fixes-compile-failure.patch

