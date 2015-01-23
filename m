From: akpm@linux-foundation.org
Subject: + ocfs2-prepare-some-interfaces-used-in-append-direct-io.patch
 added to -mm tree
Date: Thu, 22 Jan 2015 16:35:30 -0800
Message-ID: <54c19752.61BR+0cCqZ4nwd1K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55376 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbbAWAfc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jan 2015 19:35:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, alex.chen@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.com, wangww631@huawei.com, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: prepare some interfaces used in append direct io
has been added to the -mm tree.  Its filename is
     ocfs2-prepare-some-interfaces-used-in-append-direct-io.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-prepare-some-interfaces-used-in-append-direct-io.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-prepare-some-interfaces-used-in-append-direct-io.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-fix-snprintf-format-specifier-in-dlmdebugc.patch
ocfs2-fix-journal-commit-deadlock-in-ocfs2_convert_inline_data_to_extents.patch
ocfs2-add-a-mount-option-journal_async_commit-on-ocfs2-filesystem.patch
linux-next.patch
ocfs2-prepare-some-interfaces-used-in-append-direct-io.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans.patch
ocfs2-implement-ocfs2_direct_io_write.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch
ocfs2-allocate-blocks-in-ocfs2_direct_io_get_blocks.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch
ocfs2-complete-the-rest-request-through-buffer-io.patch
ocfs2-wait-for-orphan-recovery-first-once-append-o_direct-write-crash.patch
ocfs2-set-append-dio-as-a-ro-compat-feature.patch

