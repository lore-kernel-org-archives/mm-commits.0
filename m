Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E242AC88CB8
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbjFLVuj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbjFLVuh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:50:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B66719A
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:50:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 173CB62F72
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C263C433EF;
        Mon, 12 Jun 2023 21:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686606635;
        bh=E+FvAopg7CiDJdKt3xuMGMu5yRyLVIcpEgb6M7OFyF0=;
        h=Date:To:From:Subject:From;
        b=u1L3UAupYnQruOpvTgjNZre2F+ha4pBT0KkgaQP9kIvfWSW0X2IMuYswGsWeGAdyl
         YCpMuRsJ7hE5z1h+FwbhvqLsGYdc4uxE2bPYOG4wW756LbiAnH2V3KaKR0cF4SEESC
         LBOUo3HWL753omRG+UegLETv8uz3Yd+cp+1HwzfQ=
Date:   Mon, 12 Jun 2023 14:50:34 -0700
To:     mm-commits@vger.kernel.org, rpeterso@redhat.com, mcgrof@kernel.org,
        hare@suse.com, agruenba@redhat.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-convert-__block_commit_write-to-take-a-folio.patch added to mm-unstable branch
Message-Id: <20230612215035.6C263C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: convert __block_commit_write() to take a folio
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-convert-__block_commit_write-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-convert-__block_commit_write-to-take-a-folio.patch

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

