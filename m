Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EBB9C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 05:49:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbjBCFtv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 00:49:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbjBCFtr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 00:49:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDA989FAE
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 21:49:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF45260C43
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 05:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31ACEC4339B;
        Fri,  3 Feb 2023 05:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675403385;
        bh=hj1NYyok54BI04yy2DFIXxsQE0XIA9wSeSOI232Baq0=;
        h=Date:To:From:Subject:From;
        b=c6RDckCrLO6XaWlKRRndv8RXPMgbqceXfn9Fr3rWJCV/MA1xrKvZHtpFr8Xo1snmv
         8j7M48aO2EGa1tjFC6whVo5qnA6sJDtkCLm/VZSCBLFbi1JpME7KT5t/ibq1VtXI7a
         mPe/Zxodva2JKE9OBa/6Ns8w9sALnRG+RgBPrTHk=
Date:   Thu, 02 Feb 2023 21:49:44 -0800
To:     mm-commits@vger.kernel.org, jack@suse.cz, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mpage-convert-__mpage_writepage-to-use-a-folio-more-fully-fix.patch removed from -mm tree
Message-Id: <20230203054945.31ACEC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mpage-convert-__mpage_writepage-to-use-a-folio-more-fully-fix
has been removed from the -mm tree.  Its filename was
     mpage-convert-__mpage_writepage-to-use-a-folio-more-fully-fix.patch

This patch was dropped because it was folded into mpage-convert-__mpage_writepage-to-use-a-folio-more-fully.patch

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mpage-convert-__mpage_writepage-to-use-a-folio-more-fully-fix
Date: Tue, 31 Jan 2023 15:06:16 +0000

fix accidentally-triggering WARN_ON_ONCE

Link: https://lkml.kernel.org/r/Y9kuaBgXf9lKJ8b0@casper.infradead.org
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Reported-by: >syzbot+707bba7f823c7b02fa43@syzkaller.appspotmail.com>
Reported-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/mpage.c~mpage-convert-__mpage_writepage-to-use-a-folio-more-fully-fix
+++ a/fs/mpage.c
@@ -554,6 +554,9 @@ static int __mpage_writepage(struct foli
 	first_unmapped = page_block;
 
 page_is_mapped:
+	/* Don't bother writing beyond EOF, truncate will discard the folio */
+	if (folio_pos(folio) >= i_size)
+		goto confused;
 	length = folio_size(folio);
 	if (folio_pos(folio) + length > i_size) {
 		/*
@@ -565,8 +568,6 @@ page_is_mapped:
 		 * written out to the file."
 		 */
 		length = i_size - folio_pos(folio);
-		if (WARN_ON_ONCE(folio_pos(folio) >= i_size))
-			goto confused;
 		folio_zero_segment(folio, length, folio_size(folio));
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
page_alloc-use-folio-fields-directly.patch
mm-use-a-folio-in-hugepage_add_anon_rmap-and-hugepage_add_new_anon_rmap.patch
mm-use-entire_mapcount-in-__page_dup_rmap.patch
mm-debug-remove-call-to-head_compound_mapcount.patch
hugetlb-remove-uses-of-folio_mapcount_ptr.patch
mm-convert-page_mapcount-to-use-folio_entire_mapcount.patch
mm-remove-head_compound_mapcount-and-_ptr-functions.patch
mm-reimplement-compound_order.patch
mm-reimplement-compound_nr.patch
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
mm-add-memcpy_from_file_folio.patch
fs-convert-writepage_t-callback-to-pass-a-folio.patch
mpage-convert-__mpage_writepage-to-use-a-folio-more-fully.patch

