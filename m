From: akpm@linux-foundation.org
Subject: + omfs-define-filesystem-structures.patch added to -mm tree
Date: Tue, 06 May 2008 13:07:48 -0700
Message-ID: <200805062007.m46K7mFH024902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763084AbYEFUIS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 16:08:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: me@bobcopeland.com


The patch titled
     omfs: define filesystem structures
has been added to the -mm tree.  Its filename is
     omfs-define-filesystem-structures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omfs: define filesystem structures
From: Bob Copeland <me@bobcopeland.com>

Add header files containing OMFS on-disk and memory structures.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/omfs/omfs.h    |   67 ++++++++++++++++++++++++++++++++++++
 fs/omfs/omfs_fs.h |   80 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 147 insertions(+)

diff -puN /dev/null fs/omfs/omfs.h
--- /dev/null
+++ a/fs/omfs/omfs.h
@@ -0,0 +1,67 @@
+#ifndef _OMFS_H
+#define _OMFS_H
+
+#include <linux/module.h>
+#include <linux/fs.h>
+
+#include "omfs_fs.h"
+
+/* In-memory structures */
+struct omfs_sb_info {
+	u64 s_num_blocks;
+	u64 s_bitmap_ino;
+	u64 s_root_ino;
+	u32 s_blocksize;
+	u32 s_mirrors;
+	u32 s_sys_blocksize;
+	u32 s_clustersize;
+	int s_block_shift;
+	unsigned long **s_imap;
+	int s_imap_size;
+	struct mutex s_bitmap_lock;
+	int s_uid;
+	int s_gid;
+	int s_dmask;
+	int s_fmask;
+};
+
+/* convert a cluster number to a scaled block number */
+static inline sector_t clus_to_blk(struct omfs_sb_info *sbi, sector_t block)
+{
+	return block << sbi->s_block_shift;
+}
+
+static inline struct omfs_sb_info *OMFS_SB(struct super_block *sb)
+{
+	return sb->s_fs_info;
+}
+
+/* bitmap.c */
+extern unsigned long omfs_count_free(struct super_block *sb);
+extern int omfs_allocate_block(struct super_block *sb, u64 block);
+extern int omfs_allocate_range(struct super_block *sb, int min_request,
+			int max_request, u64 *return_block, int *return_size);
+extern int omfs_clear_range(struct super_block *sb, u64 block, int count);
+
+/* dir.c */
+extern struct file_operations omfs_dir_operations;
+extern struct inode_operations omfs_dir_inops;
+extern int omfs_make_empty(struct inode *inode, struct super_block *sb);
+extern int omfs_is_bad(struct omfs_sb_info *sbi, struct omfs_header *header,
+			u64 fsblock);
+
+/* file.c */
+extern struct file_operations omfs_file_operations;
+extern struct inode_operations omfs_file_inops;
+extern struct address_space_operations omfs_aops;
+extern void omfs_make_empty_table(struct buffer_head *bh, int offset);
+extern int omfs_shrink_inode(struct inode *inode);
+
+/* inode.c */
+extern struct inode *omfs_iget(struct super_block *sb, ino_t inode);
+extern struct inode *omfs_new_inode(struct inode *dir, int mode);
+extern int omfs_reserve_block(struct super_block *sb, sector_t block);
+extern int omfs_find_empty_block(struct super_block *sb, int mode, ino_t *ino);
+extern int omfs_sync_inode(struct inode *inode);
+
+#endif
diff -puN /dev/null fs/omfs/omfs_fs.h
--- /dev/null
+++ a/fs/omfs/omfs_fs.h
@@ -0,0 +1,80 @@
+#ifndef _OMFS_FS_H
+#define _OMFS_FS_H
+
+/* OMFS On-disk structures */
+
+#define OMFS_MAGIC 0xC2993D87
+#define OMFS_IMAGIC 0xD2
+
+#define OMFS_DIR 'D'
+#define OMFS_FILE 'F'
+#define OMFS_INODE_NORMAL 'e'
+#define OMFS_INODE_CONTINUATION 'c'
+#define OMFS_INODE_SYSTEM 's'
+#define OMFS_NAMELEN 256
+#define OMFS_DIR_START 0x1b8
+#define OMFS_EXTENT_START 0x1d0
+#define OMFS_EXTENT_CONT 0x40
+#define OMFS_XOR_COUNT 19
+#define OMFS_MAX_BLOCK_SIZE 8192
+
+struct omfs_super_block {
+	char s_fill1[256];
+	__be64 s_root_block;		/* block number of omfs_root_block */
+	__be64 s_num_blocks;		/* total number of FS blocks */
+	__be32 s_magic;			/* OMFS_MAGIC */
+	__be32 s_blocksize;		/* size of a block */
+	__be32 s_mirrors;		/* # of mirrors of system blocks */
+	__be32 s_sys_blocksize;		/* size of non-data blocks */
+};
+
+struct omfs_header {
+	__be64 h_self;			/* FS block where this is located */
+	__be32 h_body_size;		/* size of useful data after header */
+	__be16 h_crc;			/* crc-ccitt of body_size bytes */
+	char h_fill1[2];
+	u8 h_version;			/* version, always 1 */
+	char h_type;			/* OMFS_INODE_X */
+	u8 h_magic;			/* OMFS_IMAGIC */
+	u8 h_check_xor;			/* XOR of header bytes before this */
+	__be32 h_fill2;
+};
+
+struct omfs_root_block {
+	struct omfs_header r_head;	/* header */
+	__be64 r_fill1;
+	__be64 r_num_blocks;		/* total number of FS blocks */
+	__be64 r_root_dir;		/* block # of root directory */
+	__be64 r_bitmap;		/* block # of free space bitmap */
+	__be32 r_blocksize;		/* size of a block */
+	__be32 r_clustersize;		/* size allocated for data blocks */
+	__be64 r_mirrors;		/* # of mirrors of system blocks */
+	char r_name[OMFS_NAMELEN];	/* partition label */
+};
+
+struct omfs_inode {
+	struct omfs_header i_head;	/* header */
+	__be64 i_parent;		/* parent containing this inode */
+	__be64 i_sibling;		/* next inode in hash bucket */
+	__be64 i_ctime;			/* ctime, in milliseconds */
+	char i_fill1[35];
+	char i_type;			/* OMFS_[DIR,FILE] */
+	__be32 i_fill2;
+	char i_fill3[64];
+	char i_name[OMFS_NAMELEN];	/* filename */
+	__be64 i_size;			/* size of file, in bytes */
+};
+
+struct omfs_extent_entry {
+	__be64 e_cluster;		/* start location of a set of blocks */
+	__be64 e_blocks;		/* number of blocks after e_cluster */
+};
+
+struct omfs_extent {
+	__be64 e_next;			/* next extent table location */
+	__be32 e_extent_count;		/* total # extents in this table */
+	__be32 e_fill;
+	struct omfs_extent_entry e_entry;	/* start of extent entries */
+};
+
+#endif
_

Patches currently in -mm which might be from me@bobcopeland.com are

omfs-add-filesystem-documentation.patch
omfs-define-filesystem-structures.patch
omfs-add-inode-routines.patch
omfs-add-directory-routines.patch
omfs-add-file-routines.patch
omfs-add-bitmap-routines.patch
omfs-update-kbuild-to-include-omfs.patch
omfs-add-maintainers-entry.patch

