From: akpm@linux-foundation.org
Subject: [merged] fat-fix-sb_rdonly-change.patch removed from -mm
 tree
Date: Thu, 30 Nov 2017 12:19:17 -0800
Message-ID: <20171130201917.xqdv3DwJE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52546 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751303AbdK3UTS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 15:19:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, hirofumi@mail.parknet.co.jp, joe@perches.com, mm-commits@vger.kernel.org, stable@vger.kernel.org


The patch titled
     Subject: fs/fat/inode.c: fix sb_rdonly() change
has been removed from the -mm tree.  Its filename was
     fat-fix-sb_rdonly-change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: fs/fat/inode.c: fix sb_rdonly() change

bc98a42c1f7d0f ("VFS: Convert sb->s_flags & MS_RDONLY to sb_rdonly(sb)")
converted fat_remount():new_rdonly from a bool to an int.  However
fat_remount() depends upon the compiler's conversion of a non-zero integer
into boolean `true'.

Fix it by switching `new_rdonly' back into a bool.

Link: http://lkml.kernel.org/r/87mv3d5x51.fsf@mail.parknet.co.jp
Fixes: bc98a42c1f7d0f8 ("VFS: Convert sb->s_flags & MS_RDONLY to sb_rdonly(sb)")
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Joe Perches <joe@perches.com>
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fat/inode.c~fat-fix-sb_rdonly-change fs/fat/inode.c
--- a/fs/fat/inode.c~fat-fix-sb_rdonly-change
+++ a/fs/fat/inode.c
@@ -779,7 +779,7 @@ static void __exit fat_destroy_inodecach
 
 static int fat_remount(struct super_block *sb, int *flags, char *data)
 {
-	int new_rdonly;
+	bool new_rdonly;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	*flags |= SB_NODIRATIME | (sbi->options.isvfat ? 0 : SB_NOATIME);
 
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are


