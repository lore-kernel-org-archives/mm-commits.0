Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 317C9C32793
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 21:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbjARVKB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 16:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbjARVJv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 16:09:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626F062D22
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 13:09:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3C35B81F16
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 21:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE45C433F0;
        Wed, 18 Jan 2023 21:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674076148;
        bh=6G67GnaTwR8Ks7wP2RO13PHFahU4UcFNkh0E3xzFob8=;
        h=Date:To:From:Subject:From;
        b=pOocA8L8AKiAe9mY/exf/8wqeMkj+Oqr8c1lI3nojQqX2pZpX42l4mWunajxhcfdY
         OM1gzWfBnQU3tM0OrIt+Vz9n9+YVBwXB5RpPGoLwvYNJy2vKnu/oP7gsgYs4ylGBx9
         jvoc2hgiMMdjnEB46lY9HfdKBzAuGuBD3kZn+x18=
Date:   Wed, 18 Jan 2023 13:09:07 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, mark@fasheh.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org, jack@suse.cz,
        dushistov@mail.ru, hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + minix-move-releasing-pages-into-unlink-and-rename.patch added to mm-nonmm-unstable branch
Message-Id: <20230118210908.6DE45C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: minix: move releasing pages into unlink and rename
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     minix-move-releasing-pages-into-unlink-and-rename.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/minix-move-releasing-pages-into-unlink-and-rename.patch

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
Subject: minix: move releasing pages into unlink and rename
Date: Wed, 18 Jan 2023 18:30:21 +0100

Patch series "remove most callers of write_one_page", v3.

This series removes most users of the write_one_page API.  These helpers
internally call ->writepage which we are gradually removing from the
kernel.


This patch (of 7):

Instead of consuming the page reference and kmap in the low-level
minix_delete_entry and minix_set_link helpers, do it in the callers where
that code can be shared with the error cleanup path.

Link: https://lkml.kernel.org/r/20230118173027.294869-1-hch@lst.de
Link: https://lkml.kernel.org/r/20230118173027.294869-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/dir.c   |    2 --
 fs/minix/namei.c |   19 ++++++++++---------
 2 files changed, 10 insertions(+), 11 deletions(-)

--- a/fs/minix/dir.c~minix-move-releasing-pages-into-unlink-and-rename
+++ a/fs/minix/dir.c
@@ -306,7 +306,6 @@ int minix_delete_entry(struct minix_dir_
 	} else {
 		unlock_page(page);
 	}
-	dir_put_page(page);
 	inode->i_ctime = inode->i_mtime = current_time(inode);
 	mark_inode_dirty(inode);
 	return err;
@@ -430,7 +429,6 @@ void minix_set_link(struct minix_dir_ent
 	} else {
 		unlock_page(page);
 	}
-	dir_put_page(page);
 	dir->i_mtime = dir->i_ctime = current_time(dir);
 	mark_inode_dirty(dir);
 }
--- a/fs/minix/namei.c~minix-move-releasing-pages-into-unlink-and-rename
+++ a/fs/minix/namei.c
@@ -150,23 +150,23 @@ out_dir:
 
 static int minix_unlink(struct inode * dir, struct dentry *dentry)
 {
-	int err = -ENOENT;
 	struct inode * inode = d_inode(dentry);
 	struct page * page;
 	struct minix_dir_entry * de;
+	int err;
 
 	de = minix_find_entry(dentry, &page);
 	if (!de)
-		goto end_unlink;
-
+		return -ENOENT;
 	err = minix_delete_entry(de, page);
-	if (err)
-		goto end_unlink;
+	kunmap(page);
+	put_page(page);
 
+	if (err)
+		return err;
 	inode->i_ctime = dir->i_ctime;
 	inode_dec_link_count(inode);
-end_unlink:
-	return err;
+	return 0;
 }
 
 static int minix_rmdir(struct inode * dir, struct dentry *dentry)
@@ -223,7 +223,10 @@ static int minix_rename(struct user_name
 		new_de = minix_find_entry(new_dentry, &new_page);
 		if (!new_de)
 			goto out_dir;
+		err = 0;
 		minix_set_link(new_de, new_page, old_inode);
+		kunmap(new_page);
+		put_page(new_page);
 		new_inode->i_ctime = current_time(new_inode);
 		if (dir_de)
 			drop_nlink(new_inode);
@@ -243,8 +246,6 @@ static int minix_rename(struct user_name
 		minix_set_link(dir_de, dir_page, new_dir);
 		inode_dec_link_count(old_dir);
 	}
-	return 0;
-
 out_dir:
 	if (dir_de) {
 		kunmap(dir_page);
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

