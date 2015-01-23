From: akpm@linux-foundation.org
Subject: [to-be-updated]
 ocfs2-eliminate-the-static-flag-of-some-functions.patch removed from -mm
 tree
Date: Thu, 22 Jan 2015 16:30:07 -0800
Message-ID: <54c1960f.jySpBz3Z9O8I2D/I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773AbbAWAaI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jan 2015 19:30:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangww631@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: eliminate the static flag of some functions
has been removed from the -mm tree.  Its filename was
     ocfs2-eliminate-the-static-flag-of-some-functions.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Weiwei Wang <wangww631@huawei.com>
Subject: ocfs2: eliminate the static flag of some functions

Currently in case of append O_DIRECT write (block not allocated yet),
ocfs2 will fall back to buffered I/O.  This has some disadvantages. 
Firstly, it is not the behavior as expected.

Secondly, it will consume huge page cache, e.g.  in mass backup scenario. 
Thirdly, modern filesystems such as ext4 support this feature.

In this patch set, the direct I/O write doesn't fallback to buffer I/O
write any more because the allocate blocks are enabled in direct I/O now.


This patch (of 7):

Eliminate the static flag of some functions which will be used in append
O_DIRECT write.

Signed-off-by: Weiwei Wang <wangww631@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |   11 +++++++++--
 fs/ocfs2/file.h |    9 +++++++++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/file.c~ocfs2-eliminate-the-static-flag-of-some-functions fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-eliminate-the-static-flag-of-some-functions
+++ a/fs/ocfs2/file.c
@@ -295,7 +295,7 @@ out:
 	return ret;
 }
 
-static int ocfs2_set_inode_size(handle_t *handle,
+int ocfs2_set_inode_size(handle_t *handle,
 				struct inode *inode,
 				struct buffer_head *fe_bh,
 				u64 new_i_size)
@@ -441,7 +441,7 @@ out:
 	return status;
 }
 
-static int ocfs2_truncate_file(struct inode *inode,
+int ocfs2_truncate_file(struct inode *inode,
 			       struct buffer_head *di_bh,
 			       u64 new_i_size)
 {
@@ -709,6 +709,13 @@ leave:
 	return status;
 }
 
+int ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
+		u32 clusters_to_add, int mark_unwritten)
+{
+	return __ocfs2_extend_allocation(inode, logical_start,
+			clusters_to_add, mark_unwritten);
+}
+
 /*
  * While a write will already be ordering the data, a truncate will not.
  * Thus, we need to explicitly order the zeroed pages.
diff -puN fs/ocfs2/file.h~ocfs2-eliminate-the-static-flag-of-some-functions fs/ocfs2/file.h
--- a/fs/ocfs2/file.h~ocfs2-eliminate-the-static-flag-of-some-functions
+++ a/fs/ocfs2/file.h
@@ -51,13 +51,22 @@ int ocfs2_add_inode_data(struct ocfs2_su
 			 struct ocfs2_alloc_context *data_ac,
 			 struct ocfs2_alloc_context *meta_ac,
 			 enum ocfs2_alloc_restarted *reason_ret);
+int ocfs2_set_inode_size(handle_t *handle,
+		struct inode *inode,
+		struct buffer_head *fe_bh,
+		u64 new_i_size);
 int ocfs2_simple_size_update(struct inode *inode,
 			     struct buffer_head *di_bh,
 			     u64 new_i_size);
+int ocfs2_truncate_file(struct inode *inode,
+		struct buffer_head *di_bh,
+		u64 new_i_size);
 int ocfs2_extend_no_holes(struct inode *inode, struct buffer_head *di_bh,
 			  u64 new_i_size, u64 zero_to);
 int ocfs2_zero_extend(struct inode *inode, struct buffer_head *di_bh,
 		      loff_t zero_to);
+int ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
+		u32 clusters_to_add, int mark_unwritten);
 int ocfs2_setattr(struct dentry *dentry, struct iattr *attr);
 int ocfs2_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		  struct kstat *stat);
_

Patches currently in -mm which might be from wangww631@huawei.com are

ocfs2-add-a-mount-option-journal_async_commit-on-ocfs2-filesystem.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans.patch
ocfs2-implement-ocfs2_direct_io_write.patch
ocfs2-allocate-blocks-in-ocfs2_direct_io_get_blocks.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes.patch
ocfs2-fix-leftover-orphan-entry-caused-by-append-o_direct-write-crash.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch

