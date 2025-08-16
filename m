Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D7D20F067
	for <mm-commits@vger.kernel.org>; Sat, 16 Aug 2025 06:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755325268; cv=none; b=fCLCWB05yVcUmuvGhCre2N1v+zt51xgAHowOTRYSMQQvIe4dRd9cD7guyMuqoeBplBC5x1F1z/5U4TxUWPcQqMJeciljVrdCVZuy49nvz5aUQ15Xo4ZSnzegM3n5SRYOBytHnS5lGr0wZa238RiTCSHe8fsktntbFJR9KNUwKmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755325268; c=relaxed/simple;
	bh=accWRNAzSE6vQEAyAsIY6fIzI2Ok5vy29HufxXMGjYw=;
	h=Date:To:From:Subject:Message-Id; b=pKSlyIkz2YfDkQ/ixWCDNoVBeLOpp/cHeZHs7IFYkXwwddXVb8DbQAG+jrOL+bRJxBiv87HzSlPPlHW5B3dyOJrPlLZ9XCsFwnRakT+GFqbmErt93EeGvr3KLJ827PAPp6YdioyEIfD6Fp3qn3Dy9QC//o8FFMQB2S0VTA3iQWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M0XluywT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M0XluywT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24D7C4CEEF;
	Sat, 16 Aug 2025 06:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755325268;
	bh=accWRNAzSE6vQEAyAsIY6fIzI2Ok5vy29HufxXMGjYw=;
	h=Date:To:From:Subject:From;
	b=M0XluywTwfumHtAEOVr3Tv1wiS3/6d0FT5oiHrLjU9g4oqXWxuwepvbKLag4pTq20
	 QA4r66HFZlqtMSJNzVdM7yqxCrdRXFpfxs6yp9dUyasDLBFKR8cP2zJXmFKf5e0hG/
	 AuGEFsBdBHsYfmADO0BAa97cx411pjQ8MHmReFtA=
Date: Fri, 15 Aug 2025 23:21:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,usamaarif642@gmail.com,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,laoar.shao@gmail.com,jannh@google.com,hannes@cmpxchg.org,dev.jain@arm.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,arnd@arndb.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-convert-tva_flags-to-enum-tva_type.patch added to mm-new branch
Message-Id: <20250816062107.F24D7C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: convert "tva_flags" to "enum tva_type"
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-convert-tva_flags-to-enum-tva_type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-convert-tva_flags-to-enum-tva_type.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: convert "tva_flags" to "enum tva_type"
Date: Fri, 15 Aug 2025 14:54:54 +0100

When determining which THP orders are eligible for a VMA mapping, we have
previously specified tva_flags, however it turns out it is really not
necessary to treat these as flags.

Rather, we distinguish between distinct modes.

The only case where we previously combined flags was with
TVA_ENFORCE_SYSFS, but we can avoid this by observing that this is the
default, except for MADV_COLLAPSE or an edge cases in
collapse_pte_mapped_thp() and hugepage_vma_revalidate(), and adding a mode
specifically for this case - TVA_FORCED_COLLAPSE.

We have:
* smaps handling for showing "THPeligible"
* Pagefault handling
* khugepaged handling
* Forced collapse handling: primarily MADV_COLLAPSE, but also for
  an edge case in collapse_pte_mapped_thp()

Disregarding the edge cases, we only want to ignore sysfs settings only
when we are forcing a collapse through MADV_COLLAPSE, otherwise we want to
enforce it, hence this patch does the following flag to enum conversions:

* TVA_SMAPS | TVA_ENFORCE_SYSFS -> TVA_SMAPS
* TVA_IN_PF | TVA_ENFORCE_SYSFS -> TVA_PAGEFAULT
* TVA_ENFORCE_SYSFS             -> TVA_KHUGEPAGED
* 0                             -> TVA_FORCED_COLLAPSE

With this change, we immediately know if we are in the forced collapse
case, which will be valuable next.

Link: https://lkml.kernel.org/r/20250815135549.130506-3-usamaarif642@gmail.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yafang <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c      |    4 ++--
 include/linux/huge_mm.h |   30 ++++++++++++++++++------------
 mm/huge_memory.c        |    8 ++++----
 mm/khugepaged.c         |   17 ++++++++---------
 mm/memory.c             |   14 ++++++--------
 5 files changed, 38 insertions(+), 35 deletions(-)

--- a/fs/proc/task_mmu.c~mm-huge_memory-convert-tva_flags-to-enum-tva_type
+++ a/fs/proc/task_mmu.c
@@ -1369,8 +1369,8 @@ static int show_smap(struct seq_file *m,
 	__show_smap(m, &mss, false);
 
 	seq_printf(m, "THPeligible:    %8u\n",
-		   !!thp_vma_allowable_orders(vma, vma->vm_flags,
-			   TVA_SMAPS | TVA_ENFORCE_SYSFS, THP_ORDERS_ALL));
+		   !!thp_vma_allowable_orders(vma, vma->vm_flags, TVA_SMAPS,
+					      THP_ORDERS_ALL));
 
 	if (arch_pkeys_enabled())
 		seq_printf(m, "ProtectionKey:  %8u\n", vma_pkey(vma));
