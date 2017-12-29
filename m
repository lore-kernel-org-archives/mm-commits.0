From: akpm@linux-foundation.org
Subject: +
 ocfs2-return-erofs-to-mountocfs2-if-inode-block-is-invalid.patch added to
 -mm tree
Date: Thu, 28 Dec 2017 16:12:40 -0800
Message-ID: <5a458878.1TmL3LMnRqVLwGE0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43672 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751253AbdL2AMl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Dec 2017 19:12:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: piaojun@huawei.com, alex.chen@huawei.com, ge.changwei@h3c.com, ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: return -EROFS to mount.ocfs2 if inode block is invalid
has been added to the -mm tree.  Its filename is
     ocfs2-return-erofs-to-mountocfs2-if-inode-block-is-invalid.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-return-erofs-to-mountocfs2-if-inode-block-is-invalid.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-return-erofs-to-mountocfs2-if-inode-block-is-invalid.patch

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
Subject: ocfs2: return -EROFS to mount.ocfs2 if inode block is invalid

If metadata is corrupted such as 'invalid inode block', we will get failed
by calling 'mount()' and then set filesystem readonly as below:

ocfs2_mount
  ocfs2_initialize_super
    ocfs2_init_global_system_inodes
      ocfs2_iget
        ocfs2_read_locked_inode
          ocfs2_validate_inode_block
	    ocfs2_error
	      ocfs2_handle_error
	        ocfs2_set_ro_flag(osb, 0);  // set readonly

In this situation we need return -EROFS to 'mount.ocfs2', so that user can
fix it by fsck.  And then mount again.  In addition, 'mount.ocfs2' should
be updated correspondingly as it only return 1 for all errno.  And I will
post a patch for 'mount.ocfs2' too.

Link: http://lkml.kernel.org/r/5A4302FA.2010606@huawei.com
Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
Reviewed-by: Changwei Ge <ge.changwei@h3c.com>
Reviewed-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/super.c~ocfs2-return-erofs-to-mountocfs2-if-inode-block-is-invalid fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-return-erofs-to-mountocfs2-if-inode-block-is-invalid
+++ a/fs/ocfs2/super.c
@@ -474,9 +474,8 @@ static int ocfs2_init_global_system_inod
 		new = ocfs2_get_system_file_inode(osb, i, osb->slot_num);
 		if (!new) {
 			ocfs2_release_system_inodes(osb);
-			status = -EINVAL;
+			status = ocfs2_is_soft_readonly(osb) ? -EROFS : -EINVAL;
 			mlog_errno(status);
-			/* FIXME: Should ERROR_RO_FS */
 			mlog(ML_ERROR, "Unable to load system inode %d, "
 			     "possibly corrupt fs?", i);
 			goto bail;
@@ -505,7 +504,7 @@ static int ocfs2_init_local_system_inode
 		new = ocfs2_get_system_file_inode(osb, i, osb->slot_num);
 		if (!new) {
 			ocfs2_release_system_inodes(osb);
-			status = -EINVAL;
+			status = ocfs2_is_soft_readonly(osb) ? -EROFS : -EINVAL;
 			mlog(ML_ERROR, "status=%d, sysfile=%d, slot=%d\n",
 			     status, i, osb->slot_num);
 			goto bail;
_

Patches currently in -mm which might be from piaojun@huawei.com are

ocfs2-return-erofs-to-mountocfs2-if-inode-block-is-invalid.patch

