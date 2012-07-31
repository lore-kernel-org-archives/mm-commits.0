From: akpm@linux-foundation.org
Subject: [merged] ntfs-remove-references-to-long-gone-super-operations-and-unimplemented-methods.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:47:46 -0700
Message-ID: <20120731184746.C46BB10007A@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab2GaSrr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:47:47 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:47:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fernando@oss.ntt.co.jp, anton@tuxera.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs: remove references to long gone super operations and unimplemented methods
has been removed from the -mm tree.  Its filename was
     ntfs-remove-references-to-long-gone-super-operations-and-unimplemented-methods.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Subject: ntfs: remove references to long gone super operations and unimplemented methods

->delete_inode(), ->write_super_lockfs(), ->unlockfs() are gone so remove
refereces to them in the NTFS code.  Remove unnecessary comments about
unimplemented methods while at it (suggested by Christoph Hellwig).

Noticed while cleaning up the fsfreeze mess.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/super.c |   17 -----------------
 1 file changed, 17 deletions(-)

diff -puN fs/ntfs/super.c~ntfs-remove-references-to-long-gone-super-operations-and-unimplemented-methods fs/ntfs/super.c
--- a/fs/ntfs/super.c~ntfs-remove-references-to-long-gone-super-operations-and-unimplemented-methods
+++ a/fs/ntfs/super.c
@@ -2660,31 +2660,14 @@ static const struct super_operations ntf
 	.alloc_inode	= ntfs_alloc_big_inode,	  /* VFS: Allocate new inode. */
 	.destroy_inode	= ntfs_destroy_big_inode, /* VFS: Deallocate inode. */
 #ifdef NTFS_RW
-	//.dirty_inode	= NULL,			/* VFS: Called from
-	//					   __mark_inode_dirty(). */
 	.write_inode	= ntfs_write_inode,	/* VFS: Write dirty inode to
 						   disk. */
-	//.drop_inode	= NULL,			/* VFS: Called just after the
-	//					   inode reference count has
-	//					   been decreased to zero.
-	//					   NOTE: The inode lock is
-	//					   held. See fs/inode.c::
-	//					   generic_drop_inode(). */
-	//.delete_inode	= NULL,			/* VFS: Delete inode from disk.
-	//					   Called when i_count becomes
-	//					   0 and i_nlink is also 0. */
-	//.write_super	= NULL,			/* Flush dirty super block to
-	//					   disk. */
-	//.sync_fs	= NULL,			/* ? */
-	//.write_super_lockfs	= NULL,		/* ? */
-	//.unlockfs	= NULL,			/* ? */
 #endif /* NTFS_RW */
 	.put_super	= ntfs_put_super,	/* Syscall: umount. */
 	.statfs		= ntfs_statfs,		/* Syscall: statfs */
 	.remount_fs	= ntfs_remount,		/* Syscall: mount -o remount. */
 	.evict_inode	= ntfs_evict_big_inode,	/* VFS: Called when an inode is
 						   removed from memory. */
-	//.umount_begin	= NULL,			/* Forced umount. */
 	.show_options	= ntfs_show_options,	/* Show mount options in
 						   proc. */
 };
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

origin.patch

