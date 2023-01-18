Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1669BC38159
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 21:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbjARVKb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 16:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbjARVJ7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 16:09:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA7063E3A
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 13:09:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4853961A40
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 21:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0573C433D2;
        Wed, 18 Jan 2023 21:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674076156;
        bh=y4FtOylYzHguGf77V7lhuRyGLSEQbZxzH/lh5C6q42A=;
        h=Date:To:From:Subject:From;
        b=otRhnO6Ag9/6oalSlReUHTmgB9wF6prVJmwUDLyE9rcKNQEUwTafgYuas/B8VhJBT
         omL1YGKLv3QAkWP8pLkXPPt/1CP6CjG3hpLpg+/bfzVv8wPsld/B2lq3KELx75i1l8
         6V7y5PiBkyF5KzToVOkGe3Va5v27+BBP41v/PpSY=
Date:   Wed, 18 Jan 2023 13:09:16 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, mark@fasheh.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org, jack@suse.cz,
        dushistov@mail.ru, hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sysv-dont-flush-page-immediately-for-dirsync-directories.patch added to mm-nonmm-unstable branch
Message-Id: <20230118210916.A0573C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysv: don't flush page immediately for DIRSYNC directories
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     sysv-dont-flush-page-immediately-for-dirsync-directories.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sysv-dont-flush-page-immediately-for-dirsync-directories.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Christoph Hellwig <hch@lst.de>
Subject: sysv: don't flush page immediately for DIRSYNC directories
Date: Wed, 18 Jan 2023 18:30:25 +0100

We do not need to writeout modified directory blocks immediately when
modifying them while the page is locked.  It is enough to do the flush
somewhat later which has the added benefit that inode times can be flushed
as well.  It also allows us to stop depending on write_one_page()
function.

Ported from an ext2 patch by Jan Kara.

Link: https://lkml.kernel.org/r/20230118173027.294869-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysv/dir.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

--- a/fs/sysv/dir.c~sysv-dont-flush-page-immediately-for-dirsync-directories
+++ a/fs/sysv/dir.c
@@ -34,21 +34,26 @@ static inline void dir_put_page(struct p
 	put_page(page);
 }
 
-static int dir_commit_chunk(struct page *page, loff_t pos, unsigned len)
+static void dir_commit_chunk(struct page *page, loff_t pos, unsigned len)
 {
 	struct address_space *mapping = page->mapping;
 	struct inode *dir = mapping->host;
-	int err = 0;
 
 	block_write_end(NULL, mapping, pos, len, len, page, NULL);
 	if (pos+len > dir->i_size) {
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
+static int sysv_handle_dirsync(struct inode *dir)
+{
+	int err;
+
+	err = filemap_write_and_wait(dir->i_mapping);
+	if (!err)
+		err = sync_inode_metadata(dir, 1);
 	return err;
 }
 
@@ -215,9 +220,10 @@ got_it:
 	memcpy (de->name, name, namelen);
 	memset (de->name + namelen, 0, SYSV_DIRSIZE - namelen - 2);
 	de->inode = cpu_to_fs16(SYSV_SB(inode->i_sb), inode->i_ino);
-	err = dir_commit_chunk(page, pos, SYSV_DIRSIZE);
+	dir_commit_chunk(page, pos, SYSV_DIRSIZE);
 	dir->i_mtime = dir->i_ctime = current_time(dir);
 	mark_inode_dirty(dir);
+	err = sysv_handle_dirsync(dir);
 out_page:
 	dir_put_page(page);
 out:
@@ -238,11 +244,11 @@ int sysv_delete_entry(struct sysv_dir_en
 	err = sysv_prepare_chunk(page, pos, SYSV_DIRSIZE);
 	BUG_ON(err);
 	de->inode = 0;
-	err = dir_commit_chunk(page, pos, SYSV_DIRSIZE);
+	dir_commit_chunk(page, pos, SYSV_DIRSIZE);
 	dir_put_page(page);
 	inode->i_ctime = inode->i_mtime = current_time(inode);
 	mark_inode_dirty(inode);
-	return err;
+	return sysv_handle_dirsync(inode);
 }
 
 int sysv_make_empty(struct inode *inode, struct inode *dir)
@@ -272,7 +278,8 @@ int sysv_make_empty(struct inode *inode,
 	strcpy(de->name,"..");
 
 	kunmap(page);
-	err = dir_commit_chunk(page, 0, 2 * SYSV_DIRSIZE);
+	dir_commit_chunk(page, 0, 2 * SYSV_DIRSIZE);
+	err = sysv_handle_dirsync(inode);
 fail:
 	put_page(page);
 	return err;
@@ -336,10 +343,11 @@ void sysv_set_link(struct sysv_dir_entry
 	err = sysv_prepare_chunk(page, pos, SYSV_DIRSIZE);
 	BUG_ON(err);
 	de->inode = cpu_to_fs16(SYSV_SB(inode->i_sb), inode->i_ino);
-	err = dir_commit_chunk(page, pos, SYSV_DIRSIZE);
+	dir_commit_chunk(page, pos, SYSV_DIRSIZE);
 	dir_put_page(page);
 	dir->i_mtime = dir->i_ctime = current_time(dir);
 	mark_inode_dirty(dir);
+	sysv_handle_dirsync(inode);
 }
 
 struct sysv_dir_entry * sysv_dotdot (struct inode *dir, struct page **p)
_

Patches currently in -mm which might be from hch@lst.de are

fs-remove-an-outdated-comment-on-mpage_writepages.patch
ntfs3-stop-using-generic_writepages.patch
ntfs3-remove-writepage.patch
jbd2ocfs2-move-jbd2_journal_submit_inode_data_buffers-to-ocfs2.patch
ocfs2-use-filemap_fdatawrite_wbc-instead-of-generic_writepages.patch
mm-remove-generic_writepages.patch
minix-move-releasing-pages-into-unlink-and-rename.patch
minix-fix-error-handling-in-minix_delete_entry.patch
minix-fix-error-handling-in-minix_set_link.patch
minix-dont-flush-page-immediately-for-dirsync-directories.patch
sysv-dont-flush-page-immediately-for-dirsync-directories.patch
ufs-dont-flush-page-immediately-for-dirsync-directories.patch
ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page.patch

