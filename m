Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37F29C197A0
	for <mm-commits@archiver.kernel.org>; Fri, 17 Nov 2023 17:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbjKQRax (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Nov 2023 12:30:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjKQRav (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2023 12:30:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B2B90
        for <mm-commits@vger.kernel.org>; Fri, 17 Nov 2023 09:30:48 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34308C433C8;
        Fri, 17 Nov 2023 17:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700242248;
        bh=kk2+aSFY1di92MesPQahsZC4ok87rv8BruN0h+n/dKo=;
        h=Date:To:From:Subject:From;
        b=ORdymqRc9ylUUkdFgVD56DPf3EsqIR4aLJvCiu+my+JUSdCzw6AG364hnOV74ZEMT
         DGuQv2Lt/yHbe1t3JjODSn5QR2BANTRzHYO4MlROnxpl3g3G9l+ny8UUE2oqTvh2FQ
         ESIMtenfUJ3DfrV056R/qnWVyeoHEpIEL82GVlrs=
Date:   Fri, 17 Nov 2023 09:30:47 -0800
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-failure-use-a-folio-in-me_pagecache_dirty.patch added to mm-unstable branch
Message-Id: <20231117173048.34308C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memory-failure: use a folio in me_pagecache_dirty()
has been added to the -mm mm-unstable branch.  Its filename is
     memory-failure-use-a-folio-in-me_pagecache_dirty.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-failure-use-a-folio-in-me_pagecache_dirty.patch

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
Subject: memory-failure: use a folio in me_pagecache_dirty()
Date: Fri, 17 Nov 2023 16:14:43 +0000

Replaces three hidden calls to compound_head() with one visible one.

Link: https://lkml.kernel.org/r/20231117161447.2461643-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~memory-failure-use-a-folio-in-me_pagecache_dirty
+++ a/mm/memory-failure.c
@@ -1138,15 +1138,16 @@ static int me_pagecache_dirty(struct pag
  */
 static int me_swapcache_dirty(struct page_state *ps, struct page *p)
 {
+	struct folio *folio = page_folio(p);
 	int ret;
 	bool extra_pins = false;
 
-	ClearPageDirty(p);
+	folio_clear_dirty(folio);
 	/* Trigger EIO in shmem: */
-	ClearPageUptodate(p);
+	folio_clear_uptodate(folio);
 
 	ret = delete_from_lru_cache(p) ? MF_FAILED : MF_DELAYED;
-	unlock_page(p);
+	folio_unlock(folio);
 
 	if (ret == MF_DELAYED)
 		extra_pins = true;
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

