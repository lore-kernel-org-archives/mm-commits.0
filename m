Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1762FA35
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 02:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714012177; cv=none; b=Zj7KMABN9xlLaIEADmCFhsS6E62293FSZJmHkgxSzwymyRfAj2cp6iuOsGtwQxHwqle5kTRUpyw9eus6s5Vl2IdHdahI1YgbKI9MOrpam4ybexCm4JWmzLjyxfR3DIBojLNV6k+dmu1YWJbs3mGuLYge5RuMQYywU+pfRpNRhxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714012177; c=relaxed/simple;
	bh=LzP4djkYzfdYt3EBEtXuqqILh/XI+gxnEz9w+f5v2Gg=;
	h=Date:To:From:Subject:Message-Id; b=MpXHf6ZXkTho6Zq96brd8RSlLrJQyO34RcRxdKlwtkM7QNFEBD3ljEJHYjGtCOTP7cUcM3F5dE54dy8muF75YoimGWeKQJHKYGvCx7QzC6dY2W+G10gr7Xm4A+uz90uJ7BoT4sGqiKOmoyJaQeynXiJLJio3qax9j6+5qYYWbjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MBxGxBBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MBxGxBBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDE9C113CD;
	Thu, 25 Apr 2024 02:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714012176;
	bh=LzP4djkYzfdYt3EBEtXuqqILh/XI+gxnEz9w+f5v2Gg=;
	h=Date:To:From:Subject:From;
	b=MBxGxBBKoxR37UXAph10kFube7JE+ACGEM3pTmOAAmbdGEO+LSzXpPFUkxOEGkPiH
	 kMmWucHUtsBaNkiZhibtekIxp+J3DNf0OkX27kX4DZqgEIT2YLmQ+oWczEbu8T/zsr
	 RZEPA2q09M3ExjzGaCCuliiz4pziZ6Xat/SvK0kg=
Date: Wed, 24 Apr 2024 19:29:35 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch removed from -mm tree
Message-Id: <20240425022936.8DDE9C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-turn-folio_test_hugetlb-into-a-pagetype-fix
has been removed from the -mm tree.  Its filename was
     mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch

This patch was dropped because it was folded into mm-turn-folio_test_hugetlb-into-a-pagetype.patch

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mm-turn-folio_test_hugetlb-into-a-pagetype-fix
Date: Mon, 25 Mar 2024 15:33:38 +0000

update vmcoreinfo

Link: https://lkml.kernel.org/r/ZgGZUvsdhaT1Va-T@casper.infradead.org
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/vmcore_info.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/vmcore_info.c~mm-turn-folio_test_hugetlb-into-a-pagetype-fix
+++ a/kernel/vmcore_info.c
@@ -205,11 +205,10 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_NUMBER(PG_head_mask);
 #define PAGE_BUDDY_MAPCOUNT_VALUE	(~PG_buddy)
 	VMCOREINFO_NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE);
-#ifdef CONFIG_HUGETLB_PAGE
-	VMCOREINFO_NUMBER(PG_hugetlb);
+#define PAGE_HUGETLB_MAPCOUNT_VALUE	(~PG_hugetlb)
+	VMCOREINFO_NUMBER(PAGE_HUGETLB_MAPCOUNT_VALUE);
 #define PAGE_OFFLINE_MAPCOUNT_VALUE	(~PG_offline)
 	VMCOREINFO_NUMBER(PAGE_OFFLINE_MAPCOUNT_VALUE);
-#endif
 
 #ifdef CONFIG_KALLSYMS
 	VMCOREINFO_SYMBOL(kallsyms_names);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
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

