From: akpm@linux-foundation.org
Subject: + nilfs2-support-nanosecond-timestamp.patch added to -mm tree
Date: Mon, 09 Mar 2009 14:46:20 -0700
Message-ID: <200903092146.n29LkK0s010586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751511AbZCIVqz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Mar 2009 17:46:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp


The patch titled
     nilfs2: support nanosecond timestamp
has been added to the -mm tree.  Its filename is
     nilfs2-support-nanosecond-timestamp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: support nanosecond timestamp
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

After a review of user's feedback for finding out other compatibility
issues, I found nilfs improperly initializes timestamps in inode;
CURRENT_TIME was used there instead of CURRENT_TIME_SEC even though nilfs
didn't have nanosecond timestamps on disk.  A few users gave us the report
that the tar program sometimes failed to expand symbolic links on nilfs,
and it turned out to be the cause.

Instead of applying the above displacement, I've decided to support
nanosecond timestamps on this occation.  Fortunetaly, a needless 64-bit
field was in the nilfs_inode struct, and I found it's available for this
purpose without impact for the users.

So, this will do the enhancement and resolve the tar problem.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/gcinode.c       |    1 -
 fs/nilfs2/inode.c         |   13 ++++++-------
 fs/nilfs2/nilfs.h         |    1 -
 fs/nilfs2/super.c         |    1 +
 include/linux/nilfs2_fs.h |   10 ++++++----
 5 files changed, 13 insertions(+), 13 deletions(-)

