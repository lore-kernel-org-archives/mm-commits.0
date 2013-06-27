From: akpm@linux-foundation.org
Subject: +
 ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch added to -mm tree
Date: Thu, 27 Jun 2013 15:10:28 -0700
Message-ID: <51ccb854.v2lbG4nq/uDDMg1Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3F0WK3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jun 2013 18:10:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunil.mushran@gmail.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, younger.liu@huawei.com

Subject: + ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch added to -mm tree
To: younger.liu@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,sunil.mushran@gmail.com
From: akpm@linux-foundation.org
Date: Thu, 27 Jun 2013 15:10:28 -0700


The patch titled
     Subject: ocfs2: fix issue that ocfs2_setattr() does not deal with new_i_size==i_size
has been added to the -mm tree.  Its filename is
     ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Younger Liu <younger.liu@huawei.com>
Subject: ocfs2: fix issue that ocfs2_setattr() does not deal with new_i_size==i_size

The issue scenario is as following:

1. fallocate a large disk space(eg.  30G) with FALLOC_FL_KEEP_SIZE for
   a file whose i_size and disk size are 512(or other size).  After
   executing fallocate, i_size file is still 512, and the disk size became
   to 30G+512；

2. ftruncate the file to new_i_size which equal to inode->i_size. 
   After executing ftruncate, disk space does not changes.  In other
   words, i_size file is still 512, and disk size is 30G+512.  But we want
   disk size to be 512.  This does not meet our expectations.

In order to solve the issue above, we modified ocfs2_setattr().  If
attr->ia_size != i_size_read(inode), it calls ocfs2_truncate_file(), and
truncate disk space to attr->ia_size.

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Cc: Jie Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    2 +-
 fs/ocfs2/file.c  |    7 ++-----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size
+++ a/fs/ocfs2/alloc.c
@@ -7126,7 +7126,7 @@ int ocfs2_truncate_inline(struct inode *
 	if (end > i_size_read(inode))
 		end = i_size_read(inode);
 
-	BUG_ON(start >= end);
+	BUG_ON(start > end);
 
 	if (!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) ||
 	    !(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) ||
diff -puN fs/ocfs2/file.c~ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size
+++ a/fs/ocfs2/file.c
@@ -476,9 +476,6 @@ static int ocfs2_truncate_file(struct in
 
 	/* lets handle the simple truncate cases before doing any more
 	 * cluster locking. */
-	if (new_i_size == le64_to_cpu(fe->i_size))
-		goto bail;
-
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 
 	ocfs2_resv_discard(&osb->osb_la_resmap,
@@ -1150,14 +1147,14 @@ int ocfs2_setattr(struct dentry *dentry,
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

linux-next.patch
fs-ocfs2-cluster-tcpc-free-sc-sc_page-in-sc_kref_release.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-need-rollback-when-journal_access-failed-in-ocfs2_orphan_add.patch
ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group.patch
ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group-fix.patch
ocfs2-fix-readonly-issue-in-ocfs2_unlink.patch
ocfs2-fix-readonly-issue-in-ocfs2_unlink-fix.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch

