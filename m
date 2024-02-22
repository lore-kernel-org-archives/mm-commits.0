Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF50137914
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644501; cv=none; b=GNzQ8N0pxrk1pYBRDyWGyGSfhLEYDDUPJBjt0a6WK702952C3WKNs7/a33RlRFFZ+aex7of4fkfuYxrXQsWnf9xD+wzLURKekFKdz3PjDoAV83RyPfpDjyle0ClWm8A9oEXpwji1iGAXdyJbl+HraJQDS5Jmgv81bTK4Ad22jCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644501; c=relaxed/simple;
	bh=VbgkkkXv8YbS+Rwy3vzzd/bCjoBt4eCGzW1RSOcatJE=;
	h=Date:To:From:Subject:Message-Id; b=qDv0ROt4u/hdOp4kwwmw5cCkxUVnBnF4HZIFv0FPWsgIaI+a6q/5fvTX7/WAwfs/xv+7Qd37CGbhoWOH5UNJtRkhl9ao6SL8EjMmzTADdb63d88bWZ3NMuDvuAz3H4aWi/hiWfnnXhffFUECmDl1PqwabYtODvbzLnuqQMU9Q7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QRsG3GHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QRsG3GHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BD7C433C7;
	Thu, 22 Feb 2024 23:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644501;
	bh=VbgkkkXv8YbS+Rwy3vzzd/bCjoBt4eCGzW1RSOcatJE=;
	h=Date:To:From:Subject:From;
	b=QRsG3GHav8Bb76dduteREssonMkt8rVXjGrF4F3mj70xUg49drO3FFMqMDrE3wJYn
	 6oUT8v6XIk+Tq4jstZknV24MRMZb9jQRseEDCXES5Yq9cJ2rUTD4s45msNff34YsSO
	 PD0UKEzbYzdpF4koe0wlKIzPSrVhQkvfOJV9hqiw=
Date: Thu, 22 Feb 2024 15:28:20 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,hpa@zytor.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,apopple@nvidia.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-automatically-fold-contpte-mappings.patch removed from -mm tree
Message-Id: <20240222232821.26BD7C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64/mm: automatically fold contpte mappings
has been removed from the -mm tree.  Its filename was
     arm64-mm-automatically-fold-contpte-mappings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: arm64/mm: automatically fold contpte mappings
Date: Thu, 15 Feb 2024 10:32:05 +0000

There are situations where a change to a single PTE could cause the
contpte block in which it resides to become foldable (i.e.  could be
repainted with the contiguous bit).  Such situations arise, for example,
when user space temporarily changes protections, via mprotect, for
individual pages, such can be the case for certain garbage collectors.

We would like to detect when such a PTE change occurs.  However this can
be expensive due to the amount of checking required.  Therefore only
perform the checks when an indiviual PTE is modified via mprotect
(ptep_modify_prot_commit() -> set_pte_at() -> set_ptes(nr=1)) and only
when we are setting the final PTE in a contpte-aligned block.

Link: https://lkml.kernel.org/r/20240215103205.2607016-19-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morse <james.morse@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |   26 +++++++++++
 arch/arm64/mm/contpte.c          |   64 +++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-automatically-fold-contpte-mappings
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1185,6 +1185,8 @@ extern void ptep_modify_prot_commit(stru
  * where it is possible and makes sense to do so. The PTE_CONT bit is considered
  * a private implementation detail of the public ptep API (see below).
  */
+extern void __contpte_try_fold(struct mm_struct *mm, unsigned long addr,
+				pte_t *ptep, pte_t pte);
 extern void __contpte_try_unfold(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, pte_t pte);
 extern pte_t contpte_ptep_get(pte_t *ptep, pte_t orig_pte);
@@ -1206,6 +1208,29 @@ extern int contpte_ptep_set_access_flags
 				unsigned long addr, pte_t *ptep,
 				pte_t entry, int dirty);
 
