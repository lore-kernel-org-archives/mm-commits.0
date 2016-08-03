From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately.patch
 removed from -mm tree
Date: Wed, 03 Aug 2016 11:13:18 -0700
Message-ID: <57a2343e.6V5yWpoDVRxFRi9g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33344 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757964AbcHCSNt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: move ioctl interface and disk layout to uapi separately
has been removed from the -mm tree.  Its filename was
     nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: move ioctl interface and disk layout to uapi separately

The header file "include/linux/nilfs2_fs.h" is composed of parts for
ioctl and disk format, and both are intended to be shared with user
space programs.

This moves them to the uapi directory "include/uapi/linux" splitting
the file to "nilfs2_api.h" and "nilfs2_ondisk.h".  The following minor
changes are accompanied by this migration:

 - nilfs_direct_node struct in nilfs2/direct.h is converged to
   nilfs2_ondisk.h because it's an on-disk structure.
 - inline functions nilfs_rec_len_from_disk() and
   nilfs_rec_len_to_disk() are moved to nilfs2/dir.c.

Link: http://lkml.kernel.org/r/1465825507-3407-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/nilfs2.txt |    3 
 Documentation/ioctl/ioctl-number.txt |    2 
 MAINTAINERS                          |    3 
 fs/nilfs2/bmap.h                     |    2 
 fs/nilfs2/btree.h                    |    2 
 fs/nilfs2/cpfile.c                   |    1 
 fs/nilfs2/cpfile.h                   |    3 
 fs/nilfs2/dat.h                      |    1 
 fs/nilfs2/dir.c                      |   22 
 fs/nilfs2/direct.h                   |   10 
 fs/nilfs2/ifile.h                    |    1 
 fs/nilfs2/ioctl.c                    |    1 
 fs/nilfs2/nilfs.h                    |    3 
 fs/nilfs2/segment.h                  |    1 
 fs/nilfs2/sufile.c                   |    1 
 fs/nilfs2/sufile.h                   |    1 
 include/linux/nilfs2_fs.h            |  934 -------------------------
 include/uapi/linux/nilfs2_api.h      |  292 +++++++
 include/uapi/linux/nilfs2_ondisk.h   |  650 +++++++++++++++++
 19 files changed, 976 insertions(+), 957 deletions(-)

