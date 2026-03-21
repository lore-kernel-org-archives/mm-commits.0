Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8E9258EC2
	for <mm-commits@vger.kernel.org>; Sat, 21 Mar 2026 18:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774116626; cv=none; b=BqyRw440nA+EUs1pCOHxLfG4egkWQHZ9wV7t56LGVflZvXxm6cDzkICFxrDbQblykkDlTu2GtrJP7j91Pf7srpqB278Rt4l/+DkuWPiji0NTOt8Z/tDAaV2f7oYt90HsRtOOME+HbHHpmM6gi+vzfh7rqB/2AzAQ19jz08Oi/R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774116626; c=relaxed/simple;
	bh=HrWtNpXdw8ieSSnkU47lvoDm8CNGqKEE1jxDulp6+fE=;
	h=Date:To:From:Subject:Message-Id; b=CVIn7eGzLvTaqWTShq+V2ml77xwGTwJIGWHj7hIhxMCtfQYw0Uk/ByEF7Fx3YVegqohJ36JU8R8kbKlnRXdYH3KVB3vyXdlssr0yp7TPNGwZK0yMrru4eRxFac3F2YOAxA82dI9y+b1tv5TFIlsCddxQGdI6uqFz7pYNGzT+Drg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ESX/eEoB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ESX/eEoB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5ACC2BCAF;
	Sat, 21 Mar 2026 18:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774116625;
	bh=HrWtNpXdw8ieSSnkU47lvoDm8CNGqKEE1jxDulp6+fE=;
	h=Date:To:From:Subject:From;
	b=ESX/eEoBIdNVgJiOEmudAFcxNRd26NxE+NHIsn82M4WZ8b4o3lmp1BKe/VaOp50I7
	 8CajeBYCSPPG4TbDU03x523B9FOZREUD44LdTge438nZv6K+MJ7mUKCJwKhrIGKWKA
	 VlvnOMJjEQj5bkNSevIW70aqgGPeCjKytrnCP7/o=
Date: Sat, 21 Mar 2026 11:10:25 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,ritesh.list@gmail.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-to-return-bool-for-ptep_test_and_clear_young.patch added to mm-new branch
Message-Id: <20260321181025.AE5ACC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: change to return bool for ptep_test_and_clear_young()
has been added to the -mm mm-new branch.  Its filename is
     mm-change-to-return-bool-for-ptep_test_and_clear_young.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-to-return-bool-for-ptep_test_and_clear_young.patch

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
Subject: mm: change to return bool for ptep_test_and_clear_young()
Date: Sat, 21 Mar 2026 14:42:49 +0800

Patch series "change young flag check functions to return bool", v2.

This is a cleanup patchset to change all young flag check functions to
return bool, as discussed with David in the previous thread[1].  Since
callers only care about whether the young flag was set, returning bool
makes the intention clearer.  No functional changes intended.


This patch (of 6):

Callers use ptep_test_and_clear_young() to clear the young flag and check
whether it was set.  Change the return type to bool to make the intention
clearer.

Link: https://lkml.kernel.org/r/cover.1774075004.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/57e70efa9703d43959aa645246ea3cbdba14fa17.1774075004.git.baolin.wang@linux.alibaba.com
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

 arch/arm64/include/asm/pgtable.h             |   16 +++++++---------
 arch/arm64/mm/contpte.c                      |    7 +++----
 arch/microblaze/include/asm/pgtable.h        |    2 +-
 arch/parisc/include/asm/pgtable.h            |    7 ++++---
 arch/powerpc/include/asm/book3s/32/pgtable.h |    4 ++--
 arch/powerpc/include/asm/book3s/64/pgtable.h |    6 +++---
 arch/powerpc/include/asm/nohash/pgtable.h    |    4 ++--
 arch/riscv/include/asm/pgtable.h             |    4 ++--
 arch/riscv/mm/pgtable.c                      |    7 +++----
 arch/s390/include/asm/pgtable.h              |    4 ++--
 arch/x86/include/asm/pgtable.h               |    4 ++--
 arch/x86/mm/pgtable.c                        |    6 +++---
 arch/xtensa/include/asm/pgtable.h            |    9 ++++-----
 include/linux/pgtable.h                      |   16 ++++++++--------
 14 files changed, 46 insertions(+), 50 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-change-to-return-bool-for-ptep_test_and_clear_young
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1282,9 +1282,8 @@ static inline void __pte_clear(struct mm
 	__set_pte(ptep, __pte(0));
 }
 
-static inline int __ptep_test_and_clear_young(struct vm_area_struct *vma,
-					      unsigned long address,
-					      pte_t *ptep)
+static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pte_t *ptep)
 {
 	pte_t old_pte, pte;
 
@@ -1646,7 +1645,7 @@ extern void contpte_clear_full_ptes(stru
 extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
 				unsigned long addr, pte_t *ptep,
 				unsigned int nr, int full);
-int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
+bool contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
 				unsigned long addr, pte_t *ptep, unsigned int nr);
 int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
 				unsigned long addr, pte_t *ptep, unsigned int nr);