+static __always_inline void contpte_try_fold(struct mm_struct *mm,
+				unsigned long addr, pte_t *ptep, pte_t pte)
+{
+	/*
+	 * Only bother trying if both the virtual and physical addresses are
+	 * aligned and correspond to the last entry in a contig range. The core
+	 * code mostly modifies ranges from low to high, so this is the likely
+	 * the last modification in the contig range, so a good time to fold.
+	 * We can't fold special mappings, because there is no associated folio.
+	 */
+
+	const unsigned long contmask = CONT_PTES - 1;
+	bool valign = ((addr >> PAGE_SHIFT) & contmask) == contmask;
+
+	if (unlikely(valign)) {
+		bool palign = (pte_pfn(pte) & contmask) == contmask;
+
+		if (unlikely(palign &&
+		    pte_valid(pte) && !pte_cont(pte) && !pte_special(pte)))
+			__contpte_try_fold(mm, addr, ptep, pte);
+	}
+}
+
 static __always_inline void contpte_try_unfold(struct mm_struct *mm,
 				unsigned long addr, pte_t *ptep, pte_t pte)
 {
@@ -1286,6 +1311,7 @@ static __always_inline void set_ptes(str
 	if (likely(nr == 1)) {
 		contpte_try_unfold(mm, addr, ptep, __ptep_get(ptep));
 		__set_ptes(mm, addr, ptep, pte, 1);
+		contpte_try_fold(mm, addr, ptep, pte);
 	} else {
 		contpte_set_ptes(mm, addr, ptep, pte, nr);
 	}
--- a/arch/arm64/mm/contpte.c~arm64-mm-automatically-fold-contpte-mappings
+++ a/arch/arm64/mm/contpte.c
@@ -73,6 +73,70 @@ static void contpte_convert(struct mm_st
 	__set_ptes(mm, start_addr, start_ptep, pte, CONT_PTES);
 }
 
+void __contpte_try_fold(struct mm_struct *mm, unsigned long addr,
+			pte_t *ptep, pte_t pte)
+{
+	/*
+	 * We have already checked that the virtual and pysical addresses are
+	 * correctly aligned for a contpte mapping in contpte_try_fold() so the
+	 * remaining checks are to ensure that the contpte range is fully
+	 * covered by a single folio, and ensure that all the ptes are valid
+	 * with contiguous PFNs and matching prots. We ignore the state of the
+	 * access and dirty bits for the purpose of deciding if its a contiguous
+	 * range; the folding process will generate a single contpte entry which
+	 * has a single access and dirty bit. Those 2 bits are the logical OR of
+	 * their respective bits in the constituent pte entries. In order to
+	 * ensure the contpte range is covered by a single folio, we must
+	 * recover the folio from the pfn, but special mappings don't have a
+	 * folio backing them. Fortunately contpte_try_fold() already checked
+	 * that the pte is not special - we never try to fold special mappings.
+	 * Note we can't use vm_normal_page() for this since we don't have the
+	 * vma.
+	 */
+
+	unsigned long folio_start, folio_end;
+	unsigned long cont_start, cont_end;
+	pte_t expected_pte, subpte;
+	struct folio *folio;
+	struct page *page;
+	unsigned long pfn;
+	pte_t *orig_ptep;
+	pgprot_t prot;
+
+	int i;
+
+	if (!mm_is_user(mm))
+		return;
+
+	page = pte_page(pte);
+	folio = page_folio(page);
+	folio_start = addr - (page - &folio->page) * PAGE_SIZE;
+	folio_end = folio_start + folio_nr_pages(folio) * PAGE_SIZE;
+	cont_start = ALIGN_DOWN(addr, CONT_PTE_SIZE);
+	cont_end = cont_start + CONT_PTE_SIZE;
+
+	if (folio_start > cont_start || folio_end < cont_end)
+		return;
+
+	pfn = ALIGN_DOWN(pte_pfn(pte), CONT_PTES);
+	prot = pte_pgprot(pte_mkold(pte_mkclean(pte)));
+	expected_pte = pfn_pte(pfn, prot);
+	orig_ptep = ptep;
+	ptep = contpte_align_down(ptep);
+
+	for (i = 0; i < CONT_PTES; i++) {
+		subpte = pte_mkold(pte_mkclean(__ptep_get(ptep)));
+		if (!pte_same(subpte, expected_pte))
+			return;
+		expected_pte = pte_advance_pfn(expected_pte, 1);
+		ptep++;
+	}
+
+	pte = pte_mkcont(pte);
+	contpte_convert(mm, addr, orig_ptep, pte);
+}
+EXPORT_SYMBOL(__contpte_try_fold);
+
 void __contpte_try_unfold(struct mm_struct *mm, unsigned long addr,
 			pte_t *ptep, pte_t pte)
 {
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


