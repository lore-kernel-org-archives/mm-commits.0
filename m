Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF11C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjASBQR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjASBOp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:14:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B2F69B20
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64743B81D77
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD14C433F1;
        Thu, 19 Jan 2023 01:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090855;
        bh=5bkT5Jzgy7twTEKextDKqhcwKHvawXxtOhOvgyuMISI=;
        h=Date:To:From:Subject:From;
        b=g0bW4HuEZ63oKTAX6CnFbwvMCtB92JTw9yoiHgRu3MmiUYmjmVNlZVVDzfTzg0q2L
         swAeKumXGguBrMxS9/YwdHbU/U+1fAk1P/5RgE9PWT2j13r0FcWC9hXSFEpud192LU
         6SVTdnGuHnt9AclVDH73hPYO1l9vZlJ/N6NmCrOQ=
Date:   Wed, 18 Jan 2023 17:14:14 -0800
To:     mm-commits@vger.kernel.org, jack@suse.cz, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mpage-use-b_folio-in-do_mpage_readpage.patch removed from -mm tree
Message-Id: <20230119011415.0FD14C433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mpage: use b_folio in do_mpage_readpage()
has been removed from the -mm tree.  Its filename was
     mpage-use-b_folio-in-do_mpage_readpage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mpage: use b_folio in do_mpage_readpage()
Date: Thu, 15 Dec 2022 21:44:02 +0000

Remove this conversion of a folio back to a page.

Link: https://lkml.kernel.org/r/20221215214402.3522366-13-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/mpage.c~mpage-use-b_folio-in-do_mpage_readpage
+++ a/fs/mpage.c
@@ -198,7 +198,7 @@ static struct bio *do_mpage_readpage(str
 	/*
 	 * Then do more get_blocks calls until we are done with this folio.
 	 */
-	map_bh->b_page = &folio->page;
+	map_bh->b_folio = folio;
 	while (page_block < blocks_per_page) {
 		map_bh->b_state = 0;
 		map_bh->b_size = 0;
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

