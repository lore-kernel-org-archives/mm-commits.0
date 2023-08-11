Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C94DC04A94
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjHKW7O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236864AbjHKW7A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79380358E
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC4D5678C4
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ECA0C433C7;
        Fri, 11 Aug 2023 22:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794739;
        bh=vn2jYm4t/YXvNRxLB4WrXv1+DriYT1I0R6oRw5xJdxQ=;
        h=Date:To:From:Subject:From;
        b=FuO937j6wJnHnKQn0xwTs+MKC6PQEk7dL7xv1fobB7DaA0ZGgBEfFBrBa0mw6HmEB
         bIrTiQGTOACrfO0iPN6bdXpi+If5oCNgInkC7vNgvcv9mV0b7KedLtqEFETDE6L/1d
         EUkhoxZ7CaBnwOdMitvpDYADwcjkFXbD5ZS9UmHg=
Date:   Fri, 11 Aug 2023 15:58:58 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, tytso@mit.edu, ocfs2-devel@oss.oracle.com,
        mark@fasheh.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
        jack@suse.cz, hch@lst.de, brauner@kernel.org,
        adilger.kernel@dilger.ca, beanhuo@micron.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-buffer-clean-up-block_commit_write.patch removed from -mm tree
Message-Id: <20230811225859.4ECA0C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/buffer: clean up block_commit_write
has been removed from the -mm tree.  Its filename was
     fs-buffer-clean-up-block_commit_write.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bean Huo <beanhuo@micron.com>
Subject: fs/buffer: clean up block_commit_write
Date: Mon, 26 Jun 2023 07:55:17 +0200

Originally inode is used to get blksize, after commit 45bce8f3e343
("fs/buffer.c: make block-size be per-page and protected by the page
lock"), __block_commit_write no longer uses this parameter inode.

[akpm@linux-foundation.org: remove now-unused local `inode']
Link: https://lkml.kernel.org/r/20230626055518.842392-2-beanhuo@iokpp.de
Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Luís Henriques <ocfs2-devel@oss.oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/fs/buffer.c~fs-buffer-clean-up-block_commit_write
+++ a/fs/buffer.c
@@ -2180,8 +2180,7 @@ int __block_write_begin(struct page *pag
 }
 EXPORT_SYMBOL(__block_write_begin);
 
-static int __block_commit_write(struct inode *inode, struct folio *folio,
-		size_t from, size_t to)
+static int __block_commit_write(struct folio *folio, size_t from, size_t to)
 {
 	size_t block_start, block_end;
 	bool partial = false;
@@ -2253,7 +2252,6 @@ int block_write_end(struct file *file, s
 			struct page *page, void *fsdata)
 {
 	struct folio *folio = page_folio(page);
-	struct inode *inode = mapping->host;
 	size_t start = pos - folio_pos(folio);
 
 	if (unlikely(copied < len)) {
@@ -2277,7 +2275,7 @@ int block_write_end(struct file *file, s
 	flush_dcache_folio(folio);
 
 	/* This could be a short (even 0-length) commit */
-	__block_commit_write(inode, folio, start, start + copied);
+	__block_commit_write(folio, start, start + copied);
 
 	return copied;
 }
@@ -2601,8 +2599,7 @@ EXPORT_SYMBOL(cont_write_begin);
 int block_commit_write(struct page *page, unsigned from, unsigned to)
 {
 	struct folio *folio = page_folio(page);
-	struct inode *inode = folio->mapping->host;
-	__block_commit_write(inode, folio, from, to);
+	__block_commit_write(folio, from, to);
 	return 0;
 }
 EXPORT_SYMBOL(block_commit_write);
@@ -2650,7 +2647,7 @@ int block_page_mkwrite(struct vm_area_st
 
 	ret = __block_write_begin_int(folio, 0, end, get_block, NULL);
 	if (!ret)
-		ret = __block_commit_write(inode, folio, 0, end);
+		ret = __block_commit_write(folio, 0, end);
 
 	if (unlikely(ret < 0))
 		goto out_unlock;
_

Patches currently in -mm which might be from beanhuo@micron.com are


