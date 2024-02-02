Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1388B13EFE9
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706876066; cv=none; b=sDGRsugaXsPg9jDdg9UFqp1T0y9r6qK+61dkdB3nUDqYa6Waid8YJcHu2ldDixUB9bkGVWcb1LHQDZorvT4SfzANiNuCdeEDeu+Qj8crVKygDSBcI35vBqivMOKjNPomkpX2hbIy87C1e+Q6lymweUsgxpmI/7Ue7vHQwMgqZmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706876066; c=relaxed/simple;
	bh=F8QL88lRu/wxE12AJGNwPEb598svVaVzOVghX/yfevY=;
	h=Date:To:From:Subject:Message-Id; b=ZTOPrlhTAlOmyMTqAxmfQEPPINgrUVzM+vz97Xz0p4KyVB2cmB6+gOxQGpWn/CD4KomsuiYCGWtMhDHRSQWCSBF+MMRuwbn21xnYB7PW7VMh5C7iYd9Wh/Y3izJ5dtomtChneOZfJssi2FyRynkaBafU98mkLxmpL1UzQVaXUYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pf28VTAK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pf28VTAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A1BC433F1;
	Fri,  2 Feb 2024 12:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706876065;
	bh=F8QL88lRu/wxE12AJGNwPEb598svVaVzOVghX/yfevY=;
	h=Date:To:From:Subject:From;
	b=pf28VTAKTrS4LgUR5LEQXmz1/krXb6SgWx0Es18e1hlwyjgzlbFfjGo0YGsWpM2iD
	 harPf/Azl9WR/K6HHBCaTFsYXdjQiDYAkwqqP2vwII/GDOi14804tvWYwdueooA26P
	 XphDtZD+RdHsFMskiIBhvFLeCRrUwdTCodenHWUQ=
Date: Fri, 02 Feb 2024 04:14:23 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linux@armlinux.org.uk,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dinguyen@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-ignore-dirty-accessed-soft-dirty-bits-in-folio_pte_batch.patch added to mm-unstable branch
Message-Id: <20240202121425.11A1BC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: ignore dirty/accessed/soft-dirty bits in folio_pte_batch()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-ignore-dirty-accessed-soft-dirty-bits-in-folio_pte_batch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-ignore-dirty-accessed-soft-dirty-bits-in-folio_pte_batch.patch

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
Subject: mm/memory: ignore dirty/accessed/soft-dirty bits in folio_pte_batch()
Date: Mon, 29 Jan 2024 13:46:48 +0100

Let's always ignore the accessed/young bit: we'll always mark the PTE as
old in our child process during fork, and upcoming users will similarly
not care.

Ignore the dirty bit only if we don't want to duplicate the dirty bit into
the child process during fork.  Maybe, we could just set all PTEs in the
child dirty if any PTE is dirty.  For now, let's keep the behavior
unchanged, this can be optimized later if required.

Ignore the soft-dirty bit only if the bit doesn't have any meaning in the
src vma, and similarly won't have any in the copied dst vma.

For now, we won't bother with the uffd-wp bit.

Link: https://lkml.kernel.org/r/20240129124649.189745-15-david@redhat.com
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

 mm/memory.c |   36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

--- a/mm/memory.c~mm-memory-ignore-dirty-accessed-soft-dirty-bits-in-folio_pte_batch
+++ a/mm/memory.c
@@ -953,24 +953,44 @@ static __always_inline void __copy_prese
 	set_ptes(dst_vma->vm_mm, addr, dst_pte, pte, nr);
 }
 
+/* Flags for folio_pte_batch(). */
+typedef int __bitwise fpb_t;
+
+/* Compare PTEs after pte_mkclean(), ignoring the dirty bit. */
+#define FPB_IGNORE_DIRTY		((__force fpb_t)BIT(0))
+
+/* Compare PTEs after pte_clear_soft_dirty(), ignoring the soft-dirty bit. */
+#define FPB_IGNORE_SOFT_DIRTY		((__force fpb_t)BIT(1))
+
+static inline pte_t __pte_batch_clear_ignored(pte_t pte, fpb_t flags)
+{
+	if (flags & FPB_IGNORE_DIRTY)
+		pte = pte_mkclean(pte);
+	if (likely(flags & FPB_IGNORE_SOFT_DIRTY))
+		pte = pte_clear_soft_dirty(pte);
+	return pte_mkold(pte);
+}
+
 /*
  * Detect a PTE batch: consecutive (present) PTEs that map consecutive
  * pages of the same folio.
  *
- * All PTEs inside a PTE batch have the same PTE bits set, excluding the PFN.
+ * All PTEs inside a PTE batch have the same PTE bits set, excluding the PFN,
+ * the accessed bit, dirty bit (with FPB_IGNORE_DIRTY) and soft-dirty bit
+ * (with FPB_IGNORE_SOFT_DIRTY).
  */
 static inline int folio_pte_batch(struct folio *folio, unsigned long addr,
-		pte_t *start_ptep, pte_t pte, int max_nr)
+		pte_t *start_ptep, pte_t pte, int max_nr, fpb_t flags)
 {
 	unsigned long folio_end_pfn = folio_pfn(folio) + folio_nr_pages(folio);
 	const pte_t *end_ptep = start_ptep + max_nr;
-	pte_t expected_pte = pte_next_pfn(pte);
+	pte_t expected_pte = __pte_batch_clear_ignored(pte_next_pfn(pte), flags);
 	pte_t *ptep = start_ptep + 1;
 
 	VM_WARN_ON_FOLIO(!pte_present(pte), folio);
 
 	while (ptep != end_ptep) {
-		pte = ptep_get(ptep);
+		pte = __pte_batch_clear_ignored(ptep_get(ptep), flags);
 
 		if (!pte_same(pte, expected_pte))
 			break;
@@ -1004,6 +1024,7 @@ copy_present_ptes(struct vm_area_struct
 {
 	struct page *page;
 	struct folio *folio;
+	fpb_t flags = 0;
 	int err, nr;
 
 	page = vm_normal_page(src_vma, addr, pte);
@@ -1018,7 +1039,12 @@ copy_present_ptes(struct vm_area_struct
 	 * by keeping the batching logic separate.
 	 */
 	if (unlikely(!*prealloc && folio_test_large(folio) && max_nr != 1)) {
-		nr = folio_pte_batch(folio, addr, src_pte, pte, max_nr);
+		if (src_vma->vm_flags & VM_SHARED)
+			flags |= FPB_IGNORE_DIRTY;
+		if (!vma_soft_dirty_enabled(src_vma))
+			flags |= FPB_IGNORE_SOFT_DIRTY;
+
+		nr = folio_pte_batch(folio, addr, src_pte, pte, max_nr, flags);
 		folio_ref_add(folio, nr);
 		if (folio_test_anon(folio)) {
 			if (unlikely(folio_try_dup_anon_rmap_ptes(folio, page,
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

