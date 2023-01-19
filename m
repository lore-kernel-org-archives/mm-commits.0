Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50236C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:15:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjASBPz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjASBOn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:14:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DBE6921C
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 854E4B81D77
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7EAC433D2;
        Thu, 19 Jan 2023 01:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090848;
        bh=SaoVZApty6yL28AwkpXH0nVmNG6D/esDsHa/4ODRjBI=;
        h=Date:To:From:Subject:From;
        b=qr3KyWp4HUELNMI2JRDkvMWlWReprHCwWU+rX7Y/6R1TdXWii4pJl/LTKCuHuXuU+
         VRT/FJd8nvqQ1H213sonyTHu1VjrMcIEUGEc8IBggdGpR774K1UD8Lqg3qfCTLthAn
         lkoM4MfoTgzlePmc0s1D61tFKYsrgoaBRinpYnk0=
Date:   Wed, 18 Jan 2023 17:14:07 -0800
To:     mm-commits@vger.kernel.org, jack@suse.cz, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-use-b_folio-in-mark_buffer_dirty.patch removed from -mm tree
Message-Id: <20230119011408.2D7EAC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: buffer: use b_folio in mark_buffer_dirty()
has been removed from the -mm tree.  Its filename was
     buffer-use-b_folio-in-mark_buffer_dirty.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: use b_folio in mark_buffer_dirty()
Date: Thu, 15 Dec 2022 21:43:57 +0000

Removes about four calls to compound_head().  Two of them are inline which
removes 132 bytes from the kernel text.

Link: https://lkml.kernel.org/r/20221215214402.3522366-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/buffer.c~buffer-use-b_folio-in-mark_buffer_dirty
+++ a/fs/buffer.c
@@ -1095,16 +1095,16 @@ void mark_buffer_dirty(struct buffer_hea
 	}
 
 	if (!test_set_buffer_dirty(bh)) {
-		struct page *page = bh->b_page;
+		struct folio *folio = bh->b_folio;
 		struct address_space *mapping = NULL;
 
-		lock_page_memcg(page);
-		if (!TestSetPageDirty(page)) {
-			mapping = page_mapping(page);
+		folio_memcg_lock(folio);
+		if (!folio_test_set_dirty(folio)) {
+			mapping = folio->mapping;
 			if (mapping)
-				__set_page_dirty(page, mapping, 0);
+				__folio_mark_dirty(folio, mapping, 0);
 		}
-		unlock_page_memcg(page);
+		folio_memcg_unlock(folio);
 		if (mapping)
 			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 	}
_

Patches currently in -mm which might be from willy@infradead.org are

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

