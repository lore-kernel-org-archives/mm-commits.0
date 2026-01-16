Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE422F531B
	for <mm-commits@vger.kernel.org>; Fri, 16 Jan 2026 00:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768523137; cv=none; b=seKtvT6zYxc4rsTJgLRM4uzQFwS+FsSdhLNh01u0VBzAFbZC8wLF5ZSeMqXTRK723D9eEZ6yrwVd7cNvPZSxcgqRzSK0T0txz+jnAmIvL86cHSfMG/GOJSJkCri59IXOa2LdGnoE5vqSG/MAo04l7OSTxTOkjwkirfRiRypIGSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768523137; c=relaxed/simple;
	bh=k1FJU5iem8qSQPyqePDlyvAa7FKbSR5hy9/1D0ic0J0=;
	h=Date:To:From:Subject:Message-Id; b=VjdnggkpE0tfC+MyKuBHE/IrUI0lZofZlK7hokIluCeSLf1cRZq79Jg4vx0MZnRYYPZmSLP6i/l6S49LvhB2qxaVcHORWNb6SauG/BwvG1zDBm90Y6a8YC1+yKlDcvlAGgkpaeZV86iA2NJY7yMx6VuQs5zsS5szkZaZASYHFJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KUtLQfpE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KUtLQfpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323E6C116D0;
	Fri, 16 Jan 2026 00:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768523137;
	bh=k1FJU5iem8qSQPyqePDlyvAa7FKbSR5hy9/1D0ic0J0=;
	h=Date:To:From:Subject:From;
	b=KUtLQfpECb91jfQOX6YgOY0WcbPA69KSTzdVAdjG7qA8omAlP3uOSmaIRmB+gLACR
	 T5ilb/GzDS2yij2nWW+60JFeqyiCguaNIMxjgFq/0MsAvB/KfE6cxgvzXIJMxWx0Sl
	 Y8qfuxeAr0maamUy0c0gqlv3JuVl/DtI0X/2qLfo=
Date: Thu, 15 Jan 2026 16:25:36 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,willy@infradead.org,vishal.moola@gmail.com,thuth@redhat.com,sweettea-kernel@dorminy.me,ritesh.list@gmail.com,paulus@ozlabs.org,pasha.tatashin@soleen.com,npiggin@gmail.com,nicholas@linux.ibm.com,mpe@ellerman.id.au,mingo@kernel.org,maddy@linux.ibm.com,linmag7@gmail.com,kevin.brodsky@arm.com,jgg@ziepe.ca,guoweikang.kernel@gmail.com,donettom@linux.ibm.com,david@kernel.org,christophe.leroy@csgroup.eu,chleroy@kernel.org,apopple@nvidia.com,alexghiti@rivosinc.com,alex@ghiti.fr,ajd@linux.ibm.com,agordeev@linux.ibm.com,rmclure@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear.patch added to mm-new branch
Message-Id: <20260116002537.323E6C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_table_check: reinstate address parameter in [__]page_table_check_pmd_clear()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Rohan McLure <rmclure@linux.ibm.com>
Subject: mm/page_table_check: reinstate address parameter in [__]page_table_check_pmd_clear()
Date: Fri, 19 Dec 2025 04:09:39 +1100

This reverts commit 1831414cd729 ("mm/page_table_check: remove unused
parameter in [__]page_table_check_pmd_clear").

Reinstate previously unused parameters for the purpose of supporting
powerpc platforms, as many do not encode user/kernel ownership of the page
in the pte, but instead in the address of the access.

[ajd@linux.ibm.com: rebase on arm64 changes]
Link: https://lkml.kernel.org/r/20251219-pgtable_check_v18rebase-v18-7-755bc151a50b@linux.ibm.com
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Ingo Molnar <mingo@kernel.org>  # x86
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

--- a/arch/arm64/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1345,7 +1345,7 @@ static inline pte_t __ptep_get_and_clear
 		page_table_check_pte_clear(mm, pte);
 		break;
 	case PMD_SIZE:
-		page_table_check_pmd_clear(mm, pte_pmd(pte));
+		page_table_check_pmd_clear(mm, address, pte_pmd(pte));
 		break;
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SIZE:
--- a/arch/riscv/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear
+++ a/arch/riscv/include/asm/pgtable.h
@@ -1007,7 +1007,7 @@ static inline pmd_t pmdp_huge_get_and_cl
 	pmd_clear(pmdp);
 #endif
 
-	page_table_check_pmd_clear(mm, pmd);
+	page_table_check_pmd_clear(mm, address, pmd);
 
 	return pmd;
 }
--- a/arch/x86/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear
+++ a/arch/x86/include/asm/pgtable.h
@@ -1319,7 +1319,7 @@ static inline pmd_t pmdp_huge_get_and_cl
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
@@ -121,7 +123,8 @@ static inline void page_table_check_pte_
 {
 }
 
-static inline void page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd)
+static inline void page_table_check_pmd_clear(struct mm_struct *mm,
+					      unsigned long addr, pmd_t pmd)
 {
 }
 
--- a/include/linux/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pmd_clear
+++ a/include/linux/pgtable.h
@@ -788,7 +788,7 @@ static inline pmd_t pmdp_huge_get_and_cl
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
@@ -238,7 +239,7 @@ void __page_table_check_pmds_set(struct
 	page_table_check_pmd_flags(pmd);
 
 	for (i = 0; i < nr; i++)
-		__page_table_check_pmd_clear(mm, *(pmdp + i));
+		__page_table_check_pmd_clear(mm, addr + PMD_SIZE * i, *(pmdp + i));
 	if (pmd_user_accessible_page(pmd))
 		page_table_check_set(pmd_pfn(pmd), stride * nr, pmd_write(pmd));
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
powerpc-mm-implement-_user_accessible_page-for-ptes.patch
powerpc-mm-use-set_pte_at_unchecked-for-internal-usages.patch
powerpc-mm-support-page-table-check.patch

