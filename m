From: akpm@linux-foundation.org
Subject: - ufs2-more-correct-work-with-time.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:08:46 -0800
Message-ID: <200703180908.l2I98kGg019974@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60381 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbXCRJJF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:09:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dushistov@mail.ru, bjoern@j3e.de, mm-commits@vger.kernel.org


The patch titled
     ufs2: more correct work with time
has been removed from the -mm tree.  Its filename was
     ufs2-more-correct-work-with-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ufs2: more correct work with time
From: Evgeniy Dushistov <dushistov@mail.ru>

This patch corrects work with time in UFS2 case.

1) According to UFS2 disk layout modification/access and so on "time"
   should be hold in two variables one 64bit for seconds and another 32bit for
   nanoseconds,

   at now for some unknown reason we suppose that "inode time" holds in
   three variables 32bit for seconds, 32bit for milliseconds and 32bit for
   nanoseconds.

2) We set amount of nanoseconds in "VFS inode" to 0 during read, instead of
   getting values from "on disk inode"(this should close
   http://bugzilla.kernel.org/show_bug.cgi?id=7991).

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Bjoern Jacke <bjoern@j3e.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/ialloc.c        |    5 ++---
 fs/ufs/inode.c         |   24 ++++++++++++------------
 include/linux/ufs_fs.h |    8 ++++----
 3 files changed, 18 insertions(+), 19 deletions(-)

diff -puN fs/ufs/ialloc.c~ufs2-more-correct-work-with-time fs/ufs/ialloc.c
--- a/fs/ufs/ialloc.c~ufs2-more-correct-work-with-time
+++ a/fs/ufs/ialloc.c
@@ -343,9 +343,8 @@ cg_found:
 		lock_buffer(bh);
 		ufs2_inode = (struct ufs2_inode *)bh->b_data;
 		ufs2_inode += ufs_inotofsbo(inode->i_ino);
-		ufs2_inode->ui_birthtime.tv_sec =
-			cpu_to_fs32(sb, CURRENT_TIME_SEC.tv_sec);
-		ufs2_inode->ui_birthtime.tv_usec = 0;
+		ufs2_inode->ui_birthtime = cpu_to_fs64(sb, CURRENT_TIME.tv_sec);
+		ufs2_inode->ui_birthnsec = cpu_to_fs32(sb, CURRENT_TIME.tv_nsec);
 		mark_buffer_dirty(bh);
 		unlock_buffer(bh);
 		if (sb->s_flags & MS_SYNCHRONOUS)
diff -puN fs/ufs/inode.c~ufs2-more-correct-work-with-time fs/ufs/inode.c
--- a/fs/ufs/inode.c~ufs2-more-correct-work-with-time
+++ a/fs/ufs/inode.c
@@ -668,12 +668,12 @@ static void ufs2_read_inode(struct inode
 	inode->i_gid = fs32_to_cpu(sb, ufs2_inode->ui_gid);
 
 	inode->i_size = fs64_to_cpu(sb, ufs2_inode->ui_size);
-	inode->i_atime.tv_sec = fs32_to_cpu(sb, ufs2_inode->ui_atime.tv_sec);
-	inode->i_ctime.tv_sec = fs32_to_cpu(sb, ufs2_inode->ui_ctime.tv_sec);
-	inode->i_mtime.tv_sec = fs32_to_cpu(sb, ufs2_inode->ui_mtime.tv_sec);
-	inode->i_mtime.tv_nsec = 0;
-	inode->i_atime.tv_nsec = 0;
-	inode->i_ctime.tv_nsec = 0;
+	inode->i_atime.tv_sec = fs64_to_cpu(sb, ufs2_inode->ui_atime);
+	inode->i_ctime.tv_sec = fs64_to_cpu(sb, ufs2_inode->ui_ctime);
+	inode->i_mtime.tv_sec = fs64_to_cpu(sb, ufs2_inode->ui_mtime);
+	inode->i_atime.tv_nsec = fs32_to_cpu(sb, ufs2_inode->ui_atimensec);
+	inode->i_ctime.tv_nsec = fs32_to_cpu(sb, ufs2_inode->ui_ctimensec);
+	inode->i_mtime.tv_nsec = fs32_to_cpu(sb, ufs2_inode->ui_mtimensec);
 	inode->i_blocks = fs64_to_cpu(sb, ufs2_inode->ui_blocks);
 	inode->i_generation = fs32_to_cpu(sb, ufs2_inode->ui_gen);
 	ufsi->i_flags = fs32_to_cpu(sb, ufs2_inode->ui_flags);
@@ -803,12 +803,12 @@ static void ufs2_update_inode(struct ino
 	ufs_inode->ui_gid = cpu_to_fs32(sb, inode->i_gid);
 
 	ufs_inode->ui_size = cpu_to_fs64(sb, inode->i_size);
-	ufs_inode->ui_atime.tv_sec = cpu_to_fs32(sb, inode->i_atime.tv_sec);
-	ufs_inode->ui_atime.tv_usec = 0;
-	ufs_inode->ui_ctime.tv_sec = cpu_to_fs32(sb, inode->i_ctime.tv_sec);
-	ufs_inode->ui_ctime.tv_usec = 0;
-	ufs_inode->ui_mtime.tv_sec = cpu_to_fs32(sb, inode->i_mtime.tv_sec);
-	ufs_inode->ui_mtime.tv_usec = 0;
+	ufs_inode->ui_atime = cpu_to_fs64(sb, inode->i_atime.tv_sec);
+	ufs_inode->ui_atimensec = cpu_to_fs32(sb, inode->i_atime.tv_nsec);
+	ufs_inode->ui_ctime = cpu_to_fs64(sb, inode->i_ctime.tv_sec);
+	ufs_inode->ui_ctimensec = cpu_to_fs32(sb, inode->i_ctime.tv_nsec);
+	ufs_inode->ui_mtime = cpu_to_fs64(sb, inode->i_mtime.tv_sec);
+	ufs_inode->ui_mtimensec = cpu_to_fs32(sb, inode->i_mtime.tv_nsec);
 
 	ufs_inode->ui_blocks = cpu_to_fs64(sb, inode->i_blocks);
 	ufs_inode->ui_flags = cpu_to_fs32(sb, ufsi->i_flags);
diff -puN include/linux/ufs_fs.h~ufs2-more-correct-work-with-time include/linux/ufs_fs.h
--- a/include/linux/ufs_fs.h~ufs2-more-correct-work-with-time
+++ a/include/linux/ufs_fs.h
@@ -649,10 +649,10 @@ struct ufs2_inode {
 	__fs32     ui_blksize;     /*  12: Inode blocksize. */
 	__fs64     ui_size;        /*  16: File byte count. */
 	__fs64     ui_blocks;      /*  24: Bytes actually held. */
-	struct ufs_timeval   ui_atime;       /*  32: Last access time. */
-	struct ufs_timeval   ui_mtime;       /*  40: Last modified time. */
-	struct ufs_timeval   ui_ctime;       /*  48: Last inode change time. */
-	struct ufs_timeval   ui_birthtime;   /*  56: Inode creation time. */
+	__fs64   ui_atime;       /*  32: Last access time. */
+	__fs64   ui_mtime;       /*  40: Last modified time. */
+	__fs64   ui_ctime;       /*  48: Last inode change time. */
+	__fs64   ui_birthtime;   /*  56: Inode creation time. */
 	__fs32     ui_mtimensec;   /*  64: Last modified time. */
 	__fs32     ui_atimensec;   /*  68: Last access time. */
 	__fs32     ui_ctimensec;   /*  72: Last inode change time. */
_

Patches currently in -mm which might be from dushistov@mail.ru are

origin.patch
