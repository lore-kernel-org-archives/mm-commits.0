Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3C3BC072A2
	for <mm-commits@archiver.kernel.org>; Fri, 17 Nov 2023 17:30:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbjKQRa5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Nov 2023 12:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjKQRay (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2023 12:30:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D75110CE
        for <mm-commits@vger.kernel.org>; Fri, 17 Nov 2023 09:30:50 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1109C433C9;
        Fri, 17 Nov 2023 17:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700242249;
        bh=D68N2nT076mYtBQukkQH4H9fu+MidqVzrxRGI+fqUs4=;
        h=Date:To:From:Subject:From;
        b=P30XXvhbTowZYO6UCW7v54Xtm49q1nMnBKjV/N+PZ/WjxWoCp2y0+Pv11jQ/PqRtr
         Fi68I5PPP75LQwgYrEG8hWpv4eWP3R7yhJsM+HQ1kI69n5yFPoBKe+kmxL7lAp52bi
         8iusUlWbPt/+iiPcLdLOUAJqUrCMQ9GbG4RVj9EQ=
Date:   Fri, 17 Nov 2023 09:30:49 -0800
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-failure-convert-delete_from_lru_cache-to-take-a-folio.patch added to mm-unstable branch
Message-Id: <20231117173049.C1109C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memory-failure: convert delete_from_lru_cache() to take a folio
has been added to the -mm mm-unstable branch.  Its filename is
     memory-failure-convert-delete_from_lru_cache-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-failure-convert-delete_from_lru_cache-to-take-a-folio.patch

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
Subject: memory-failure: convert delete_from_lru_cache() to take a folio
Date: Fri, 17 Nov 2023 16:14:44 +0000

All three callers now have a folio; pass it in instead of the page.
Saves five calls to compound_head().

Link: https://lkml.kernel.org/r/20231117161447.2461643-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/mm/memory-failure.c~memory-failure-convert-delete_from_lru_cache-to-take-a-folio
+++ a/mm/memory-failure.c
@@ -902,26 +902,26 @@ static const char * const action_page_ty
  * The page count will stop it from being freed by unpoison.
  * Stress tests should be aware of this memory leak problem.
  */
-static int delete_from_lru_cache(struct page *p)
+static int delete_from_lru_cache(struct folio *folio)
 {
-	if (isolate_lru_page(p)) {
+	if (folio_isolate_lru(folio)) {
 		/*
 		 * Clear sensible page flags, so that the buddy system won't
-		 * complain when the page is unpoison-and-freed.
+		 * complain when the folio is unpoison-and-freed.
 		 */
-		ClearPageActive(p);
-		ClearPageUnevictable(p);
+		folio_clear_active(folio);
+		folio_clear_unevictable(folio);
 
 		/*
 		 * Poisoned page might never drop its ref count to 0 so we have
 		 * to uncharge it manually from its memcg.
 		 */
-		mem_cgroup_uncharge(page_folio(p));
+		mem_cgroup_uncharge(folio);
 
 		/*
-		 * drop the page count elevated by isolate_lru_page()
+		 * drop the refcount elevated by folio_isolate_lru()
 		 */
-		put_page(p);
+		folio_put(folio);
 		return 0;
 	}
 	return -EIO;
@@ -1019,7 +1019,7 @@ static int me_pagecache_clean(struct pag
 	struct address_space *mapping;
 	bool extra_pins;
 
-	delete_from_lru_cache(p);
+	delete_from_lru_cache(folio);
 
 	/*
 	 * For anonymous folios the only reference left
@@ -1146,7 +1146,7 @@ static int me_swapcache_dirty(struct pag
 	/* Trigger EIO in shmem: */
 	folio_clear_uptodate(folio);
 
-	ret = delete_from_lru_cache(p) ? MF_FAILED : MF_DELAYED;
+	ret = delete_from_lru_cache(folio) ? MF_FAILED : MF_DELAYED;
 	folio_unlock(folio);
 
 	if (ret == MF_DELAYED)
@@ -1165,7 +1165,7 @@ static int me_swapcache_clean(struct pag
 
 	delete_from_swap_cache(folio);
 
-	ret = delete_from_lru_cache(p) ? MF_FAILED : MF_RECOVERED;
+	ret = delete_from_lru_cache(folio) ? MF_FAILED : MF_RECOVERED;
 	folio_unlock(folio);
 
 	if (has_extra_refcount(ps, p, false))
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

