Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194DE2F0C73
	for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2025 23:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755126360; cv=none; b=VUNJYJCx0vZrPYoCtIhJXlhB76RIQd/4txqMEe9sbIMdM4/mbi/IQLaMl5YE8LJwK+wql39MiTYgn01Q8CXzwtNdFYnjQ+TYA/83hOH4PJOPeF0n28JUCoSdXZm220hq+E7Hb411UFbkIvaLKIuU2UBFJOWgNq8In922Kr+8tks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755126360; c=relaxed/simple;
	bh=qHZAL7EArUdvFZrLBpVreOoXiVbXknG2K10wqHnEhok=;
	h=Date:To:From:Subject:Message-Id; b=saB0I1mDWMCfBfxRfM9BkR+sPB87CR18xgPTfWxsFVVecWZbKCgqTgfD0VpP2Njzs7Y0zIHXG6R2hwbXVHN4h1KWATyzJhR0q/o9FAr7S0WVbpl7AyL1YNaI9g6AGkfwg9GJWSNm1mBNHa4YdZUZlIlevfdynS3lfsYyVkdTVGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aeOyELRa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aeOyELRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9917BC4CEEB;
	Wed, 13 Aug 2025 23:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755126359;
	bh=qHZAL7EArUdvFZrLBpVreOoXiVbXknG2K10wqHnEhok=;
	h=Date:To:From:Subject:From;
	b=aeOyELRaw4Hm/Zlnj6McaZ6AwlkRwuYAXPPNEb53O6xxmFngDnklfodZS+91fRI2J
	 j0ndbmVu0tnuWoAXWpjk/3n+n6ByLPZ7g929pK6sTMCANheUotdQv4iwDnpmtNAPAe
	 9emOxnOAshTYHXmTZCtkXwSk6YGoKsFjwAxO8kVY=
Date: Wed, 13 Aug 2025 16:05:59 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,sweettea-kernel@dorminy.me,pasha.tatashin@soleen.com,nicholas@linux.ibm.com,mingo@kernel.org,maddy@linux.ibm.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,ajd@linux.ibm.com,rmclure@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_set.patch added to mm-new branch
Message-Id: <20250813230559.9917BC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_table_check: reinstate address parameter in [__]page_table_check_pmd[s]_set()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_set.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Rohan McLure <rmclure@linux.ibm.com>
Subject: mm/page_table_check: reinstate address parameter in [__]page_table_check_pmd[s]_set()
Date: Wed, 13 Aug 2025 16:26:05 +1000

