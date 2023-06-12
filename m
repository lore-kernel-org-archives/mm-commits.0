Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7F3CC88CB7
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbjFLVu6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236430AbjFLVuz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:50:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C0B19F
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:50:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3E7A62F79
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3387EC433D2;
        Mon, 12 Jun 2023 21:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686606647;
        bh=WuWgjinS06iaDRoMcp4yFq615qM/sUce7fAHobK3TRE=;
        h=Date:To:From:Subject:From;
        b=aBfeYN753MKMovscIkqhElvOpvUlYKY897L0LeHg2xom53B/r8/Rg0LPLW+rDS6wL
         Qci7ccNLaPqK/uio73DrUGWQTYpyfsaa3nUSsMfNWjIil3SeEIxRt14y+1luckjzFB
         6x46/n/ji1kQaCB1LFHSeVnAJ5+6ioQyg+OwIo0c=
Date:   Mon, 12 Jun 2023 14:50:46 -0700
To:     mm-commits@vger.kernel.org, rpeterso@redhat.com, mcgrof@kernel.org,
        hare@suse.com, agruenba@redhat.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-convert-block_truncate_page-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20230612215047.3387EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: convert block_truncate_page() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-convert-block_truncate_page-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-convert-block_truncate_page-to-use-a-folio.patch

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
Subject: buffer: convert block_truncate_page() to use a folio
Date: Mon, 12 Jun 2023 22:01:41 +0100

Support large folios in block_truncate_page() and avoid three hidden calls
to compound_head().

Link: https://lkml.kernel.org/r/20230612210141.730128-15-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Bob Peterson <rpeterso@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

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
+	folio = filemap_grab_folio(mapping, index);
+	if (!folio)
 		return -ENOMEM;
 
-	if (!page_has_buffers(page))
-		create_empty_buffers(page, blocksize, 0);
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

