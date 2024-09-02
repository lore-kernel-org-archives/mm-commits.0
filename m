Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B035381E
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247801; cv=none; b=XCR/1oqb04cDMMEHiQEou9M2pBQ4bkmsGzMrvsySbgMUrxnOjisczItjTkdETuaMOaLfVyiEAxqsRSBZnCwBtEBGTj0BWVF9ddIFaGok5nHXXrjtXzNVysxDCaWrVGxoDpcdaFvSUmioeavLH6xnp+mF0n57GPIiedqwkBzqje0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247801; c=relaxed/simple;
	bh=BG1uZBvPFlv19jgxt8q3kn9VZLGvQKCAxL995qFWe1k=;
	h=Date:To:From:Subject:Message-Id; b=FlDiqmSPxLikZ13AAVjwAi2qiwhKsGHu8CwvwvN7ImRVUKhBADSYiHcyPQnEI4by3uKB8nn3DdBj03ZPA83X32/LH0O/ZNxe57hdniHQcsfsidV9hjNRD5+rUQsRXSyohRkkjqVjRTQn7i73pjNLKrvHgyIWXDe05PkX65Is2PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WUxaVexm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WUxaVexm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1695C4CEC2;
	Mon,  2 Sep 2024 03:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247800;
	bh=BG1uZBvPFlv19jgxt8q3kn9VZLGvQKCAxL995qFWe1k=;
	h=Date:To:From:Subject:From;
	b=WUxaVexmu1+mJFzfIDyZ53mglUC2ctqN9Hb1XsbO/t9BR2y+YStDQqIYJCg9upc4I
	 QBkQTGNYturYKeOr0v7cVUJYwSaD5HlL7lEPcUKzHoAlG551KpO1wxFbdbPP6txTb2
	 HrQ+XtjSUXLsx9DEWF/3V498W1eUsJZoBZ5YvNII=
Date: Sun, 01 Sep 2024 20:30:00 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,seanjc@google.com,rientjes@google.com,riel@surriel.com,rick.p.edgecombe@intel.com,pbonzini@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,kirill@shutemov.name,hughd@google.com,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,aneesh.kumar@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-x86-add-missing-pud-helpers.patch removed from -mm tree
Message-Id: <20240902033000.D1695C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/x86: add missing pud helpers
has been removed from the -mm tree.  Its filename was
     mm-x86-add-missing-pud-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/x86: add missing pud helpers
Date: Mon, 12 Aug 2024 14:12:24 -0400

Some new helpers will be needed for pud entry updates soon.  Introduce
these helpers by referencing the pmd ones.  Namely:

  - pudp_invalidate(): this helper invalidates a huge pud before a
    split happens, so that the invalidated pud entry will make sure no
    race will happen (either with software, like a concurrent zap, or
    hardware, like a/d bit lost).

  - pud_modify(): this helper applies a new pgprot to an existing huge
    pud mapping.

For more information on why we need these two helpers, please refer to the
corresponding pmd helpers in the mprotect() code path.

When at it, simplify the pud_modify()/pmd_modify() comments on shadow
stack pgtable entries to reference pte_modify() to avoid duplicating the
whole paragraph three times.

Link: https://lkml.kernel.org/r/20240812181225.1360970-7-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |   57 ++++++++++++++++++++++++++-----
 arch/x86/mm/pgtable.c          |   12 ++++++
 2 files changed, 61 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~mm-x86-add-missing-pud-helpers
+++ a/arch/x86/include/asm/pgtable.h
@@ -787,6 +787,12 @@ static inline pmd_t pmd_mkinvalid(pmd_t
 		      __pgprot(pmd_flags(pmd) & ~(_PAGE_PRESENT|_PAGE_PROTNONE)));
 }
 
