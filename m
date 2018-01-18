From: akpm@linux-foundation.org
Subject: +
 ocfs2-acl-use-ip_xattr_sem-to-protect-getting-extended-attribute.patch
 added to -mm tree
Date: Thu, 18 Jan 2018 11:32:34 -0800
Message-ID: <5a60f652.ivaOT9fZDmWLL510%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48784 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932457AbeARTcg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Jan 2018 14:32:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: piaojun@huawei.com, alex.chen@huawei.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/acl: use 'ip_xattr_sem' to protect getting extended attribute
has been added to the -mm tree.  Its filename is
     ocfs2-acl-use-ip_xattr_sem-to-protect-getting-extended-attribute.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-acl-use-ip_xattr_sem-to-protect-getting-extended-attribute.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-acl-use-ip_xattr_sem-to-protect-getting-extended-attribute.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: piaojun <piaojun@huawei.com>
Subject: ocfs2/acl: use 'ip_xattr_sem' to protect getting extended attribute

The race between *set_acl and *get_acl will cause getting incomplete xattr
data as below:

processA                                    processB

ocfs2_set_acl
  ocfs2_xattr_set
    __ocfs2_xattr_set_handle

                                            ocfs2_get_acl_nolock
                                              ocfs2_xattr_get_nolock:

processB may get incomplete xattr data if processA hasn't set_acl done. 
So we should use 'ip_xattr_sem' to protect getting extended attribute in
ocfs2_get_acl_nolock(), as other processes could be changing it
concurrently.

Link: http://lkml.kernel.org/r/5A5DDCFF.7030001@huawei.com
Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/acl.c   |    6 ++++++
 fs/ocfs2/xattr.c |    2 ++
 2 files changed, 8 insertions(+)

diff -puN fs/ocfs2/acl.c~ocfs2-acl-use-ip_xattr_sem-to-protect-getting-extended-attribute fs/ocfs2/acl.c
--- a/fs/ocfs2/acl.c~ocfs2-acl-use-ip_xattr_sem-to-protect-getting-extended-attribute
+++ a/fs/ocfs2/acl.c
@@ -311,7 +311,9 @@ struct posix_acl *ocfs2_iop_get_acl(stru
 	if (had_lock < 0)
 		return ERR_PTR(had_lock);
 
+	down_read(&OCFS2_I(inode)->ip_xattr_sem);
 	acl = ocfs2_get_acl_nolock(inode, type, di_bh);
+	up_read(&OCFS2_I(inode)->ip_xattr_sem);
 
 	ocfs2_inode_unlock_tracker(inode, 0, &oh, had_lock);
 	brelse(di_bh);
@@ -330,7 +332,9 @@ int ocfs2_acl_chmod(struct inode *inode,
 	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
 		return 0;
 
+	down_read(&OCFS2_I(inode)->ip_xattr_sem);
 	acl = ocfs2_get_acl_nolock(inode, ACL_TYPE_ACCESS, bh);
+	up_read(&OCFS2_I(inode)->ip_xattr_sem);
 	if (IS_ERR(acl) || !acl)
 		return PTR_ERR(acl);
 	ret = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
@@ -361,8 +365,10 @@ int ocfs2_init_acl(handle_t *handle,
 
 	if (!S_ISLNK(inode->i_mode)) {
 		if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
+			down_read(&OCFS2_I(dir)->ip_xattr_sem);
 			acl = ocfs2_get_acl_nolock(dir, ACL_TYPE_DEFAULT,
 						   dir_bh);
+			up_read(&OCFS2_I(dir)->ip_xattr_sem);
 			if (IS_ERR(acl))
 				return PTR_ERR(acl);
 		}
diff -puN fs/ocfs2/xattr.c~ocfs2-acl-use-ip_xattr_sem-to-protect-getting-extended-attribute fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~ocfs2-acl-use-ip_xattr_sem-to-protect-getting-extended-attribute
+++ a/fs/ocfs2/xattr.c
@@ -638,9 +638,11 @@ int ocfs2_calc_xattr_init(struct inode *
 						     si->value_len);
 
 	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
+		down_read(&OCFS2_I(dir)->ip_xattr_sem);
 		acl_len = ocfs2_xattr_get_nolock(dir, dir_bh,
 					OCFS2_XATTR_INDEX_POSIX_ACL_DEFAULT,
 					"", NULL, 0);
+		up_read(&OCFS2_I(dir)->ip_xattr_sem);
 		if (acl_len > 0) {
 			a_size = ocfs2_xattr_entry_real_size(0, acl_len);
 			if (S_ISDIR(mode))
_

Patches currently in -mm which might be from piaojun@huawei.com are

ocfs2-return-erofs-to-mountocfs2-if-inode-block-is-invalid.patch
ocfs2-xattr-assign-errno-to-ret-in-ocfs2_calc_xattr_init.patch
ocfs2-acl-use-ip_xattr_sem-to-protect-getting-extended-attribute.patch

