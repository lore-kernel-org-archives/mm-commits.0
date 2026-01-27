Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B741E5702
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486742; cv=none; b=H51M89neCYUGpCXnwizCxSwL0BLJJs9ARR4JkrtZckQIgzd/8v23EL0dId/uk/781vqrfQGBdvWi2ZS7FPkIZEcT7bynApXx3xSP8QYbyDfvtbljXpSs4XdX3MSCRwNSSqcD3+u3a9qzzWxu0gWHyP99fW3OKthQXsxdXUOeDEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486742; c=relaxed/simple;
	bh=Lagq4CAa8KrcHST37vpKP5DtzgbeMzmotQrYmZUCA8g=;
	h=Date:To:From:Subject:Message-Id; b=p9FbOBFuN5BrpGlR/P9U7DNG0TPfwMgFxTEn+gKrzGVQHU9sC7K0qDZocmXiZzf86lIJIBDO0SzZnAVMNHQyCvw3N5ej2u7deSpjSOvnqkSDn6w9UdpXavmmRuWAk5dA+sZxUSzGaMrcv4A7xHA94rAsqk7m64uqnjHRFdcHhgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ujirg68Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ujirg68Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC420C116C6;
	Tue, 27 Jan 2026 04:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486742;
	bh=Lagq4CAa8KrcHST37vpKP5DtzgbeMzmotQrYmZUCA8g=;
	h=Date:To:From:Subject:From;
	b=ujirg68QU8zidbs5bQf727BU4K1gfJH3WKtQe4B+U5mHN8kNB2ryeUfndH+baHAVR
	 z5IPar0Z4Uqjtd/QiESZ/EUUa+QXVfa7MHSqLICEMbS3grOz/uCw4Y97jyUk6AsdoU
	 ohD8m78QzOiacB6vF8xLp82ffvyo78IiaRc5pW9M=
Date: Mon, 26 Jan 2026 20:05:41 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,willy@infradead.org,vishal.moola@gmail.com,thuth@redhat.com,sweettea-kernel@dorminy.me,ritesh.list@gmail.com,paulus@ozlabs.org,pasha.tatashin@soleen.com,npiggin@gmail.com,nicholas@linux.ibm.com,mpe@ellerman.id.au,mingo@kernel.org,maddy@linux.ibm.com,linmag7@gmail.com,kevin.brodsky@arm.com,jgg@ziepe.ca,guoweikang.kernel@gmail.com,donettom@linux.ibm.com,david@kernel.org,christophe.leroy@csgroup.eu,chleroy@kernel.org,apopple@nvidia.com,alexghiti@rivosinc.com,alex@ghiti.fr,ajd@linux.ibm.com,agordeev@linux.ibm.com,rmclure@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_clear.patch removed from -mm tree
Message-Id: <20260127040541.EC420C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_table_check: reinstate address parameter in [__]page_table_check_pud_clear()
has been removed from the -mm tree.  Its filename was
     mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_clear.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rohan McLure <rmclure@linux.ibm.com>
Subject: mm/page_table_check: reinstate address parameter in [__]page_table_check_pud_clear()
Date: Fri, 19 Dec 2025 04:09:38 +1100

This reverts commit 931c38e16499 ("mm/page_table_check: remove unused
parameter in [__]page_table_check_pud_clear").

Reinstate previously unused parameters for the purpose of supporting
powerpc platforms, as many do not encode user/kernel ownership of the page
in the pte, but instead in the address of the access.

[ajd@linux.ibm.com: rebase on arm64 changes]
Link: https://lkml.kernel.org/r/20251219-pgtable_check_v18rebase-v18-6-755bc151a50b@linux.ibm.com
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Ingo Molnar <mingo@kernel.org>  # x86
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
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

 arch/arm64/include/asm/pgtable.h |    2 +-
 arch/riscv/include/asm/pgtable.h |    2 +-
 arch/x86/include/asm/pgtable.h   |    2 +-
 include/linux/page_table_check.h |   11 +++++++----
 include/linux/pgtable.h          |    2 +-
 mm/page_table_check.c            |    5 +++--
 6 files changed, 14 insertions(+), 10 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_clear
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1349,7 +1349,7 @@ static inline pte_t __ptep_get_and_clear
 		break;
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SIZE:
-		page_table_check_pud_clear(mm, pte_pud(pte));
+		page_table_check_pud_clear(mm, address, pte_pud(pte));
 		break;
 #endif
 	default:
--- a/arch/riscv/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_clear
+++ a/arch/riscv/include/asm/pgtable.h
@@ -1101,7 +1101,7 @@ static inline pud_t pudp_huge_get_and_cl
 	pud_clear(pudp);
 #endif
 
-	page_table_check_pud_clear(mm, pud);
+	page_table_check_pud_clear(mm, address, pud);
 
 	return pud;
 }
