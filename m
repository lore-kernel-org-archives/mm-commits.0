From: akpm@linux-foundation.org
Subject: [patch 063/127] ext2/4, xfs: call thp_get_unmapped_area() for pmd mappings
Date: Fri, 07 Oct 2016 16:59:59 -0700
Message-ID: <57f836ff.uEhiSaYRhey7xfTw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39224 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756766AbcJHAAQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:00:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, toshi.kani@hpe.com, adilger.kernel@dilger.ca, dan.j.williams@intel.com, david@fromorbit.com, hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com, kirill@shutemov.name, mawilcox@microsoft.com, mike.kravetz@oracle.com, ross.zwisler@linux.intel.com, tytso@mit.edu

From: Toshi Kani <toshi.kani@hpe.com>
Subject: ext2/4, xfs: call thp_get_unmapped_area() for pmd mappings

To support DAX pmd mappings with unmodified applications,
filesystems need to align an mmap address by the pmd size.

Call thp_get_unmapped_area() from f_op->get_unmapped_area.

Note, there is no change in behavior for a non-DAX file.

Link: http://lkml.kernel.org/r/1472497881-9323-3-git-send-email-toshi.kani@hpe.com
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/file.c    |    1 +
 fs/ext4/file.c    |    1 +
 fs/xfs/xfs_file.c |    1 +
 3 files changed, 3 insertions(+)

diff -puN fs/ext2/file.c~ext2-4-xfs-call-thp_get_unmapped_area-for-pmd-mappings fs/ext2/file.c
--- a/fs/ext2/file.c~ext2-4-xfs-call-thp_get_unmapped_area-for-pmd-mappings
+++ a/fs/ext2/file.c
@@ -234,6 +234,7 @@ const struct file_operations ext2_file_o
 	.open		= dquot_file_open,
 	.release	= ext2_release_file,
 	.fsync		= ext2_fsync,
+	.get_unmapped_area = thp_get_unmapped_area,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 };
diff -puN fs/ext4/file.c~ext2-4-xfs-call-thp_get_unmapped_area-for-pmd-mappings fs/ext4/file.c
--- a/fs/ext4/file.c~ext2-4-xfs-call-thp_get_unmapped_area-for-pmd-mappings
+++ a/fs/ext4/file.c
@@ -703,6 +703,7 @@ const struct file_operations ext4_file_o
 	.open		= ext4_file_open,
 	.release	= ext4_release_file,
 	.fsync		= ext4_sync_file,
+	.get_unmapped_area = thp_get_unmapped_area,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= ext4_fallocate,
diff -puN fs/xfs/xfs_file.c~ext2-4-xfs-call-thp_get_unmapped_area-for-pmd-mappings fs/xfs/xfs_file.c
--- a/fs/xfs/xfs_file.c~ext2-4-xfs-call-thp_get_unmapped_area-for-pmd-mappings
+++ a/fs/xfs/xfs_file.c
@@ -1618,6 +1618,7 @@ const struct file_operations xfs_file_op
 	.open		= xfs_file_open,
 	.release	= xfs_file_release,
 	.fsync		= xfs_file_fsync,
+	.get_unmapped_area = thp_get_unmapped_area,
 	.fallocate	= xfs_file_fallocate,
 };
 
_
