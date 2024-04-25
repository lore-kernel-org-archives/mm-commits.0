Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E5B185E
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 00:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714006209; cv=none; b=i78aPHG71DHI6oNBSjI8PmiS6Enx8F/yoyGNtoDpRQ+gW+9HnGRRUYyp35dcdBuL4bzfmnJGxQpN78Ey1PXtKhWlob9oAmUxvhLt69POPzzgwLg/eBuoO4WljAsPLvXVpluwwwVHa+8heem6ByOsRJboXu5j7vGA9B2zrCYmEKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714006209; c=relaxed/simple;
	bh=opBFkuF31OPzJXmlbuJ0r1YFJ2H6oXLqg7SA9nxRmCM=;
	h=Date:To:From:Subject:Message-Id; b=jyB5vNSCBD8J2JKa9ULcGWnHSG8un5dFZfcc5Bod8HOPuOwafAyzaKvgMUiRA0Xoo3dYZBLN8C0J1tRE386lXJjkxntNtCbS92hoVXkVRPbe2r8oT9iyhRC1W0mzx2RPUE1C3dJiQz6SqmJS1+ay+X0k6v7/MnjRSjSYPApfk3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vrAu/uN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vrAu/uN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2A2C113CD;
	Thu, 25 Apr 2024 00:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714006209;
	bh=opBFkuF31OPzJXmlbuJ0r1YFJ2H6oXLqg7SA9nxRmCM=;
	h=Date:To:From:Subject:From;
	b=vrAu/uN0rd4jgb0zGHqxl/SszWBWhmQAjhLjTpZ0hzhcszEWxiLm0FASB8YBcqjbz
	 1D4AxyV50xeFqd40s85QjezElPYa2sy5i7tu7/8qjIt2HoifUO9sherCqhp0DrtryX
	 pG3TVz7BUFxlnLTE0GWg7TwZrhz1SpQaYwjufOjA=
Date: Wed, 24 Apr 2024 17:50:08 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,linmiaohe@huawei.com,jane.chu@oracle.com,dan.j.williams@intel.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-pass-the-folio-to-collect_procs_ksm.patch added to mm-unstable branch
Message-Id: <20240425005008.EC2A2C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: pass the folio to collect_procs_ksm()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-pass-the-folio-to-collect_procs_ksm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-pass-the-folio-to-collect_procs_ksm.patch

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
Subject: mm/memory-failure: pass the folio to collect_procs_ksm()
Date: Fri, 12 Apr 2024 20:35:08 +0100

We've already calculated it, so pass it in instead of recalculating it in
collect_procs_ksm().

Link: https://lkml.kernel.org/r/20240412193510.2356957-12-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h |   14 +++-----------
 mm/ksm.c            |    5 ++---
 mm/memory-failure.c |    2 +-
 3 files changed, 6 insertions(+), 15 deletions(-)

--- a/include/linux/ksm.h~mm-memory-failure-pass-the-folio-to-collect_procs_ksm
+++ a/include/linux/ksm.h
@@ -81,15 +81,9 @@ struct folio *ksm_might_need_to_copy(str
 
 void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc);
 void folio_migrate_ksm(struct folio *newfolio, struct folio *folio);
-
-#ifdef CONFIG_MEMORY_FAILURE
-void collect_procs_ksm(struct page *page, struct list_head *to_kill,
-		       int force_early);
-#endif
-
-#ifdef CONFIG_PROC_FS
+void collect_procs_ksm(struct folio *folio, struct page *page,
+		struct list_head *to_kill, int force_early);
 long ksm_process_profit(struct mm_struct *);
-#endif /* CONFIG_PROC_FS */
 
 #else  /* !CONFIG_KSM */
 
@@ -120,12 +114,10 @@ static inline void ksm_might_unmap_zero_
 {
 }
 
-#ifdef CONFIG_MEMORY_FAILURE
-static inline void collect_procs_ksm(struct page *page,
+static inline void collect_procs_ksm(struct folio *folio, struct page *page,
 				     struct list_head *to_kill, int force_early)
 {
 }
-#endif
 
 #ifdef CONFIG_MMU
 static inline int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
--- a/mm/ksm.c~mm-memory-failure-pass-the-folio-to-collect_procs_ksm
+++ a/mm/ksm.c
@@ -3178,12 +3178,11 @@ again:
 /*
  * Collect processes when the error hit an ksm page.
  */
-void collect_procs_ksm(struct page *page, struct list_head *to_kill,
-		       int force_early)
+void collect_procs_ksm(struct folio *folio, struct page *page,
+		struct list_head *to_kill, int force_early)
 {
 	struct ksm_stable_node *stable_node;
 	struct ksm_rmap_item *rmap_item;
-	struct folio *folio = page_folio(page);
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
 
--- a/mm/memory-failure.c~mm-memory-failure-pass-the-folio-to-collect_procs_ksm
+++ a/mm/memory-failure.c
@@ -729,7 +729,7 @@ static void collect_procs(struct folio *
 	if (!folio->mapping)
 		return;
 	if (unlikely(folio_test_ksm(folio)))
-		collect_procs_ksm(page, tokill, force_early);
+		collect_procs_ksm(folio, page, tokill, force_early);
 	else if (folio_test_anon(folio))
 		collect_procs_anon(folio, page, tokill, force_early);
 	else
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

