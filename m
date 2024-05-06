Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F62383A1
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957124; cv=none; b=qivA+SpYk7tK5b/+ZKh82cyJAjfwbX0nRbrIDkTQCfYcPtw3N2i1iw2BVODIimIzzS3i+XX+Al76AkVrvhWbVLqxt7+kqhqZQ6Btp82pYWhwEqqUhhjCpCB1tQ7cZFBVWdU6iir3LchAyQh6SFbKc7DpyUKCOPf/chgWmYc4+lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957124; c=relaxed/simple;
	bh=p1dNDxTWkiugffzcIBRVbRZjRBTSs3O+LM2/SJwzDEM=;
	h=Date:To:From:Subject:Message-Id; b=eH7EPiZEFZBmnY4D28oqOGbUvn6HYk+YaYZwAAalxBbeaLYtknJJmm5nBqGu3qSfWmZmQ61iReem5pkWVPgp7RFBv+veCGTWdAI5T5cYrzz7rmILUYefB2slEJJzpygJmrNYwxA4VAvZCWfCWT0yqRovzERWAs/kGdB2GEPkys4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NeesyhTi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NeesyhTi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5357FC113CC;
	Mon,  6 May 2024 00:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957124;
	bh=p1dNDxTWkiugffzcIBRVbRZjRBTSs3O+LM2/SJwzDEM=;
	h=Date:To:From:Subject:From;
	b=NeesyhTi9CtVLhEzFA1Oeb8/Ox7jg9+sbIpk7vQEbPO3tTmUx4TImDx6pC53dfX27
	 59I5Iyf8g9YpgPQHgSJ2TCgILjkjflstMsUssWCiqOCi2Hf1o3ABaQgfjs4/B7jr6L
	 afQDeoZ2Ju6fE1EmVkK4c28ICr//iFCzaTUKCrZo=
Date: Sun, 05 May 2024 17:58:43 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-simplify-thp_vma_allowable_order.patch removed from -mm tree
Message-Id: <20240506005844.5357FC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: simplify thp_vma_allowable_order
has been removed from the -mm tree.  Its filename was
     mm-simplify-thp_vma_allowable_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mm: simplify thp_vma_allowable_order
Date: Thu, 25 Apr 2024 05:00:55 +0100

Combine the three boolean arguments into one flags argument for
readability.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c      |    4 ++--
 include/linux/huge_mm.h |   29 +++++++++++++++--------------
 mm/huge_memory.c        |    7 +++++--
 mm/khugepaged.c         |   16 +++++++---------
 mm/memory.c             |   10 ++++++----
 5 files changed, 35 insertions(+), 31 deletions(-)

--- a/fs/proc/task_mmu.c~mm-simplify-thp_vma_allowable_order
+++ a/fs/proc/task_mmu.c
@@ -871,8 +871,8 @@ static int show_smap(struct seq_file *m,
 	__show_smap(m, &mss, false);
 
 	seq_printf(m, "THPeligible:    %8u\n",
-		   !!thp_vma_allowable_orders(vma, vma->vm_flags, true, false,
-					      true, THP_ORDERS_ALL));
+		   !!thp_vma_allowable_orders(vma, vma->vm_flags,
+			   TVA_SMAPS | TVA_ENFORCE_SYSFS, THP_ORDERS_ALL));
 
 	if (arch_pkeys_enabled())
 		seq_printf(m, "ProtectionKey:  %8u\n", vma_pkey(vma));
--- a/include/linux/huge_mm.h~mm-simplify-thp_vma_allowable_order
+++ a/include/linux/huge_mm.h
@@ -81,8 +81,12 @@ extern struct kobj_attribute shmem_enabl
  */
 #define THP_ORDERS_ALL		(THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE)
 
-#define thp_vma_allowable_order(vma, vm_flags, smaps, in_pf, enforce_sysfs, order) \
-	(!!thp_vma_allowable_orders(vma, vm_flags, smaps, in_pf, enforce_sysfs, BIT(order)))
+#define TVA_SMAPS		(1 << 0)	/* Will be used for procfs */
+#define TVA_IN_PF		(1 << 1)	/* Page fault handler */
+#define TVA_ENFORCE_SYSFS	(1 << 2)	/* Obey sysfs configuration */
+
+#define thp_vma_allowable_order(vma, vm_flags, tva_flags, order) \
+	(!!thp_vma_allowable_orders(vma, vm_flags, tva_flags, BIT(order)))
 
 #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
 #define HPAGE_PMD_SHIFT PMD_SHIFT
@@ -218,17 +222,15 @@ static inline bool file_thp_enabled(stru
 }
 
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
-					 unsigned long vm_flags, bool smaps,
-					 bool in_pf, bool enforce_sysfs,
+					 unsigned long vm_flags,
+					 unsigned long tva_flags,
 					 unsigned long orders);
 
 /**
  * thp_vma_allowable_orders - determine hugepage orders that are allowed for vma
  * @vma:  the vm area to check
  * @vm_flags: use these vm_flags instead of vma->vm_flags
- * @smaps: whether answer will be used for smaps file
- * @in_pf: whether answer will be used by page fault handler
- * @enforce_sysfs: whether sysfs config should be taken into account
+ * @tva_flags: Which TVA flags to honour
  * @orders: bitfield of all orders to consider
  *
  * Calculates the intersection of the requested hugepage orders and the allowed
@@ -241,12 +243,12 @@ unsigned long __thp_vma_allowable_orders
  */
 static inline
 unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
