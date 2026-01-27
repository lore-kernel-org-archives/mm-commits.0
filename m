Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F4E1E5702
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486747; cv=none; b=NxtjYeWTfF78LTuekaOoUzmsHeof+B1SqLsLxXrG2VXKO58vZHUB5wSTPiiROoF0Ax09AUpgmjSiOT5n1V8kGrMI2/cEz1RKf1+euAAst4kLrq6OnPAfuiGQb04dHu8a9QtSucW2ErYuxTSdVTOAb0SxRGTdWm50vPBkL6eJ/zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486747; c=relaxed/simple;
	bh=7saksCcTd5tvRU0bY8aszwZfBZYlnQ0INBbPvG1Ev+A=;
	h=Date:To:From:Subject:Message-Id; b=fXhK7lcyEhDr7K2Pc7i1al4E9fVdo+gcVxiFMQj0/eXDR0DIHSv2dZPRAH9NNM5r1DJcGzm8GFq50w5/TeGoZ8pHmuWvt3SbTlqAXlsL85Kh5bVO+V/LKD8tZU0GhH/zK//4flbCC92efn2L7J3i8z/4eCejOeVWVB2cLFJtxB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uOs+YBg8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uOs+YBg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2D2C116C6;
	Tue, 27 Jan 2026 04:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486747;
	bh=7saksCcTd5tvRU0bY8aszwZfBZYlnQ0INBbPvG1Ev+A=;
	h=Date:To:From:Subject:From;
	b=uOs+YBg8dDyNccZYeV3lW5EX+5g1K4IlXUbU+DSFBknFXiQAnkT+iodJdeby2VAgo
	 QiKg9gFcGyow/qc+PwiaepTLt6Q0X0ZqAW2ZsCySb04oMhY57FooyC7mmjaMKdnn/t
	 Qz3np2LtWrejbI8RpBtJtaculvPZ3r1zdzGRTAb8=
Date: Mon, 26 Jan 2026 20:05:46 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,willy@infradead.org,vishal.moola@gmail.com,thuth@redhat.com,sweettea-kernel@dorminy.me,ritesh.list@gmail.com,paulus@ozlabs.org,pasha.tatashin@soleen.com,npiggin@gmail.com,nicholas@linux.ibm.com,mpe@ellerman.id.au,mingo@kernel.org,maddy@linux.ibm.com,linmag7@gmail.com,kevin.brodsky@arm.com,jgg@ziepe.ca,guoweikang.kernel@gmail.com,donettom@linux.ibm.com,david@kernel.org,christophe.leroy@csgroup.eu,chleroy@kernel.org,apopple@nvidia.com,alexghiti@rivosinc.com,alex@ghiti.fr,ajd@linux.ibm.com,agordeev@linux.ibm.com,rmclure@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-provide-address-parameter-to-ptemdud_user_accessible_page.patch removed from -mm tree
Message-Id: <20260127040547.4D2D2C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: provide address parameter to p{te,md,ud}_user_accessible_page()
has been removed from the -mm tree.  Its filename was
     mm-provide-address-parameter-to-ptemdud_user_accessible_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rohan McLure <rmclure@linux.ibm.com>
Subject: mm: provide address parameter to p{te,md,ud}_user_accessible_page()
Date: Fri, 19 Dec 2025 04:09:41 +1100

On several powerpc platforms, a page table entry may not imply whether the
relevant mapping is for userspace or kernelspace.  Instead, such platforms
infer this by the address which is being accessed.

Add an additional address argument to each of these routines in order to
provide support for page table check on powerpc.

