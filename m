Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E758F17F8
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 00:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714006193; cv=none; b=VKzMaWwl41lP56fthhmiSTBEKI7pV9rFCm/ngH1kKho9AyL9L3p9W8y4F4LOpxutetmKf6/vxyQy3ByzhqkWfBXWzfHyc82RjDEAvTKcUL57WcpirFlWmZ1NltKQqoPUQ9u/KFgD8jbfd7jiu0zvfzvociscW0CGPfeFNZHns90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714006193; c=relaxed/simple;
	bh=Ku5Nc4YDckEhB6eZ3kSf+AZPz+Rg6IriGFJ8q1OXk0c=;
	h=Date:To:From:Subject:Message-Id; b=uN2JufnZ8m5cL8vYgoiZVaistGeSo/65b3+F2yvILVgdq75SdXRah4tcx3ZQftOtxQCieZLVWg0bkQtfUaeepidw528dWjFVTMaRVU8fALuslXtpxc5QRoBYZ3OCSQzmxfJS4KR7mdyvp9pMldDVWRpDTA717tMybrAiFbzFQhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k7HmHBhh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k7HmHBhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57810C113CD;
	Thu, 25 Apr 2024 00:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714006192;
	bh=Ku5Nc4YDckEhB6eZ3kSf+AZPz+Rg6IriGFJ8q1OXk0c=;
	h=Date:To:From:Subject:From;
	b=k7HmHBhh0rlRghvP8u6nBSmhyApEfzRvPo1l3cDlgVE3hT6LFuNTCsSWMABSIOh1R
	 vQU3lt5B87c52vJ3yB5PLVjW0H3J3XySJAliRBmJQTurEIMwb8tb9j/zlkLLn8NWqN
	 UoqW+iX6DkxXlCSCVsBKi3nQ5F6PxuJ4NL9aTzgk=
Date: Wed, 24 Apr 2024 17:49:51 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,linmiaohe@huawei.com,jane.chu@oracle.com,dan.j.williams@intel.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-return-the-address-from-page_mapped_in_vma.patch added to mm-unstable branch
Message-Id: <20240425004952.57810C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: return the address from page_mapped_in_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-return-the-address-from-page_mapped_in_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-return-the-address-from-page_mapped_in_vma.patch

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
Subject: mm: return the address from page_mapped_in_vma()
Date: Fri, 12 Apr 2024 20:35:00 +0100

The only user of this function calls page_address_in_vma() immediately
after page_mapped_in_vma() calculates it and uses it to return true/false.
Return the address instead, allowing memory-failure to skip the call to
page_address_in_vma().

Link: https://lkml.kernel.org/r/20240412193510.2356957-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 +-
 mm/memory-failure.c  |   22 +++++++++++++---------
 mm/page_vma_mapped.c |   16 +++++++++-------
 3 files changed, 23 insertions(+), 17 deletions(-)

--- a/include/linux/rmap.h~mm-return-the-address-from-page_mapped_in_vma
+++ a/include/linux/rmap.h
@@ -732,7 +732,7 @@ int pfn_mkclean_range(unsigned long pfn,
 
 void remove_migration_ptes(struct folio *src, struct folio *dst, bool locked);
 
-int page_mapped_in_vma(struct page *page, struct vm_area_struct *vma);
+unsigned long page_mapped_in_vma(struct page *page, struct vm_area_struct *vma);
 
 /*
  * rmap_walk_control: To control rmap traversing for specific needs
--- a/mm/memory-failure.c~mm-return-the-address-from-page_mapped_in_vma
+++ a/mm/memory-failure.c
@@ -473,10 +473,11 @@ static void __add_to_kill(struct task_st
 }
 
 static void add_to_kill_anon_file(struct task_struct *tsk, struct page *p,
-				  struct vm_area_struct *vma,
-				  struct list_head *to_kill)
+		struct vm_area_struct *vma, struct list_head *to_kill,
+		unsigned long addr)
 {
-	unsigned long addr = page_address_in_vma(p, vma);
+	if (addr == -EFAULT)
+		return;
 	__add_to_kill(tsk, p, vma, to_kill, addr);
 }
 
@@ -601,7 +602,6 @@ struct task_struct *task_early_kill(stru
 static void collect_procs_anon(struct folio *folio, struct page *page,
 		struct list_head *to_kill, int force_early)
 {
-	struct vm_area_struct *vma;
 	struct task_struct *tsk;
 	struct anon_vma *av;
 	pgoff_t pgoff;
@@ -613,8 +613,10 @@ static void collect_procs_anon(struct fo
 	pgoff = page_to_pgoff(page);
 	rcu_read_lock();
 	for_each_process(tsk) {
+		struct vm_area_struct *vma;
 		struct anon_vma_chain *vmac;
 		struct task_struct *t = task_early_kill(tsk, force_early);
+		unsigned long addr;
 
 		if (!t)
 			continue;
@@ -623,9 +625,8 @@ static void collect_procs_anon(struct fo
 			vma = vmac->vma;
 			if (vma->vm_mm != t->mm)
 				continue;
-			if (!page_mapped_in_vma(page, vma))
-				continue;
-			add_to_kill_anon_file(t, page, vma, to_kill);
+			addr = page_mapped_in_vma(page, vma);
+			add_to_kill_anon_file(t, page, vma, to_kill, addr);
 		}
 	}
 	rcu_read_unlock();
@@ -648,6 +649,7 @@ static void collect_procs_file(struct fo
 	pgoff = page_to_pgoff(page);
 	for_each_process(tsk) {
 		struct task_struct *t = task_early_kill(tsk, force_early);
+		unsigned long addr;
 
 		if (!t)
 			continue;
@@ -660,8 +662,10 @@ static void collect_procs_file(struct fo
 			 * Assume applications who requested early kill want
 			 * to be informed of all such data corruptions.
 			 */
-			if (vma->vm_mm == t->mm)
-				add_to_kill_anon_file(t, page, vma, to_kill);
+			if (vma->vm_mm != t->mm)
+				continue;
+			addr = page_address_in_vma(page, vma);
+			add_to_kill_anon_file(t, page, vma, to_kill, addr);
 		}
 	}
 	rcu_read_unlock();
--- a/mm/page_vma_mapped.c~mm-return-the-address-from-page_mapped_in_vma
+++ a/mm/page_vma_mapped.c
@@ -319,11 +319,12 @@ next_pte:
  * @page: the page to test
  * @vma: the VMA to test
  *
- * Returns 1 if the page is mapped into the page tables of the VMA, 0
- * if the page is not mapped into the page tables of this VMA.  Only
- * valid for normal file or anonymous VMAs.
+ * Return: The address the page is mapped at if the page is in the range
+ * covered by the VMA and present in the page table.  If the page is
+ * outside the VMA or not present, returns -EFAULT.
+ * Only valid for normal file or anonymous VMAs.
  */
-int page_mapped_in_vma(struct page *page, struct vm_area_struct *vma)
+unsigned long page_mapped_in_vma(struct page *page, struct vm_area_struct *vma)
 {
 	struct folio *folio = page_folio(page);
 	pgoff_t pgoff = folio->index + folio_page_idx(folio, page);
@@ -336,9 +337,10 @@ int page_mapped_in_vma(struct page *page
 
 	pvmw.address = vma_address(vma, pgoff, 1);
 	if (pvmw.address == -EFAULT)
-		return 0;
+		goto out;
 	if (!page_vma_mapped_walk(&pvmw))
-		return 0;
+		return -EFAULT;
 	page_vma_mapped_walk_done(&pvmw);
-	return 1;
+out:
+	return pvmw.address;
 }
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

