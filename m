From: akpm@linux-foundation.org
Subject: [merged] const-mark-remaining-address_space_operations-const.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:37:08 -0700
Message-ID: <200909222037.n8MKb83t031251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752659AbZIVUmB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     const: mark remaining address_space_operations const
has been removed from the -mm tree.  Its filename was
     const-mark-remaining-address_space_operations-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: const: mark remaining address_space_operations const
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/disk-io.c            |    2 +-
 fs/btrfs/inode.c              |    8 ++++----
 fs/ecryptfs/ecryptfs_kernel.h |    2 +-
 fs/ecryptfs/mmap.c            |    2 +-
 fs/nilfs2/btnode.c            |    2 +-
 fs/nilfs2/gcinode.c           |    2 +-
 fs/nilfs2/inode.c             |    2 +-
 fs/nilfs2/mdt.c               |    2 +-
 fs/nilfs2/nilfs.h             |    2 +-
 fs/omfs/file.c                |    2 +-
 fs/omfs/omfs.h                |    2 +-
 fs/ubifs/xattr.c              |    2 +-
 12 files changed, 15 insertions(+), 15 deletions(-)

diff -puN fs/btrfs/disk-io.c~const-mark-remaining-address_space_operations-const fs/btrfs/disk-io.c
--- a/fs/btrfs/disk-io.c~const-mark-remaining-address_space_operations-const
+++ a/fs/btrfs/disk-io.c
@@ -772,7 +772,7 @@ static void btree_invalidatepage(struct 
 	}
 }
 
