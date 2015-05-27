From: akpm@linux-foundation.org
Subject: +
 resubmit-ocfs2_iop_set-get_acl-called-from-the-vfs-so-take-inode-lock-v2second-version.patch added to -mm tree
Date: Wed, 27 May 2015 13:50:59 -0700
Message-ID: <55662e33.rTVkBxGjppkgWRGt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56919 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbbE0UvA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 May 2015 16:51:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tariq.x.saeed@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: take inode lock in ocfs2_iop_set/get_acl()
has been added to the -mm tree.  Its filename is
     resubmit-ocfs2_iop_set-get_acl-called-from-the-vfs-so-take-inode-lock-v2second-version.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/resubmit-ocfs2_iop_set-get_acl-called-from-the-vfs-so-take-inode-lock-v2second-version.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/resubmit-ocfs2_iop_set-get_acl-called-from-the-vfs-so-take-inode-lock-v2second-version.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tariq Saeed <tariq.x.saeed@oracle.com>
Subject: ocfs2: take inode lock in ocfs2_iop_set/get_acl()

Orabug: 20189959

This bug in mainline code is pointed out by Mark Fasheh.  When
ocfs2_iop_set_acl() and ocfs2_iop_get_acl() are entered from VFS layer,
inode lock is not held.  This seems to be regression from older kernels. 
The patch is to fix that.

Signed-off-by: Tariq Saeed <tariq.x.saeed@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/acl.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/acl.c~resubmit-ocfs2_iop_set-get_acl-called-from-the-vfs-so-take-inode-lock-v2second-version fs/ocfs2/acl.c
--- a/fs/ocfs2/acl.c~resubmit-ocfs2_iop_set-get_acl-called-from-the-vfs-so-take-inode-lock-v2second-version
+++ a/fs/ocfs2/acl.c
@@ -284,7 +284,19 @@ int ocfs2_set_acl(handle_t *handle,
 
 int ocfs2_iop_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
-	return ocfs2_set_acl(NULL, inode, NULL, type, acl, NULL, NULL);
+	struct buffer_head *bh = NULL;
+	int status = 0;
+
+	status = ocfs2_inode_lock(inode, &bh, 1);
+	if (status < 0) {
+		if (status != -ENOENT)
+			mlog_errno(status);
+		return status;
+	}
+	status = ocfs2_set_acl(NULL, inode, bh, type, acl, NULL, NULL);
+	ocfs2_inode_unlock(inode, 1);
+	brelse(bh);
+	return status;
 }
 
 struct posix_acl *ocfs2_iop_get_acl(struct inode *inode, int type)
@@ -292,19 +304,21 @@ struct posix_acl *ocfs2_iop_get_acl(stru
 	struct ocfs2_super *osb;
 	struct buffer_head *di_bh = NULL;
 	struct posix_acl *acl;
-	int ret = -EAGAIN;
+	int ret;
 
 	osb = OCFS2_SB(inode->i_sb);
 	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
 		return NULL;
-
-	ret = ocfs2_read_inode_block(inode, &di_bh);
-	if (ret < 0)
+	ret = ocfs2_inode_lock(inode, &di_bh, 0);
+	if (ret < 0) {
+		if (ret != -ENOENT)
+			mlog_errno(ret);
 		return ERR_PTR(ret);
+	}
 
 	acl = ocfs2_get_acl_nolock(inode, type, di_bh);
 
+	ocfs2_inode_unlock(inode, 0);
 	brelse(di_bh);