+static inline pud_t pud_mkinvalid(pud_t pud)
+{
+	return pfn_pud(pud_pfn(pud),
+		       __pgprot(pud_flags(pud) & ~(_PAGE_PRESENT|_PAGE_PROTNONE)));
+}
+
 static inline u64 flip_protnone_guard(u64 oldval, u64 val, u64 mask);
 
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
@@ -834,14 +840,8 @@ static inline pmd_t pmd_modify(pmd_t pmd
 	pmd_result = __pmd(val);
 
 	/*
-	 * To avoid creating Write=0,Dirty=1 PMDs, pte_modify() needs to avoid:
-	 *  1. Marking Write=0 PMDs Dirty=1
-	 *  2. Marking Dirty=1 PMDs Write=0
-	 *
-	 * The first case cannot happen because the _PAGE_CHG_MASK will filter
-	 * out any Dirty bit passed in newprot. Handle the second case by
-	 * going through the mksaveddirty exercise. Only do this if the old
-	 * value was Write=1 to avoid doing this on Shadow Stack PTEs.
+	 * Avoid creating shadow stack PMD by accident.  See comment in
+	 * pte_modify().
 	 */
 	if (oldval & _PAGE_RW)
 		pmd_result = pmd_mksaveddirty(pmd_result);
@@ -851,6 +851,29 @@ static inline pmd_t pmd_modify(pmd_t pmd
 	return pmd_result;
 }
 
+static inline pud_t pud_modify(pud_t pud, pgprot_t newprot)
+{
+	pudval_t val = pud_val(pud), oldval = val;
+	pud_t pud_result;
+
+	val &= _HPAGE_CHG_MASK;
+	val |= check_pgprot(newprot) & ~_HPAGE_CHG_MASK;
+	val = flip_protnone_guard(oldval, val, PHYSICAL_PUD_PAGE_MASK);
+
+	pud_result = __pud(val);
+
+	/*
+	 * Avoid creating shadow stack PUD by accident.  See comment in
+	 * pte_modify().
+	 */
+	if (oldval & _PAGE_RW)
+		pud_result = pud_mksaveddirty(pud_result);
+	else
+		pud_result = pud_clear_saveddirty(pud_result);
+
+	return pud_result;
+}
+
 /*
  * mprotect needs to preserve PAT and encryption bits when updating
  * vm_page_prot
@@ -1389,10 +1412,28 @@ static inline pmd_t pmdp_establish(struc
 }
 #endif
 
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+static inline pud_t pudp_establish(struct vm_area_struct *vma,
+		unsigned long address, pud_t *pudp, pud_t pud)
+{
+	page_table_check_pud_set(vma->vm_mm, pudp, pud);
+	if (IS_ENABLED(CONFIG_SMP)) {
+		return xchg(pudp, pud);
+	} else {
+		pud_t old = *pudp;
+		WRITE_ONCE(*pudp, pud);
+		return old;
+	}
+}
+#endif
+
 #define __HAVE_ARCH_PMDP_INVALIDATE_AD
 extern pmd_t pmdp_invalidate_ad(struct vm_area_struct *vma,
 				unsigned long address, pmd_t *pmdp);
 
+pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
+		      pud_t *pudp);
+
 /*
  * Page table pages are page-aligned.  The lower half of the top
  * level is used for userspace and the top half for the kernel.
--- a/arch/x86/mm/pgtable.c~mm-x86-add-missing-pud-helpers
+++ a/arch/x86/mm/pgtable.c
@@ -641,6 +641,18 @@ pmd_t pmdp_invalidate_ad(struct vm_area_
 }
 #endif
 
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
+	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
+pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
+		     pud_t *pudp)
+{
+	VM_WARN_ON_ONCE(!pud_present(*pudp));
+	pud_t old = pudp_establish(vma, address, pudp, pud_mkinvalid(*pudp));
+	flush_pud_tlb_range(vma, address, address + HPAGE_PUD_SIZE);
+	return old;
+}
+#endif
+
 /**
  * reserve_top_address - reserves a hole in the top of kernel address space
  * @reserve - size of hole to reserve
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-introduce-arch_supports_huge_pfnmap-and-special-bits-to-pmd-pud.patch
mm-drop-is_huge_zero_pud.patch
mm-mark-special-bits-for-huge-pfn-mappings-when-inject.patch
mm-allow-thp-orders-for-pfnmaps.patch
mm-gup-detect-huge-pfnmap-entries-in-gup-fast.patch
mm-pagewalk-check-pfnmap-for-folio_walk_start.patch
mm-pagewalk-check-pfnmap-for-folio_walk_start-fix.patch
mm-fork-accept-huge-pfnmap-entries.patch
mm-always-define-pxx_pgprot.patch
mm-new-follow_pfnmap-api.patch
kvm-use-follow_pfnmap-api.patch
s390-pci_mmio-use-follow_pfnmap-api.patch
mm-x86-pat-use-the-new-follow_pfnmap-api.patch
vfio-use-the-new-follow_pfnmap-api.patch
acrn-use-the-new-follow_pfnmap-api.patch
mm-access_process_vm-use-the-new-follow_pfnmap-api.patch
mm-remove-follow_pte.patch
mm-x86-support-large-pfn-mappings.patch
mm-arm64-support-large-pfn-mappings.patch

