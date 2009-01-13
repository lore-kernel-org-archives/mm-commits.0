From: akpm@linux-foundation.org
Subject: + ufs-copy-symlink-data-into-the-correct-union-member.patch added to -mm tree
Date: Tue, 13 Jan 2009 00:13:52 -0800
Message-ID: <200901130813.n0D8Dq7r011040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758871AbZAMIOY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 03:14:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: duaneg@dghda.com


The patch titled
     ufs: copy symlink data into the correct union member
has been added to the -mm tree.  Its filename is
     ufs-copy-symlink-data-into-the-correct-union-member.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ufs: copy symlink data into the correct union member
From: Duane Griffin <duaneg@dghda.com>

Copy symlink data into the union member it is accessed through.  Although
this shouldn't make a difference to behaviour it makes the code easier to
follow and grep through.  It may also prevent problems if the struct/union
definitions change in the future.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ufs/namei.c~ufs-copy-symlink-data-into-the-correct-union-member fs/ufs/namei.c
--- a/fs/ufs/namei.c~ufs-copy-symlink-data-into-the-correct-union-member
+++ a/fs/ufs/namei.c
@@ -147,7 +147,7 @@ static int ufs_symlink (struct inode * d
 	} else {
 		/* fast symlink */
 		inode->i_op = &ufs_fast_symlink_inode_operations;
-		memcpy((char*)&UFS_I(inode)->i_u1.i_data,symname,l);
+		memcpy(UFS_I(inode)->i_u1.i_symlink, symname, l);
 		inode->i_size = l-1;
 	}
 	mark_inode_dirty(inode);
_

Patches currently in -mm which might be from duaneg@dghda.com are

ext4-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext4-tighten-restrictions-on-inode-flags.patch
ufs-validate-maximum-fast-symlink-size-from-superblock.patch
ufs-dont-truncate-longer-ufs2-fast-symlinks.patch
ufs-ensure-fast-symlinks-are-nul-terminated.patch
ufs-copy-symlink-data-into-the-correct-union-member.patch