diff -puN fs/nilfs2/gcinode.c~nilfs2-support-nanosecond-timestamp fs/nilfs2/gcinode.c
--- a/fs/nilfs2/gcinode.c~nilfs2-support-nanosecond-timestamp
+++ a/fs/nilfs2/gcinode.c
@@ -226,7 +226,6 @@ static struct inode *alloc_gcinode(struc
 	ii->i_flags = 0;
 	ii->i_state = 1 << NILFS_I_GCINODE;
 	ii->i_bh = NULL;
-	ii->i_dtime = 0;
 	nilfs_bmap_init_gc(ii->i_bmap);
 
 	return inode;
diff -puN fs/nilfs2/inode.c~nilfs2-support-nanosecond-timestamp fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~nilfs2-support-nanosecond-timestamp
+++ a/fs/nilfs2/inode.c
@@ -306,7 +306,6 @@ struct inode *nilfs_new_inode(struct ino
 
 	/* ii->i_file_acl = 0; */
 	/* ii->i_dir_acl = 0; */
-	ii->i_dtime = 0;
 	ii->i_dir_start_lookup = 0;
 #ifdef CONFIG_NILFS_FS_POSIX_ACL
 	ii->i_acl = NULL;
@@ -390,11 +389,10 @@ int nilfs_read_inode_common(struct inode
 	inode->i_atime.tv_sec = le64_to_cpu(raw_inode->i_mtime);
 	inode->i_ctime.tv_sec = le64_to_cpu(raw_inode->i_ctime);
 	inode->i_mtime.tv_sec = le64_to_cpu(raw_inode->i_mtime);
-	inode->i_atime.tv_nsec = 0;
-	inode->i_ctime.tv_nsec = 0;
-	inode->i_mtime.tv_nsec = 0;
-	ii->i_dtime = le64_to_cpu(raw_inode->i_dtime);
-	if (inode->i_nlink == 0 && (inode->i_mode == 0 || ii->i_dtime))
+	inode->i_atime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
+	inode->i_ctime.tv_nsec = le32_to_cpu(raw_inode->i_ctime_nsec);
+	inode->i_mtime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
+	if (inode->i_nlink == 0 && inode->i_mode == 0)
 		return -EINVAL; /* this inode is deleted */
 
 	inode->i_blocks = le64_to_cpu(raw_inode->i_blocks);
@@ -505,9 +503,10 @@ void nilfs_write_inode_common(struct ino
 	raw_inode->i_size = cpu_to_le64(inode->i_size);
 	raw_inode->i_ctime = cpu_to_le64(inode->i_ctime.tv_sec);
 	raw_inode->i_mtime = cpu_to_le64(inode->i_mtime.tv_sec);
+	raw_inode->i_ctime_nsec = cpu_to_le32(inode->i_ctime.tv_nsec);
+	raw_inode->i_mtime_nsec = cpu_to_le32(inode->i_mtime.tv_nsec);
 	raw_inode->i_blocks = cpu_to_le64(inode->i_blocks);
 
-	raw_inode->i_dtime = cpu_to_le64(ii->i_dtime);
 	raw_inode->i_flags = cpu_to_le32(ii->i_flags);
 	raw_inode->i_generation = cpu_to_le32(inode->i_generation);
 
diff -puN fs/nilfs2/nilfs.h~nilfs2-support-nanosecond-timestamp fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h~nilfs2-support-nanosecond-timestamp
+++ a/fs/nilfs2/nilfs.h
@@ -48,7 +48,6 @@ struct nilfs_inode_info {
 	struct nilfs_bmap *i_bmap;
 	union nilfs_bmap_union i_bmap_union;
 	__u64 i_xattr;	/* sector_t ??? */
-	__u32 i_dtime;
 	__u32 i_dir_start_lookup;
 	__u64 i_cno;		/* check point number for GC inode */
 	struct address_space i_btnode_cache;
diff -puN fs/nilfs2/super.c~nilfs2-support-nanosecond-timestamp fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-support-nanosecond-timestamp
+++ a/fs/nilfs2/super.c
@@ -792,6 +792,7 @@ nilfs_fill_super(struct super_block *sb,
 	sb->s_op = &nilfs_sops;
 	sb->s_export_op = &nilfs_export_ops;
 	sb->s_root = NULL;
+	sb->s_time_gran = 1;
 
 	if (!nilfs_loaded(nilfs)) {
 		err = load_nilfs(nilfs, sbi);
diff -puN include/linux/nilfs2_fs.h~nilfs2-support-nanosecond-timestamp include/linux/nilfs2_fs.h
--- a/include/linux/nilfs2_fs.h~nilfs2-support-nanosecond-timestamp
+++ a/include/linux/nilfs2_fs.h
@@ -67,9 +67,10 @@
  * struct nilfs_inode - structure of an inode on disk
  * @i_blocks: blocks count
  * @i_size: size in bytes
- * @i_ctime: creation time
- * @i_mtime: modification time
- * @i_dtime: deletion time
+ * @i_ctime: creation time (seconds)
+ * @i_mtime: modification time (seconds)
+ * @i_ctime_nsec: creation time (nano seconds)
+ * @i_mtime_nsec: modification time (nano seconds)
  * @i_uid: user id
  * @i_gid: group id
  * @i_mode: file mode
@@ -85,7 +86,8 @@ struct nilfs_inode {
 	__le64	i_size;
 	__le64	i_ctime;
 	__le64	i_mtime;
-	__le64	i_dtime;
+	__le32	i_ctime_nsec;
+	__le32	i_mtime_nsec;
 	__le32	i_uid;
 	__le32	i_gid;
 	__le16	i_mode;
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-add-document.patch
nilfs2-disk-format-and-userland-interface.patch
nilfs2-add-inode-and-other-major-structures.patch
nilfs2-integrated-block-mapping.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-b-tree-based-block-mapping.patch
nilfs2-direct-block-mapping.patch
nilfs2-b-tree-node-cache.patch
nilfs2-buffer-and-page-operations.patch
nilfs2-meta-data-file.patch
nilfs2-persistent-object-allocator.patch
nilfs2-disk-address-translator.patch
nilfs2-inode-map-file.patch
nilfs2-checkpoint-file.patch
nilfs2-segment-usage-file.patch
nilfs2-segment-usage-file-fix-wrong-counting-of-checkpoints-and-dirty-segments.patch
nilfs2-inode-operations.patch
nilfs2-inode-operations-fix.patch
nilfs2-file-operations.patch
nilfs2-directory-entry-operations.patch
nilfs2-pathname-operations.patch
nilfs2-pathname-operations-fix.patch
nilfs2-operations-for-the_nilfs-core-object.patch
nilfs2-super-block-operations.patch
nilfs2-super-block-operations-fix.patch
nilfs2-segment-buffer.patch
nilfs2-segment-buffer-fix.patch
nilfs2-segment-constructor.patch
nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite.patch
nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range.patch
nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range-fix.patch
nilfs2-recovery-functions.patch
nilfs2-another-dat-for-garbage-collection.patch
nilfs2-block-cache-for-garbage-collection.patch
nilfs2-ioctl-operations.patch
nilfs2-update-makefile-and-kconfig.patch
nilfs2-fix-problems-of-memory-allocation-in-ioctl.patch
nilfs2-cleanup-nilfs_clear_inode.patch
nilfs2-avoid-double-error-caused-by-nilfs_transaction_end.patch
nilfs2-insert-explanations-in-gcinode-file.patch
nilfs2-add-maintainer.patch
nilfs2-fix-gc-failure-on-volumes-keeping-numerous-snapshots.patch
nilfs2-clean-up-indirect-function-calling-conventions.patch
nilfs2-fix-buggy-behavior-seen-in-enumerating-checkpoints.patch
nilfs2-remove-timedwait-ioctl-command.patch
nilfs2-use-fixed-sized-types-for-ioctl-structures.patch
nilfs2-remove-compat-ioctl-code.patch
nilfs2-use-unlocked_ioctl.patch
nilfs2-extend-nilfs_sustat-ioctl-struct.patch
nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl.patch
nilfs2-super-block-operations-fix-endian-bug.patch
nilfs2-clean-up-sketch-file.patch
nilfs2-mark-minor-flag-for-checkpoint-created-by-internal-operation.patch
nilfs2-simplify-handling-of-active-state-of-segments.patch
nilfs2-introduce-secondary-super-block.patch
nilfs2-introduce-secondary-super-block-fix.patch
nilfs2-support-nanosecond-timestamp.patch

