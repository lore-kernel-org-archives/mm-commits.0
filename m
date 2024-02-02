Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9932414076D
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706876053; cv=none; b=Um04uVWjHMdWDuCRMyjqPOr/FtU86O4vgkx5v5Prhh3quDWyX3hD/0eToSMGPiH4K2skIgzPJEpP683bP1FVbsmifdqmsy+7h0d7ehXmVdnvLVTh9hWG8aOk5OZIGQjBPDeL90jc88hb4sxRZmoSNSczHBcgOvZldeaFpL6+l6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706876053; c=relaxed/simple;
	bh=ZzInhr2X9xm6JWM9JRq3o2gAe+7hn37KU6U/q/k7Hnw=;
	h=Date:To:From:Subject:Message-Id; b=B5QMdPsE1hp22Z+t13lBWwjoAUvGpX9xU9BvH9U1+PiDPgP4ta+eq1IA6UOKYIQ4uB2K3QQ41m+/MHyTEvErNHy78h4AbVoyxAWRhKwOI7dAbM5BGS0NWCKwp9CyXCZ9nVX16mCmA8BhcP6b9V49rPFGEHvFlN0Gbf7dYvrUobc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bEJ0/0tb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bEJ0/0tb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC264C433C7;
	Fri,  2 Feb 2024 12:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706876053;
	bh=ZzInhr2X9xm6JWM9JRq3o2gAe+7hn37KU6U/q/k7Hnw=;
	h=Date:To:From:Subject:From;
	b=bEJ0/0tb6mVatzCnTRmZiIA60Ls5d/EaRN3/x6Cbr46bm/wRZsKSpqewbhXNaWM2M
	 WCN668qWKtrBr8B7saoDPb3lFpXVnl3gHBPZoo8RIwcn2mDBvh55Q1I5Dz45PrQo4G
	 gCpJx7NbzxG6N2TFsx9FdcBm9FUY/8cLAI346FcY=
Date: Fri, 02 Feb 2024 04:14:10 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linux@armlinux.org.uk,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dinguyen@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-factor-out-copying-the-actual-pte-in-copy_present_pte.patch added to mm-unstable branch
Message-Id: <20240202121412.BC264C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: factor out copying the actual PTE in copy_present_pte()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-factor-out-copying-the-actual-pte-in-copy_present_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-factor-out-copying-the-actual-pte-in-copy_present_pte.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: factor out copying the actual PTE in copy_present_pte()
Date: Mon, 29 Jan 2024 13:46:45 +0100

Let's prepare for further changes.

Link: https://lkml.kernel.org/r/20240129124649.189745-12-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
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

 mm/memory.c |   63 ++++++++++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 30 deletions(-)

--- a/mm/memory.c~mm-memory-factor-out-copying-the-actual-pte-in-copy_present_pte
+++ a/mm/memory.c
@@ -930,6 +930,29 @@ copy_present_page(struct vm_area_struct
 	return 0;
 }
 
