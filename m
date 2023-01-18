Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39D83C38147
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 21:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbjARVKC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 16:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjARVJw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 16:09:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2879613C0
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 13:09:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13CDF61A34
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 21:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EDCAC433EF;
        Wed, 18 Jan 2023 21:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674076150;
        bh=j5ch8z4P33iuF2rMLHi1vrxhW81MqFYmQ4QyCBAgKJU=;
        h=Date:To:From:Subject:From;
        b=UXBAwjjGScQCpOcAW8XEDikiQgdT19GiHheiE5x7qU/rujwallXWobGgwtOLJBagE
         pu9b+E0lU0YfeJQAqMBe8HRJHzp+DkUFRJQh7AVLjhrlgTHBxOCVeITIIbZGmklsg4
         +GHPFk8b3mbTTckzdaANmpd7y+22KwgchJX3nwDg=
Date:   Wed, 18 Jan 2023 13:09:09 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, mark@fasheh.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org, jack@suse.cz,
        dushistov@mail.ru, hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + minix-fix-error-handling-in-minix_delete_entry.patch added to mm-nonmm-unstable branch
Message-Id: <20230118210910.6EDCAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: minix: fix error handling in minix_delete_entry
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     minix-fix-error-handling-in-minix_delete_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/minix-fix-error-handling-in-minix_delete_entry.patch

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
Subject: minix: fix error handling in minix_delete_entry
Date: Wed, 18 Jan 2023 18:30:22 +0100

If minix_prepare_chunk fails, updating c/mtime and marking the dir inode
dirty is wrong, as the inode hasn't been modified.

Link: https://lkml.kernel.org/r/20230118173027.294869-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/dir.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/fs/minix/dir.c~minix-fix-error-handling-in-minix_delete_entry
+++ a/fs/minix/dir.c
@@ -297,18 +297,20 @@ int minix_delete_entry(struct minix_dir_
 
 	lock_page(page);
 	err = minix_prepare_chunk(page, pos, len);
-	if (err == 0) {
-		if (sbi->s_version == MINIX_V3)
-			((minix3_dirent *) de)->inode = 0;
-		else
-			de->inode = 0;
-		err = dir_commit_chunk(page, pos, len);
-	} else {
+	if (err) {
 		unlock_page(page);
+		return err;
 	}
+	if (sbi->s_version == MINIX_V3)
+		((minix3_dirent *)de)->inode = 0;
+	else
+		de->inode = 0;
+	err = dir_commit_chunk(page, pos, len);
+	if (err)
+		return err;
 	inode->i_ctime = inode->i_mtime = current_time(inode);
 	mark_inode_dirty(inode);
-	return err;
+	return 0;
 }
 
 int minix_make_empty(struct inode *inode, struct inode *dir)
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

