Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E9BEC4167D
	for <mm-commits@archiver.kernel.org>; Tue, 14 Nov 2023 23:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjKNXW5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Nov 2023 18:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbjKNXW4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Nov 2023 18:22:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9378DDF
        for <mm-commits@vger.kernel.org>; Tue, 14 Nov 2023 15:22:52 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B015C433CA;
        Tue, 14 Nov 2023 23:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700004172;
        bh=FqsrRNhZka/M9Sc1lgSGaOhkd1B/CtP4Lr7WSXr2xt4=;
        h=Date:To:From:Subject:From;
        b=Qq4e/wELuzTfIJLItdyU3Dyyt1rPPRxLGhyI449Uwrw/PdUYP2dq6+koG819GSqMl
         dmX2EqKyu6ULF9UBG7fktft/ghl50PZTgL7Kn8avKGpJI1QrN4pXbuirNTw3SOIkEK
         1PJoPeZ5P2AYVWnIpBavGBTJMDeCiMW1LXzjVHWc=
Date:   Tue, 14 Nov 2023 15:22:51 -0800
To:     mm-commits@vger.kernel.org, konishi.ryusuke@gmail.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-convert-nilfs_abort_logs-to-use-folios.patch added to mm-nonmm-unstable branch
Message-Id: <20231114232252.2B015C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: convert nilfs_abort_logs to use folios
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-convert-nilfs_abort_logs-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-convert-nilfs_abort_logs-to-use-folios.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: nilfs2: convert nilfs_abort_logs to use folios
Date: Tue, 14 Nov 2023 17:44:18 +0900

Use the new folio APIs, saving five hidden calls to compound_head().

Link: https://lkml.kernel.org/r/20231114084436.2755-3-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/fs/nilfs2/segment.c~nilfs2-convert-nilfs_abort_logs-to-use-folios
+++ a/fs/nilfs2/segment.c
@@ -1788,7 +1788,7 @@ static void nilfs_end_page_io(struct pag
 static void nilfs_abort_logs(struct list_head *logs, int err)
 {
 	struct nilfs_segment_buffer *segbuf;
-	struct page *bd_page = NULL, *fs_page = NULL;
+	struct folio *bd_folio = NULL, *fs_folio = NULL;
 	struct buffer_head *bh;
 
 	if (list_empty(logs))
@@ -1798,10 +1798,10 @@ static void nilfs_abort_logs(struct list
 		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
 				    b_assoc_buffers) {
 			clear_buffer_uptodate(bh);
-			if (bh->b_page != bd_page) {
-				if (bd_page)
-					end_page_writeback(bd_page);
-				bd_page = bh->b_page;
+			if (bh->b_folio != bd_folio) {
+				if (bd_folio)
+					folio_end_writeback(bd_folio);
+				bd_folio = bh->b_folio;
 			}
 		}
 
@@ -1810,22 +1810,22 @@ static void nilfs_abort_logs(struct list
 			clear_buffer_async_write(bh);
 			if (bh == segbuf->sb_super_root) {
 				clear_buffer_uptodate(bh);
-				if (bh->b_page != bd_page) {
-					end_page_writeback(bd_page);
-					bd_page = bh->b_page;
+				if (bh->b_folio != bd_folio) {
+					folio_end_writeback(bd_folio);
+					bd_folio = bh->b_folio;
 				}
 				break;
 			}
-			if (bh->b_page != fs_page) {
-				nilfs_end_page_io(fs_page, err);
-				fs_page = bh->b_page;
+			if (bh->b_folio != fs_folio) {
+				nilfs_end_folio_io(fs_folio, err);
+				fs_folio = bh->b_folio;
 			}
 		}
 	}
-	if (bd_page)
-		end_page_writeback(bd_page);
+	if (bd_folio)
+		folio_end_writeback(bd_folio);
 
-	nilfs_end_page_io(fs_page, err);
+	nilfs_end_folio_io(fs_folio, err);
 }
 
 static void nilfs_segctor_abort_construction(struct nilfs_sc_info *sci,
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

