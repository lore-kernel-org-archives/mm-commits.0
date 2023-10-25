Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A99DCC25B6B
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbjJYXsr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbjJYXsV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D96186
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA98AC433C9;
        Wed, 25 Oct 2023 23:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277690;
        bh=61DSuLv7l3QYWBxN3Ms3tHL3hGuRtoa6lQfb5l6435A=;
        h=Date:To:From:Subject:From;
        b=F/yS0bOWNDeGUVIzG9ohwVcI0rfg1tYQoGRR8CRnvhiWbP/YQvMQQujDyFyrVyr+I
         3435SSneT/p8Y0eABD2mlTNa7riwLggH3IxHKISCH8wY3YgDu/uQ7kYiGK+97OFYb5
         3OVEyBbeOX3YIJLr4PAERGXISLEBBfaQ7Wfu4lpo=
Date:   Wed, 25 Oct 2023 16:48:10 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ufs-convert-ufs_change_blocknr-to-use-folios.patch removed from -mm tree
Message-Id: <20231025234810.DA98AC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ufs: convert ufs_change_blocknr() to use folios
has been removed from the -mm tree.  Its filename was
     ufs-convert-ufs_change_blocknr-to-use-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ufs: convert ufs_change_blocknr() to use folios
Date: mon, 16 Oct 2023 21:11:12 +0100

Convert the locked_page argument to a folio, then use folios throughout. 
Saves three hidden calls to compound_head().

Link: https://lkml.kernel.org/r/20231016201114.1928083-26-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/balloc.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/fs/ufs/balloc.c~ufs-convert-ufs_change_blocknr-to-use-folios
+++ a/fs/ufs/balloc.c
@@ -240,6 +240,7 @@ static void ufs_change_blocknr(struct in
 			       unsigned int count, sector_t oldb,
 			       sector_t newb, struct page *locked_page)
 {
+	struct folio *folio, *locked_folio = page_folio(locked_page);
 	const unsigned blks_per_page =
 		1 << (PAGE_SHIFT - inode->i_blkbits);
 	const unsigned mask = blks_per_page - 1;
@@ -247,42 +248,39 @@ static void ufs_change_blocknr(struct in
 	pgoff_t index, cur_index, last_index;
 	unsigned pos, j, lblock;
 	sector_t end, i;
-	struct page *page;
 	struct buffer_head *head, *bh;
 
 	UFSD("ENTER, ino %lu, count %u, oldb %llu, newb %llu\n",
 	      inode->i_ino, count,
 	     (unsigned long long)oldb, (unsigned long long)newb);
 
-	BUG_ON(!locked_page);
-	BUG_ON(!PageLocked(locked_page));
+	BUG_ON(!folio_test_locked(locked_folio));
 
-	cur_index = locked_page->index;
+	cur_index = locked_folio->index;
 	end = count + beg;
 	last_index = end >> (PAGE_SHIFT - inode->i_blkbits);
 	for (i = beg; i < end; i = (i | mask) + 1) {
 		index = i >> (PAGE_SHIFT - inode->i_blkbits);
 
 		if (likely(cur_index != index)) {
-			page = ufs_get_locked_page(mapping, index);
-			if (!page)/* it was truncated */
+			folio = ufs_get_locked_folio(mapping, index);
+			if (!folio) /* it was truncated */
 				continue;
-			if (IS_ERR(page)) {/* or EIO */
+			if (IS_ERR(folio)) {/* or EIO */
 				ufs_error(inode->i_sb, __func__,
 					  "read of page %llu failed\n",
 					  (unsigned long long)index);
 				continue;
 			}
 		} else
-			page = locked_page;
+			folio = locked_folio;
 
-		head = page_buffers(page);
+		head = folio_buffers(folio);
 		bh = head;
 		pos = i & mask;
 		for (j = 0; j < pos; ++j)
 			bh = bh->b_this_page;
 
-
 		if (unlikely(index == last_index))
 			lblock = end & mask;
 		else
@@ -313,7 +311,7 @@ static void ufs_change_blocknr(struct in
 		} while (bh != head);
 
 		if (likely(cur_index != index))
-			ufs_put_locked_page(page);
+			ufs_put_locked_folio(folio);
  	}
 	UFSD("EXIT\n");
 }
_

Patches currently in -mm which might be from willy@infradead.org are


