From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-prepare-some-interfaces-used-in-append-direct-io.patch removed from
 -mm tree
Date: Tue, 17 Feb 2015 12:06:16 -0800
Message-ID: <54e39f38.mbZncZA2A5s9dqN8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35320 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbbBQUGR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 15:06:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, alex.chen@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.com, wangww631@huawei.com, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: prepare some interfaces used in append direct io
has been removed from the -mm tree.  Its filename was
     ocfs2-prepare-some-interfaces-used-in-append-direct-io.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: prepare some interfaces used in append direct io

Currently in case of append O_DIRECT write (block not allocated yet),
ocfs2 will fall back to buffered I/O.  This has some disadvantages. 
Firstly, it is not the behavior as expected.  Secondly, it will consume
huge page cache, e.g.  in mass backup scenario.  Thirdly, modern
filesystems such as ext4 support this feature.

In this patch set, the direct I/O write doesn't fallback to buffer I/O
write any more because the allocate blocks are enabled in direct I/O now.


This patch (of 9):

Prepare some interfaces which will be used in append O_DIRECT write.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Weiwei Wang <wangww631@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Xuejiufei <xuejiufei@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: alex chen <alex.chen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |   11 +++++++++--
 fs/ocfs2/file.h |    9 +++++++++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/file.c~ocfs2-prepare-some-interfaces-used-in-append-direct-io fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-prepare-some-interfaces-used-in-append-direct-io
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
diff -puN fs/ocfs2/file.h~ocfs2-prepare-some-interfaces-used-in-append-direct-io fs/ocfs2/file.h
--- a/fs/ocfs2/file.h~ocfs2-prepare-some-interfaces-used-in-append-direct-io
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

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v3.patch

