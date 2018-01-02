From: akpm@linux-foundation.org
Subject: [merged] ntfs-remove-i_version-handling.patch removed from
 -mm tree
Date: Tue, 02 Jan 2018 11:54:24 -0800
Message-ID: <20180102195424.nPtYXi3ox%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59466 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbeABTy0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jan 2018 14:54:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.dilger@intel.com, anton@tuxera.com, jlayton@redhat.com, jsimmons@infradead.org, mikulas@artax.karlin.mff.cuni.cz, mm-commits@vger.kernel.org, oleg.drokin@intel.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: ntfs: remove i_version handling
has been removed from the -mm tree.  Its filename was
     ntfs-remove-i_version-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeff Layton <jlayton@redhat.com>
Subject: ntfs: remove i_version handling

NTFS keeps track of the i_version counter here, seemingly for no reason. 
It does not set the SB_I_VERSION flag so it'll never be incremented on
write, and it doesn't increment it internally for metadata operations.

Link: http://lkml.kernel.org/r/20171207113206.31544-3-jlayton@kernel.org
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Acked-by: Anton Altaparmakov <anton@tuxera.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: James Simmons <jsimmons@infradead.org>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/inode.c |    9 ---------
 fs/ntfs/mft.c   |    6 ------
 2 files changed, 15 deletions(-)

diff -puN fs/ntfs/inode.c~ntfs-remove-i_version-handling fs/ntfs/inode.c
--- a/fs/ntfs/inode.c~ntfs-remove-i_version-handling
+++ a/fs/ntfs/inode.c
@@ -560,13 +560,6 @@ static int ntfs_read_locked_inode(struct
 	ntfs_debug("Entering for i_ino 0x%lx.", vi->i_ino);
 
 	/* Setup the generic vfs inode parts now. */
-
-	/*
-	 * This is for checking whether an inode has changed w.r.t. a file so
-	 * that the file can be updated if necessary (compare with f_version).
-	 */
-	vi->i_version = 1;
-
 	vi->i_uid = vol->uid;
 	vi->i_gid = vol->gid;
 	vi->i_mode = 0;
@@ -1240,7 +1233,6 @@ static int ntfs_read_locked_attr_inode(s
 	base_ni = NTFS_I(base_vi);
 
 	/* Just mirror the values from the base inode. */
-	vi->i_version	= base_vi->i_version;
 	vi->i_uid	= base_vi->i_uid;
 	vi->i_gid	= base_vi->i_gid;
 	set_nlink(vi, base_vi->i_nlink);
@@ -1507,7 +1499,6 @@ static int ntfs_read_locked_index_inode(
 	ni	= NTFS_I(vi);
 	base_ni = NTFS_I(base_vi);
 	/* Just mirror the values from the base inode. */
-	vi->i_version	= base_vi->i_version;
 	vi->i_uid	= base_vi->i_uid;
 	vi->i_gid	= base_vi->i_gid;
 	set_nlink(vi, base_vi->i_nlink);
diff -puN fs/ntfs/mft.c~ntfs-remove-i_version-handling fs/ntfs/mft.c
--- a/fs/ntfs/mft.c~ntfs-remove-i_version-handling
+++ a/fs/ntfs/mft.c
@@ -2641,12 +2641,6 @@ mft_rec_already_initialized:
 			goto undo_mftbmp_alloc;
 		}
 		vi->i_ino = bit;
-		/*
-		 * This is for checking whether an inode has changed w.r.t. a
-		 * file so that the file can be updated if necessary (compare
-		 * with f_version).
-		 */
-		vi->i_version = 1;
 
 		/* The owner and group come from the ntfs volume. */
 		vi->i_uid = vol->uid;
_

Patches currently in -mm which might be from jlayton@redhat.com are