--- a/include/linux/huge_mm.h~mm-huge_memory-convert-tva_flags-to-enum-tva_type
+++ a/include/linux/huge_mm.h
@@ -94,12 +94,15 @@ extern struct kobj_attribute thpsize_shm
 #define THP_ORDERS_ALL	\
 	(THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_SPECIAL | THP_ORDERS_ALL_FILE_DEFAULT)
 
-#define TVA_SMAPS		(1 << 0)	/* Will be used for procfs */
-#define TVA_IN_PF		(1 << 1)	/* Page fault handler */
-#define TVA_ENFORCE_SYSFS	(1 << 2)	/* Obey sysfs configuration */
+enum tva_type {
+	TVA_SMAPS,		/* Exposing "THPeligible:" in smaps. */
+	TVA_PAGEFAULT,		/* Serving a page fault. */
+	TVA_KHUGEPAGED,		/* Khugepaged collapse. */
+	TVA_FORCED_COLLAPSE,	/* Forced collapse (e.g. MADV_COLLAPSE). */
+};
 
-#define thp_vma_allowable_order(vma, vm_flags, tva_flags, order) \
-	(!!thp_vma_allowable_orders(vma, vm_flags, tva_flags, BIT(order)))
+#define thp_vma_allowable_order(vma, vm_flags, type, order) \
+	(!!thp_vma_allowable_orders(vma, vm_flags, type, BIT(order)))
 
 #define split_folio(f) split_folio_to_list(f, NULL)
 
