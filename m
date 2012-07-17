From: akpm@linux-foundation.org
Subject: [merged] fs-ufs-re-arrange-the-code-a-bit.patch removed from -mm tree
Date: Tue, 17 Jul 2012 13:05:07 -0700
Message-ID: <20120717200508.1946F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:45067 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab2GQUFM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jul 2012 16:05:12 -0400
Received: by lbbgp10 with SMTP id gp10so53333lbb.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jul 2012 13:05:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: artem.bityutskiy@linux.intel.com, dushistov@mail.ru, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ufs: rearrange the code a bit
has been removed from the -mm tree.  Its filename was
     fs-ufs-re-arrange-the-code-a-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: fs/ufs: rearrange the code a bit

This patch does not make any functional changes.  It only moves 3
functions in fs/ufs/super.c a little bit up in order to prepare for
further changes where I'll need this new arrangement to avoid forward
declarations.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |  117 +++++++++++++++++++++++------------------------
 1 file changed, 58 insertions(+), 59 deletions(-)

diff -puN fs/ufs/super.c~fs-ufs-re-arrange-the-code-a-bit fs/ufs/super.c
--- a/fs/ufs/super.c~fs-ufs-re-arrange-the-code-a-bit
+++ a/fs/ufs/super.c
@@ -691,6 +691,64 @@ static void ufs_put_super_internal(struc
 	UFSD("EXIT\n");
 }
 
+static int ufs_sync_fs(struct super_block *sb, int wait)
+{
+	struct ufs_sb_private_info * uspi;
+	struct ufs_super_block_first * usb1;
+	struct ufs_super_block_third * usb3;
+	unsigned flags;
+
+	lock_ufs(sb);
+	lock_super(sb);
+
+	UFSD("ENTER\n");
+
+	flags = UFS_SB(sb)->s_flags;
+	uspi = UFS_SB(sb)->s_uspi;
+	usb1 = ubh_get_usb_first(uspi);
+	usb3 = ubh_get_usb_third(uspi);
+
+	usb1->fs_time = cpu_to_fs32(sb, get_seconds());
+	if ((flags & UFS_ST_MASK) == UFS_ST_SUN  ||
+	    (flags & UFS_ST_MASK) == UFS_ST_SUNOS ||
+	    (flags & UFS_ST_MASK) == UFS_ST_SUNx86)
+		ufs_set_fs_state(sb, usb1, usb3,
+				UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
+	ufs_put_cstotal(sb);
+	sb->s_dirt = 0;
+
+	UFSD("EXIT\n");
+	unlock_super(sb);
+	unlock_ufs(sb);
+
+	return 0;
+}
+
+static void ufs_write_super(struct super_block *sb)
+{
+	if (!(sb->s_flags & MS_RDONLY))
+		ufs_sync_fs(sb, 1);
+	else
+		sb->s_dirt = 0;
+}
+
+static void ufs_put_super(struct super_block *sb)
+{
+	struct ufs_sb_info * sbi = UFS_SB(sb);
+
+	UFSD("ENTER\n");
+
+	if (!(sb->s_flags & MS_RDONLY))
+		ufs_put_super_internal(sb);
+
+	ubh_brelse_uspi (sbi->s_uspi);
+	kfree (sbi->s_uspi);
+	kfree (sbi);
+	sb->s_fs_info = NULL;
+	UFSD("EXIT\n");
+	return;
+}
+
 static int ufs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct ufs_sb_info * sbi;
@@ -1191,65 +1249,6 @@ failed_nomem:
 	return -ENOMEM;
 }
 
-static int ufs_sync_fs(struct super_block *sb, int wait)
-{
-	struct ufs_sb_private_info * uspi;
-	struct ufs_super_block_first * usb1;
-	struct ufs_super_block_third * usb3;
-	unsigned flags;
-
-	lock_ufs(sb);
-	lock_super(sb);
-
-	UFSD("ENTER\n");
-
-	flags = UFS_SB(sb)->s_flags;
-	uspi = UFS_SB(sb)->s_uspi;
-	usb1 = ubh_get_usb_first(uspi);
-	usb3 = ubh_get_usb_third(uspi);
-
-	usb1->fs_time = cpu_to_fs32(sb, get_seconds());
-	if ((flags & UFS_ST_MASK) == UFS_ST_SUN  ||
-	    (flags & UFS_ST_MASK) == UFS_ST_SUNOS ||
-	    (flags & UFS_ST_MASK) == UFS_ST_SUNx86)
-		ufs_set_fs_state(sb, usb1, usb3,
-				UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
-	ufs_put_cstotal(sb);
-	sb->s_dirt = 0;
-
-	UFSD("EXIT\n");
-	unlock_super(sb);
-	unlock_ufs(sb);
-
-	return 0;
-}
-
-static void ufs_write_super(struct super_block *sb)
-{
-	if (!(sb->s_flags & MS_RDONLY))
-		ufs_sync_fs(sb, 1);
-	else
-		sb->s_dirt = 0;
-}
-
-static void ufs_put_super(struct super_block *sb)
-{
-	struct ufs_sb_info * sbi = UFS_SB(sb);
-		
-	UFSD("ENTER\n");
-
-	if (!(sb->s_flags & MS_RDONLY))
-		ufs_put_super_internal(sb);
-	
-	ubh_brelse_uspi (sbi->s_uspi);
-	kfree (sbi->s_uspi);
-	kfree (sbi);
-	sb->s_fs_info = NULL;
-	UFSD("EXIT\n");
-	return;
-}
-