@@ -1813,9 +1812,8 @@ static inline pte_t ptep_get_and_clear(s
 }
 
 #define test_and_clear_young_ptes test_and_clear_young_ptes
-static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
-					    unsigned long addr, pte_t *ptep,
-					    unsigned int nr)
+static inline bool test_and_clear_young_ptes(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, unsigned int nr)
 {
 	if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
 		return __ptep_test_and_clear_young(vma, addr, ptep);
@@ -1824,8 +1822,8 @@ static inline int test_and_clear_young_p
 }
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
-				unsigned long addr, pte_t *ptep)
+static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
 {
 	return test_and_clear_young_ptes(vma, addr, ptep, 1);
 }
--- a/arch/arm64/mm/contpte.c~mm-change-to-return-bool-for-ptep_test_and_clear_young
+++ a/arch/arm64/mm/contpte.c
@@ -508,9 +508,8 @@ pte_t contpte_get_and_clear_full_ptes(st
 }
 EXPORT_SYMBOL_GPL(contpte_get_and_clear_full_ptes);
 
-int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
-					unsigned long addr, pte_t *ptep,
-					unsigned int nr)
+bool contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, unsigned int nr)
 {
 	/*
 	 * ptep_clear_flush_young() technically requires us to clear the access
@@ -525,7 +524,7 @@ int contpte_test_and_clear_young_ptes(st
 	 */
 
 	unsigned long end = addr + nr * PAGE_SIZE;
-	int young = 0;
+	bool young = false;
 
 	ptep = contpte_align_addr_ptep(&addr, &end, ptep, nr);
 	for (; addr != end; ptep++, addr += PAGE_SIZE)
--- a/arch/microblaze/include/asm/pgtable.h~mm-change-to-return-bool-for-ptep_test_and_clear_young
+++ a/arch/microblaze/include/asm/pgtable.h
@@ -318,7 +318,7 @@ static inline void set_pte(pte_t *ptep,
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 struct vm_area_struct;
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
+static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
 		unsigned long address, pte_t *ptep)
 {
 	return (pte_update(ptep, _PAGE_ACCESSED, 0) & _PAGE_ACCESSED) != 0;
--- a/arch/parisc/include/asm/pgtable.h~mm-change-to-return-bool-for-ptep_test_and_clear_young
+++ a/arch/parisc/include/asm/pgtable.h
@@ -438,16 +438,17 @@ static inline pte_t ptep_get(pte_t *ptep
 }
 #define ptep_get ptep_get
 
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
+static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
 {
 	pte_t pte;
 
 	pte = ptep_get(ptep);
 	if (!pte_young(pte)) {
-		return 0;
+		return false;
 	}
 	set_pte_at(vma->vm_mm, addr, ptep, pte_mkold(pte));
-	return 1;
+	return true;
 }
 
 int ptep_clear_flush_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep);
--- a/arch/powerpc/include/asm/book3s/32/pgtable.h~mm-change-to-return-bool-for-ptep_test_and_clear_young
+++ a/arch/powerpc/include/asm/book3s/32/pgtable.h
@@ -295,8 +295,8 @@ static inline pte_basic_t pte_update(str
  * for our hash-based implementation, we fix that up here.
  */
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-static inline int __ptep_test_and_clear_young(struct mm_struct *mm,
-					      unsigned long addr, pte_t *ptep)
+static inline bool __ptep_test_and_clear_young(struct mm_struct *mm,
+		unsigned long addr, pte_t *ptep)
 {
 	unsigned long old;
 	old = pte_update(mm, addr, ptep, _PAGE_ACCESSED, 0, 0);
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~mm-change-to-return-bool-for-ptep_test_and_clear_young
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -349,13 +349,13 @@ static inline unsigned long pte_update(s
  * For radix: H_PAGE_HASHPTE should be zero. Hence we can use the same
  * function for both hash and radix.
  */
-static inline int __ptep_test_and_clear_young(struct mm_struct *mm,
-					      unsigned long addr, pte_t *ptep)
+static inline bool __ptep_test_and_clear_young(struct mm_struct *mm,
+		unsigned long addr, pte_t *ptep)
 {
 	unsigned long old;
 
 	if ((pte_raw(*ptep) & cpu_to_be64(_PAGE_ACCESSED | H_PAGE_HASHPTE)) == 0)
-		return 0;
+		return false;
 	old = pte_update(mm, addr, ptep, _PAGE_ACCESSED, 0, 0);
 	return (old & _PAGE_ACCESSED) != 0;
 }
--- a/arch/powerpc/include/asm/nohash/pgtable.h~mm-change-to-return-bool-for-ptep_test_and_clear_young
+++ a/arch/powerpc/include/asm/nohash/pgtable.h
@@ -101,8 +101,8 @@ static inline pte_basic_t pte_update(str
 }
 #endif
 
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long addr, pte_t *ptep)
+static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
 {
 	unsigned long old;
 
--- a/arch/riscv/include/asm/pgtable.h~mm-change-to-return-bool-for-ptep_test_and_clear_young
+++ a/arch/riscv/include/asm/pgtable.h
@@ -659,8 +659,8 @@ static inline void pte_clear(struct mm_s
 extern int ptep_set_access_flags(struct vm_area_struct *vma, unsigned long address,
 				 pte_t *ptep, pte_t entry, int dirty);
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG	/* defined in mm/pgtable.c */
-extern int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long address,
-				     pte_t *ptep);
+bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pte_t *ptep);
 
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
--- a/arch/riscv/mm/pgtable.c~mm-change-to-return-bool-for-ptep_test_and_clear_young
+++ a/arch/riscv/mm/pgtable.c
@@ -29,12 +29,11 @@ int ptep_set_access_flags(struct vm_area
 	return true;
 }
 
-int ptep_test_and_clear_young(struct vm_area_struct *vma,
-			      unsigned long address,
-			      pte_t *ptep)
+bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pte_t *ptep)
 {
 	if (!pte_young(ptep_get(ptep)))
-		return 0;
+		return false;
 	return test_and_clear_bit(_PAGE_ACCESSED_OFFSET, &pte_val(*ptep));
 }
 EXPORT_SYMBOL_GPL(ptep_test_and_clear_young);
--- a/arch/s390/include/asm/pgtable.h~mm-change-to-return-bool-for-ptep_test_and_clear_young
+++ a/arch/s390/include/asm/pgtable.h
@@ -1164,8 +1164,8 @@ pte_t ptep_xchg_direct(struct mm_struct
 pte_t ptep_xchg_lazy(struct mm_struct *, unsigned long, pte_t *, pte_t);
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long addr, pte_t *ptep)
+static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
 {
 	pte_t pte = *ptep;
 
--- a/arch/x86/include/asm/pgtable.h~mm-change-to-return-bool-for-ptep_test_and_clear_young
+++ a/arch/x86/include/asm/pgtable.h
@@ -1232,8 +1232,8 @@ extern int ptep_set_access_flags(struct
 				 pte_t entry, int dirty);
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-extern int ptep_test_and_clear_young(struct vm_area_struct *vma,
-				     unsigned long addr, pte_t *ptep);
+bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep);
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
 extern int ptep_clear_flush_young(struct vm_area_struct *vma,
--- a/arch/x86/mm/pgtable.c~mm-change-to-return-bool-for-ptep_test_and_clear_young
+++ a/arch/x86/mm/pgtable.c
@@ -443,10 +443,10 @@ int pudp_set_access_flags(struct vm_area
 }
 #endif
 
-int ptep_test_and_clear_young(struct vm_area_struct *vma,
-			      unsigned long addr, pte_t *ptep)
+bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
 {
-	int ret = 0;
+	bool ret = false;
 
 	if (pte_young(*ptep))
 		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,
--- a/arch/xtensa/include/asm/pgtable.h~mm-change-to-return-bool-for-ptep_test_and_clear_young
+++ a/arch/xtensa/include/asm/pgtable.h
@@ -304,15 +304,14 @@ set_pmd(pmd_t *pmdp, pmd_t pmdval)
 
 struct vm_area_struct;
 
-static inline int
-ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr,
-			  pte_t *ptep)
+static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
 {
 	pte_t pte = *ptep;
 	if (!pte_young(pte))
-		return 0;
+		return false;
 	update_pte(ptep, pte_mkold(pte));
-	return 1;
+	return true;
 }
 
 static inline pte_t
--- a/include/linux/pgtable.h~mm-change-to-return-bool-for-ptep_test_and_clear_young
+++ a/include/linux/pgtable.h
@@ -491,17 +491,17 @@ static inline pgd_t pgdp_get(pgd_t *pgdp
 #endif
 
 #ifndef __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long address,
-					    pte_t *ptep)
+static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pte_t *ptep)
 {
 	pte_t pte = ptep_get(ptep);
-	int r = 1;
+	bool young = true;
+
 	if (!pte_young(pte))
-		r = 0;
+		young = false;
 	else
 		set_pte_at(vma->vm_mm, address, ptep, pte_mkold(pte));
-	return r;
+	return young;
 }
 #endif
 
@@ -1123,10 +1123,10 @@ static inline int clear_flush_young_ptes
  *
  * Returns: whether any PTE was young.
  */
-static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
+static inline bool test_and_clear_young_ptes(struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep, unsigned int nr)
 {
-	int young = 0;
+	bool young = false;
 
 	for (;;) {
 		young |= ptep_test_and_clear_young(vma, addr, ptep);
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

