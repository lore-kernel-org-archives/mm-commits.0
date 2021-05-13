Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A08C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 00:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1972561406
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 00:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbhEMArB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 20:47:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240006AbhEMAnu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 20:43:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60A99613CA;
        Thu, 13 May 2021 00:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620866554;
        bh=1o2HKPR8htRmd24GAsPak7OCId6L06vqKojR1a7zZAo=;
        h=Date:From:To:Subject:From;
        b=yO707oGskvufvgNV+u6onYtQyoK/jdgHpMHh4GXWW3JijEkbS516pxdlCRrf6jMtS
         VwWuLCI847gQGkZSSIywUyf96G+as4M90TvRwN+Eh2Vrp/2cZGhgwMs1rmTOQnxEw/
         1Ook1jHWN9yLRvh+BMXcvmEsFsPcPgKgExO0d0BA=
Date:   Wed, 12 May 2021 17:42:33 -0700
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, christophe.leroy@csgroup.eu,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, npiggin@gmail.com, paulus@samba.org,
        rppt@kernel.org, uladzislau.rezki@sony.com
Subject:  +
 mm-hugetlb-change-parameters-of-arch_make_huge_pte.patch added to -mm tree
Message-ID: <20210513004233.zZxvoRfsP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: change parameters of arch_make_huge_pte()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-change-parameters-of-arch_make_huge_pte.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-change-parameters-of-arch_make_huge_pte.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-change-parameters-of-arch_make_huge_pte.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm/hugetlb: change parameters of arch_make_huge_pte()

Patch series "Subject: [PATCH v2 0/5] Implement huge VMAP and VMALLOC on powerpc 8xx", v2.

This series implements huge VMAP and VMALLOC on powerpc 8xx.

Powerpc 8xx has 4 page sizes:
- 4k
- 16k
- 512k
- 8M

At the time being, vmalloc and vmap only support huge pages which are
leaf at PMD level.

Here the PMD level is 4M, it doesn't correspond to any supported
page size.

For now, implement use of 16k and 512k pages which is done
at PTE level.

Support of 8M pages will be implemented later, it requires use of
hugepd tables.

To allow this, the architecture provides two functions:
- arch_vmap_pte_range_map_size() which tells vmap_pte_range() what
page size to use. A stub returning PAGE_SIZE is provided when the
architecture doesn't provide this function.
- arch_vmap_pte_supported_shift() which tells __vmalloc_node_range()
what page shift to use for a given area size. A stub returning
PAGE_SHIFT is provided when the architecture doesn't provide this
function.


This patch (of 5):

At the time being, arch_make_huge_pte() has the following prototype:

  pte_t arch_make_huge_pte(pte_t entry, struct vm_area_struct *vma,
			   struct page *page, int writable);

vma is used to get the pages shift or size.
vma is also used on Sparc to get vm_flags.
page is not used.
writable is not used.

In order to use this function without a vma, replace vma by shift and
flags.  Also remove the used parameters.

Link: https://lkml.kernel.org/r/cover.1620795204.git.christophe.leroy@csgroup.eu
Link: https://lkml.kernel.org/r/f4633ac6a7da2f22f31a04a89e0a7026bb78b15b.1620795204.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Uladzislau Rezki <uladzislau.rezki@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/hugetlb.h                 |    3 +--
 arch/arm64/mm/hugetlbpage.c                      |    5 ++---
 arch/powerpc/include/asm/nohash/32/hugetlb-8xx.h |    5 ++---
 arch/sparc/include/asm/pgtable_64.h              |    3 +--
 arch/sparc/mm/hugetlbpage.c                      |    6 ++----
 include/linux/hugetlb.h                          |    4 ++--
 mm/hugetlb.c                                     |    6 ++++--
 mm/migrate.c                                     |    4 +++-
 8 files changed, 17 insertions(+), 19 deletions(-)

--- a/arch/arm64/include/asm/hugetlb.h~mm-hugetlb-change-parameters-of-arch_make_huge_pte
+++ a/arch/arm64/include/asm/hugetlb.h
@@ -23,8 +23,7 @@ static inline void arch_clear_hugepage_f
 }
 #define arch_clear_hugepage_flags arch_clear_hugepage_flags
 
-extern pte_t arch_make_huge_pte(pte_t entry, struct vm_area_struct *vma,
-				struct page *page, int writable);
+pte_t arch_make_huge_pte(pte_t entry, unsigned int shift, vm_flags_t flags);
 #define arch_make_huge_pte arch_make_huge_pte
 #define __HAVE_ARCH_HUGE_SET_HUGE_PTE_AT
 extern void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
--- a/arch/arm64/mm/hugetlbpage.c~mm-hugetlb-change-parameters-of-arch_make_huge_pte
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -339,10 +339,9 @@ pte_t *huge_pte_offset(struct mm_struct
 	return NULL;
 }
 
