Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969607C085
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103938; cv=none; b=JsqDz6+XmEZEVvnLc6IdnSJzRk2jP/X9Dd/+Z1IrV4D31UuHT2kYNcVOXgIQYywDVBtN29GMzoIpg6WLKDUsnea3ID9lK58VbbgzgWNYWca/Xw4jiizd9jCK+ebDtSw2TukmYDA5NYTaPCIn3TE0tNZWLi0LfxEOIvpdtKhKBO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103938; c=relaxed/simple;
	bh=M6pyget1H1jFw7+H2ag28Bz5J+OyUICYVLKVtxUqrYE=;
	h=Date:To:From:Subject:Message-Id; b=GfZSDdquHigHyi4b7b73O/MRPJ+IhEIFf3OXTSV4OQ2cuPmrFJebM0PJ8fspr5vTY+pfvbKndiJEaJdNE7YrN4QZG9pLI9GS3zyQwBGAD5cVX7p9yCc3xXm2lkR278YAahhtP+Obxg0f1ynsIjWImQE1r47MsfgOZqaDov/KBBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AB1H084Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AB1H084Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC00C113CD;
	Fri, 26 Apr 2024 03:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103938;
	bh=M6pyget1H1jFw7+H2ag28Bz5J+OyUICYVLKVtxUqrYE=;
	h=Date:To:From:Subject:From;
	b=AB1H084QUpX2NfSqXcndd85Xb8GoAC0pC9NOWDOJuxx/jvKYlyy4HiW21E0dGXGAx
	 Yfjb/wgtLS/Ox04KZbLnT88bgyQipCDPQfNvIQ2mHDqMYlj8UZ9DW9n+Wxe4X2ZPG7
	 Ex0i3iQO8okp4UYtFp8H/AG9AlhrQR2tAkY2M4jE=
Date: Thu, 25 Apr 2024 20:58:57 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-folio_prep_large_rmappable.patch removed from -mm tree
Message-Id: <20240426035858.6EC00C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove folio_prep_large_rmappable()
has been removed from the -mm tree.  Its filename was
     mm-remove-folio_prep_large_rmappable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove folio_prep_large_rmappable()
Date: Thu, 21 Mar 2024 14:24:41 +0000

Now that prep_compound_page() initialises folio->_deferred_list,
folio_prep_large_rmappable()'s only purpose is to set the large_rmappable
flag, so inline it into the two callers.  Take the opportunity to convert
the large_rmappable definition from PAGEFLAG to FOLIO_FLAG and remove the
existance of PageTestLargeRmappable and friends.

Link: https://lkml.kernel.org/r/20240321142448.1645400-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h    |    3 ---
 include/linux/page-flags.h |    4 ++--
 mm/huge_memory.c           |    9 +--------
 mm/internal.h              |    3 ++-
 4 files changed, 5 insertions(+), 14 deletions(-)

--- a/include/linux/huge_mm.h~mm-remove-folio_prep_large_rmappable
+++ a/include/linux/huge_mm.h
@@ -263,7 +263,6 @@ unsigned long thp_vma_allowable_orders(s
 unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 
-void folio_prep_large_rmappable(struct folio *folio);
 bool can_split_folio(struct folio *folio, int *pextra_pins);
 int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order);
@@ -411,8 +410,6 @@ static inline unsigned long thp_vma_allo
 	return 0;
 }
 
-static inline void folio_prep_large_rmappable(struct folio *folio) {}
-
 #define transparent_hugepage_flags 0UL
 
 #define thp_get_unmapped_area	NULL
--- a/include/linux/page-flags.h~mm-remove-folio_prep_large_rmappable
+++ a/include/linux/page-flags.h
@@ -868,9 +868,9 @@ static inline void ClearPageCompound(str
 	BUG_ON(!PageHead(page));
 	ClearPageHead(page);
 }
-PAGEFLAG(LargeRmappable, large_rmappable, PF_SECOND)
+FOLIO_FLAG(large_rmappable, FOLIO_SECOND_PAGE)
 #else
-TESTPAGEFLAG_FALSE(LargeRmappable, large_rmappable)
+FOLIO_FLAG_FALSE(large_rmappable)
 #endif
 
 #define PG_head_mask ((1UL << PG_head))
--- a/mm/huge_memory.c~mm-remove-folio_prep_large_rmappable
+++ a/mm/huge_memory.c
@@ -789,13 +789,6 @@ struct deferred_split *get_deferred_spli
 }
 #endif
 
-void folio_prep_large_rmappable(struct folio *folio)
-{
-	if (!folio || !folio_test_large(folio))
-		return;
-	folio_set_large_rmappable(folio);
-}
-
 static inline bool is_transparent_hugepage(struct folio *folio)
 {
 	if (!folio_test_large(folio))
@@ -2862,7 +2855,7 @@ static void __split_huge_page_tail(struc
 	clear_compound_head(page_tail);
 	if (new_order) {
 		prep_compound_page(page_tail, new_order);
-		folio_prep_large_rmappable(new_folio);
+		folio_set_large_rmappable(new_folio);
 	}
 
 	/* Finally unfreeze refcount. Additional reference from page cache. */
--- a/mm/internal.h~mm-remove-folio_prep_large_rmappable
+++ a/mm/internal.h
@@ -513,7 +513,8 @@ static inline struct folio *page_rmappab
 {
 	struct folio *folio = (struct folio *)page;
 
-	folio_prep_large_rmappable(folio);
+	if (folio && folio_test_large(folio))
+		folio_set_large_rmappable(folio);
 	return folio;
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are

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

