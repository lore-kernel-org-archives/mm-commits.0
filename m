Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F9F1C6A8;
	Thu, 25 Apr 2024 02:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714012518; cv=none; b=ZCm8LTCHDMBnJ3tGJFKRYiebyBfFA6lx5vKJmwK7/lwpW7Mf0+0huVp2TL5TlFBQighc/o3LPXlH3kpLQTbygdjlJzlZ5J6Zwly4CNMGOlGUboW+nAFokqijbYn0t4J1T3+Hpj/i7pC5qWbUwn1NVDbxhyVmg86K1WWtnD/2uj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714012518; c=relaxed/simple;
	bh=3GgjsAWEvvzyaJsyxTN0iC1eGF055hM7Hh3uFw0xceM=;
	h=Date:To:From:Subject:Message-Id; b=CibqAKn8seE8Kb110p4oDi9reDfDuJGrdkGm6wV9Bmu10f1jRpe0I+NVh13eN096edk/DS8B6KJIzFjBgipyOEaGmIqX0q6+fKDDYip1hmBSQ0ISj0mTI81GyNVuBjx18Tr7fC5dll46eW98KRQcnywiBhoYvxFbwwBGwHcryrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PE9HzwaV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PE9HzwaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB52C2BD10;
	Thu, 25 Apr 2024 02:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714012518;
	bh=3GgjsAWEvvzyaJsyxTN0iC1eGF055hM7Hh3uFw0xceM=;
	h=Date:To:From:Subject:From;
	b=PE9HzwaVC6qzjL2wtJoc0kqLOLcwxCkdgqfwgVqLy28Xl8Wg0FLgAfkx+/T2lWJXi
	 jGm7qrj4Bh6VC8CwKrn3ypjKtPr8MdZREpuS2tFDebPT7Kuvfn9cvJmImtnIMQFt3m
	 OmH3sIHx+DHHJ91OCAZeJpJsnY49HzYma77LUuAw=
Date: Wed, 24 Apr 2024 19:35:17 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-create-folio_flag_false-and-folio_type_ops-macros.patch removed from -mm tree
Message-Id: <20240425023518.1DB52C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: create FOLIO_FLAG_FALSE and FOLIO_TYPE_OPS macros
has been removed from the -mm tree.  Its filename was
     mm-create-folio_flag_false-and-folio_type_ops-macros.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: create FOLIO_FLAG_FALSE and FOLIO_TYPE_OPS macros
Date: Thu, 21 Mar 2024 14:24:40 +0000

Following the separation of FOLIO_FLAGS from PAGEFLAGS, separate
FOLIO_FLAG_FALSE from PAGEFLAG_FALSE and FOLIO_TYPE_OPS from
PAGE_TYPE_OPS.

Link: https://lkml.kernel.org/r/20240321142448.1645400-3-willy@infradead.org
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

 include/linux/page-flags.h |   70 +++++++++++++++++++++++------------
 1 file changed, 47 insertions(+), 23 deletions(-)

--- a/include/linux/page-flags.h~mm-create-folio_flag_false-and-folio_type_ops-macros
+++ a/include/linux/page-flags.h
@@ -458,30 +458,51 @@ static __always_inline int TestClearPage
 	TESTSETFLAG(uname, lname, policy)				\
 	TESTCLEARFLAG(uname, lname, policy)
 
+#define FOLIO_TEST_FLAG_FALSE(name)					\
+static inline bool folio_test_##name(const struct folio *folio)		\
+{ return false; }
+#define FOLIO_SET_FLAG_NOOP(name)					\
+static inline void folio_set_##name(struct folio *folio) { }
+#define FOLIO_CLEAR_FLAG_NOOP(name)					\
+static inline void folio_clear_##name(struct folio *folio) { }
+#define __FOLIO_SET_FLAG_NOOP(name)					\
+static inline void __folio_set_##name(struct folio *folio) { }
+#define __FOLIO_CLEAR_FLAG_NOOP(name)					\
+static inline void __folio_clear_##name(struct folio *folio) { }
+#define FOLIO_TEST_SET_FLAG_FALSE(name)					\
+static inline bool folio_test_set_##name(struct folio *folio)		\
+{ return false; }
+#define FOLIO_TEST_CLEAR_FLAG_FALSE(name)				\
+static inline bool folio_test_clear_##name(struct folio *folio)		\
+{ return false; }
+
+#define FOLIO_FLAG_FALSE(name)						\
+FOLIO_TEST_FLAG_FALSE(name)						\
+FOLIO_SET_FLAG_NOOP(name)						\
+FOLIO_CLEAR_FLAG_NOOP(name)
+
 #define TESTPAGEFLAG_FALSE(uname, lname)				\
