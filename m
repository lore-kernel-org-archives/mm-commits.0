From: akpm@linux-foundation.org
Subject: + ufs-ensure-fast-symlinks-are-nul-terminated.patch added to -mm tree
Date: Tue, 13 Jan 2009 00:13:51 -0800
Message-ID: <200901130813.n0D8DpkV011036@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59588 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758854AbZAMIOV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 03:14:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: duaneg@dghda.com


The patch titled
     ufs: ensure fast symlinks are NUL-terminated
has been added to the -mm tree.  Its filename is
     ufs-ensure-fast-symlinks-are-nul-terminated.patch

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
Subject: ufs: ensure fast symlinks are NUL-terminated
From: Duane Griffin <duaneg@dghda.com>

Ensure fast symlink targets are NUL-terminated, even if corrupted
on-disk.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/inode.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/ufs/inode.c~ufs-ensure-fast-symlinks-are-nul-terminated fs/ufs/inode.c
--- a/fs/ufs/inode.c~ufs-ensure-fast-symlinks-are-nul-terminated
+++ a/fs/ufs/inode.c
@@ -650,7 +650,8 @@ static int ufs1_read_inode(struct inode 
 		       sizeof(ufs_inode->ui_u2.ui_addr));
 	} else {
 		memcpy(ufsi->i_u1.i_symlink, ufs_inode->ui_u2.ui_symlink,
-		       sizeof(ufs_inode->ui_u2.ui_symlink));
+		       sizeof(ufs_inode->ui_u2.ui_symlink) - 1);
+		ufsi->i_u1.i_symlink[sizeof(ufs_inode->ui_u2.ui_symlink) - 1] = 0;
 	}
 	return 0;
 }
@@ -698,7 +699,8 @@ static int ufs2_read_inode(struct inode 
 		       sizeof(ufs2_inode->ui_u2.ui_addr));
 	} else {
 		memcpy(ufsi->i_u1.i_symlink, ufs2_inode->ui_u2.ui_symlink,
-		       sizeof(ufs2_inode->ui_u2.ui_symlink));
+		       sizeof(ufs2_inode->ui_u2.ui_symlink) - 1);
+		ufsi->i_u1.i_symlink[sizeof(ufs2_inode->ui_u2.ui_symlink) - 1] = 0;
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from duaneg@dghda.com are

ext4-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext4-tighten-restrictions-on-inode-flags.patch
ufs-validate-maximum-fast-symlink-size-from-superblock.patch
ufs-dont-truncate-longer-ufs2-fast-symlinks.patch
ufs-ensure-fast-symlinks-are-nul-terminated.patch
ufs-copy-symlink-data-into-the-correct-union-member.patch

