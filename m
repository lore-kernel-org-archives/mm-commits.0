From: akpm@linux-foundation.org
Subject: + ext4-fix-sparse-warnings.patch added to -mm tree
Date: Fri, 21 Sep 2007 03:22:37 -0700
Message-ID: <200709211022.l8LAMbhp030734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39299 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751910AbXIUKWp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 06:22:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com


The patch titled
     ext4: Fix sparse warnings
has been added to the -mm tree.  Its filename is
     ext4-fix-sparse-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext4: Fix sparse warnings
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c         |    6 ++++--
 include/linux/ext4_fs.h |   16 ++++++++--------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff -puN fs/ext4/inode.c~ext4-fix-sparse-warnings fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext4-fix-sparse-warnings
+++ a/fs/ext4/inode.c
@@ -3277,12 +3277,14 @@ int ext4_mark_inode_dirty(handle_t *hand
 						      iloc, handle);
 			if (ret) {
 				EXT4_I(inode)->i_state |= EXT4_STATE_NO_EXPAND;
-				if (mnt_count != sbi->s_es->s_mnt_count) {
+				if (mnt_count !=
+					le16_to_cpu(sbi->s_es->s_mnt_count)) {
 					ext4_warning(inode->i_sb, __FUNCTION__,
 					"Unable to expand inode %lu. Delete"
 					" some EAs or run e2fsck.",
 					inode->i_ino);
-					mnt_count = sbi->s_es->s_mnt_count;
+					mnt_count =
+					le16_to_cpu(sbi->s_es->s_mnt_count);
 				}
 			}
 		}
diff -puN include/linux/ext4_fs.h~ext4-fix-sparse-warnings include/linux/ext4_fs.h
--- a/include/linux/ext4_fs.h~ext4-fix-sparse-warnings
+++ a/include/linux/ext4_fs.h
@@ -115,7 +115,7 @@ struct ext4_group_desc
 	__le16	bg_free_blocks_count;	/* Free blocks count */
 	__le16	bg_free_inodes_count;	/* Free inodes count */
 	__le16	bg_used_dirs_count;	/* Directories count */
-	__u16	bg_flags;		/* EXT4_BG_flags (INODE_UNINIT, etc) */
+	__le16	bg_flags;		/* EXT4_BG_flags (INODE_UNINIT, etc) */
 	__u32	bg_reserved[2];		/* Likely block/inode bitmap checksum */
 	__le16  bg_itable_unused;	/* Unused inodes count */
 	__le16  bg_checksum;		/* crc16(sb_uuid+group+desc) */
@@ -586,13 +586,13 @@ struct ext4_super_block {
 /*150*/	__le32	s_blocks_count_hi;	/* Blocks count */
 	__le32	s_r_blocks_count_hi;	/* Reserved blocks count */
 	__le32	s_free_blocks_count_hi;	/* Free blocks count */
-	__u16	s_min_extra_isize;	/* All inodes have at least # bytes */
-	__u16	s_want_extra_isize; 	/* New inodes should reserve # bytes */
-	__u32	s_flags;		/* Miscellaneous flags */
-	__u16   s_raid_stride;		/* RAID stride */
-	__u16   s_mmp_interval;         /* # seconds to wait in MMP checking */
-	__u64   s_mmp_block;            /* Block for multi-mount protection */
-	__u32   s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
+	__le16	s_min_extra_isize;	/* All inodes have at least # bytes */
+	__le16	s_want_extra_isize; 	/* New inodes should reserve # bytes */
+	__le32	s_flags;		/* Miscellaneous flags */
+	__le16  s_raid_stride;		/* RAID stride */
+	__le16  s_mmp_interval;         /* # seconds to wait in MMP checking */
+	__le64  s_mmp_block;            /* Block for multi-mount protection */
+	__le32  s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
 	__u32   s_reserved[163];        /* Padding to the end of the block */
 };
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

ext2-ext3-ext4-add-block-bitmap-validation.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
ext4-uninitialized-block-groups.patch
ext4-uninitialized-block-groups-fix.patch
introduce-ext4_find_next_bit.patch
ext4-fix-sparse-warnings.patch