--- a/arch/x86/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_clear
+++ a/arch/x86/include/asm/pgtable.h
@@ -1330,7 +1330,7 @@ static inline pud_t pudp_huge_get_and_cl
 {
 	pud_t pud = native_pudp_get_and_clear(pudp);
 
-	page_table_check_pud_clear(mm, pud);
+	page_table_check_pud_clear(mm, addr, pud);
 
 	return pud;
 }
--- a/include/linux/page_table_check.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_clear
+++ a/include/linux/page_table_check.h
@@ -16,7 +16,8 @@ extern struct page_ext_operations page_t
 void __page_table_check_zero(struct page *page, unsigned int order);
 void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte);
 void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd);
-void __page_table_check_pud_clear(struct mm_struct *mm, pud_t pud);
+void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
+				  pud_t pud);
 void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
 		pte_t *ptep, pte_t pte, unsigned int nr);
 void __page_table_check_pmds_set(struct mm_struct *mm, unsigned long addr,
@@ -59,12 +60,13 @@ static inline void page_table_check_pmd_
 	__page_table_check_pmd_clear(mm, pmd);
 }
 
-static inline void page_table_check_pud_clear(struct mm_struct *mm, pud_t pud)
+static inline void page_table_check_pud_clear(struct mm_struct *mm,
+					      unsigned long addr, pud_t pud)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_pud_clear(mm, pud);
+	__page_table_check_pud_clear(mm, addr, pud);
 }
 
 static inline void page_table_check_ptes_set(struct mm_struct *mm,
@@ -123,7 +125,8 @@ static inline void page_table_check_pmd_
 {
 }
 
-static inline void page_table_check_pud_clear(struct mm_struct *mm, pud_t pud)
+static inline void page_table_check_pud_clear(struct mm_struct *mm,
+					      unsigned long addr, pud_t pud)
 {
 }
 
--- a/include/linux/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_clear
+++ a/include/linux/pgtable.h
@@ -801,7 +801,7 @@ static inline pud_t pudp_huge_get_and_cl
 	pud_t pud = *pudp;
 
 	pud_clear(pudp);
-	page_table_check_pud_clear(mm, pud);
+	page_table_check_pud_clear(mm, address, pud);
 
 	return pud;
 }
--- a/mm/page_table_check.c~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_clear
+++ a/mm/page_table_check.c
@@ -167,7 +167,8 @@ void __page_table_check_pmd_clear(struct
 }
 EXPORT_SYMBOL(__page_table_check_pmd_clear);
 
-void __page_table_check_pud_clear(struct mm_struct *mm, pud_t pud)
+void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
+				  pud_t pud)
 {
 	if (&init_mm == mm)
 		return;
@@ -253,7 +254,7 @@ void __page_table_check_puds_set(struct
 		return;
 
 	for (i = 0; i < nr; i++)
-		__page_table_check_pud_clear(mm, *(pudp + i));
+		__page_table_check_pud_clear(mm, addr + PUD_SIZE * i, *(pudp + i));
 	if (pud_user_accessible_page(pud))
 		page_table_check_set(pud_pfn(pud), stride * nr, pud_write(pud));
 }
_

Patches currently in -mm which might be from rmclure@linux.ibm.com are