This reverts commit a3b837130b58 ("mm/page_table_check: remove unused
parameter in [__]page_table_check_pmd_set").

Reinstate previously unused parameters for the purpose of supporting
powerpc platforms, as many do not encode user/kernel ownership of the page
in the pte, but instead in the address of the access.

Apply this to __page_table_check_pmds_set(), page_table_check_pmd_set(),
and the page_table_check_pmd_set() wrapper macro.

[ajd@linux.ibm.com: rebase on arm64 + riscv changes, update commit message]
Link: https://lkml.kernel.org/r/20250813062614.51759-5-ajd@linux.ibm.com
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Ingo Molnar <mingo@kernel.org>	[x86]
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Nicholas Miehlbradt <nicholas@linux.ibm.com>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    5 +++--
 arch/riscv/include/asm/pgtable.h |    4 ++--
 arch/x86/include/asm/pgtable.h   |    4 ++--
 include/linux/page_table_check.h |   12 ++++++------
 mm/page_table_check.c            |    4 ++--
 5 files changed, 15 insertions(+), 14 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_set
+++ a/arch/arm64/include/asm/pgtable.h
@@ -709,7 +709,8 @@ static inline void __set_ptes_anysz(stru
 		page_table_check_ptes_set(mm, ptep, pte, nr);
 		break;
 	case PMD_SIZE:
-		page_table_check_pmds_set(mm, (pmd_t *)ptep, pte_pmd(pte), nr);
+		page_table_check_pmds_set(mm, addr, (pmd_t *)ptep,
+					  pte_pmd(pte), nr);
 		break;
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SIZE:
@@ -1514,7 +1515,7 @@ static inline void pmdp_set_wrprotect(st
 static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(vma->vm_mm, pmdp, pmd);
+	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
 	return __pmd(xchg_relaxed(&pmd_val(*pmdp), pmd_val(pmd)));
 }
 #endif
--- a/arch/riscv/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_set
+++ a/arch/riscv/include/asm/pgtable.h
@@ -805,7 +805,7 @@ static inline pud_t pud_mkspecial(pud_t
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 				pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(mm, pmdp, pmd);
+	page_table_check_pmd_set(mm, addr, pmdp, pmd);
 	return __set_pte_at(mm, (pte_t *)pmdp, pmd_pte(pmd));
 }
 
@@ -876,7 +876,7 @@ static inline void pmdp_set_wrprotect(st
 static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 				unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(vma->vm_mm, pmdp, pmd);
+	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
 	return __pmd(atomic_long_xchg((atomic_long_t *)pmdp, pmd_val(pmd)));
 }
 
--- a/arch/x86/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_set
+++ a/arch/x86/include/asm/pgtable.h
@@ -1213,7 +1213,7 @@ static inline pud_t native_local_pudp_ge
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 			      pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(mm, pmdp, pmd);
+	page_table_check_pmd_set(mm, addr, pmdp, pmd);
 	set_pmd(pmdp, pmd);
 }
 
@@ -1356,7 +1356,7 @@ static inline void pmdp_set_wrprotect(st
 static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(vma->vm_mm, pmdp, pmd);
+	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
 	if (IS_ENABLED(CONFIG_SMP)) {
 		return xchg(pmdp, pmd);
 	} else {
--- a/include/linux/page_table_check.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_set
+++ a/include/linux/page_table_check.h
@@ -19,8 +19,8 @@ void __page_table_check_pmd_clear(struct
 void __page_table_check_pud_clear(struct mm_struct *mm, pud_t pud);
 void __page_table_check_ptes_set(struct mm_struct *mm, pte_t *ptep, pte_t pte,
 		unsigned int nr);
-void __page_table_check_pmds_set(struct mm_struct *mm, pmd_t *pmdp, pmd_t pmd,
-		unsigned int nr);
+void __page_table_check_pmds_set(struct mm_struct *mm, unsigned long addr,
+		pmd_t *pmdp, pmd_t pmd, unsigned int nr);
 void __page_table_check_puds_set(struct mm_struct *mm, unsigned long addr,
 		pud_t *pudp, pud_t pud, unsigned int nr);
 void __page_table_check_pte_clear_range(struct mm_struct *mm,
@@ -77,12 +77,12 @@ static inline void page_table_check_ptes
 }
 
 static inline void page_table_check_pmds_set(struct mm_struct *mm,
-		pmd_t *pmdp, pmd_t pmd, unsigned int nr)
+		unsigned long addr, pmd_t *pmdp, pmd_t pmd, unsigned int nr)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_pmds_set(mm, pmdp, pmd, nr);
+	__page_table_check_pmds_set(mm, addr, pmdp, pmd, nr);
 }
 
 static inline void page_table_check_puds_set(struct mm_struct *mm,
@@ -132,7 +132,7 @@ static inline void page_table_check_ptes
 }
 
 static inline void page_table_check_pmds_set(struct mm_struct *mm,
-		pmd_t *pmdp, pmd_t pmd, unsigned int nr)
+		unsigned long addr, pmd_t *pmdp, pmd_t pmd, unsigned int nr)
 {
 }
 
@@ -149,7 +149,7 @@ static inline void page_table_check_pte_
 
 #endif /* CONFIG_PAGE_TABLE_CHECK */
 
-#define page_table_check_pmd_set(mm, pmdp, pmd)	page_table_check_pmds_set(mm, pmdp, pmd, 1)
+#define page_table_check_pmd_set(mm, addr, pmdp, pmd)	page_table_check_pmds_set(mm, addr, pmdp, pmd, 1)
 #define page_table_check_pud_set(mm, addr, pudp, pud)	page_table_check_puds_set(mm, addr, pudp, pud, 1)
 
 #endif /* __LINUX_PAGE_TABLE_CHECK_H */
--- a/mm/page_table_check.c~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_set
+++ a/mm/page_table_check.c
@@ -218,8 +218,8 @@ static inline void page_table_check_pmd_
 		WARN_ON_ONCE(swap_cached_writable(pmd_to_swp_entry(pmd)));
 }
 
-void __page_table_check_pmds_set(struct mm_struct *mm, pmd_t *pmdp, pmd_t pmd,
-		unsigned int nr)
+void __page_table_check_pmds_set(struct mm_struct *mm, unsigned long addr,
+		pmd_t *pmdp, pmd_t pmd, unsigned int nr)
 {
 	unsigned long stride = PMD_SIZE >> PAGE_SHIFT;
 	unsigned int i;
_

Patches currently in -mm which might be from rmclure@linux.ibm.com are

mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_set.patch
mm-page_table_check-provide-addr-parameter-to-page_table_check_ptes_set.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_clear.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pte_clear.patch
mm-provide-address-parameter-to-ptemdud_user_accessible_page.patch
powerpc-mm-add-pud_pfn-stub.patch
powerpc-mm-implement-_user_accessible_page-for-ptes.patch
powerpc-mm-use-set_pte_at_unchecked-for-internal-usages.patch
powerpc-mm-support-page-table-check.patch

