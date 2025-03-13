Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EF31F8923
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 22:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741906104; cv=none; b=u895FdxSo3P0Oq199bPZ5/tIOQEINtkCnr4uQGy4CZHBhDgWSzpadfWZ6ZNpmDKvF9/OUZdR41JkADFzDCh8yjX+3kdJXXQ2I0yb4O2G5vq2vmm3z2LzzizQd7x3mLWJncy3fl72i1VZTCEP7WGEzvwd0V6Xd7eNSbFkKNTN/VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741906104; c=relaxed/simple;
	bh=7xC+5Vdwq/zNbNMQwut6KpkSUcPtmtqa1lOII3qZU1w=;
	h=Date:To:From:Subject:Message-Id; b=cQy5NI6yfLBTPsa/QutZacFu92DmgItyU4Yuf2a+yg4zErkMqqZ3QoAp3+YLIMyDaMDjoA1aWkOyoMRH94ELUKF6v4TVfwVJjmsloIBRnKh3ENl+GporSWcn+IJRavLezTE1zQk/mVjvLVBNF+zXZvMaWZmNqjOzGTr1/6BSZVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i0e7G52T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i0e7G52T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D376C4CEDD;
	Thu, 13 Mar 2025 22:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741906104;
	bh=7xC+5Vdwq/zNbNMQwut6KpkSUcPtmtqa1lOII3qZU1w=;
	h=Date:To:From:Subject:From;
	b=i0e7G52TKxB2t2Se1QZmVYFI6E9elOWZUm5Gwb9/BrCMfmzxGEs23a3jQgKhF22dX
	 LeRYHcOfuDw7U9ZT0HVBCIcfBn9I52AgiU6lmpMUoaKM5wZ+6lyyrNo81XWo2D28Bq
	 Rx9p+3Gqb49WAUbUewp3BXhuxTGU24c8dK/djnTE=
Date: Thu, 13 Mar 2025 15:48:23 -0700
To: mm-commits@vger.kernel.org,x86@kernel.org,sweettea-kernel@dorminy.me,pasha.tatashin@soleen.com,christophe.leroy@csgroup.eu,ajd@linux.ibm.com,rmclure@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear.patch added to mm-unstable branch
Message-Id: <20250313224824.2D376C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_table_check: reinstate address parameter in [__]page_table_check_pmd_clear()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear.patch

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
From: Rohan McLure <rmclure@linux.ibm.com>
Subject: mm/page_table_check: reinstate address parameter in [__]page_table_check_pmd_clear()
Date: Wed, 12 Feb 2025 03:13:58 +1100

This reverts commit 1831414cd729 ("mm/page_table_check: remove unused
parameter in [__]page_table_check_pmd_clear").

Reinstate previously unused parameters for the purpose of supporting
powerpc platforms, as many do not encode user/kernel ownership of the page
in the pte, but instead in the address of the access.

Link: https://lkml.kernel.org/r/20250211161404.850215-6-ajd@linux.ibm.com
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: <x86@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    2 +-
 arch/riscv/include/asm/pgtable.h |    2 +-
 arch/x86/include/asm/pgtable.h   |    2 +-
 include/linux/page_table_check.h |   11 +++++++----
 include/linux/pgtable.h          |    2 +-
 mm/page_table_check.c            |    5 +++--
 6 files changed, 14 insertions(+), 10 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1324,7 +1324,7 @@ static inline pmd_t pmdp_huge_get_and_cl
 {
 	pmd_t pmd = __pmd(xchg_relaxed(&pmd_val(*pmdp), 0));
 
-	page_table_check_pmd_clear(mm, pmd);
+	page_table_check_pmd_clear(mm, address, pmd);
 
 	return pmd;
 }
--- a/arch/riscv/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear
+++ a/arch/riscv/include/asm/pgtable.h
@@ -826,7 +826,7 @@ static inline pmd_t pmdp_huge_get_and_cl
 {
 	pmd_t pmd = __pmd(atomic_long_xchg((atomic_long_t *)pmdp, 0));
 
-	page_table_check_pmd_clear(mm, pmd);
+	page_table_check_pmd_clear(mm, address, pmd);
 
 	return pmd;
 }
--- a/arch/x86/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear
+++ a/arch/x86/include/asm/pgtable.h
@@ -1387,7 +1387,7 @@ static inline pmd_t pmdp_huge_get_and_cl
 {
 	pmd_t pmd = native_pmdp_get_and_clear(pmdp);
 
-	page_table_check_pmd_clear(mm, pmd);
+	page_table_check_pmd_clear(mm, addr, pmd);
 
 	return pmd;
 }
--- a/include/linux/page_table_check.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear
+++ a/include/linux/page_table_check.h
@@ -15,7 +15,8 @@ extern struct page_ext_operations page_t
 
 void __page_table_check_zero(struct page *page, unsigned int order);
 void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte);
-void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd);
+void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
+				  pmd_t pmd);
 void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
 				  pud_t pud);
 void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
@@ -52,12 +53,13 @@ static inline void page_table_check_pte_
 	__page_table_check_pte_clear(mm, pte);
 }
 
-static inline void page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd)
+static inline void page_table_check_pmd_clear(struct mm_struct *mm,
+					      unsigned long addr, pmd_t pmd)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_pmd_clear(mm, pmd);
+	__page_table_check_pmd_clear(mm, addr, pmd);
 }
 
 static inline void page_table_check_pud_clear(struct mm_struct *mm,
@@ -123,7 +125,8 @@ static inline void page_table_check_pte_
 {
 }
 
-static inline void page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd)
+static inline void page_table_check_pmd_clear(struct mm_struct *mm,
+					      unsigned long addr, pmd_t pmd)
 {
 }
 
--- a/include/linux/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear
+++ a/include/linux/pgtable.h
@@ -637,7 +637,7 @@ static inline pmd_t pmdp_huge_get_and_cl
 	pmd_t pmd = *pmdp;
 
 	pmd_clear(pmdp);
-	page_table_check_pmd_clear(mm, pmd);
+	page_table_check_pmd_clear(mm, address, pmd);
 
 	return pmd;
 }
--- a/mm/page_table_check.c~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear
+++ a/mm/page_table_check.c
@@ -156,7 +156,8 @@ void __page_table_check_pte_clear(struct
 }
 EXPORT_SYMBOL(__page_table_check_pte_clear);
 
-void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd)
+void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
+				  pmd_t pmd)
 {
 	if (&init_mm == mm)
 		return;
@@ -227,7 +228,7 @@ void __page_table_check_pmd_set(struct m
 
 	page_table_check_pmd_flags(pmd);
 
-	__page_table_check_pmd_clear(mm, *pmdp);
+	__page_table_check_pmd_clear(mm, addr, *pmdp);
 	if (pmd_user_accessible_page(pmd)) {
 		page_table_check_set(pmd_pfn(pmd), PMD_SIZE >> PAGE_SHIFT,
 				     pmd_write(pmd));
_

Patches currently in -mm which might be from rmclure@linux.ibm.com are

mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_set.patch
mm-page_table_check-provide-addr-parameter-to-page_table_check_pte_set.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_clear.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pte_clear.patch
mm-provide-address-parameter-to-ptemdud_user_accessible_page.patch
powerpc-mm-add-pud_pfn-stub.patch
powerpc-mm-implement-_user_accessible_page-for-ptes.patch
powerpc-mm-use-set_pte_at_unchecked-for-internal-usages.patch
powerpc-mm-support-page-table-check.patch

