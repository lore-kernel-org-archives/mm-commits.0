Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC7015B3
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 00:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714006198; cv=none; b=fAwkaiUA3VGXeeHlStKOs9TP3/8HZtJBqLoNkBXUrLFMPSARRLezHd5100TsHpDJSohrSdI42OUpBykB2WSuFCJSBM2WFHHYHnsbUjRoAAhltV7k16Fbm6DpUmUnU3KdLXYvz6i2yn9TnQcSCCXq8myysXCpKMT1AtFTvhEU+gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714006198; c=relaxed/simple;
	bh=Cjhu0mGo6/JLquqmijCavhAXxv4QqUCwCNvyCIwtjLk=;
	h=Date:To:From:Subject:Message-Id; b=NB9wxUfLvOVPX3H7i6VDUC/7u3u/ZOuzY3YYIH8XyvXO77GJ8EQ27E/7shBH/cFs6SE1GUDIDK5h7LMiJZ18cPHSumkHF+8uSIobWLk9N+qE+7e9kra7DLvP2YoNfr7wJe+I8sZ9WGlIDBVq3CXH1jSCkBD/htxbW3Rcu4z0rYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V+iFeLHw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V+iFeLHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB0BC113CD;
	Thu, 25 Apr 2024 00:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714006198;
	bh=Cjhu0mGo6/JLquqmijCavhAXxv4QqUCwCNvyCIwtjLk=;
	h=Date:To:From:Subject:From;
	b=V+iFeLHwuPX08epwLPVexBEBMIB+BMe6KOKL138vMnzjir4q4HXps6Wm+XKi1O5gl
	 3U1N5wgFt1XUsfEN/BpeSDdZXXPPOejWcRc0JHxDD6bfAH0SD2CjEp5lj1NK9Ga6Yg
	 lj8BGq8VwahOdwH5cHoQrE216wjIQMxdzZER1u8c=
Date: Wed, 24 Apr 2024 17:49:57 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,linmiaohe@huawei.com,jane.chu@oracle.com,dan.j.williams@intel.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-convert-shake_page-to-shake_folio.patch added to mm-unstable branch
Message-Id: <20240425004958.1DB0BC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: convert shake_page() to shake_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-convert-shake_page-to-shake_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-convert-shake_page-to-shake_folio.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/memory-failure: convert shake_page() to shake_folio()
Date: Fri, 12 Apr 2024 20:35:02 +0100

Removes two calls to compound_head().  Move the prototype to internal.h;
we definitely don't want code outside mm using it.

Link: https://lkml.kernel.org/r/20240412193510.2356957-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h   |    1 -
 mm/hwpoison-inject.c |   11 ++++++-----
 mm/internal.h        |    1 +
 mm/memory-failure.c  |   15 ++++++++++-----
 4 files changed, 17 insertions(+), 11 deletions(-)

--- a/include/linux/mm.h~mm-memory-failure-convert-shake_page-to-shake_folio
+++ a/include/linux/mm.h
@@ -4033,7 +4033,6 @@ int mf_dax_kill_procs(struct address_spa
 extern int memory_failure(unsigned long pfn, int flags);
 extern void memory_failure_queue_kick(int cpu);
 extern int unpoison_memory(unsigned long pfn);
-extern void shake_page(struct page *p);
 extern atomic_long_t num_poisoned_pages __read_mostly;
 extern int soft_offline_page(unsigned long pfn, int flags);
 #ifdef CONFIG_MEMORY_FAILURE
--- a/mm/hwpoison-inject.c~mm-memory-failure-convert-shake_page-to-shake_folio
+++ a/mm/hwpoison-inject.c
@@ -15,7 +15,7 @@ static int hwpoison_inject(void *data, u
 {
 	unsigned long pfn = val;
 	struct page *p;
-	struct page *hpage;
+	struct folio *folio;
 	int err;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -25,16 +25,17 @@ static int hwpoison_inject(void *data, u
 		return -ENXIO;
 
 	p = pfn_to_page(pfn);
-	hpage = compound_head(p);
+	folio = page_folio(p);
 
 	if (!hwpoison_filter_enable)
 		goto inject;
 
-	shake_page(hpage);
+	shake_folio(folio);
 	/*
 	 * This implies unable to support non-LRU pages except free page.
 	 */
-	if (!PageLRU(hpage) && !PageHuge(p) && !is_free_buddy_page(p))
+	if (!folio_test_lru(folio) && !folio_test_hugetlb(folio) &&
+	    !is_free_buddy_page(p))
 		return 0;
 
 	/*
@@ -42,7 +43,7 @@ static int hwpoison_inject(void *data, u
 	 * the targeted owner (or on a free page).
 	 * memory_failure() will redo the check reliably inside page lock.
 	 */
-	err = hwpoison_filter(hpage);
+	err = hwpoison_filter(&folio->page);
 	if (err)
 		return 0;
 
--- a/mm/internal.h~mm-memory-failure-convert-shake_page-to-shake_folio
+++ a/mm/internal.h
@@ -1037,6 +1037,7 @@ static inline int find_next_best_node(in
 /*
  * mm/memory-failure.c
  */
+void shake_folio(struct folio *folio);
 extern int hwpoison_filter(struct page *p);
 
 extern u32 hwpoison_filter_dev_major;
--- a/mm/memory-failure.c~mm-memory-failure-convert-shake_page-to-shake_folio
+++ a/mm/memory-failure.c
@@ -369,20 +369,25 @@ static int kill_proc(struct to_kill *tk,
  * Unknown page type encountered. Try to check whether it can turn PageLRU by
  * lru_add_drain_all.
  */
-void shake_page(struct page *p)
+void shake_folio(struct folio *folio)
 {
-	if (PageHuge(p))
+	if (folio_test_hugetlb(folio))
 		return;
 	/*
 	 * TODO: Could shrink slab caches here if a lightweight range-based
 	 * shrinker will be available.
 	 */
-	if (PageSlab(p))
+	if (folio_test_slab(folio))
 		return;
 
 	lru_add_drain_all();
 }
-EXPORT_SYMBOL_GPL(shake_page);
+EXPORT_SYMBOL_GPL(shake_folio);
+
+static void shake_page(struct page *page)
+{
+	shake_folio(page_folio(page));
+}
 
 static unsigned long dev_pagemap_mapping_shift(struct vm_area_struct *vma,
 		unsigned long address)
@@ -1639,7 +1644,7 @@ static bool hwpoison_user_mappings(struc
 	 * shake_page() again to ensure that it's flushed.
 	 */
 	if (mlocked)
-		shake_page(hpage);
+		shake_folio(folio);
 
 	/*
 	 * Now that the dirty bit has been propagated to the
_

Patches currently in -mm which might be from willy@infradead.org are

mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch
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
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch

