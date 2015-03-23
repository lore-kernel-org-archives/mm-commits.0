From: akpm@linux-foundation.org
Subject: + ocfs2-fix-possible-uninitialized-variable-access.patch added to -mm tree
Date: Mon, 23 Mar 2015 16:20:22 -0700
Message-ID: <55109fb6.aRdE6rp4N5scffo/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbbCWXUX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Mar 2015 19:20:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix possible uninitialized variable access
has been added to the -mm tree.  Its filename is
     ocfs2-fix-possible-uninitialized-variable-access.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-possible-uninitialized-variable-access.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-possible-uninitialized-variable-access.patch

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
Subject: ocfs2: fix possible uninitialized variable access

In ocfs2_local_alloc_find_clear_bits and ocfs2_get_dentry, variable
numfound and set may be uninitialized and then used in tracepoint.  In
ocfs2_xattr_block_get and ocfs2_delete_xattr_in_bucket, variable block_off
and xv may be uninitialized and then used in the following logic due to
unchecked return value.

This patch fixes these possible issues.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/export.c     |    2 +-
 fs/ocfs2/localalloc.c |    2 +-
 fs/ocfs2/xattr.c      |    8 ++++++++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/export.c~ocfs2-fix-possible-uninitialized-variable-access fs/ocfs2/export.c
--- a/fs/ocfs2/export.c~ocfs2-fix-possible-uninitialized-variable-access
+++ a/fs/ocfs2/export.c
@@ -82,7 +82,6 @@ static struct dentry *ocfs2_get_dentry(s
 	}
 
 	status = ocfs2_test_inode_bit(osb, blkno, &set);
-	trace_ocfs2_get_dentry_test_bit(status, set);
 	if (status < 0) {
 		if (status == -EINVAL) {
 			/*
@@ -96,6 +95,7 @@ static struct dentry *ocfs2_get_dentry(s
 		goto unlock_nfs_sync;
 	}
 
+	trace_ocfs2_get_dentry_test_bit(status, set);
 	/* If the inode allocator bit is clear, this inode must be stale */
 	if (!set) {
 		status = -ESTALE;
diff -puN fs/ocfs2/localalloc.c~ocfs2-fix-possible-uninitialized-variable-access fs/ocfs2/localalloc.c
--- a/fs/ocfs2/localalloc.c~ocfs2-fix-possible-uninitialized-variable-access
+++ a/fs/ocfs2/localalloc.c
@@ -839,7 +839,7 @@ static int ocfs2_local_alloc_find_clear_
 				     u32 *numbits,
 				     struct ocfs2_alloc_reservation *resv)
 {
-	int numfound, bitoff, left, startoff, lastzero;
+	int numfound = 0, bitoff, left, startoff, lastzero;
 	int local_resv = 0;
 	struct ocfs2_alloc_reservation r;
 	void *bitmap = NULL;
diff -puN fs/ocfs2/xattr.c~ocfs2-fix-possible-uninitialized-variable-access fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~ocfs2-fix-possible-uninitialized-variable-access
+++ a/fs/ocfs2/xattr.c
@@ -1238,6 +1238,10 @@ static int ocfs2_xattr_block_get(struct
 								i,
 								&block_off,
 								&name_offset);
+			if (ret) {
+				mlog_errno(ret);
+				goto cleanup;
+			}
 			xs->base = bucket_block(xs->bucket, block_off);
 		}
 		if (ocfs2_xattr_is_local(xs->here)) {
@@ -5665,6 +5669,10 @@ static int ocfs2_delete_xattr_in_bucket(
 
 		ret = ocfs2_get_xattr_tree_value_root(inode->i_sb, bucket,
 						      i, &xv, NULL);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
 
 		ret = ocfs2_lock_xattr_remove_allocators(inode, xv,
 							 args->ref_ci,
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-fix-a-typing-error-in-ocfs2_direct_io_write.patch
ocfs2-no-need-get-dinode-bh-when-zeroing-extend.patch
ocfs2-take-inode-lock-when-get-clusters.patch
ocfs2-do-not-use-ocfs2_zero_extend-during-direct-io.patch
ocfs2-fix-typo-in-ocfs2_reserve_local_alloc_bits.patch
ocfs2-use-actual-name-length-when-find-entry-in-ocfs2_orphan_del.patch
ocfs2-use-enoent-instead-of-eexist-when-get-system-file-fails.patch
ocfs2-rollback-the-cleared-bits-if-error-occurs-after-ocfs2_block_group_clear_bits.patch
ocfs2-remove-goto-statement-in-ocfs2_check_dir_for_entry.patch
ocfs2-fix-possible-uninitialized-variable-access.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v3.patch

