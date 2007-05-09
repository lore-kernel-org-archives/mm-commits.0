From: akpm@linux-foundation.org
Subject: - udf-decrement-correct-link-count-in-udf_rmdir.patch removed from -mm tree
Date: Tue, 08 May 2007 19:52:05 -0700
Message-ID: <200705090252.l492q5ct009535@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032074AbXEICxX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:53:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: molletts@yahoo.com, haveblue@us.ibm.com, jack@ucw.cz, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     udf: decrement correct link count in udf_rmdir
has been removed from the -mm tree.  Its filename was
     udf-decrement-correct-link-count-in-udf_rmdir.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: udf: decrement correct link count in udf_rmdir
From: Stephen Mollett <molletts@yahoo.com>

It appears that a minor thinko occurred in udf_rmdir and the
(already-cleared) link count on the directory that is being removed was
being decremented instead of the link count on its parent directory.  This
gives rise to lots of kernel messages similar to:

UDF-fs warning (device loop1): udf_rmdir: empty directory has nlink != 2 (8)

when removing directory trees.  No other ill effects have been observed but
I guess it could theoretically result in the link count overflowing on a
very long-lived, much modified directory.

Signed-off-by: Stephen Mollett <molletts@yahoo.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Jan Kara <jack@ucw.cz>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/udf/namei.c~udf-decrement-correct-link-count-in-udf_rmdir fs/udf/namei.c
--- a/fs/udf/namei.c~udf-decrement-correct-link-count-in-udf_rmdir
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

Patches currently in -mm which might be from molletts@yahoo.com are

origin.patch
