From: akpm@linux-foundation.org
Subject: +
 vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax.patch added to -mm tree
Date: Mon, 12 Jan 2015 15:11:06 -0800
Message-ID: <54b4548a.myOLA4GJGoCXUN8y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36319 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbbALXLH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 18:11:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.r.wilcox@intel.com, andreas.dilger@intel.com, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mathieu.desnoyers@efficios.com, rdunlap@infradead.org, ross.zwisler@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs,ext2: remove CONFIG_EXT2_FS_XIP and rename CONFIG_FS_XIP to CONFIG_FS_DAX
has been added to the -mm tree.  Its filename is
     vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: vfs,ext2: remove CONFIG_EXT2_FS_XIP and rename CONFIG_FS_XIP to CONFIG_FS_DAX

The fewer Kconfig options we have the better.  Use the generic
CONFIG_FS_DAX to enable XIP support in ext2 as well as in the core.

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

 fs/Kconfig         |   21 ++++++++++++++-------
 fs/Makefile        |    2 +-
 fs/ext2/Kconfig    |   11 -----------
 fs/ext2/ext2.h     |    2 +-
 fs/ext2/file.c     |    4 ++--
 fs/ext2/super.c    |    4 ++--
 include/linux/fs.h |    2 +-
 scripts/diffconfig |    1 -
 8 files changed, 21 insertions(+), 26 deletions(-)

diff -puN fs/Kconfig~vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax fs/Kconfig
--- a/fs/Kconfig~vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax
+++ a/fs/Kconfig
@@ -13,13 +13,6 @@ if BLOCK
 source "fs/ext2/Kconfig"
 source "fs/ext3/Kconfig"
 source "fs/ext4/Kconfig"
-
-config FS_XIP
-# execute in place
-	bool
-	depends on EXT2_FS_XIP
-	default y
-
 source "fs/jbd/Kconfig"
 source "fs/jbd2/Kconfig"
 
@@ -40,6 +33,20 @@ source "fs/ocfs2/Kconfig"
 source "fs/btrfs/Kconfig"
 source "fs/nilfs2/Kconfig"
 
+config FS_DAX
+	bool "Direct Access (DAX) support"
+	depends on MMU
+	help
+	  Direct Access (DAX) can be used on memory-backed block devices.
+	  If the block device supports DAX and the filesystem supports DAX,
+	  then you can avoid using the pagecache to buffer I/Os.  Turning
+	  on this option will compile in support for DAX; you will need to
+	  mount the filesystem using the -o dax option.
+
+	  If you do not have a block device that is capable of using this,
+	  or if unsure, say N.  Saying Y will increase the size of the kernel
+	  by about 5kB.
+
 endif # BLOCK
 
 # Posix ACL utility routines
diff -puN fs/Makefile~vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax fs/Makefile
--- a/fs/Makefile~vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax
+++ a/fs/Makefile
@@ -28,7 +28,7 @@ obj-$(CONFIG_SIGNALFD)		+= signalfd.o
 obj-$(CONFIG_TIMERFD)		+= timerfd.o
 obj-$(CONFIG_EVENTFD)		+= eventfd.o
 obj-$(CONFIG_AIO)               += aio.o
-obj-$(CONFIG_FS_XIP)		+= dax.o
+obj-$(CONFIG_FS_DAX)		+= dax.o
 obj-$(CONFIG_FILE_LOCKING)      += locks.o
 obj-$(CONFIG_COMPAT)		+= compat.o compat_ioctl.o
 obj-$(CONFIG_BINFMT_AOUT)	+= binfmt_aout.o
diff -puN fs/ext2/Kconfig~vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax fs/ext2/Kconfig
--- a/fs/ext2/Kconfig~vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax
+++ a/fs/ext2/Kconfig
@@ -42,14 +42,3 @@ config EXT2_FS_SECURITY
 
 	  If you are not using a security module that requires using
 	  extended attributes for file security labels, say N.
