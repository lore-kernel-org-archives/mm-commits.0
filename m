From: akpm@linux-foundation.org
Subject: - avoid-one-conditional-branch-in-touch_atime.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:50:30 -0800
Message-ID: <200702112250.l1BMoUnS015861@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60061 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932745AbXBKWu5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:50:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, mm-commits@vger.kernel.org


The patch titled
     avoid one conditional branch in touch_atime()
has been removed from the -mm tree.  Its filename was
     avoid-one-conditional-branch-in-touch_atime.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: avoid one conditional branch in touch_atime()
From: Eric Dumazet <dada1@cosmosbay.com>

I added IS_NOATIME(inode) macro definition in include/linux/fs.h, true if
the inode superblock is marked readonly or noatime.

This new macro is then used in touch_atime() instead of separatly testing
MS_RDONLY and MS_NOATIME

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c         |    4 +---
 include/linux/fs.h |    1 +
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/inode.c~avoid-one-conditional-branch-in-touch_atime fs/inode.c
--- a/fs/inode.c~avoid-one-conditional-branch-in-touch_atime
+++ a/fs/inode.c
@@ -1160,11 +1160,9 @@ void touch_atime(struct vfsmount *mnt, s
 	struct inode *inode = dentry->d_inode;
 	struct timespec now;
 
-	if (IS_RDONLY(inode))
-		return;
 	if (inode->i_flags & S_NOATIME)
 		return;
-	if (inode->i_sb->s_flags & MS_NOATIME)
+	if (IS_NOATIME(inode))
 		return;
 	if ((inode->i_sb->s_flags & MS_NODIRATIME) && S_ISDIR(inode->i_mode))
 		return;
diff -puN include/linux/fs.h~avoid-one-conditional-branch-in-touch_atime include/linux/fs.h
--- a/include/linux/fs.h~avoid-one-conditional-branch-in-touch_atime
+++ a/include/linux/fs.h
@@ -169,6 +169,7 @@ extern int dir_notify_enable;
 #define IS_DIRSYNC(inode)	(__IS_FLG(inode, MS_SYNCHRONOUS|MS_DIRSYNC) || \
 					((inode)->i_flags & (S_SYNC|S_DIRSYNC)))
 #define IS_MANDLOCK(inode)	__IS_FLG(inode, MS_MANDLOCK)
+#define IS_NOATIME(inode)   __IS_FLG(inode, MS_RDONLY|MS_NOATIME)
 
 #define IS_NOQUOTA(inode)	((inode)->i_flags & S_NOQUOTA)
 #define IS_APPEND(inode)	((inode)->i_flags & S_APPEND)
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
fs-speedup-rw_verify_area.patch
close_files-add-scheduling-point.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
