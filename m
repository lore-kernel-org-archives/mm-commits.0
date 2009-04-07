From: akpm@linux-foundation.org
Subject: [merged] nilfs2-add-inode-and-other-major-structures.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:08:14 -0700
Message-ID: <200904071908.n37J8E6U011690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750804AbZDGThh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:37:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, sato.koji@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     nilfs2: add inode and other major structures
has been removed from the -mm tree.  Its filename was
     nilfs2-add-inode-and-other-major-structures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: add inode and other major structures
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This adds the following common structures of the NILFS2 file system.

* nilfs_inode_info structure:
  gives on-memory inode.

* nilfs_sb_info structure:
  keeps per-mount state and a special inode for the ifile.
  This structure is attached to the super_block structure.

* the_nilfs structure:
  keeps shared state and locks among a read/write mount and snapshot
  mounts.  This keeps special inodes for the sufile, cpfile, dat, and
  another dat inode used during GC (gcdat).  This also has a hash table
  of dummy inodes to cache disk blocks during GC (gcinodes).

* nilfs_transaction_info structure:
  keeps per task state while nilfs is writing logs or doing indivisible
  inode or namespace operations.  This structure is used to identify
  context during log making and store nest level of the lock which
  ensures atomicity of file system operations.

Signed-off-by: Koji Sato <sato.koji@lab.ntt.co.jp>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/nilfs.h     |  323 ++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/sb.h        |  102 ++++++++++++
 fs/nilfs2/the_nilfs.h |  290 +++++++++++++++++++++++++++++++++++
 3 files changed, 715 insertions(+)

