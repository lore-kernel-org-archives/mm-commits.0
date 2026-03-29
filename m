Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B22A27F017
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744961; cv=none; b=t998Bcl7CMy0uVfj1fDS4nSKkNVm2b78/5SBWgJU58hoU3MMcY0L3gorxT0zeVDwDm8+AA01PeeHCm6VWXJ32vJIEPNLBIDjYk94KOd4GsC0eROA270ybjo4x4Jjll89284B3Zp4G7aZuNFkVdFTddml4ZbBXr2RtnxxviIlCRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744961; c=relaxed/simple;
	bh=XM3oF0sGyeeoQ0B8EjR/xkRFkuHJdYsWrct9YiFfT34=;
	h=Date:To:From:Subject:Message-Id; b=CYHHhLYH39LROWofwy34I40lDzpsETtVFKnUmjsTT1fOFFT6qxL5YEKU3JAMe1EzE2H4iikgmOh8vvKZVetu4+PwaMgkcQrL/xm3LuSJCtT8z+Jy3SfYXPiJHeUebyOQ/o6Bnk6C9jeH4ZeskQh1OvxfjhMcJyhr5LPLlxz+8u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KJbVNYtL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KJbVNYtL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549A4C4CEF7;
	Sun, 29 Mar 2026 00:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744961;
	bh=XM3oF0sGyeeoQ0B8EjR/xkRFkuHJdYsWrct9YiFfT34=;
	h=Date:To:From:Subject:From;
	b=KJbVNYtLk1IjKVbQV5LBMZiTOcDdGo+J2LHOejvAWaoITicZnoSK2g9UJUfCN+SPJ
	 QhyQl/Tc6IBJHjfCpAyp4iiPIVk8v1I2fD3FmsEYuUWY66xEmo/PBNE5dp+ZRh7Nx2
	 Kbql+XVg4AeqxTRJHQjhunV6I4ODFVgoPCOiFObY=
Date: Sat, 28 Mar 2026 17:42:40 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,ritesh.list@gmail.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-change-to-return-bool-for-pmdp_test_and_clear_young.patch removed from -mm tree
Message-Id: <20260329004241.549A4C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: change to return bool for pmdp_test_and_clear_young()
has been removed from the -mm tree.  Its filename was
     mm-change-to-return-bool-for-pmdp_test_and_clear_young.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: change to return bool for pmdp_test_and_clear_young()
Date: Sat, 21 Mar 2026 14:42:51 +0800

Callers use pmdp_test_and_clear_young() to clear the young flag and check
whether it was set for this PMD entry.  Change the return type to bool to
make the intention clearer.

Link: https://lkml.kernel.org/r/f1d31307a13365d3d0fed5809727dcc2dd59631b.1774075004.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h             |    5 +---
 arch/powerpc/include/asm/book3s/64/pgtable.h |   10 ++++----
 arch/powerpc/mm/book3s64/pgtable.c           |    4 +--
 arch/riscv/include/asm/pgtable.h             |    4 +--
 arch/s390/include/asm/pgtable.h              |    4 +--
 arch/x86/include/asm/pgtable.h               |    4 +--
 arch/x86/mm/pgtable.c                        |    6 ++---
 include/linux/pgtable.h                      |   19 ++++++++---------
 8 files changed, 27 insertions(+), 29 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-change-to-return-bool-for-pmdp_test_and_clear_young
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1320,9 +1320,8 @@ static inline bool __ptep_clear_flush_yo
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG)
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
-static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long address,
-					    pmd_t *pmdp)
+static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp)
 {
 	/* Operation applies to PMD table entry only if FEAT_HAFT is enabled */
 	VM_WARN_ON(pmd_table(READ_ONCE(*pmdp)) && !system_supports_haft());
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~mm-change-to-return-bool-for-pmdp_test_and_clear_young
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1161,13 +1161,13 @@ pud_hugepage_update(struct mm_struct *mm
  * For radix we should always find H_PAGE_HASHPTE zero. Hence
  * the below will work for radix too
  */
-static inline int __pmdp_test_and_clear_young(struct mm_struct *mm,
-					      unsigned long addr, pmd_t *pmdp)
+static inline bool __pmdp_test_and_clear_young(struct mm_struct *mm,
+		unsigned long addr, pmd_t *pmdp)
 {
 	unsigned long old;
 
 	if ((pmd_raw(*pmdp) & cpu_to_be64(_PAGE_ACCESSED | H_PAGE_HASHPTE)) == 0)
-		return 0;
+		return false;
 	old = pmd_hugepage_update(mm, addr, pmdp, _PAGE_ACCESSED, 0);
 	return ((old & _PAGE_ACCESSED) != 0);
 }
@@ -1300,8 +1300,8 @@ extern int pudp_set_access_flags(struct
 				 pud_t entry, int dirty);
 
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
-extern int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-				     unsigned long address, pmd_t *pmdp);
+bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp);
 #define __HAVE_ARCH_PUDP_TEST_AND_CLEAR_YOUNG
 extern int pudp_test_and_clear_young(struct vm_area_struct *vma,
 				     unsigned long address, pud_t *pudp);
