Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FEC4C62
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 00:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714006189; cv=none; b=Wh1pqoSfDk31E+8WJOl40v+RBbsFGgIXWKvxDYTzcQ93rOh8o3P1Fb7jUZhIw4oXSBDOCy2zjU6sxl97IKMLoU/K7zg+8PERfHKb0hG/sO3O25xPFd2XZs6rfjzKrLN45WGwB/s6n+X/Vn3d6wFFoHQ6S8TEtCf5AcvEv0nY+RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714006189; c=relaxed/simple;
	bh=wbUgwPjbkDY+OLknxhxipVpbstPS0+maRQ7Qdd9w1n4=;
	h=Date:To:From:Subject:Message-Id; b=YqTFOVDX1Tx7m1x1PbpJY6VALsKszxKWt6t1ijlr3XbT9dSEYYzdGrv3hqnR2usujaPqA+vqwgSTSWRQRAePEVPJ2A/wg87MoxyWf7j60ISH0+7xbzHF1jmTwpT65lnkMF0xYBYvo1+1ikh7OnBYh91OHRu9kd7Os2s+xvl9Mss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kN38+Iay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kN38+Iay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35E1C113CD;
	Thu, 25 Apr 2024 00:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714006189;
	bh=wbUgwPjbkDY+OLknxhxipVpbstPS0+maRQ7Qdd9w1n4=;
	h=Date:To:From:Subject:From;
	b=kN38+IayFWXTvRv1T49N75RVAvyD6KNcOgPYd+no23Fg/ZwQvwlWhCWuZA6VgZgae
	 JSjh21IQLtNbs5NlkeSeXLJ5+4+mneVfNNMrXYSIgm6I0alo//4PmsuJ/kchK9bogg
	 gu1FDC6qIv+jBzCIGGQSvogFMVBVb+AEyLFsto7A=
Date: Wed, 24 Apr 2024 17:49:48 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,linmiaohe@huawei.com,jane.chu@oracle.com,dan.j.williams@intel.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill.patch added to mm-unstable branch
Message-Id: <20240425004948.F35E1C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: remove fsdax_pgoff argument from __add_to_kill
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill.patch

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
Subject: mm/memory-failure: remove fsdax_pgoff argument from __add_to_kill
Date: Fri, 12 Apr 2024 20:34:58 +0100

Patch series "Some cleanups for memory-failure", v3.

A lot of folio conversions, plus some other simplifications. 


This patch (of 11):

Unify the KSM and DAX codepaths by calculating the addr in
add_to_kill_fsdax() instead of telling __add_to_kill() to calculate it.

Link: https://lkml.kernel.org/r/20240412193510.2356957-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240412193510.2356957-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill
+++ a/mm/memory-failure.c
@@ -427,21 +427,13 @@ static unsigned long dev_pagemap_mapping
  * not much we can do.	We just print a message and ignore otherwise.
  */
 
-#define FSDAX_INVALID_PGOFF ULONG_MAX
-
 /*
  * Schedule a process for later kill.
  * Uses GFP_ATOMIC allocations to avoid potential recursions in the VM.
- *
- * Note: @fsdax_pgoff is used only when @p is a fsdax page and a
- * filesystem with a memory failure handler has claimed the
- * memory_failure event. In all other cases, page->index and
- * page->mapping are sufficient for mapping the page back to its
- * corresponding user virtual address.
  */
 static void __add_to_kill(struct task_struct *tsk, struct page *p,
 			  struct vm_area_struct *vma, struct list_head *to_kill,
-			  unsigned long ksm_addr, pgoff_t fsdax_pgoff)
+			  unsigned long addr)
 {
 	struct to_kill *tk;
 
@@ -451,12 +443,10 @@ static void __add_to_kill(struct task_st
 		return;
 	}
 
-	tk->addr = ksm_addr ? ksm_addr : page_address_in_vma(p, vma);
-	if (is_zone_device_page(p)) {
-		if (fsdax_pgoff != FSDAX_INVALID_PGOFF)
-			tk->addr = vma_address(vma, fsdax_pgoff, 1);
+	tk->addr = addr ? addr : page_address_in_vma(p, vma);
+	if (is_zone_device_page(p))
 		tk->size_shift = dev_pagemap_mapping_shift(vma, tk->addr);
-	} else
+	else
 		tk->size_shift = page_shift(compound_head(p));
 
 	/*
@@ -486,7 +476,7 @@ static void add_to_kill_anon_file(struct
 				  struct vm_area_struct *vma,
 				  struct list_head *to_kill)
 {
-	__add_to_kill(tsk, p, vma, to_kill, 0, FSDAX_INVALID_PGOFF);
+	__add_to_kill(tsk, p, vma, to_kill, 0);
 }
 
 #ifdef CONFIG_KSM
@@ -504,10 +494,10 @@ static bool task_in_to_kill_list(struct
 }
 void add_to_kill_ksm(struct task_struct *tsk, struct page *p,
 		     struct vm_area_struct *vma, struct list_head *to_kill,
-		     unsigned long ksm_addr)
+		     unsigned long addr)
 {
 	if (!task_in_to_kill_list(to_kill, tsk))
-		__add_to_kill(tsk, p, vma, to_kill, ksm_addr, FSDAX_INVALID_PGOFF);
+		__add_to_kill(tsk, p, vma, to_kill, addr);
 }
 #endif
 /*
@@ -681,7 +671,8 @@ static void add_to_kill_fsdax(struct tas
 			      struct vm_area_struct *vma,
 			      struct list_head *to_kill, pgoff_t pgoff)
 {
-	__add_to_kill(tsk, p, vma, to_kill, 0, pgoff);
+	unsigned long addr = vma_address(vma, pgoff, 1);
+	__add_to_kill(tsk, p, vma, to_kill, addr);
 }
 
 /*
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

