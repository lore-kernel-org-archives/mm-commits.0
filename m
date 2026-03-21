Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1D8347BD4
	for <mm-commits@vger.kernel.org>; Sat, 21 Mar 2026 18:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774116650; cv=none; b=QHr9VPQ1Q8xECmrIMX3W6O9zOhXyw9aloCJ5Ziz4eupnhEYP7417GmDMG7iQ3F+mE9G3Z7P0teQ3imDOkLGEKDxG/b1OysKKab/+h6+9DVwSfonOIGHBuRDPK6TmjEYtSiSDwX70M2ZkPv/V4u3KpcOZb0uPUQQ0Yub74YkNCsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774116650; c=relaxed/simple;
	bh=DiKpmyruVrGXbQlug8Y/ETP7IQHeyvEsPUIPgZPJXTg=;
	h=Date:To:From:Subject:Message-Id; b=sf7Oko0KROQNgYnzCR/L0ezHPv9YR8MyY1kQeq5I4q85fz7UF4n+jLl920dPs4+mYFEpGSKDnO4Z1JtTWt3c2bDfDESJIrvOWLHShvlVvEgjKCsGjs7pLXcyYbveKoYx3XRhD+O9da4QUgZSvxNt0ggmqKLTQp2LRea7O4+e4sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XABHYa9t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XABHYa9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163C4C2BCAF;
	Sat, 21 Mar 2026 18:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774116649;
	bh=DiKpmyruVrGXbQlug8Y/ETP7IQHeyvEsPUIPgZPJXTg=;
	h=Date:To:From:Subject:From;
	b=XABHYa9t+wEPj2weLT7iSCeRt6BqXS0msL15sVr9ANb8fXlg4oMiAdCm5y+M9ojKo
	 5ug7Ue8rFAang/dLkHnj8yxSBcBPHZUcBMygtYdolx5SyE2sAHKxonwJ0VzSMJgWJ8
	 N4LnCfvkirbX1h34oDGgb8Z5roXlIhR8HNUWay7E=
Date: Sat, 21 Mar 2026 11:10:48 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,ritesh.list@gmail.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-to-return-bool-for-pudp_test_and_clear_young.patch added to mm-new branch
Message-Id: <20260321181049.163C4C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: change to return bool for pudp_test_and_clear_young()
has been added to the -mm mm-new branch.  Its filename is
     mm-change-to-return-bool-for-pudp_test_and_clear_young.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-to-return-bool-for-pudp_test_and_clear_young.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: change to return bool for pudp_test_and_clear_young()
Date: Sat, 21 Mar 2026 14:42:53 +0800

The pudp_test_and_clear_young() is used to clear the young flag, returning
whether the young flag was set for this PUD entry.  Change the return type
to bool to make the intention clearer.

Link: https://lkml.kernel.org/r/2c56fe52c1bf9404145274d7e91d4a65060f6c7c.1774075004.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/pgtable.h |   10 +++++-----
 arch/powerpc/mm/book3s64/pgtable.c           |    4 ++--
 arch/riscv/include/asm/pgtable.h             |    4 ++--
 arch/x86/include/asm/pgtable.h               |    4 ++--
 arch/x86/mm/pgtable.c                        |    6 +++---
 5 files changed, 14 insertions(+), 14 deletions(-)

--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~mm-change-to-return-bool-for-pudp_test_and_clear_young
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1172,13 +1172,13 @@ static inline bool __pmdp_test_and_clear
 	return ((old & _PAGE_ACCESSED) != 0);
 }
 
-static inline int __pudp_test_and_clear_young(struct mm_struct *mm,
-					      unsigned long addr, pud_t *pudp)
+static inline bool __pudp_test_and_clear_young(struct mm_struct *mm,
+		unsigned long addr, pud_t *pudp)
 {
 	unsigned long old;
 
 	if ((pud_raw(*pudp) & cpu_to_be64(_PAGE_ACCESSED | H_PAGE_HASHPTE)) == 0)
-		return 0;
+		return false;
 	old = pud_hugepage_update(mm, addr, pudp, _PAGE_ACCESSED, 0);
 	return ((old & _PAGE_ACCESSED) != 0);
 }
