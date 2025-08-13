Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855172F3C0D
	for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2025 23:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755126363; cv=none; b=pvjsMwSNLiTNPRaor5qoBZ9k/PRC+z6+16T6NNPtPhy9rmsnDZr/toOZkCUEBCWT0+438pnHsCgUbnY7NxQkvD2304mXKmSTnhv+Do/e4U6vQbBgbWFfgmLmjbdQfoXMpP/fgD2i0hlTCFiDtcPZHa03uBCISOpNJ4kNP6BBU5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755126363; c=relaxed/simple;
	bh=BCrTc6UrARprO04iV4jZD0F4MHENZ3kzbbKmlVg1a0I=;
	h=Date:To:From:Subject:Message-Id; b=AefnQUBhzIBk6UFg4xaiPIPWF3hR3BkeviYjA4WApP/d+bmPes9iXfQLAOHP4qg3uYhI/Jygybb52mkiBVdE9In5wUFNo29EmJUK0hCO9kYmoLNzpJnNRHWXCFrEHnbhiO6i8vtiCIQKP6lRUKR/pZA3ZYAuAfjowLi3iSvp2P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jp0puAmY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jp0puAmY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52370C4CEEB;
	Wed, 13 Aug 2025 23:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755126363;
	bh=BCrTc6UrARprO04iV4jZD0F4MHENZ3kzbbKmlVg1a0I=;
	h=Date:To:From:Subject:From;
	b=jp0puAmYQbxVKXpSF8UD9K5QfrZs2886a1Z82JCcCERIeDTlL/2l5CYmlk0ToSKwv
	 K015X3gBCtkDZHaRlOhlz4bg/C5GBRD0I2tCjoDpLK+2AFH/TQh4b94Ms9S8fXcfEz
	 m+umbdVUoBmufQ7H5cdadMX+8CA1j4vka5FvaHZM=
Date: Wed, 13 Aug 2025 16:06:02 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,sweettea-kernel@dorminy.me,pasha.tatashin@soleen.com,nicholas@linux.ibm.com,mingo@kernel.org,maddy@linux.ibm.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,ajd@linux.ibm.com,rmclure@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-provide-addr-parameter-to-page_table_check_ptes_set.patch added to mm-new branch
Message-Id: <20250813230603.52370C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_table_check: provide addr parameter to page_table_check_ptes_set()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_table_check-provide-addr-parameter-to-page_table_check_ptes_set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_table_check-provide-addr-parameter-to-page_table_check_ptes_set.patch

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
Subject: mm/page_table_check: provide addr parameter to page_table_check_ptes_set()
Date: Wed, 13 Aug 2025 16:26:06 +1000

To provide support for powerpc platforms, provide an addr parameter to the
__page_table_check_ptes_set() and page_table_check_ptes_set() routines. 
This parameter is needed on some powerpc platforms which do not encode
whether a mapping is for user or kernel in the pte.  On such platforms,
this can be inferred from the addr parameter.

[ajd@linux.ibm.com: rebase on arm64 + riscv changes, update commit message]
Link: https://lkml.kernel.org/r/20250813062614.51759-6-ajd@linux.ibm.com
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Nicholas Miehlbradt <nicholas@linux.ibm.com>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    2 +-
 arch/riscv/include/asm/pgtable.h |    2 +-
 include/linux/page_table_check.h |   12 +++++++-----
 include/linux/pgtable.h          |    2 +-
 mm/page_table_check.c            |    4 ++--
 5 files changed, 12 insertions(+), 10 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-page_table_check-provide-addr-parameter-to-page_table_check_ptes_set
+++ a/arch/arm64/include/asm/pgtable.h
@@ -706,7 +706,7 @@ static inline void __set_ptes_anysz(stru
 
 	switch (pgsize) {
 	case PAGE_SIZE:
-		page_table_check_ptes_set(mm, ptep, pte, nr);
+		page_table_check_ptes_set(mm, addr, ptep, pte, nr);
 		break;
 	case PMD_SIZE:
 		page_table_check_pmds_set(mm, addr, (pmd_t *)ptep,
--- a/arch/riscv/include/asm/pgtable.h~mm-page_table_check-provide-addr-parameter-to-page_table_check_ptes_set
+++ a/arch/riscv/include/asm/pgtable.h
@@ -560,7 +560,7 @@ static inline void __set_pte_at(struct m
 static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 		pte_t *ptep, pte_t pteval, unsigned int nr)
 {
-	page_table_check_ptes_set(mm, ptep, pteval, nr);
+	page_table_check_ptes_set(mm, addr, ptep, pteval, nr);
 
 	for (;;) {
 		__set_pte_at(mm, ptep, pteval);
--- a/include/linux/page_table_check.h~mm-page_table_check-provide-addr-parameter-to-page_table_check_ptes_set
+++ a/include/linux/page_table_check.h
@@ -17,8 +17,8 @@ void __page_table_check_zero(struct page
 void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte);
 void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd);
 void __page_table_check_pud_clear(struct mm_struct *mm, pud_t pud);
-void __page_table_check_ptes_set(struct mm_struct *mm, pte_t *ptep, pte_t pte,
-		unsigned int nr);
+void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
+		pte_t *ptep, pte_t pte, unsigned int nr);
 void __page_table_check_pmds_set(struct mm_struct *mm, unsigned long addr,
 		pmd_t *pmdp, pmd_t pmd, unsigned int nr);
 void __page_table_check_puds_set(struct mm_struct *mm, unsigned long addr,
@@ -68,12 +68,13 @@ static inline void page_table_check_pud_
 }
 
 static inline void page_table_check_ptes_set(struct mm_struct *mm,
-		pte_t *ptep, pte_t pte, unsigned int nr)
+					     unsigned long addr, pte_t *ptep,
+					     pte_t pte, unsigned int nr)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_ptes_set(mm, ptep, pte, nr);
+	__page_table_check_ptes_set(mm, addr, ptep, pte, nr);
 }
 
 static inline void page_table_check_pmds_set(struct mm_struct *mm,
@@ -127,7 +128,8 @@ static inline void page_table_check_pud_
 }
 
 static inline void page_table_check_ptes_set(struct mm_struct *mm,
-		pte_t *ptep, pte_t pte, unsigned int nr)
+					     unsigned long addr, pte_t *ptep,
+					     pte_t pte, unsigned int nr)
 {
 }
 
--- a/include/linux/pgtable.h~mm-page_table_check-provide-addr-parameter-to-page_table_check_ptes_set
+++ a/include/linux/pgtable.h
@@ -289,7 +289,7 @@ static inline pte_t pte_advance_pfn(pte_
 static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 		pte_t *ptep, pte_t pte, unsigned int nr)
 {
-	page_table_check_ptes_set(mm, ptep, pte, nr);
+	page_table_check_ptes_set(mm, addr, ptep, pte, nr);
 
 	for (;;) {
 		set_pte(ptep, pte);
--- a/mm/page_table_check.c~mm-page_table_check-provide-addr-parameter-to-page_table_check_ptes_set
+++ a/mm/page_table_check.c
@@ -193,8 +193,8 @@ static inline void page_table_check_pte_
 		WARN_ON_ONCE(swap_cached_writable(pte_to_swp_entry(pte)));
 }
 
-void __page_table_check_ptes_set(struct mm_struct *mm, pte_t *ptep, pte_t pte,
-		unsigned int nr)
+void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
+				 pte_t *ptep, pte_t pte, unsigned int nr)
 {
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