diff -puN /dev/null fs/nilfs2/nilfs.h
--- /dev/null
+++ a/fs/nilfs2/nilfs.h
@@ -0,0 +1,323 @@
+/*
+ * nilfs.h - NILFS local header file.
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Koji Sato <koji@osrg.net>
+ *            Ryusuke Konishi <ryusuke@osrg.net>
+ */
+
+#ifndef _NILFS_H
+#define _NILFS_H
+
+#include <linux/kernel.h>
+#include <linux/buffer_head.h>
+#include <linux/spinlock.h>
+#include <linux/blkdev.h>
+#include <linux/nilfs2_fs.h>
+#include "the_nilfs.h"
+#include "sb.h"
+#include "bmap.h"
+#include "bmap_union.h"
+
+/*
+ * NILFS filesystem version
+ */
+#define NILFS_VERSION		"2.0.5"
+
+/*
+ * nilfs inode data in memory
+ */
+struct nilfs_inode_info {
+	__u32 i_flags;
+	unsigned long  i_state;		/* Dynamic state flags */
+	struct nilfs_bmap *i_bmap;
+	union nilfs_bmap_union i_bmap_union;
+	__u64 i_xattr;	/* sector_t ??? */
+	__u32 i_dtime;
+	__u32 i_dir_start_lookup;
+	__u64 i_cno;		/* check point number for GC inode */
+	struct address_space i_btnode_cache;
+	struct list_head i_dirty;	/* List for connecting dirty files */
+
+#ifdef CONFIG_NILFS_XATTR
+	/*
+	 * Extended attributes can be read independently of the main file
+	 * data. Taking i_sem even when reading would cause contention
+	 * between readers of EAs and writers of regular file data, so
+	 * instead we synchronize on xattr_sem when reading or changing
+	 * EAs.
+	 */
+	struct rw_semaphore xattr_sem;
+#endif
+#ifdef CONFIG_NILFS_POSIX_ACL
+	struct posix_acl *i_acl;
+	struct posix_acl *i_default_acl;
+#endif
+	struct buffer_head *i_bh;	/* i_bh contains a new or dirty
+					   disk inode */
+	struct inode vfs_inode;
+};
+
+static inline struct nilfs_inode_info *NILFS_I(const struct inode *inode)
+{
+	return container_of(inode, struct nilfs_inode_info, vfs_inode);
+}
+
+static inline struct nilfs_inode_info *
+NILFS_BMAP_I(const struct nilfs_bmap *bmap)
+{
+	return container_of((union nilfs_bmap_union *)bmap,
+			    struct nilfs_inode_info,
+			    i_bmap_union);
+}
+
+static inline struct inode *NILFS_BTNC_I(struct address_space *btnc)
+{
+	struct nilfs_inode_info *ii =
+		container_of(btnc, struct nilfs_inode_info, i_btnode_cache);
+	return &ii->vfs_inode;
+}
+
+static inline struct inode *NILFS_AS_I(struct address_space *mapping)
+{
+	return (mapping->host) ? :
+		container_of(mapping, struct inode, i_data);
+}
+
+/*
+ * Dynamic state flags of NILFS on-memory inode (i_state)
+ */
+enum {
+	NILFS_I_NEW = 0,		/* Inode is newly created */
+	NILFS_I_DIRTY,			/* The file is dirty */
+	NILFS_I_QUEUED,			/* inode is in dirty_files list */
+	NILFS_I_BUSY,			/* inode is grabbed by a segment
+					   constructor */
+	NILFS_I_COLLECTED,		/* All dirty blocks are collected */
+	NILFS_I_UPDATED,		/* The file has been written back */
+	NILFS_I_INODE_DIRTY,		/* write_inode is requested */
+	NILFS_I_BMAP,			/* has bmap and btnode_cache */
+	NILFS_I_GCINODE,		/* inode for GC, on memory only */
+	NILFS_I_GCDAT,			/* shadow DAT, on memory only */
+};
+
+/*
+ * Macros to check inode numbers
+ */
+#define NILFS_MDT_INO_BITS   \
+  ((unsigned int)(1 << NILFS_DAT_INO | 1 << NILFS_CPFILE_INO |		\
+		  1 << NILFS_SUFILE_INO | 1 << NILFS_IFILE_INO |	\
+		  1 << NILFS_ATIME_INO | 1 << NILFS_SKETCH_INO))
+
+#define NILFS_SYS_INO_BITS   \
+  ((unsigned int)(1 << NILFS_ROOT_INO) | NILFS_MDT_INO_BITS)
+
+#define NILFS_FIRST_INO(sb)  (NILFS_SB(sb)->s_nilfs->ns_first_ino)
+
+#define NILFS_MDT_INODE(sb, ino) \
+  ((ino) < NILFS_FIRST_INO(sb) && (NILFS_MDT_INO_BITS & (1 << (ino))))
+#define NILFS_VALID_INODE(sb, ino) \
+  ((ino) >= NILFS_FIRST_INO(sb) || (NILFS_SYS_INO_BITS & (1 << (ino))))
+
+/**
+ * struct nilfs_transaction_info: context information for synchronization
+ * @ti_magic: Magic number
+ * @ti_save: Backup of journal_info field of task_struct
+ * @ti_flags: Flags
+ * @ti_count: Nest level
+ * @ti_garbage:	List of inode to be put when releasing semaphore
+ */
+struct nilfs_transaction_info {
+	u32			ti_magic;
+	void		       *ti_save;
+				/* This should never used. If this happens,
+				   one of other filesystems has a bug. */
+	unsigned short		ti_flags;
+	unsigned short		ti_count;
+	struct list_head	ti_garbage;
+};
+
+/* ti_magic */
+#define NILFS_TI_MAGIC		0xd9e392fb
+
+/* ti_flags */
+#define NILFS_TI_DYNAMIC_ALLOC	0x0001  /* Allocated from slab */
+#define NILFS_TI_SYNC		0x0002	/* Force to construct segment at the
+					   end of transaction. */
+#define NILFS_TI_GC		0x0004	/* GC context */
+#define NILFS_TI_COMMIT		0x0008	/* Change happened or not */
+#define NILFS_TI_WRITER		0x0010	/* Constructor context */
+
+
+int nilfs_transaction_begin(struct super_block *,
+			    struct nilfs_transaction_info *, int);
+int nilfs_transaction_end(struct super_block *, int);
+
+static inline void nilfs_set_transaction_flag(unsigned int flag)
+{
+	struct nilfs_transaction_info *ti = current->journal_info;
+
+	BUG_ON(!ti);
+	ti->ti_flags |= flag;
+}
+
+static inline int nilfs_test_transaction_flag(unsigned int flag)
+{
+	struct nilfs_transaction_info *ti = current->journal_info;
+
+	if (ti == NULL || ti->ti_magic != NILFS_TI_MAGIC)
+		return 0;
+	return !!(ti->ti_flags & flag);
+}
+
+static inline int nilfs_doing_gc(void)
+{
+	return nilfs_test_transaction_flag(NILFS_TI_GC);
+}
+
+static inline int nilfs_doing_construction(void)
+{
+	return nilfs_test_transaction_flag(NILFS_TI_WRITER);
+}
+
+static inline struct inode *nilfs_dat_inode(const struct the_nilfs *nilfs)
+{
+	return nilfs_doing_gc() ? nilfs->ns_gc_dat : nilfs->ns_dat;
+}
+
+/*
+ * function prototype
+ */
+#ifdef CONFIG_NILFS_POSIX_ACL
+#error "NILFS: not yet supported POSIX ACL"
+extern int nilfs_permission(struct inode *, int, struct nameidata *);
+extern int nilfs_acl_chmod(struct inode *);
+extern int nilfs_init_acl(struct inode *, struct inode *);
+#else
+#define nilfs_permission   NULL
+
+static inline int nilfs_acl_chmod(struct inode *inode)
+{
+	return 0;
+}
+
+static inline int nilfs_init_acl(struct inode *inode, struct inode *dir)
+{
+	inode->i_mode &= ~current_umask();
+	return 0;
+}
+#endif
+
+#define NILFS_ATIME_DISABLE
+
+/* dir.c */
+extern int nilfs_add_link(struct dentry *, struct inode *);
+extern ino_t nilfs_inode_by_name(struct inode *, struct dentry *);
+extern int nilfs_make_empty(struct inode *, struct inode *);
+extern struct nilfs_dir_entry *
+nilfs_find_entry(struct inode *, struct dentry *, struct page **);
+extern int nilfs_delete_entry(struct nilfs_dir_entry *, struct page *);
+extern int nilfs_empty_dir(struct inode *);
+extern struct nilfs_dir_entry *nilfs_dotdot(struct inode *, struct page **);
+extern void nilfs_set_link(struct inode *, struct nilfs_dir_entry *,
+			   struct page *, struct inode *);
+
+/* file.c */
+extern int nilfs_sync_file(struct file *, struct dentry *, int);
+
+/* ioctl.c */
+int nilfs_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
+long nilfs_compat_ioctl(struct file *, unsigned int, unsigned long);
+int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *, void __user *);
+
+/* inode.c */
+extern struct inode *nilfs_new_inode(struct inode *, int);
+extern void nilfs_free_inode(struct inode *);
+extern int nilfs_get_block(struct inode *, sector_t, struct buffer_head *, int);
+extern void nilfs_set_inode_flags(struct inode *);
+extern int nilfs_read_inode_common(struct inode *, struct nilfs_inode *);
+extern void nilfs_write_inode_common(struct inode *, struct nilfs_inode *, int);
+extern struct inode *nilfs_iget(struct super_block *, unsigned long);
+extern void nilfs_update_inode(struct inode *, struct buffer_head *);
+extern void nilfs_truncate(struct inode *);
+extern void nilfs_delete_inode(struct inode *);
+extern int nilfs_setattr(struct dentry *, struct iattr *);
+extern int nilfs_load_inode_block(struct nilfs_sb_info *, struct inode *,
+				  struct buffer_head **);
+extern int nilfs_inode_dirty(struct inode *);
+extern int nilfs_set_file_dirty(struct nilfs_sb_info *, struct inode *,
+				unsigned);
+extern int nilfs_mark_inode_dirty(struct inode *);
+extern void nilfs_dirty_inode(struct inode *);
+
+/* namei.c */
+extern struct dentry *nilfs_get_parent(struct dentry *);
+
+/* super.c */
+extern struct inode *nilfs_alloc_inode(struct super_block *);
+extern void nilfs_destroy_inode(struct inode *);
+extern void nilfs_error(struct super_block *, const char *, const char *, ...)
+	__attribute__ ((format (printf, 3, 4)));
+extern void nilfs_warning(struct super_block *, const char *, const char *, ...)
+       __attribute__ ((format (printf, 3, 4)));
+extern struct nilfs_super_block *
+nilfs_load_super_block(struct super_block *, struct buffer_head **);
+extern struct nilfs_super_block *
+nilfs_reload_super_block(struct super_block *, struct buffer_head **, int);
+extern int nilfs_store_magic_and_option(struct super_block *,
+					struct nilfs_super_block *, char *);
+extern void nilfs_update_last_segment(struct nilfs_sb_info *, int);
+extern int nilfs_commit_super(struct nilfs_sb_info *);
+extern int nilfs_attach_checkpoint(struct nilfs_sb_info *, __u64);
+extern void nilfs_detach_checkpoint(struct nilfs_sb_info *);
+
+/* gcinode.c */
+int nilfs_gccache_submit_read_data(struct inode *, sector_t, sector_t, __u64,
+				   struct buffer_head **);
+int nilfs_gccache_submit_read_node(struct inode *, sector_t, __u64,
+				   struct buffer_head **);
+int nilfs_gccache_wait_and_mark_dirty(struct buffer_head *);
+int nilfs_init_gccache(struct the_nilfs *);
+void nilfs_destroy_gccache(struct the_nilfs *);
+void nilfs_clear_gcinode(struct inode *);
+struct inode *nilfs_gc_iget(struct the_nilfs *, ino_t, __u64);
+void nilfs_remove_all_gcinode(struct the_nilfs *);
+
+/* gcdat.c */
+int nilfs_init_gcdat_inode(struct the_nilfs *);
+void nilfs_commit_gcdat_inode(struct the_nilfs *);
+void nilfs_clear_gcdat_inode(struct the_nilfs *);
+
+/*
+ * Inodes and files operations
+ */
+extern struct file_operations nilfs_dir_operations;
+extern struct inode_operations nilfs_file_inode_operations;
+extern struct file_operations nilfs_file_operations;
+extern struct address_space_operations nilfs_aops;
+extern struct inode_operations nilfs_dir_inode_operations;
+extern struct inode_operations nilfs_special_inode_operations;
+extern struct inode_operations nilfs_symlink_inode_operations;
+
+/*
+ * filesystem type
+ */
+extern struct file_system_type nilfs_fs_type;
+
+
+#endif	/* _NILFS_H */
diff -puN /dev/null fs/nilfs2/sb.h
--- /dev/null
+++ a/fs/nilfs2/sb.h
@@ -0,0 +1,102 @@
+/*
+ * sb.h - NILFS on-memory super block structure.
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ *
+ */
+
+#ifndef _NILFS_SB
+#define _NILFS_SB
+
+#include <linux/types.h>
+#include <linux/fs.h>
+
+/*
+ * Mount options
+ */
+struct nilfs_mount_options {
+	unsigned long mount_opt;
+	__u64 snapshot_cno;
+};
+
+struct the_nilfs;
+struct nilfs_sc_info;
+
+/*
+ * NILFS super-block data in memory
+ */
+struct nilfs_sb_info {
+	/* Snapshot status */
+	__u64 s_snapshot_cno;		/* Checkpoint number */
+	atomic_t s_inodes_count;
+	atomic_t s_blocks_count;	/* Reserved (might be deleted) */
+
+	/* Mount options */
+	unsigned long s_mount_opt;
+	uid_t s_resuid;
+	gid_t s_resgid;
+
+	unsigned long s_interval;	/* construction interval */
+	unsigned long s_watermark;	/* threshold of data amount
+					   for the segment construction */
+
+	/* Fundamental members */
+	struct super_block *s_super;	/* reverse pointer to super_block */
+	struct the_nilfs *s_nilfs;
+	struct list_head s_list;	/* list head for nilfs->ns_supers */
+
+	/* Segment constructor */
+	struct list_head s_dirty_files;	/* dirty files list */
+	struct nilfs_sc_info *s_sc_info; /* segment constructor info */
+	spinlock_t s_inode_lock;	/* Lock for the nilfs inode.
+					   It covers s_dirty_files list */
+
+	/* Metadata files */
+	struct inode *s_ifile;		/* index file inode */
+
+	/* Inode allocator */
+	spinlock_t s_next_gen_lock;
+	u32 s_next_generation;
+};
+
+static inline struct nilfs_sb_info *NILFS_SB(struct super_block *sb)
+{
+	return sb->s_fs_info;
+}
+
+static inline struct nilfs_sc_info *NILFS_SC(struct nilfs_sb_info *sbi)
+{
+	return sbi->s_sc_info;
+}
+
+/*
+ * Bit operations for the mount option
+ */
+#define nilfs_clear_opt(sbi, opt)  \
+	do { (sbi)->s_mount_opt &= ~NILFS_MOUNT_##opt; } while (0)
+#define nilfs_set_opt(sbi, opt)  \
+	do { (sbi)->s_mount_opt |= NILFS_MOUNT_##opt; } while (0)
+#define nilfs_test_opt(sbi, opt)   ((sbi)->s_mount_opt & NILFS_MOUNT_##opt)
+#define nilfs_write_opt(sbi, mask, opt)					\
+	do { (sbi)->s_mount_opt =					\
+		(((sbi)->s_mount_opt & ~NILFS_MOUNT_##mask) |		\
+		 NILFS_MOUNT_##opt);					\
+	} while (0)
+
+#endif /* _NILFS_SB */
diff -puN /dev/null fs/nilfs2/the_nilfs.h
--- /dev/null
+++ a/fs/nilfs2/the_nilfs.h
@@ -0,0 +1,290 @@
+/*
+ * the_nilfs.h - the_nilfs shared structure.
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ *
+ */
+
+#ifndef _THE_NILFS_H
+#define _THE_NILFS_H
+
+#include <linux/types.h>
+#include <linux/buffer_head.h>
+#include <linux/fs.h>
+#include <linux/blkdev.h>
+#include <linux/backing-dev.h>
+#include "sb.h"
+
+/* the_nilfs struct */
+enum {
+	THE_NILFS_INIT = 0,     /* Information from super_block is set */
+	THE_NILFS_LOADED,       /* Roll-back/roll-forward has done and
+				   the latest checkpoint was loaded */
+	THE_NILFS_DISCONTINUED,	/* 'next' pointer chain has broken */
+	THE_NILFS_COND_NONGC_WRITE,	/* Condition to wake up cleanerd */
+};
+
+/**
+ * struct the_nilfs - struct to supervise multiple nilfs mount points
+ * @ns_flags: flags
+ * @ns_count: reference count
+ * @ns_bdev: block device
+ * @ns_bdi: backing dev info
+ * @ns_writer: back pointer to writable nilfs_sb_info
+ * @ns_sem: semaphore for shared states
+ * @ns_writer_mutex: mutex protecting ns_writer attach/detach
+ * @ns_writer_refcount: number of referrers on ns_writer
+ * @ns_sbh: buffer head of the on-disk super block
+ * @ns_sbp: pointer to the super block data
+ * @ns_used_segments: list of full segments in volatile active state
+ * @ns_supers: list of nilfs super block structs
+ * @ns_seg_seq: segment sequence counter
+ * @ns_segnum: index number of the latest full segment.
+ * @ns_nextnum: index number of the full segment index to be used next
+ * @ns_pseg_offset: offset of next partial segment in the current full segment
+ * @ns_cno: next checkpoint number
+ * @ns_ctime: write time of the last segment
+ * @ns_nongc_ctime: write time of the last segment not for cleaner operation
+ * @ns_ndirtyblks: Number of dirty data blocks
+ * @ns_last_segment_lock: lock protecting fields for the latest segment
+ * @ns_last_pseg: start block number of the latest segment
+ * @ns_last_seq: sequence value of the latest segment
+ * @ns_last_cno: checkpoint number of the latest segment
+ * @ns_free_segments_count: counter of free segments
+ * @ns_segctor_sem: segment constructor semaphore
+ * @ns_dat: DAT file inode
+ * @ns_cpfile: checkpoint file inode
+ * @ns_sufile: segusage file inode
+ * @ns_gc_dat: shadow inode of the DAT file inode for GC
+ * @ns_gc_inodes: dummy inodes to keep live blocks
+ * @ns_gc_inodes_h: hash list to keep dummy inode holding live blocks
+ * @ns_cleanerd_wq: wait queue for cleanerd
+ * @ns_blocksize_bits: bit length of block size
+ * @ns_nsegments: number of segments in filesystem
+ * @ns_blocks_per_segment: number of blocks per segment
+ * @ns_r_segments_percentage: reserved segments percentage
+ * @ns_nrsvsegs: number of reserved segments
+ * @ns_first_data_block: block number of first data block
+ * @ns_inode_size: size of on-disk inode
+ * @ns_first_ino: first not-special inode number
+ * @ns_crc_seed: seed value of CRC32 calculation
+ */
+struct the_nilfs {
+	unsigned long		ns_flags;
+	atomic_t		ns_count;
+
+	struct block_device    *ns_bdev;
+	struct backing_dev_info *ns_bdi;
+	struct nilfs_sb_info   *ns_writer;
+	struct rw_semaphore	ns_sem;
+	struct mutex		ns_writer_mutex;
+	atomic_t		ns_writer_refcount;
+
+	/*
+	 * used for
+	 * - loading the latest checkpoint exclusively.
+	 * - allocating a new full segment.
+	 * - protecting s_dirt in the super_block struct
+	 *   (see nilfs_write_super) and the following fields.
+	 */
+	struct buffer_head     *ns_sbh;
+	struct nilfs_super_block *ns_sbp;
+	struct list_head	ns_used_segments;
+	unsigned		ns_mount_state;
+	struct list_head	ns_supers;
+
+	/*
+	 * Following fields are dedicated to a writable FS-instance.
+	 * Except for the period seeking checkpoint, code outside the segment
+	 * constructor must lock a segment semaphore with transaction_begin()
+	 * and transaction_end(), when accessing these fields.
+	 * The writable FS-instance is sole during a lifetime of the_nilfs.
+	 */
+	u64			ns_seg_seq;
+	__u64			ns_segnum;
+	__u64			ns_nextnum;
+	unsigned long		ns_pseg_offset;
+	__u64			ns_cno;
+	time_t			ns_ctime;
+	time_t			ns_nongc_ctime;
+	atomic_t		ns_ndirtyblks;
+
+	/*
+	 * The following fields hold information on the latest partial segment
+	 * written to disk with a super root.  These fields are protected by
+	 * ns_last_segment_lock.
+	 */
+	spinlock_t		ns_last_segment_lock;
+	sector_t		ns_last_pseg;
+	u64			ns_last_seq;
+	__u64			ns_last_cno;
+	unsigned long		ns_free_segments_count;
+
+	struct rw_semaphore	ns_segctor_sem;
+
+	/*
+	 * Following fields are lock free except for the period before
+	 * the_nilfs is initialized.
+	 */
+	struct inode	       *ns_dat;
+	struct inode	       *ns_cpfile;
+	struct inode	       *ns_sufile;
+	struct inode	       *ns_gc_dat;
+
+	/* GC inode list and hash table head */
+	struct list_head	ns_gc_inodes;
+	struct hlist_head      *ns_gc_inodes_h;
+
+	/* cleanerd */
+	wait_queue_head_t	ns_cleanerd_wq;
+
+	/* Disk layout information (static) */
+	unsigned int		ns_blocksize_bits;
+	unsigned long		ns_nsegments;
+	unsigned long		ns_blocks_per_segment;
+	unsigned long		ns_r_segments_percentage;
+	unsigned long		ns_nrsvsegs;
+	unsigned long		ns_first_data_block;
+	int			ns_inode_size;
+	int			ns_first_ino;
+	u32			ns_crc_seed;
+};
+
+#define NILFS_GCINODE_HASH_BITS		8
+#define NILFS_GCINODE_HASH_SIZE		(1<<NILFS_GCINODE_HASH_BITS)
+
+#define THE_NILFS_FNS(bit, name)					\
+static inline void set_nilfs_##name(struct the_nilfs *nilfs)		\
+{									\
+	set_bit(THE_NILFS_##bit, &(nilfs)->ns_flags);			\
+}									\
+static inline void clear_nilfs_##name(struct the_nilfs *nilfs)		\
+{									\
+	clear_bit(THE_NILFS_##bit, &(nilfs)->ns_flags);			\
+}									\
+static inline int nilfs_##name(struct the_nilfs *nilfs)			\
+{									\
+	return test_bit(THE_NILFS_##bit, &(nilfs)->ns_flags);		\
+}
+
+THE_NILFS_FNS(INIT, init)
+THE_NILFS_FNS(LOADED, loaded)
+THE_NILFS_FNS(DISCONTINUED, discontinued)
+THE_NILFS_FNS(COND_NONGC_WRITE, cond_nongc_write)
+
+void nilfs_set_last_segment(struct the_nilfs *, sector_t, u64, __u64);
+struct the_nilfs *alloc_nilfs(struct block_device *);
+void put_nilfs(struct the_nilfs *);
+int init_nilfs(struct the_nilfs *, struct nilfs_sb_info *, char *);
+int load_nilfs(struct the_nilfs *, struct nilfs_sb_info *);
+int nilfs_count_free_blocks(struct the_nilfs *, sector_t *);
+void nilfs_dispose_used_segments(struct the_nilfs *);
+int nilfs_checkpoint_is_mounted(struct the_nilfs *, __u64, int);
+int nilfs_near_disk_full(struct the_nilfs *);
+
+
+static inline void get_nilfs(struct the_nilfs *nilfs)
+{
+	/* Caller must have at least one reference of the_nilfs. */
+	atomic_inc(&nilfs->ns_count);
+}
+
+static inline struct nilfs_sb_info *nilfs_get_writer(struct the_nilfs *nilfs)
+{
+	if (atomic_inc_and_test(&nilfs->ns_writer_refcount))
+		mutex_lock(&nilfs->ns_writer_mutex);
+	return nilfs->ns_writer;
+}
+
+static inline void nilfs_put_writer(struct the_nilfs *nilfs)
+{
+	if (atomic_add_negative(-1, &nilfs->ns_writer_refcount))
+		mutex_unlock(&nilfs->ns_writer_mutex);
+}
+
+static inline void
+nilfs_attach_writer(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
+{
+	mutex_lock(&nilfs->ns_writer_mutex);
+	nilfs->ns_writer = sbi;
+	mutex_unlock(&nilfs->ns_writer_mutex);
+}
+
+static inline void
+nilfs_detach_writer(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
+{
+	mutex_lock(&nilfs->ns_writer_mutex);
+	if (sbi == nilfs->ns_writer)
+		nilfs->ns_writer = NULL;
+	mutex_unlock(&nilfs->ns_writer_mutex);
+}
+
+static inline void
+nilfs_get_segment_range(struct the_nilfs *nilfs, __u64 segnum,
+			sector_t *seg_start, sector_t *seg_end)
+{
+	*seg_start = (sector_t)nilfs->ns_blocks_per_segment * segnum;
+	*seg_end = *seg_start + nilfs->ns_blocks_per_segment - 1;
+	if (segnum == 0)
+		*seg_start = nilfs->ns_first_data_block;
+}
+
+static inline sector_t
+nilfs_get_segment_start_blocknr(struct the_nilfs *nilfs, __u64 segnum)
+{
+	return (segnum == 0) ? nilfs->ns_first_data_block :
+		(sector_t)nilfs->ns_blocks_per_segment * segnum;
+}
+
+static inline __u64
+nilfs_get_segnum_of_block(struct the_nilfs *nilfs, sector_t blocknr)
+{
+	sector_t segnum = blocknr;
+
+	sector_div(segnum, nilfs->ns_blocks_per_segment);
+	return segnum;
+}
+
+static inline void
+nilfs_terminate_segment(struct the_nilfs *nilfs, sector_t seg_start,
+			sector_t seg_end)
+{
+	/* terminate the current full segment (used in case of I/O-error) */
+	nilfs->ns_pseg_offset = seg_end - seg_start + 1;
+}
+
+static inline void nilfs_shift_to_next_segment(struct the_nilfs *nilfs)
+{
+	/* move forward with a full segment */
+	nilfs->ns_segnum = nilfs->ns_nextnum;
+	nilfs->ns_pseg_offset = 0;
+	nilfs->ns_seg_seq++;
+}
+
+static inline __u64 nilfs_last_cno(struct the_nilfs *nilfs)
+{
+	__u64 cno;
+
+	spin_lock(&nilfs->ns_last_segment_lock);
+	cno = nilfs->ns_last_cno;
+	spin_unlock(&nilfs->ns_last_segment_lock);
+	return cno;
+}
+
+#endif /* _THE_NILFS_H */
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch

