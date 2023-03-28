Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C251C77B6C
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjC1XW7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjC1XWE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:22:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC21FE0
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48375619FA
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC72C433D2;
        Tue, 28 Mar 2023 23:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045713;
        bh=jAHx5t0Gh39f66wAp5EQbKg74n4Lsdu4IJBOkNih6pY=;
        h=Date:To:From:Subject:From;
        b=bExBHX5SIPTiRhg5lV9muTQxvTwgFnZxHZWjpDxh3hM7P0zqtELneXXesU2xCQm//
         38WL4JNJcox5c14+yGikZizF0LQo2vHmI2rtFQWWRGWrm0rbDwCgLLYpp5T+DH7AQX
         9AFV7IHgtLDH31/O4XjWTcbmHmK+uyc0L97foTnE=
Date:   Tue, 28 Mar 2023 16:21:53 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        piaojun@huawei.com, ocfs2-devel@oss.oracle.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, jiangqi903@gmail.com, jack@suse.cz,
        ghe@suse.com, gechangwei@live.cn, dushistov@mail.ru,
        dave.kleikamp@oracle.com, hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ufs-dont-flush-page-immediately-for-dirsync-directories.patch removed from -mm tree
Message-Id: <20230328232153.9FC72C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ufs: don't flush page immediately for DIRSYNC directories
has been removed from the -mm tree.  Its filename was
     ufs-dont-flush-page-immediately-for-dirsync-directories.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: ufs: don't flush page immediately for DIRSYNC directories
Date: Tue, 7 Mar 2023 15:31:23 +0100

Patch series "remove most callers of write_one_page", v4.

This series removes most users of the write_one_page API.  These helpers
internally call ->writepage which we are gradually removing from the
kernel.


This patch (of 3):

We do not need to writeout modified directory blocks immediately when
modifying them while the page is locked.  It is enough to do the flush
somewhat later which has the added benefit that inode times can be flushed
as well.  It also allows us to stop depending on write_one_page()
function.

Ported from an ext2 patch by Jan Kara.

Link: https://lkml.kernel.org/r/20230307143125.27778-1-hch@lst.de
Link: https://lkml.kernel.org/r/20230307143125.27778-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/dir.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/fs/ufs/dir.c~ufs-dont-flush-page-immediately-for-dirsync-directories
+++ a/fs/ufs/dir.c
@@ -42,11 +42,10 @@ static inline int ufs_match(struct super
 	return !memcmp(name, de->d_name, len);
 }
 
-static int ufs_commit_chunk(struct page *page, loff_t pos, unsigned len)
+static void ufs_commit_chunk(struct page *page, loff_t pos, unsigned len)
 {
 	struct address_space *mapping = page->mapping;
 	struct inode *dir = mapping->host;
-	int err = 0;
 
 	inode_inc_iversion(dir);
 	block_write_end(NULL, mapping, pos, len, len, page, NULL);
@@ -54,10 +53,16 @@ static int ufs_commit_chunk(struct page
 		i_size_write(dir, pos+len);
 		mark_inode_dirty(dir);
 	}
-	if (IS_DIRSYNC(dir))
-		err = write_one_page(page);
-	else
-		unlock_page(page);
+	unlock_page(page);
+}
+
+static int ufs_handle_dirsync(struct inode *dir)
+{
+	int err;
+
+	err = filemap_write_and_wait(dir->i_mapping);
+	if (!err)
+		err = sync_inode_metadata(dir, 1);
 	return err;
 }
 
@@ -99,11 +104,12 @@ void ufs_set_link(struct inode *dir, str
 	de->d_ino = cpu_to_fs32(dir->i_sb, inode->i_ino);
 	ufs_set_de_type(dir->i_sb, de, inode->i_mode);
 
-	err = ufs_commit_chunk(page, pos, len);
+	ufs_commit_chunk(page, pos, len);
 	ufs_put_page(page);
 	if (update_times)
 		dir->i_mtime = dir->i_ctime = current_time(dir);
 	mark_inode_dirty(dir);
+	ufs_handle_dirsync(dir);
 }
 
 
@@ -390,10 +396,11 @@ got_it:
 	de->d_ino = cpu_to_fs32(sb, inode->i_ino);
 	ufs_set_de_type(sb, de, inode->i_mode);
 
-	err = ufs_commit_chunk(page, pos, rec_len);
+	ufs_commit_chunk(page, pos, rec_len);
 	dir->i_mtime = dir->i_ctime = current_time(dir);
 
 	mark_inode_dirty(dir);
+	err = ufs_handle_dirsync(dir);
 	/* OFFSET_CACHE */
 out_put:
 	ufs_put_page(page);
@@ -531,9 +538,10 @@ int ufs_delete_entry(struct inode *inode
 	if (pde)
 		pde->d_reclen = cpu_to_fs16(sb, to - from);
 	dir->d_ino = 0;
-	err = ufs_commit_chunk(page, pos, to - from);
+	ufs_commit_chunk(page, pos, to - from);
 	inode->i_ctime = inode->i_mtime = current_time(inode);
 	mark_inode_dirty(inode);
+	err = ufs_handle_dirsync(inode);
 out:
 	ufs_put_page(page);
 	UFSD("EXIT\n");
@@ -579,7 +587,8 @@ int ufs_make_empty(struct inode * inode,
 	strcpy (de->d_name, "..");
 	kunmap(page);
 
-	err = ufs_commit_chunk(page, 0, chunk_size);
+	ufs_commit_chunk(page, 0, chunk_size);
+	err = ufs_handle_dirsync(inode);
 fail:
 	put_page(page);
 	return err;
_

Patches currently in -mm which might be from hch@lst.de are

mm-dont-look-at-xarray-value-entries-in-split_huge_pages_in_file.patch
mm-make-mapping_get_entry-available-outside-of-filemapc.patch
mm-use-filemap_get_entry-in-filemap_get_incore_folio.patch
shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp.patch
mm-remove-fgp_entry.patch
mm-return-an-err_ptr-from-__filemap_get_folio.patch
mm-return-an-err_ptr-from-__filemap_get_folio-fix.patch

