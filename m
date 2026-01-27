Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65291E5702
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486736; cv=none; b=L1+0Z/l96CNWQEH709+Zr5MJS/4aaJKQ85ynVfeSKj6rvbFRJiHbxUVZcuJ8CDNjhhuNZLT0UKyavr3M+v/IkMXFd1QZd9WyAHqAOyz4gJQa8/bk6K1XzKMpp7rLxwvZmrqbRL4xhScKuxUFlXsYP5x+9uK4j6rvN4cNgXjg0I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486736; c=relaxed/simple;
	bh=vDM7oZwWGHCE8Mh0wNPodRY5+/PrQqS1n07m9tnbTaI=;
	h=Date:To:From:Subject:Message-Id; b=JquQdoDILEv/Db8FOEiK66cI+fHqZw843MG45atk9YpWE1hAcIJZL4nIc++AWNe6MEtb2LkBu8GWoADl65oA+QUusSUuyimRMGMY8uMZIVt8UFijqvPy50hFtqK+VvTC8mJs57RU7PMFRUzlCm8R9lsldWx/k5bp2sHSl5TzEE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pBSGX+rf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pBSGX+rf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90118C116C6;
	Tue, 27 Jan 2026 04:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486736;
	bh=vDM7oZwWGHCE8Mh0wNPodRY5+/PrQqS1n07m9tnbTaI=;
	h=Date:To:From:Subject:From;
	b=pBSGX+rfWnXWN1FPOpVFYCu6hCdvthnQmHa5SzINvh3sb/8u6N4MB04Qezt8tXEJ/
	 pgwLnlNdNz/EQK0jkU9CW+UWvns1BWu6uSER7gQ/8S+YWhe5HWGORFN5pTYRfS93xZ
	 27tQqPvxzznl2nsG/4adBm5Egx5CKhO6BJHZogZE=
Date: Mon, 26 Jan 2026 20:05:36 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,willy@infradead.org,vishal.moola@gmail.com,thuth@redhat.com,sweettea-kernel@dorminy.me,ritesh.list@gmail.com,paulus@ozlabs.org,pasha.tatashin@soleen.com,npiggin@gmail.com,nicholas@linux.ibm.com,mpe@ellerman.id.au,mingo@kernel.org,maddy@linux.ibm.com,linmag7@gmail.com,kevin.brodsky@arm.com,jgg@ziepe.ca,guoweikang.kernel@gmail.com,donettom@linux.ibm.com,david@kernel.org,christophe.leroy@csgroup.eu,chleroy@kernel.org,apopple@nvidia.com,alexghiti@rivosinc.com,alex@ghiti.fr,ajd@linux.ibm.com,agordeev@linux.ibm.com,rmclure@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set.patch removed from -mm tree
Message-Id: <20260127040536.90118C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_table_check: reinstate address parameter in [__]page_table_check_pud[s]_set()
has been removed from the -mm tree.  Its filename was
     mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rohan McLure <rmclure@linux.ibm.com>
Subject: mm/page_table_check: reinstate address parameter in [__]page_table_check_pud[s]_set()
Date: Fri, 19 Dec 2025 04:09:35 +1100

