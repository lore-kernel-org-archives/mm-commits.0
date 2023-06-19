Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D2D7EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjFSX0w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjFSXZA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:25:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85F81BC1
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56A0560F79
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD36CC433C0;
        Mon, 19 Jun 2023 23:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216995;
        bh=XGFZQ5PdBkEw2V/1C+JdA82LDBEa2AnboHi8rttU9uM=;
        h=Date:To:From:Subject:From;
        b=KDNL/Zxs2qYVwoxaYvMrsDtG1ydekrPurjQKdkYsX3P66TamQ4SL7Ooyuf628Zk7F
         LvTdatF8ksq2vS3IX9YTMdZN5oiAgIyYzwX5uEgoU1dKTdytgXSO1XnsC0ACM4R7IB
         JkjuTwuc61EZDVqfluxkCac5D8cnTWDi0lNQUkN4=
Date:   Mon, 19 Jun 2023 16:23:15 -0700
To:     mm-commits@vger.kernel.org, rpeterso@redhat.com, mcgrof@kernel.org,
        hare@suse.com, agruenba@redhat.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-convert-block_truncate_page-to-use-a-folio.patch removed from -mm tree
Message-Id: <20230619232315.AD36CC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: buffer: convert block_truncate_page() to use a folio
has been removed from the -mm tree.  Its filename was
     buffer-convert-block_truncate_page-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: convert block_truncate_page() to use a folio
Date: Mon, 12 Jun 2023 22:01:41 +0100

Support large folios in block_truncate_page() and avoid three hidden calls
to compound_head().

[willy@infradead.org: fix check of filemap_grab_folio() return value]
  Link: https://lkml.kernel.org/r/ZItZOt+XxV12HtzL@casper.infradead.org
Link: https://lkml.kernel.org/r/20230612210141.730128-15-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Bob Peterson <rpeterso@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

--- a/fs/buffer.c~buffer-convert-block_truncate_page-to-use-a-folio
+++ a/fs/buffer.c
@@ -2598,17 +2598,16 @@ int block_truncate_page(struct address_s
 			loff_t from, get_block_t *get_block)
 {
 	pgoff_t index = from >> PAGE_SHIFT;
-	unsigned offset = from & (PAGE_SIZE-1);
 	unsigned blocksize;
 	sector_t iblock;
-	unsigned length, pos;
+	size_t offset, length, pos;
 	struct inode *inode = mapping->host;
-	struct page *page;
+	struct folio *folio;
 	struct buffer_head *bh;
 	int err = 0;
 
 	blocksize = i_blocksize(inode);
-	length = offset & (blocksize - 1);
+	length = from & (blocksize - 1);
 
 	/* Block boundary? Nothing to do */
 	if (!length)
@@ -2617,15 +2616,18 @@ int block_truncate_page(struct address_s
 	length = blocksize - length;
 	iblock = (sector_t)index << (PAGE_SHIFT - inode->i_blkbits);
 	
-	page = grab_cache_page(mapping, index);
-	if (!page)
-		return -ENOMEM;
-
-	if (!page_has_buffers(page))
-		create_empty_buffers(page, blocksize, 0);
+	folio = filemap_grab_folio(mapping, index);
+	if (IS_ERR(folio))
+		return PTR_ERR(folio);
+
+	bh = folio_buffers(folio);
+	if (!bh) {
+		folio_create_empty_buffers(folio, blocksize, 0);
+		bh = folio_buffers(folio);
+	}
 
 	/* Find the buffer that contains "offset" */
-	bh = page_buffers(page);
+	offset = offset_in_folio(folio, from);
 	pos = blocksize;
 	while (offset >= pos) {
 		bh = bh->b_this_page;
@@ -2644,7 +2646,7 @@ int block_truncate_page(struct address_s
 	}
 
 	/* Ok, it's mapped. Make sure it's up-to-date */
-	if (PageUptodate(page))
+	if (folio_test_uptodate(folio))
 		set_buffer_uptodate(bh);
 
 	if (!buffer_uptodate(bh) && !buffer_delay(bh) && !buffer_unwritten(bh)) {
@@ -2654,12 +2656,12 @@ int block_truncate_page(struct address_s
 			goto unlock;
 	}
 
-	zero_user(page, offset, length);
+	folio_zero_range(folio, offset, length);
 	mark_buffer_dirty(bh);
 
 unlock:
-	unlock_page(page);
-	put_page(page);
+	folio_unlock(folio);
+	folio_put(folio);
 
 	return err;
 }
_

Patches currently in -mm which might be from willy@infradead.org are


