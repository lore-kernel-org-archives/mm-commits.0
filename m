From: akpm@linux-foundation.org
Subject: + nilfs2-add-omitted-comments-for-different-structures-in-driver-implementation.patch added to -mm tree
Date: Thu, 19 Jul 2012 14:15:15 -0700
Message-ID: <20120719211516.2112F5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:60595 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab2GSVPS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jul 2012 17:15:18 -0400
Received: by weyr1 with SMTP id r1so163808wey.1
        for <mm-commits@vger.kernel.org>; Thu, 19 Jul 2012 14:15:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: slava@dubeyko.com, konishi.ryusuke@lab.ntt.co.jp


The patch titled
     Subject: nilfs2: add omitted comments for different structures in driver implementation
has been added to the -mm tree.  Its filename is
     nilfs2-add-omitted-comments-for-different-structures-in-driver-implementation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: nilfs2: add omitted comments for different structures in driver implementation

Add omitted comments for different structures in driver implementation.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.h     |   14 +++++++++++---
 fs/nilfs2/bmap.h      |    7 +++++++
 fs/nilfs2/btnode.h    |    8 +++++++-
 fs/nilfs2/dat.c       |    6 ++++++
 fs/nilfs2/export.h    |    8 ++++++++
 fs/nilfs2/ifile.c     |    6 +++++-
 fs/nilfs2/inode.c     |    7 +++++++
 fs/nilfs2/mdt.h       |    7 +++++++
 fs/nilfs2/nilfs.h     |   17 +++++++++++++++--
 fs/nilfs2/sufile.c    |    8 +++++++-
 fs/nilfs2/the_nilfs.h |    3 +--
 11 files changed, 81 insertions(+), 10 deletions(-)

