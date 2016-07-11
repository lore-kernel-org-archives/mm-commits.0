From: akpm@linux-foundation.org
Subject: + ocfs2-remove-obscure-bug_on-in-dlmglue.patch added to -mm tree
Date: Mon, 11 Jul 2016 14:47:52 -0700
Message-ID: <57841408.QbVF5SzxRf7PL++x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43367 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbcGKVrx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2016 17:47:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.de, zren@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove obscure BUG_ON in dlmglue
has been added to the -mm tree.  Its filename is
     ocfs2-remove-obscure-bug_on-in-dlmglue.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-obscure-bug_on-in-dlmglue.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-obscure-bug_on-in-dlmglue.patch

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
Subject: ocfs2: remove obscure BUG_ON in dlmglue

These BUG_ON(!inode) are obscure because we have already used inode to get
osb.  And actually we can guarantee here inode is valid in the context. 
So we can safely remove them.

Link: http://lkml.kernel.org/r/5776336A.6030104@huawei.com
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Eric Ren <zren@suse.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN fs/ocfs2/dlmglue.c~ocfs2-remove-obscure-bug_on-in-dlmglue fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-remove-obscure-bug_on-in-dlmglue
+++ a/fs/ocfs2/dlmglue.c
@@ -1635,7 +1635,6 @@ int ocfs2_create_new_inode_locks(struct
 	int ret;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	BUG_ON(!inode);
 	BUG_ON(!ocfs2_inode_is_new(inode));
 
 	mlog(0, "Inode %llu\n", (unsigned long long)OCFS2_I(inode)->ip_blkno);
@@ -1678,8 +1677,6 @@ int ocfs2_rw_lock(struct inode *inode, i
 	struct ocfs2_lock_res *lockres;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	BUG_ON(!inode);
-
 	mlog(0, "inode %llu take %s RW lock\n",
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
 	     write ? "EXMODE" : "PRMODE");
@@ -1722,8 +1719,6 @@ int ocfs2_open_lock(struct inode *inode)
 	struct ocfs2_lock_res *lockres;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	BUG_ON(!inode);
-
 	mlog(0, "inode %llu take PRMODE open lock\n",
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno);
 
@@ -1747,8 +1742,6 @@ int ocfs2_try_open_lock(struct inode *in
 	struct ocfs2_lock_res *lockres;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	BUG_ON(!inode);
-
 	mlog(0, "inode %llu try to take %s open lock\n",
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
 	     write ? "EXMODE" : "PRMODE");
@@ -2326,8 +2319,6 @@ int ocfs2_inode_lock_full_nested(struct
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct buffer_head *local_bh = NULL;
 
-	BUG_ON(!inode);
