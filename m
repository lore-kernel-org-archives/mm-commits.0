Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966A214AD0D
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 22:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766962261; cv=none; b=P/scB8VkDXU/VUzyEAlV0HsDgu7day2KRLfGN7fifqQ5GGc9xRT7pUuijgnqzAxwYH2TCyaZ/FUcXSFo2ppeOoCqB1xllmh9R3MBVuu1nnHEktnVPkAdFfzp5uYFzp9r5XFmgaMSn+tl8FqG0fICTMICAq7NJt72klJUMSKNGNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766962261; c=relaxed/simple;
	bh=QZlxr0UFGQYxAsjm5FVRBy3It+8YpqoKgcle9/jM+gc=;
	h=Date:To:From:Subject:Message-Id; b=VNkO24Jo2I0A24+b/IaxZ6thbywBQiUmD/AaCg6TGvy0mLlUIhI6o1ZAbt1Vwb5s5WFHiCXTrlnRx28nZkp/94gAfjHb+ZyYrSJ82CnKb42IOajrQQM+UikzVHuOaJLZgkpCcGS7mX+UTbbSHrLp4N0856CpN851t3T45Jl98vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1a/GP1/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1a/GP1/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC31C4CEFB;
	Sun, 28 Dec 2025 22:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766962261;
	bh=QZlxr0UFGQYxAsjm5FVRBy3It+8YpqoKgcle9/jM+gc=;
	h=Date:To:From:Subject:From;
	b=1a/GP1/D/60SR8BBz8E1rmwN/WsZvcKkT+5tdIoWTYBWt5l8qHU5tBv/VBHv6WXv8
	 v7eEKvqzvaLZnwL+641WAAtjeOdjAfN2dyRQW1iKxAtpFKtvoJv/N6V2fdLKTlZY5F
	 fvDDmO+Lo22wdmQB2gYjMa265wTeIAq76V9M5nc0=
Date: Sun, 28 Dec 2025 14:51:00 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-use-enum-scan_result-for-result-variables-and-return-types.patch added to mm-new branch
Message-Id: <20251228225101.5AC31C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: use enum scan_result for result variables and return types
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-use-enum-scan_result-for-result-variables-and-return-types.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-use-enum-scan_result-for-result-variables-and-return-types.patch

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
From: Shivank Garg <shivankg@amd.com>
Subject: mm/khugepaged: use enum scan_result for result variables and return types
Date: Wed, 24 Dec 2025 11:13:57 +0000

Convert result variables and return types from int to enum scan_result
throughout khugepaged code.  This improves type safety and code clarity by
making the intent explicit.

No functional change.

Link: https://lkml.kernel.org/r/20251224111351.41042-12-shivankg@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |  111 +++++++++++++++++++++++-----------------------
 1 file changed, 57 insertions(+), 54 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-use-enum-scan_result-for-result-variables-and-return-types
+++ a/mm/khugepaged.c
@@ -537,17 +537,18 @@ static void release_pte_pages(pte_t *pte
 	}
 }
 
