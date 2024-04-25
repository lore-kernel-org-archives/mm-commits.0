Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DB315B3
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 00:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714006204; cv=none; b=JIuWEaeyGeKjr1iu5XaLGn4ClW+65iU5QHbhYBjTeqgbf9El1A3EijvPeUoo3Dz/g55FQWtEjd05/t2uoWqDZAgWAejZOJwSrY78pHLnxqPw1r4tKATv8I1pV/tHhUpA0+AI5a6R90HLgp4f+b3PKhzZHarR0GVbeOsVfCtNiSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714006204; c=relaxed/simple;
	bh=V5f13m1t4bK69rE7r6xBdttuTkZJ8EXv4hE7j5NboKw=;
	h=Date:To:From:Subject:Message-Id; b=ldZmJcQ6pLWVBasMJE8l5cbmKXB8lJ06YYM6IzVRf0zm8vd3F/xUNuBlWrwep43EtN8ScYJYC3H5uOP+iLBsS6i1tiU6Dm75yNc6XrvESTVefbeHLtXJiyZoSF8XrzWO/DvB2Pu8FH3+tj0TvRret1X4zM2lzqZwZ/6s+m3QBnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jvdJx1Yu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jvdJx1Yu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDF7C113CE;
	Thu, 25 Apr 2024 00:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714006204;
	bh=V5f13m1t4bK69rE7r6xBdttuTkZJ8EXv4hE7j5NboKw=;
	h=Date:To:From:Subject:From;
	b=jvdJx1YuBJjjxWFeK7Y6cCRWb+DZsJtLX/kmrX3a87iYteIXVQ/fXQSeBZCpH76MZ
	 fj7Ig5v5O2mL5AbgOEg/aCAc4QipziIDCjt4nPWrIm7nXnpsoq/0cNrI1MuCiI6WeX
	 KvThV4FemqNox7qctk1FaZn4e7qpYSAn9Lc4uzTs=
Date: Wed, 24 Apr 2024 17:50:03 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,linmiaohe@huawei.com,jane.chu@oracle.com,dan.j.williams@intel.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio.patch added to mm-unstable branch
Message-Id: <20240425005004.1EDF7C113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: convert hwpoison_user_mappings to take a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio.patch

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
Subject: mm/memory-failure: convert hwpoison_user_mappings to take a folio
Date: Fri, 12 Apr 2024 20:35:05 +0100

Pass the folio from the callers, and use it throughout instead of hpage. 
Saves dozens of calls to compound_head().

Link: https://lkml.kernel.org/r/20240412193510.2356957-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio
+++ a/mm/memory-failure.c
@@ -1559,24 +1559,24 @@ static int get_hwpoison_page(struct page
  * Do all that is necessary to remove user space mappings. Unmap
  * the pages and send SIGBUS to the processes if the data was dirty.
  */
-static bool hwpoison_user_mappings(struct page *p, unsigned long pfn,
-				  int flags, struct page *hpage)
+static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
+		unsigned long pfn, int flags)
 {
-	struct folio *folio = page_folio(hpage);
 	enum ttu_flags ttu = TTU_IGNORE_MLOCK | TTU_SYNC | TTU_HWPOISON;
 	struct address_space *mapping;
 	LIST_HEAD(tokill);
 	bool unmap_success;
 	int forcekill;
-	bool mlocked = PageMlocked(hpage);
+	bool mlocked = folio_test_mlocked(folio);
 
 	/*
 	 * Here we are interested only in user-mapped pages, so skip any
 	 * other types of pages.
 	 */
-	if (PageReserved(p) || PageSlab(p) || PageTable(p) || PageOffline(p))
+	if (folio_test_reserved(folio) || folio_test_slab(folio) ||
+	    folio_test_pgtable(folio) || folio_test_offline(folio))
 		return true;
-	if (!(PageLRU(hpage) || PageHuge(p)))
+	if (!(folio_test_lru(folio) || folio_test_hugetlb(folio)))
 		return true;
 
 	/*
@@ -1586,7 +1586,7 @@ static bool hwpoison_user_mappings(struc
 	if (!page_mapped(p))
 		return true;
 
-	if (PageSwapCache(p)) {
+	if (folio_test_swapcache(folio)) {
 		pr_err("%#lx: keeping poisoned page in swap cache\n", pfn);
 		ttu &= ~TTU_HWPOISON;
 	}
@@ -1597,11 +1597,11 @@ static bool hwpoison_user_mappings(struc
 	 * XXX: the dirty test could be racy: set_page_dirty() may not always
 	 * be called inside page lock (it's recommended but not enforced).
 	 */
-	mapping = page_mapping(hpage);
-	if (!(flags & MF_MUST_KILL) && !PageDirty(hpage) && mapping &&
+	mapping = folio_mapping(folio);
+	if (!(flags & MF_MUST_KILL) && !folio_test_dirty(folio) && mapping &&
 	    mapping_can_writeback(mapping)) {
-		if (page_mkclean(hpage)) {
-			SetPageDirty(hpage);
+		if (folio_mkclean(folio)) {
+			folio_set_dirty(folio);
 		} else {
 			ttu &= ~TTU_HWPOISON;
 			pr_info("%#lx: corrupted page was clean: dropped without side effects\n",
@@ -1616,7 +1616,7 @@ static bool hwpoison_user_mappings(struc
 	 */
 	collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
 
-	if (PageHuge(hpage) && !PageAnon(hpage)) {
+	if (folio_test_hugetlb(folio) && !folio_test_anon(folio)) {
 		/*
 		 * For hugetlb pages in shared mappings, try_to_unmap
 		 * could potentially call huge_pmd_unshare.  Because of
@@ -1656,7 +1656,7 @@ static bool hwpoison_user_mappings(struc
 	 * use a more force-full uncatchable kill to prevent
 	 * any accesses to the poisoned memory.
 	 */
-	forcekill = PageDirty(hpage) || (flags & MF_MUST_KILL) ||
+	forcekill = folio_test_dirty(folio) || (flags & MF_MUST_KILL) ||
 		    !unmap_success;
 	kill_procs(&tokill, forcekill, !unmap_success, pfn, flags);
 
@@ -2100,7 +2100,7 @@ retry:
 
 	page_flags = folio->flags;
 
-	if (!hwpoison_user_mappings(p, pfn, flags, &folio->page)) {
+	if (!hwpoison_user_mappings(folio, p, pfn, flags)) {
 		folio_unlock(folio);
 		return action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 	}
@@ -2367,7 +2367,7 @@ try_again:
 	 * Now take care of user space mappings.
 	 * Abort on fail: __filemap_remove_folio() assumes unmapped page.
 	 */
-	if (!hwpoison_user_mappings(p, pfn, flags, p)) {
+	if (!hwpoison_user_mappings(folio, p, pfn, flags)) {
 		res = action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 		goto unlock_page;
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

