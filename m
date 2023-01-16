Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA04BC54EBE
	for <mm-commits@archiver.kernel.org>; Mon, 16 Jan 2023 20:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbjAPUIj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Jan 2023 15:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbjAPUIh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jan 2023 15:08:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C8EEE
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 12:08:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91A00B810DE
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 20:08:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF94C433EF;
        Mon, 16 Jan 2023 20:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673899713;
        bh=xREbXk0YxdhgiQdZ6QoNKg7tRwXEhiY+9HO27Od5EWc=;
        h=Date:To:From:Subject:From;
        b=B7jtwq7yM/v18TBoj/+Q/0RmwUNat6jg6vMi2G4IXYBagouw1tAcpmGU2SQQ4YOzp
         X7vPd2bHGkf8i9ReiEl73afL992QL8mw/wASfV6NWHVAAnMcQNqM7LJ0pLkrZ/afqz
         IzGMhuai/5BFkFHjWk8DYU/ayZpt1StHdy99y/Do=
Date:   Mon, 16 Jan 2023 12:08:32 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + readahead-convert-readahead_expand-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20230116200833.3DF94C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: readahead: convert readahead_expand() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     readahead-convert-readahead_expand-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/readahead-convert-readahead_expand-to-use-a-folio.patch

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
Subject: readahead: convert readahead_expand() to use a folio
Date: Mon, 16 Jan 2023 19:39:41 +0000

Replace the uses of page with a folio.  Also add a missing test for
workingset in the leading edge expansion.

Link: https://lkml.kernel.org/r/20230116193941.2148487-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/readahead.c~readahead-convert-readahead_expand-to-use-a-folio
+++ a/mm/readahead.c
@@ -801,21 +801,25 @@ void readahead_expand(struct readahead_c
 	/* Expand the leading edge downwards */
 	while (ractl->_index > new_index) {
 		unsigned long index = ractl->_index - 1;
-		struct page *page = xa_load(&mapping->i_pages, index);
+		struct folio *folio = xa_load(&mapping->i_pages, index);
 
-		if (page && !xa_is_value(page))
-			return; /* Page apparently present */
+		if (folio && !xa_is_value(folio))
+			return; /* Folio apparently present */
 
-		page = __page_cache_alloc(gfp_mask);
-		if (!page)
+		folio = filemap_alloc_folio(gfp_mask, 0);
+		if (!folio)
 			return;
-		if (add_to_page_cache_lru(page, mapping, index, gfp_mask) < 0) {
-			put_page(page);
+		if (filemap_add_folio(mapping, folio, index, gfp_mask) < 0) {
+			folio_put(folio);
 			return;
 		}
-
+		if (unlikely(folio_test_workingset(folio)) &&
+				!ractl->_workingset) {
+			ractl->_workingset = true;
+			psi_memstall_enter(&ractl->_pflags);
+		}
 		ractl->_nr_pages++;
-		ractl->_index = page->index;
+		ractl->_index = folio->index;
 	}
 
 	new_len += new_start - readahead_pos(ractl);
@@ -824,19 +828,20 @@ void readahead_expand(struct readahead_c
 	/* Expand the trailing edge upwards */
 	while (ractl->_nr_pages < new_nr_pages) {
 		unsigned long index = ractl->_index + ractl->_nr_pages;
-		struct page *page = xa_load(&mapping->i_pages, index);
+		struct folio *folio = xa_load(&mapping->i_pages, index);
 
-		if (page && !xa_is_value(page))
-			return; /* Page apparently present */
+		if (folio && !xa_is_value(folio))
+			return; /* Folio apparently present */
 
-		page = __page_cache_alloc(gfp_mask);
-		if (!page)
+		folio = filemap_alloc_folio(gfp_mask, 0);
+		if (!folio)
 			return;
-		if (add_to_page_cache_lru(page, mapping, index, gfp_mask) < 0) {
-			put_page(page);
+		if (filemap_add_folio(mapping, folio, index, gfp_mask) < 0) {
+			folio_put(folio);
 			return;
 		}
-		if (unlikely(PageWorkingset(page)) && !ractl->_workingset) {
+		if (unlikely(folio_test_workingset(folio)) &&
+				!ractl->_workingset) {
 			ractl->_workingset = true;
 			psi_memstall_enter(&ractl->_pflags);
 		}
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
mm-add-vma_alloc_zeroed_movable_folio.patch
mm-convert-do_anonymous_page-to-use-a-folio.patch
mm-convert-wp_page_copy-to-use-folios.patch
mm-use-a-folio-in-copy_pte_range.patch
mm-use-a-folio-in-copy_present_pte.patch
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

