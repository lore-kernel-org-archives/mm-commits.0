Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31C14C25B6E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbjJYXsW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbjJYXsG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A73196
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:47:59 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B0AC433C9;
        Wed, 25 Oct 2023 23:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277678;
        bh=dSWeUM69tN9helXE/WpPYrbfhc71n173RgcfW+w+x3k=;
        h=Date:To:From:Subject:From;
        b=H1M35p7SEYPO230cNOLWJkQXiEqSrNq295BQZXM3MJIveogQUfeQdcnMNpcMndZqA
         xkjcAFm3Q34YbHXHG4Ch7MbBr4RtK6Ihz21xRYhzEnEZHI0ULyhsiiqCOWcBNuP8V5
         DoEnBxMjz86VinZuu96Dnc+DIA5O/YRkybjfdn3E=
Date:   Wed, 25 Oct 2023 16:47:58 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nilfs2-convert-nilfs_grab_buffer-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231025234758.94B0AC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: convert nilfs_grab_buffer() to use a folio
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_grab_buffer-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert nilfs_grab_buffer() to use a folio
Date: Mon, 16 Oct 2023 21:10:58 +0100

Remove a number of folio->page->folio conversions.

Link: https://lkml.kernel.org/r/20231016201114.1928083-12-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/fs/nilfs2/page.c~nilfs2-convert-nilfs_grab_buffer-to-use-a-folio
+++ a/fs/nilfs2/page.c
@@ -25,19 +25,19 @@
 	(BIT(BH_Uptodate) | BIT(BH_Mapped) | BIT(BH_NILFS_Node) |	\
 	 BIT(BH_NILFS_Volatile) | BIT(BH_NILFS_Checked))
 
-static struct buffer_head *
-__nilfs_get_page_block(struct page *page, unsigned long block, pgoff_t index,
-		       int blkbits, unsigned long b_state)
+static struct buffer_head *__nilfs_get_folio_block(struct folio *folio,
+		unsigned long block, pgoff_t index, int blkbits,
+		unsigned long b_state)
 
 {
 	unsigned long first_block;
-	struct buffer_head *bh;
+	struct buffer_head *bh = folio_buffers(folio);
 
-	if (!page_has_buffers(page))
-		create_empty_buffers(page, 1 << blkbits, b_state);
+	if (!bh)
+		bh = folio_create_empty_buffers(folio, 1 << blkbits, b_state);
 
 	first_block = (unsigned long)index << (PAGE_SHIFT - blkbits);
-	bh = nilfs_page_get_nth_block(page, block - first_block);
+	bh = get_nth_bh(bh, block - first_block);
 
 	touch_buffer(bh);
 	wait_on_buffer(bh);
@@ -51,17 +51,17 @@ struct buffer_head *nilfs_grab_buffer(st
 {
 	int blkbits = inode->i_blkbits;
 	pgoff_t index = blkoff >> (PAGE_SHIFT - blkbits);
-	struct page *page;
+	struct folio *folio;
 	struct buffer_head *bh;
 
-	page = grab_cache_page(mapping, index);
-	if (unlikely(!page))
+	folio = filemap_grab_folio(mapping, index);
+	if (IS_ERR(folio))
 		return NULL;
 
-	bh = __nilfs_get_page_block(page, blkoff, index, blkbits, b_state);
+	bh = __nilfs_get_folio_block(folio, blkoff, index, blkbits, b_state);
 	if (unlikely(!bh)) {
-		unlock_page(page);
-		put_page(page);
+		folio_unlock(folio);
+		folio_put(folio);
 		return NULL;
 	}
 	return bh;
_

Patches currently in -mm which might be from willy@infradead.org are


