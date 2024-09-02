Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DED1605BA
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247796; cv=none; b=UKai2eiJEXK4VM9Au3+8q+wBg3AOWTyYHmvfzIE8fz+vfY2guUcHILPAIf4zqkimNmMvblzZhHdr2fWMoOy+ExRWvZzA+wpjthQhiKvGcUKuluaNTDhGk1HPEqitOZJdH+99nx+DskRP9M9paClbmfZ7OE8EYT5sqqi9ERlY/6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247796; c=relaxed/simple;
	bh=Zrs0Ta/KRfpCVWnjA6CrTFwGzI788p2ERMeUppzlRzM=;
	h=Date:To:From:Subject:Message-Id; b=RLtYd2vmTvXUlMLo6Sp+EGK2XA4YsfVxEQD1ioZsPA+cXYzBZ8Qd23YYLKjZ+yaKsoIexD/BIVQ5oDjNCr7yC8k8yDjBTFGAfYn/jCGQOnYFR4zAC3I/U0knmukrDLfiuKLIjpLBP2eyBJ596JMDODkjJivWJm17OgD58W8qtvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2V4WMIel; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2V4WMIel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1405CC4CEC2;
	Mon,  2 Sep 2024 03:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247796;
	bh=Zrs0Ta/KRfpCVWnjA6CrTFwGzI788p2ERMeUppzlRzM=;
	h=Date:To:From:Subject:From;
	b=2V4WMIelmI6mKVQ6Xa/hOByCcJy9Ah901DqRmCUb1LeEpHnZpUdBAPgYBUUW6+xDc
	 OF6OyyquodYP3sKPtYAjNwi6EGaU6KRXWXOGlOSAGEl5IK/dd6gYARyss049J5rHEn
	 LjLhZdxWY3fCVIUhtFMeLPiIWzoYS/MY2TJdp0FI=
Date: Sun, 01 Sep 2024 20:29:55 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,seanjc@google.com,rientjes@google.com,riel@surriel.com,rick.p.edgecombe@intel.com,pbonzini@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,kirill@shutemov.name,hughd@google.com,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,aneesh.kumar@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-powerpc-add-missing-pud-helpers.patch removed from -mm tree
Message-Id: <20240902032956.1405CC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/powerpc: add missing pud helpers
has been removed from the -mm tree.  Its filename was
     mm-powerpc-add-missing-pud-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/powerpc: add missing pud helpers
Date: Mon, 12 Aug 2024 14:12:21 -0400

Some new helpers will be needed for pud entry updates soon.  Introduce
these helpers by referencing the pmd ones.  Namely:

  - pudp_invalidate(): this helper invalidates a huge pud before a split
  happens, so that the invalidated pud entry will make sure no race will
  happen (either with software, like a concurrent zap, or hardware, like
  a/d bit lost).

  - pud_modify(): this helper applies a new pgprot to an existing huge pud
  mapping.

For more information on why we need these two helpers, please refer to the
corresponding pmd helpers in the mprotect() code path.

Link: https://lkml.kernel.org/r/20240812181225.1360970-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/pgtable.h |    3 ++
 arch/powerpc/mm/book3s64/pgtable.c           |   20 +++++++++++++++++
 2 files changed, 23 insertions(+)

--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~mm-powerpc-add-missing-pud-helpers
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1124,6 +1124,7 @@ extern pmd_t pfn_pmd(unsigned long pfn,
 extern pud_t pfn_pud(unsigned long pfn, pgprot_t pgprot);
 extern pmd_t mk_pmd(struct page *page, pgprot_t pgprot);
 extern pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot);
+extern pud_t pud_modify(pud_t pud, pgprot_t newprot);
 extern void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 		       pmd_t *pmdp, pmd_t pmd);
 extern void set_pud_at(struct mm_struct *mm, unsigned long addr,
@@ -1384,6 +1385,8 @@ static inline pgtable_t pgtable_trans_hu
 #define __HAVE_ARCH_PMDP_INVALIDATE
 extern pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 			     pmd_t *pmdp);
+extern pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
+			     pud_t *pudp);
 
 #define pmd_move_must_withdraw pmd_move_must_withdraw
 struct spinlock;
--- a/arch/powerpc/mm/book3s64/pgtable.c~mm-powerpc-add-missing-pud-helpers
+++ a/arch/powerpc/mm/book3s64/pgtable.c
@@ -176,6 +176,17 @@ pmd_t pmdp_invalidate(struct vm_area_str
 	return __pmd(old_pmd);
 }
 
+pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
+		      pud_t *pudp)
+{
+	unsigned long old_pud;
+
+	VM_WARN_ON_ONCE(!pud_present(*pudp));
+	old_pud = pud_hugepage_update(vma->vm_mm, address, pudp, _PAGE_PRESENT, _PAGE_INVALID);
+	flush_pud_tlb_range(vma, address, address + HPAGE_PUD_SIZE);
+	return __pud(old_pud);
+}
+
 pmd_t pmdp_huge_get_and_clear_full(struct vm_area_struct *vma,
 				   unsigned long addr, pmd_t *pmdp, int full)
 {
@@ -259,6 +270,15 @@ pmd_t pmd_modify(pmd_t pmd, pgprot_t new
 	pmdv &= _HPAGE_CHG_MASK;
 	return pmd_set_protbits(__pmd(pmdv), newprot);
 }
+
+pud_t pud_modify(pud_t pud, pgprot_t newprot)
+{
+	unsigned long pudv;
+
+	pudv = pud_val(pud);
+	pudv &= _HPAGE_CHG_MASK;
+	return pud_set_protbits(__pud(pudv), newprot);
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 /* For use by kexec, called with MMU off */
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

