Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C433C25B6F
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjJYXsX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbjJYXsG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B966419A
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5680EC433C7;
        Wed, 25 Oct 2023 23:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277680;
        bh=3UQTCAaf8hnmHMrbX8Wdgs53qIruyaflMZphhdVYgxk=;
        h=Date:To:From:Subject:From;
        b=kILFq1nnNx/dpuHqx6Syrb+AWr9t5+PIlikwbIt2kZyvie7AMv/1pt2S6uHJBMemv
         ggEOHULh3TmViR0d8ijCTQie8Y3XASaZWr3UTcwjHeO1Najd37cyJo46OeIVWBUi3c
         4FMqbSwjrrZRVx6GlvQyZn+9lsZeO6U174MCXKuo=
Date:   Wed, 25 Oct 2023 16:47:59 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nilfs2-convert-nilfs_mdt_forget_block-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231025234800.5680EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: convert nilfs_mdt_forget_block() to use a folio
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_mdt_forget_block-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert nilfs_mdt_forget_block() to use a folio
Date: Mon, 16 Oct 2023 21:11:00 +0100

Remove a number of folio->page->folio conversions.

Link: https://lkml.kernel.org/r/20231016201114.1928083-14-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/mdt.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/fs/nilfs2/mdt.c~nilfs2-convert-nilfs_mdt_forget_block-to-use-a-folio
+++ a/fs/nilfs2/mdt.c
@@ -356,30 +356,28 @@ int nilfs_mdt_delete_block(struct inode
  */
 int nilfs_mdt_forget_block(struct inode *inode, unsigned long block)
 {
-	pgoff_t index = (pgoff_t)block >>
-		(PAGE_SHIFT - inode->i_blkbits);
-	struct page *page;
-	unsigned long first_block;
+	pgoff_t index = block >> (PAGE_SHIFT - inode->i_blkbits);
+	struct folio *folio;
+	struct buffer_head *bh;
 	int ret = 0;
 	int still_dirty;
 
-	page = find_lock_page(inode->i_mapping, index);
-	if (!page)
+	folio = filemap_lock_folio(inode->i_mapping, index);
+	if (IS_ERR(folio))
 		return -ENOENT;
 
-	wait_on_page_writeback(page);
+	folio_wait_writeback(folio);
 
-	first_block = (unsigned long)index <<
-		(PAGE_SHIFT - inode->i_blkbits);
-	if (page_has_buffers(page)) {
-		struct buffer_head *bh;
-
-		bh = nilfs_page_get_nth_block(page, block - first_block);
+	bh = folio_buffers(folio);
+	if (bh) {
+		unsigned long first_block = index <<
+				(PAGE_SHIFT - inode->i_blkbits);
+		bh = get_nth_bh(bh, block - first_block);
 		nilfs_forget_buffer(bh);
 	}
-	still_dirty = PageDirty(page);
-	unlock_page(page);
-	put_page(page);
+	still_dirty = folio_test_dirty(folio);
+	folio_unlock(folio);
+	folio_put(folio);
 
 	if (still_dirty ||
 	    invalidate_inode_pages2_range(inode->i_mapping, index, index) != 0)
_

Patches currently in -mm which might be from willy@infradead.org are


