Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5D16C25B6B
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:48:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbjJYXsV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbjJYXsG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3772E195
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:47:58 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C417EC433CA;
        Wed, 25 Oct 2023 23:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277677;
        bh=q0XzjuZmo+HBl81obGJw5vYupwmmVbTijPJERfxavRw=;
        h=Date:To:From:Subject:From;
        b=OHyTEXA6AYtiu9ey4as+4o10hioLtYKBtuBETGF/Pkjv04cCBz5lnLOFXF32EDd+I
         xT5s4ivxMoIJKJYBBj9llEF4VlOWAkEZQilQ7V7V6Z3G6Ox08hSmq3xezlcOi5K21d
         Uw3Az19t1PhxujOOxVXs9YgkCejP90qneIJqAuuU=
Date:   Wed, 25 Oct 2023 16:47:57 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nilfs2-convert-nilfs_mdt_freeze_buffer-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231025234757.C417EC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: convert nilfs_mdt_freeze_buffer to use a folio
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_mdt_freeze_buffer-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert nilfs_mdt_freeze_buffer to use a folio
Date: Mon, 16 Oct 2023 21:10:57 +0100

Remove a number of folio->page->folio conversions.

Link: https://lkml.kernel.org/r/20231016201114.1928083-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/mdt.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/fs/nilfs2/mdt.c~nilfs2-convert-nilfs_mdt_freeze_buffer-to-use-a-folio
+++ a/fs/nilfs2/mdt.c
@@ -560,17 +560,19 @@ int nilfs_mdt_freeze_buffer(struct inode
 {
 	struct nilfs_shadow_map *shadow = NILFS_MDT(inode)->mi_shadow;
 	struct buffer_head *bh_frozen;
-	struct page *page;
+	struct folio *folio;
 	int blkbits = inode->i_blkbits;
 
-	page = grab_cache_page(shadow->inode->i_mapping, bh->b_folio->index);
-	if (!page)
-		return -ENOMEM;
+	folio = filemap_grab_folio(shadow->inode->i_mapping,
+			bh->b_folio->index);
+	if (IS_ERR(folio))
+		return PTR_ERR(folio);
+
+	bh_frozen = folio_buffers(folio);
+	if (!bh_frozen)
+		bh_frozen = folio_create_empty_buffers(folio, 1 << blkbits, 0);
 
-	if (!page_has_buffers(page))
-		create_empty_buffers(page, 1 << blkbits, 0);
-
-	bh_frozen = nilfs_page_get_nth_block(page, bh_offset(bh) >> blkbits);
+	bh_frozen = get_nth_bh(bh_frozen, bh_offset(bh) >> blkbits);
 
 	if (!buffer_uptodate(bh_frozen))
 		nilfs_copy_buffer(bh_frozen, bh);
@@ -582,8 +584,8 @@ int nilfs_mdt_freeze_buffer(struct inode
 		brelse(bh_frozen); /* already frozen */
 	}
 
-	unlock_page(page);
-	put_page(page);
+	folio_unlock(folio);
+	folio_put(folio);
 	return 0;
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are


