Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A881313F01B
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706876068; cv=none; b=tQJ7mXGX+jy/7CzyOjg7/IGGJZbkqoczplwjw0048wsZzcz1DJZDHv044cSlGVsmm2K7qJ54a6bN5vcyJxprUz5zF1DIbsYU1AULG/J037QSlpTQ8D1J2/s4VGnfJj+fv0ortOuf64Y7AZUz45yMtGG1FdwWSTEuYHj475Bkr/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706876068; c=relaxed/simple;
	bh=WfDMARPD/lkj7JFlN9K6upkqtgNZG7ZkzJeHmGM2GJM=;
	h=Date:To:From:Subject:Message-Id; b=ADKkr2sKfjgzGFBK26tUCO9bjh+S9rtnvIyHfTPtegacw47x+VhlEBrQlPfa7EPdW5BGnwdLMzPq9CqPYipZDtnGyBsqSHCQWepzze7LPAzhk+eIlhsLuk3ZM4CEGim/DNfdTUfr4aMJeoqn70wRlFVyFG25qLN+AJR/7sqvIqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fgYopfaQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fgYopfaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9894C433F1;
	Fri,  2 Feb 2024 12:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706876068;
	bh=WfDMARPD/lkj7JFlN9K6upkqtgNZG7ZkzJeHmGM2GJM=;
	h=Date:To:From:Subject:From;
	b=fgYopfaQVGCHfZrJexeqEEFFf9MfsXzvtCrAWWT829a/02uCil7otTiNF0O7kPRff
	 mO+a/+PsReP+3a1XAavuoUVGDHQd5NgcGZhwdtslbCc0iK9hXwe+6w0CM20/PYTUv7
	 u7vdHpr+Vh/lPyTBR2wk/Qgkrm4cqgAaA/k/Ntng=
Date: Fri, 02 Feb 2024 04:14:25 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linux@armlinux.org.uk,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dinguyen@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-ignore-writable-bit-in-folio_pte_batch.patch added to mm-unstable branch
Message-Id: <20240202121427.C9894C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: ignore writable bit in folio_pte_batch()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-ignore-writable-bit-in-folio_pte_batch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-ignore-writable-bit-in-folio_pte_batch.patch

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
Subject: mm/memory: ignore writable bit in folio_pte_batch()
Date: Mon, 29 Jan 2024 13:46:49 +0100

...  and conditionally return to the caller if any PTE except the first
one is writable.  fork() has to make sure to properly write-protect in
case any PTE is writable.  Other users (e.g., page unmaping) are expected
to not care.

Link: https://lkml.kernel.org/r/20240129124649.189745-16-david@redhat.com
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

 mm/memory.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

--- a/mm/memory.c~mm-memory-ignore-writable-bit-in-folio_pte_batch
+++ a/mm/memory.c
@@ -968,7 +968,7 @@ static inline pte_t __pte_batch_clear_ig
 		pte = pte_mkclean(pte);
 	if (likely(flags & FPB_IGNORE_SOFT_DIRTY))
 		pte = pte_clear_soft_dirty(pte);
-	return pte_mkold(pte);
+	return pte_wrprotect(pte_mkold(pte));
 }
 
 /*
@@ -976,21 +976,32 @@ static inline pte_t __pte_batch_clear_ig
  * pages of the same folio.
  *
  * All PTEs inside a PTE batch have the same PTE bits set, excluding the PFN,
- * the accessed bit, dirty bit (with FPB_IGNORE_DIRTY) and soft-dirty bit
- * (with FPB_IGNORE_SOFT_DIRTY).
+ * the accessed bit, writable bit, dirty bit (with FPB_IGNORE_DIRTY) and
+ * soft-dirty bit (with FPB_IGNORE_SOFT_DIRTY).
+ *
+ * If "any_writable" is set, it will indicate if any other PTE besides the
+ * first (given) PTE is writable.
  */
 static inline int folio_pte_batch(struct folio *folio, unsigned long addr,
-		pte_t *start_ptep, pte_t pte, int max_nr, fpb_t flags)
+		pte_t *start_ptep, pte_t pte, int max_nr, fpb_t flags,
+		bool *any_writable)
 {
 	unsigned long folio_end_pfn = folio_pfn(folio) + folio_nr_pages(folio);
 	const pte_t *end_ptep = start_ptep + max_nr;
 	pte_t expected_pte = __pte_batch_clear_ignored(pte_next_pfn(pte), flags);
 	pte_t *ptep = start_ptep + 1;
+	bool writable;
+
+	if (any_writable)
+		*any_writable = false;
 
 	VM_WARN_ON_FOLIO(!pte_present(pte), folio);
 
 	while (ptep != end_ptep) {
-		pte = __pte_batch_clear_ignored(ptep_get(ptep), flags);
+		pte = ptep_get(ptep);
+		if (any_writable)
+			writable = !!pte_write(pte);
+		pte = __pte_batch_clear_ignored(pte, flags);
 
 		if (!pte_same(pte, expected_pte))
 			break;
@@ -1003,6 +1014,9 @@ static inline int folio_pte_batch(struct
 		if (pte_pfn(pte) == folio_end_pfn)
 			break;
 
+		if (any_writable)
+			*any_writable |= writable;
+
 		expected_pte = pte_next_pfn(expected_pte);
 		ptep++;
 	}
@@ -1024,6 +1038,7 @@ copy_present_ptes(struct vm_area_struct
 {
 	struct page *page;
 	struct folio *folio;
+	bool any_writable;
 	fpb_t flags = 0;
 	int err, nr;
 
@@ -1044,7 +1059,8 @@ copy_present_ptes(struct vm_area_struct
 		if (!vma_soft_dirty_enabled(src_vma))
 			flags |= FPB_IGNORE_SOFT_DIRTY;
 
-		nr = folio_pte_batch(folio, addr, src_pte, pte, max_nr, flags);
+		nr = folio_pte_batch(folio, addr, src_pte, pte, max_nr, flags,
+				     &any_writable);
 		folio_ref_add(folio, nr);
 		if (folio_test_anon(folio)) {
 			if (unlikely(folio_try_dup_anon_rmap_ptes(folio, page,
@@ -1058,6 +1074,8 @@ copy_present_ptes(struct vm_area_struct
 			folio_dup_file_rmap_ptes(folio, page, nr);
 			rss[mm_counter_file(folio)] += nr;
 		}
+		if (any_writable)
+			pte = pte_mkwrite(pte, src_vma);
 		__copy_present_ptes(dst_vma, src_vma, dst_pte, src_pte, pte,
 				    addr, nr);
 		return nr;
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

