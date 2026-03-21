Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F6D346AF1
	for <mm-commits@vger.kernel.org>; Sat, 21 Mar 2026 18:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774116645; cv=none; b=rR1JB2szVaXfMTIdM1u30NtI987lB0xFoskCMEdi44KWHFc+R9VQ31LcuMeQvqvKIhsoM8ZIrTR7WXXRR3iyMWShg/QaTu5e1u2C4ELhwgO0Kskfh1HejS/J4iimyotTlpMt9bxzkIin6ISNGZpz58+3MqGIq34tn1chZ3fVS4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774116645; c=relaxed/simple;
	bh=hlAUz+WfIMXG0xXCH63SBiU6u/MZ+Cl6c90yDXd+nHc=;
	h=Date:To:From:Subject:Message-Id; b=ujdhj3QT7D19Cdcqea4vNOH8tZ2JXewyHYAIeJpWk4NArf10Au6SfJIhMi3I4irx23DC0BVbopop/9+hhcJM/joSvCQX2qskRo8qr1CDKdpfmZfpv0eW1mgdofFgFpcKCMN1l3nCER2Nox1Q0gbgsImH/PJA3RYOymIrD8PnhP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A+p3JCav; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A+p3JCav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9B5C2BCAF;
	Sat, 21 Mar 2026 18:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774116645;
	bh=hlAUz+WfIMXG0xXCH63SBiU6u/MZ+Cl6c90yDXd+nHc=;
	h=Date:To:From:Subject:From;
	b=A+p3JCavgbdB1e8ABh6xS5zrUjYHYon+SWzY8blmGUl3gmSASjgn4UOh46NanVnGT
	 U0cypZXrfZU6RqRBb87D0TRaow5Vl5Lj+HauHKO1KRYyDHUofM1ZlTwl3vhGBshw21
	 npfOB1vtdAh672MVm7a2sPlxvv2xP8RVsXZTUvbk=
Date: Sat, 21 Mar 2026 11:10:44 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,ritesh.list@gmail.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-to-return-bool-for-pmdp_clear_flush_young.patch added to mm-new branch
Message-Id: <20260321181045.3E9B5C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: change to return bool for pmdp_clear_flush_young()
has been added to the -mm mm-new branch.  Its filename is
     mm-change-to-return-bool-for-pmdp_clear_flush_young.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-to-return-bool-for-pmdp_clear_flush_young.patch

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
Subject: mm: change to return bool for pmdp_clear_flush_young()
Date: Sat, 21 Mar 2026 14:42:52 +0800

The pmdp_clear_flush_young() is used to clear the young flag and flush the
TLB, returning whether the young flag was set for this PMD entry.  Change
the return type to bool to make the intention clearer.

Link: https://lkml.kernel.org/r/a668b9a974c0d675e7a41f6973bcbe3336e8b373.1774075004.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/pgtable.h |    4 ++--
 arch/x86/include/asm/pgtable.h  |    4 ++--
 arch/x86/mm/pgtable.c           |    6 +++---
 include/linux/pgtable.h         |   10 +++++-----
 mm/pgtable-generic.c            |    7 ++++---
 5 files changed, 16 insertions(+), 15 deletions(-)

--- a/arch/s390/include/asm/pgtable.h~mm-change-to-return-bool-for-pmdp_clear_flush_young
+++ a/arch/s390/include/asm/pgtable.h
@@ -1693,8 +1693,8 @@ static inline bool pmdp_test_and_clear_y
 }
 
 #define __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
-static inline int pmdp_clear_flush_young(struct vm_area_struct *vma,
-					 unsigned long addr, pmd_t *pmdp)
+static inline bool pmdp_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t *pmdp)
 {
 	VM_BUG_ON(addr & ~HPAGE_MASK);
 	return pmdp_test_and_clear_young(vma, addr, pmdp);
--- a/arch/x86/include/asm/pgtable.h~mm-change-to-return-bool-for-pmdp_clear_flush_young
+++ a/arch/x86/include/asm/pgtable.h
@@ -1301,8 +1301,8 @@ extern int pudp_test_and_clear_young(str
 				     unsigned long addr, pud_t *pudp);
 
 #define __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
-extern int pmdp_clear_flush_young(struct vm_area_struct *vma,
-				  unsigned long address, pmd_t *pmdp);
+bool pmdp_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp);
 
 
 #define __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
--- a/arch/x86/mm/pgtable.c~mm-change-to-return-bool-for-pmdp_clear_flush_young
+++ a/arch/x86/mm/pgtable.c
@@ -503,10 +503,10 @@ bool ptep_clear_flush_young(struct vm_ar
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-int pmdp_clear_flush_young(struct vm_area_struct *vma,
-			   unsigned long address, pmd_t *pmdp)
+bool pmdp_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp)
 {
-	int young;
+	bool young;
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
--- a/include/linux/pgtable.h~mm-change-to-return-bool-for-pmdp_clear_flush_young
+++ a/include/linux/pgtable.h
@@ -536,18 +536,18 @@ bool ptep_clear_flush_young(struct vm_ar
 
 #ifndef __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-extern int pmdp_clear_flush_young(struct vm_area_struct *vma,
-				  unsigned long address, pmd_t *pmdp);
+bool pmdp_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp);
 #else
 /*
  * Despite relevant to THP only, this API is called from generic rmap code
  * under PageTransHuge(), hence needs a dummy implementation for !THP
  */
-static inline int pmdp_clear_flush_young(struct vm_area_struct *vma,
-					 unsigned long address, pmd_t *pmdp)
+static inline bool pmdp_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp)
 {
 	BUILD_BUG();
-	return 0;
+	return false;
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
--- a/mm/pgtable-generic.c~mm-change-to-return-bool-for-pmdp_clear_flush_young
+++ a/mm/pgtable-generic.c
@@ -124,10 +124,11 @@ int pmdp_set_access_flags(struct vm_area
 #endif
 
 #ifndef __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
-int pmdp_clear_flush_young(struct vm_area_struct *vma,
-			   unsigned long address, pmd_t *pmdp)
+bool pmdp_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp)
 {
-	int young;
+	bool young;
+
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 	young = pmdp_test_and_clear_young(vma, address, pmdp);
 	if (young)
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