-static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
-					unsigned long start_addr,
-					pte_t *pte,
-					struct collapse_control *cc,
-					struct list_head *compound_pagelist)
+static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
+						     unsigned long start_addr,
+						     pte_t *pte,
+						     struct collapse_control *cc,
+						     struct list_head *compound_pagelist)
 {
 	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long addr = start_addr;
 	pte_t *_pte;
-	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
+	int none_or_zero = 0, shared = 0, referenced = 0;
+	enum scan_result result = SCAN_FAIL;
 
 	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
@@ -780,13 +781,13 @@ static void __collapse_huge_page_copy_fa
  * @ptl: lock on raw pages' PTEs
  * @compound_pagelist: list that stores compound pages
  */
-static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
+static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
 		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
 		unsigned long address, spinlock_t *ptl,
 		struct list_head *compound_pagelist)
 {
 	unsigned int i;
-	int result = SCAN_SUCCEED;
+	enum scan_result result = SCAN_SUCCEED;
 
 	/*
 	 * Copying pages' contents is subject to memory poison at any iteration.
@@ -898,10 +899,9 @@ static int hpage_collapse_find_target_no
  * Returns enum scan_result value.
  */
 
-static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
-				   bool expect_anon,
-				   struct vm_area_struct **vmap,
-				   struct collapse_control *cc)
+static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
+						bool expect_anon, struct vm_area_struct **vmap,
+						struct collapse_control *cc)
 {
 	struct vm_area_struct *vma;
 	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
@@ -930,7 +930,7 @@ static int hugepage_vma_revalidate(struc
 	return SCAN_SUCCEED;
 }
 
-static inline int check_pmd_state(pmd_t *pmd)
+static inline enum scan_result check_pmd_state(pmd_t *pmd)
 {
 	pmd_t pmde = pmdp_get_lockless(pmd);
 
@@ -953,9 +953,9 @@ static inline int check_pmd_state(pmd_t
 	return SCAN_SUCCEED;
 }
 
-static int find_pmd_or_thp_or_none(struct mm_struct *mm,
-				   unsigned long address,
-				   pmd_t **pmd)
+static enum scan_result find_pmd_or_thp_or_none(struct mm_struct *mm,
+						unsigned long address,
+						pmd_t **pmd)
 {
 	*pmd = mm_find_pmd(mm, address);
 	if (!*pmd)
@@ -964,12 +964,12 @@ static int find_pmd_or_thp_or_none(struc
 	return check_pmd_state(*pmd);
 }
 
-static int check_pmd_still_valid(struct mm_struct *mm,
-				 unsigned long address,
-				 pmd_t *pmd)
+static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
+					      unsigned long address,
+					      pmd_t *pmd)
 {
 	pmd_t *new_pmd;
-	int result = find_pmd_or_thp_or_none(mm, address, &new_pmd);
+	enum scan_result result = find_pmd_or_thp_or_none(mm, address, &new_pmd);
 
 	if (result != SCAN_SUCCEED)
 		return result;
@@ -985,15 +985,15 @@ static int check_pmd_still_valid(struct
  * Called and returns without pte mapped or spinlocks held.
  * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
  */
-static int __collapse_huge_page_swapin(struct mm_struct *mm,
-				       struct vm_area_struct *vma,
-				       unsigned long start_addr, pmd_t *pmd,
-				       int referenced)
+static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
+						    struct vm_area_struct *vma,
+						    unsigned long start_addr, pmd_t *pmd,
+						    int referenced)
 {
 	int swapped_in = 0;
 	vm_fault_t ret = 0;
 	unsigned long addr, end = start_addr + (HPAGE_PMD_NR * PAGE_SIZE);
-	int result;
+	enum scan_result result;
 	pte_t *pte = NULL;
 	spinlock_t *ptl;
 
@@ -1062,8 +1062,8 @@ out:
 	return result;
 }
 
-static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
-			      struct collapse_control *cc)
+static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
+					   struct collapse_control *cc)
 {
 	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
 		     GFP_TRANSHUGE);
@@ -1090,9 +1090,9 @@ static int alloc_charge_folio(struct fol
 	return SCAN_SUCCEED;
 }
 
-static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
-			      int referenced, int unmapped,
-			      struct collapse_control *cc)
+static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
+					   int referenced, int unmapped,
+					   struct collapse_control *cc)
 {
 	LIST_HEAD(compound_pagelist);
 	pmd_t *pmd, _pmd;
@@ -1100,7 +1100,7 @@ static int collapse_huge_page(struct mm_
 	pgtable_t pgtable;
 	struct folio *folio;
 	spinlock_t *pmd_ptl, *pte_ptl;
-	int result = SCAN_FAIL;
+	enum scan_result result = SCAN_FAIL;
 	struct vm_area_struct *vma;
 	struct mmu_notifier_range range;
 
@@ -1246,15 +1246,15 @@ out_nolock:
 	return result;
 }
 
-static int hpage_collapse_scan_pmd(struct mm_struct *mm,
-				   struct vm_area_struct *vma,
-				   unsigned long start_addr, bool *mmap_locked,
-				   struct collapse_control *cc)
+static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
+						struct vm_area_struct *vma,
+						unsigned long start_addr, bool *mmap_locked,
+						struct collapse_control *cc)
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
-	int result = SCAN_FAIL, referenced = 0;
-	int none_or_zero = 0, shared = 0;
+	int none_or_zero = 0, shared = 0, referenced = 0;
+	enum scan_result result = SCAN_FAIL;
 	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long addr;