@@ -264,14 +267,14 @@ static inline unsigned long thp_vma_suit
 
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 vm_flags_t vm_flags,
-					 unsigned long tva_flags,
+					 enum tva_type type,
 					 unsigned long orders);
 
 /**
  * thp_vma_allowable_orders - determine hugepage orders that are allowed for vma
  * @vma:  the vm area to check
  * @vm_flags: use these vm_flags instead of vma->vm_flags
- * @tva_flags: Which TVA flags to honour
+ * @type: TVA type
  * @orders: bitfield of all orders to consider
  *
  * Calculates the intersection of the requested hugepage orders and the allowed
@@ -285,11 +288,14 @@ unsigned long __thp_vma_allowable_orders
 static inline
 unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 				       vm_flags_t vm_flags,
-				       unsigned long tva_flags,
+				       enum tva_type type,
 				       unsigned long orders)
 {
-	/* Optimization to check if required orders are enabled early. */
-	if ((tva_flags & TVA_ENFORCE_SYSFS) && vma_is_anonymous(vma)) {
+	/*
+	 * Optimization to check if required orders are enabled early. Only
+	 * forced collapse ignores sysfs configs.
+	 */
+	if (type != TVA_FORCED_COLLAPSE && vma_is_anonymous(vma)) {
 		unsigned long mask = READ_ONCE(huge_anon_orders_always);
 
 		if (vm_flags & VM_HUGEPAGE)
@@ -303,7 +309,7 @@ unsigned long thp_vma_allowable_orders(s
 			return 0;
 	}
 
-	return __thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
+	return __thp_vma_allowable_orders(vma, vm_flags, type, orders);
 }
 
 struct thpsize {
@@ -547,7 +553,7 @@ static inline unsigned long thp_vma_suit
 
 static inline unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 					vm_flags_t vm_flags,
-					unsigned long tva_flags,
+					enum tva_type type,
 					unsigned long orders)
 {
 	return 0;
--- a/mm/huge_memory.c~mm-huge_memory-convert-tva_flags-to-enum-tva_type
+++ a/mm/huge_memory.c
@@ -99,12 +99,12 @@ static inline bool file_thp_enabled(stru
 
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 vm_flags_t vm_flags,
-					 unsigned long tva_flags,
+					 enum tva_type type,
 					 unsigned long orders)
 {
-	bool smaps = tva_flags & TVA_SMAPS;
-	bool in_pf = tva_flags & TVA_IN_PF;
-	bool enforce_sysfs = tva_flags & TVA_ENFORCE_SYSFS;
+	const bool smaps = type == TVA_SMAPS;
+	const bool in_pf = type == TVA_PAGEFAULT;
+	const bool enforce_sysfs = type != TVA_FORCED_COLLAPSE;
 	unsigned long supported_orders;
 
 	/* Check the intersection of requested and supported orders. */
--- a/mm/khugepaged.c~mm-huge_memory-convert-tva_flags-to-enum-tva_type
+++ a/mm/khugepaged.c
@@ -474,8 +474,7 @@ void khugepaged_enter_vma(struct vm_area
 {
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
 	    hugepage_pmd_enabled()) {
-		if (thp_vma_allowable_order(vma, vm_flags, TVA_ENFORCE_SYSFS,
-					    PMD_ORDER))
+		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
 			__khugepaged_enter(vma->vm_mm);
 	}
 }
@@ -921,7 +920,8 @@ static int hugepage_vma_revalidate(struc
 				   struct collapse_control *cc)
 {
 	struct vm_area_struct *vma;
-	unsigned long tva_flags = cc->is_khugepaged ? TVA_ENFORCE_SYSFS : 0;
+	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
+				 TVA_FORCED_COLLAPSE;
 
 	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
 		return SCAN_ANY_PROCESS;
@@ -932,7 +932,7 @@ static int hugepage_vma_revalidate(struc
 
 	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
 		return SCAN_ADDRESS_RANGE;
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, tva_flags, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
@@ -1533,9 +1533,9 @@ int collapse_pte_mapped_thp(struct mm_st
 	 * in the page cache with a single hugepage. If a mm were to fault-in
 	 * this memory (mapped by a suitably aligned VMA), we'd get the hugepage
 	 * and map it by a PMD, regardless of sysfs THP settings. As such, let's
-	 * analogously elide sysfs THP settings here.
+	 * analogously elide sysfs THP settings here and force collapse.
 	 */
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, 0, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 
 	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
@@ -2432,8 +2432,7 @@ static unsigned int khugepaged_scan_mm_s
 			progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags,
-					TVA_ENFORCE_SYSFS, PMD_ORDER)) {
+		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
 skip:
 			progress++;
 			continue;
@@ -2767,7 +2766,7 @@ int madvise_collapse(struct vm_area_stru
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, 0, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return -EINVAL;
 
 	cc = kmalloc(sizeof(*cc), GFP_KERNEL);
--- a/mm/memory.c~mm-huge_memory-convert-tva_flags-to-enum-tva_type
+++ a/mm/memory.c
@@ -4515,8 +4515,8 @@ static struct folio *alloc_swap_folio(st
 	 * Get a list of all the (large) orders below PMD_ORDER that are enabled
 	 * and suitable for swapping THP.
 	 */
-	orders = thp_vma_allowable_orders(vma, vma->vm_flags,
-			TVA_IN_PF | TVA_ENFORCE_SYSFS, BIT(PMD_ORDER) - 1);
+	orders = thp_vma_allowable_orders(vma, vma->vm_flags, TVA_PAGEFAULT,
+					  BIT(PMD_ORDER) - 1);
 	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 	orders = thp_swap_suitable_orders(swp_offset(entry),
 					  vmf->address, orders);
@@ -5063,8 +5063,8 @@ static struct folio *alloc_anon_folio(st
 	 * for this vma. Then filter out the orders that can't be allocated over
 	 * the faulting address and still be fully contained in the vma.
 	 */
-	orders = thp_vma_allowable_orders(vma, vma->vm_flags,
-			TVA_IN_PF | TVA_ENFORCE_SYSFS, BIT(PMD_ORDER) - 1);
+	orders = thp_vma_allowable_orders(vma, vma->vm_flags, TVA_PAGEFAULT,
+					  BIT(PMD_ORDER) - 1);
 	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 
 	if (!orders)
@@ -6254,8 +6254,7 @@ static vm_fault_t __handle_mm_fault(stru
 		return VM_FAULT_OOM;
 retry_pud:
 	if (pud_none(*vmf.pud) &&
-	    thp_vma_allowable_order(vma, vm_flags,
-				TVA_IN_PF | TVA_ENFORCE_SYSFS, PUD_ORDER)) {
+	    thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PUD_ORDER)) {
 		ret = create_huge_pud(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
@@ -6289,8 +6288,7 @@ retry_pud:
 		goto retry_pud;
 
 	if (pmd_none(*vmf.pmd) &&
-	    thp_vma_allowable_order(vma, vm_flags,
-				TVA_IN_PF | TVA_ENFORCE_SYSFS, PMD_ORDER)) {
+	    thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PMD_ORDER)) {
 		ret = create_huge_pmd(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
_

Patches currently in -mm which might be from david@redhat.com are

mm-migrate-remove-migratepage_unmap.patch
treewide-remove-migratepage_success.patch
mm-huge_memory-move-more-common-code-into-insert_pmd.patch
mm-huge_memory-move-more-common-code-into-insert_pud.patch
mm-huge_memory-support-huge-zero-folio-in-vmf_insert_folio_pmd.patch
fs-dax-use-vmf_insert_folio_pmd-to-insert-the-huge-zero-folio.patch
mm-huge_memory-mark-pmd-mappings-of-the-huge-zero-folio-special.patch
powerpc-ptdump-rename-struct-pgtable_level-to-struct-ptdump_pglevel.patch
mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level.patch
mm-memory-convert-print_bad_pte-to-print_bad_page_map.patch
mm-memory-factor-out-common-code-from-vm_normal_page_.patch
mm-introduce-and-use-vm_normal_page_pud.patch
mm-rename-vm_ops-find_special_page-to-vm_ops-find_normal_page.patch
prctl-extend-pr_set_thp_disable-to-optionally-exclude-vm_hugepage.patch
mm-huge_memory-convert-tva_flags-to-enum-tva_type.patch
mm-huge_memory-respect-madv_collapse-with-pr_thp_disable_except_advised.patch

