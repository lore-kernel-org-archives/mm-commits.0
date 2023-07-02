Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E98EB64D9
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 23:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjGBXSV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 19:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjGBXSU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 19:18:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8541BE
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 16:18:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39DF260CEC
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 23:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782D0C433C8;
        Sun,  2 Jul 2023 23:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688339898;
        bh=APrHuFDMJYb2QFNL+thfFvPjZ3HnajvL7Q4htrRNsxQ=;
        h=Date:To:From:Subject:From;
        b=uzT0kaw7y/1ODkdp4FEPjJq0tmg8gCvCYr1KPB1gO0Gi2iY5WWn6ouqhyT+XSbnS0
         upzLm3Lz0gr9u7xHAvz3Rbs4StmRANKu4hRRCbTRtsRN+tC/FaN4UY8kTyrpwrxQ1Q
         LcYrbCserbFFDsaacwC3r5PK77wWesqJcS/vIbGI=
Date:   Sun, 02 Jul 2023 16:18:17 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, tytso@mit.edu, ocfs2-devel@oss.oracle.com,
        mark@fasheh.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
        jack@suse.cz, hch@lst.de, brauner@kernel.org,
        adilger.kernel@dilger.ca, beanhuo@micron.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-buffer-clean-up-block_commit_write.patch added to mm-unstable branch
Message-Id: <20230702231818.782D0C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/buffer: clean up block_commit_write
has been added to the -mm mm-unstable branch.  Its filename is
     fs-buffer-clean-up-block_commit_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-buffer-clean-up-block_commit_write.patch

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
From: Bean Huo <beanhuo@micron.com>
Subject: fs/buffer: clean up block_commit_write
Date: Mon, 26 Jun 2023 07:55:17 +0200

Originally inode is used to get blksize, after commit 45bce8f3e343
("fs/buffer.c: make block-size be per-page and protected by the page
lock"), __block_commit_write no longer uses this parameter inode.

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

 fs/buffer.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

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
@@ -2277,7 +2276,7 @@ int block_write_end(struct file *file, s
 	flush_dcache_folio(folio);
 
 	/* This could be a short (even 0-length) commit */
-	__block_commit_write(inode, folio, start, start + copied);
+	__block_commit_write(folio, start, start + copied);
 
 	return copied;
 }
@@ -2601,8 +2600,7 @@ EXPORT_SYMBOL(cont_write_begin);
 int block_commit_write(struct page *page, unsigned from, unsigned to)
 {
 	struct folio *folio = page_folio(page);
-	struct inode *inode = folio->mapping->host;
-	__block_commit_write(inode, folio, from, to);
+	__block_commit_write(folio, from, to);
 	return 0;
 }
 EXPORT_SYMBOL(block_commit_write);
@@ -2650,7 +2648,7 @@ int block_page_mkwrite(struct vm_area_st
 
 	ret = __block_write_begin_int(folio, 0, end, get_block, NULL);
 	if (!ret)
-		ret = __block_commit_write(inode, folio, 0, end);
+		ret = __block_commit_write(folio, 0, end);
 
 	if (unlikely(ret < 0))
 		goto out_unlock;
_

Patches currently in -mm which might be from beanhuo@micron.com are

fs-buffer-clean-up-block_commit_write.patch
fs-convert-block_commit_write-to-return-void.patch

