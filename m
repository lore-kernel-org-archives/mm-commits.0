From: akpm@linux-foundation.org
Subject: + faster-ext2_clear_inode.patch added to -mm tree
Date: Thu, 19 Jul 2007 17:31:24 -0700
Message-ID: <200707200031.l6K0VO2P030839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43585 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757969AbXGTAcI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 20:32:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, agruen@suse.de, joern@logfs.org


The patch titled
     Faster ext2_clear_inode()
has been added to the -mm tree.  Its filename is
     faster-ext2_clear_inode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Faster ext2_clear_inode()
From: Alexey Dobriyan <adobriyan@gmail.com>

If CONFIG_EXT2_FS_POSIX_ACL is not configured, ext2_clear_inode() will be
empty function.  However, there still will be call and immediate return
which can be avoided.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Joern Engel <joern@logfs.org>
Cc: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/super.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/ext2/super.c~faster-ext2_clear_inode fs/ext2/super.c
--- a/fs/ext2/super.c~faster-ext2_clear_inode
+++ a/fs/ext2/super.c
@@ -185,9 +185,9 @@ static void destroy_inodecache(void)
 	kmem_cache_destroy(ext2_inode_cachep);
 }
 
+#ifdef CONFIG_EXT2_FS_POSIX_ACL
 static void ext2_clear_inode(struct inode *inode)
 {
-#ifdef CONFIG_EXT2_FS_POSIX_ACL
 	struct ext2_inode_info *ei = EXT2_I(inode);
 
 	if (ei->i_acl && ei->i_acl != EXT2_ACL_NOT_CACHED) {
@@ -198,8 +198,10 @@ static void ext2_clear_inode(struct inod
 		posix_acl_release(ei->i_default_acl);
 		ei->i_default_acl = EXT2_ACL_NOT_CACHED;
 	}
-#endif
 }
+#else
+#define ext2_clear_inode NULL
+#endif
 
 static int ext2_show_options(struct seq_file *seq, struct vfsmount *vfs)
 {
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
faster-ext2_clear_inode.patch
