From: akpm@linux-foundation.org
Subject: + ntfs-remove-i_version-handling.patch added to -mm tree
Date: Thu, 07 Dec 2017 15:39:47 -0800
Message-ID: <5a29d143.nSnaijDcvZnT2KgH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57230 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750973AbdLGXjt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2017 18:39:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, andreas.dilger@intel.com, anton@tuxera.com, jsimmons@infradead.org, mikulas@artax.karlin.mff.cuni.cz, oleg.drokin@intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs: remove i_version handling
has been added to the -mm tree.  Its filename is
     ntfs-remove-i_version-handling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ntfs-remove-i_version-handling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ntfs-remove-i_version-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ntfs-remove-i_version-handling.patch
hpfs-dont-bother-with-the-i_version-counter-or-f_version.patch
lustre-dont-set-f_version-in-ll_readdir.patch