diff -puN Documentation/filesystems/nilfs2.txt~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately Documentation/filesystems/nilfs2.txt
--- a/Documentation/filesystems/nilfs2.txt~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately
+++ a/Documentation/filesystems/nilfs2.txt
@@ -267,7 +267,8 @@ among NILFS2 files can be depicted as fo
                                   `-- file (ino=yy)
                                     ( regular file, directory, or symlink )
 
-For detail on the format of each file, please see include/linux/nilfs2_fs.h.
+For detail on the format of each file, please see nilfs2_ondisk.h
+located at include/uapi/linux directory.
 
 There are no patents or other intellectual property that we protect
 with regard to the design of NILFS2.  It is allowed to replicate the
diff -puN Documentation/ioctl/ioctl-number.txt~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately Documentation/ioctl/ioctl-number.txt
--- a/Documentation/ioctl/ioctl-number.txt~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately
+++ a/Documentation/ioctl/ioctl-number.txt
@@ -248,7 +248,7 @@ Code  Seq#(hex)	Include File		Comments
 'm'	00	drivers/scsi/megaraid/megaraid_ioctl.h	conflict!
 'm'	00-1F	net/irda/irmod.h	conflict!
 'n'	00-7F	linux/ncp_fs.h and fs/ncpfs/ioctl.c
-'n'	80-8F	linux/nilfs2_fs.h	NILFS2
+'n'	80-8F	uapi/linux/nilfs2_api.h	NILFS2
 'n'	E0-FF	linux/matroxfb.h	matroxfb
 'o'	00-1F	fs/ocfs2/ocfs2_fs.h	OCFS2
 'o'     00-03   mtd/ubi-user.h		conflict! (OCFS2 and UBI overlaps)
diff -puN MAINTAINERS~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately MAINTAINERS
--- a/MAINTAINERS~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately
+++ a/MAINTAINERS
@@ -8258,8 +8258,9 @@ T:	git git://github.com/konis/nilfs2.git
 S:	Supported
 F:	Documentation/filesystems/nilfs2.txt
 F:	fs/nilfs2/
-F:	include/linux/nilfs2_fs.h
 F:	include/trace/events/nilfs2.h
+F:	include/uapi/linux/nilfs2_api.h
+F:	include/uapi/linux/nilfs2_ondisk.h
 
 NINJA SCSI-3 / NINJA SCSI-32Bi (16bit/CardBus) PCMCIA SCSI HOST ADAPTER DRIVER
 M:	YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
diff -puN fs/nilfs2/bmap.h~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately fs/nilfs2/bmap.h
--- a/fs/nilfs2/bmap.h~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately
+++ a/fs/nilfs2/bmap.h
@@ -22,7 +22,7 @@
 #include <linux/types.h>
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
-#include <linux/nilfs2_fs.h>
+#include <linux/nilfs2_ondisk.h>	/* nilfs_binfo, nilfs_inode, etc */
 #include "alloc.h"
 #include "dat.h"
 
diff -puN fs/nilfs2/btree.h~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately fs/nilfs2/btree.h
--- a/fs/nilfs2/btree.h~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately
+++ a/fs/nilfs2/btree.h
@@ -22,7 +22,7 @@
 #include <linux/types.h>
 #include <linux/buffer_head.h>
 #include <linux/list.h>
-#include <linux/nilfs2_fs.h>
+#include <linux/nilfs2_ondisk.h>	/* nilfs_btree_node */
 #include "btnode.h"
 #include "bmap.h"
 
diff -puN fs/nilfs2/cpfile.c~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately fs/nilfs2/cpfile.c
--- a/fs/nilfs2/cpfile.c~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately
+++ a/fs/nilfs2/cpfile.c
@@ -21,7 +21,6 @@
 #include <linux/string.h>
 #include <linux/buffer_head.h>
 #include <linux/errno.h>
-#include <linux/nilfs2_fs.h>
 #include "mdt.h"
 #include "cpfile.h"
 
diff -puN fs/nilfs2/cpfile.h~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately fs/nilfs2/cpfile.h
--- a/fs/nilfs2/cpfile.h~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately
+++ a/fs/nilfs2/cpfile.h
@@ -21,7 +21,8 @@
 
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
-#include <linux/nilfs2_fs.h>
+#include <linux/nilfs2_api.h>		/* nilfs_cpstat */
+#include <linux/nilfs2_ondisk.h>	/* nilfs_inode, nilfs_checkpoint */
 
 
 int nilfs_cpfile_get_checkpoint(struct inode *, __u64, int,
diff -puN fs/nilfs2/dat.h~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately fs/nilfs2/dat.h
--- a/fs/nilfs2/dat.h~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately
+++ a/fs/nilfs2/dat.h
@@ -22,6 +22,7 @@
 #include <linux/types.h>
 #include <linux/buffer_head.h>
 #include <linux/fs.h>
+#include <linux/nilfs2_ondisk.h>	/* nilfs_inode, nilfs_checkpoint */
 
 
 struct nilfs_palloc_req;
diff -puN fs/nilfs2/dir.c~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately fs/nilfs2/dir.c
--- a/fs/nilfs2/dir.c~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately
+++ a/fs/nilfs2/dir.c
@@ -42,6 +42,28 @@
 #include "nilfs.h"
 #include "page.h"
 
+static inline unsigned int nilfs_rec_len_from_disk(__le16 dlen)
+{
+	unsigned int len = le16_to_cpu(dlen);
+
+#if (PAGE_SIZE >= 65536)
+	if (len == NILFS_MAX_REC_LEN)
+		return 1 << 16;
+#endif
+	return len;
+}
+
+static inline __le16 nilfs_rec_len_to_disk(unsigned int len)
+{
+#if (PAGE_SIZE >= 65536)
+	if (len == (1 << 16))
+		return cpu_to_le16(NILFS_MAX_REC_LEN);
+
+	BUG_ON(len > (1 << 16));
+#endif
+	return cpu_to_le16(len);
+}
+
 /*
  * nilfs uses block-sized chunks. Arguably, sector-sized ones would be
  * more robust, but we have what we have
diff -puN fs/nilfs2/direct.h~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately fs/nilfs2/direct.h
--- a/fs/nilfs2/direct.h~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately
+++ a/fs/nilfs2/direct.h
@@ -24,16 +24,6 @@
 #include "bmap.h"
 
 
-/**
- * struct nilfs_direct_node - direct node
- * @dn_flags: flags
- * @dn_pad: padding
- */
-struct nilfs_direct_node {
-	__u8 dn_flags;
-	__u8 pad[7];
-};
-
 #define NILFS_DIRECT_NBLOCKS	(NILFS_BMAP_SIZE / sizeof(__le64) - 1)
 #define NILFS_DIRECT_KEY_MIN	0
 #define NILFS_DIRECT_KEY_MAX	(NILFS_DIRECT_NBLOCKS - 1)
diff -puN fs/nilfs2/ifile.h~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately fs/nilfs2/ifile.h
--- a/fs/nilfs2/ifile.h~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately
+++ a/fs/nilfs2/ifile.h
@@ -23,7 +23,6 @@
 
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
-#include <linux/nilfs2_fs.h>
 #include "mdt.h"
 #include "alloc.h"
 
diff -puN fs/nilfs2/ioctl.c~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately
+++ a/fs/nilfs2/ioctl.c
@@ -25,7 +25,6 @@
 #include <linux/compat.h>	/* compat_ptr() */
 #include <linux/mount.h>	/* mnt_want_write_file(), mnt_drop_write_file() */
 #include <linux/buffer_head.h>
-#include <linux/nilfs2_fs.h>
 #include "nilfs.h"
 #include "segment.h"
 #include "bmap.h"
diff -puN fs/nilfs2/nilfs.h~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately
+++ a/fs/nilfs2/nilfs.h
@@ -23,7 +23,8 @@
 #include <linux/buffer_head.h>
 #include <linux/spinlock.h>
 #include <linux/blkdev.h>
-#include <linux/nilfs2_fs.h>
+#include <linux/nilfs2_api.h>
+#include <linux/nilfs2_ondisk.h>
 #include "the_nilfs.h"
 #include "bmap.h"
 
diff -puN fs/nilfs2/segment.h~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately fs/nilfs2/segment.h
--- a/fs/nilfs2/segment.h~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately
+++ a/fs/nilfs2/segment.h
@@ -23,7 +23,6 @@
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
 #include <linux/workqueue.h>
-#include <linux/nilfs2_fs.h>
 #include "nilfs.h"
 
 struct nilfs_root;
diff -puN fs/nilfs2/sufile.c~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately fs/nilfs2/sufile.c
--- a/fs/nilfs2/sufile.c~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately
+++ a/fs/nilfs2/sufile.c
@@ -22,7 +22,6 @@
 #include <linux/string.h>
 #include <linux/buffer_head.h>
 #include <linux/errno.h>
-#include <linux/nilfs2_fs.h>
 #include "mdt.h"
 #include "sufile.h"
 
diff -puN fs/nilfs2/sufile.h~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately fs/nilfs2/sufile.h
--- a/fs/nilfs2/sufile.h~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately
+++ a/fs/nilfs2/sufile.h
@@ -21,7 +21,6 @@
 
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
-#include <linux/nilfs2_fs.h>
 #include "mdt.h"
 
 
diff -puN include/linux/nilfs2_fs.h~nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately /dev/null
--- a/include/linux/nilfs2_fs.h
+++ /dev/null
@@ -1,934 +0,0 @@
-/*
- * nilfs2_fs.h - NILFS2 on-disk structures and common declarations.
- *
- * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU Lesser General Public License as published
- * by the Free Software Foundation; either version 2.1 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU Lesser General Public License for more details.
- *
- * Written by Koji Sato and Ryusuke Konishi.
- */
-/*
- *  linux/include/linux/ext2_fs.h
- *
- * Copyright (C) 1992, 1993, 1994, 1995
- * Remy Card (card@masi.ibp.fr)
- * Laboratoire MASI - Institut Blaise Pascal
- * Universite Pierre et Marie Curie (Paris VI)
- *
- *  from
- *
- *  linux/include/linux/minix_fs.h
- *
- *  Copyright (C) 1991, 1992  Linus Torvalds
- */
-
-#ifndef _LINUX_NILFS_FS_H
-#define _LINUX_NILFS_FS_H
-
-#include <linux/types.h>
-#include <linux/ioctl.h>
-#include <linux/magic.h>
-#include <linux/bug.h>
-
-
-#define NILFS_INODE_BMAP_SIZE	7
-/**
- * struct nilfs_inode - structure of an inode on disk
- * @i_blocks: blocks count
- * @i_size: size in bytes
- * @i_ctime: creation time (seconds)
- * @i_mtime: modification time (seconds)
- * @i_ctime_nsec: creation time (nano seconds)
- * @i_mtime_nsec: modification time (nano seconds)
- * @i_uid: user id
- * @i_gid: group id
- * @i_mode: file mode
- * @i_links_count: links count
- * @i_flags: file flags
- * @i_bmap: block mapping
- * @i_xattr: extended attributes
- * @i_generation: file generation (for NFS)
- * @i_pad:	padding
- */
-struct nilfs_inode {
-	__le64	i_blocks;
-	__le64	i_size;
-	__le64	i_ctime;
-	__le64	i_mtime;
-	__le32	i_ctime_nsec;
-	__le32	i_mtime_nsec;
-	__le32	i_uid;
-	__le32	i_gid;
-	__le16	i_mode;
-	__le16	i_links_count;
-	__le32	i_flags;
-	__le64	i_bmap[NILFS_INODE_BMAP_SIZE];
-#define i_device_code	i_bmap[0]
-	__le64	i_xattr;
-	__le32	i_generation;
-	__le32	i_pad;
-};
-
-#define NILFS_MIN_INODE_SIZE		128
-
-/**
- * struct nilfs_super_root - structure of super root
- * @sr_sum: check sum
- * @sr_bytes: byte count of the structure
- * @sr_flags: flags (reserved)
- * @sr_nongc_ctime: write time of the last segment not for cleaner operation
- * @sr_dat: DAT file inode
- * @sr_cpfile: checkpoint file inode
- * @sr_sufile: segment usage file inode
- */
-struct nilfs_super_root {
-	__le32 sr_sum;
-	__le16 sr_bytes;
-	__le16 sr_flags;
-	__le64 sr_nongc_ctime;
-	struct nilfs_inode sr_dat;
-	struct nilfs_inode sr_cpfile;
-	struct nilfs_inode sr_sufile;
-};
-
-#define NILFS_SR_MDT_OFFSET(inode_size, i)  \
-	((unsigned long)&((struct nilfs_super_root *)0)->sr_dat + \
-			(inode_size) * (i))
-#define NILFS_SR_DAT_OFFSET(inode_size)     NILFS_SR_MDT_OFFSET(inode_size, 0)
-#define NILFS_SR_CPFILE_OFFSET(inode_size)  NILFS_SR_MDT_OFFSET(inode_size, 1)
-#define NILFS_SR_SUFILE_OFFSET(inode_size)  NILFS_SR_MDT_OFFSET(inode_size, 2)
-#define NILFS_SR_BYTES(inode_size)	    NILFS_SR_MDT_OFFSET(inode_size, 3)
-
-/*
- * Maximal mount counts
- */
-#define NILFS_DFL_MAX_MNT_COUNT		50      /* 50 mounts */
-
-/*
- * File system states (sbp->s_state, nilfs->ns_mount_state)
- */
-#define NILFS_VALID_FS			0x0001  /* Unmounted cleanly */
-#define NILFS_ERROR_FS			0x0002  /* Errors detected */
-#define NILFS_RESIZE_FS			0x0004	/* Resize required */
-
-/*
- * Mount flags (sbi->s_mount_opt)
- */
-#define NILFS_MOUNT_ERROR_MODE		0x0070  /* Error mode mask */
-#define NILFS_MOUNT_ERRORS_CONT		0x0010  /* Continue on errors */
-#define NILFS_MOUNT_ERRORS_RO		0x0020  /* Remount fs ro on errors */
-#define NILFS_MOUNT_ERRORS_PANIC	0x0040  /* Panic on errors */
-#define NILFS_MOUNT_BARRIER		0x1000  /* Use block barriers */
-#define NILFS_MOUNT_STRICT_ORDER	0x2000  /*
-						 * Apply strict in-order
-						 * semantics also for data
-						 */
-#define NILFS_MOUNT_NORECOVERY		0x4000  /*
-						 * Disable write access during
-						 * mount-time recovery
-						 */
-#define NILFS_MOUNT_DISCARD		0x8000  /* Issue DISCARD requests */
-
-
-/**
- * struct nilfs_super_block - structure of super block on disk
- */
-struct nilfs_super_block {
-/*00*/	__le32	s_rev_level;		/* Revision level */
-	__le16	s_minor_rev_level;	/* minor revision level */
-	__le16	s_magic;		/* Magic signature */
-
-	__le16  s_bytes;		/*
-					 * Bytes count of CRC calculation
-					 * for this structure. s_reserved
-					 * is excluded.
-					 */
-	__le16  s_flags;		/* flags */
-	__le32  s_crc_seed;		/* Seed value of CRC calculation */
-/*10*/	__le32	s_sum;			/* Check sum of super block */
-
-	__le32	s_log_block_size;	/*
-					 * Block size represented as follows
-					 * blocksize =
-					 *     1 << (s_log_block_size + 10)
-					 */
-	__le64  s_nsegments;		/* Number of segments in filesystem */
-/*20*/	__le64  s_dev_size;		/* block device size in bytes */
-	__le64	s_first_data_block;	/* 1st seg disk block number */
-/*30*/	__le32  s_blocks_per_segment;   /* number of blocks per full segment */
-	__le32	s_r_segments_percentage; /* Reserved segments percentage */
-
-	__le64  s_last_cno;		/* Last checkpoint number */
-/*40*/	__le64  s_last_pseg;		/* disk block addr pseg written last */
-	__le64  s_last_seq;             /* seq. number of seg written last */
-/*50*/	__le64	s_free_blocks_count;	/* Free blocks count */
-
-	__le64	s_ctime;		/*
-					 * Creation time (execution time of
-					 * newfs)
-					 */
-/*60*/	__le64	s_mtime;		/* Mount time */
-	__le64	s_wtime;		/* Write time */
-/*70*/	__le16	s_mnt_count;		/* Mount count */
-	__le16	s_max_mnt_count;	/* Maximal mount count */
-	__le16	s_state;		/* File system state */
-	__le16	s_errors;		/* Behaviour when detecting errors */
-	__le64	s_lastcheck;		/* time of last check */
-
-/*80*/	__le32	s_checkinterval;	/* max. time between checks */
-	__le32	s_creator_os;		/* OS */
-	__le16	s_def_resuid;		/* Default uid for reserved blocks */
-	__le16	s_def_resgid;		/* Default gid for reserved blocks */
-	__le32	s_first_ino;		/* First non-reserved inode */
-
-/*90*/	__le16  s_inode_size;		/* Size of an inode */
-	__le16  s_dat_entry_size;       /* Size of a dat entry */
-	__le16  s_checkpoint_size;      /* Size of a checkpoint */
-	__le16	s_segment_usage_size;	/* Size of a segment usage */
-
-/*98*/	__u8	s_uuid[16];		/* 128-bit uuid for volume */
-/*A8*/	char	s_volume_name[80];	/* volume name */
-
-/*F8*/	__le32  s_c_interval;           /* Commit interval of segment */
-	__le32  s_c_block_max;          /*
-					 * Threshold of data amount for
-					 * the segment construction
-					 */
-/*100*/	__le64  s_feature_compat;	/* Compatible feature set */
-	__le64  s_feature_compat_ro;	/* Read-only compatible feature set */
-	__le64  s_feature_incompat;	/* Incompatible feature set */
-	__u32	s_reserved[186];	/* padding to the end of the block */
-};
-
-/*
- * Codes for operating systems
- */
-#define NILFS_OS_LINUX		0
-/* Codes from 1 to 4 are reserved to keep compatibility with ext2 creator-OS */
-
-/*
- * Revision levels
- */
-#define NILFS_CURRENT_REV	2	/* current major revision */
-#define NILFS_MINOR_REV		0	/* minor revision */
-#define NILFS_MIN_SUPP_REV	2	/* minimum supported revision */
-
-/*
- * Feature set definitions
- *
- * If there is a bit set in the incompatible feature set that the kernel
- * doesn't know about, it should refuse to mount the filesystem.
- */
-#define NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT	0x00000001ULL
-
-#define NILFS_FEATURE_COMPAT_SUPP	0ULL
-#define NILFS_FEATURE_COMPAT_RO_SUPP	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT
-#define NILFS_FEATURE_INCOMPAT_SUPP	0ULL
-
-/*
- * Bytes count of super_block for CRC-calculation
- */
-#define NILFS_SB_BYTES  \
-	((long)&((struct nilfs_super_block *)0)->s_reserved)
-
-/*
- * Special inode number
- */
-#define NILFS_ROOT_INO		2	/* Root file inode */
-#define NILFS_DAT_INO		3	/* DAT file */
-#define NILFS_CPFILE_INO	4	/* checkpoint file */
-#define NILFS_SUFILE_INO	5	/* segment usage file */
-#define NILFS_IFILE_INO		6	/* ifile */
-#define NILFS_ATIME_INO		7	/* Atime file (reserved) */
-#define NILFS_XATTR_INO		8	/* Xattribute file (reserved) */
-#define NILFS_SKETCH_INO	10	/* Sketch file */
-#define NILFS_USER_INO		11	/* Fisrt user's file inode number */
-
-#define NILFS_SB_OFFSET_BYTES	1024	/* byte offset of nilfs superblock */
-
-#define NILFS_SEG_MIN_BLOCKS	16	/*
-					 * Minimum number of blocks in
-					 * a full segment
-					 */
-#define NILFS_PSEG_MIN_BLOCKS	2	/*
-					 * Minimum number of blocks in
-					 * a partial segment
-					 */
-#define NILFS_MIN_NRSVSEGS	8	/*
-					 * Minimum number of reserved
-					 * segments
-					 */
-
-/*
- * We call DAT, cpfile, and sufile root metadata files.  Inodes of
- * these files are written in super root block instead of ifile, and
- * garbage collector doesn't keep any past versions of these files.
- */
-#define NILFS_ROOT_METADATA_FILE(ino) \
-	((ino) >= NILFS_DAT_INO && (ino) <= NILFS_SUFILE_INO)
-
-/*
- * bytes offset of secondary super block
- */
-#define NILFS_SB2_OFFSET_BYTES(devsize)	((((devsize) >> 12) - 1) << 12)
-
-/*
- * Maximal count of links to a file
- */
-#define NILFS_LINK_MAX		32000
-
-/*
- * Structure of a directory entry
- *  (Same as ext2)
- */
-
-#define NILFS_NAME_LEN 255
-
-/*
- * Block size limitations
- */
-#define NILFS_MIN_BLOCK_SIZE		1024
-#define NILFS_MAX_BLOCK_SIZE		65536
-
-/*
- * The new version of the directory entry.  Since V0 structures are
- * stored in intel byte order, and the name_len field could never be
- * bigger than 255 chars, it's safe to reclaim the extra byte for the
- * file_type field.
- */
-struct nilfs_dir_entry {
-	__le64	inode;			/* Inode number */
-	__le16	rec_len;		/* Directory entry length */
-	__u8	name_len;		/* Name length */
-	__u8	file_type;		/* Dir entry type (file, dir, etc) */
-	char	name[NILFS_NAME_LEN];	/* File name */
-	char    pad;
-};
-
-/*
- * NILFS directory file types.  Only the low 3 bits are used.  The
- * other bits are reserved for now.
- */
-enum {
-	NILFS_FT_UNKNOWN,
-	NILFS_FT_REG_FILE,
-	NILFS_FT_DIR,
-	NILFS_FT_CHRDEV,
-	NILFS_FT_BLKDEV,
-	NILFS_FT_FIFO,
-	NILFS_FT_SOCK,
-	NILFS_FT_SYMLINK,
-	NILFS_FT_MAX
-};
-
-/*
- * NILFS_DIR_PAD defines the directory entries boundaries
- *
- * NOTE: It must be a multiple of 8
- */
-#define NILFS_DIR_PAD			8
-#define NILFS_DIR_ROUND			(NILFS_DIR_PAD - 1)
-#define NILFS_DIR_REC_LEN(name_len)	(((name_len) + 12 + NILFS_DIR_ROUND) & \
-					~NILFS_DIR_ROUND)
-#define NILFS_MAX_REC_LEN		((1<<16)-1)
-
-static inline unsigned int nilfs_rec_len_from_disk(__le16 dlen)
-{
-	unsigned int len = le16_to_cpu(dlen);
-
-#if !defined(__KERNEL__) || (PAGE_SIZE >= 65536)
-	if (len == NILFS_MAX_REC_LEN)
-		return 1 << 16;
-#endif
-	return len;
-}
-
-static inline __le16 nilfs_rec_len_to_disk(unsigned int len)
-{
-#if !defined(__KERNEL__) || (PAGE_SIZE >= 65536)
-	if (len == (1 << 16))
-		return cpu_to_le16(NILFS_MAX_REC_LEN);
-	else if (len > (1 << 16))
-		BUG();
-#endif
-	return cpu_to_le16(len);
-}
-
-/**
- * struct nilfs_finfo - file information
- * @fi_ino: inode number
- * @fi_cno: checkpoint number
- * @fi_nblocks: number of blocks (including intermediate blocks)
- * @fi_ndatablk: number of file data blocks
- */
-struct nilfs_finfo {
-	__le64 fi_ino;
-	__le64 fi_cno;
-	__le32 fi_nblocks;
-	__le32 fi_ndatablk;
-	/* array of virtual block numbers */
-};
-
-/**
- * struct nilfs_binfo_v - information for the block to which a virtual block number is assigned
- * @bi_vblocknr: virtual block number
- * @bi_blkoff: block offset
- */
-struct nilfs_binfo_v {
-	__le64 bi_vblocknr;
-	__le64 bi_blkoff;
-};
-
-/**
- * struct nilfs_binfo_dat - information for the block which belongs to the DAT file
- * @bi_blkoff: block offset
- * @bi_level: level
- * @bi_pad: padding
- */
-struct nilfs_binfo_dat {
-	__le64 bi_blkoff;
-	__u8 bi_level;
-	__u8 bi_pad[7];
-};
-
-/**
- * union nilfs_binfo: block information
- * @bi_v: nilfs_binfo_v structure
- * @bi_dat: nilfs_binfo_dat structure
- */
-union nilfs_binfo {
-	struct nilfs_binfo_v bi_v;
-	struct nilfs_binfo_dat bi_dat;
-};
-
-/**
- * struct nilfs_segment_summary - segment summary header
- * @ss_datasum: checksum of data
- * @ss_sumsum: checksum of segment summary
- * @ss_magic: magic number
- * @ss_bytes: size of this structure in bytes
- * @ss_flags: flags
- * @ss_seq: sequence number
- * @ss_create: creation timestamp
- * @ss_next: next segment
- * @ss_nblocks: number of blocks
- * @ss_nfinfo: number of finfo structures
- * @ss_sumbytes: total size of segment summary in bytes
- * @ss_pad: padding
- * @ss_cno: checkpoint number
- */
-struct nilfs_segment_summary {
-	__le32 ss_datasum;
-	__le32 ss_sumsum;
-	__le32 ss_magic;
-	__le16 ss_bytes;
-	__le16 ss_flags;
-	__le64 ss_seq;
-	__le64 ss_create;
-	__le64 ss_next;
-	__le32 ss_nblocks;
-	__le32 ss_nfinfo;
-	__le32 ss_sumbytes;
-	__le32 ss_pad;
-	__le64 ss_cno;
-	/* array of finfo structures */
-};
-
-#define NILFS_SEGSUM_MAGIC	0x1eaffa11  /* segment summary magic number */
-
-/*
- * Segment summary flags
- */
-#define NILFS_SS_LOGBGN 0x0001  /* begins a logical segment */
-#define NILFS_SS_LOGEND 0x0002  /* ends a logical segment */
-#define NILFS_SS_SR     0x0004  /* has super root */
-#define NILFS_SS_SYNDT  0x0008  /* includes data only updates */
-#define NILFS_SS_GC     0x0010  /* segment written for cleaner operation */
-
-/**
- * struct nilfs_btree_node - B-tree node
- * @bn_flags: flags
- * @bn_level: level
- * @bn_nchildren: number of children
- * @bn_pad: padding
- */
-struct nilfs_btree_node {
-	__u8 bn_flags;
-	__u8 bn_level;
-	__le16 bn_nchildren;
-	__le32 bn_pad;
-};
-
-/* flags */
-#define NILFS_BTREE_NODE_ROOT   0x01
-
-/* level */
-#define NILFS_BTREE_LEVEL_DATA          0
-#define NILFS_BTREE_LEVEL_NODE_MIN      (NILFS_BTREE_LEVEL_DATA + 1)
-#define NILFS_BTREE_LEVEL_MAX           14	/* Max level (exclusive) */
-
-/**
- * struct nilfs_palloc_group_desc - block group descriptor
- * @pg_nfrees: number of free entries in block group
- */
-struct nilfs_palloc_group_desc {
-	__le32 pg_nfrees;
-};
-
-/**
- * struct nilfs_dat_entry - disk address translation entry
- * @de_blocknr: block number
- * @de_start: start checkpoint number
- * @de_end: end checkpoint number
- * @de_rsv: reserved for future use
- */
-struct nilfs_dat_entry {
-	__le64 de_blocknr;
-	__le64 de_start;
-	__le64 de_end;
-	__le64 de_rsv;
-};
-
-#define NILFS_MIN_DAT_ENTRY_SIZE	32
-
-/**
- * struct nilfs_snapshot_list - snapshot list
- * @ssl_next: next checkpoint number on snapshot list
- * @ssl_prev: previous checkpoint number on snapshot list
- */
-struct nilfs_snapshot_list {
-	__le64 ssl_next;
-	__le64 ssl_prev;
-};
-
-/**
- * struct nilfs_checkpoint - checkpoint structure
- * @cp_flags: flags
- * @cp_checkpoints_count: checkpoints count in a block
- * @cp_snapshot_list: snapshot list
- * @cp_cno: checkpoint number
- * @cp_create: creation timestamp
- * @cp_nblk_inc: number of blocks incremented by this checkpoint
- * @cp_inodes_count: inodes count
- * @cp_blocks_count: blocks count
- * @cp_ifile_inode: inode of ifile
- */
-struct nilfs_checkpoint {
-	__le32 cp_flags;
-	__le32 cp_checkpoints_count;
-	struct nilfs_snapshot_list cp_snapshot_list;
-	__le64 cp_cno;
-	__le64 cp_create;
-	__le64 cp_nblk_inc;
-	__le64 cp_inodes_count;
-	__le64 cp_blocks_count;
-
-	/*
-	 * Do not change the byte offset of ifile inode.
-	 * To keep the compatibility of the disk format,
-	 * additional fields should be added behind cp_ifile_inode.
-	 */
-	struct nilfs_inode cp_ifile_inode;
-};
-
-#define NILFS_MIN_CHECKPOINT_SIZE	(64 + NILFS_MIN_INODE_SIZE)
-
-/* checkpoint flags */
-enum {
-	NILFS_CHECKPOINT_SNAPSHOT,
-	NILFS_CHECKPOINT_INVALID,
-	NILFS_CHECKPOINT_SKETCH,
-	NILFS_CHECKPOINT_MINOR,
-};
-
-#define NILFS_CHECKPOINT_FNS(flag, name)				\
-static inline void							\
-nilfs_checkpoint_set_##name(struct nilfs_checkpoint *cp)		\
-{									\
-	cp->cp_flags = cpu_to_le32(le32_to_cpu(cp->cp_flags) |		\
-				   (1UL << NILFS_CHECKPOINT_##flag));	\
-}									\
-static inline void							\
-nilfs_checkpoint_clear_##name(struct nilfs_checkpoint *cp)		\
-{									\
-	cp->cp_flags = cpu_to_le32(le32_to_cpu(cp->cp_flags) &		\
-				   ~(1UL << NILFS_CHECKPOINT_##flag));	\
-}									\
-static inline int							\
-nilfs_checkpoint_##name(const struct nilfs_checkpoint *cp)		\
-{									\
-	return !!(le32_to_cpu(cp->cp_flags) &				\
-		  (1UL << NILFS_CHECKPOINT_##flag));			\
-}
-
-NILFS_CHECKPOINT_FNS(SNAPSHOT, snapshot)
-NILFS_CHECKPOINT_FNS(INVALID, invalid)
-NILFS_CHECKPOINT_FNS(MINOR, minor)
-
-/**
- * struct nilfs_cpinfo - checkpoint information
- * @ci_flags: flags
- * @ci_pad: padding
- * @ci_cno: checkpoint number
- * @ci_create: creation timestamp
- * @ci_nblk_inc: number of blocks incremented by this checkpoint
- * @ci_inodes_count: inodes count
- * @ci_blocks_count: blocks count
- * @ci_next: next checkpoint number in snapshot list
- */
-struct nilfs_cpinfo {
-	__u32 ci_flags;
-	__u32 ci_pad;
-	__u64 ci_cno;
-	__u64 ci_create;
-	__u64 ci_nblk_inc;
-	__u64 ci_inodes_count;
-	__u64 ci_blocks_count;
-	__u64 ci_next;
-};
-
-#define NILFS_CPINFO_FNS(flag, name)					\
-static inline int							\
-nilfs_cpinfo_##name(const struct nilfs_cpinfo *cpinfo)			\
-{									\
-	return !!(cpinfo->ci_flags & (1UL << NILFS_CHECKPOINT_##flag));	\
-}
-
-NILFS_CPINFO_FNS(SNAPSHOT, snapshot)
-NILFS_CPINFO_FNS(INVALID, invalid)
-NILFS_CPINFO_FNS(MINOR, minor)
-
-
-/**
- * struct nilfs_cpfile_header - checkpoint file header
- * @ch_ncheckpoints: number of checkpoints
- * @ch_nsnapshots: number of snapshots
- * @ch_snapshot_list: snapshot list
- */
-struct nilfs_cpfile_header {
-	__le64 ch_ncheckpoints;
-	__le64 ch_nsnapshots;
-	struct nilfs_snapshot_list ch_snapshot_list;
-};
-
-#define NILFS_CPFILE_FIRST_CHECKPOINT_OFFSET	\
-	((sizeof(struct nilfs_cpfile_header) +				\
-	  sizeof(struct nilfs_checkpoint) - 1) /			\
-			sizeof(struct nilfs_checkpoint))
-
-/**
- * struct nilfs_segment_usage - segment usage
- * @su_lastmod: last modified timestamp
- * @su_nblocks: number of blocks in segment
- * @su_flags: flags
- */
-struct nilfs_segment_usage {
-	__le64 su_lastmod;
-	__le32 su_nblocks;
-	__le32 su_flags;
-};
-
-#define NILFS_MIN_SEGMENT_USAGE_SIZE	16
-
-/* segment usage flag */
-enum {
-	NILFS_SEGMENT_USAGE_ACTIVE,
-	NILFS_SEGMENT_USAGE_DIRTY,
-	NILFS_SEGMENT_USAGE_ERROR,
-
-	/* ... */
-};
-
-#define NILFS_SEGMENT_USAGE_FNS(flag, name)				\
-static inline void							\
-nilfs_segment_usage_set_##name(struct nilfs_segment_usage *su)		\
-{									\
-	su->su_flags = cpu_to_le32(le32_to_cpu(su->su_flags) |		\
-				   (1UL << NILFS_SEGMENT_USAGE_##flag));\
-}									\
-static inline void							\
-nilfs_segment_usage_clear_##name(struct nilfs_segment_usage *su)	\
-{									\
-	su->su_flags =							\
-		cpu_to_le32(le32_to_cpu(su->su_flags) &			\
-			    ~(1UL << NILFS_SEGMENT_USAGE_##flag));      \
-}									\
-static inline int							\
-nilfs_segment_usage_##name(const struct nilfs_segment_usage *su)	\
-{									\
-	return !!(le32_to_cpu(su->su_flags) &				\
-		  (1UL << NILFS_SEGMENT_USAGE_##flag));			\
-}
-
-NILFS_SEGMENT_USAGE_FNS(ACTIVE, active)
-NILFS_SEGMENT_USAGE_FNS(DIRTY, dirty)
-NILFS_SEGMENT_USAGE_FNS(ERROR, error)
-
-static inline void
-nilfs_segment_usage_set_clean(struct nilfs_segment_usage *su)
-{
-	su->su_lastmod = cpu_to_le64(0);
-	su->su_nblocks = cpu_to_le32(0);
-	su->su_flags = cpu_to_le32(0);
-}
-
-static inline int
-nilfs_segment_usage_clean(const struct nilfs_segment_usage *su)
-{
-	return !le32_to_cpu(su->su_flags);
-}
-
-/**
- * struct nilfs_sufile_header - segment usage file header
- * @sh_ncleansegs: number of clean segments
- * @sh_ndirtysegs: number of dirty segments
- * @sh_last_alloc: last allocated segment number
- */
-struct nilfs_sufile_header {
-	__le64 sh_ncleansegs;
-	__le64 sh_ndirtysegs;
-	__le64 sh_last_alloc;
-	/* ... */
-};
-
-#define NILFS_SUFILE_FIRST_SEGMENT_USAGE_OFFSET	\
-	((sizeof(struct nilfs_sufile_header) +				\
-	  sizeof(struct nilfs_segment_usage) - 1) /			\
-			 sizeof(struct nilfs_segment_usage))
-
-/**
- * nilfs_suinfo - segment usage information
- * @sui_lastmod: timestamp of last modification
- * @sui_nblocks: number of written blocks in segment
- * @sui_flags: segment usage flags
- */
-struct nilfs_suinfo {
-	__u64 sui_lastmod;
-	__u32 sui_nblocks;
-	__u32 sui_flags;
-};
-
-#define NILFS_SUINFO_FNS(flag, name)					\
-static inline int							\
-nilfs_suinfo_##name(const struct nilfs_suinfo *si)			\
-{									\
-	return si->sui_flags & (1UL << NILFS_SEGMENT_USAGE_##flag);	\
-}
-
-NILFS_SUINFO_FNS(ACTIVE, active)
-NILFS_SUINFO_FNS(DIRTY, dirty)
-NILFS_SUINFO_FNS(ERROR, error)
-
-static inline int nilfs_suinfo_clean(const struct nilfs_suinfo *si)
-{
-	return !si->sui_flags;
-}
-
-/* ioctl */
-/**
- * nilfs_suinfo_update - segment usage information update
- * @sup_segnum: segment number
- * @sup_flags: flags for which fields are active in sup_sui
- * @sup_reserved: reserved necessary for alignment
- * @sup_sui: segment usage information
- */
-struct nilfs_suinfo_update {
-	__u64 sup_segnum;
-	__u32 sup_flags;
-	__u32 sup_reserved;
-	struct nilfs_suinfo sup_sui;
-};
-
-enum {
-	NILFS_SUINFO_UPDATE_LASTMOD,
-	NILFS_SUINFO_UPDATE_NBLOCKS,
-	NILFS_SUINFO_UPDATE_FLAGS,
-	__NR_NILFS_SUINFO_UPDATE_FIELDS,
-};
-
-#define NILFS_SUINFO_UPDATE_FNS(flag, name)				\
-static inline void							\
-nilfs_suinfo_update_set_##name(struct nilfs_suinfo_update *sup)		\
-{									\
-	sup->sup_flags |= 1UL << NILFS_SUINFO_UPDATE_##flag;		\
-}									\
-static inline void							\
-nilfs_suinfo_update_clear_##name(struct nilfs_suinfo_update *sup)	\
-{									\
-	sup->sup_flags &= ~(1UL << NILFS_SUINFO_UPDATE_##flag);		\
-}									\
-static inline int							\
-nilfs_suinfo_update_##name(const struct nilfs_suinfo_update *sup)	\
-{									\
-	return !!(sup->sup_flags & (1UL << NILFS_SUINFO_UPDATE_##flag));\
-}
-
-NILFS_SUINFO_UPDATE_FNS(LASTMOD, lastmod)
-NILFS_SUINFO_UPDATE_FNS(NBLOCKS, nblocks)
-NILFS_SUINFO_UPDATE_FNS(FLAGS, flags)
-
-enum {
-	NILFS_CHECKPOINT,
-	NILFS_SNAPSHOT,
-};
-
-/**
- * struct nilfs_cpmode - change checkpoint mode structure
- * @cm_cno: checkpoint number
- * @cm_mode: mode of checkpoint
- * @cm_pad: padding
- */
-struct nilfs_cpmode {
-	__u64 cm_cno;
-	__u32 cm_mode;
-	__u32 cm_pad;
-};
-
-/**
- * struct nilfs_argv - argument vector
- * @v_base: pointer on data array from userspace
- * @v_nmembs: number of members in data array
- * @v_size: size of data array in bytes
- * @v_flags: flags
- * @v_index: start number of target data items
- */
-struct nilfs_argv {
-	__u64 v_base;
-	__u32 v_nmembs;	/* number of members */
-	__u16 v_size;	/* size of members */
-	__u16 v_flags;
-	__u64 v_index;
-};
-
-/**
- * struct nilfs_period - period of checkpoint numbers
- * @p_start: start checkpoint number (inclusive)
- * @p_end: end checkpoint number (exclusive)
- */
-struct nilfs_period {
-	__u64 p_start;
-	__u64 p_end;
-};
-
-/**
- * struct nilfs_cpstat - checkpoint statistics
- * @cs_cno: checkpoint number
- * @cs_ncps: number of checkpoints
- * @cs_nsss: number of snapshots
- */
-struct nilfs_cpstat {
-	__u64 cs_cno;
-	__u64 cs_ncps;
-	__u64 cs_nsss;
-};
-
-/**
- * struct nilfs_sustat - segment usage statistics
- * @ss_nsegs: number of segments
- * @ss_ncleansegs: number of clean segments
- * @ss_ndirtysegs: number of dirty segments
- * @ss_ctime: creation time of the last segment
- * @ss_nongc_ctime: creation time of the last segment not for GC
- * @ss_prot_seq: least sequence number of segments which must not be reclaimed
- */
-struct nilfs_sustat {
-	__u64 ss_nsegs;
-	__u64 ss_ncleansegs;
-	__u64 ss_ndirtysegs;
-	__u64 ss_ctime;
-	__u64 ss_nongc_ctime;
-	__u64 ss_prot_seq;
-};
-
-/**
- * struct nilfs_vinfo - virtual block number information
- * @vi_vblocknr: virtual block number
- * @vi_start: start checkpoint number (inclusive)
- * @vi_end: end checkpoint number (exclusive)
- * @vi_blocknr: disk block number
- */
-struct nilfs_vinfo {
-	__u64 vi_vblocknr;
-	__u64 vi_start;
-	__u64 vi_end;
-	__u64 vi_blocknr;
-};
-
-/**
- * struct nilfs_vdesc - descriptor of virtual block number
- * @vd_ino: inode number
- * @vd_cno: checkpoint number
- * @vd_vblocknr: virtual block number
- * @vd_period: period of checkpoint numbers
- * @vd_blocknr: disk block number
- * @vd_offset: logical block offset inside a file
- * @vd_flags: flags (data or node block)
- * @vd_pad: padding
- */
-struct nilfs_vdesc {
-	__u64 vd_ino;
-	__u64 vd_cno;
-	__u64 vd_vblocknr;
-	struct nilfs_period vd_period;
-	__u64 vd_blocknr;
-	__u64 vd_offset;
-	__u32 vd_flags;
-	__u32 vd_pad;
-};
-
-/**
- * struct nilfs_bdesc - descriptor of disk block number
- * @bd_ino: inode number
- * @bd_oblocknr: disk block address (for skipping dead blocks)
- * @bd_blocknr: disk block address
- * @bd_offset: logical block offset inside a file
- * @bd_level: level in the b-tree organization
- * @bd_pad: padding
- */
-struct nilfs_bdesc {
-	__u64 bd_ino;
-	__u64 bd_oblocknr;
-	__u64 bd_blocknr;
-	__u64 bd_offset;
-	__u32 bd_level;
-	__u32 bd_pad;
-};
-
-#define NILFS_IOCTL_IDENT		'n'
-
-#define NILFS_IOCTL_CHANGE_CPMODE  \
-	_IOW(NILFS_IOCTL_IDENT, 0x80, struct nilfs_cpmode)
-#define NILFS_IOCTL_DELETE_CHECKPOINT  \
-	_IOW(NILFS_IOCTL_IDENT, 0x81, __u64)
-#define NILFS_IOCTL_GET_CPINFO  \
-	_IOR(NILFS_IOCTL_IDENT, 0x82, struct nilfs_argv)
-#define NILFS_IOCTL_GET_CPSTAT  \
-	_IOR(NILFS_IOCTL_IDENT, 0x83, struct nilfs_cpstat)
-#define NILFS_IOCTL_GET_SUINFO  \
-	_IOR(NILFS_IOCTL_IDENT, 0x84, struct nilfs_argv)
-#define NILFS_IOCTL_GET_SUSTAT  \
-	_IOR(NILFS_IOCTL_IDENT, 0x85, struct nilfs_sustat)
-#define NILFS_IOCTL_GET_VINFO  \
-	_IOWR(NILFS_IOCTL_IDENT, 0x86, struct nilfs_argv)
-#define NILFS_IOCTL_GET_BDESCS  \
-	_IOWR(NILFS_IOCTL_IDENT, 0x87, struct nilfs_argv)
-#define NILFS_IOCTL_CLEAN_SEGMENTS  \
-	_IOW(NILFS_IOCTL_IDENT, 0x88, struct nilfs_argv[5])
-#define NILFS_IOCTL_SYNC  \
-	_IOR(NILFS_IOCTL_IDENT, 0x8A, __u64)
-#define NILFS_IOCTL_RESIZE  \
-	_IOW(NILFS_IOCTL_IDENT, 0x8B, __u64)
-#define NILFS_IOCTL_SET_ALLOC_RANGE  \
-	_IOW(NILFS_IOCTL_IDENT, 0x8C, __u64[2])
-#define NILFS_IOCTL_SET_SUINFO  \
-	_IOW(NILFS_IOCTL_IDENT, 0x8D, struct nilfs_argv)
-
-#endif	/* _LINUX_NILFS_FS_H */
diff -puN /dev/null include/uapi/linux/nilfs2_api.h
--- /dev/null
+++ a/include/uapi/linux/nilfs2_api.h
@@ -0,0 +1,292 @@
+/*
+ * nilfs2_api.h - NILFS2 user space API
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published
+ * by the Free Software Foundation; either version 2.1 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _LINUX_NILFS2_API_H
+#define _LINUX_NILFS2_API_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+/**
+ * struct nilfs_cpinfo - checkpoint information
+ * @ci_flags: flags
+ * @ci_pad: padding
+ * @ci_cno: checkpoint number
+ * @ci_create: creation timestamp
+ * @ci_nblk_inc: number of blocks incremented by this checkpoint
+ * @ci_inodes_count: inodes count
+ * @ci_blocks_count: blocks count
+ * @ci_next: next checkpoint number in snapshot list
+ */
+struct nilfs_cpinfo {
+	__u32 ci_flags;
+	__u32 ci_pad;
+	__u64 ci_cno;
+	__u64 ci_create;
+	__u64 ci_nblk_inc;
+	__u64 ci_inodes_count;
+	__u64 ci_blocks_count;
+	__u64 ci_next;
+};
+
+/* checkpoint flags */
+enum {
+	NILFS_CPINFO_SNAPSHOT,
+	NILFS_CPINFO_INVALID,
+	NILFS_CPINFO_SKETCH,
+	NILFS_CPINFO_MINOR,
+};
+
+#define NILFS_CPINFO_FNS(flag, name)					\
+static inline int							\
+nilfs_cpinfo_##name(const struct nilfs_cpinfo *cpinfo)			\
+{									\
+	return !!(cpinfo->ci_flags & (1UL << NILFS_CPINFO_##flag));	\
+}
+
+NILFS_CPINFO_FNS(SNAPSHOT, snapshot)
+NILFS_CPINFO_FNS(INVALID, invalid)
+NILFS_CPINFO_FNS(MINOR, minor)
+
+/**
+ * nilfs_suinfo - segment usage information
+ * @sui_lastmod: timestamp of last modification
+ * @sui_nblocks: number of written blocks in segment
+ * @sui_flags: segment usage flags
+ */
+struct nilfs_suinfo {
+	__u64 sui_lastmod;
+	__u32 sui_nblocks;
+	__u32 sui_flags;
+};
+
+/* segment usage flags */
+enum {
+	NILFS_SUINFO_ACTIVE,
+	NILFS_SUINFO_DIRTY,
+	NILFS_SUINFO_ERROR,
+};
+
+#define NILFS_SUINFO_FNS(flag, name)					\
+static inline int							\
+nilfs_suinfo_##name(const struct nilfs_suinfo *si)			\
+{									\
+	return si->sui_flags & (1UL << NILFS_SUINFO_##flag);		\
+}
+
+NILFS_SUINFO_FNS(ACTIVE, active)
+NILFS_SUINFO_FNS(DIRTY, dirty)
+NILFS_SUINFO_FNS(ERROR, error)
+
+static inline int nilfs_suinfo_clean(const struct nilfs_suinfo *si)
+{
+	return !si->sui_flags;
+}
+
+/**
+ * nilfs_suinfo_update - segment usage information update
+ * @sup_segnum: segment number
+ * @sup_flags: flags for which fields are active in sup_sui
+ * @sup_reserved: reserved necessary for alignment
+ * @sup_sui: segment usage information
+ */
+struct nilfs_suinfo_update {
+	__u64 sup_segnum;
+	__u32 sup_flags;
+	__u32 sup_reserved;
+	struct nilfs_suinfo sup_sui;
+};
+
+enum {
+	NILFS_SUINFO_UPDATE_LASTMOD,
+	NILFS_SUINFO_UPDATE_NBLOCKS,
+	NILFS_SUINFO_UPDATE_FLAGS,
+	__NR_NILFS_SUINFO_UPDATE_FIELDS,
+};
+
+#define NILFS_SUINFO_UPDATE_FNS(flag, name)				\
+static inline void							\
+nilfs_suinfo_update_set_##name(struct nilfs_suinfo_update *sup)		\
+{									\
+	sup->sup_flags |= 1UL << NILFS_SUINFO_UPDATE_##flag;		\
+}									\
+static inline void							\
+nilfs_suinfo_update_clear_##name(struct nilfs_suinfo_update *sup)	\
+{									\
+	sup->sup_flags &= ~(1UL << NILFS_SUINFO_UPDATE_##flag);		\
+}									\
+static inline int							\
+nilfs_suinfo_update_##name(const struct nilfs_suinfo_update *sup)	\
+{									\
+	return !!(sup->sup_flags & (1UL << NILFS_SUINFO_UPDATE_##flag));\
+}
+
+NILFS_SUINFO_UPDATE_FNS(LASTMOD, lastmod)
+NILFS_SUINFO_UPDATE_FNS(NBLOCKS, nblocks)
+NILFS_SUINFO_UPDATE_FNS(FLAGS, flags)
+
+enum {
+	NILFS_CHECKPOINT,
+	NILFS_SNAPSHOT,
+};
+
+/**
+ * struct nilfs_cpmode - change checkpoint mode structure
+ * @cm_cno: checkpoint number
+ * @cm_mode: mode of checkpoint
+ * @cm_pad: padding
+ */
+struct nilfs_cpmode {
+	__u64 cm_cno;
+	__u32 cm_mode;
+	__u32 cm_pad;
+};
+
+/**
+ * struct nilfs_argv - argument vector
+ * @v_base: pointer on data array from userspace
+ * @v_nmembs: number of members in data array
+ * @v_size: size of data array in bytes
+ * @v_flags: flags
+ * @v_index: start number of target data items
+ */
+struct nilfs_argv {
+	__u64 v_base;
+	__u32 v_nmembs;	/* number of members */
+	__u16 v_size;	/* size of members */
+	__u16 v_flags;
+	__u64 v_index;
+};
+
+/**
+ * struct nilfs_period - period of checkpoint numbers
+ * @p_start: start checkpoint number (inclusive)
+ * @p_end: end checkpoint number (exclusive)
+ */
+struct nilfs_period {
+	__u64 p_start;
+	__u64 p_end;
+};
+
+/**
+ * struct nilfs_cpstat - checkpoint statistics
+ * @cs_cno: checkpoint number
+ * @cs_ncps: number of checkpoints
+ * @cs_nsss: number of snapshots
+ */
+struct nilfs_cpstat {
+	__u64 cs_cno;
+	__u64 cs_ncps;
+	__u64 cs_nsss;
+};
+
+/**
+ * struct nilfs_sustat - segment usage statistics
+ * @ss_nsegs: number of segments
+ * @ss_ncleansegs: number of clean segments
+ * @ss_ndirtysegs: number of dirty segments
+ * @ss_ctime: creation time of the last segment
+ * @ss_nongc_ctime: creation time of the last segment not for GC
+ * @ss_prot_seq: least sequence number of segments which must not be reclaimed
+ */
+struct nilfs_sustat {
+	__u64 ss_nsegs;
+	__u64 ss_ncleansegs;
+	__u64 ss_ndirtysegs;
+	__u64 ss_ctime;
+	__u64 ss_nongc_ctime;
+	__u64 ss_prot_seq;
+};
+
+/**
+ * struct nilfs_vinfo - virtual block number information
+ * @vi_vblocknr: virtual block number
+ * @vi_start: start checkpoint number (inclusive)
+ * @vi_end: end checkpoint number (exclusive)
+ * @vi_blocknr: disk block number
+ */
+struct nilfs_vinfo {
+	__u64 vi_vblocknr;
+	__u64 vi_start;
+	__u64 vi_end;
+	__u64 vi_blocknr;
+};
+
+/**
+ * struct nilfs_vdesc - descriptor of virtual block number
+ * @vd_ino: inode number
+ * @vd_cno: checkpoint number
+ * @vd_vblocknr: virtual block number
+ * @vd_period: period of checkpoint numbers
+ * @vd_blocknr: disk block number
+ * @vd_offset: logical block offset inside a file
+ * @vd_flags: flags (data or node block)
+ * @vd_pad: padding
+ */
+struct nilfs_vdesc {
+	__u64 vd_ino;
+	__u64 vd_cno;
+	__u64 vd_vblocknr;
+	struct nilfs_period vd_period;
+	__u64 vd_blocknr;
+	__u64 vd_offset;
+	__u32 vd_flags;
+	__u32 vd_pad;
+};
+
+/**
+ * struct nilfs_bdesc - descriptor of disk block number
+ * @bd_ino: inode number
+ * @bd_oblocknr: disk block address (for skipping dead blocks)
+ * @bd_blocknr: disk block address
+ * @bd_offset: logical block offset inside a file
+ * @bd_level: level in the b-tree organization
+ * @bd_pad: padding
+ */
+struct nilfs_bdesc {
+	__u64 bd_ino;
+	__u64 bd_oblocknr;
+	__u64 bd_blocknr;
+	__u64 bd_offset;
+	__u32 bd_level;
+	__u32 bd_pad;
+};
+
+#define NILFS_IOCTL_IDENT	'n'
+
+#define NILFS_IOCTL_CHANGE_CPMODE					\
+	_IOW(NILFS_IOCTL_IDENT, 0x80, struct nilfs_cpmode)
+#define NILFS_IOCTL_DELETE_CHECKPOINT					\
+	_IOW(NILFS_IOCTL_IDENT, 0x81, __u64)
+#define NILFS_IOCTL_GET_CPINFO						\
+	_IOR(NILFS_IOCTL_IDENT, 0x82, struct nilfs_argv)
+#define NILFS_IOCTL_GET_CPSTAT						\
+	_IOR(NILFS_IOCTL_IDENT, 0x83, struct nilfs_cpstat)
+#define NILFS_IOCTL_GET_SUINFO						\
+	_IOR(NILFS_IOCTL_IDENT, 0x84, struct nilfs_argv)
+#define NILFS_IOCTL_GET_SUSTAT						\
+	_IOR(NILFS_IOCTL_IDENT, 0x85, struct nilfs_sustat)
+#define NILFS_IOCTL_GET_VINFO						\
+	_IOWR(NILFS_IOCTL_IDENT, 0x86, struct nilfs_argv)
+#define NILFS_IOCTL_GET_BDESCS						\
+	_IOWR(NILFS_IOCTL_IDENT, 0x87, struct nilfs_argv)
+#define NILFS_IOCTL_CLEAN_SEGMENTS					\
+	_IOW(NILFS_IOCTL_IDENT, 0x88, struct nilfs_argv[5])
+#define NILFS_IOCTL_SYNC						\
+	_IOR(NILFS_IOCTL_IDENT, 0x8A, __u64)
+#define NILFS_IOCTL_RESIZE						\
+	_IOW(NILFS_IOCTL_IDENT, 0x8B, __u64)
+#define NILFS_IOCTL_SET_ALLOC_RANGE					\
+	_IOW(NILFS_IOCTL_IDENT, 0x8C, __u64[2])
+#define NILFS_IOCTL_SET_SUINFO						\
+	_IOW(NILFS_IOCTL_IDENT, 0x8D, struct nilfs_argv)
+
+#endif /* _LINUX_NILFS2_API_H */
diff -puN /dev/null include/uapi/linux/nilfs2_ondisk.h
--- /dev/null
+++ a/include/uapi/linux/nilfs2_ondisk.h
@@ -0,0 +1,650 @@
+/*
+ * nilfs2_ondisk.h - NILFS2 on-disk structures
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published
+ * by the Free Software Foundation; either version 2.1 of the License, or
+ * (at your option) any later version.
+ */
+/*
+ *  linux/include/linux/ext2_fs.h
+ *
+ * Copyright (C) 1992, 1993, 1994, 1995
+ * Remy Card (card@masi.ibp.fr)
+ * Laboratoire MASI - Institut Blaise Pascal
+ * Universite Pierre et Marie Curie (Paris VI)
+ *
+ *  from
+ *
+ *  linux/include/linux/minix_fs.h
+ *
+ *  Copyright (C) 1991, 1992  Linus Torvalds
+ */
+
+#ifndef _LINUX_NILFS2_ONDISK_H
+#define _LINUX_NILFS2_ONDISK_H
+
+#include <linux/types.h>
+#include <linux/magic.h>
+
+
+#define NILFS_INODE_BMAP_SIZE	7
+
+/**
+ * struct nilfs_inode - structure of an inode on disk
+ * @i_blocks: blocks count
+ * @i_size: size in bytes
+ * @i_ctime: creation time (seconds)
+ * @i_mtime: modification time (seconds)
+ * @i_ctime_nsec: creation time (nano seconds)
+ * @i_mtime_nsec: modification time (nano seconds)
+ * @i_uid: user id
+ * @i_gid: group id
+ * @i_mode: file mode
+ * @i_links_count: links count
+ * @i_flags: file flags
+ * @i_bmap: block mapping
+ * @i_xattr: extended attributes
+ * @i_generation: file generation (for NFS)
+ * @i_pad: padding
+ */
+struct nilfs_inode {
+	__le64	i_blocks;
+	__le64	i_size;
+	__le64	i_ctime;
+	__le64	i_mtime;
+	__le32	i_ctime_nsec;
+	__le32	i_mtime_nsec;
+	__le32	i_uid;
+	__le32	i_gid;
+	__le16	i_mode;
+	__le16	i_links_count;
+	__le32	i_flags;
+	__le64	i_bmap[NILFS_INODE_BMAP_SIZE];
+#define i_device_code	i_bmap[0]
+	__le64	i_xattr;
+	__le32	i_generation;
+	__le32	i_pad;
+};
+
+#define NILFS_MIN_INODE_SIZE		128
+
+/**
+ * struct nilfs_super_root - structure of super root
+ * @sr_sum: check sum
+ * @sr_bytes: byte count of the structure
+ * @sr_flags: flags (reserved)
+ * @sr_nongc_ctime: write time of the last segment not for cleaner operation
+ * @sr_dat: DAT file inode
+ * @sr_cpfile: checkpoint file inode
+ * @sr_sufile: segment usage file inode
+ */
+struct nilfs_super_root {
+	__le32 sr_sum;
+	__le16 sr_bytes;
+	__le16 sr_flags;
+	__le64 sr_nongc_ctime;
+	struct nilfs_inode sr_dat;
+	struct nilfs_inode sr_cpfile;
+	struct nilfs_inode sr_sufile;
+};
+
+#define NILFS_SR_MDT_OFFSET(inode_size, i)  \
+	((unsigned long)&((struct nilfs_super_root *)0)->sr_dat + \
+			(inode_size) * (i))
+#define NILFS_SR_DAT_OFFSET(inode_size)     NILFS_SR_MDT_OFFSET(inode_size, 0)
+#define NILFS_SR_CPFILE_OFFSET(inode_size)  NILFS_SR_MDT_OFFSET(inode_size, 1)
+#define NILFS_SR_SUFILE_OFFSET(inode_size)  NILFS_SR_MDT_OFFSET(inode_size, 2)
+#define NILFS_SR_BYTES(inode_size)	    NILFS_SR_MDT_OFFSET(inode_size, 3)
+
+/*
+ * Maximal mount counts
+ */
+#define NILFS_DFL_MAX_MNT_COUNT		50      /* 50 mounts */
+
+/*
+ * File system states (sbp->s_state, nilfs->ns_mount_state)
+ */
+#define NILFS_VALID_FS			0x0001  /* Unmounted cleanly */
+#define NILFS_ERROR_FS			0x0002  /* Errors detected */
+#define NILFS_RESIZE_FS			0x0004	/* Resize required */
+
+/*
+ * Mount flags (sbi->s_mount_opt)
+ */
+#define NILFS_MOUNT_ERROR_MODE		0x0070  /* Error mode mask */
+#define NILFS_MOUNT_ERRORS_CONT		0x0010  /* Continue on errors */
+#define NILFS_MOUNT_ERRORS_RO		0x0020  /* Remount fs ro on errors */
+#define NILFS_MOUNT_ERRORS_PANIC	0x0040  /* Panic on errors */
+#define NILFS_MOUNT_BARRIER		0x1000  /* Use block barriers */
+#define NILFS_MOUNT_STRICT_ORDER	0x2000  /*
+						 * Apply strict in-order
+						 * semantics also for data
+						 */
+#define NILFS_MOUNT_NORECOVERY		0x4000  /*
+						 * Disable write access during
+						 * mount-time recovery
+						 */
+#define NILFS_MOUNT_DISCARD		0x8000  /* Issue DISCARD requests */
+
+
+/**
+ * struct nilfs_super_block - structure of super block on disk
+ */
+struct nilfs_super_block {
+/*00*/	__le32	s_rev_level;		/* Revision level */
+	__le16	s_minor_rev_level;	/* minor revision level */
+	__le16	s_magic;		/* Magic signature */
+
+	__le16  s_bytes;		/*
+					 * Bytes count of CRC calculation
+					 * for this structure. s_reserved
+					 * is excluded.
+					 */
+	__le16  s_flags;		/* flags */
+	__le32  s_crc_seed;		/* Seed value of CRC calculation */
+/*10*/	__le32	s_sum;			/* Check sum of super block */
+
+	__le32	s_log_block_size;	/*
+					 * Block size represented as follows
+					 * blocksize =
+					 *     1 << (s_log_block_size + 10)
+					 */
+	__le64  s_nsegments;		/* Number of segments in filesystem */
+/*20*/	__le64  s_dev_size;		/* block device size in bytes */
+	__le64	s_first_data_block;	/* 1st seg disk block number */
+/*30*/	__le32  s_blocks_per_segment;   /* number of blocks per full segment */
+	__le32	s_r_segments_percentage; /* Reserved segments percentage */
+
+	__le64  s_last_cno;		/* Last checkpoint number */
+/*40*/	__le64  s_last_pseg;		/* disk block addr pseg written last */
+	__le64  s_last_seq;             /* seq. number of seg written last */
+/*50*/	__le64	s_free_blocks_count;	/* Free blocks count */
+
+	__le64	s_ctime;		/*
+					 * Creation time (execution time of
+					 * newfs)
+					 */
+/*60*/	__le64	s_mtime;		/* Mount time */
+	__le64	s_wtime;		/* Write time */
+/*70*/	__le16	s_mnt_count;		/* Mount count */
+	__le16	s_max_mnt_count;	/* Maximal mount count */
+	__le16	s_state;		/* File system state */
+	__le16	s_errors;		/* Behaviour when detecting errors */
+	__le64	s_lastcheck;		/* time of last check */
+
+/*80*/	__le32	s_checkinterval;	/* max. time between checks */
+	__le32	s_creator_os;		/* OS */
+	__le16	s_def_resuid;		/* Default uid for reserved blocks */
+	__le16	s_def_resgid;		/* Default gid for reserved blocks */
+	__le32	s_first_ino;		/* First non-reserved inode */
+
+/*90*/	__le16  s_inode_size;		/* Size of an inode */
+	__le16  s_dat_entry_size;       /* Size of a dat entry */
+	__le16  s_checkpoint_size;      /* Size of a checkpoint */
+	__le16	s_segment_usage_size;	/* Size of a segment usage */
+
+/*98*/	__u8	s_uuid[16];		/* 128-bit uuid for volume */
+/*A8*/	char	s_volume_name[80];	/* volume name */
+
+/*F8*/	__le32  s_c_interval;           /* Commit interval of segment */
+	__le32  s_c_block_max;          /*
+					 * Threshold of data amount for
+					 * the segment construction
+					 */
+/*100*/	__le64  s_feature_compat;	/* Compatible feature set */
+	__le64  s_feature_compat_ro;	/* Read-only compatible feature set */
+	__le64  s_feature_incompat;	/* Incompatible feature set */
+	__u32	s_reserved[186];	/* padding to the end of the block */
+};
+
+/*
+ * Codes for operating systems
+ */
+#define NILFS_OS_LINUX		0
+/* Codes from 1 to 4 are reserved to keep compatibility with ext2 creator-OS */
+
+/*
+ * Revision levels
+ */
+#define NILFS_CURRENT_REV	2	/* current major revision */
+#define NILFS_MINOR_REV		0	/* minor revision */
+#define NILFS_MIN_SUPP_REV	2	/* minimum supported revision */
+
+/*
+ * Feature set definitions
+ *
+ * If there is a bit set in the incompatible feature set that the kernel
+ * doesn't know about, it should refuse to mount the filesystem.
+ */
+#define NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT	0x00000001ULL
+
+#define NILFS_FEATURE_COMPAT_SUPP	0ULL
+#define NILFS_FEATURE_COMPAT_RO_SUPP	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT
+#define NILFS_FEATURE_INCOMPAT_SUPP	0ULL
+
+/*
+ * Bytes count of super_block for CRC-calculation
+ */
+#define NILFS_SB_BYTES  \
+	((long)&((struct nilfs_super_block *)0)->s_reserved)
+
+/*
+ * Special inode number
+ */
+#define NILFS_ROOT_INO		2	/* Root file inode */
+#define NILFS_DAT_INO		3	/* DAT file */
+#define NILFS_CPFILE_INO	4	/* checkpoint file */
+#define NILFS_SUFILE_INO	5	/* segment usage file */
+#define NILFS_IFILE_INO		6	/* ifile */
+#define NILFS_ATIME_INO		7	/* Atime file (reserved) */
+#define NILFS_XATTR_INO		8	/* Xattribute file (reserved) */
+#define NILFS_SKETCH_INO	10	/* Sketch file */
+#define NILFS_USER_INO		11	/* Fisrt user's file inode number */
+
+#define NILFS_SB_OFFSET_BYTES	1024	/* byte offset of nilfs superblock */
+
+#define NILFS_SEG_MIN_BLOCKS	16	/*
+					 * Minimum number of blocks in
+					 * a full segment
+					 */
+#define NILFS_PSEG_MIN_BLOCKS	2	/*
+					 * Minimum number of blocks in
+					 * a partial segment
+					 */
+#define NILFS_MIN_NRSVSEGS	8	/*
+					 * Minimum number of reserved
+					 * segments
+					 */
+
+/*
+ * We call DAT, cpfile, and sufile root metadata files.  Inodes of
+ * these files are written in super root block instead of ifile, and
+ * garbage collector doesn't keep any past versions of these files.
+ */
+#define NILFS_ROOT_METADATA_FILE(ino) \
+	((ino) >= NILFS_DAT_INO && (ino) <= NILFS_SUFILE_INO)
+
+/*
+ * bytes offset of secondary super block
+ */
+#define NILFS_SB2_OFFSET_BYTES(devsize)	((((devsize) >> 12) - 1) << 12)
+
+/*
+ * Maximal count of links to a file
+ */
+#define NILFS_LINK_MAX		32000
+
+/*
+ * Structure of a directory entry
+ *  (Same as ext2)
+ */
+
+#define NILFS_NAME_LEN 255
+
+/*
+ * Block size limitations
+ */
+#define NILFS_MIN_BLOCK_SIZE		1024
+#define NILFS_MAX_BLOCK_SIZE		65536
+
+/*
+ * The new version of the directory entry.  Since V0 structures are
+ * stored in intel byte order, and the name_len field could never be
+ * bigger than 255 chars, it's safe to reclaim the extra byte for the
+ * file_type field.
+ */
+struct nilfs_dir_entry {
+	__le64	inode;			/* Inode number */
+	__le16	rec_len;		/* Directory entry length */
+	__u8	name_len;		/* Name length */
+	__u8	file_type;		/* Dir entry type (file, dir, etc) */
+	char	name[NILFS_NAME_LEN];	/* File name */
+	char    pad;
+};
+
+/*
+ * NILFS directory file types.  Only the low 3 bits are used.  The
+ * other bits are reserved for now.
+ */
+enum {
+	NILFS_FT_UNKNOWN,
+	NILFS_FT_REG_FILE,
+	NILFS_FT_DIR,
+	NILFS_FT_CHRDEV,
+	NILFS_FT_BLKDEV,
+	NILFS_FT_FIFO,
+	NILFS_FT_SOCK,
+	NILFS_FT_SYMLINK,
+	NILFS_FT_MAX
+};
+
+/*
+ * NILFS_DIR_PAD defines the directory entries boundaries
+ *
+ * NOTE: It must be a multiple of 8
+ */
+#define NILFS_DIR_PAD			8
+#define NILFS_DIR_ROUND			(NILFS_DIR_PAD - 1)
+#define NILFS_DIR_REC_LEN(name_len)	(((name_len) + 12 + NILFS_DIR_ROUND) & \
+					~NILFS_DIR_ROUND)
+#define NILFS_MAX_REC_LEN		((1 << 16) - 1)
+
+/**
+ * struct nilfs_finfo - file information
+ * @fi_ino: inode number
+ * @fi_cno: checkpoint number
+ * @fi_nblocks: number of blocks (including intermediate blocks)
+ * @fi_ndatablk: number of file data blocks
+ */
+struct nilfs_finfo {
+	__le64 fi_ino;
+	__le64 fi_cno;
+	__le32 fi_nblocks;
+	__le32 fi_ndatablk;
+};
+
+/**
+ * struct nilfs_binfo_v - information on a data block (except DAT)
+ * @bi_vblocknr: virtual block number
+ * @bi_blkoff: block offset
+ */
+struct nilfs_binfo_v {
+	__le64 bi_vblocknr;
+	__le64 bi_blkoff;
+};
+
+/**
+ * struct nilfs_binfo_dat - information on a DAT node block
+ * @bi_blkoff: block offset
+ * @bi_level: level
+ * @bi_pad: padding
+ */
+struct nilfs_binfo_dat {
+	__le64 bi_blkoff;
+	__u8 bi_level;
+	__u8 bi_pad[7];
+};
+
+/**
+ * union nilfs_binfo: block information
+ * @bi_v: nilfs_binfo_v structure
+ * @bi_dat: nilfs_binfo_dat structure
+ */
+union nilfs_binfo {
+	struct nilfs_binfo_v bi_v;
+	struct nilfs_binfo_dat bi_dat;
+};
+
+/**
+ * struct nilfs_segment_summary - segment summary header
+ * @ss_datasum: checksum of data
+ * @ss_sumsum: checksum of segment summary
+ * @ss_magic: magic number
+ * @ss_bytes: size of this structure in bytes
+ * @ss_flags: flags
+ * @ss_seq: sequence number
+ * @ss_create: creation timestamp
+ * @ss_next: next segment
+ * @ss_nblocks: number of blocks
+ * @ss_nfinfo: number of finfo structures
+ * @ss_sumbytes: total size of segment summary in bytes
+ * @ss_pad: padding
+ * @ss_cno: checkpoint number
+ */
+struct nilfs_segment_summary {
+	__le32 ss_datasum;
+	__le32 ss_sumsum;
+	__le32 ss_magic;
+	__le16 ss_bytes;
+	__le16 ss_flags;
+	__le64 ss_seq;
+	__le64 ss_create;
+	__le64 ss_next;
+	__le32 ss_nblocks;
+	__le32 ss_nfinfo;
+	__le32 ss_sumbytes;
+	__le32 ss_pad;
+	__le64 ss_cno;
+	/* array of finfo structures */
+};
+
+#define NILFS_SEGSUM_MAGIC	0x1eaffa11  /* segment summary magic number */
+
+/*
+ * Segment summary flags
+ */
+#define NILFS_SS_LOGBGN 0x0001  /* begins a logical segment */
+#define NILFS_SS_LOGEND 0x0002  /* ends a logical segment */
+#define NILFS_SS_SR     0x0004  /* has super root */
+#define NILFS_SS_SYNDT  0x0008  /* includes data only updates */
+#define NILFS_SS_GC     0x0010  /* segment written for cleaner operation */
+
+/**
+ * struct nilfs_btree_node - header of B-tree node block
+ * @bn_flags: flags
+ * @bn_level: level
+ * @bn_nchildren: number of children
+ * @bn_pad: padding
+ */
+struct nilfs_btree_node {
+	__u8 bn_flags;
+	__u8 bn_level;
+	__le16 bn_nchildren;
+	__le32 bn_pad;
+};
+
+/* flags */
+#define NILFS_BTREE_NODE_ROOT   0x01
+
+/* level */
+#define NILFS_BTREE_LEVEL_DATA          0
+#define NILFS_BTREE_LEVEL_NODE_MIN      (NILFS_BTREE_LEVEL_DATA + 1)
+#define NILFS_BTREE_LEVEL_MAX           14	/* Max level (exclusive) */
+
+/**
+ * struct nilfs_direct_node - header of built-in bmap array
+ * @dn_flags: flags
+ * @dn_pad: padding
+ */
+struct nilfs_direct_node {
+	__u8 dn_flags;
+	__u8 pad[7];
+};
+
+/**
+ * struct nilfs_palloc_group_desc - block group descriptor
+ * @pg_nfrees: number of free entries in block group
+ */
+struct nilfs_palloc_group_desc {
+	__le32 pg_nfrees;
+};
+
+/**
+ * struct nilfs_dat_entry - disk address translation entry
+ * @de_blocknr: block number
+ * @de_start: start checkpoint number
+ * @de_end: end checkpoint number
+ * @de_rsv: reserved for future use
+ */
+struct nilfs_dat_entry {
+	__le64 de_blocknr;
+	__le64 de_start;
+	__le64 de_end;
+	__le64 de_rsv;
+};
+
+#define NILFS_MIN_DAT_ENTRY_SIZE	32
+
+/**
+ * struct nilfs_snapshot_list - snapshot list
+ * @ssl_next: next checkpoint number on snapshot list
+ * @ssl_prev: previous checkpoint number on snapshot list
+ */
+struct nilfs_snapshot_list {
+	__le64 ssl_next;
+	__le64 ssl_prev;
+};
+
+/**
+ * struct nilfs_checkpoint - checkpoint structure
+ * @cp_flags: flags
+ * @cp_checkpoints_count: checkpoints count in a block
+ * @cp_snapshot_list: snapshot list
+ * @cp_cno: checkpoint number
+ * @cp_create: creation timestamp
+ * @cp_nblk_inc: number of blocks incremented by this checkpoint
+ * @cp_inodes_count: inodes count
+ * @cp_blocks_count: blocks count
+ * @cp_ifile_inode: inode of ifile
+ */
+struct nilfs_checkpoint {
+	__le32 cp_flags;
+	__le32 cp_checkpoints_count;
+	struct nilfs_snapshot_list cp_snapshot_list;
+	__le64 cp_cno;
+	__le64 cp_create;
+	__le64 cp_nblk_inc;
+	__le64 cp_inodes_count;
+	__le64 cp_blocks_count;
+
+	/*
+	 * Do not change the byte offset of ifile inode.
+	 * To keep the compatibility of the disk format,
+	 * additional fields should be added behind cp_ifile_inode.
+	 */
+	struct nilfs_inode cp_ifile_inode;
+};
+
+#define NILFS_MIN_CHECKPOINT_SIZE	(64 + NILFS_MIN_INODE_SIZE)
+
+/* checkpoint flags */
+enum {
+	NILFS_CHECKPOINT_SNAPSHOT,
+	NILFS_CHECKPOINT_INVALID,
+	NILFS_CHECKPOINT_SKETCH,
+	NILFS_CHECKPOINT_MINOR,
+};
+
+#define NILFS_CHECKPOINT_FNS(flag, name)				\
+static inline void							\
+nilfs_checkpoint_set_##name(struct nilfs_checkpoint *cp)		\
+{									\
+	cp->cp_flags = cpu_to_le32(le32_to_cpu(cp->cp_flags) |		\
+				   (1UL << NILFS_CHECKPOINT_##flag));	\
+}									\
+static inline void							\
+nilfs_checkpoint_clear_##name(struct nilfs_checkpoint *cp)		\
+{									\
+	cp->cp_flags = cpu_to_le32(le32_to_cpu(cp->cp_flags) &		\
+				   ~(1UL << NILFS_CHECKPOINT_##flag));	\
+}									\
+static inline int							\
+nilfs_checkpoint_##name(const struct nilfs_checkpoint *cp)		\
+{									\
+	return !!(le32_to_cpu(cp->cp_flags) &				\
+		  (1UL << NILFS_CHECKPOINT_##flag));			\
+}
+
+NILFS_CHECKPOINT_FNS(SNAPSHOT, snapshot)
+NILFS_CHECKPOINT_FNS(INVALID, invalid)
+NILFS_CHECKPOINT_FNS(MINOR, minor)
+
+/**
+ * struct nilfs_cpfile_header - checkpoint file header
+ * @ch_ncheckpoints: number of checkpoints
+ * @ch_nsnapshots: number of snapshots
+ * @ch_snapshot_list: snapshot list
+ */
+struct nilfs_cpfile_header {
+	__le64 ch_ncheckpoints;
+	__le64 ch_nsnapshots;
+	struct nilfs_snapshot_list ch_snapshot_list;
+};
+
+#define NILFS_CPFILE_FIRST_CHECKPOINT_OFFSET				\
+	((sizeof(struct nilfs_cpfile_header) +				\
+	  sizeof(struct nilfs_checkpoint) - 1) /			\
+			sizeof(struct nilfs_checkpoint))
+
+/**
+ * struct nilfs_segment_usage - segment usage
+ * @su_lastmod: last modified timestamp
+ * @su_nblocks: number of blocks in segment
+ * @su_flags: flags
+ */
+struct nilfs_segment_usage {
+	__le64 su_lastmod;
+	__le32 su_nblocks;
+	__le32 su_flags;
+};
+
+#define NILFS_MIN_SEGMENT_USAGE_SIZE	16
+
+/* segment usage flag */
+enum {
+	NILFS_SEGMENT_USAGE_ACTIVE,
+	NILFS_SEGMENT_USAGE_DIRTY,
+	NILFS_SEGMENT_USAGE_ERROR,
+};
+
+#define NILFS_SEGMENT_USAGE_FNS(flag, name)				\
+static inline void							\
+nilfs_segment_usage_set_##name(struct nilfs_segment_usage *su)		\
+{									\
+	su->su_flags = cpu_to_le32(le32_to_cpu(su->su_flags) |		\
+				   (1UL << NILFS_SEGMENT_USAGE_##flag));\
+}									\
+static inline void							\
+nilfs_segment_usage_clear_##name(struct nilfs_segment_usage *su)	\
+{									\
+	su->su_flags =							\
+		cpu_to_le32(le32_to_cpu(su->su_flags) &			\
+			    ~(1UL << NILFS_SEGMENT_USAGE_##flag));      \
+}									\
+static inline int							\
+nilfs_segment_usage_##name(const struct nilfs_segment_usage *su)	\
+{									\
+	return !!(le32_to_cpu(su->su_flags) &				\
+		  (1UL << NILFS_SEGMENT_USAGE_##flag));			\
+}
+
+NILFS_SEGMENT_USAGE_FNS(ACTIVE, active)
+NILFS_SEGMENT_USAGE_FNS(DIRTY, dirty)
+NILFS_SEGMENT_USAGE_FNS(ERROR, error)
+
+static inline void
+nilfs_segment_usage_set_clean(struct nilfs_segment_usage *su)
+{
+	su->su_lastmod = cpu_to_le64(0);
+	su->su_nblocks = cpu_to_le32(0);
+	su->su_flags = cpu_to_le32(0);
+}
+
+static inline int
+nilfs_segment_usage_clean(const struct nilfs_segment_usage *su)
+{
+	return !le32_to_cpu(su->su_flags);
+}
+
+/**
+ * struct nilfs_sufile_header - segment usage file header
+ * @sh_ncleansegs: number of clean segments
+ * @sh_ndirtysegs: number of dirty segments
+ * @sh_last_alloc: last allocated segment number
+ */
+struct nilfs_sufile_header {
+	__le64 sh_ncleansegs;
+	__le64 sh_ndirtysegs;
+	__le64 sh_last_alloc;
+	/* ... */
+};
+
+#define NILFS_SUFILE_FIRST_SEGMENT_USAGE_OFFSET				\
+	((sizeof(struct nilfs_sufile_header) +				\
+	  sizeof(struct nilfs_segment_usage) - 1) /			\
+			 sizeof(struct nilfs_segment_usage))
+
+#endif	/* _LINUX_NILFS2_ONDISK_H */
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are


