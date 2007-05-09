From: akpm@linux-foundation.org
Subject: - udf-fix-link-counts.patch removed from -mm tree
Date: Wed, 09 May 2007 03:06:08 -0700
Message-ID: <200705091006.l49A69gr020837@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755046AbXEIKGs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 06:06:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     udf: fix link counts
has been removed from the -mm tree.  Its filename was
     udf-fix-link-counts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: udf: fix link counts
From: Jan Kara <jack@suse.cz>

We have to decrease link-count of the parent directory when removing a
subdirectory.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/namei.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/udf/namei.c~udf-fix-link-counts fs/udf/namei.c
--- a/fs/udf/namei.c~udf-fix-link-counts
+++ a/fs/udf/namei.c
@@ -878,7 +878,7 @@ static int udf_rmdir(struct inode * dir,
 			inode->i_nlink);
 	clear_nlink(inode);
 	inode->i_size = 0;
-	inode_dec_link_count(inode);
+	inode_dec_link_count(dir);
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = current_fs_time(dir->i_sb);
 	mark_inode_dirty(dir);
 
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
ext4-copy-i_flags-to-inode-flags-on-write.patch