diff -puN fs/nilfs2/alloc.h~nilfs2-add-omitted-comments-for-different-structures-in-driver-implementation fs/nilfs2/alloc.h
--- a/fs/nilfs2/alloc.h~nilfs2-add-omitted-comments-for-different-structures-in-driver-implementation
+++ a/fs/nilfs2/alloc.h
@@ -76,15 +76,23 @@ int nilfs_palloc_freev(struct inode *, _
 #define nilfs_clear_bit_atomic		ext2_clear_bit_atomic
 #define nilfs_find_next_zero_bit	find_next_zero_bit_le
 
-/*
- * persistent object allocator cache
+/**
+ * struct nilfs_bh_assoc - block offset and buffer head association
+ * @blkoff: block offset
+ * @bh: buffer head
  */
-
 struct nilfs_bh_assoc {
 	unsigned long blkoff;
 	struct buffer_head *bh;
 };
 
+/**
+ * struct nilfs_palloc_cache - persistent object allocator cache
+ * @lock: cache protecting lock
+ * @prev_desc: blockgroup descriptors cache
+ * @prev_bitmap: blockgroup bitmap cache
+ * @prev_entry: translation entries cache
+ */
 struct nilfs_palloc_cache {
 	spinlock_t lock;
 	struct nilfs_bh_assoc prev_desc;
diff -puN fs/nilfs2/bmap.h~nilfs2-add-omitted-comments-for-different-structures-in-driver-implementation fs/nilfs2/bmap.h
--- a/fs/nilfs2/bmap.h~nilfs2-add-omitted-comments-for-different-structures-in-driver-implementation
+++ a/fs/nilfs2/bmap.h
@@ -135,6 +135,13 @@ struct nilfs_bmap {
 /* state */
 #define NILFS_BMAP_DIRTY	0x00000001
 
+/**
+ * struct nilfs_bmap_store - shadow copy of bmap state
+ * @data: cached raw block mapping of on-disk inode
+ * @last_allocated_key: cached value of last allocated key for data block
+ * @last_allocated_ptr: cached value of last allocated ptr for data block
+ * @state: cached value of state field of bmap structure
+ */
 struct nilfs_bmap_store {
 	__le64 data[NILFS_BMAP_SIZE / sizeof(__le64)];
 	__u64 last_allocated_key;
diff -puN fs/nilfs2/btnode.h~nilfs2-add-omitted-comments-for-different-structures-in-driver-implementation fs/nilfs2/btnode.h
--- a/fs/nilfs2/btnode.h~nilfs2-add-omitted-comments-for-different-structures-in-driver-implementation
+++ a/fs/nilfs2/btnode.h
@@ -29,7 +29,13 @@
 #include <linux/fs.h>
 #include <linux/backing-dev.h>
 
-
+/**
+ * struct nilfs_btnode_chkey_ctxt - change key context
+ * @oldkey: old key of block's moving content
+ * @newkey: new key for block's content
+ * @bh: buffer head of old buffer
+ * @newbh: buffer head of new buffer
+ */
 struct nilfs_btnode_chkey_ctxt {
 	__u64 oldkey;
 	__u64 newkey;
diff -puN fs/nilfs2/dat.c~nilfs2-add-omitted-comments-for-different-structures-in-driver-implementation fs/nilfs2/dat.c
--- a/fs/nilfs2/dat.c~nilfs2-add-omitted-comments-for-different-structures-in-driver-implementation
+++ a/fs/nilfs2/dat.c
@@ -33,6 +33,12 @@
 #define NILFS_CNO_MIN	((__u64)1)
 #define NILFS_CNO_MAX	(~(__u64)0)
 
+/**
+ * struct nilfs_dat_info - on-memory private data of DAT file
+ * @mi: on-memory private data of metadata file
+ * @palloc_cache: persistent object allocator cache of DAT file
+ * @shadow: shadow map of DAT file
+ */
 struct nilfs_dat_info {
 	struct nilfs_mdt_info mi;
 	struct nilfs_palloc_cache palloc_cache;
diff -puN fs/nilfs2/export.h~nilfs2-add-omitted-comments-for-different-structures-in-driver-implementation fs/nilfs2/export.h
--- a/fs/nilfs2/export.h~nilfs2-add-omitted-comments-for-different-structures-in-driver-implementation
+++ a/fs/nilfs2/export.h
@@ -5,6 +5,14 @@
 
 extern const struct export_operations nilfs_export_ops;
 
+/**
+ * struct nilfs_fid - NILFS file id type
+ * @cno: checkpoint number
+ * @ino: inode number
+ * @gen: file generation (version) for NFS
+ * @parent_gen: parent generation (version) for NFS
+ * @parent_ino: parent inode number
+ */
 struct nilfs_fid {
 	u64 cno;
 	u64 ino;
diff -puN fs/nilfs2/ifile.c~nilfs2-add-omitted-comments-for-different-structures-in-driver-implementation fs/nilfs2/ifile.c
--- a/fs/nilfs2/ifile.c~nilfs2-add-omitted-comments-for-different-structures-in-driver-implementation
+++ a/fs/nilfs2/ifile.c
@@ -29,7 +29,11 @@
 #include "alloc.h"
 #include "ifile.h"
 
-
+/**
+ * struct nilfs_ifile_info - on-memory private data of ifile
+ * @mi: on-memory private data of metadata file
+ * @palloc_cache: persistent object allocator cache of ifile
+ */
 struct nilfs_ifile_info {
 	struct nilfs_mdt_info mi;
 	struct nilfs_palloc_cache palloc_cache;
diff -puN fs/nilfs2/inode.c~nilfs2-add-omitted-comments-for-different-structures-in-driver-implementation fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~nilfs2-add-omitted-comments-for-different-structures-in-driver-implementation
+++ a/fs/nilfs2/inode.c
@@ -34,6 +34,13 @@
 #include "cpfile.h"
 #include "ifile.h"
 
+/**
+ * struct nilfs_iget_args - arguments used during comparison between inodes
+ * @ino: inode number
+ * @cno: checkpoint number
+ * @root: pointer on NILFS root object (mounted checkpoint)
+ * @for_gc: inode for GC flag
+ */
 struct nilfs_iget_args {
 	u64 ino;
 	__u64 cno;
diff -puN fs/nilfs2/mdt.h~nilfs2-add-omitted-comments-for-different-structures-in-driver-implementation fs/nilfs2/mdt.h
--- a/fs/nilfs2/mdt.h~nilfs2-add-omitted-comments-for-different-structures-in-driver-implementation
+++ a/fs/nilfs2/mdt.h
@@ -28,6 +28,13 @@
 #include "nilfs.h"
 #include "page.h"
 
+/**
+ * struct nilfs_shadow_map - shadow mapping of meta data file
+ * @bmap_store: shadow copy of bmap state
+ * @frozen_data: shadowed dirty data pages
+ * @frozen_btnodes: shadowed dirty b-tree nodes' pages
+ * @frozen_buffers: list of frozen buffers
+ */
 struct nilfs_shadow_map {
 	struct nilfs_bmap_store bmap_store;
 	struct address_space frozen_data;
diff -puN fs/nilfs2/nilfs.h~nilfs2-add-omitted-comments-for-different-structures-in-driver-implementation fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h~nilfs2-add-omitted-comments-for-different-structures-in-driver-implementation
+++ a/fs/nilfs2/nilfs.h
@@ -32,8 +32,21 @@
 #include "the_nilfs.h"
 #include "bmap.h"
 
-/*
- * nilfs inode data in memory
+/**
+ * struct nilfs_inode_info - nilfs inode data in memory
+ * @i_flags: inode flags
+ * @i_state: dynamic state flags
+ * @i_bmap: pointer on i_bmap_data
+ * @i_bmap_data: raw block mapping
+ * @i_xattr: <TODO>
+ * @i_dir_start_lookup: page index of last successful search
+ * @i_cno: checkpoint number for GC inode
+ * @i_btnode_cache: cached pages of b-tree nodes
+ * @i_dirty: list for connecting dirty files
+ * @xattr_sem: semaphore for extended attributes processing
+ * @i_bh: buffer contains disk inode
+ * @i_root: root object of the current filesystem tree
+ * @vfs_inode: VFS inode object
  */
 struct nilfs_inode_info {
 	__u32 i_flags;
diff -puN fs/nilfs2/sufile.c~nilfs2-add-omitted-comments-for-different-structures-in-driver-implementation fs/nilfs2/sufile.c
--- a/fs/nilfs2/sufile.c~nilfs2-add-omitted-comments-for-different-structures-in-driver-implementation
+++ a/fs/nilfs2/sufile.c
@@ -30,7 +30,13 @@
 #include "mdt.h"
 #include "sufile.h"
 
-
+/**
+ * struct nilfs_sufile_info - on-memory private data of sufile
+ * @mi: on-memory private data of metadata file
+ * @ncleansegs: number of clean segments
+ * @allocmin: lower limit of allocatable segment range
+ * @allocmax: upper limit of allocatable segment range
+ */
 struct nilfs_sufile_info {
 	struct nilfs_mdt_info mi;
 	unsigned long ncleansegs;/* number of clean segments */
diff -puN fs/nilfs2/the_nilfs.h~nilfs2-add-omitted-comments-for-different-structures-in-driver-implementation fs/nilfs2/the_nilfs.h
--- a/fs/nilfs2/the_nilfs.h~nilfs2-add-omitted-comments-for-different-structures-in-driver-implementation
+++ a/fs/nilfs2/the_nilfs.h
@@ -232,9 +232,8 @@ THE_NILFS_FNS(SB_DIRTY, sb_dirty)
  * @count: refcount of this structure
  * @nilfs: nilfs object
  * @ifile: inode file
- * @root: root inode
  * @inodes_count: number of inodes
- * @blocks_count: number of blocks (Reserved)
+ * @blocks_count: number of blocks
  */
 struct nilfs_root {
 	__u64 cno;
_
Subject: Subject: nilfs2: add omitted comments for different structures in driver implementation

Patches currently in -mm which might be from slava@dubeyko.com are

nilfs2-add-omitted-comment-for-ns_mount_state-field-of-the_nilfs-structure.patch
nilfs2-add-omitted-comments-for-structures-in-nilfs2_fsh.patch
nilfs2-add-omitted-comments-for-different-structures-in-driver-implementation.patch

