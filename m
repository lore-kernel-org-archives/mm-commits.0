Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 659F3C7EE43
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237887AbjFLVu4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbjFLVum (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:50:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0963418C
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:50:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 921C262F7C
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D09C433D2;
        Mon, 12 Jun 2023 21:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686606640;
        bh=pZo+GdjFX/ZJeK9qVqa/4VZHcIC1WLZIpOCYgubXAto=;
        h=Date:To:From:Subject:From;
        b=VWTEUpM9W3rnJKu75EhjVuxlUFTgirPglwcKIf2v53yFGe9MM2eA/6iqJNdkKyDyd
         bnCIou1F7mglFYQZBmMpDfsGwxTA7wGhYEiMjmcH+cxqip2dNLpAgvp9MLcnJzF8ZN
         MNGEcYVpFjsc1MUXio9Bzj1p3//mweKHPtAde+gE=
Date:   Mon, 12 Jun 2023 14:50:39 -0700
To:     mm-commits@vger.kernel.org, rpeterso@redhat.com, mcgrof@kernel.org,
        hare@suse.com, agruenba@redhat.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-convert-grow_dev_page-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20230612215039.E1D09C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: convert grow_dev_page() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-convert-grow_dev_page-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-convert-grow_dev_page-to-use-a-folio.patch

This patch will later appear in the mm-unstable branch at
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

gfs2-use-a-folio-inside-gfs2_jdata_writepage.patch
gfs2-pass-a-folio-to-__gfs2_jdata_write_folio.patch
gfs2-convert-gfs2_write_jdata_page-to-gfs2_write_jdata_folio.patch
buffer-convert-__block_write_full_page-to-__block_write_full_folio.patch
gfs2-support-ludicrously-large-folios-in-gfs2_trans_add_databufs.patch
buffer-make-block_write_full_page-handle-large-folios-correctly.patch
buffer-convert-block_page_mkwrite-to-use-a-folio.patch
buffer-convert-__block_commit_write-to-take-a-folio.patch
buffer-convert-page_zero_new_buffers-to-folio_zero_new_buffers.patch
buffer-convert-grow_dev_page-to-use-a-folio.patch
buffer-convert-init_page_buffers-to-folio_init_buffers.patch
buffer-convert-link_dev_buffers-to-take-a-folio.patch
buffer-use-a-folio-in-__find_get_block_slow.patch
buffer-convert-block_truncate_page-to-use-a-folio.patch