-pte_t arch_make_huge_pte(pte_t entry, struct vm_area_struct *vma,
-			 struct page *page, int writable)
+pte_t arch_make_huge_pte(pte_t entry, unsigned int shift, vm_flags_t flags)
 {
-	size_t pagesize = huge_page_size(hstate_vma(vma));
+	size_t pagesize = 1UL << shift;
 
 	if (pagesize == CONT_PTE_SIZE) {
 		entry = pte_mkcont(entry);
--- a/arch/powerpc/include/asm/nohash/32/hugetlb-8xx.h~mm-hugetlb-change-parameters-of-arch_make_huge_pte
+++ a/arch/powerpc/include/asm/nohash/32/hugetlb-8xx.h
@@ -66,10 +66,9 @@ static inline void huge_ptep_set_wrprote
 }
 
 #ifdef CONFIG_PPC_4K_PAGES
-static inline pte_t arch_make_huge_pte(pte_t entry, struct vm_area_struct *vma,
-				       struct page *page, int writable)
+static inline pte_t arch_make_huge_pte(pte_t entry, unsigned int shift, vm_flags_t flags)
 {
-	size_t size = huge_page_size(hstate_vma(vma));
+	size_t size = 1UL << shift;
 
 	if (size == SZ_16K)
 		return __pte(pte_val(entry) & ~_PAGE_HUGE);
--- a/arch/sparc/include/asm/pgtable_64.h~mm-hugetlb-change-parameters-of-arch_make_huge_pte
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -377,8 +377,7 @@ static inline pgprot_t pgprot_noncached(
 #define pgprot_noncached pgprot_noncached
 
 #if defined(CONFIG_HUGETLB_PAGE) || defined(CONFIG_TRANSPARENT_HUGEPAGE)
-extern pte_t arch_make_huge_pte(pte_t entry, struct vm_area_struct *vma,
-				struct page *page, int writable);
+pte_t arch_make_huge_pte(pte_t entry, unsigned int shift, vm_flags_t flags);
 #define arch_make_huge_pte arch_make_huge_pte
 static inline unsigned long __pte_default_huge_mask(void)
 {
--- a/arch/sparc/mm/hugetlbpage.c~mm-hugetlb-change-parameters-of-arch_make_huge_pte
+++ a/arch/sparc/mm/hugetlbpage.c
@@ -177,10 +177,8 @@ static pte_t hugepage_shift_to_tte(pte_t
 		return sun4u_hugepage_shift_to_tte(entry, shift);
 }
 
-pte_t arch_make_huge_pte(pte_t entry, struct vm_area_struct *vma,
-			 struct page *page, int writeable)
+pte_t arch_make_huge_pte(pte_t entry, unsigned int shift, vm_flags_t flags)
 {
-	unsigned int shift = huge_page_shift(hstate_vma(vma));
 	pte_t pte;
 
 	pte = hugepage_shift_to_tte(entry, shift);
@@ -188,7 +186,7 @@ pte_t arch_make_huge_pte(pte_t entry, st
 #ifdef CONFIG_SPARC64
 	/* If this vma has ADI enabled on it, turn on TTE.mcd
 	 */
-	if (vma->vm_flags & VM_SPARC_ADI)
+	if (flags & VM_SPARC_ADI)
 		return pte_mkmcd(pte);
 	else
 		return pte_mknotmcd(pte);
--- a/include/linux/hugetlb.h~mm-hugetlb-change-parameters-of-arch_make_huge_pte
+++ a/include/linux/hugetlb.h
@@ -733,8 +733,8 @@ static inline void arch_clear_hugepage_f
 #endif
 
 #ifndef arch_make_huge_pte
-static inline pte_t arch_make_huge_pte(pte_t entry, struct vm_area_struct *vma,
-				       struct page *page, int writable)
+static inline pte_t arch_make_huge_pte(pte_t entry, unsigned int shift,
+				       vm_flags_t flags)
 {
 	return entry;
 }
--- a/mm/hugetlb.c~mm-hugetlb-change-parameters-of-arch_make_huge_pte
+++ a/mm/hugetlb.c
@@ -3992,6 +3992,7 @@ static pte_t make_huge_pte(struct vm_are
 				int writable)
 {
 	pte_t entry;
+	unsigned int shift = huge_page_shift(hstate_vma(vma));
 
 	if (writable) {
 		entry = huge_pte_mkwrite(huge_pte_mkdirty(mk_huge_pte(page,
@@ -4002,7 +4003,7 @@ static pte_t make_huge_pte(struct vm_are
 	}
 	entry = pte_mkyoung(entry);
 	entry = pte_mkhuge(entry);
-	entry = arch_make_huge_pte(entry, vma, page, writable);
+	entry = arch_make_huge_pte(entry, shift, vma->vm_flags);
 
 	return entry;
 }
@@ -5387,10 +5388,11 @@ unsigned long hugetlb_change_protection(
 		}
 		if (!huge_pte_none(pte)) {
 			pte_t old_pte;
+			unsigned int shift = huge_page_shift(hstate_vma(vma));
 
 			old_pte = huge_ptep_modify_prot_start(vma, address, ptep);
 			pte = pte_mkhuge(huge_pte_modify(old_pte, newprot));
-			pte = arch_make_huge_pte(pte, vma, NULL, 0);
+			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
 			huge_ptep_modify_prot_commit(vma, address, ptep, old_pte, pte);
 			pages++;
 		}
--- a/mm/migrate.c~mm-hugetlb-change-parameters-of-arch_make_huge_pte
+++ a/mm/migrate.c
@@ -226,8 +226,10 @@ static bool remove_migration_pte(struct
 
 #ifdef CONFIG_HUGETLB_PAGE
 		if (PageHuge(new)) {
+			unsigned int shift = huge_page_shift(hstate_vma(vma));
+
 			pte = pte_mkhuge(pte);
-			pte = arch_make_huge_pte(pte, vma, new, 0);
+			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
 			set_huge_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
 			if (PageAnon(new))
 				hugepage_add_anon_rmap(new, vma, pvmw.address);
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-hugetlb-change-parameters-of-arch_make_huge_pte.patch
mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge.patch
mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmap.patch
mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmalloc.patch
powerpc-8xx-add-support-for-huge-pages-on-vmap-and-vmalloc.patch

