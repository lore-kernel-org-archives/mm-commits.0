From: akpm@linux-foundation.org
Subject: [merged] ext2-remove-ext2_xip_verify_sb.patch removed from -mm
 tree
Date: Tue, 17 Feb 2015 12:05:45 -0800
Message-ID: <54e39f19.n//rUTd4nM3YcSXD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35208 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbbBQUFq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 15:05:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.r.wilcox@intel.com, andreas.dilger@intel.com, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mathieu.desnoyers@efficios.com, rdunlap@infradead.org, ross.zwisler@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: ext2: remove ext2_xip_verify_sb()
has been removed from the -mm tree.  Its filename was
     ext2-remove-ext2_xip_verify_sb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: ext2: remove ext2_xip_verify_sb()

Jan Kara pointed out that calling ext2_xip_verify_sb() in ext2_remount()
doesn't make sense, since changing the XIP option on remount isn't
allowed.  It also doesn't make sense to re-check whether blocksize is
supported since it can't change between mounts.

Replace the call to ext2_xip_verify_sb() in ext2_fill_super() with the
equivalent check and delete the definition.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/super.c |   33 ++++++++++++---------------------
 fs/ext2/xip.c   |   12 ------------
 fs/ext2/xip.h   |    2 --
 3 files changed, 12 insertions(+), 35 deletions(-)

diff -puN fs/ext2/super.c~ext2-remove-ext2_xip_verify_sb fs/ext2/super.c
--- a/fs/ext2/super.c~ext2-remove-ext2_xip_verify_sb
+++ a/fs/ext2/super.c
@@ -877,9 +877,6 @@ static int ext2_fill_super(struct super_
 		((EXT2_SB(sb)->s_mount_opt & EXT2_MOUNT_POSIX_ACL) ?
 		 MS_POSIXACL : 0);
 
-	ext2_xip_verify_sb(sb); /* see if bdev supports xip, unset
-				    EXT2_MOUNT_XIP if not */
-
 	if (le32_to_cpu(es->s_rev_level) == EXT2_GOOD_OLD_REV &&
 	    (EXT2_HAS_COMPAT_FEATURE(sb, ~0U) ||
 	     EXT2_HAS_RO_COMPAT_FEATURE(sb, ~0U) ||
@@ -909,11 +906,17 @@ static int ext2_fill_super(struct super_
 
 	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
 
-	if (ext2_use_xip(sb) && blocksize != PAGE_SIZE) {
-		if (!silent)
+	if (sbi->s_mount_opt & EXT2_MOUNT_XIP) {
+		if (blocksize != PAGE_SIZE) {
 			ext2_msg(sb, KERN_ERR,
-				"error: unsupported blocksize for xip");
-		goto failed_mount;
+					"error: unsupported blocksize for xip");
+			goto failed_mount;
+		}
+		if (!sb->s_bdev->bd_disk->fops->direct_access) {
+			ext2_msg(sb, KERN_ERR,
+					"error: device does not support xip");
+			goto failed_mount;
+		}
 	}
 
 	/* If the blocksize doesn't match, re-read the thing.. */
@@ -1259,7 +1262,6 @@ static int ext2_remount (struct super_bl
 {
 	struct ext2_sb_info * sbi = EXT2_SB(sb);
 	struct ext2_super_block * es;
-	unsigned long old_mount_opt = sbi->s_mount_opt;
 	struct ext2_mount_options old_opts;
 	unsigned long old_sb_flags;
 	int err;
@@ -1284,22 +1286,11 @@ static int ext2_remount (struct super_bl
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
 		((sbi->s_mount_opt & EXT2_MOUNT_POSIX_ACL) ? MS_POSIXACL : 0);
 
-	ext2_xip_verify_sb(sb); /* see if bdev supports xip, unset
-				    EXT2_MOUNT_XIP if not */
-
-	if ((ext2_use_xip(sb)) && (sb->s_blocksize != PAGE_SIZE)) {
-		ext2_msg(sb, KERN_WARNING,
-			"warning: unsupported blocksize for xip");
-		err = -EINVAL;
-		goto restore_opts;
-	}
-
 	es = sbi->s_es;
-	if ((sbi->s_mount_opt ^ old_mount_opt) & EXT2_MOUNT_XIP) {
+	if ((sbi->s_mount_opt ^ old_opts.s_mount_opt) & EXT2_MOUNT_XIP) {
 		ext2_msg(sb, KERN_WARNING, "warning: refusing change of "
 			 "xip flag with busy inodes while remounting");
-		sbi->s_mount_opt &= ~EXT2_MOUNT_XIP;
-		sbi->s_mount_opt |= old_mount_opt & EXT2_MOUNT_XIP;
+		sbi->s_mount_opt ^= EXT2_MOUNT_XIP;
 	}
 	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY)) {
 		spin_unlock(&sbi->s_lock);
diff -puN fs/ext2/xip.c~ext2-remove-ext2_xip_verify_sb fs/ext2/xip.c
--- a/fs/ext2/xip.c~ext2-remove-ext2_xip_verify_sb
+++ a/fs/ext2/xip.c
@@ -13,15 +13,3 @@
 #include "ext2.h"
 #include "xip.h"
 
-void ext2_xip_verify_sb(struct super_block *sb)
-{
-	struct ext2_sb_info *sbi = EXT2_SB(sb);
-
-	if ((sbi->s_mount_opt & EXT2_MOUNT_XIP) &&
-	    !sb->s_bdev->bd_disk->fops->direct_access) {
-		sbi->s_mount_opt &= (~EXT2_MOUNT_XIP);
-		ext2_msg(sb, KERN_WARNING,
-			     "warning: ignoring xip option - "
-			     "not supported by bdev");
-	}
-}
diff -puN fs/ext2/xip.h~ext2-remove-ext2_xip_verify_sb fs/ext2/xip.h
--- a/fs/ext2/xip.h~ext2-remove-ext2_xip_verify_sb
+++ a/fs/ext2/xip.h
@@ -6,13 +6,11 @@
  */
 
 #ifdef CONFIG_EXT2_FS_XIP
-extern void ext2_xip_verify_sb (struct super_block *);
 static inline int ext2_use_xip (struct super_block *sb)
 {
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 	return (sbi->s_mount_opt & EXT2_MOUNT_XIP);
 }
 #else
-#define ext2_xip_verify_sb(sb)			do { } while (0)
 #define ext2_use_xip(sb)			0
 #endif
_

Patches currently in -mm which might be from matthew.r.wilcox@intel.com are

origin.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

