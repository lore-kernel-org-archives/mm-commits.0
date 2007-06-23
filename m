From: akpm@linux-foundation.org
Subject: - fuse-fs_flags-fixlet.patch removed from -mm tree
Date: Sat, 23 Jun 2007 12:27:16 -0700
Message-ID: <200706231927.l5NJRGZw022046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58734 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752781AbXFWT10 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 15:27:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: ->fs_flags fixlet
has been removed from the -mm tree.  Its filename was
     fuse-fs_flags-fixlet.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 1 insertion(+), 2 deletions(-)

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

procfs-directory-entry-cleanup-fix.patch
remove-capabilityh-from-mmh.patch
ptrace_peekdata-consolidation.patch
ptrace_pokedata-consolidation.patch
