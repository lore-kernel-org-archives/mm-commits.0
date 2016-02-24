From: akpm@linux-foundation.org
Subject: + ext2-ext4-only-set-s_dax-for-regular-inodes.patch added to -mm
 tree
Date: Wed, 24 Feb 2016 14:27:17 -0800
Message-ID: <56ce2e45.i/3f0mQ6hIJbxftP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42413 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296AbcBXW1S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Feb 2016 17:27:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, axboe@fb.com, dan.j.williams@intel.com, david@fromorbit.com, jack@suse.cz, matthew.r.wilcox@intel.com, tytso@mit.edu, viro@ftp.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: ext2, ext4: only set S_DAX for regular inodes
has been added to the -mm tree.  Its filename is
     ext2-ext4-only-set-s_dax-for-regular-inodes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ext2-ext4-only-set-s_dax-for-regular-inodes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ext2-ext4-only-set-s_dax-for-regular-inodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: ext2, ext4: only set S_DAX for regular inodes

When S_DAX is set on an inode we assume that if there are pages attached
to the mapping (mapping->nrpages != 0), those pages are clean zero pages
that were used to service reads from holes.  Any dirty data associated
with the inode should be in the form of DAX exceptional entries
(mapping->nrexceptional) that is written back via
dax_writeback_mapping_range().

With the current code, though, this isn't always true.  For example, ext2
and ext4 directory inodes can have S_DAX set, but have their dirty data
stored as dirty page cache entries.  For these types of inodes, having
S_DAX set doesn't really make sense since their I/O doesn't actually
happen through the DAX code path.

Instead, only allow S_DAX to be set for regular inodes for ext2 and ext4. 
This allows us to have strict DAX vs non-DAX paths in the writeback code.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Al Viro <viro@ftp.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/inode.c |    2 +-
 fs/ext4/inode.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ext2/inode.c~ext2-ext4-only-set-s_dax-for-regular-inodes fs/ext2/inode.c
--- a/fs/ext2/inode.c~ext2-ext4-only-set-s_dax-for-regular-inodes
+++ a/fs/ext2/inode.c
@@ -1296,7 +1296,7 @@ void ext2_set_inode_flags(struct inode *
 		inode->i_flags |= S_NOATIME;
 	if (flags & EXT2_DIRSYNC_FL)
 		inode->i_flags |= S_DIRSYNC;
-	if (test_opt(inode->i_sb, DAX))
+	if (test_opt(inode->i_sb, DAX) && S_ISREG(inode->i_mode))
 		inode->i_flags |= S_DAX;
 }
 
diff -puN fs/ext4/inode.c~ext2-ext4-only-set-s_dax-for-regular-inodes fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext2-ext4-only-set-s_dax-for-regular-inodes
+++ a/fs/ext4/inode.c
@@ -4155,7 +4155,7 @@ void ext4_set_inode_flags(struct inode *
 		new_fl |= S_NOATIME;
 	if (flags & EXT4_DIRSYNC_FL)
 		new_fl |= S_DIRSYNC;
-	if (test_opt(inode->i_sb, DAX))
+	if (test_opt(inode->i_sb, DAX) && S_ISREG(inode->i_mode))
 		new_fl |= S_DAX;
 	inode_set_flags(inode, new_fl,
 			S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC|S_DAX);
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

ext2-ext4-only-set-s_dax-for-regular-inodes.patch
ext4-online-defrag-not-supported-with-dax.patch
dax-give-dax-clearing-code-correct-bdev.patch
dax-move-writeback-calls-into-the-filesystems.patch