-static struct address_space_operations btree_aops = {
+static const struct address_space_operations btree_aops = {
 	.readpage	= btree_readpage,
 	.writepage	= btree_writepage,
 	.writepages	= btree_writepages,
diff -puN fs/btrfs/inode.c~const-mark-remaining-address_space_operations-const fs/btrfs/inode.c
--- a/fs/btrfs/inode.c~const-mark-remaining-address_space_operations-const
+++ a/fs/btrfs/inode.c
@@ -60,8 +60,8 @@ static struct inode_operations btrfs_sym
 static struct inode_operations btrfs_dir_ro_inode_operations;
 static struct inode_operations btrfs_special_inode_operations;
 static struct inode_operations btrfs_file_inode_operations;
-static struct address_space_operations btrfs_aops;
-static struct address_space_operations btrfs_symlink_aops;
+static const struct address_space_operations btrfs_aops;
+static const struct address_space_operations btrfs_symlink_aops;
 static struct file_operations btrfs_dir_file_operations;
 static struct extent_io_ops btrfs_extent_io_ops;
 
@@ -5259,7 +5259,7 @@ static struct extent_io_ops btrfs_extent
  *
  * For now we're avoiding this by dropping bmap.
  */
-static struct address_space_operations btrfs_aops = {
+static const struct address_space_operations btrfs_aops = {
 	.readpage	= btrfs_readpage,
 	.writepage	= btrfs_writepage,
 	.writepages	= btrfs_writepages,
@@ -5271,7 +5271,7 @@ static struct address_space_operations b
 	.set_page_dirty	= btrfs_set_page_dirty,
 };
 
-static struct address_space_operations btrfs_symlink_aops = {
+static const struct address_space_operations btrfs_symlink_aops = {
 	.readpage	= btrfs_readpage,
 	.writepage	= btrfs_writepage,
 	.invalidatepage = btrfs_invalidatepage,
diff -puN fs/ecryptfs/ecryptfs_kernel.h~const-mark-remaining-address_space_operations-const fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~const-mark-remaining-address_space_operations-const
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -582,7 +582,7 @@ extern const struct inode_operations ecr
 extern const struct inode_operations ecryptfs_symlink_iops;
 extern const struct super_operations ecryptfs_sops;
 extern const struct dentry_operations ecryptfs_dops;
-extern struct address_space_operations ecryptfs_aops;
+extern const struct address_space_operations ecryptfs_aops;
 extern int ecryptfs_verbosity;
 extern unsigned int ecryptfs_message_buf_len;
 extern signed long ecryptfs_message_wait_timeout;
diff -puN fs/ecryptfs/mmap.c~const-mark-remaining-address_space_operations-const fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~const-mark-remaining-address_space_operations-const
+++ a/fs/ecryptfs/mmap.c
@@ -545,7 +545,7 @@ static sector_t ecryptfs_bmap(struct add
 	return rc;
 }
 
-struct address_space_operations ecryptfs_aops = {
+const struct address_space_operations ecryptfs_aops = {
 	.writepage = ecryptfs_writepage,
 	.readpage = ecryptfs_readpage,
 	.write_begin = ecryptfs_write_begin,
diff -puN fs/nilfs2/btnode.c~const-mark-remaining-address_space_operations-const fs/nilfs2/btnode.c
--- a/fs/nilfs2/btnode.c~const-mark-remaining-address_space_operations-const
+++ a/fs/nilfs2/btnode.c
@@ -46,7 +46,7 @@ void nilfs_btnode_cache_init_once(struct
 	INIT_LIST_HEAD(&btnc->i_mmap_nonlinear);
 }
 
-static struct address_space_operations def_btnode_aops = {
+static const struct address_space_operations def_btnode_aops = {
 	.sync_page		= block_sync_page,
 };
 
diff -puN fs/nilfs2/gcinode.c~const-mark-remaining-address_space_operations-const fs/nilfs2/gcinode.c
--- a/fs/nilfs2/gcinode.c~const-mark-remaining-address_space_operations-const
+++ a/fs/nilfs2/gcinode.c
@@ -52,7 +52,7 @@
 #include "dat.h"
 #include "ifile.h"
 
-static struct address_space_operations def_gcinode_aops = {
+static const struct address_space_operations def_gcinode_aops = {
 	.sync_page		= block_sync_page,
 };
 
diff -puN fs/nilfs2/inode.c~const-mark-remaining-address_space_operations-const fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~const-mark-remaining-address_space_operations-const
+++ a/fs/nilfs2/inode.c
@@ -238,7 +238,7 @@ nilfs_direct_IO(int rw, struct kiocb *io
 	return size;
 }
 
-struct address_space_operations nilfs_aops = {
+const struct address_space_operations nilfs_aops = {
 	.writepage		= nilfs_writepage,
 	.readpage		= nilfs_readpage,
 	.sync_page		= block_sync_page,
diff -puN fs/nilfs2/mdt.c~const-mark-remaining-address_space_operations-const fs/nilfs2/mdt.c
--- a/fs/nilfs2/mdt.c~const-mark-remaining-address_space_operations-const
+++ a/fs/nilfs2/mdt.c
@@ -427,7 +427,7 @@ nilfs_mdt_write_page(struct page *page, 
 }
 
 
-static struct address_space_operations def_mdt_aops = {
+static const struct address_space_operations def_mdt_aops = {
 	.writepage		= nilfs_mdt_write_page,
 	.sync_page		= block_sync_page,
 };
diff -puN fs/nilfs2/nilfs.h~const-mark-remaining-address_space_operations-const fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h~const-mark-remaining-address_space_operations-const
+++ a/fs/nilfs2/nilfs.h
@@ -297,7 +297,7 @@ void nilfs_clear_gcdat_inode(struct the_
 extern struct file_operations nilfs_dir_operations;
 extern struct inode_operations nilfs_file_inode_operations;
 extern struct file_operations nilfs_file_operations;
-extern struct address_space_operations nilfs_aops;
+extern const struct address_space_operations nilfs_aops;
 extern struct inode_operations nilfs_dir_inode_operations;
 extern struct inode_operations nilfs_special_inode_operations;
 extern struct inode_operations nilfs_symlink_inode_operations;
diff -puN fs/omfs/file.c~const-mark-remaining-address_space_operations-const fs/omfs/file.c
--- a/fs/omfs/file.c~const-mark-remaining-address_space_operations-const
+++ a/fs/omfs/file.c
@@ -337,7 +337,7 @@ struct inode_operations omfs_file_inops 
 	.truncate = omfs_truncate
 };
 
-struct address_space_operations omfs_aops = {
+const struct address_space_operations omfs_aops = {
 	.readpage = omfs_readpage,
 	.readpages = omfs_readpages,
 	.writepage = omfs_writepage,
diff -puN fs/omfs/omfs.h~const-mark-remaining-address_space_operations-const fs/omfs/omfs.h
--- a/fs/omfs/omfs.h~const-mark-remaining-address_space_operations-const
+++ a/fs/omfs/omfs.h
@@ -53,7 +53,7 @@ extern int omfs_is_bad(struct omfs_sb_in
 /* file.c */
 extern struct file_operations omfs_file_operations;
 extern struct inode_operations omfs_file_inops;
-extern struct address_space_operations omfs_aops;
+extern const struct address_space_operations omfs_aops;
 extern void omfs_make_empty_table(struct buffer_head *bh, int offset);
 extern int omfs_shrink_inode(struct inode *inode);
 
diff -puN fs/ubifs/xattr.c~const-mark-remaining-address_space_operations-const fs/ubifs/xattr.c
--- a/fs/ubifs/xattr.c~const-mark-remaining-address_space_operations-const
+++ a/fs/ubifs/xattr.c
@@ -79,7 +79,7 @@ enum {
 };
 
 static const struct inode_operations none_inode_operations;
-static struct address_space_operations none_address_operations;
+static const struct address_space_operations none_address_operations;
 static const struct file_operations none_file_operations;
 
 /**
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
acpi-switch-proc-acpi-debug_layerdebug_level-to-seq_file.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
cpqarray-switch-to-seq_file.patch
dac960-switch-to-seq_file.patch
proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch
procfs-provide-stack-information-for-threads-v08.patch
procfs-provide-stack-information-for-threads-v011.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
viafb-switch-to-seq_file.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
sysctl-remove-struct-file-argument-of-proc_handler.patch
aio-ifdef-fields-in-mm_struct.patch
gru-use-proc_create.patch

