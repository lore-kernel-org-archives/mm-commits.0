Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F8CEB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:26:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjFSX0t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjFSXYu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:24:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEBE12C
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DA4360FC5
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93D4C433C0;
        Mon, 19 Jun 2023 23:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216991;
        bh=tIRoGzmjhKtrRhg9G0Xq3g/BHGSHmBGtbnj8NzR7fg4=;
        h=Date:To:From:Subject:From;
        b=fiixC2gDVgqocy/0IxjKo2bSTEoVhhJuShK2bYAOiNHnfzYZrhI9S3sSUxIRJ8Kyl
         GUPucB1GdH4TK9cbGRvhLGoEUfdjBKZpPpImszs11UAiTDEf2EVLyy/o3vpL/yTEHG
         FsyAXHaOp3/AN4ZyRoxSnfxKwODnRfHpRig7incg=
Date:   Mon, 19 Jun 2023 16:23:11 -0700
To:     mm-commits@vger.kernel.org, rpeterso@redhat.com, mcgrof@kernel.org,
        hare@suse.com, agruenba@redhat.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-convert-grow_dev_page-to-use-a-folio.patch removed from -mm tree
Message-Id: <20230619232311.A93D4C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: buffer: convert grow_dev_page() to use a folio
has been removed from the -mm tree.  Its filename was
     buffer-convert-grow_dev_page-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: convert grow_dev_page() to use a folio
Date: Mon, 12 Jun 2023 22:01:37 +0100

Get a folio from the page cache instead of a page, then use the folio API
throughout.  Removes a few calls to compound_head() and may be needed to
support block size > PAGE_SIZE.

Link: https://lkml.kernel.org/r/20230612210141.730128-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Bob Peterson <rpeterso@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

--- a/fs/buffer.c~buffer-convert-grow_dev_page-to-use-a-folio
+++ a/fs/buffer.c
@@ -976,7 +976,7 @@ grow_dev_page(struct block_device *bdev,
 	      pgoff_t index, int size, int sizebits, gfp_t gfp)
 {
 	struct inode *inode = bdev->bd_inode;
-	struct page *page;
+	struct folio *folio;
 	struct buffer_head *bh;
 	sector_t end_block;
 	int ret = 0;
@@ -992,42 +992,38 @@ grow_dev_page(struct block_device *bdev,
 	 */
 	gfp_mask |= __GFP_NOFAIL;
 
-	page = find_or_create_page(inode->i_mapping, index, gfp_mask);
+	folio = __filemap_get_folio(inode->i_mapping, index,
+			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp_mask);
 
-	BUG_ON(!PageLocked(page));
-
-	if (page_has_buffers(page)) {
-		bh = page_buffers(page);
+	bh = folio_buffers(folio);
+	if (bh) {
 		if (bh->b_size == size) {
-			end_block = init_page_buffers(page, bdev,
+			end_block = init_page_buffers(&folio->page, bdev,
 						(sector_t)index << sizebits,
 						size);
 			goto done;
 		}
-		if (!try_to_free_buffers(page_folio(page)))
+		if (!try_to_free_buffers(folio))
 			goto failed;
 	}
 
-	/*
-	 * Allocate some buffers for this page
-	 */
-	bh = alloc_page_buffers(page, size, true);
+	bh = folio_alloc_buffers(folio, size, true);
 
 	/*
-	 * Link the page to the buffers and initialise them.  Take the
+	 * Link the folio to the buffers and initialise them.  Take the
 	 * lock to be atomic wrt __find_get_block(), which does not
-	 * run under the page lock.
+	 * run under the folio lock.
 	 */
 	spin_lock(&inode->i_mapping->private_lock);
-	link_dev_buffers(page, bh);
-	end_block = init_page_buffers(page, bdev, (sector_t)index << sizebits,
-			size);
+	link_dev_buffers(&folio->page, bh);
+	end_block = init_page_buffers(&folio->page, bdev,
+			(sector_t)index << sizebits, size);
 	spin_unlock(&inode->i_mapping->private_lock);
 done:
 	ret = (block < end_block) ? 1 : -ENXIO;
 failed:
-	unlock_page(page);
-	put_page(page);
+	folio_unlock(folio);
+	folio_put(folio);
 	return ret;
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are