@@ -1303,8 +1303,8 @@ extern int pudp_set_access_flags(struct
 bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp);
 #define __HAVE_ARCH_PUDP_TEST_AND_CLEAR_YOUNG
-extern int pudp_test_and_clear_young(struct vm_area_struct *vma,
-				     unsigned long address, pud_t *pudp);
+bool pudp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pud_t *pudp);
 
 
 #define __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
--- a/arch/powerpc/mm/book3s64/pgtable.c~mm-change-to-return-bool-for-pudp_test_and_clear_young
+++ a/arch/powerpc/mm/book3s64/pgtable.c
@@ -104,8 +104,8 @@ bool pmdp_test_and_clear_young(struct vm
 	return __pmdp_test_and_clear_young(vma->vm_mm, address, pmdp);
 }
 
-int pudp_test_and_clear_young(struct vm_area_struct *vma,
-			      unsigned long address, pud_t *pudp)
+bool pudp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pud_t *pudp)
 {
 	return __pudp_test_and_clear_young(vma->vm_mm, address, pudp);
 }
--- a/arch/riscv/include/asm/pgtable.h~mm-change-to-return-bool-for-pudp_test_and_clear_young
+++ a/arch/riscv/include/asm/pgtable.h
@@ -1109,8 +1109,8 @@ static inline int pudp_set_access_flags(
 	return ptep_set_access_flags(vma, address, (pte_t *)pudp, pud_pte(entry), dirty);
 }
 
-static inline int pudp_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long address, pud_t *pudp)
+static inline bool pudp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pud_t *pudp)
 {
 	return ptep_test_and_clear_young(vma, address, (pte_t *)pudp);
 }
--- a/arch/x86/include/asm/pgtable.h~mm-change-to-return-bool-for-pudp_test_and_clear_young
+++ a/arch/x86/include/asm/pgtable.h
@@ -1297,8 +1297,8 @@ extern int pudp_set_access_flags(struct
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
 bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmdp);
-extern int pudp_test_and_clear_young(struct vm_area_struct *vma,
-				     unsigned long addr, pud_t *pudp);
+bool pudp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pud_t *pudp);
 
 #define __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
 bool pmdp_clear_flush_young(struct vm_area_struct *vma,
--- a/arch/x86/mm/pgtable.c~mm-change-to-return-bool-for-pudp_test_and_clear_young
+++ a/arch/x86/mm/pgtable.c
@@ -470,10 +470,10 @@ bool pmdp_test_and_clear_young(struct vm
 #endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-int pudp_test_and_clear_young(struct vm_area_struct *vma,
-			      unsigned long addr, pud_t *pudp)
+bool pudp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pud_t *pudp)
 {
-	int ret = 0;
+	bool ret = false;
 
 	if (pud_young(*pudp))
 		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-filemap-fix-nr_pages-calculation-overflow-in-filemap_map_pages.patch
mm-use-inline-helper-functions-instead-of-ugly-macros.patch
mm-rename-ptep-pmdp_clear_young_notify-to-ptep-pmdp_test_and_clear_young_notify.patch
mm-rmap-add-a-zone_device-folio-warning-in-folio_referenced.patch
mm-add-a-batched-helper-to-clear-the-young-flag-for-large-folios.patch
mm-support-batched-checking-of-the-young-flag-for-mglru.patch
arm64-mm-implement-the-architecture-specific-test_and_clear_young_ptes.patch
mm-change-to-return-bool-for-ptep_test_and_clear_young.patch
mm-change-to-return-bool-for-ptep_clear_flush_young-clear_flush_young_ptes.patch
mm-change-to-return-bool-for-pmdp_test_and_clear_young.patch
mm-change-to-return-bool-for-pmdp_clear_flush_young.patch
mm-change-to-return-bool-for-pudp_test_and_clear_young.patch
mm-change-to-return-bool-for-the-mmu-notifiers-young-flag-check.patch

