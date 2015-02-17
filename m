From: akpm@linux-foundation.org
Subject: [merged] vfsext2-introduce-is_daxinode.patch removed from -mm
 tree
Date: Tue, 17 Feb 2015 12:05:24 -0800
Message-ID: <54e39f04.I3026XRaYVNqHqoH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbbBQUFZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 15:05:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.r.wilcox@intel.com, andreas.dilger@intel.com, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mathieu.desnoyers@efficios.com, rdunlap@infradead.org, ross.zwisler@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs,ext2: introduce IS_DAX(inode)
has been removed from the -mm tree.  Its filename was
     vfsext2-introduce-is_daxinode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: vfs,ext2: introduce IS_DAX(inode)

Use an inode flag to tag inodes which should avoid using the page cache. 
Convert ext2 to use it instead of mapping_is_xip().  Prevent I/Os to files
tagged with the DAX flag from falling back to buffered I/O.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/inode.c    |    9 ++++++---
 fs/ext2/xip.h      |    2 --
 include/linux/fs.h |    6 ++++++
 mm/filemap.c       |   19 ++++++++++++-------
 4 files changed, 24 insertions(+), 12 deletions(-)

diff -puN fs/ext2/inode.c~vfsext2-introduce-is_daxinode fs/ext2/inode.c
--- a/fs/ext2/inode.c~vfsext2-introduce-is_daxinode
+++ a/fs/ext2/inode.c
@@ -731,7 +731,7 @@ static int ext2_get_blocks(struct inode 
 		goto cleanup;
 	}
 
-	if (ext2_use_xip(inode->i_sb)) {
+	if (IS_DAX(inode)) {
 		/*
 		 * we need to clear the block
 		 */
@@ -1201,7 +1201,7 @@ static int ext2_setsize(struct inode *in
 
 	inode_dio_wait(inode);
 
-	if (mapping_is_xip(inode->i_mapping))
+	if (IS_DAX(inode))
 		error = xip_truncate_page(inode->i_mapping, newsize);
 	else if (test_opt(inode->i_sb, NOBH))
 		error = nobh_truncate_page(inode->i_mapping,
@@ -1273,7 +1273,8 @@ void ext2_set_inode_flags(struct inode *
 {
 	unsigned int flags = EXT2_I(inode)->i_flags;
 
-	inode->i_flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC);
+	inode->i_flags &= ~(S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME |
+				S_DIRSYNC | S_DAX);
 	if (flags & EXT2_SYNC_FL)
 		inode->i_flags |= S_SYNC;
 	if (flags & EXT2_APPEND_FL)
@@ -1284,6 +1285,8 @@ void ext2_set_inode_flags(struct inode *
 		inode->i_flags |= S_NOATIME;
 	if (flags & EXT2_DIRSYNC_FL)
 		inode->i_flags |= S_DIRSYNC;
+	if (test_opt(inode->i_sb, XIP))
+		inode->i_flags |= S_DAX;
 }
 
 /* Propagate flags from i_flags to EXT2_I(inode)->i_flags */
diff -puN fs/ext2/xip.h~vfsext2-introduce-is_daxinode fs/ext2/xip.h
--- a/fs/ext2/xip.h~vfsext2-introduce-is_daxinode
+++ a/fs/ext2/xip.h
@@ -16,9 +16,7 @@ static inline int ext2_use_xip (struct s
 }
 int ext2_get_xip_mem(struct address_space *, pgoff_t, int,
 				void **, unsigned long *);
-#define mapping_is_xip(map) unlikely(map->a_ops->get_xip_mem)
 #else
-#define mapping_is_xip(map)			0
 #define ext2_xip_verify_sb(sb)			do { } while (0)
 #define ext2_use_xip(sb)			0
 #define ext2_clear_xip_target(inode, chain)	0
diff -puN include/linux/fs.h~vfsext2-introduce-is_daxinode include/linux/fs.h
--- a/include/linux/fs.h~vfsext2-introduce-is_daxinode
+++ a/include/linux/fs.h
@@ -1677,6 +1677,11 @@ struct super_operations {
 #define S_IMA		1024	/* Inode has an associated IMA struct */
 #define S_AUTOMOUNT	2048	/* Automount/referral quasi-directory */
 #define S_NOSEC		4096	/* no suid or xattr security attributes */
+#ifdef CONFIG_FS_XIP
+#define S_DAX		8192	/* Direct Access, avoiding the page cache */
+#else
+#define S_DAX		0	/* Make all the DAX code disappear */
+#endif
 
 /*
  * Note that nosuid etc flags are inode-specific: setting some file-system
@@ -1714,6 +1719,7 @@ struct super_operations {
 #define IS_IMA(inode)		((inode)->i_flags & S_IMA)
 #define IS_AUTOMOUNT(inode)	((inode)->i_flags & S_AUTOMOUNT)
 #define IS_NOSEC(inode)		((inode)->i_flags & S_NOSEC)
+#define IS_DAX(inode)		((inode)->i_flags & S_DAX)
 
 #define IS_WHITEOUT(inode)	(S_ISCHR(inode->i_mode) && \
 				 (inode)->i_rdev == WHITEOUT_DEV)
diff -puN mm/filemap.c~vfsext2-introduce-is_daxinode mm/filemap.c
--- a/mm/filemap.c~vfsext2-introduce-is_daxinode
+++ a/mm/filemap.c
@@ -1723,9 +1723,11 @@ generic_file_read_iter(struct kiocb *ioc
 		 * we've already read everything we wanted to, or if
 		 * there was a short read because we hit EOF, go ahead
 		 * and return.  Otherwise fallthrough to buffered io for
-		 * the rest of the read.
+		 * the rest of the read.  Buffered reads will not work for
+		 * DAX files, so don't bother trying.
 		 */
-		if (retval < 0 || !iov_iter_count(iter) || *ppos >= size) {
+		if (retval < 0 || !iov_iter_count(iter) || *ppos >= size ||
+		    IS_DAX(inode)) {
 			file_accessed(file);
 			goto out;
 		}
@@ -2587,13 +2589,16 @@ ssize_t __generic_file_write_iter(struct
 		loff_t endbyte;
 
 		written = generic_file_direct_write(iocb, from, pos);
-		if (written < 0 || written == count)
-			goto out;
