Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A1BCC197A0
	for <mm-commits@archiver.kernel.org>; Fri, 17 Nov 2023 17:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbjKQRa6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Nov 2023 12:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbjKQRa5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2023 12:30:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93B8E5
        for <mm-commits@vger.kernel.org>; Fri, 17 Nov 2023 09:30:53 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7076EC433C7;
        Fri, 17 Nov 2023 17:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700242253;
        bh=bzXUUVVWb25LaSPZTfEXVOy6NgFAVSfFTiKQpyGdTYw=;
        h=Date:To:From:Subject:From;
        b=jX0S2UJDdNVblFxCLnwDLnPHnSt5DRGeSSBJgml8l8hctKItnceWguGsXF4M8f9dF
         8PyPcuSvWTwzslrrkm2qIWeqxiVocWSRwy+3P1ZFoa1fUtWVq/kRcTDXHqldzUX1Ov
         b1Kon8dlcD9PsSY7r0R7iHSuo/04XITLg9TCYSUM=
Date:   Fri, 17 Nov 2023 09:30:52 -0800
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-failure-convert-truncate_error_page-to-truncate_error_folio.patch added to mm-unstable branch
Message-Id: <20231117173053.7076EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memory-failure: convert truncate_error_page to truncate_error_folio
has been added to the -mm mm-unstable branch.  Its filename is
     memory-failure-convert-truncate_error_page-to-truncate_error_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-failure-convert-truncate_error_page-to-truncate_error_folio.patch

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
Subject: memory-failure: convert truncate_error_page to truncate_error_folio
Date: Fri, 17 Nov 2023 16:14:46 +0000

Both callers now have a folio, so pass it in.  Nothing downstream was
expecting a tail page; that's asserted in generic_error_remove_page(), for
example.

Link: https://lkml.kernel.org/r/20231117161447.2461643-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/memory-failure.c~memory-failure-convert-truncate_error_page-to-truncate_error_folio
+++ a/mm/memory-failure.c
@@ -927,14 +927,13 @@ static int delete_from_lru_cache(struct
 	return -EIO;
 }
 
-static int truncate_error_page(struct page *p, unsigned long pfn,
+static int truncate_error_page(struct folio *folio, unsigned long pfn,
 				struct address_space *mapping)
 {
-	struct folio *folio = page_folio(p);
 	int ret = MF_FAILED;
 
 	if (mapping->a_ops->error_remove_page) {
-		int err = mapping->a_ops->error_remove_page(mapping, p);
+		int err = mapping->a_ops->error_remove_page(mapping, &folio->page);
 
 		if (err != 0)
 			pr_info("%#lx: Failed to punch page: %d\n", pfn, err);
@@ -1055,7 +1054,7 @@ static int me_pagecache_clean(struct pag
 	 *
 	 * Open: to take i_rwsem or not for this? Right now we don't.
 	 */
-	ret = truncate_error_page(p, page_to_pfn(p), mapping);
+	ret = truncate_error_page(folio, page_to_pfn(p), mapping);
 	if (has_extra_refcount(ps, p, extra_pins))
 		ret = MF_FAILED;
 
@@ -1189,7 +1188,7 @@ static int me_huge_page(struct page_stat
 
 	mapping = folio_mapping(folio);
 	if (mapping) {
-		res = truncate_error_page(&folio->page, page_to_pfn(p), mapping);
+		res = truncate_error_page(folio, page_to_pfn(p), mapping);
 		/* The page is kept in page cache. */
 		extra_pins = true;
 		folio_unlock(folio);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-folio_zero_tail-and-use-it-in-ext4.patch
mm-add-folio_fill_tail-and-use-it-in-iomap.patch
gfs2-convert-stuffed_readpage-to-stuffed_read_folio.patch
mm-remove-test_set_page_writeback.patch
afs-do-not-test-the-return-value-of-folio_start_writeback.patch
smb-do-not-test-the-return-value-of-folio_start_writeback.patch
mm-return-void-from-folio_start_writeback-and-related-functions.patch
mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios.patch
mm-convert-__do_fault-to-use-a-folio.patch
mm-use-mapping_evict_folio-in-truncate_error_page.patch
mm-convert-soft_offline_in_use_page-to-use-a-folio.patch
mm-convert-isolate_page-to-mf_isolate_folio.patch
mm-remove-invalidate_inode_page.patch
buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch
gfp-include-__gfp_nowarn-in-gfp_nowait.patch
memory-failure-use-a-folio-in-me_pagecache_clean.patch
memory-failure-use-a-folio-in-me_pagecache_dirty.patch
memory-failure-convert-delete_from_lru_cache-to-take-a-folio.patch
memory-failure-use-a-folio-in-me_huge_page.patch
memory-failure-convert-truncate_error_page-to-truncate_error_folio.patch
fs-convert-error_remove_page-to-error_remove_folio.patch
nilfs2-add-nilfs_end_folio_io.patch
nilfs2-convert-nilfs_abort_logs-to-use-folios.patch
nilfs2-convert-nilfs_segctor_complete_write-to-use-folios.patch
nilfs2-convert-nilfs_forget_buffer-to-use-a-folio.patch
nilfs2-convert-to-nilfs_folio_buffers_clean.patch
nilfs2-convert-nilfs_writepage-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_write_page-to-use-a-folio.patch
nilfs2-convert-to-nilfs_clear_folio_dirty.patch
nilfs2-convert-to-__nilfs_clear_folio_dirty.patch
nilfs2-convert-nilfs_segctor_prepare_write-to-use-folios.patch
nilfs2-convert-nilfs_page_mkwrite-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_create_block-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_submit_block-to-use-a-folio.patch
nilfs2-convert-nilfs_gccache_submit_read_data-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_create_block-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_submit_block-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_delete-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_prepare_change_key-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_commit_change_key-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_abort_change_key-to-use-a-folio.patch

