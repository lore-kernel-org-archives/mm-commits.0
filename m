From: akpm@linux-foundation.org
Subject: [merged] ext2-update-also-inode-on-disk-when-dir-is-is_dirsync.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:18:23 -0800
Message-ID: <200901161918.n0GJINRX026968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752652AbZAPTUA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:20:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     ext2: also update the inode on disk when dir is IS_DIRSYNC
has been removed from the -mm tree.  Its filename was
     ext2-update-also-inode-on-disk-when-dir-is-is_dirsync.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2: also update the inode on disk when dir is IS_DIRSYNC
From: Jan Kara <jack@suse.cz>

We used to just write changed page for IS_DIRSYNC inodes.  But we also
have to update the directory inode itself just for the case that we've
allocated a new block and changed i_size.

[akpm@linux-foundation.org: still sync the data page]
Signed-off-by: Jan Kara <jack@suse.cz>
Tested-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/dir.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/ext2/dir.c~ext2-update-also-inode-on-disk-when-dir-is-is_dirsync fs/ext2/dir.c
--- a/fs/ext2/dir.c~ext2-update-also-inode-on-disk-when-dir-is-is_dirsync
+++ a/fs/ext2/dir.c
@@ -95,10 +95,13 @@ static int ext2_commit_chunk(struct page
 		mark_inode_dirty(dir);
 	}
 
-	if (IS_DIRSYNC(dir))
+	if (IS_DIRSYNC(dir)) {
 		err = write_one_page(page, 1);
-	else
+		if (!err)
+			err = ext2_sync_inode(dir);
+	} else {
 		unlock_page(page);
+	}
 
 	return err;
 }
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch
ext2-add-blk_issue_flush-to-syncing-paths.patch

