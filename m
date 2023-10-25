Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 053B6C25B70
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbjJYXs1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbjJYXsQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9262D18D
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:07 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2A2C433CC;
        Wed, 25 Oct 2023 23:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277687;
        bh=1SBYoa3EsBW87wbBcfQ6Bioc6THbk3BGGaMuprkP4Fk=;
        h=Date:To:From:Subject:From;
        b=TsesDEujDkqEqGXgFbUdLsMyRsd33VSIOAcFX6guT1j8LkErIW4QULeI+3ntawr7I
         oOG7ZGp7aArY8F/homYja6nj2eo400WAikGjn95LY9yHXS7iZd0YgrTEVvUTrRHySM
         uwnqiWLKzzKEGXIQph0RztEsv/ShMEwl836r0GJg=
Date:   Wed, 25 Oct 2023 16:48:06 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ocfs2-convert-ocfs2_map_page_blocks-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231025234807.5F2A2C433CC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: convert ocfs2_map_page_blocks to use a folio
has been removed from the -mm tree.  Its filename was
     ocfs2-convert-ocfs2_map_page_blocks-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ocfs2: convert ocfs2_map_page_blocks to use a folio
Date: Mon, 16 Oct 2023 21:11:08 +0100

Convert the page argument to a folio and then use the folio APIs
throughout.  Replaces three hidden calls to compound_head() with one
explicit one.

Link: https://lkml.kernel.org/r/20231016201114.1928083-22-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-convert-ocfs2_map_page_blocks-to-use-a-folio
+++ a/fs/ocfs2/aops.c
@@ -568,10 +568,10 @@ static void ocfs2_clear_page_regions(str
  * read-in the blocks at the tail of our file. Avoid reading them by
  * testing i_size against each block offset.
  */
-static int ocfs2_should_read_blk(struct inode *inode, struct page *page,
+static int ocfs2_should_read_blk(struct inode *inode, struct folio *folio,
 				 unsigned int block_start)
 {
-	u64 offset = page_offset(page) + block_start;
+	u64 offset = folio_pos(folio) + block_start;
 
 	if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
 		return 1;
@@ -593,15 +593,16 @@ int ocfs2_map_page_blocks(struct page *p
 			  struct inode *inode, unsigned int from,
 			  unsigned int to, int new)
 {
+	struct folio *folio = page_folio(page);
 	int ret = 0;
 	struct buffer_head *head, *bh, *wait[2], **wait_bh = wait;
 	unsigned int block_end, block_start;
 	unsigned int bsize = i_blocksize(inode);
 
-	if (!page_has_buffers(page))
-		create_empty_buffers(page, bsize, 0);
+	head = folio_buffers(folio);
+	if (!head)
+		head = folio_create_empty_buffers(folio, bsize, 0);
 
-	head = page_buffers(page);
 	for (bh = head, block_start = 0; bh != head || !block_start;
 	     bh = bh->b_this_page, block_start += bsize) {
 		block_end = block_start + bsize;
@@ -613,7 +614,7 @@ int ocfs2_map_page_blocks(struct page *p
 		 * they may belong to unallocated clusters.
 		 */
 		if (block_start >= to || block_end <= from) {
-			if (PageUptodate(page))
+			if (folio_test_uptodate(folio))
 				set_buffer_uptodate(bh);
 			continue;
 		}
@@ -630,11 +631,11 @@ int ocfs2_map_page_blocks(struct page *p
 			clean_bdev_bh_alias(bh);
 		}
 
-		if (PageUptodate(page)) {
+		if (folio_test_uptodate(folio)) {
 			set_buffer_uptodate(bh);
 		} else if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
 			   !buffer_new(bh) &&
-			   ocfs2_should_read_blk(inode, page, block_start) &&
+			   ocfs2_should_read_blk(inode, folio, block_start) &&
 			   (block_start < from || block_end > to)) {
 			bh_read_nowait(bh, 0);
 			*wait_bh++=bh;
@@ -668,7 +669,7 @@ int ocfs2_map_page_blocks(struct page *p
 		if (block_start >= to)
 			break;
 
-		zero_user(page, block_start, bh->b_size);
+		folio_zero_range(folio, block_start, bh->b_size);
 		set_buffer_uptodate(bh);
 		mark_buffer_dirty(bh);
 
_

Patches currently in -mm which might be from willy@infradead.org are


