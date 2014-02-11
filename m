From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch removed from -mm tree
Date: Tue, 11 Feb 2014 11:23:50 -0800
Message-ID: <52fa78c6.tLS4p8ssGAEyELh9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbaBKTXv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 14:23:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunil.mushran@gmail.com, shencanquan@huawei.com, mfasheh@suse.de, jlbec@evilplan.org, jeff.liu@oracle.com, younger.liu@huawei.com

Subject: [merged] ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch removed from -mm tree
To: younger.liu@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.de,shencanquan@huawei.com,sunil.mushran@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 11:23:50 -0800


The patch titled
     Subject: ocfs2: fix issue that ocfs2_setattr() does not deal with new_i_size==i_size
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Younger Liu <younger.liu@huawei.com>
Subject: ocfs2: fix issue that ocfs2_setattr() does not deal with new_i_size==i_size

The issue scenario is as following:

- Create a small file and fallocate a large disk space for a file with
  FALLOC_FL_KEEP_SIZE option.

- ftruncate the file back to the original size again.  but the disk free
  space is not changed back.  This is a real bug that be fixed in this
  patch.

In order to solve the issue above, we modified ocfs2_setattr(), if
attr->ia_size != i_size_read(inode), It calls ocfs2_truncate_file(), and
truncate disk space to attr->ia_size.

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Tested-by: Jie Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Reviewed-by: Jensen <shencanquan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    2 +-
 fs/ocfs2/file.c  |    9 ++-------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size
+++ a/fs/ocfs2/alloc.c
@@ -7158,7 +7158,7 @@ int ocfs2_truncate_inline(struct inode *
 	if (end > i_size_read(inode))
 		end = i_size_read(inode);
 
-	BUG_ON(start >= end);
+	BUG_ON(start > end);
 
 	if (!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) ||
 	    !(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) ||
diff -puN fs/ocfs2/file.c~ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size
+++ a/fs/ocfs2/file.c
@@ -477,11 +477,6 @@ static int ocfs2_truncate_file(struct in
 		goto bail;
 	}
 
-	/* lets handle the simple truncate cases before doing any more
-	 * cluster locking. */
-	if (new_i_size == le64_to_cpu(fe->i_size))
-		goto bail;
-
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 
 	ocfs2_resv_discard(&osb->osb_la_resmap,
@@ -1148,14 +1143,14 @@ int ocfs2_setattr(struct dentry *dentry,
 		goto bail_unlock_rw;
 	}
 
-	if (size_change && attr->ia_size != i_size_read(inode)) {
+	if (size_change) {
 		status = inode_newsize_ok(inode, attr->ia_size);
 		if (status)
 			goto bail_unlock;
 
 		inode_dio_wait(inode);
 
-		if (i_size_read(inode) > attr->ia_size) {
+		if (i_size_read(inode) >= attr->ia_size) {
 			if (ocfs2_should_order_data(inode)) {
 				status = ocfs2_begin_ordered_truncate(inode,
 								      attr->ia_size);
_

Patches currently in -mm which might be from younger.liu@huawei.com are

origin.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch

