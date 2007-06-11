From: akpm@linux-foundation.org
Subject: + fuse-fs_flags-fixlet.patch added to -mm tree
Date: Mon, 11 Jun 2007 12:57:21 -0700
Message-ID: <200706111957.l5BJvLqn027827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56681 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753662AbXFKT5c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 15:57:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, mszeredi@suse.cz


The patch titled
     fuse: ->fs_flags fixlet
has been added to the -mm tree.  Its filename is
     fuse-fs_flags-fixlet.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fuse: ->fs_flags fixlet
From: Alexey Dobriyan <adobriyan@gmail.com>

fs/fuse/inode.c:658:3: error: Initializer entry defined twice
fs/fuse/inode.c:661:3:   also defined here

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/inode.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/fuse/inode.c~fuse-fs_flags-fixlet fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-fs_flags-fixlet
+++ a/fs/fuse/inode.c
@@ -655,10 +655,9 @@ static int fuse_get_sb_blk(struct file_s
 static struct file_system_type fuseblk_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "fuseblk",
-	.fs_flags	= FS_HAS_SUBTYPE,
 	.get_sb		= fuse_get_sb_blk,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_HAS_SUBTYPE,
 };
 
 static inline int register_fuseblk(void)
_

Patches currently in -mm which might be from adobriyan@gmail.com are

fuse-fs_flags-fixlet.patch
git-parisc.patch
procfs-directory-entry-cleanup-fix.patch
remove-capabilityh-from-mmh.patch
