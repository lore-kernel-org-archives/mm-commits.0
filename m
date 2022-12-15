Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B105BC46467
	for <mm-commits@archiver.kernel.org>; Thu, 15 Dec 2022 23:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiLOXKZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 18:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiLOXJo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 18:09:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC15F5D6B9
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 15:09:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78ED161F88
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 23:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9B3C433D2;
        Thu, 15 Dec 2022 23:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671145781;
        bh=USgTFHMgOSlBoEYpSYy/Onw1ITQyjVf4q/n94vP+Hdg=;
        h=Date:To:From:Subject:From;
        b=JdaY2mco/Xw+flMx/jqxDxpzdThWt2D2DMrtDd91f2jUtsMwHQpe457b5hd8f+53r
         xIYcLuvSg7749srlz99/TPvi247LkPYxYY/MLBPwldE3r/mFrXNnD0c7QTMx6EpcnH
         fJ1Yc0O8aKKYaXPJPwDOlSW47VMzEVEXSKVhaihw=
Date:   Thu, 15 Dec 2022 15:09:41 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-replace-obvious-uses-of-b_page-with-b_folio.patch added to mm-unstable branch
Message-Id: <20221215230941.CD9B3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: replace obvious uses of b_page with b_folio
has been added to the -mm mm-unstable branch.  Its filename is
     nilfs2-replace-obvious-uses-of-b_page-with-b_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-replace-obvious-uses-of-b_page-with-b_folio.patch

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
Subject: nilfs2: replace obvious uses of b_page with b_folio
Date: Thu, 15 Dec 2022 21:44:00 +0000

These places just use b_page to get to the buffer's address_space or the
index of the page the buffer is in.

Link: https://lkml.kernel.org/r/20221215214402.3522366-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btnode.c  |    2 +-
 fs/nilfs2/btree.c   |    2 +-
 fs/nilfs2/gcinode.c |    2 +-
 fs/nilfs2/mdt.c     |    4 ++--
 fs/nilfs2/segment.c |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

--- a/fs/nilfs2/btnode.c~nilfs2-replace-obvious-uses-of-b_page-with-b_folio
+++ a/fs/nilfs2/btnode.c
@@ -188,7 +188,7 @@ int nilfs_btnode_prepare_change_key(stru
 		struct page *opage = obh->b_page;
 		lock_page(opage);
 retry:
-		/* BUG_ON(oldkey != obh->b_page->index); */
+		/* BUG_ON(oldkey != obh->b_folio->index); */
 		if (unlikely(oldkey != opage->index))
 			NILFS_PAGE_BUG(opage,
 				       "invalid oldkey %lld (newkey=%lld)",
--- a/fs/nilfs2/btree.c~nilfs2-replace-obvious-uses-of-b_page-with-b_folio
+++ a/fs/nilfs2/btree.c
@@ -398,7 +398,7 @@ int nilfs_btree_broken_node_block(struct
 	if (buffer_nilfs_checked(bh))
 		return 0;
 
-	inode = bh->b_page->mapping->host;
+	inode = bh->b_folio->mapping->host;
 	ret = nilfs_btree_node_broken((struct nilfs_btree_node *)bh->b_data,
 				      bh->b_size, inode, bh->b_blocknr);
 	if (likely(!ret))
--- a/fs/nilfs2/gcinode.c~nilfs2-replace-obvious-uses-of-b_page-with-b_folio
+++ a/fs/nilfs2/gcinode.c
@@ -140,7 +140,7 @@ int nilfs_gccache_wait_and_mark_dirty(st
 {
 	wait_on_buffer(bh);
 	if (!buffer_uptodate(bh)) {
-		struct inode *inode = bh->b_page->mapping->host;
+		struct inode *inode = bh->b_folio->mapping->host;
 
 		nilfs_err(inode->i_sb,
 			  "I/O error reading %s block for GC (ino=%lu, vblocknr=%llu)",
--- a/fs/nilfs2/mdt.c~nilfs2-replace-obvious-uses-of-b_page-with-b_folio
+++ a/fs/nilfs2/mdt.c
@@ -563,7 +563,7 @@ int nilfs_mdt_freeze_buffer(struct inode
 	struct page *page;
 	int blkbits = inode->i_blkbits;
 
-	page = grab_cache_page(shadow->inode->i_mapping, bh->b_page->index);
+	page = grab_cache_page(shadow->inode->i_mapping, bh->b_folio->index);
 	if (!page)
 		return -ENOMEM;
 
@@ -595,7 +595,7 @@ nilfs_mdt_get_frozen_buffer(struct inode
 	struct page *page;
 	int n;
 
-	page = find_lock_page(shadow->inode->i_mapping, bh->b_page->index);
+	page = find_lock_page(shadow->inode->i_mapping, bh->b_folio->index);
 	if (page) {
 		if (page_has_buffers(page)) {
 			n = bh_offset(bh) >> inode->i_blkbits;
--- a/fs/nilfs2/segment.c~nilfs2-replace-obvious-uses-of-b_page-with-b_folio
+++ a/fs/nilfs2/segment.c
@@ -1581,7 +1581,7 @@ nilfs_segctor_update_payload_blocknr(str
 			nblocks = le32_to_cpu(finfo->fi_nblocks);
 			ndatablk = le32_to_cpu(finfo->fi_ndatablk);
 
-			inode = bh->b_page->mapping->host;
+			inode = bh->b_folio->mapping->host;
 
 			if (mode == SC_LSEG_DSYNC)
 				sc_op = &nilfs_sc_dsync_ops;
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-add-b_folio-as-an-alias-of-b_page.patch
buffer-replace-obvious-uses-of-b_page-with-b_folio.patch
buffer-use-b_folio-in-touch_buffer.patch
buffer-use-b_folio-in-end_buffer_async_read.patch
buffer-use-b_folio-in-end_buffer_async_write.patch
page_io-remove-buffer_head-include.patch
buffer-use-b_folio-in-mark_buffer_dirty.patch
gfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
jbd2-replace-obvious-uses-of-b_page-with-b_folio.patch
nilfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
reiserfs-replace-obvious-uses-of-b_page-with-b_folio.patch
mpage-use-b_folio-in-do_mpage_readpage.patch

