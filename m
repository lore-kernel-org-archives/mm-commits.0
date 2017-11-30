From: akpm@linux-foundation.org
Subject: [patch 24/28] fs/fat/inode.c: fix sb_rdonly() change
Date: Wed, 29 Nov 2017 16:11:19 -0800
Message-ID: <5a1f4ca7.vqacpTpnCh2C8AdG%akpm__15666.7778770954$1512000682$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60804 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753593AbdK3ALV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 19:11:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hirofumi@mail.parknet.co.jp, dhowells@redhat.com, joe@perches.com, stable@vger.kernel.org

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