This reverts commit 6d144436d954 ("mm/page_table_check: remove unused
parameter in [__]page_table_check_pud_set").

Reinstate previously unused parameters for the purpose of supporting
powerpc platforms, as many do not encode user/kernel ownership of the page
in the pte, but instead in the address of the access.

Apply this to __page_table_check_puds_set(), page_table_check_puds_set()
and the page_table_check_pud_set() wrapper macro.

[ajd@linux.ibm.com: rebase on riscv + arm64 changes, update commit message]
Link: https://lkml.kernel.org/r/20251219-pgtable_check_v18rebase-v18-3-755bc151a50b@linux.ibm.com
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

 arch/arm64/include/asm/pgtable.h |    3 ++-
 arch/riscv/include/asm/pgtable.h |    4 ++--
 arch/x86/include/asm/pgtable.h   |    4 ++--
 include/linux/page_table_check.h |   12 ++++++------
 mm/page_table_check.c            |    4 ++--
 5 files changed, 14 insertions(+), 13 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set
+++ a/arch/arm64/include/asm/pgtable.h
@@ -688,7 +688,8 @@ static inline void __set_ptes_anysz(stru
 		break;
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SIZE:
-		page_table_check_puds_set(mm, (pud_t *)ptep, pte_pud(pte), nr);
+		page_table_check_puds_set(mm, addr, (pud_t *)ptep,
+					  pte_pud(pte), nr);
 		break;
 #endif
 	default:
--- a/arch/riscv/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set
+++ a/arch/riscv/include/asm/pgtable.h
@@ -953,7 +953,7 @@ static inline void set_pmd_at(struct mm_
 static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
 				pud_t *pudp, pud_t pud)
 {
-	page_table_check_pud_set(mm, pudp, pud);
+	page_table_check_pud_set(mm, addr, pudp, pud);
 	return __set_pte_at(mm, (pte_t *)pudp, pud_pte(pud));
 }
 
@@ -1122,7 +1122,7 @@ static inline void update_mmu_cache_pud(
 static inline pud_t pudp_establish(struct vm_area_struct *vma,
 				   unsigned long address, pud_t *pudp, pud_t pud)
 {
-	page_table_check_pud_set(vma->vm_mm, pudp, pud);
+	page_table_check_pud_set(vma->vm_mm, address, pudp, pud);
 	return __pud(atomic_long_xchg((atomic_long_t *)pudp, pud_val(pud)));
 }
 
--- a/arch/x86/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set
+++ a/arch/x86/include/asm/pgtable.h
@@ -1221,7 +1221,7 @@ static inline void set_pmd_at(struct mm_
 static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
 			      pud_t *pudp, pud_t pud)
 {
-	page_table_check_pud_set(mm, pudp, pud);
+	page_table_check_pud_set(mm, addr, pudp, pud);
 	native_set_pud(pudp, pud);
 }
 
@@ -1372,7 +1372,7 @@ static inline pmd_t pmdp_establish(struc
 static inline pud_t pudp_establish(struct vm_area_struct *vma,
 		unsigned long address, pud_t *pudp, pud_t pud)
 {
-	page_table_check_pud_set(vma->vm_mm, pudp, pud);
+	page_table_check_pud_set(vma->vm_mm, address, pudp, pud);
 	if (IS_ENABLED(CONFIG_SMP)) {
 		return xchg(pudp, pud);
 	} else {
--- a/include/linux/page_table_check.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set
+++ a/include/linux/page_table_check.h
@@ -21,8 +21,8 @@ void __page_table_check_ptes_set(struct
 		unsigned int nr);
 void __page_table_check_pmds_set(struct mm_struct *mm, pmd_t *pmdp, pmd_t pmd,
 		unsigned int nr);
-void __page_table_check_puds_set(struct mm_struct *mm, pud_t *pudp, pud_t pud,
-		unsigned int nr);
+void __page_table_check_puds_set(struct mm_struct *mm, unsigned long addr,
+		pud_t *pudp, pud_t pud, unsigned int nr);
 void __page_table_check_pte_clear_range(struct mm_struct *mm,
 					unsigned long addr,
 					pmd_t pmd);
@@ -86,12 +86,12 @@ static inline void page_table_check_pmds
 }
 
 static inline void page_table_check_puds_set(struct mm_struct *mm,
-		pud_t *pudp, pud_t pud, unsigned int nr)
+		unsigned long addr, pud_t *pudp, pud_t pud, unsigned int nr)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_puds_set(mm, pudp, pud, nr);
+	__page_table_check_puds_set(mm, addr, pudp, pud, nr);
 }
 
 static inline void page_table_check_pte_clear_range(struct mm_struct *mm,
@@ -137,7 +137,7 @@ static inline void page_table_check_pmds
 }
 
 static inline void page_table_check_puds_set(struct mm_struct *mm,
-		pud_t *pudp, pud_t pud, unsigned int nr)
+		unsigned long addr, pud_t *pudp, pud_t pud, unsigned int nr)
 {
 }
 
@@ -150,6 +150,6 @@ static inline void page_table_check_pte_
 #endif /* CONFIG_PAGE_TABLE_CHECK */
 
 #define page_table_check_pmd_set(mm, pmdp, pmd)	page_table_check_pmds_set(mm, pmdp, pmd, 1)
-#define page_table_check_pud_set(mm, pudp, pud)	page_table_check_puds_set(mm, pudp, pud, 1)
+#define page_table_check_pud_set(mm, addr, pudp, pud)	page_table_check_puds_set(mm, addr, pudp, pud, 1)
 
 #endif /* __LINUX_PAGE_TABLE_CHECK_H */
--- a/mm/page_table_check.c~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set
+++ a/mm/page_table_check.c
@@ -243,8 +243,8 @@ void __page_table_check_pmds_set(struct
 }
 EXPORT_SYMBOL(__page_table_check_pmds_set);
 
-void __page_table_check_puds_set(struct mm_struct *mm, pud_t *pudp, pud_t pud,
-		unsigned int nr)
+void __page_table_check_puds_set(struct mm_struct *mm, unsigned long addr,
+		pud_t *pudp, pud_t pud,	unsigned int nr)
 {
 	unsigned long stride = PUD_SIZE >> PAGE_SHIFT;
 	unsigned int i;
_

Patches currently in -mm which might be from rmclure@linux.ibm.com are


