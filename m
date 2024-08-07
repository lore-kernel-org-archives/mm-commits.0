Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A099D149DE4
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 21:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723066016; cv=none; b=ksLhFlTm4Hal3PQeO1OrEInmyv2y/sbjVN1mMk4mdNEFfeik5L7mYd6vkcn6hvKRczbEHADPfb1YK3YmtDpJ8qcafT49SDxNXmNuQZIeK28RYpAQ6USUx4sPvZQBOJXyM+8uRKc/O1haDs6sM4qjeBWs+hmha0rSHcreCXNWHxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723066016; c=relaxed/simple;
	bh=8MlPPo2ZNkl9yF6USqLF8yAeFiE8MFuVGVLx3gZKZSc=;
	h=Date:To:From:Subject:Message-Id; b=Mt7OzFRYY+w7h7YHoKlfBNvkbumxB7xdrE0HMf+bEoVW6rUjSqDpjF+XZqcOevhRUzq2DBFEtFfDHYNle7rrP+ZuvQhR9O3dvukmrENmSMN7siMjvSjb8QPyiB6vbUkiYYJKHplHIExrzrcqFqzGi6RkHMRpU3AcsbS2r7pkShA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I53Wm+n0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I53Wm+n0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591C6C32781;
	Wed,  7 Aug 2024 21:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723066016;
	bh=8MlPPo2ZNkl9yF6USqLF8yAeFiE8MFuVGVLx3gZKZSc=;
	h=Date:To:From:Subject:From;
	b=I53Wm+n01fXcyDGiwWOVtLBAn1rpn5BZBgXJMIf2hLH+G3O400dONSp5XICBlUVWR
	 awNamvOZvFOl65kOUFTL6rpIkGhMem2Hevr247gnmcoznSVHAtuMgFtZ89K4FCDunL
	 Lkw7FGb5loFintrBOGEXHakAeltAkFZPZakWU5Lg=
Date: Wed, 07 Aug 2024 14:26:55 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,seanjc@google.com,rientjes@google.com,riel@surriel.com,rick.p.edgecombe@intel.com,pbonzini@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mgorman@techsingularity.net,kirill@shutemov.name,jthoughton@google.com,hughd@google.com,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,aneesh.kumar@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-powerpc-add-missing-pud-helpers.patch added to mm-unstable branch
Message-Id: <20240807212656.591C6C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/powerpc: add missing pud helpers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-powerpc-add-missing-pud-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-powerpc-add-missing-pud-helpers.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/powerpc: add missing pud helpers
Date: Wed, 7 Aug 2024 15:48:07 -0400

These new helpers will be needed for pud entry updates soon.  Introduce
them by referencing the pmd ones.  Namely:

- pudp_invalidate()
- pud_modify()

Link: https://lkml.kernel.org/r/20240807194812.819412-4-peterx@redhat.com
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
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
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

mm-dax-dump-start-address-in-fault-handler.patch
mm-mprotect-push-mmu-notifier-to-puds.patch
mm-powerpc-add-missing-pud-helpers.patch
mm-x86-make-pud_leaf-only-care-about-pse-bit.patch
mm-x86-arch_check_zapped_pud.patch
mm-x86-add-missing-pud-helpers.patch
mm-mprotect-fix-dax-pud-handlings.patch

