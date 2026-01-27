Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEC31E5702
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486740; cv=none; b=nRrnOXhDz81bg6HCc8Il2nluafKK2r1zhy5LpWFAYiK+Y4ZH4zF98qg4FZr4E7WLJfRghQhYVVdlrefvsr0mRx26bwibPWS+FaIr4ptT/ZadLKK+3kxkSuLVRRwp4CrkmhIxvXo1iOh5No25zVYifNFtZ44JlYb1jRJdrYHNNFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486740; c=relaxed/simple;
	bh=1Br0GiND5KWINqCQ8mHIzvFeXnQq/xGl4aO7v9c5rFE=;
	h=Date:To:From:Subject:Message-Id; b=Eps+/NGTOGYAIM+SWX5xuzSdm7LKSifJNozqymjvvXV+hnGcgw1N/iS7QSZe1BGo7TqQGh98cFEDT6Z3didKc/QITaY2aGPBx9U1VM7P/2StakvvgziYTLpDNfjMCgldyXduH0yMJ+PEQmPZoswKts588foO8cXjabnKFv7VDxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G6Ztddg9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G6Ztddg9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DA2C116C6;
	Tue, 27 Jan 2026 04:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486740;
	bh=1Br0GiND5KWINqCQ8mHIzvFeXnQq/xGl4aO7v9c5rFE=;
	h=Date:To:From:Subject:From;
	b=G6Ztddg9UG5tYMsrNjwiCwbbLOfBJU6sgPfgII5pIwTrB1e7OumbuMx7n8q5Ay9VF
	 9io1IzQkgotAlJNtWaMneVX5NKyrcyu2wOzhn02CwO1CgW/KmmUFrQyg8pVikUogSx
	 j1RmY9k+mqSA9erolfc47kw5y8Gwf3c4YmC8bOrM=
Date: Mon, 26 Jan 2026 20:05:39 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,willy@infradead.org,vishal.moola@gmail.com,thuth@redhat.com,sweettea-kernel@dorminy.me,ritesh.list@gmail.com,paulus@ozlabs.org,pasha.tatashin@soleen.com,npiggin@gmail.com,nicholas@linux.ibm.com,mpe@ellerman.id.au,mingo@kernel.org,maddy@linux.ibm.com,linmag7@gmail.com,kevin.brodsky@arm.com,jgg@ziepe.ca,guoweikang.kernel@gmail.com,donettom@linux.ibm.com,david@kernel.org,christophe.leroy@csgroup.eu,chleroy@kernel.org,apopple@nvidia.com,alexghiti@rivosinc.com,alex@ghiti.fr,ajd@linux.ibm.com,agordeev@linux.ibm.com,rmclure@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_table_check-provide-addr-parameter-to-page_table_check_ptes_set.patch removed from -mm tree
Message-Id: <20260127040540.31DA2C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_table_check: provide addr parameter to page_table_check_ptes_set()
has been removed from the -mm tree.  Its filename was
     mm-page_table_check-provide-addr-parameter-to-page_table_check_ptes_set.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rohan McLure <rmclure@linux.ibm.com>
Subject: mm/page_table_check: provide addr parameter to page_table_check_ptes_set()
Date: Fri, 19 Dec 2025 04:09:37 +1100

To provide support for powerpc platforms, provide an addr parameter to the
__page_table_check_ptes_set() and page_table_check_ptes_set() routines. 
This parameter is needed on some powerpc platforms which do not encode
whether a mapping is for user or kernel in the pte.  On such platforms,
this can be inferred from the addr parameter.

[ajd@linux.ibm.com: rebase on arm64 + riscv changes, update commit message]
Link: https://lkml.kernel.org/r/20251219-pgtable_check_v18rebase-v18-5-755bc151a50b@linux.ibm.com
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Alexandre Ghiti <alexghiti@rivosinc.com> # riscv
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Guo Weikang <guoweikang.kernel@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
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

 arch/arm64/include/asm/pgtable.h |    2 +-
 arch/riscv/include/asm/pgtable.h |    2 +-
 include/linux/page_table_check.h |   12 +++++++-----
 include/linux/pgtable.h          |    2 +-
 mm/page_table_check.c            |    4 ++--
 5 files changed, 12 insertions(+), 10 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-page_table_check-provide-addr-parameter-to-page_table_check_ptes_set
+++ a/arch/arm64/include/asm/pgtable.h
@@ -681,7 +681,7 @@ static inline void __set_ptes_anysz(stru
 
 	switch (pgsize) {
 	case PAGE_SIZE:
-		page_table_check_ptes_set(mm, ptep, pte, nr);
+		page_table_check_ptes_set(mm, addr, ptep, pte, nr);
 		break;
 	case PMD_SIZE:
 		page_table_check_pmds_set(mm, addr, (pmd_t *)ptep,
--- a/arch/riscv/include/asm/pgtable.h~mm-page_table_check-provide-addr-parameter-to-page_table_check_ptes_set
+++ a/arch/riscv/include/asm/pgtable.h
@@ -627,7 +627,7 @@ static inline void __set_pte_at(struct m
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
@@ -429,7 +429,7 @@ static inline pte_t pte_advance_pfn(pte_
 static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 		pte_t *ptep, pte_t pte, unsigned int nr)
 {
-	page_table_check_ptes_set(mm, ptep, pte, nr);
+	page_table_check_ptes_set(mm, addr, ptep, pte, nr);
 
 	for (;;) {
 		set_pte(ptep, pte);
--- a/mm/page_table_check.c~mm-page_table_check-provide-addr-parameter-to-page_table_check_ptes_set
+++ a/mm/page_table_check.c
@@ -196,8 +196,8 @@ static void page_table_check_pte_flags(p
 	}
 }
 
-void __page_table_check_ptes_set(struct mm_struct *mm, pte_t *ptep, pte_t pte,
-		unsigned int nr)
+void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
+				 pte_t *ptep, pte_t pte, unsigned int nr)
 {
 	unsigned int i;
 
_

Patches currently in -mm which might be from rmclure@linux.ibm.com are


