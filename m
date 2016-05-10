From: akpm@linux-foundation.org
Subject: +
 ocfs2-revert-using-ocfs2_acl_chmod-to-avoid-inode-cluster-lock-hang.patch
 added to -mm tree
Date: Mon, 09 May 2016 22:58:12 -0700
Message-ID: <57317874.oAge0DIRPnqI2HFd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37949 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbcEJF6N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2016 01:58:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, tariq.x.saeed@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: revert using ocfs2_acl_chmod to avoid inode cluster lock hang
has been added to the -mm tree.  Its filename is
     ocfs2-revert-using-ocfs2_acl_chmod-to-avoid-inode-cluster-lock-hang.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-revert-using-ocfs2_acl_chmod-to-avoid-inode-cluster-lock-hang.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-revert-using-ocfs2_acl_chmod-to-avoid-inode-cluster-lock-hang.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: revert using ocfs2_acl_chmod to avoid inode cluster lock hang

commit 743b5f1434f5 ("ocfs2: take inode lock in ocfs2_iop_set/get_acl()")
introduced this issue.  ocfs2_setattr called by chmod command holds
cluster wide inode lock when calling posix_acl_chmod.  This latter
function in turn calls ocfs2_iop_get_acl and ocfs2_iop_set_acl.  These two
are also called directly from vfs layer for getfacl/setfacl commands and
therefore acquire the cluster wide inode lock.  If a remote conversion
request comes after the first inode lock in ocfs2_setattr,
OCFS2_LOCK_BLOCKED will be set.  And this will cause the second call to
inode lock from the ocfs2_iop_get_acl() to block indefinetly.

The deleted version of ocfs2_acl_chmod() calls __posix_acl_chmod() which
does not call back into the filesystem.  Therefore, we restore
ocfs2_acl_chmod(), modify it slightly for locking as needed, and use that
instead.

Fixes: 743b5f1434f5 ("ocfs2: take inode lock in ocfs2_iop_set/get_acl()")
Signed-off-by: Tariq Saeed <tariq.x.saeed@oracle.com>
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/acl.c  |   24 ++++++++++++++++++++++++
 fs/ocfs2/acl.h  |    1 +
 fs/ocfs2/file.c |    4 ++--
 3 files changed, 27 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/acl.c~ocfs2-revert-using-ocfs2_acl_chmod-to-avoid-inode-cluster-lock-hang fs/ocfs2/acl.c
--- a/fs/ocfs2/acl.c~ocfs2-revert-using-ocfs2_acl_chmod-to-avoid-inode-cluster-lock-hang
+++ a/fs/ocfs2/acl.c
@@ -322,3 +322,27 @@ struct posix_acl *ocfs2_iop_get_acl(stru
 	brelse(di_bh);
 	return acl;
 }
+
+int ocfs2_acl_chmod(struct inode *inode, struct buffer_head *bh)
+{
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct posix_acl *acl;
+	int ret;
+
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+
+	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
+		return 0;
+
+	acl = ocfs2_get_acl_nolock(inode, ACL_TYPE_ACCESS, bh);
+	if (IS_ERR(acl) || !acl)
+		return PTR_ERR(acl);
+	ret = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
+	if (ret)
+		return ret;
+	ret = ocfs2_set_acl(NULL, inode, NULL, ACL_TYPE_ACCESS,
+			    acl, NULL, NULL);
+	posix_acl_release(acl);
+	return ret;
+}
diff -puN fs/ocfs2/acl.h~ocfs2-revert-using-ocfs2_acl_chmod-to-avoid-inode-cluster-lock-hang fs/ocfs2/acl.h
--- a/fs/ocfs2/acl.h~ocfs2-revert-using-ocfs2_acl_chmod-to-avoid-inode-cluster-lock-hang
+++ a/fs/ocfs2/acl.h
@@ -35,5 +35,6 @@ int ocfs2_set_acl(handle_t *handle,
 			 struct posix_acl *acl,
 			 struct ocfs2_alloc_context *meta_ac,
 			 struct ocfs2_alloc_context *data_ac);
+extern int ocfs2_acl_chmod(struct inode *, struct buffer_head *);
 
 #endif /* OCFS2_ACL_H */
diff -puN fs/ocfs2/file.c~ocfs2-revert-using-ocfs2_acl_chmod-to-avoid-inode-cluster-lock-hang fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-revert-using-ocfs2_acl_chmod-to-avoid-inode-cluster-lock-hang
+++ a/fs/ocfs2/file.c
@@ -1268,20 +1268,20 @@ bail_unlock_rw:
 	if (size_change)
 		ocfs2_rw_unlock(inode, 1);
 bail:
-	brelse(bh);
 
 	/* Release quota pointers in case we acquired them */
 	for (qtype = 0; qtype < OCFS2_MAXQUOTAS; qtype++)
 		dqput(transfer_to[qtype]);
 
 	if (!status && attr->ia_valid & ATTR_MODE) {
-		status = posix_acl_chmod(inode, inode->i_mode);
+		status = ocfs2_acl_chmod(inode, bh);
 		if (status < 0)
 			mlog_errno(status);
 	}
 	if (inode_locked)
 		ocfs2_inode_unlock(inode, 1);
 
+	brelse(bh);
 	return status;
 }
 
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-revert-using-ocfs2_acl_chmod-to-avoid-inode-cluster-lock-hang.patch
ocfs2-fix-posix_acl_create-deadlock.patch
ocfs2-o2hb-add-negotiate-timer.patch
ocfs2-o2hb-add-negotiate-timer-v2.patch
ocfs2-o2hb-add-nego_timeout-message.patch
ocfs2-o2hb-add-nego_timeout-message-v2.patch
ocfs2-o2hb-add-negotiate_approve-message.patch
ocfs2-o2hb-add-negotiate_approve-message-v2.patch
ocfs2-o2hb-add-some-user-debug-log.patch
ocfs2-o2hb-add-some-user-debug-log-v2.patch
ocfs2-o2hb-dont-negotiate-if-last-hb-fail.patch
ocfs2-o2hb-fix-hb-hung-time.patch