[ajd@linux.ibm.com: rebase on arm64 changes]
Link: https://lkml.kernel.org/r/20251219-pgtable_check_v18rebase-v18-9-755bc151a50b@linux.ibm.com
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Ingo Molnar <mingo@kernel.org>  # x86
Acked-by: Alexandre Ghiti <alexghiti@rivosinc.com> # riscv
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Guo Weikang <guoweikang.kernel@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Miehlbradt <nicholas@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Thomas Huth <thuth@redhat.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    6 +++---
 arch/riscv/include/asm/pgtable.h |    6 +++---
 arch/x86/include/asm/pgtable.h   |    6 +++---
 mm/page_table_check.c            |   12 ++++++------
 4 files changed, 15 insertions(+), 15 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-provide-address-parameter-to-ptemdud_user_accessible_page
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1265,17 +1265,17 @@ static inline int pmdp_set_access_flags(
 #endif
 
 #ifdef CONFIG_PAGE_TABLE_CHECK
-static inline bool pte_user_accessible_page(pte_t pte)
+static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
 {
 	return pte_valid(pte) && (pte_user(pte) || pte_user_exec(pte));
 }
 
-static inline bool pmd_user_accessible_page(pmd_t pmd)
+static inline bool pmd_user_accessible_page(pmd_t pmd, unsigned long addr)
 {
 	return pmd_valid(pmd) && !pmd_table(pmd) && (pmd_user(pmd) || pmd_user_exec(pmd));
 }
 
-static inline bool pud_user_accessible_page(pud_t pud)
+static inline bool pud_user_accessible_page(pud_t pud, unsigned long addr)
 {
 	return pud_valid(pud) && !pud_table(pud) && (pud_user(pud) || pud_user_exec(pud));
 }
--- a/arch/riscv/include/asm/pgtable.h~mm-provide-address-parameter-to-ptemdud_user_accessible_page
+++ a/arch/riscv/include/asm/pgtable.h
@@ -958,17 +958,17 @@ static inline void set_pud_at(struct mm_
 }
 
 #ifdef CONFIG_PAGE_TABLE_CHECK
-static inline bool pte_user_accessible_page(pte_t pte)
+static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
 {
 	return pte_present(pte) && pte_user(pte);
 }
 
-static inline bool pmd_user_accessible_page(pmd_t pmd)
+static inline bool pmd_user_accessible_page(pmd_t pmd, unsigned long addr)
 {
 	return pmd_leaf(pmd) && pmd_user(pmd);
 }
 
-static inline bool pud_user_accessible_page(pud_t pud)
+static inline bool pud_user_accessible_page(pud_t pud, unsigned long addr)
 {
 	return pud_leaf(pud) && pud_user(pud);
 }
--- a/arch/x86/include/asm/pgtable.h~mm-provide-address-parameter-to-ptemdud_user_accessible_page
+++ a/arch/x86/include/asm/pgtable.h
@@ -1680,17 +1680,17 @@ static inline bool arch_has_hw_nonleaf_p
 #endif
 
 #ifdef CONFIG_PAGE_TABLE_CHECK
-static inline bool pte_user_accessible_page(pte_t pte)
+static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
 {
 	return (pte_val(pte) & _PAGE_PRESENT) && (pte_val(pte) & _PAGE_USER);
 }
 
-static inline bool pmd_user_accessible_page(pmd_t pmd)
+static inline bool pmd_user_accessible_page(pmd_t pmd, unsigned long addr)
 {
 	return pmd_leaf(pmd) && (pmd_val(pmd) & _PAGE_PRESENT) && (pmd_val(pmd) & _PAGE_USER);
 }
 
-static inline bool pud_user_accessible_page(pud_t pud)
+static inline bool pud_user_accessible_page(pud_t pud, unsigned long addr)
 {
 	return pud_leaf(pud) && (pud_val(pud) & _PAGE_PRESENT) && (pud_val(pud) & _PAGE_USER);
 }
--- a/mm/page_table_check.c~mm-provide-address-parameter-to-ptemdud_user_accessible_page
+++ a/mm/page_table_check.c
@@ -151,7 +151,7 @@ void __page_table_check_pte_clear(struct
 	if (&init_mm == mm)
 		return;
 
-	if (pte_user_accessible_page(pte)) {
+	if (pte_user_accessible_page(pte, addr)) {
 		page_table_check_clear(pte_pfn(pte), PAGE_SIZE >> PAGE_SHIFT);
 	}
 }
@@ -163,7 +163,7 @@ void __page_table_check_pmd_clear(struct
 	if (&init_mm == mm)
 		return;
 
-	if (pmd_user_accessible_page(pmd)) {
+	if (pmd_user_accessible_page(pmd, addr)) {
 		page_table_check_clear(pmd_pfn(pmd), PMD_SIZE >> PAGE_SHIFT);
 	}
 }
@@ -175,7 +175,7 @@ void __page_table_check_pud_clear(struct
 	if (&init_mm == mm)
 		return;
 
-	if (pud_user_accessible_page(pud)) {
+	if (pud_user_accessible_page(pud, addr)) {
 		page_table_check_clear(pud_pfn(pud), PUD_SIZE >> PAGE_SHIFT);
 	}
 }
@@ -211,7 +211,7 @@ void __page_table_check_ptes_set(struct
 
 	for (i = 0; i < nr; i++)
 		__page_table_check_pte_clear(mm, addr + PAGE_SIZE * i, ptep_get(ptep + i));
-	if (pte_user_accessible_page(pte))
+	if (pte_user_accessible_page(pte, addr))
 		page_table_check_set(pte_pfn(pte), nr, pte_write(pte));
 }
 EXPORT_SYMBOL(__page_table_check_ptes_set);
@@ -241,7 +241,7 @@ void __page_table_check_pmds_set(struct
 
 	for (i = 0; i < nr; i++)
 		__page_table_check_pmd_clear(mm, addr + PMD_SIZE * i, *(pmdp + i));
-	if (pmd_user_accessible_page(pmd))
+	if (pmd_user_accessible_page(pmd, addr))
 		page_table_check_set(pmd_pfn(pmd), stride * nr, pmd_write(pmd));
 }
 EXPORT_SYMBOL(__page_table_check_pmds_set);
@@ -257,7 +257,7 @@ void __page_table_check_puds_set(struct
 
 	for (i = 0; i < nr; i++)
 		__page_table_check_pud_clear(mm, addr + PUD_SIZE * i, *(pudp + i));
-	if (pud_user_accessible_page(pud))
+	if (pud_user_accessible_page(pud, addr))
 		page_table_check_set(pud_pfn(pud), stride * nr, pud_write(pud));
 }
 EXPORT_SYMBOL(__page_table_check_puds_set);
_

Patches currently in -mm which might be from rmclure@linux.ibm.com are


