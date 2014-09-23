From: akpm@linux-foundation.org
Subject: + ocfs2-eliminate-the-static-flag-of-some-functions.patch added
 to -mm tree
Date: Tue, 23 Sep 2014 15:15:16 -0700
Message-ID: <5421f0f4.Ty46sLDn8/nqO36i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38389 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943AbaIWWPR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Sep 2014 18:15:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangww631@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: make some functions non-static
has been added to the -mm tree.  Its filename is
     ocfs2-eliminate-the-static-flag-of-some-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-eliminate-the-static-flag-of-some-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-eliminate-the-static-flag-of-some-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: WeiWei Wang <wangww631@huawei.com>
Subject: ocfs2: make some functions non-static

Currently in case of O_DIRECT append write (block not allocated yet),
ocfs2 will fall back to buffered I/O.  This has some disadvantages. 
Firstly, it is not the behavior as expected.  Secondly, it will consume
huge page cache, e.g.  in mass backup scenario.  Thirdly, modern
filesystems such as ext4 support this feature.

In this patch set, the direct I/O write doesn't fallback to buffer I/O
write any more because the allocate blocks are enabled in direct I/O now.


This patch:

Give some functions global scope.

Signed-off-by: Weiwei Wang <wangww631@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c  |    6 +++---
 fs/ocfs2/file.h  |    9 +++++++++
 fs/ocfs2/namei.c |   18 ++----------------
 fs/ocfs2/namei.h |   15 ++++++++++++++-
 4 files changed, 28 insertions(+), 20 deletions(-)

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
@@ -557,7 +557,7 @@ int ocfs2_add_inode_data(struct ocfs2_su
 	return ret;
 }
 
-static int __ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
+int __ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
 				     u32 clusters_to_add, int mark_unwritten)
 {
 	int status = 0;
diff -puN fs/ocfs2/file.h~ocfs2-eliminate-the-static-flag-of-some-functions fs/ocfs2/file.h
--- a/fs/ocfs2/file.h~ocfs2-eliminate-the-static-flag-of-some-functions
+++ a/fs/ocfs2/file.h
@@ -51,13 +51,22 @@ int ocfs2_add_inode_data(struct ocfs2_su
 			 struct ocfs2_alloc_context *data_ac,
 			 struct ocfs2_alloc_context *meta_ac,
 			 enum ocfs2_alloc_restarted *reason_ret);
+int ocfs2_set_inode_size(handle_t *handle,
+				struct inode *inode,
+				struct buffer_head *fe_bh,
+				u64 new_i_size);
 int ocfs2_simple_size_update(struct inode *inode,
 			     struct buffer_head *di_bh,
 			     u64 new_i_size);
+int ocfs2_truncate_file(struct inode *inode,
+			       struct buffer_head *di_bh,
+			       u64 new_i_size);
 int ocfs2_extend_no_holes(struct inode *inode, struct buffer_head *di_bh,
 			  u64 new_i_size, u64 zero_to);
 int ocfs2_zero_extend(struct inode *inode, struct buffer_head *di_bh,
 		      loff_t zero_to);
+int __ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
+				     u32 clusters_to_add, int mark_unwritten);
 int ocfs2_setattr(struct dentry *dentry, struct iattr *attr);
 int ocfs2_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		  struct kstat *stat);
diff -puN fs/ocfs2/namei.c~ocfs2-eliminate-the-static-flag-of-some-functions fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-eliminate-the-static-flag-of-some-functions
+++ a/fs/ocfs2/namei.c
@@ -75,20 +75,6 @@ static int ocfs2_mknod_locked(struct ocf
 			      handle_t *handle,
 			      struct ocfs2_alloc_context *inode_ac);
 
-static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
-				    struct inode **ret_orphan_dir,
-				    u64 blkno,
-				    char *name,
-				    struct ocfs2_dir_lookup_result *lookup);
-
-static int ocfs2_orphan_add(struct ocfs2_super *osb,
-			    handle_t *handle,
-			    struct inode *inode,
-			    struct buffer_head *fe_bh,
-			    char *name,
-			    struct ocfs2_dir_lookup_result *lookup,
-			    struct inode *orphan_dir_inode);
-
 static int ocfs2_create_symlink_data(struct ocfs2_super *osb,
 				     handle_t *handle,
 				     struct inode *inode,
@@ -2097,7 +2083,7 @@ static int __ocfs2_prepare_orphan_dir(st
  *
  * Returns non-zero on failure. 
  */
-static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
+int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
 				    struct inode **ret_orphan_dir,
 				    u64 blkno,
 				    char *name,
@@ -2137,7 +2123,7 @@ out:
 	return ret;
 }
 
-static int ocfs2_orphan_add(struct ocfs2_super *osb,
+int ocfs2_orphan_add(struct ocfs2_super *osb,
 			    handle_t *handle,
 			    struct inode *inode,
 			    struct buffer_head *fe_bh,
diff -puN fs/ocfs2/namei.h~ocfs2-eliminate-the-static-flag-of-some-functions fs/ocfs2/namei.h
--- a/fs/ocfs2/namei.h~ocfs2-eliminate-the-static-flag-of-some-functions
+++ a/fs/ocfs2/namei.h
@@ -26,10 +26,23 @@
 #ifndef OCFS2_NAMEI_H
 #define OCFS2_NAMEI_H
 
+#include "dir.h"
+
 extern const struct inode_operations ocfs2_dir_iops;
 
 struct dentry *ocfs2_get_parent(struct dentry *child);
-
+int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
+				    struct inode **ret_orphan_dir,
+				    u64 blkno,
+				    char *name,
+				    struct ocfs2_dir_lookup_result *lookup);
+int ocfs2_orphan_add(struct ocfs2_super *osb,
+			    handle_t *handle,
+			    struct inode *inode,
+			    struct buffer_head *fe_bh,
+			    char *name,
+			    struct ocfs2_dir_lookup_result *lookup,
+			    struct inode *orphan_dir_inode);
 int ocfs2_orphan_del(struct ocfs2_super *osb,
 		     handle_t *handle,
 		     struct inode *orphan_dir_inode,
_

Patches currently in -mm which might be from wangww631@huawei.com are

ocfs2-eliminate-the-static-flag-of-some-functions.patch
ocfs2-add-two-functions-of-add-and-remove-inode-in-orphan-dir.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans.patch
ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io.patch
ocfs2-allocate-blocks-in-ocfs2_direct_io_get_blocks.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes.patch

