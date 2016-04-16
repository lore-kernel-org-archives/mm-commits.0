From: akpm@linux-foundation.org
Subject: +
 ext2-4-xfs-blk-call-dax_get_unmapped_area-for-dax-pmd-mappings.patch added
 to -mm tree
Date: Fri, 15 Apr 2016 22:05:56 -0700
Message-ID: <5711c834.WHUtmAShjSBEcbQu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbcDPFF5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2016 01:05:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hpe.com, adilger.kernel@dilger.ca, dan.j.williams@intel.com, david@fromorbit.com, jack@suse.cz, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, tytso@mit.edu, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ext2/4, xfs, blk: call dax_get_unmapped_area() for DAX pmd mappings
has been added to the -mm tree.  Its filename is
     ext2-4-xfs-blk-call-dax_get_unmapped_area-for-dax-pmd-mappings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ext2-4-xfs-blk-call-dax_get_unmapped_area-for-dax-pmd-mappings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ext2-4-xfs-blk-call-dax_get_unmapped_area-for-dax-pmd-mappings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Toshi Kani <toshi.kani@hpe.com>
Subject: ext2/4, xfs, blk: call dax_get_unmapped_area() for DAX pmd mappings

To support DAX pmd mappings with unmodified applications, filesystems need
to align an mmap address by the pmd size.

Call dax_get_unmapped_area() from f_op->get_unmapped_area.

Note, there is no change in behavior for a non-DAX file.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c    |    1 +
 fs/ext2/file.c    |    1 +
 fs/ext4/file.c    |    1 +
 fs/xfs/xfs_file.c |    1 +
 4 files changed, 4 insertions(+)

diff -puN fs/block_dev.c~ext2-4-xfs-blk-call-dax_get_unmapped_area-for-dax-pmd-mappings fs/block_dev.c
--- a/fs/block_dev.c~ext2-4-xfs-blk-call-dax_get_unmapped_area-for-dax-pmd-mappings
+++ a/fs/block_dev.c
@@ -1798,6 +1798,7 @@ const struct file_operations def_blk_fop
 	.write_iter	= blkdev_write_iter,
 	.mmap		= blkdev_mmap,
 	.fsync		= blkdev_fsync,
+	.get_unmapped_area = dax_get_unmapped_area,
 	.unlocked_ioctl	= block_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= compat_blkdev_ioctl,
diff -puN fs/ext2/file.c~ext2-4-xfs-blk-call-dax_get_unmapped_area-for-dax-pmd-mappings fs/ext2/file.c
--- a/fs/ext2/file.c~ext2-4-xfs-blk-call-dax_get_unmapped_area-for-dax-pmd-mappings
+++ a/fs/ext2/file.c
@@ -172,6 +172,7 @@ const struct file_operations ext2_file_o
 	.open		= dquot_file_open,
 	.release	= ext2_release_file,
 	.fsync		= ext2_fsync,
+	.get_unmapped_area = dax_get_unmapped_area,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 };
diff -puN fs/ext4/file.c~ext2-4-xfs-blk-call-dax_get_unmapped_area-for-dax-pmd-mappings fs/ext4/file.c
--- a/fs/ext4/file.c~ext2-4-xfs-blk-call-dax_get_unmapped_area-for-dax-pmd-mappings
+++ a/fs/ext4/file.c
@@ -708,6 +708,7 @@ const struct file_operations ext4_file_o
 	.open		= ext4_file_open,
 	.release	= ext4_release_file,
 	.fsync		= ext4_sync_file,
+	.get_unmapped_area = dax_get_unmapped_area,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= ext4_fallocate,
diff -puN fs/xfs/xfs_file.c~ext2-4-xfs-blk-call-dax_get_unmapped_area-for-dax-pmd-mappings fs/xfs/xfs_file.c
--- a/fs/xfs/xfs_file.c~ext2-4-xfs-blk-call-dax_get_unmapped_area-for-dax-pmd-mappings
+++ a/fs/xfs/xfs_file.c
@@ -1708,6 +1708,7 @@ const struct file_operations xfs_file_op
 	.open		= xfs_file_open,
 	.release	= xfs_file_release,
 	.fsync		= xfs_file_fsync,
+	.get_unmapped_area = dax_get_unmapped_area,
 	.fallocate	= xfs_file_fallocate,
 };
 
_

Patches currently in -mm which might be from toshi.kani@hpe.com are

dax-add-dax_get_unmapped_area-for-pmd-mappings.patch
ext2-4-xfs-blk-call-dax_get_unmapped_area-for-dax-pmd-mappings.patch

