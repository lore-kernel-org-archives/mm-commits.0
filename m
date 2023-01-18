Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 898DCC32793
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 21:10:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbjARVKa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 16:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbjARVJ6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 16:09:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7222C63E37
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 13:09:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1516AB81F17
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 21:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDD4C433D2;
        Wed, 18 Jan 2023 21:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674076154;
        bh=y+LjEFDQUKkMitZzdFLoWyxfGTNwFTBPG8U8RKym+uw=;
        h=Date:To:From:Subject:From;
        b=TmAhroY8ZCBANHzldOuBHXe4v6bGNziy2imLbofz6XS+MyK4oE4ZsFhk9uxVr0WN6
         sDMdeoiM5un7BrwDPMwJcjgNQTSF5uFrRMPFZAGoYGhuzL14yvRs3xrbb6VibDbgmA
         g1JXRh9vo/gBWnYVtfM9uaczExfMAYO25avVMAQY=
Date:   Wed, 18 Jan 2023 13:09:14 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, mark@fasheh.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org, jack@suse.cz,
        dushistov@mail.ru, hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + minix-dont-flush-page-immediately-for-dirsync-directories.patch added to mm-nonmm-unstable branch
Message-Id: <20230118210914.AFDD4C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: minix: don't flush page immediately for DIRSYNC directories
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     minix-dont-flush-page-immediately-for-dirsync-directories.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/minix-dont-flush-page-immediately-for-dirsync-directories.patch

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
Subject: minix: don't flush page immediately for DIRSYNC directories
Date: Wed, 18 Jan 2023 18:30:24 +0100

We do not need to writeout modified directory blocks immediately when
modifying them while the page is locked.  It is enough to do the flush
somewhat later which has the added benefit that inode times can be flushed
as well.  It also allows us to stop depending on write_one_page()
function.

Ported from an ext2 patch by Jan Kara.

Link: https://lkml.kernel.org/r/20230118173027.294869-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/dir.c |   36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

--- a/fs/minix/dir.c~minix-dont-flush-page-immediately-for-dirsync-directories
+++ a/fs/minix/dir.c
@@ -46,21 +46,27 @@ minix_last_byte(struct inode *inode, uns
 	return last_byte;
 }
 
-static int dir_commit_chunk(struct page *page, loff_t pos, unsigned len)
+static void dir_commit_chunk(struct page *page, loff_t pos, unsigned len)
 {
 	struct address_space *mapping = page->mapping;
 	struct inode *dir = mapping->host;
-	int err = 0;
+
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
+static int minix_handle_dirsync(struct inode *dir)
+{
+	int err;
+
+	err = filemap_write_and_wait(dir->i_mapping);
+	if (!err)
+		err = sync_inode_metadata(dir, 1);
 	return err;
 }
 
@@ -274,9 +280,10 @@ got_it:
 		memset (namx + namelen, 0, sbi->s_dirsize - namelen - 2);
 		de->inode = inode->i_ino;
 	}
-	err = dir_commit_chunk(page, pos, sbi->s_dirsize);
+	dir_commit_chunk(page, pos, sbi->s_dirsize);
 	dir->i_mtime = dir->i_ctime = current_time(dir);
 	mark_inode_dirty(dir);
+	err = minix_handle_dirsync(dir);
 out_put:
 	dir_put_page(page);
 out:
@@ -305,12 +312,10 @@ int minix_delete_entry(struct minix_dir_
 		((minix3_dirent *)de)->inode = 0;
 	else
 		de->inode = 0;
-	err = dir_commit_chunk(page, pos, len);
-	if (err)
-		return err;
+	dir_commit_chunk(page, pos, len);
 	inode->i_ctime = inode->i_mtime = current_time(inode);
 	mark_inode_dirty(inode);
-	return 0;
+	return minix_handle_dirsync(inode);
 }
 
 int minix_make_empty(struct inode *inode, struct inode *dir)
@@ -350,7 +355,8 @@ int minix_make_empty(struct inode *inode
 	}
 	kunmap_atomic(kaddr);
 
-	err = dir_commit_chunk(page, 0, 2 * sbi->s_dirsize);
+	dir_commit_chunk(page, 0, 2 * sbi->s_dirsize);
+	err = minix_handle_dirsync(inode);
 fail:
 	put_page(page);
 	return err;
@@ -429,12 +435,10 @@ int minix_set_link(struct minix_dir_entr
 		((minix3_dirent *)de)->inode = inode->i_ino;
 	else
 		de->inode = inode->i_ino;
-	err = dir_commit_chunk(page, pos, sbi->s_dirsize);
-	if (err)
-		return err;
+	dir_commit_chunk(page, pos, sbi->s_dirsize);
 	dir->i_mtime = dir->i_ctime = current_time(dir);
 	mark_inode_dirty(dir);
-	return 0;
+	return minix_handle_dirsync(dir);
 }
 
 struct minix_dir_entry * minix_dotdot (struct inode *dir, struct page **p)
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

