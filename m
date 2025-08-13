Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543F02F0C73
	for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2025 23:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755126375; cv=none; b=WfR7goWorM0XzNPjUTYWWJqEyJKwPUxZq4HVg/jsBrTzwFSX5K8JMq6iYiC1icbMH524ZcSsi+Cn1E/u9wQGGwF5SIKURN6sWx6opxSpsF/mbD/WaTianv+bOr6wKsdpT5X7e3wkaHfV4I3+nZLCadcVf3jQxVSGk6PCuI4CeCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755126375; c=relaxed/simple;
	bh=t52QopdWxRINow5BqJD4nT8h3WPjt7rsb0zB9YkNR9U=;
	h=Date:To:From:Subject:Message-Id; b=HJqQt2A41UioQo6MPazI/VYggBfNknV7PhbafmDpFG8KU4jUwndTMveS33RsArJmp2OQkeen5Ro1mJJEw0X/2R08JCc3J3FwZwPbJovi1qbr0xcj/zLtapS8rgNRK4kqVQCT9zUz7xyFLSlrQtWAqCxR2uDMvWLJXiTsNCSqHjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DCunn6hn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DCunn6hn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEFB3C4CEEB;
	Wed, 13 Aug 2025 23:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755126374;
	bh=t52QopdWxRINow5BqJD4nT8h3WPjt7rsb0zB9YkNR9U=;
	h=Date:To:From:Subject:From;
	b=DCunn6hngMWbXGe8wksnNlt+9J7tjGWGLGSUmcU5L+I0qFS+6D+j/iec92P0M1Blf
	 JnrXeKgPeCuf3/bxQincjl7F7AhaAJ1qt5b/RWhL8cNqJNe5tkT/4q41I2eBvS1sq8
	 nilgYLmClxQPNsRiKVgF5o477K+HUtN/QtzRF5L4=
Date: Wed, 13 Aug 2025 16:06:14 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,sweettea-kernel@dorminy.me,pasha.tatashin@soleen.com,nicholas@linux.ibm.com,mingo@kernel.org,maddy@linux.ibm.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,ajd@linux.ibm.com,rmclure@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-reinstate-address-parameter-in-page_table_check_pte_clear.patch added to mm-new branch
Message-Id: <20250813230614.AEFB3C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_table_check: Reinstate address parameter in [__]page_table_check_pte_clear()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_table_check-reinstate-address-parameter-in-page_table_check_pte_clear.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_table_check-reinstate-address-parameter-in-page_table_check_pte_clear.patch

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
Subject: mm/page_table_check: Reinstate address parameter in [__]page_table_check_pte_clear()
Date: Wed, 13 Aug 2025 16:26:09 +1000

This reverts commit aa232204c468 ("mm/page_table_check: remove unused
parameter in [__]page_table_check_pte_clear").

Reinstate previously unused parameters for the purpose of supporting
powerpc platforms, as many do not encode user/kernel ownership of the page
in the pte, but instead in the address of the access.

[ajd@linux.ibm.com: rebase, fix additional occurrence and loop handling]
Link: https://lkml.kernel.org/r/20250813062614.51759-9-ajd@linux.ibm.com
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

 arch/arm64/include/asm/pgtable.h |    2 +-
 arch/riscv/include/asm/pgtable.h |    2 +-
 arch/x86/include/asm/pgtable.h   |    4 ++--
 include/linux/page_table_check.h |   11 +++++++----
 include/linux/pgtable.h          |    4 ++--
 mm/page_table_check.c            |    7 ++++---
 6 files changed, 17 insertions(+), 13 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pte_clear
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1367,7 +1367,7 @@ static inline pte_t __ptep_get_and_clear
 
 	switch (pgsize) {
 	case PAGE_SIZE:
-		page_table_check_pte_clear(mm, pte);
+		page_table_check_pte_clear(mm, address, pte);
 		break;
 	case PMD_SIZE:
 		page_table_check_pmd_clear(mm, address, pte_pmd(pte));
--- a/arch/riscv/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pte_clear
+++ a/arch/riscv/include/asm/pgtable.h
@@ -591,7 +591,7 @@ static inline pte_t ptep_get_and_clear(s
 {
 	pte_t pte = __pte(atomic_long_xchg((atomic_long_t *)ptep, 0));
 
-	page_table_check_pte_clear(mm, pte);
+	page_table_check_pte_clear(mm, address, pte);
 
 	return pte;
 }
--- a/arch/x86/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pte_clear
+++ a/arch/x86/include/asm/pgtable.h
@@ -1251,7 +1251,7 @@ static inline pte_t ptep_get_and_clear(s
 				       pte_t *ptep)
 {
 	pte_t pte = native_ptep_get_and_clear(ptep);
-	page_table_check_pte_clear(mm, pte);
+	page_table_check_pte_clear(mm, addr, pte);
 	return pte;
 }
 
@@ -1267,7 +1267,7 @@ static inline pte_t ptep_get_and_clear_f
 		 * care about updates and native needs no locking
 		 */
 		pte = native_local_ptep_get_and_clear(ptep);
-		page_table_check_pte_clear(mm, pte);
+		page_table_check_pte_clear(mm, addr, pte);
 	} else {
 		pte = ptep_get_and_clear(mm, addr, ptep);
 	}
--- a/include/linux/page_table_check.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pte_clear
+++ a/include/linux/page_table_check.h
@@ -14,7 +14,8 @@ extern struct static_key_true page_table
 extern struct page_ext_operations page_table_check_ops;
 
 void __page_table_check_zero(struct page *page, unsigned int order);
-void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte);
+void __page_table_check_pte_clear(struct mm_struct *mm, unsigned long addr,
+				  pte_t pte);
 void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
 				  pmd_t pmd);
 void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
