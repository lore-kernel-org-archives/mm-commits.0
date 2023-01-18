Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ACFBC38147
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 21:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbjARVKZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 16:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbjARVJy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 16:09:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65276630A2
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 13:09:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1B49B81F18
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 21:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60495C433D2;
        Wed, 18 Jan 2023 21:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674076152;
        bh=xc3q2Ng50eYbv3UDJpNqMZwFlXXeWgZ8M9vx+ug/YOk=;
        h=Date:To:From:Subject:From;
        b=XpiNPpWvh4V37xTtClYVTBZSbHqIlMl2La55U8ruW83gR0DSLgoIQqCcwfLIHZUJW
         QvK3+1ZgGWOAXSTSnJG1GEuDc/AEscKnkeVOU/K2rtwISwT969eCuAhXTSnXQXbSO2
         0XVt6Lg+qZsDMEdV/kR7uhopzFdnBOr4vnq+Wr3s=
Date:   Wed, 18 Jan 2023 13:09:11 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, mark@fasheh.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org, jack@suse.cz,
        dushistov@mail.ru, hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + minix-fix-error-handling-in-minix_set_link.patch added to mm-nonmm-unstable branch
Message-Id: <20230118210912.60495C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: minix: fix error handling in minix_set_link
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     minix-fix-error-handling-in-minix_set_link.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/minix-fix-error-handling-in-minix_set_link.patch

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
Subject: minix: fix error handling in minix_set_link
Date: Wed, 18 Jan 2023 18:30:23 +0100

If minix_prepare_chunk fails, updating c/mtime and marking the dir inode
dirty is wrong, as the inode hasn't been modified.  Also propagate the
error to the caller.

Note that this moves the dir_put_page call later, but that matches other
uses of this helper in the directory code.

Link: https://lkml.kernel.org/r/20230118173027.294869-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/dir.c   |   22 ++++++++++++----------
 fs/minix/minix.h |    3 ++-
 fs/minix/namei.c |   10 ++++++----
 3 files changed, 20 insertions(+), 15 deletions(-)

--- a/fs/minix/dir.c~minix-fix-error-handling-in-minix_set_link
+++ a/fs/minix/dir.c
@@ -410,8 +410,8 @@ not_empty:
 }
 
 /* Releases the page */
-void minix_set_link(struct minix_dir_entry *de, struct page *page,
-	struct inode *inode)
+int minix_set_link(struct minix_dir_entry *de, struct page *page,
+		struct inode *inode)
 {
 	struct inode *dir = page->mapping->host;
 	struct minix_sb_info *sbi = minix_sb(dir->i_sb);
@@ -420,19 +420,21 @@ void minix_set_link(struct minix_dir_ent
 	int err;
 
 	lock_page(page);
-
 	err = minix_prepare_chunk(page, pos, sbi->s_dirsize);
-	if (err == 0) {
-		if (sbi->s_version == MINIX_V3)
-			((minix3_dirent *) de)->inode = inode->i_ino;
-		else
-			de->inode = inode->i_ino;
-		err = dir_commit_chunk(page, pos, sbi->s_dirsize);
-	} else {
+	if (err) {
 		unlock_page(page);
+		return err;
 	}
+	if (sbi->s_version == MINIX_V3)
+		((minix3_dirent *)de)->inode = inode->i_ino;
+	else
+		de->inode = inode->i_ino;
+	err = dir_commit_chunk(page, pos, sbi->s_dirsize);
+	if (err)
+		return err;
 	dir->i_mtime = dir->i_ctime = current_time(dir);
 	mark_inode_dirty(dir);
+	return 0;
 }
 
 struct minix_dir_entry * minix_dotdot (struct inode *dir, struct page **p)
--- a/fs/minix/minix.h~minix-fix-error-handling-in-minix_set_link
+++ a/fs/minix/minix.h
@@ -69,7 +69,8 @@ extern int minix_add_link(struct dentry*
 extern int minix_delete_entry(struct minix_dir_entry*, struct page*);
 extern int minix_make_empty(struct inode*, struct inode*);
 extern int minix_empty_dir(struct inode*);
-extern void minix_set_link(struct minix_dir_entry*, struct page*, struct inode*);
+int minix_set_link(struct minix_dir_entry *de, struct page *page,
+		struct inode *inode);
 extern struct minix_dir_entry *minix_dotdot(struct inode*, struct page**);
 extern ino_t minix_inode_by_name(struct dentry*);
 
--- a/fs/minix/namei.c~minix-fix-error-handling-in-minix_set_link
+++ a/fs/minix/namei.c
@@ -223,10 +223,11 @@ static int minix_rename(struct user_name
 		new_de = minix_find_entry(new_dentry, &new_page);
 		if (!new_de)
 			goto out_dir;
-		err = 0;
-		minix_set_link(new_de, new_page, old_inode);
+		err = minix_set_link(new_de, new_page, old_inode);
 		kunmap(new_page);
 		put_page(new_page);
+		if (err)
+			goto out_dir;
 		new_inode->i_ctime = current_time(new_inode);
 		if (dir_de)
 			drop_nlink(new_inode);
@@ -243,8 +244,9 @@ static int minix_rename(struct user_name
 	mark_inode_dirty(old_inode);
 
 	if (dir_de) {
-		minix_set_link(dir_de, dir_page, new_dir);
-		inode_dec_link_count(old_dir);
+		err = minix_set_link(dir_de, dir_page, new_dir);
+		if (!err)
+			inode_dec_link_count(old_dir);
 	}
 out_dir:
 	if (dir_de) {
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

