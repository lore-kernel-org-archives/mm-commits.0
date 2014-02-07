From: akpm@linux-foundation.org
Subject: + hfsplus-add-hfsx-subfolder-count-support.patch added to -mm
 tree
Date: Fri, 07 Feb 2014 13:22:38 -0800
Message-ID: <52f54e9e.DJXRg4BdJfZ55/Ey%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59296 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbaBGVWj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Feb 2014 16:22:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, slava@dubeyko.com, hch@infradead.org, saproj@gmail.com

Subject: + hfsplus-add-hfsx-subfolder-count-support.patch added to -mm tree
To: saproj@gmail.com,hch@infradead.org,slava@dubeyko.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Fri, 07 Feb 2014 13:22:38 -0800


The patch titled
     Subject: hfsplus: add HFSX subfolder count support
has been added to the -mm tree.  Its filename is
     hfsplus-add-hfsx-subfolder-count-support.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-add-hfsx-subfolder-count-support.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-add-hfsx-subfolder-count-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergei Antonov <saproj@gmail.com>
Subject: hfsplus: add HFSX subfolder count support

tAdd adds support for HFSX 'HasFolderCount' flag and a corresponding
'folderCount' field in folder records.  (For reference see HFS_FOLDERCOUNT
and kHFSHasFolderCountBit/kHFSHasFolderCountMask in Apple's source code.)

Ignoring subfolder count leads to fs errors found by Mac:
...
Checking catalog hierarchy.
HasFolderCount flag needs to be set (id = 105)
(It should be 0x10 instead of 0)
Incorrect folder count in a directory (id = 2)
(It should be 7 instead of 6)
...

Steps to reproduce:
 Format with "newfs_hfs -s /dev/diskXXX".
 Mount in Linux.
 Create a new directory in root.
 Unmount.
 Run "fsck_hfs /dev/diskXXX".

The patch handles directory creation, deletion, and rename.

Signed-off-by: Sergei Antonov <saproj@gmail.com>
Reviewed-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/catalog.c     |   41 +++++++++++++++++++++++++++++++++++++
 fs/hfsplus/hfsplus_fs.h  |    1 
 fs/hfsplus/hfsplus_raw.h |    6 +++--
 fs/hfsplus/inode.c       |    9 ++++++++
 4 files changed, 55 insertions(+), 2 deletions(-)

diff -puN fs/hfsplus/catalog.c~hfsplus-add-hfsx-subfolder-count-support fs/hfsplus/catalog.c
--- a/fs/hfsplus/catalog.c~hfsplus-add-hfsx-subfolder-count-support
+++ a/fs/hfsplus/catalog.c
@@ -103,6 +103,8 @@ static int hfsplus_cat_build_record(hfsp
 		folder = &entry->folder;
 		memset(folder, 0, sizeof(*folder));
 		folder->type = cpu_to_be16(HFSPLUS_FOLDER);
+		if (test_bit(HFSPLUS_SB_HFSX, &sbi->flags))
+			folder->flags |= cpu_to_be16(HFSPLUS_HAS_FOLDER_COUNT);
 		folder->id = cpu_to_be32(inode->i_ino);
 		HFSPLUS_I(inode)->create_date =
 			folder->create_date =
@@ -203,6 +205,36 @@ int hfsplus_find_cat(struct super_block
 	return hfs_brec_find(fd, hfs_find_rec_by_key);
 }
 
+static void hfsplus_subfolders_inc(struct inode *dir)
+{
+	struct hfsplus_sb_info *sbi = HFSPLUS_SB(dir->i_sb);
+
+	if (test_bit(HFSPLUS_SB_HFSX, &sbi->flags)) {
+		/*
+		 * Increment subfolder count. Note, the value is only meaningful
+		 * for folders with HFSPLUS_HAS_FOLDER_COUNT flag set.
+		 */
+		HFSPLUS_I(dir)->subfolders++;
+	}
+}
+
+static void hfsplus_subfolders_dec(struct inode *dir)
+{
+	struct hfsplus_sb_info *sbi = HFSPLUS_SB(dir->i_sb);
+
+	if (test_bit(HFSPLUS_SB_HFSX, &sbi->flags)) {
+		/*
+		 * Decrement subfolder count. Note, the value is only meaningful
+		 * for folders with HFSPLUS_HAS_FOLDER_COUNT flag set.
+		 *
+		 * Check for zero. Some subfolders may have been created
+		 * by an implementation ignorant of this counter.
+		 */
+		if (HFSPLUS_I(dir)->subfolders)
+			HFSPLUS_I(dir)->subfolders--;
+	}
+}
+
 int hfsplus_create_cat(u32 cnid, struct inode *dir,
 		struct qstr *str, struct inode *inode)
 {
@@ -247,6 +279,8 @@ int hfsplus_create_cat(u32 cnid, struct
 		goto err1;
 
 	dir->i_size++;
+	if (S_ISDIR(inode->i_mode))
+		hfsplus_subfolders_inc(dir);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
 	hfsplus_mark_inode_dirty(dir, HFSPLUS_I_CAT_DIRTY);
 
@@ -336,6 +370,8 @@ int hfsplus_delete_cat(u32 cnid, struct
 		goto out;
 
 	dir->i_size--;
+	if (type == HFSPLUS_FOLDER)
+		hfsplus_subfolders_dec(dir);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
 	hfsplus_mark_inode_dirty(dir, HFSPLUS_I_CAT_DIRTY);
 
@@ -380,6 +416,7 @@ int hfsplus_rename_cat(u32 cnid,
 
 	hfs_bnode_read(src_fd.bnode, &entry, src_fd.entryoffset,
 				src_fd.entrylength);
+	type = be16_to_cpu(entry.type);
 
 	/* create new dir entry with the data from the old entry */
 	hfsplus_cat_build_key(sb, dst_fd.search_key, dst_dir->i_ino, dst_name);
@@ -394,6 +431,8 @@ int hfsplus_rename_cat(u32 cnid,
 	if (err)
 		goto out;
 	dst_dir->i_size++;
+	if (type == HFSPLUS_FOLDER)
+		hfsplus_subfolders_inc(dst_dir);
 	dst_dir->i_mtime = dst_dir->i_ctime = CURRENT_TIME_SEC;
 
 	/* finally remove the old entry */
@@ -405,6 +444,8 @@ int hfsplus_rename_cat(u32 cnid,
 	if (err)
 		goto out;
 	src_dir->i_size--;
+	if (type == HFSPLUS_FOLDER)
+		hfsplus_subfolders_dec(src_dir);
 	src_dir->i_mtime = src_dir->i_ctime = CURRENT_TIME_SEC;
 
 	/* remove old thread entry */
diff -puN fs/hfsplus/hfsplus_fs.h~hfsplus-add-hfsx-subfolder-count-support fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~hfsplus-add-hfsx-subfolder-count-support
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -242,6 +242,7 @@ struct hfsplus_inode_info {
 	 */
 	sector_t fs_blocks;
 	u8 userflags;		/* BSD user file flags */
+	u32 subfolders;		/* Subfolder count (HFSX only) */
 	struct list_head open_dir_list;
 	loff_t phys_size;
 
diff -puN fs/hfsplus/hfsplus_raw.h~hfsplus-add-hfsx-subfolder-count-support fs/hfsplus/hfsplus_raw.h
--- a/fs/hfsplus/hfsplus_raw.h~hfsplus-add-hfsx-subfolder-count-support
+++ a/fs/hfsplus/hfsplus_raw.h
@@ -261,7 +261,7 @@ struct hfsplus_cat_folder {
 	struct DInfo user_info;
 	struct DXInfo finder_info;
 	__be32 text_encoding;
-	u32 reserved;
+	__be32 subfolders;	/* Subfolder count in HFSX. Reserved in HFS+. */
 } __packed;
 
 /* HFS file info (stolen from hfs.h) */
@@ -301,11 +301,13 @@ struct hfsplus_cat_file {
 	struct hfsplus_fork_raw rsrc_fork;
 } __packed;
 
-/* File attribute bits */
+/* File and folder flag bits */
 #define HFSPLUS_FILE_LOCKED		0x0001
 #define HFSPLUS_FILE_THREAD_EXISTS	0x0002
 #define HFSPLUS_XATTR_EXISTS		0x0004
 #define HFSPLUS_ACL_EXISTS		0x0008
+#define HFSPLUS_HAS_FOLDER_COUNT	0x0010	/* Folder has subfolder count
+						 * (HFSX only) */
 
 /* HFS+ catalog thread (part of a cat_entry) */
 struct hfsplus_cat_thread {
diff -puN fs/hfsplus/inode.c~hfsplus-add-hfsx-subfolder-count-support fs/hfsplus/inode.c
--- a/fs/hfsplus/inode.c~hfsplus-add-hfsx-subfolder-count-support
+++ a/fs/hfsplus/inode.c
@@ -375,6 +375,7 @@ struct inode *hfsplus_new_inode(struct s
 	hip->extent_state = 0;
 	hip->flags = 0;
 	hip->userflags = 0;
+	hip->subfolders = 0;
 	memset(hip->first_extents, 0, sizeof(hfsplus_extent_rec));
 	memset(hip->cached_extents, 0, sizeof(hfsplus_extent_rec));
 	hip->alloc_blocks = 0;
@@ -494,6 +495,10 @@ int hfsplus_cat_read_inode(struct inode
 		inode->i_ctime = hfsp_mt2ut(folder->attribute_mod_date);
 		HFSPLUS_I(inode)->create_date = folder->create_date;
 		HFSPLUS_I(inode)->fs_blocks = 0;
+		if (folder->flags & cpu_to_be16(HFSPLUS_HAS_FOLDER_COUNT)) {
+			HFSPLUS_I(inode)->subfolders =
+				be32_to_cpu(folder->subfolders);
+		}
 		inode->i_op = &hfsplus_dir_inode_operations;
 		inode->i_fop = &hfsplus_dir_operations;
 	} else if (type == HFSPLUS_FILE) {
@@ -566,6 +571,10 @@ int hfsplus_cat_write_inode(struct inode
 		folder->content_mod_date = hfsp_ut2mt(inode->i_mtime);
 		folder->attribute_mod_date = hfsp_ut2mt(inode->i_ctime);
 		folder->valence = cpu_to_be32(inode->i_size - 2);
+		if (folder->flags & cpu_to_be16(HFSPLUS_HAS_FOLDER_COUNT)) {
+			folder->subfolders =
+				cpu_to_be32(HFSPLUS_I(inode)->subfolders);
+		}
 		hfs_bnode_write(fd.bnode, &entry, fd.entryoffset,
 					 sizeof(struct hfsplus_cat_folder));
 	} else if (HFSPLUS_IS_RSRC(inode)) {
_

Patches currently in -mm which might be from saproj@gmail.com are

hfsplus-add-hfsx-subfolder-count-support.patch