-
-config EXT2_FS_XIP
-	bool "Ext2 execute in place support"
-	depends on EXT2_FS && MMU
-	help
-	  Execute in place can be used on memory-backed block devices. If you
-	  enable this option, you can select to mount block devices which are
-	  capable of this feature without using the page cache.
-
-	  If you do not use a block device that is capable of using this,
-	  or if unsure, say N.
diff -puN fs/ext2/ext2.h~vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax fs/ext2/ext2.h
--- a/fs/ext2/ext2.h~vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax
+++ a/fs/ext2/ext2.h
@@ -380,7 +380,7 @@ struct ext2_inode {
 #define EXT2_MOUNT_NO_UID32		0x000200  /* Disable 32-bit UIDs */
 #define EXT2_MOUNT_XATTR_USER		0x004000  /* Extended user attributes */
 #define EXT2_MOUNT_POSIX_ACL		0x008000  /* POSIX Access Control Lists */
-#ifdef CONFIG_FS_XIP
+#ifdef CONFIG_FS_DAX
 #define EXT2_MOUNT_XIP			0x010000  /* Execute in place */
 #else
 #define EXT2_MOUNT_XIP			0
diff -puN fs/ext2/file.c~vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax fs/ext2/file.c
--- a/fs/ext2/file.c~vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax
+++ a/fs/ext2/file.c
@@ -25,7 +25,7 @@
 #include "xattr.h"
 #include "acl.h"
 
-#ifdef CONFIG_EXT2_FS_XIP
+#ifdef CONFIG_FS_DAX
 static int ext2_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	return dax_fault(vma, vmf, ext2_get_block);
@@ -109,7 +109,7 @@ const struct file_operations ext2_file_o
 	.splice_write	= iter_file_splice_write,
 };
 
-#ifdef CONFIG_EXT2_FS_XIP
+#ifdef CONFIG_FS_DAX
 const struct file_operations ext2_xip_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= new_sync_read,
diff -puN fs/ext2/super.c~vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax fs/ext2/super.c
--- a/fs/ext2/super.c~vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax
+++ a/fs/ext2/super.c
@@ -291,7 +291,7 @@ static int ext2_show_options(struct seq_
 		seq_puts(seq, ",grpquota");
 #endif
 
-#if defined(CONFIG_EXT2_FS_XIP)
+#ifdef CONFIG_FS_DAX
 	if (sbi->s_mount_opt & EXT2_MOUNT_XIP)
 		seq_puts(seq, ",xip");
 #endif
@@ -558,7 +558,7 @@ static int parse_options(char *options,
 			break;
 #endif
 		case Opt_xip:
-#ifdef CONFIG_EXT2_FS_XIP
+#ifdef CONFIG_FS_DAX
 			set_opt (sbi->s_mount_opt, XIP);
 #else
 			ext2_msg(sb, KERN_INFO, "xip option not supported");
diff -puN include/linux/fs.h~vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax include/linux/fs.h
--- a/include/linux/fs.h~vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax
+++ a/include/linux/fs.h
@@ -1637,7 +1637,7 @@ struct super_operations {
 #define S_IMA		1024	/* Inode has an associated IMA struct */
 #define S_AUTOMOUNT	2048	/* Automount/referral quasi-directory */
 #define S_NOSEC		4096	/* no suid or xattr security attributes */
-#ifdef CONFIG_FS_XIP
+#ifdef CONFIG_FS_DAX
 #define S_DAX		8192	/* Direct Access, avoiding the page cache */
 #else
 #define S_DAX		0	/* Make all the DAX code disappear */
diff -puN scripts/diffconfig~vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax scripts/diffconfig
--- a/scripts/diffconfig~vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax
+++ a/scripts/diffconfig
@@ -28,7 +28,6 @@ If no config files are specified, .confi
 Example usage:
  $ diffconfig .config config-with-some-changes
 -EXT2_FS_XATTR  n
--EXT2_FS_XIP  n
  CRAMFS  n -> y
  EXT2_FS  y -> n
  LOG_BUF_SHIFT  14 -> 16
_

Patches currently in -mm which might be from matthew.r.wilcox@intel.com are

axonram-fix-bug-in-direct_access.patch
block-change-direct_access-calling-convention.patch
mm-fix-xip-fault-vs-truncate-race.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
vfsext2-introduce-is_daxinode.patch
daxext2-replace-xip-read-and-write-with-dax-i-o.patch
daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-xip_truncate_page-with-dax_truncate_page.patch
vfs-remove-get_xip_mem.patch
ext2-remove-ext2_xip_verify_sb.patch
ext2-remove-ext2_use_xip.patch
ext2-remove-xipc-and-xiph.patch
vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax.patch
ext2-remove-ext2_aops_xip.patch
ext2-get-rid-of-most-mentions-of-xip-in-ext2.patch
dax-add-dax_zero_page_range.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality.patch
brd-rename-xip-to-dax.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

