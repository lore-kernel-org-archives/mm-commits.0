Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A35C25B6E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbjJYXsF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbjJYXry (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:47:54 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EF0183
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:47:52 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2481C433CB;
        Wed, 25 Oct 2023 23:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277672;
        bh=bUAn3xAlERILcbrkqPxRKYP36QyXZEhiKc0pSpj/fMw=;
        h=Date:To:From:Subject:From;
        b=E/zf3B7sKd+F6ZBN/LRdff/ZKfOut1qfW9J0X6z9Kds+mZ0iIuUdtre9P7BcrEay4
         ibCECZKbsVsQFVEi2pN05F9PtuVeqwueFxto5BByl/OEnMZalUmRR8l6+jA8RvKZXG
         RwTeoNPDwxp+NSShaHXlNSvqRp/lg0O5Rfwyvz+U=
Date:   Wed, 25 Oct 2023 16:47:52 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ext4-convert-to-folio_create_empty_buffers.patch removed from -mm tree
Message-Id: <20231025234752.A2481C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ext4: convert to folio_create_empty_buffers
has been removed from the -mm tree.  Its filename was
     ext4-convert-to-folio_create_empty_buffers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ext4: convert to folio_create_empty_buffers
Date: Mon, 16 Oct 2023 21:10:51 +0100

Remove an unnecessary folio->page->folio conversion and take advantage of
the new return value from folio_create_empty_buffers().

Link: https://lkml.kernel.org/r/20231016201114.1928083-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c       |   14 +++++---------
 fs/ext4/move_extent.c |   11 +++++------
 2 files changed, 10 insertions(+), 15 deletions(-)

--- a/fs/ext4/inode.c~ext4-convert-to-folio_create_empty_buffers
+++ a/fs/ext4/inode.c
@@ -1020,10 +1020,8 @@ static int ext4_block_write_begin(struct
 	BUG_ON(from > to);
 
 	head = folio_buffers(folio);
-	if (!head) {
-		create_empty_buffers(&folio->page, blocksize, 0);
-		head = folio_buffers(folio);
-	}
+	if (!head)
+		head = folio_create_empty_buffers(folio, blocksize, 0);
 	bbits = ilog2(blocksize);
 	block = (sector_t)folio->index << (PAGE_SHIFT - bbits);
 
@@ -1153,7 +1151,7 @@ retry_grab:
 	 * starting the handle.
 	 */
 	if (!folio_buffers(folio))
-		create_empty_buffers(&folio->page, inode->i_sb->s_blocksize, 0);
+		folio_create_empty_buffers(folio, inode->i_sb->s_blocksize, 0);
 
 	folio_unlock(folio);
 
@@ -3643,10 +3641,8 @@ static int __ext4_block_zero_page_range(
 	iblock = index << (PAGE_SHIFT - inode->i_sb->s_blocksize_bits);
 
 	bh = folio_buffers(folio);
-	if (!bh) {
-		create_empty_buffers(&folio->page, blocksize, 0);
-		bh = folio_buffers(folio);
-	}
+	if (!bh)
+		bh = folio_create_empty_buffers(folio, blocksize, 0);
 
 	/* Find the buffer that contains "offset" */
 	pos = blocksize;
--- a/fs/ext4/move_extent.c~ext4-convert-to-folio_create_empty_buffers
+++ a/fs/ext4/move_extent.c
@@ -183,10 +183,8 @@ mext_page_mkuptodate(struct folio *folio
 
 	blocksize = i_blocksize(inode);
 	head = folio_buffers(folio);
-	if (!head) {
-		create_empty_buffers(&folio->page, blocksize, 0);
-		head = folio_buffers(folio);
-	}
+	if (!head)
+		head = folio_create_empty_buffers(folio, blocksize, 0);
 
 	block = (sector_t)folio->index << (PAGE_SHIFT - inode->i_blkbits);
 	for (bh = head, block_start = 0; bh != head || !block_start;
@@ -380,9 +378,10 @@ data_copy:
 	}
 	/* Perform all necessary steps similar write_begin()/write_end()
 	 * but keeping in mind that i_size will not change */
-	if (!folio_buffers(folio[0]))
-		create_empty_buffers(&folio[0]->page, 1 << orig_inode->i_blkbits, 0);
 	bh = folio_buffers(folio[0]);
+	if (!bh)
+		bh = folio_create_empty_buffers(folio[0],
+				1 << orig_inode->i_blkbits, 0);
 	for (i = 0; i < data_offset_in_page; i++)
 		bh = bh->b_this_page;
 	for (i = 0; i < block_len_in_page; i++) {
_

Patches currently in -mm which might be from willy@infradead.org are


