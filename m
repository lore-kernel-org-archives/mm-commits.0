Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E136F79C2
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560177; cv=none; b=CkBMEnSsbZCGlkSyHyePktoKR2SnPLnv72SqHkPmivH9VJ4EQycpXSoqz83jTDiYDRUwditriXhkTTPLVr96wpcRJ2Ufov0jHY1oCsWV2MryF2/dPYsHrDVwH/S0IIYDcSIFDNU516EjfNrAY5BUEBG3GaC1H8oDwt3C6VRrpZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560177; c=relaxed/simple;
	bh=VToulHwNHN+4iaZ/AhQtMDfIBX/vn9DRK70gX6j1QxE=;
	h=Date:To:From:Subject:Message-Id; b=VzhqrSjHo8+FIexNSF3Pjb+EV3OJNIlwtI80wfsF8mTxxfCnMNEcGhWewH12LhHEIfYm2ZXo8n3Kt1H4GE93jlcVQxbv6OM/cNHDiu54vXk51Cgb3emi9l67fAQEoNxulJ1PH1n74k2uIxqUbyYf3tEaud5k3MuuZAQzdtCB18A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tM+mBBmr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tM+mBBmr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4167C433B2;
	Thu, 22 Feb 2024 00:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560176;
	bh=VToulHwNHN+4iaZ/AhQtMDfIBX/vn9DRK70gX6j1QxE=;
	h=Date:To:From:Subject:From;
	b=tM+mBBmrmUcmvAXaS4dNuO37prmqQWX+GHUtIfby+N6xjETjozRYnVrFdWxHz4Kc8
	 Ga4kidTSMzHc2uSQYhoyqxu9pyIWIKj2bQhDqIraMqKB5CgYRYhF7knmpXb7jex5Og
	 um0R/AHGAyQg2ypUsPTVid1u9qQO+HAlECQzBMTc=
Date: Wed, 21 Feb 2024 16:02:56 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,rppt@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linux@armlinux.org.uk,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dinguyen@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-pass-pte-to-copy_present_pte.patch removed from -mm tree
Message-Id: <20240222000256.A4167C433B2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: pass PTE to copy_present_pte()
has been removed from the -mm tree.  Its filename was
     mm-memory-pass-pte-to-copy_present_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: pass PTE to copy_present_pte()
Date: Mon, 29 Jan 2024 13:46:46 +0100

We already read it, let's just forward it.

This patch is based on work by Ryan Roberts.

[david@redhat.com: fix the hmm "exclusive_cow" selftest]
  Link: https://lkml.kernel.org/r/13f296b8-e882-47fd-b939-c2141dc28717@redhat.com
Link: https://lkml.kernel.org/r/20240129124649.189745-13-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N. Rao <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Russell King (Oracle) <linux@armlinux.org.uk>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-memory-pass-pte-to-copy_present_pte
+++ a/mm/memory.c
@@ -959,10 +959,9 @@ static inline void __copy_present_pte(st
  */
 static inline int
 copy_present_pte(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
-		 pte_t *dst_pte, pte_t *src_pte, unsigned long addr, int *rss,
-		 struct folio **prealloc)
+		 pte_t *dst_pte, pte_t *src_pte, pte_t pte, unsigned long addr,
+		 int *rss, struct folio **prealloc)
 {
-	pte_t pte = ptep_get(src_pte);
 	struct page *page;
 	struct folio *folio;
 
@@ -1094,6 +1093,8 @@ again:
 				progress += 8;
 				continue;
 			}
+			ptent = ptep_get(src_pte);
+			VM_WARN_ON_ONCE(!pte_present(ptent));
 
 			/*
 			 * Device exclusive entry restored, continue by copying
@@ -1103,7 +1104,7 @@ again:
 		}
 		/* copy_present_pte() will clear `*prealloc' if consumed */
 		ret = copy_present_pte(dst_vma, src_vma, dst_pte, src_pte,
-				       addr, rss, &prealloc);
+				       ptent, addr, rss, &prealloc);
 		/*
 		 * If we need a pre-allocated page for this pte, drop the
 		 * locks, allocate, and try again.
_

Patches currently in -mm which might be from david@redhat.com are

mm-memory-factor-out-zapping-of-present-pte-into-zap_present_pte.patch
mm-memory-handle-page-case-in-zap_present_pte-separately.patch
mm-memory-further-separate-anon-and-pagecache-folio-handling-in-zap_present_pte.patch
mm-memory-factor-out-zapping-folio-pte-into-zap_present_folio_pte.patch
mm-mmu_gather-pass-delay_rmap-instead-of-encoded-page-to-__tlb_remove_page_size.patch
mm-mmu_gather-define-encoded_page_flag_delay_rmap.patch
mm-mmu_gather-add-tlb_remove_tlb_entries.patch
mm-mmu_gather-add-__tlb_remove_folio_pages.patch
mm-mmu_gather-improve-cond_resched-handling-with-large-folios-and-expensive-page-freeing.patch
mm-memory-optimize-unmap-zap-with-pte-mapped-thp.patch

