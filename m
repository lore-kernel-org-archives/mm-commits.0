Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB839C63797
	for <mm-commits@archiver.kernel.org>; Mon, 16 Jan 2023 21:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbjAPVmF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Jan 2023 16:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234605AbjAPVlx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jan 2023 16:41:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFD02C672
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 13:41:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C523B810F3
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 21:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045D5C433F0;
        Mon, 16 Jan 2023 21:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673905310;
        bh=KfzyVCccBh9Gc0Nq30KohtVe2I9j97EP+IcIzXkWl2k=;
        h=Date:To:From:Subject:From;
        b=QJ9Z+Z294aRGB1+e90ye6VQHfshCP3H8ZOTE2pDlAZ9oQuTsrna6H2/S/ShuzDHdY
         UvkOKRYZPXyZGj4BFNyDRAarho0yfmUcp/2QnK0cxd55sonLLuB8q3IBIpnkYwl6ac
         TqKgd50l/xZg1AMg15epRG+eHRrmHRuAfwqojCm8=
Date:   Mon, 16 Jan 2023 13:41:49 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-use-a-folio-in-copy_present_pte.patch removed from -mm tree
Message-Id: <20230116214150.045D5C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: use a folio in copy_present_pte()
has been removed from the -mm tree.  Its filename was
     mm-use-a-folio-in-copy_present_pte.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: use a folio in copy_present_pte()
Date: Mon, 16 Jan 2023 19:18:13 +0000

We still have to keep the page around because we need to know which page
in the folio we're copying, but we can replace five implict calls to
compound_head() with one.

Link: https://lkml.kernel.org/r/20230116191813.2145215-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory.c~mm-use-a-folio-in-copy_present_pte
+++ a/mm/memory.c
@@ -906,25 +906,28 @@ copy_present_pte(struct vm_area_struct *
 	unsigned long vm_flags = src_vma->vm_flags;
 	pte_t pte = *src_pte;
 	struct page *page;
+	struct folio *folio;
 
 	page = vm_normal_page(src_vma, addr, pte);
-	if (page && PageAnon(page)) {
+	if (page)
+		folio = page_folio(page);
+	if (page && folio_test_anon(folio)) {
 		/*
 		 * If this page may have been pinned by the parent process,
 		 * copy the page immediately for the child so that we'll always
 		 * guarantee the pinned page won't be randomly replaced in the
 		 * future.
 		 */
-		get_page(page);
+		folio_get(folio);
 		if (unlikely(page_try_dup_anon_rmap(page, false, src_vma))) {
-			/* Page maybe pinned, we have to copy. */
-			put_page(page);
+			/* Page may be pinned, we have to copy. */
+			folio_put(folio);
 			return copy_present_page(dst_vma, src_vma, dst_pte, src_pte,
 						 addr, rss, prealloc, page);
 		}
 		rss[MM_ANONPAGES]++;
 	} else if (page) {
-		get_page(page);
+		folio_get(folio);
 		page_dup_file_rmap(page, false);
 		rss[mm_counter_file(page)]++;
 	}
@@ -937,7 +940,7 @@ copy_present_pte(struct vm_area_struct *
 		ptep_set_wrprotect(src_mm, addr, src_pte);
 		pte = pte_wrprotect(pte);
 	}
-	VM_BUG_ON(page && PageAnon(page) && PageAnonExclusive(page));
+	VM_BUG_ON(page && folio_test_anon(folio) && PageAnonExclusive(page));
 
 	/*
 	 * If it's a shared mapping, mark it clean in
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-add-b_folio-as-an-alias-of-b_page.patch
buffer-replace-obvious-uses-of-b_page-with-b_folio.patch
buffer-use-b_folio-in-touch_buffer.patch
buffer-use-b_folio-in-end_buffer_async_read.patch
buffer-use-b_folio-in-end_buffer_async_write.patch
page_io-remove-buffer_head-include.patch
buffer-use-b_folio-in-mark_buffer_dirty.patch
gfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
jbd2-replace-obvious-uses-of-b_page-with-b_folio.patch
nilfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
reiserfs-replace-obvious-uses-of-b_page-with-b_folio.patch
mpage-use-b_folio-in-do_mpage_readpage.patch
mm-memcg-add-folio_memcg_check.patch
mm-remove-folio_pincount_ptr-and-head_compound_pincount.patch
mm-convert-head_subpages_mapcount-into-folio_nr_pages_mapped.patch
doc-clarify-refcount-section-by-referring-to-folios-pages.patch
mm-convert-total_compound_mapcount-to-folio_total_mapcount.patch
mm-convert-page_remove_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_anon_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_file_rmap-to-use-a-folio-internally.patch
mm-add-folio_add_new_anon_rmap.patch
mm-add-folio_add_new_anon_rmap-fix-2.patch
page_alloc-use-folio-fields-directly.patch
mm-use-a-folio-in-hugepage_add_anon_rmap-and-hugepage_add_new_anon_rmap.patch
mm-use-entire_mapcount-in-__page_dup_rmap.patch
mm-debug-remove-call-to-head_compound_mapcount.patch
hugetlb-remove-uses-of-folio_mapcount_ptr.patch
mm-convert-page_mapcount-to-use-folio_entire_mapcount.patch
mm-remove-head_compound_mapcount-and-_ptr-functions.patch
mm-reimplement-compound_order.patch
mm-reimplement-compound_nr.patch
mm-reimplement-compound_nr-fix.patch
mm-convert-set_compound_page_dtor-and-set_compound_order-to-folios.patch
mm-convert-is_transparent_hugepage-to-use-a-folio.patch
mm-convert-destroy_large_folio-to-use-folio_dtor.patch
hugetlb-remove-uses-of-compound_dtor-and-compound_nr.patch
mm-remove-first-tail-page-members-from-struct-page.patch
doc-correct-struct-folio-kernel-doc.patch
mm-move-page-deferred_list-to-folio-_deferred_list.patch
mm-huge_memory-remove-page_deferred_list.patch
mm-huge_memory-convert-get_deferred_split_queue-to-take-a-folio.patch
mm-convert-deferred_split_huge_page-to-deferred_split_folio.patch
shmem-convert-shmem_write_end-to-use-a-folio.patch
mm-fs-convert-inode_attach_wb-to-take-a-folio.patch
mm-convert-mem_cgroup_css_from_page-to-mem_cgroup_css_from_folio.patch
mm-remove-page_evictable.patch
mm-remove-mlock_vma_page.patch
mm-remove-munlock_vma_page.patch
mm-clean-up-mlock_page-munlock_page-references-in-comments.patch
rmap-add-folio-parameter-to-__page_set_anon_rmap.patch
filemap-convert-filemap_map_pmd-to-take-a-folio.patch
filemap-convert-filemap_range_has_page-to-use-a-folio.patch
readahead-convert-readahead_expand-to-use-a-folio.patch

