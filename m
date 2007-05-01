From: akpm@linux-foundation.org
Subject: + udf-decrement-correct-link-count-in-udf_rmdir.patch added to -mm tree
Date: Tue, 01 May 2007 14:01:51 -0700
Message-ID: <200705012101.l41L1pos006652@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946010AbXEAVDM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2007 17:03:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: molletts@yahoo.com, haveblue@us.ibm.com, jack@ucw.cz, stable@kernel.org


The patch titled
     udf: decrement correct link count in udf_rmdir
has been added to the -mm tree.  Its filename is
     udf-decrement-correct-link-count-in-udf_rmdir.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 1 deletion(-)

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

udf-decrement-correct-link-count-in-udf_rmdir.patch