--- a/arch/powerpc/mm/book3s64/pgtable.c~mm-change-to-return-bool-for-pmdp_test_and_clear_young
+++ a/arch/powerpc/mm/book3s64/pgtable.c
@@ -98,8 +98,8 @@ int pudp_set_access_flags(struct vm_area
 }
 
 
-int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-			      unsigned long address, pmd_t *pmdp)
+bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp)
 {
 	return __pmdp_test_and_clear_young(vma->vm_mm, address, pmdp);
 }
--- a/arch/riscv/include/asm/pgtable.h~mm-change-to-return-bool-for-pmdp_test_and_clear_young
+++ a/arch/riscv/include/asm/pgtable.h
@@ -1015,8 +1015,8 @@ static inline int pmdp_set_access_flags(
 }
 
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
-static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-					unsigned long address, pmd_t *pmdp)
+static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp)
 {
 	return ptep_test_and_clear_young(vma, address, (pte_t *)pmdp);
 }
--- a/arch/s390/include/asm/pgtable.h~mm-change-to-return-bool-for-pmdp_test_and_clear_young
+++ a/arch/s390/include/asm/pgtable.h
@@ -1683,8 +1683,8 @@ static inline int pmdp_set_access_flags(
 }
 
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
-static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long addr, pmd_t *pmdp)
+static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t *pmdp)
 {
 	pmd_t pmd = *pmdp;
 
--- a/arch/x86/include/asm/pgtable.h~mm-change-to-return-bool-for-pmdp_test_and_clear_young
+++ a/arch/x86/include/asm/pgtable.h
@@ -1295,8 +1295,8 @@ extern int pudp_set_access_flags(struct
 				 pud_t entry, int dirty);
 
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
-extern int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-				     unsigned long addr, pmd_t *pmdp);
+bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t *pmdp);
 extern int pudp_test_and_clear_young(struct vm_area_struct *vma,
 				     unsigned long addr, pud_t *pudp);
 
--- a/arch/x86/mm/pgtable.c~mm-change-to-return-bool-for-pmdp_test_and_clear_young
+++ a/arch/x86/mm/pgtable.c
@@ -456,10 +456,10 @@ bool ptep_test_and_clear_young(struct vm
 }
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG)
-int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-			      unsigned long addr, pmd_t *pmdp)
+bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t *pmdp)
 {
-	int ret = 0;
+	bool ret = false;
 
 	if (pmd_young(*pmdp))
 		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,
--- a/include/linux/pgtable.h~mm-change-to-return-bool-for-pmdp_test_and_clear_young
+++ a/include/linux/pgtable.h
@@ -507,25 +507,24 @@ static inline bool ptep_test_and_clear_y
 
 #ifndef __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG)
-static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long address,
-					    pmd_t *pmdp)
+static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp)
 {
 	pmd_t pmd = *pmdp;
-	int r = 1;
+	bool young = true;
+
 	if (!pmd_young(pmd))
-		r = 0;
+		young = false;
 	else
 		set_pmd_at(vma->vm_mm, address, pmdp, pmd_mkold(pmd));
-	return r;
+	return young;
 }
 #else
-static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long address,
-					    pmd_t *pmdp)
+static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp)
 {
 	BUILD_BUG();
-	return 0;
+	return false;
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
 #endif
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-filemap-fix-nr_pages-calculation-overflow-in-filemap_map_pages.patch
mm-vmscan-fix-dirty-folios-throttling-on-cgroup-v1-for-mglru.patch