@@ -1441,8 +1441,8 @@ static void collect_mm_slot(struct mm_sl
 }
 
 /* folio must be locked, and mmap_lock must be held */
-static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
-			pmd_t *pmdp, struct folio *folio, struct page *page)
+static enum scan_result set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
+				     pmd_t *pmdp, struct folio *folio, struct page *page)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_fault vmf = {
@@ -1477,10 +1477,11 @@ static int set_huge_pmd(struct vm_area_s
 	return SCAN_SUCCEED;
 }
 
-static int try_collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
-				       bool install_pmd)
+static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
+						    bool install_pmd)
 {
-	int nr_mapped_ptes = 0, result = SCAN_FAIL;
+	enum scan_result result = SCAN_FAIL;
+	int nr_mapped_ptes = 0;
 	unsigned int nr_batch_ptes;
 	struct mmu_notifier_range range;
 	bool notified = false;
@@ -1862,9 +1863,9 @@ drop_pml:
  *    + unlock old pages
  *    + unlock and free huge page;
  */
-static int collapse_file(struct mm_struct *mm, unsigned long addr,
-			 struct file *file, pgoff_t start,
-			 struct collapse_control *cc)
+static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
+				      struct file *file, pgoff_t start,
+				      struct collapse_control *cc)
 {
 	struct address_space *mapping = file->f_mapping;
 	struct page *dst;
@@ -1872,7 +1873,8 @@ static int collapse_file(struct mm_struc
 	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
-	int nr_none = 0, result = SCAN_SUCCEED;
+	enum scan_result result = SCAN_SUCCEED;
+	int nr_none = 0;
 	bool is_shmem = shmem_file(file);
 
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
@@ -2293,16 +2295,16 @@ out:
 	return result;
 }
 
-static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
-				    struct file *file, pgoff_t start,
-				    struct collapse_control *cc)
+static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
+						 struct file *file, pgoff_t start,
+						 struct collapse_control *cc)
 {
 	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
 	XA_STATE(xas, &mapping->i_pages, start);
 	int present, swap;
 	int node = NUMA_NO_NODE;
-	int result = SCAN_SUCCEED;
+	enum scan_result result = SCAN_SUCCEED;
 
 	present = 0;
 	swap = 0;
@@ -2400,7 +2402,7 @@ static int hpage_collapse_scan_file(stru
 	return result;
 }
 
-static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
+static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result *result,
 					    struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
 	__acquires(&khugepaged_mm_lock)
@@ -2562,7 +2564,7 @@ static void khugepaged_do_scan(struct co
 	unsigned int progress = 0, pass_through_head = 0;
 	unsigned int pages = READ_ONCE(khugepaged_pages_to_scan);
 	bool wait = true;
-	int result = SCAN_SUCCEED;
+	enum scan_result result = SCAN_SUCCEED;
 
 	lru_add_drain_all();
 
@@ -2775,7 +2777,8 @@ int madvise_collapse(struct vm_area_stru
 	struct collapse_control *cc;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long hstart, hend, addr;
-	int thps = 0, last_fail = SCAN_FAIL;
+	enum scan_result last_fail = SCAN_FAIL;
+	int thps = 0;
 	bool mmap_locked = true;
 
 	BUG_ON(vma->vm_start > start);
@@ -2797,7 +2800,7 @@ int madvise_collapse(struct vm_area_stru
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		bool retried = false;
-		int result = SCAN_FAIL;
+		enum scan_result result = SCAN_FAIL;
 
 		if (!mmap_locked) {
 retry:
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-khugepaged-map-dirty-writeback-pages-failures-to-eagain.patch
mm-khugepaged-retry-with-sync-writeback-for-madv_collapse.patch
mm-khugepaged-remove-unnecessary-goto-skip-label.patch
mm-khugepaged-count-small-vmas-towards-scan-limit.patch
mm-khugepaged-count-small-vmas-towards-scan-limit-fix.patch
mm-khugepaged-change-collapse_pte_mapped_thp-to-return-void.patch
mm-khugepaged-use-enum-scan_result-for-result-variables-and-return-types.patch
mm-khugepaged-make-khugepaged_collapse_control-static.patch

