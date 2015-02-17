From: akpm@linux-foundation.org
Subject: [merged] ext2-get-rid-of-most-mentions-of-xip-in-ext2.patch
 removed from -mm tree
Date: Tue, 17 Feb 2015 12:05:59 -0800
Message-ID: <54e39f27.8haomJQCv/2ENEzG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35267 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbbBQUGA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 15:06:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.r.wilcox@intel.com, andreas.dilger@intel.com, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mathieu.desnoyers@efficios.com, rdunlap@infradead.org, ross.zwisler@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: ext2: get rid of most mentions of XIP in ext2
has been removed from the -mm tree.  Its filename was
     ext2-get-rid-of-most-mentions-of-xip-in-ext2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: ext2: get rid of most mentions of XIP in ext2

To help people transition, accept the 'xip' mount option (and report it in
/proc/mounts), but print a message encouraging people to switch over to
the 'dax' option.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/ext2.txt |    5 +++--
 fs/ext2/ext2.h                     |   13 +++++++------
 fs/ext2/file.c                     |    2 +-
 fs/ext2/inode.c                    |    6 +++---
 fs/ext2/namei.c                    |    8 ++++----
 fs/ext2/super.c                    |   25 ++++++++++++++++---------
 6 files changed, 34 insertions(+), 25 deletions(-)