+static inline void __copy_present_pte(struct vm_area_struct *dst_vma,
+		struct vm_area_struct *src_vma, pte_t *dst_pte, pte_t *src_pte,
+		pte_t pte, unsigned long addr)
+{
+	struct mm_struct *src_mm = src_vma->vm_mm;
+
+	/* If it's a COW mapping, write protect it both processes. */
+	if (is_cow_mapping(src_vma->vm_flags) && pte_write(pte)) {
+		ptep_set_wrprotect(src_mm, addr, src_pte);
+		pte = pte_wrprotect(pte);
+	}
+
+	/* If it's a shared mapping, mark it clean in the child. */
+	if (src_vma->vm_flags & VM_SHARED)
+		pte = pte_mkclean(pte);
+	pte = pte_mkold(pte);
+
+	if (!userfaultfd_wp(dst_vma))
+		pte = pte_clear_uffd_wp(pte);
+
+	set_pte_at(dst_vma->vm_mm, addr, dst_pte, pte);
+}
+
 /*
  * Copy one pte.  Returns 0 if succeeded, or -EAGAIN if one preallocated page
  * is required to copy this pte.
@@ -939,23 +962,23 @@ copy_present_pte(struct vm_area_struct *
 		 pte_t *dst_pte, pte_t *src_pte, unsigned long addr, int *rss,
 		 struct folio **prealloc)
 {
-	struct mm_struct *src_mm = src_vma->vm_mm;
-	unsigned long vm_flags = src_vma->vm_flags;
 	pte_t pte = ptep_get(src_pte);
 	struct page *page;
 	struct folio *folio;
 
 	page = vm_normal_page(src_vma, addr, pte);
-	if (page)
-		folio = page_folio(page);
-	if (page && folio_test_anon(folio)) {
+	if (unlikely(!page))
+		goto copy_pte;
+
+	folio = page_folio(page);
+	folio_get(folio);
+	if (folio_test_anon(folio)) {
 		/*
 		 * If this page may have been pinned by the parent process,
 		 * copy the page immediately for the child so that we'll always
 		 * guarantee the pinned page won't be randomly replaced in the
 		 * future.
 		 */
-		folio_get(folio);
 		if (unlikely(folio_try_dup_anon_rmap_pte(folio, page, src_vma))) {
 			/* Page may be pinned, we have to copy. */
 			folio_put(folio);
@@ -963,34 +986,14 @@ copy_present_pte(struct vm_area_struct *
 						 addr, rss, prealloc, page);
 		}
 		rss[MM_ANONPAGES]++;
-	} else if (page) {
-		folio_get(folio);
+		VM_WARN_ON_FOLIO(PageAnonExclusive(page), folio);
+	} else {
 		folio_dup_file_rmap_pte(folio, page);
 		rss[mm_counter_file(folio)]++;
 	}
 
-	/*
-	 * If it's a COW mapping, write protect it both
-	 * in the parent and the child
-	 */
-	if (is_cow_mapping(vm_flags) && pte_write(pte)) {
-		ptep_set_wrprotect(src_mm, addr, src_pte);
-		pte = pte_wrprotect(pte);
-	}
-	VM_BUG_ON(page && folio_test_anon(folio) && PageAnonExclusive(page));
-
-	/*
-	 * If it's a shared mapping, mark it clean in
-	 * the child
-	 */
-	if (vm_flags & VM_SHARED)
-		pte = pte_mkclean(pte);
-	pte = pte_mkold(pte);
-
-	if (!userfaultfd_wp(dst_vma))
-		pte = pte_clear_uffd_wp(pte);
-
-	set_pte_at(dst_vma->vm_mm, addr, dst_pte, pte);
+copy_pte:
+	__copy_present_pte(dst_vma, src_vma, dst_pte, src_pte, pte, addr);
 	return 0;
 }
 
_

Patches currently in -mm which might be from david@redhat.com are

arm-pgtable-define-pfn_pte_shift.patch
nios2-pgtable-define-pfn_pte_shift.patch
powerpc-pgtable-define-pfn_pte_shift.patch
riscv-pgtable-define-pfn_pte_shift.patch
s390-pgtable-define-pfn_pte_shift.patch
sparc-pgtable-define-pfn_pte_shift.patch
mm-pgtable-make-pte_next_pfn-independent-of-set_ptes.patch
arm-mm-use-pte_next_pfn-in-set_ptes.patch
powerpc-mm-use-pte_next_pfn-in-set_ptes.patch
mm-memory-factor-out-copying-the-actual-pte-in-copy_present_pte.patch
mm-memory-pass-pte-to-copy_present_pte.patch
mm-memory-optimize-fork-with-pte-mapped-thp.patch
mm-memory-ignore-dirty-accessed-soft-dirty-bits-in-folio_pte_batch.patch
mm-memory-ignore-writable-bit-in-folio_pte_batch.patch