-static inline bool folio_test_##lname(const struct folio *folio) { return false; } \
+FOLIO_TEST_FLAG_FALSE(lname)						\
 static inline int Page##uname(const struct page *page) { return 0; }
 
 #define SETPAGEFLAG_NOOP(uname, lname)					\
-static inline void folio_set_##lname(struct folio *folio) { }		\
+FOLIO_SET_FLAG_NOOP(lname)						\
 static inline void SetPage##uname(struct page *page) {  }
 
 #define CLEARPAGEFLAG_NOOP(uname, lname)				\
-static inline void folio_clear_##lname(struct folio *folio) { }		\
+FOLIO_CLEAR_FLAG_NOOP(lname)						\
 static inline void ClearPage##uname(struct page *page) {  }
 
 #define __CLEARPAGEFLAG_NOOP(uname, lname)				\
-static inline void __folio_clear_##lname(struct folio *folio) { }	\
+__FOLIO_CLEAR_FLAG_NOOP(lname)						\
 static inline void __ClearPage##uname(struct page *page) {  }
 
 #define TESTSETFLAG_FALSE(uname, lname)					\
-static inline bool folio_test_set_##lname(struct folio *folio)		\
-{ return 0; }								\
+FOLIO_TEST_SET_FLAG_FALSE(lname)					\
 static inline int TestSetPage##uname(struct page *page) { return 0; }
 
 #define TESTCLEARFLAG_FALSE(uname, lname)				\
-static inline bool folio_test_clear_##lname(struct folio *folio)	\
-{ return 0; }								\
+FOLIO_TEST_CLEAR_FLAG_FALSE(lname)					\
 static inline int TestClearPage##uname(struct page *page) { return 0; }
 
 #define PAGEFLAG_FALSE(uname, lname) TESTPAGEFLAG_FALSE(uname, lname)	\
@@ -977,35 +998,38 @@ static inline int page_has_type(const st
 	return page_type_has_type(page->page_type);
 }
 
+#define FOLIO_TYPE_OPS(lname, fname)					\
+static __always_inline bool folio_test_##fname(const struct folio *folio)\
+{									\
+	return folio_test_type(folio, PG_##lname);			\
+}									\
+static __always_inline void __folio_set_##fname(struct folio *folio)	\
+{									\
+	VM_BUG_ON_FOLIO(!folio_test_type(folio, 0), folio);		\
+	folio->page.page_type &= ~PG_##lname;				\
+}									\
+static __always_inline void __folio_clear_##fname(struct folio *folio)	\
+{									\
+	VM_BUG_ON_FOLIO(!folio_test_##fname(folio), folio);		\
+	folio->page.page_type |= PG_##lname;				\
+}
+
 #define PAGE_TYPE_OPS(uname, lname, fname)				\
+FOLIO_TYPE_OPS(lname, fname)						\
 static __always_inline int Page##uname(const struct page *page)		\
 {									\
 	return PageType(page, PG_##lname);				\
 }									\
-static __always_inline int folio_test_##fname(const struct folio *folio)\
-{									\
-	return folio_test_type(folio, PG_##lname);			\
-}									\
 static __always_inline void __SetPage##uname(struct page *page)		\
 {									\
 	VM_BUG_ON_PAGE(!PageType(page, 0), page);			\
 	page->page_type &= ~PG_##lname;					\
 }									\
-static __always_inline void __folio_set_##fname(struct folio *folio)	\
-{									\
-	VM_BUG_ON_FOLIO(!folio_test_type(folio, 0), folio);		\
-	folio->page.page_type &= ~PG_##lname;				\
-}									\
 static __always_inline void __ClearPage##uname(struct page *page)	\
 {									\
 	VM_BUG_ON_PAGE(!Page##uname(page), page);			\
 	page->page_type |= PG_##lname;					\
-}									\
-static __always_inline void __folio_clear_##fname(struct folio *folio)	\
-{									\
-	VM_BUG_ON_FOLIO(!folio_test_##fname(folio), folio);		\
-	folio->page.page_type |= PG_##lname;				\
-}									\
+}
 
 /*
  * PageBuddy() indicates that the page is free and in the buddy system
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

