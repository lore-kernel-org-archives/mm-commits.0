Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D45152E19
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 20:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714077812; cv=none; b=FxR9WSyogy8kVCFSdyWMXqRXthEKuZU9wuPHKlicKW0iAqNtPJfXsPK3NXfpXk3rL4/lUSZsDJekBPmQUHuuo/79K78Dye2z9vZ+bT1h/kZUHf1blxpm3sfUSSu4YUcNG8Vldxk0/ozD4ArP+rnUMGqLbMeeC4g8PXis+d2hUCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714077812; c=relaxed/simple;
	bh=6Oi1U84uAJoIncDVjcDzdKfgHUi0XxYbXJhu5OAycJA=;
	h=Date:To:From:Subject:Message-Id; b=jeUcSnleR8uRnfTTDi6wOTIrHRnwGfzusJo+FNhozm2VxzEKnS5OGs4Zbv8XqniHYFYFduiP3NJQ+O+c62iQGegoskyo5neMB+2rhNQsRJaUc+VhZcUnEfYZ5kuAeGH4m1RH6K5VNtse4yqMn9EYBgo9iISsb173rFQTVrugBRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UYMhe+pL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UYMhe+pL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FE7C113CE;
	Thu, 25 Apr 2024 20:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714077811;
	bh=6Oi1U84uAJoIncDVjcDzdKfgHUi0XxYbXJhu5OAycJA=;
	h=Date:To:From:Subject:From;
	b=UYMhe+pLRnPWMmNDtwj0YCCACfVJLuDECNmNdVOxdL5i/J+HSHVHfTHNmBxExv2/K
	 Ne3qq/U58YvZuDzaC6einu3kQa6lG95obJhfKmo1FPMSnlx0Br2kri0r8Uk5OrCEgr
	 cKloFLh7KAPioEnOMwFBusmp1M1oc1wueIjKu2hU=
Date: Thu, 25 Apr 2024 13:43:31 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-simplify-thp_vma_allowable_order.patch added to mm-unstable branch
Message-Id: <20240425204331.A8FE7C113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: simplify thp_vma_allowable_order
has been added to the -mm mm-unstable branch.  Its filename is
     mm-simplify-thp_vma_allowable_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-simplify-thp_vma_allowable_order.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-always-initialise-folio-_deferred_list.patch
mm-remove-folio_prep_large_rmappable.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-free-up-pg_slab-fix.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch
sh-remove-use-of-pg_arch_1-on-individual-pages.patch
xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch
mm-make-page_ext_get-take-a-const-argument.patch
mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch
mm-make-is_free_buddy_page-take-a-const-argument.patch
mm-make-page_mapped-take-a-const-argument.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio-fix.patch
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch
proc-rewrite-stable_page_flags-fix.patch
proc-rewrite-stable_page_flags-fix-2.patch
sparc-use-is_huge_zero_pmd.patch
mm-add-is_huge_zero_folio.patch
mm-add-pmd_folio.patch
mm-convert-migrate_vma_collect_pmd-to-use-a-folio.patch
mm-convert-huge_zero_page-to-huge_zero_folio.patch
mm-convert-do_huge_pmd_anonymous_page-to-huge_zero_folio.patch
dax-use-huge_zero_folio.patch
mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio.patch
mm-use-rwsem-assertion-macros-for-mmap_lock.patch
filemap-remove-__set_page_dirty.patch
mm-correct-page_mapped_in_vma-for-large-folios.patch
mm-remove-vma_address.patch
mm-rename-vma_pgoff_address-back-to-vma_address.patch
khugepaged-inline-hpage_collapse_alloc_folio.patch
khugepaged-convert-alloc_charge_hpage-to-alloc_charge_folio.patch
khugepaged-remove-hpage-from-collapse_huge_page.patch
khugepaged-pass-a-folio-to-__collapse_huge_page_copy.patch
khugepaged-remove-hpage-from-collapse_file.patch
khugepaged-use-a-folio-throughout-collapse_file.patch
khugepaged-use-a-folio-throughout-collapse_file-fix.patch
khugepaged-use-a-folio-throughout-hpage_collapse_scan_file.patch
proc-convert-clear_refs_pte_range-to-use-a-folio.patch
proc-convert-smaps_account-to-use-a-folio.patch
mm-remove-page_idle-and-page_young-wrappers.patch
mm-generate-page_idle_flag-definitions.patch
proc-convert-gather_stats-to-use-a-folio.patch
proc-convert-smaps_page_accumulate-to-use-a-folio.patch
proc-pass-a-folio-to-smaps_page_accumulate.patch
proc-convert-smaps_pmd_entry-to-use-a-folio.patch
mm-remove-struct-page-from-get_shadow_from_swap_cache.patch
hugetlb-convert-alloc_buddy_hugetlb_folio-to-use-a-folio.patch
mm-convert-pagecache_isize_extended-to-use-a-folio.patch
mm-free-non-hugetlb-large-folios-in-a-batch.patch
mm-combine-free_the_page-and-free_unref_page.patch
mm-inline-destroy_large_folio-into-__folio_put_large.patch
mm-combine-__folio_put_small-__folio_put_large-and-__folio_put.patch
mm-convert-free_zone_device_page-to-free_zone_device_folio.patch
doc-improve-the-description-of-__folio_mark_dirty.patch
buffer-add-kernel-doc-for-block_dirty_folio.patch
buffer-add-kernel-doc-for-try_to_free_buffers.patch
buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch
buffer-add-kernel-doc-for-brelse-and-__brelse.patch
buffer-add-kernel-doc-for-bforget-and-__bforget.patch
buffer-improve-bdev_getblk-documentation.patch
doc-split-bufferrst-out-of-api-summaryrst.patch
doc-split-bufferrst-out-of-api-summaryrst-fix.patch
mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill.patch
mm-memory-failure-pass-addr-to-__add_to_kill.patch
mm-return-the-address-from-page_mapped_in_vma.patch
mm-make-page_mapped_in_vma-conditional-on-config_memory_failure.patch
mm-memory-failure-convert-shake_page-to-shake_folio.patch
mm-convert-hugetlb_page_mapping_lock_write-to-folio.patch
mm-memory-failure-convert-memory_failure-to-use-a-folio.patch
mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio.patch
mm-memory-failure-add-some-folio-conversions-to-unpoison_memory.patch
mm-memory-failure-use-folio-functions-throughout-collect_procs.patch
mm-memory-failure-pass-the-folio-to-collect_procs_ksm.patch
fscrypt-convert-bh_get_inode_and_lblk_num-to-use-a-folio.patch
f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio.patch
memory-failure-remove-calls-to-page_mapping.patch
migrate-expand-the-use-of-folio-in-__migrate_device_pages.patch
userfault-expand-folio-use-in-mfill_atomic_install_pte.patch
mm-remove-page_mapping.patch
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch
mm-simplify-thp_vma_allowable_order.patch

