From: akpm@linux-foundation.org
Subject: - romfs-romfs_iget-unsigned-ino-=-0-is-always-true.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:51:05 -0800
Message-ID: <200901082251.n08Mp5bk030240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763375AbZAHWvJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     romfs: romfs_iget() - unsigned ino >= 0 is always true
has been removed from the -mm tree.  Its filename was
     romfs-romfs_iget-unsigned-ino-=-0-is-always-true.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: romfs: romfs_iget() - unsigned ino >= 0 is always true
From: roel kluin <roel.kluin@gmail.com>

romfs_strnlen() returns int
unsigned X >= 0 is always true

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: roel kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/inode.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/romfs/inode.c~romfs-romfs_iget-unsigned-ino-=-0-is-always-true fs/romfs/inode.c
--- a/fs/romfs/inode.c~romfs-romfs_iget-unsigned-ino-=-0-is-always-true
+++ a/fs/romfs/inode.c
@@ -490,7 +490,7 @@ static mode_t romfs_modemap[] =
 static struct inode *
 romfs_iget(struct super_block *sb, unsigned long ino)
 {
-	int nextfh;
+	int nextfh, ret;
 	struct romfs_inode ri;
 	struct inode *i;
 
@@ -526,11 +526,11 @@ romfs_iget(struct super_block *sb, unsig
 	i->i_mtime.tv_nsec = i->i_atime.tv_nsec = i->i_ctime.tv_nsec = 0;
 
         /* Precalculate the data offset */
-        ino = romfs_strnlen(i, ino+ROMFH_SIZE, ROMFS_MAXFN);
-        if (ino >= 0)
-                ino = ((ROMFH_SIZE+ino+1+ROMFH_PAD)&ROMFH_MASK);
-        else
-                ino = 0;
+	ret = romfs_strnlen(i, ino + ROMFH_SIZE, ROMFS_MAXFN);
+	if (ret >= 0)
+		ino = (ROMFH_SIZE + ret + 1 + ROMFH_PAD) & ROMFH_MASK;
+	else
+		ino = 0;
 
         ROMFS_I(i)->i_metasize = ino;
         ROMFS_I(i)->i_dataoffset = ino+(i->i_ino&ROMFH_MASK);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
ufs-sector_t-cannot-be-negative.patch

