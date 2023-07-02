Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39ABDEB64DD
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 23:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjGBXSY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 19:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjGBXSW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 19:18:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4A01BE
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 16:18:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10E0C60CF7
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 23:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEFEC433C8;
        Sun,  2 Jul 2023 23:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688339900;
        bh=qeCMlUhLDiEhYZ8p8knZNlJm46cE/nQsIqIMelxyn/o=;
        h=Date:To:From:Subject:From;
        b=2deEe4+T34+b6CnLJsOoYcgpx5R27I2wl2oJTPA5isILJ1poMZCog/VDiK77Xoa0k
         P/RqDx0mQZjLmdE1CBuzKfInoaKMbqBSQ6vrHy9JLDt46PMqMSAOS1RD9hAho3kYui
         UeyJHFnQqIfVOMUIdej9bbSKZzj8jH7rD9FZOxOI=
Date:   Sun, 02 Jul 2023 16:18:19 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, tytso@mit.edu, ocfs2-devel@oss.oracle.com,
        mark@fasheh.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
        jack@suse.cz, hch@lst.de, brauner@kernel.org,
        adilger.kernel@dilger.ca, beanhuo@micron.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-convert-block_commit_write-to-return-void.patch added to mm-unstable branch
Message-Id: <20230702231820.5EEFEC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: convert block_commit_write to return void
has been added to the -mm mm-unstable branch.  Its filename is
     fs-convert-block_commit_write-to-return-void.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-convert-block_commit_write-to-return-void.patch

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
Subject: fs: convert block_commit_write to return void
Date: Mon, 26 Jun 2023 07:55:18 +0200

block_commit_write() always returns 0, this patch changes it to return
void.

Link: https://lkml.kernel.org/r/20230626055518.842392-3-beanhuo@iokpp.de
Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Luís Henriques <ocfs2-devel@oss.oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   14 ++++++--------
 fs/ext4/move_extent.c       |    7 ++-----
 fs/ocfs2/file.c             |    7 +------
 fs/udf/file.c               |    6 +++---
 include/linux/buffer_head.h |    2 +-
 5 files changed, 13 insertions(+), 23 deletions(-)

--- a/fs/buffer.c~fs-convert-block_commit_write-to-return-void
+++ a/fs/buffer.c
@@ -2180,7 +2180,7 @@ int __block_write_begin(struct page *pag
 }
 EXPORT_SYMBOL(__block_write_begin);
 
-static int __block_commit_write(struct folio *folio, size_t from, size_t to)
+static void __block_commit_write(struct folio *folio, size_t from, size_t to)
 {
 	size_t block_start, block_end;
 	bool partial = false;
@@ -2215,7 +2215,6 @@ static int __block_commit_write(struct f
 	 */
 	if (!partial)
 		folio_mark_uptodate(folio);
-	return 0;
 }
 
 /*
@@ -2597,11 +2596,10 @@ int cont_write_begin(struct file *file,
 }
 EXPORT_SYMBOL(cont_write_begin);
 
-int block_commit_write(struct page *page, unsigned from, unsigned to)
+void block_commit_write(struct page *page, unsigned from, unsigned to)
 {
 	struct folio *folio = page_folio(page);
 	__block_commit_write(folio, from, to);
-	return 0;
 }
 EXPORT_SYMBOL(block_commit_write);
 
@@ -2647,11 +2645,11 @@ int block_page_mkwrite(struct vm_area_st
 		end = size - folio_pos(folio);
 
 	ret = __block_write_begin_int(folio, 0, end, get_block, NULL);
-	if (!ret)
-		ret = __block_commit_write(folio, 0, end);
+	if (unlikely(ret))
+		 goto out_unlock;
+
+	__block_commit_write(folio, 0, end);
 
-	if (unlikely(ret < 0))
-		goto out_unlock;
 	folio_mark_dirty(folio);
 	folio_wait_stable(folio);
 	return 0;
--- a/fs/ext4/move_extent.c~fs-convert-block_commit_write-to-return-void
+++ a/fs/ext4/move_extent.c
@@ -388,14 +388,11 @@ data_copy:
 	for (i = 0; i < block_len_in_page; i++) {
 		*err = ext4_get_block(orig_inode, orig_blk_offset + i, bh, 0);
 		if (*err < 0)
-			break;
+			goto repair_branches;
 		bh = bh->b_this_page;
 	}
-	if (!*err)
-		*err = block_commit_write(&folio[0]->page, from, from + replaced_size);
 
-	if (unlikely(*err < 0))
-		goto repair_branches;
+	block_commit_write(&folio[0]->page, from, from + replaced_size);
 
 	/* Even in case of data=writeback it is reasonable to pin
 	 * inode to transaction, to prevent unexpected data loss */
--- a/fs/ocfs2/file.c~fs-convert-block_commit_write-to-return-void
+++ a/fs/ocfs2/file.c
@@ -808,12 +808,7 @@ static int ocfs2_write_zero_page(struct
 
 
 		/* must not update i_size! */
-		ret = block_commit_write(page, block_start + 1,
-					 block_start + 1);
-		if (ret < 0)
-			mlog_errno(ret);
-		else
-			ret = 0;
+		block_commit_write(page, block_start + 1, block_start + 1);
 	}
 
 	/*
--- a/fs/udf/file.c~fs-convert-block_commit_write-to-return-void
+++ a/fs/udf/file.c
@@ -63,13 +63,13 @@ static vm_fault_t udf_page_mkwrite(struc
 	else
 		end = PAGE_SIZE;
 	err = __block_write_begin(page, 0, end, udf_get_block);
-	if (!err)
-		err = block_commit_write(page, 0, end);
-	if (err < 0) {
+	if (err) {
 		unlock_page(page);
 		ret = block_page_mkwrite_return(err);
 		goto out_unlock;
 	}
+
+	block_commit_write(page, 0, end);
 out_dirty:
 	set_page_dirty(page);
 	wait_for_stable_page(page);
--- a/include/linux/buffer_head.h~fs-convert-block_commit_write-to-return-void
+++ a/include/linux/buffer_head.h
@@ -288,7 +288,7 @@ int cont_write_begin(struct file *, stru
 			unsigned, struct page **, void **,
 			get_block_t *, loff_t *);
 int generic_cont_expand_simple(struct inode *inode, loff_t size);
-int block_commit_write(struct page *page, unsigned from, unsigned to);
+void block_commit_write(struct page *page, unsigned int from, unsigned int to);
 int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 				get_block_t get_block);
 /* Convert errno to return value from ->page_mkwrite() call */
_

Patches currently in -mm which might be from beanhuo@micron.com are

fs-buffer-clean-up-block_commit_write.patch
fs-convert-block_commit_write-to-return-void.patch

