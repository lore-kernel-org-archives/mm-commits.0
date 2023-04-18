Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0683CC77B76
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 00:51:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjDRAvU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Apr 2023 20:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDRAvU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Apr 2023 20:51:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF63F49E7
        for <mm-commits@vger.kernel.org>; Mon, 17 Apr 2023 17:51:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B7CC62B95
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 00:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C01C433D2;
        Tue, 18 Apr 2023 00:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681779077;
        bh=TeizO9A01GbDaaeJbkDCK7nNi1mYpIJL80Abl8EYTGo=;
        h=Date:To:From:Subject:From;
        b=VgS8lgEBXNwmNkwpA+ZSyZBSYvDZt1nn30lSnykSagkeLNAa1x+zJ5ZWFYH/DOT+V
         7gcsnbiJorHjr/zy9hhzPu/Mc2RULWYl3SPuDDliCFJ4CyRn2gd8jRpp7DD0Jn6oUJ
         rtDmYH+gTnnvuUUou9vZ4lFwdFUCDBzloEKaNoSs=
Date:   Mon, 17 Apr 2023 17:51:17 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, mcgrof@kernel.org, hare@suse.de,
        brauner@kernel.org, p.raghav@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-buffer-convert-create_page_buffers-to-folio_create_buffers.patch added to mm-unstable branch
Message-Id: <20230418005117.C4C01C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/buffer: convert create_page_buffers to folio_create_buffers
has been added to the -mm mm-unstable branch.  Its filename is
     fs-buffer-convert-create_page_buffers-to-folio_create_buffers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-buffer-convert-create_page_buffers-to-folio_create_buffers.patch

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
From: Pankaj Raghav <p.raghav@samsung.com>
Subject: fs/buffer: convert create_page_buffers to folio_create_buffers
Date: Mon, 17 Apr 2023 14:36:18 +0200

fs/buffer do not support large folios as there are many assumptions on the
folio size to be the host page size.  This conversion is one step towards
removing that assumption.  Also this conversion will reduce calls to
compound_head() if folio_create_buffers() calls
folio_create_empty_buffers().

Link: https://lkml.kernel.org/r/20230417123618.22094-5-p.raghav@samsung.com
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/fs/buffer.c~fs-buffer-convert-create_page_buffers-to-folio_create_buffers
+++ a/fs/buffer.c
@@ -1723,14 +1723,17 @@ static inline int block_size_bits(unsign
 	return ilog2(blocksize);
 }
 
-static struct buffer_head *create_page_buffers(struct page *page, struct inode *inode, unsigned int b_state)
+static struct buffer_head *folio_create_buffers(struct folio *folio,
+						struct inode *inode,
+						unsigned int b_state)
 {
-	BUG_ON(!PageLocked(page));
+	BUG_ON(!folio_test_locked(folio));
 
-	if (!page_has_buffers(page))
-		create_empty_buffers(page, 1 << READ_ONCE(inode->i_blkbits),
-				     b_state);
-	return page_buffers(page);
+	if (!folio_buffers(folio))
+		folio_create_empty_buffers(folio,
+					   1 << READ_ONCE(inode->i_blkbits),
+					   b_state);
+	return folio_buffers(folio);
 }
 
 /*
@@ -1774,8 +1777,8 @@ int __block_write_full_page(struct inode
 	int nr_underway = 0;
 	blk_opf_t write_flags = wbc_to_write_flags(wbc);
 
-	head = create_page_buffers(page, inode,
-					(1 << BH_Dirty)|(1 << BH_Uptodate));
+	head = folio_create_buffers(page_folio(page), inode,
+				    (1 << BH_Dirty) | (1 << BH_Uptodate));
 
 	/*
 	 * Be very careful.  We have no exclusion from block_dirty_folio
@@ -2038,7 +2041,7 @@ int __block_write_begin_int(struct folio
 	BUG_ON(to > PAGE_SIZE);
 	BUG_ON(from > to);
 
-	head = create_page_buffers(&folio->page, inode, 0);
+	head = folio_create_buffers(folio, inode, 0);
 	blocksize = head->b_size;
 	bbits = block_size_bits(blocksize);
 
@@ -2324,7 +2327,7 @@ int block_read_full_folio(struct folio *
 
 	VM_BUG_ON_FOLIO(folio_test_large(folio), folio);
 
-	head = create_page_buffers(&folio->page, inode, 0);
+	head = folio_create_buffers(folio, inode, 0);
 	blocksize = head->b_size;
 	bbits = block_size_bits(blocksize);
 
_

Patches currently in -mm which might be from p.raghav@samsung.com are

orangefs-use-folios-in-orangefs_readahead.patch
mpage-split-submit_bio-and-bio-end_io-handler-for-reads-and-writes.patch
mpage-use-folios-in-bio-end_io-handler.patch
fs-buffer-add-folio_set_bh-helper.patch
buffer-add-folio_alloc_buffers-helper.patch
fs-buffer-add-folio_create_empty_buffers-helper.patch
fs-buffer-convert-create_page_buffers-to-folio_create_buffers.patch

