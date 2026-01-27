Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06CF1E5702
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486735; cv=none; b=d7LXbXKnaNzpQop7MrgB2e95kMNZO1EjjYH8To2+8jypuP03m3Jc0VVUaGxmWlwSMbNrwInGzUGHgX4l3ddlxrQTCOC+9zP8QNyWteZS4PQ63BSJX41VtD148O1BiRU68+FKfezKkQFtJMV/AVMzRuhsIg12hBA3N1u0CtY8MqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486735; c=relaxed/simple;
	bh=BCffZDP/d4HRxiDLtbPX1/JCv6uoVZq3cYD0xbr9QuE=;
	h=Date:To:From:Subject:Message-Id; b=e0agw4Eqr8/7xkwmrj+Q5tOFys7hmPMzODXF2wTDCEYwb1LdWeT11kt1xLdyjKFv6bvusRxASzEUltNuSTRlrtL/tzCoT3GR8L6AjER8YIbXFGo7OfkDUruv1cPL5W5coeO61eY/+TEZR82tR5eTE3VESqa9/mCM0tOnx2nomNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gs364B9+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gs364B9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2923C116C6;
	Tue, 27 Jan 2026 04:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486734;
	bh=BCffZDP/d4HRxiDLtbPX1/JCv6uoVZq3cYD0xbr9QuE=;
	h=Date:To:From:Subject:From;
	b=Gs364B9+rX5Jv7Efhwcxx8qYo+dcHw40EF7Zdu9DstNhsbZiY2smrUQBg/BgOjfgy
	 lO6XCZpytPuK4ON0GkUEJHfXyHWd07Jpt6c7Oh+NkfXG0LRuejME7jKBwQOaPjYrKI
	 ZgUzRQd/GR5IRrXmpqEZtedYkXvBqPbeRK1MxMkA=
Date: Mon, 26 Jan 2026 20:05:34 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,willy@infradead.org,vishal.moola@gmail.com,thuth@redhat.com,sweettea-kernel@dorminy.me,rmclure@linux.ibm.com,ritesh.list@gmail.com,paulus@ozlabs.org,pasha.tatashin@soleen.com,npiggin@gmail.com,nicholas@linux.ibm.com,mpe@ellerman.id.au,mingo@kernel.org,maddy@linux.ibm.com,linmag7@gmail.com,kevin.brodsky@arm.com,jgg@ziepe.ca,guoweikang.kernel@gmail.com,donettom@linux.ibm.com,david@kernel.org,christophe.leroy@csgroup.eu,chleroy@kernel.org,apopple@nvidia.com,alexghiti@rivosinc.com,alex@ghiti.fr,agordeev@linux.ibm.com,ajd@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-add-addr-parameter-to-__ptep_get_and_clear_anysz.patch removed from -mm tree
Message-Id: <20260127040534.C2923C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64/mm: add addr parameter to __ptep_get_and_clear_anysz()
has been removed from the -mm tree.  Its filename was
     arm64-mm-add-addr-parameter-to-__ptep_get_and_clear_anysz.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Donnellan <ajd@linux.ibm.com>
Subject: arm64/mm: add addr parameter to __ptep_get_and_clear_anysz()
Date: Fri, 19 Dec 2025 04:09:34 +1100

To provide support for page table check on powerpc, we need to
reinstate the address parameter in several functions, including
page_table_check_{pte,pmd,pud}_clear().

In preparation for this, add the addr parameter to arm64's
__ptep_get_and_clear_anysz() and change its callsites accordingly.

Link: https://lkml.kernel.org/r/20251219-pgtable_check_v18rebase-v18-2-755bc151a50b@linux.ibm.com
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
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
Cc: Rohan McLure <rmclure@linux.ibm.com>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Thomas Huth <thuth@redhat.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    5 +++--
 arch/arm64/mm/hugetlbpage.c      |    7 ++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-add-addr-parameter-to-__ptep_get_and_clear_anysz
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1332,6 +1332,7 @@ static inline int pmdp_test_and_clear_yo
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
 
 static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
+					       unsigned long address,
 					       pte_t *ptep,
 					       unsigned long pgsize)
 {
@@ -1359,7 +1360,7 @@ static inline pte_t __ptep_get_and_clear
 static inline pte_t __ptep_get_and_clear(struct mm_struct *mm,
 				       unsigned long address, pte_t *ptep)
 {
-	return __ptep_get_and_clear_anysz(mm, ptep, PAGE_SIZE);
+	return __ptep_get_and_clear_anysz(mm, address, ptep, PAGE_SIZE);
 }
 
 static inline void __clear_full_ptes(struct mm_struct *mm, unsigned long addr,
@@ -1398,7 +1399,7 @@ static inline pte_t __get_and_clear_full
 static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 					    unsigned long address, pmd_t *pmdp)
 {
-	return pte_pmd(__ptep_get_and_clear_anysz(mm, (pte_t *)pmdp, PMD_SIZE));
+	return pte_pmd(__ptep_get_and_clear_anysz(mm, address, (pte_t *)pmdp, PMD_SIZE));
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
--- a/arch/arm64/mm/hugetlbpage.c~arm64-mm-add-addr-parameter-to-__ptep_get_and_clear_anysz
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -155,11 +155,12 @@ static pte_t get_clear_contig(struct mm_
 	pte_t pte, tmp_pte;
 	bool present;
 
-	pte = __ptep_get_and_clear_anysz(mm, ptep, pgsize);
+	pte = __ptep_get_and_clear_anysz(mm, addr, ptep, pgsize);
 	present = pte_present(pte);
 	while (--ncontig) {
 		ptep++;
-		tmp_pte = __ptep_get_and_clear_anysz(mm, ptep, pgsize);
+		addr += pgsize;
+		tmp_pte = __ptep_get_and_clear_anysz(mm, addr, ptep, pgsize);
 		if (present) {
 			if (pte_dirty(tmp_pte))
 				pte = pte_mkdirty(pte);
@@ -203,7 +204,7 @@ static void clear_flush(struct mm_struct
 	unsigned long i, saddr = addr;
 
 	for (i = 0; i < ncontig; i++, addr += pgsize, ptep++)
-		__ptep_get_and_clear_anysz(mm, ptep, pgsize);
+		__ptep_get_and_clear_anysz(mm, addr, ptep, pgsize);
 
 	if (mm == &init_mm)
 		flush_tlb_kernel_range(saddr, addr);
_

Patches currently in -mm which might be from ajd@linux.ibm.com are