-				       unsigned long vm_flags, bool smaps,
-				       bool in_pf, bool enforce_sysfs,
+				       unsigned long vm_flags,
+				       unsigned long tva_flags,
 				       unsigned long orders)
 {
 	/* Optimization to check if required orders are enabled early. */
-	if (enforce_sysfs && vma_is_anonymous(vma)) {
+	if ((tva_flags & TVA_ENFORCE_SYSFS) && vma_is_anonymous(vma)) {
 		unsigned long mask = READ_ONCE(huge_anon_orders_always);
 
 		if (vm_flags & VM_HUGEPAGE)
@@ -260,8 +262,7 @@ unsigned long thp_vma_allowable_orders(s
 			return 0;
 	}
 
-	return __thp_vma_allowable_orders(vma, vm_flags, smaps, in_pf,
-					  enforce_sysfs, orders);
+	return __thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
 }
 
 enum mthp_stat_item {
@@ -428,8 +429,8 @@ static inline unsigned long thp_vma_suit
 }
 
 static inline unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
-					unsigned long vm_flags, bool smaps,
-					bool in_pf, bool enforce_sysfs,
+					unsigned long vm_flags,
+					unsigned long tva_flags,
 					unsigned long orders)
 {
 	return 0;
--- a/mm/huge_memory.c~mm-simplify-thp_vma_allowable_order
+++ a/mm/huge_memory.c
@@ -81,10 +81,13 @@ unsigned long huge_anon_orders_madvise _
 unsigned long huge_anon_orders_inherit __read_mostly;
 
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
-					 unsigned long vm_flags, bool smaps,
-					 bool in_pf, bool enforce_sysfs,
+					 unsigned long vm_flags,
+					 unsigned long tva_flags,
 					 unsigned long orders)
 {
+	bool smaps = tva_flags & TVA_SMAPS;
+	bool in_pf = tva_flags & TVA_IN_PF;
+	bool enforce_sysfs = tva_flags & TVA_ENFORCE_SYSFS;
 	/* Check the intersection of requested and supported orders. */
 	orders &= vma_is_anonymous(vma) ?
 			THP_ORDERS_ALL_ANON : THP_ORDERS_ALL_FILE;
--- a/mm/khugepaged.c~mm-simplify-thp_vma_allowable_order
+++ a/mm/khugepaged.c
@@ -453,7 +453,7 @@ void khugepaged_enter_vma(struct vm_area
 {
 	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags) &&
 	    hugepage_flags_enabled()) {
-		if (thp_vma_allowable_order(vma, vm_flags, false, false, true,
+		if (thp_vma_allowable_order(vma, vm_flags, TVA_ENFORCE_SYSFS,
 					    PMD_ORDER))
 			__khugepaged_enter(vma->vm_mm);
 	}
@@ -900,6 +900,7 @@ static int hugepage_vma_revalidate(struc
 				   struct collapse_control *cc)
 {
 	struct vm_area_struct *vma;
+	unsigned long tva_flags = cc->is_khugepaged ? TVA_ENFORCE_SYSFS : 0;
 
 	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
 		return SCAN_ANY_PROCESS;
@@ -910,8 +911,7 @@ static int hugepage_vma_revalidate(struc
 
 	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
 		return SCAN_ADDRESS_RANGE;
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, false, false,
-				     cc->is_khugepaged, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, tva_flags, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
@@ -1501,8 +1501,7 @@ int collapse_pte_mapped_thp(struct mm_st
 	 * and map it by a PMD, regardless of sysfs THP settings. As such, let's
 	 * analogously elide sysfs THP settings here.
 	 */
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, false, false, false,
-				     PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, 0, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 
 	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
@@ -2363,8 +2362,8 @@ static unsigned int khugepaged_scan_mm_s
 			progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags, false, false,
-					     true, PMD_ORDER)) {
+		if (!thp_vma_allowable_order(vma, vma->vm_flags,
+					TVA_ENFORCE_SYSFS, PMD_ORDER)) {
 skip:
 			progress++;
 			continue;
@@ -2701,8 +2700,7 @@ int madvise_collapse(struct vm_area_stru
 
 	*prev = vma;
 
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, false, false, false,
-				     PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, 0, PMD_ORDER))
 		return -EINVAL;
 
 	cc = kmalloc(sizeof(*cc), GFP_KERNEL);
--- a/mm/memory.c~mm-simplify-thp_vma_allowable_order
+++ a/mm/memory.c
@@ -4334,8 +4334,8 @@ static struct folio *alloc_anon_folio(st
 	 * for this vma. Then filter out the orders that can't be allocated over
 	 * the faulting address and still be fully contained in the vma.
 	 */
-	orders = thp_vma_allowable_orders(vma, vma->vm_flags, false, true, true,
-					  BIT(PMD_ORDER) - 1);
+	orders = thp_vma_allowable_orders(vma, vma->vm_flags,
+			TVA_IN_PF | TVA_ENFORCE_SYSFS, BIT(PMD_ORDER) - 1);
 	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 
 	if (!orders)
@@ -5438,7 +5438,8 @@ static vm_fault_t __handle_mm_fault(stru
 		return VM_FAULT_OOM;
 retry_pud:
 	if (pud_none(*vmf.pud) &&
-	    thp_vma_allowable_order(vma, vm_flags, false, true, true, PUD_ORDER)) {
+	    thp_vma_allowable_order(vma, vm_flags,
+				TVA_IN_PF | TVA_ENFORCE_SYSFS, PUD_ORDER)) {
 		ret = create_huge_pud(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
@@ -5472,7 +5473,8 @@ retry_pud:
 		goto retry_pud;
 
 	if (pmd_none(*vmf.pmd) &&
-	    thp_vma_allowable_order(vma, vm_flags, false, true, true, PMD_ORDER)) {
+	    thp_vma_allowable_order(vma, vm_flags,
+				TVA_IN_PF | TVA_ENFORCE_SYSFS, PMD_ORDER)) {
 		ret = create_huge_pmd(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

