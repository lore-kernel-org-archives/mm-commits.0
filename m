Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 440E2C0015E
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjFSX0h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjFSXYu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:24:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8239FA
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4ED3560FC5
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3D1C433C8;
        Mon, 19 Jun 2023 23:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216989;
        bh=8evcMJOLHb9oDApsCjxS4idruu+IdUMvqVyHgsK1a+o=;
        h=Date:To:From:Subject:From;
        b=tI6Y6x8QBRc+RHd0IgDg2FcTtdABGP5BS7MxbVaXLHuIOIC7gc6+PE5+7c0Se0xyT
         pM5qceyPHXoAKBxYMfluT9uYQ/ugsLsNSohRTQlvF0l+iW9Lmt1Tl+Zziwr5tX9bDg
         3vHn2DE2vYIhj2NIwrD0BEjcWDPz5o/F6dejtMGU=
Date:   Mon, 19 Jun 2023 16:23:09 -0700
To:     mm-commits@vger.kernel.org, rpeterso@redhat.com, mcgrof@kernel.org,
        hare@suse.com, agruenba@redhat.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-convert-__block_commit_write-to-take-a-folio.patch removed from -mm tree
Message-Id: <20230619232309.AB3D1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: buffer: convert __block_commit_write() to take a folio
has been removed from the -mm tree.  Its filename was
     buffer-convert-__block_commit_write-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: convert __block_commit_write() to take a folio
Date: Mon, 12 Jun 2023 22:01:35 +0100

This removes a hidden call to compound_head() inside
__block_commit_write() and moves it to those callers which are still page
based.  Also make block_write_end() safe for large folios.

Link: https://lkml.kernel.org/r/20230612210141.730128-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Bob Peterson <rpeterso@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/fs/buffer.c~buffer-convert-__block_commit_write-to-take-a-folio
+++ a/fs/buffer.c
@@ -2116,15 +2116,15 @@ int __block_write_begin(struct page *pag
 }
 EXPORT_SYMBOL(__block_write_begin);
 
-static int __block_commit_write(struct inode *inode, struct page *page,
-		unsigned from, unsigned to)
+static int __block_commit_write(struct inode *inode, struct folio *folio,
+		size_t from, size_t to)
 {
-	unsigned block_start, block_end;
-	int partial = 0;
+	size_t block_start, block_end;
+	bool partial = false;
 	unsigned blocksize;
 	struct buffer_head *bh, *head;
 
-	bh = head = page_buffers(page);
+	bh = head = folio_buffers(folio);
 	blocksize = bh->b_size;
 
 	block_start = 0;
@@ -2132,7 +2132,7 @@ static int __block_commit_write(struct i
 		block_end = block_start + blocksize;
 		if (block_end <= from || block_start >= to) {
 			if (!buffer_uptodate(bh))
-				partial = 1;
+				partial = true;
 		} else {
 			set_buffer_uptodate(bh);
 			mark_buffer_dirty(bh);
@@ -2147,11 +2147,11 @@ static int __block_commit_write(struct i
 	/*
 	 * If this is a partial write which happened to make all buffers
 	 * uptodate then we can optimize away a bogus read_folio() for
-	 * the next read(). Here we 'discover' whether the page went
+	 * the next read(). Here we 'discover' whether the folio went
 	 * uptodate as a result of this (potentially partial) write.
 	 */
 	if (!partial)
-		SetPageUptodate(page);
+		folio_mark_uptodate(folio);
 	return 0;
 }
 
@@ -2188,10 +2188,9 @@ int block_write_end(struct file *file, s
 			loff_t pos, unsigned len, unsigned copied,
 			struct page *page, void *fsdata)
 {
+	struct folio *folio = page_folio(page);
 	struct inode *inode = mapping->host;
-	unsigned start;
-
-	start = pos & (PAGE_SIZE - 1);
+	size_t start = pos - folio_pos(folio);
 
 	if (unlikely(copied < len)) {
 		/*
@@ -2203,18 +2202,18 @@ int block_write_end(struct file *file, s
 		 * read_folio might come in and destroy our partial write.
 		 *
 		 * Do the simplest thing, and just treat any short write to a
-		 * non uptodate page as a zero-length write, and force the
+		 * non uptodate folio as a zero-length write, and force the
 		 * caller to redo the whole thing.
 		 */
-		if (!PageUptodate(page))
+		if (!folio_test_uptodate(folio))
 			copied = 0;
 
-		page_zero_new_buffers(page, start+copied, start+len);
+		page_zero_new_buffers(&folio->page, start+copied, start+len);
 	}
-	flush_dcache_page(page);
+	flush_dcache_folio(folio);
 
 	/* This could be a short (even 0-length) commit */
-	__block_commit_write(inode, page, start, start+copied);
+	__block_commit_write(inode, folio, start, start + copied);
 
 	return copied;
 }
@@ -2537,8 +2536,9 @@ EXPORT_SYMBOL(cont_write_begin);
 
 int block_commit_write(struct page *page, unsigned from, unsigned to)
 {
-	struct inode *inode = page->mapping->host;
-	__block_commit_write(inode,page,from,to);
+	struct folio *folio = page_folio(page);
+	struct inode *inode = folio->mapping->host;
+	__block_commit_write(inode, folio, from, to);
 	return 0;
 }
 EXPORT_SYMBOL(block_commit_write);
@@ -2586,7 +2586,7 @@ int block_page_mkwrite(struct vm_area_st
 
 	ret = __block_write_begin_int(folio, 0, end, get_block, NULL);
 	if (!ret)
-		ret = block_commit_write(&folio->page, 0, end);
+		ret = __block_commit_write(inode, folio, 0, end);
 
 	if (unlikely(ret < 0))
 		goto out_unlock;
_

Patches currently in -mm which might be from willy@infradead.org are


