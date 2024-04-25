Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE88D12E61;
	Thu, 25 Apr 2024 02:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714012519; cv=none; b=qkYRP2S+jT1HgJK2NnGDpyO+VcmaKraMQaQL+QLGHkYuDOclQdwrQ8x+A4KkXybp5fOJF4TF37+ke9PUbu50cL9CIgTF63qoYwTtoKixBMQwmr8R+A2w2cuD2urLLBZHj3+equH5WMhha7aAdUku8OBVOd6NSqOjx4W6ZxX0XW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714012519; c=relaxed/simple;
	bh=XkHbhEyVLWmwu2RFHTEc//TPbsOXxfhnz6241On3sBQ=;
	h=Date:To:From:Subject:Message-Id; b=X1aSz5oo00ZvmYWgCYfs+6R90lHUkjbcPvavRpkeoEnweCy0HUPLCs4Pda2ZYrwtP75HDTmyFPAQl4w3JD10DGdNlq0Hv7j0wBlPTXnxGO+oEcVcJIINL3nsu7LXzQAXYhoO2JmKpuZPQLLvu5wsRJypDBzf0EPlYqG+5HBBT0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qH2+W5NF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qH2+W5NF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397E7C32782;
	Thu, 25 Apr 2024 02:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714012519;
	bh=XkHbhEyVLWmwu2RFHTEc//TPbsOXxfhnz6241On3sBQ=;
	h=Date:To:From:Subject:From;
	b=qH2+W5NFp5Fk9mfJS3q/YiMP5gq5BPqty3vVdL9+vKK4x9vp/V/3r6Y9xVCl46304
	 yeIAiBdfhPt3U9B+GD7I4CISIxlNdCNJdgmKt26PKDYELHvfd6CR6BMDwubRo9gGce
	 1BfHaWMl0pEefn+aaAeLhh1nx7bSQAE5TDmYydco=
Date: Wed, 24 Apr 2024 19:35:18 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-support-page_mapcount-on-page_has_type-pages.patch removed from -mm tree
Message-Id: <20240425023519.397E7C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: support page_mapcount() on page_has_type() pages
has been removed from the -mm tree.  Its filename was
     mm-support-page_mapcount-on-page_has_type-pages.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: support page_mapcount() on page_has_type() pages
Date: Thu, 21 Mar 2024 14:24:42 +0000

Return 0 for pages which can't be mapped.  This matches how page_mapped()
works.  It is more convenient for users to not have to filter out these
pages.

Link: https://lkml.kernel.org/r/20240321142448.1645400-5-willy@infradead.org
Fixes: 9c5ccf2db04b ("mm: remove HUGETLB_PAGE_DTOR")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c             |    7 ++-----
 include/linux/mm.h         |    8 +++++---
 include/linux/page-flags.h |    4 ++--
 3 files changed, 9 insertions(+), 10 deletions(-)

--- a/fs/proc/page.c~mm-support-page_mapcount-on-page_has_type-pages
+++ a/fs/proc/page.c
@@ -67,7 +67,7 @@ static ssize_t kpagecount_read(struct fi
 		 */
 		ppage = pfn_to_online_page(pfn);
 
-		if (!ppage || PageSlab(ppage) || page_has_type(ppage))
+		if (!ppage)
 			pcount = 0;
 		else
 			pcount = page_mapcount(ppage);
@@ -124,11 +124,8 @@ u64 stable_page_flags(struct page *page)
 
 	/*
 	 * pseudo flags for the well known (anonymous) memory mapped pages
-	 *
-	 * Note that page->_mapcount is overloaded in SLAB, so the
-	 * simple test in page_mapped() is not enough.
 	 */
-	if (!PageSlab(page) && page_mapped(page))
+	if (page_mapped(page))
 		u |= 1 << KPF_MMAP;
 	if (PageAnon(page))
 		u |= 1 << KPF_ANON;
--- a/include/linux/mm.h~mm-support-page_mapcount-on-page_has_type-pages
+++ a/include/linux/mm.h
@@ -1223,14 +1223,16 @@ static inline void page_mapcount_reset(s
  * a large folio, it includes the number of times this page is mapped
  * as part of that folio.
  *
- * The result is undefined for pages which cannot be mapped into userspace.
- * For example SLAB or special types of pages. See function page_has_type().
- * They use this field in struct page differently.
+ * Will report 0 for pages which cannot be mapped into userspace, eg
+ * slab, page tables and similar.
  */
 static inline int page_mapcount(struct page *page)
 {
 	int mapcount = atomic_read(&page->_mapcount) + 1;
 
+	/* Handle page_has_type() pages */
+	if (mapcount < 0)
+		mapcount = 0;
 	if (unlikely(PageCompound(page)))
 		mapcount += folio_entire_mapcount(page_folio(page));
 
--- a/include/linux/page-flags.h~mm-support-page_mapcount-on-page_has_type-pages
+++ a/include/linux/page-flags.h
@@ -971,12 +971,12 @@ static inline bool is_page_hwpoison(stru
  * page_type may be used.  Because it is initialised to -1, we invert the
  * sense of the bit, so __SetPageFoo *clears* the bit used for PageFoo, and
  * __ClearPageFoo *sets* the bit used for PageFoo.  We reserve a few high and
- * low bits so that an underflow or overflow of page_mapcount() won't be
+ * low bits so that an underflow or overflow of _mapcount won't be
  * mistaken for a page type value.
  */
 
 #define PAGE_TYPE_BASE	0xf0000000
-/* Reserve		0x0000007f to catch underflows of page_mapcount */
+/* Reserve		0x0000007f to catch underflows of _mapcount */
 #define PAGE_MAPCOUNT_RESERVE	-128
 #define PG_buddy	0x00000080
 #define PG_offline	0x00000100
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

