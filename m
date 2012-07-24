From: akpm@linux-foundation.org
Subject: + ntfs-remove-references-to-long-gone-super-operations-and-unimplemented-methods.patch added to -mm tree
Date: Mon, 23 Jul 2012 17:02:49 -0700
Message-ID: <20120724000250.1BDD520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:38831 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab2GXACw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jul 2012 20:02:52 -0400
Received: by fat25 with SMTP id 25so347090fat.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jul 2012 17:02:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@oss.ntt.co.jp, anton@tuxera.com


The patch titled
     Subject: ntfs: remove references to long gone super operations and unimplemented methods
has been added to the -mm tree.  Its filename is
     ntfs-remove-references-to-long-gone-super-operations-and-unimplemented-methods.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: ntfs: remove references to long gone super operations and unimplemented methods

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

ntfs-remove-references-to-long-gone-super-operations-and-unimplemented-methods.patch
nilfs2-remove-references-to-long-gone-super-operations.patch
nilfs2-fix-timing-issue-between-rmcp-and-chcp-ioctls.patch
nilfs2-fix-deadlock-issue-between-chcp-and-thaw-ioctls.patch

