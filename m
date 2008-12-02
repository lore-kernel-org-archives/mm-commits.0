From: akpm@linux-foundation.org
Subject: + romfs-romfs_iget-unsigned-ino-=-0-is-always-true.patch added to -mm tree
Date: Tue, 02 Dec 2008 14:13:59 -0800
Message-ID: <200812022213.mB2MDx9J030046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751826AbYLBWOd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 17:14:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com


The patch titled
     romfs: romfs_iget() - unsigned ino >= 0 is always true
has been added to the -mm tree.  Its filename is
     romfs-romfs_iget-unsigned-ino-=-0-is-always-true.patch

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
Subject: romfs: romfs_iget() - unsigned ino >= 0 is always true
From: roel kluin <roel.kluin@gmail.com>

romfs_strnlen() returns int
unsigned X >= 0 is always true

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/inode.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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
 
@@ -527,9 +527,9 @@ romfs_iget(struct super_block *sb, unsig
 	i->i_uid = i->i_gid = 0;
 
         /* Precalculate the data offset */
-        ino = romfs_strnlen(i, ino+ROMFH_SIZE, ROMFS_MAXFN);
-        if (ino >= 0)
-                ino = ((ROMFH_SIZE+ino+1+ROMFH_PAD)&ROMFH_MASK);
+        ret = romfs_strnlen(i, ino+ROMFH_SIZE, ROMFS_MAXFN);
+        if (ret >= 0)
+                ino = ((ROMFH_SIZE+ret+1+ROMFH_PAD)&ROMFH_MASK);
         else
                 ino = 0;
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
gbefb-unsigned-var-pixclock-cannot-be-less-than-0.patch
sm501-unsigned-ptr-cannot-be-negative.patch
ufs-sector_t-cannot-be-negative.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true.patch
make-various-things-static.patch