diff -puN Documentation/filesystems/ext2.txt~ext2-get-rid-of-most-mentions-of-xip-in-ext2 Documentation/filesystems/ext2.txt
--- a/Documentation/filesystems/ext2.txt~ext2-get-rid-of-most-mentions-of-xip-in-ext2
+++ a/Documentation/filesystems/ext2.txt
@@ -20,6 +20,9 @@ minixdf				Makes `df' act like Minix.
 check=none, nocheck	(*)	Don't do extra checking of bitmaps on mount
 				(check=normal and check=strict options removed)
 
+dax				Use direct access (no page cache).  See
+				Documentation/filesystems/dax.txt.
+
 debug				Extra debugging information is sent to the
 				kernel syslog.  Useful for developers.
 
@@ -56,8 +59,6 @@ noacl				Don't support POSIX ACLs.
 
 nobh				Do not attach buffer_heads to file pagecache.
 
-xip				Use execute in place (no caching) if possible
-
 grpquota,noquota,quota,usrquota	Quota options are silently ignored by ext2.
 
 
diff -puN fs/ext2/ext2.h~ext2-get-rid-of-most-mentions-of-xip-in-ext2 fs/ext2/ext2.h
--- a/fs/ext2/ext2.h~ext2-get-rid-of-most-mentions-of-xip-in-ext2
+++ a/fs/ext2/ext2.h
@@ -380,14 +380,15 @@ struct ext2_inode {
 #define EXT2_MOUNT_NO_UID32		0x000200  /* Disable 32-bit UIDs */
 #define EXT2_MOUNT_XATTR_USER		0x004000  /* Extended user attributes */
 #define EXT2_MOUNT_POSIX_ACL		0x008000  /* POSIX Access Control Lists */
-#ifdef CONFIG_FS_DAX
-#define EXT2_MOUNT_XIP			0x010000  /* Execute in place */
-#else
-#define EXT2_MOUNT_XIP			0
-#endif
+#define EXT2_MOUNT_XIP			0x010000  /* Obsolete, use DAX */
 #define EXT2_MOUNT_USRQUOTA		0x020000  /* user quota */
 #define EXT2_MOUNT_GRPQUOTA		0x040000  /* group quota */
 #define EXT2_MOUNT_RESERVATION		0x080000  /* Preallocation */
+#ifdef CONFIG_FS_DAX
+#define EXT2_MOUNT_DAX			0x100000  /* Direct Access */
+#else
+#define EXT2_MOUNT_DAX			0
+#endif
 
 
 #define clear_opt(o, opt)		o &= ~EXT2_MOUNT_##opt
@@ -792,7 +793,7 @@ extern int ext2_fsync(struct file *file,
 		      int datasync);
 extern const struct inode_operations ext2_file_inode_operations;
 extern const struct file_operations ext2_file_operations;
-extern const struct file_operations ext2_xip_file_operations;
+extern const struct file_operations ext2_dax_file_operations;
 
 /* inode.c */
 extern const struct address_space_operations ext2_aops;
diff -puN fs/ext2/file.c~ext2-get-rid-of-most-mentions-of-xip-in-ext2 fs/ext2/file.c
--- a/fs/ext2/file.c~ext2-get-rid-of-most-mentions-of-xip-in-ext2
+++ a/fs/ext2/file.c
@@ -109,7 +109,7 @@ const struct file_operations ext2_file_o
 };
 
 #ifdef CONFIG_FS_DAX
-const struct file_operations ext2_xip_file_operations = {
+const struct file_operations ext2_dax_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= new_sync_read,
 	.write		= new_sync_write,
diff -puN fs/ext2/inode.c~ext2-get-rid-of-most-mentions-of-xip-in-ext2 fs/ext2/inode.c
--- a/fs/ext2/inode.c~ext2-get-rid-of-most-mentions-of-xip-in-ext2
+++ a/fs/ext2/inode.c
@@ -1286,7 +1286,7 @@ void ext2_set_inode_flags(struct inode *
 		inode->i_flags |= S_NOATIME;
 	if (flags & EXT2_DIRSYNC_FL)
 		inode->i_flags |= S_DIRSYNC;
-	if (test_opt(inode->i_sb, XIP))
+	if (test_opt(inode->i_sb, DAX))
 		inode->i_flags |= S_DAX;
 }
 
@@ -1388,9 +1388,9 @@ struct inode *ext2_iget (struct super_bl
 
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &ext2_file_inode_operations;
-		if (test_opt(inode->i_sb, XIP)) {
+		if (test_opt(inode->i_sb, DAX)) {
 			inode->i_mapping->a_ops = &ext2_aops;
-			inode->i_fop = &ext2_xip_file_operations;
+			inode->i_fop = &ext2_dax_file_operations;
 		} else if (test_opt(inode->i_sb, NOBH)) {
 			inode->i_mapping->a_ops = &ext2_nobh_aops;
 			inode->i_fop = &ext2_file_operations;
diff -puN fs/ext2/namei.c~ext2-get-rid-of-most-mentions-of-xip-in-ext2 fs/ext2/namei.c
--- a/fs/ext2/namei.c~ext2-get-rid-of-most-mentions-of-xip-in-ext2
+++ a/fs/ext2/namei.c
@@ -104,9 +104,9 @@ static int ext2_create (struct inode * d
 		return PTR_ERR(inode);
 
 	inode->i_op = &ext2_file_inode_operations;
-	if (test_opt(inode->i_sb, XIP)) {
+	if (test_opt(inode->i_sb, DAX)) {
 		inode->i_mapping->a_ops = &ext2_aops;
-		inode->i_fop = &ext2_xip_file_operations;
+		inode->i_fop = &ext2_dax_file_operations;
 	} else if (test_opt(inode->i_sb, NOBH)) {
 		inode->i_mapping->a_ops = &ext2_nobh_aops;
 		inode->i_fop = &ext2_file_operations;
@@ -125,9 +125,9 @@ static int ext2_tmpfile(struct inode *di
 		return PTR_ERR(inode);
 
 	inode->i_op = &ext2_file_inode_operations;
-	if (test_opt(inode->i_sb, XIP)) {
+	if (test_opt(inode->i_sb, DAX)) {
 		inode->i_mapping->a_ops = &ext2_aops;
-		inode->i_fop = &ext2_xip_file_operations;
+		inode->i_fop = &ext2_dax_file_operations;
 	} else if (test_opt(inode->i_sb, NOBH)) {
 		inode->i_mapping->a_ops = &ext2_nobh_aops;
 		inode->i_fop = &ext2_file_operations;
diff -puN fs/ext2/super.c~ext2-get-rid-of-most-mentions-of-xip-in-ext2 fs/ext2/super.c
--- a/fs/ext2/super.c~ext2-get-rid-of-most-mentions-of-xip-in-ext2
+++ a/fs/ext2/super.c
@@ -294,6 +294,8 @@ static int ext2_show_options(struct seq_
 #ifdef CONFIG_FS_DAX
 	if (sbi->s_mount_opt & EXT2_MOUNT_XIP)
 		seq_puts(seq, ",xip");
+	if (sbi->s_mount_opt & EXT2_MOUNT_DAX)
+		seq_puts(seq, ",dax");
 #endif
 
 	if (!test_opt(sb, RESERVATION))
@@ -402,7 +404,7 @@ enum {
 	Opt_resgid, Opt_resuid, Opt_sb, Opt_err_cont, Opt_err_panic,
 	Opt_err_ro, Opt_nouid32, Opt_nocheck, Opt_debug,
 	Opt_oldalloc, Opt_orlov, Opt_nobh, Opt_user_xattr, Opt_nouser_xattr,
-	Opt_acl, Opt_noacl, Opt_xip, Opt_ignore, Opt_err, Opt_quota,
+	Opt_acl, Opt_noacl, Opt_xip, Opt_dax, Opt_ignore, Opt_err, Opt_quota,
 	Opt_usrquota, Opt_grpquota, Opt_reservation, Opt_noreservation
 };
 
@@ -431,6 +433,7 @@ static const match_table_t tokens = {
 	{Opt_acl, "acl"},
 	{Opt_noacl, "noacl"},
 	{Opt_xip, "xip"},
+	{Opt_dax, "dax"},
 	{Opt_grpquota, "grpquota"},
 	{Opt_ignore, "noquota"},
 	{Opt_quota, "quota"},
@@ -558,10 +561,14 @@ static int parse_options(char *options, 
 			break;
 #endif
 		case Opt_xip:
+			ext2_msg(sb, KERN_INFO, "use dax instead of xip");
+			set_opt(sbi->s_mount_opt, XIP);
+			/* Fall through */
+		case Opt_dax:
 #ifdef CONFIG_FS_DAX
-			set_opt (sbi->s_mount_opt, XIP);
+			set_opt(sbi->s_mount_opt, DAX);
 #else
-			ext2_msg(sb, KERN_INFO, "xip option not supported");
+			ext2_msg(sb, KERN_INFO, "dax option not supported");
 #endif
 			break;
 
@@ -905,15 +912,15 @@ static int ext2_fill_super(struct super_
 
 	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
 
-	if (sbi->s_mount_opt & EXT2_MOUNT_XIP) {
+	if (sbi->s_mount_opt & EXT2_MOUNT_DAX) {
 		if (blocksize != PAGE_SIZE) {
 			ext2_msg(sb, KERN_ERR,
-					"error: unsupported blocksize for xip");
+					"error: unsupported blocksize for dax");
 			goto failed_mount;
 		}
 		if (!sb->s_bdev->bd_disk->fops->direct_access) {
 			ext2_msg(sb, KERN_ERR,
-					"error: device does not support xip");
+					"error: device does not support dax");
 			goto failed_mount;
 		}
 	}
@@ -1286,10 +1293,10 @@ static int ext2_remount (struct super_bl
 		((sbi->s_mount_opt & EXT2_MOUNT_POSIX_ACL) ? MS_POSIXACL : 0);
 
 	es = sbi->s_es;
-	if ((sbi->s_mount_opt ^ old_opts.s_mount_opt) & EXT2_MOUNT_XIP) {
+	if ((sbi->s_mount_opt ^ old_opts.s_mount_opt) & EXT2_MOUNT_DAX) {
 		ext2_msg(sb, KERN_WARNING, "warning: refusing change of "
-			 "xip flag with busy inodes while remounting");
-		sbi->s_mount_opt ^= EXT2_MOUNT_XIP;
+			 "dax flag with busy inodes while remounting");
+		sbi->s_mount_opt ^= EXT2_MOUNT_DAX;
 	}
 	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY)) {
 		spin_unlock(&sbi->s_lock);
_

Patches currently in -mm which might be from matthew.r.wilcox@intel.com are

origin.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