@@ -45,12 +46,13 @@ static inline void page_table_check_free
 	__page_table_check_zero(page, order);
 }
 
-static inline void page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
+static inline void page_table_check_pte_clear(struct mm_struct *mm,
+					      unsigned long addr, pte_t pte)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_pte_clear(mm, pte);
+	__page_table_check_pte_clear(mm, addr, pte);
 }
 
 static inline void page_table_check_pmd_clear(struct mm_struct *mm,
@@ -119,7 +121,8 @@ static inline void page_table_check_free
 {
 }
 
-static inline void page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
+static inline void page_table_check_pte_clear(struct mm_struct *mm,
+					      unsigned long addr, pte_t pte)
 {
 }
 
--- a/include/linux/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pte_clear
+++ a/include/linux/pgtable.h
@@ -494,7 +494,7 @@ static inline pte_t ptep_get_and_clear(s
 {
 	pte_t pte = ptep_get(ptep);
 	pte_clear(mm, address, ptep);
-	page_table_check_pte_clear(mm, pte);
+	page_table_check_pte_clear(mm, address, pte);
 	return pte;
 }
 #endif
@@ -553,7 +553,7 @@ static inline void ptep_clear(struct mm_
 	 * No need for ptep_get_and_clear(): page table check doesn't care about
 	 * any bits that could have been set by HW concurrently.
 	 */
-	page_table_check_pte_clear(mm, pte);
+	page_table_check_pte_clear(mm, addr, pte);
 }
 
 #ifdef CONFIG_GUP_GET_PXX_LOW_HIGH
--- a/mm/page_table_check.c~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pte_clear
+++ a/mm/page_table_check.c
@@ -145,7 +145,8 @@ void __page_table_check_zero(struct page
 	rcu_read_unlock();
 }
 
-void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
+void __page_table_check_pte_clear(struct mm_struct *mm, unsigned long addr,
+				  pte_t pte)
 {
 	if (&init_mm == mm)
 		return;
@@ -206,7 +207,7 @@ void __page_table_check_ptes_set(struct
 	page_table_check_pte_flags(pte);
 
 	for (i = 0; i < nr; i++)
-		__page_table_check_pte_clear(mm, ptep_get(ptep + i));
+		__page_table_check_pte_clear(mm, addr + PAGE_SIZE * i, ptep_get(ptep + i));
 	if (pte_user_accessible_page(pte))
 		page_table_check_set(pte_pfn(pte), nr, pte_write(pte));
 }
@@ -268,7 +269,7 @@ void __page_table_check_pte_clear_range(
 		if (WARN_ON(!ptep))
 			return;
 		for (i = 0; i < PTRS_PER_PTE; i++) {
-			__page_table_check_pte_clear(mm, ptep_get(ptep));
+			__page_table_check_pte_clear(mm, addr, ptep_get(ptep));
 			addr += PAGE_SIZE;
 			ptep++;
 		}
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

