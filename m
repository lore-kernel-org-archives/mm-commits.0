From: akpm@linux-foundation.org
Subject: + udf-fix-link-counts.patch added to -mm tree
Date: Tue, 06 Mar 2007 17:20:45 -0800
Message-ID: <200703070120.l271KjA7015369@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41945 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161111AbXCGBUt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 20:20:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz


The patch titled
     udf: fix link counts
has been added to the -mm tree.  Its filename is
     udf-fix-link-counts.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

udf-use-sector_t-and-loff_t-for-file-offsets.patch
udf-introduce-struct-extent_position.patch
udf-use-get_bh.patch
udf-add-assertions.patch
udf-support-files-larger-than-1g.patch
udf-fix-link-counts.patch
