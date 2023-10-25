Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1633EC25B6F
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234825AbjJYXsr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbjJYXsV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38CA81A7
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069CCC433C8;
        Wed, 25 Oct 2023 23:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277690;
        bh=KrFk5m/+HeoBEXyisWwokDH5tvf/hkCY8FeOSPkEPNw=;
        h=Date:To:From:Subject:From;
        b=fp05yL8vqahjm7Nq92qG5L4b/ZKNHvAmyKN/IMRrHZSDq9HJhzErVIr4pSJI0QpX9
         kLfPtxipJj4d43AOPI56PMTbsKy9S0a+oSQcenNr0BPc7Otkf/un82GuaRp0H69EY6
         CPRFU/69a36S5miXXANY7czDyNo+o4XJpqDA1tqM=
Date:   Wed, 25 Oct 2023 16:48:09 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ufs-use-ufs_get_locked_folio-in-ufs_alloc_lastblock.patch removed from -mm tree
Message-Id: <20231025234810.069CCC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ufs: use ufs_get_locked_folio() in ufs_alloc_lastblock()
has been removed from the -mm tree.  Its filename was
     ufs-use-ufs_get_locked_folio-in-ufs_alloc_lastblock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ufs: use ufs_get_locked_folio() in ufs_alloc_lastblock()
Date: Mon, 16 Oct 2023 21:11:11 +0100

Switch to the folio APIs, saving one folio->page->folio conversion.

Link: https://lkml.kernel.org/r/20231016201114.1928083-25-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/inode.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/fs/ufs/inode.c~ufs-use-ufs_get_locked_folio-in-ufs_alloc_lastblock
+++ a/fs/ufs/inode.c
@@ -1057,7 +1057,7 @@ static int ufs_alloc_lastblock(struct in
 	struct ufs_sb_private_info *uspi = UFS_SB(sb)->s_uspi;
 	unsigned i, end;
 	sector_t lastfrag;
-	struct page *lastpage;
+	struct folio *folio;
 	struct buffer_head *bh;
 	u64 phys64;
 
@@ -1068,18 +1068,17 @@ static int ufs_alloc_lastblock(struct in
 
 	lastfrag--;
 
-	lastpage = ufs_get_locked_page(mapping, lastfrag >>
+	folio = ufs_get_locked_folio(mapping, lastfrag >>
 				       (PAGE_SHIFT - inode->i_blkbits));
-       if (IS_ERR(lastpage)) {
-               err = -EIO;
-               goto out;
-       }
-
-       end = lastfrag & ((1 << (PAGE_SHIFT - inode->i_blkbits)) - 1);
-       bh = page_buffers(lastpage);
-       for (i = 0; i < end; ++i)
-               bh = bh->b_this_page;
+	if (IS_ERR(folio)) {
+		err = -EIO;
+		goto out;
+	}
 
+	end = lastfrag & ((1 << (PAGE_SHIFT - inode->i_blkbits)) - 1);
+	bh = folio_buffers(folio);
+	for (i = 0; i < end; ++i)
+		bh = bh->b_this_page;
 
        err = ufs_getfrag_block(inode, lastfrag, bh, 1);
 
@@ -1095,7 +1094,7 @@ static int ufs_alloc_lastblock(struct in
 		*/
 	       set_buffer_uptodate(bh);
 	       mark_buffer_dirty(bh);
-	       set_page_dirty(lastpage);
+		folio_mark_dirty(folio);
        }
 
        if (lastfrag >= UFS_IND_FRAGMENT) {
@@ -1113,7 +1112,7 @@ static int ufs_alloc_lastblock(struct in
 	       }
        }
 out_unlock:
-       ufs_put_locked_page(lastpage);
+       ufs_put_locked_folio(folio);
 out:
        return err;
 }
_

Patches currently in -mm which might be from willy@infradead.org are


