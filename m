From: akpm@linux-foundation.org
Subject: + ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock-v2.patch
 added to -mm tree
Date: Wed, 29 Nov 2017 14:30:39 -0800
Message-ID: <5a1f350f.mBshrdA9Ez+FuvR5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49546 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750890AbdK2Wam (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 17:30:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock-v2
has been added to the -mm tree.  Its filename is
     ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject: ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock-v2

Link: http://lkml.kernel.org/r/1511944612-9629-2-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/ocfs2/dlmglue.c~ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock-v2 fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock-v2
+++ a/fs/ocfs2/dlmglue.c
@@ -1759,8 +1759,7 @@ int ocfs2_try_rw_lock(struct inode *inod
 
 	level = write ? DLM_LOCK_EX : DLM_LOCK_PR;
 
-	status = ocfs2_cluster_lock(OCFS2_SB(inode->i_sb), lockres, level,
-				    DLM_LKF_NOQUEUE, 0);
+	status = ocfs2_cluster_lock(osb, lockres, level, DLM_LKF_NOQUEUE, 0);
 	return status;
 }
 
_

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-get-rid-of-ocfs2_is_o2cb_active-function.patch
ocfs2-give-an-obvious-tip-for-dismatch-cluster-names.patch
ocfs2-give-an-obvious-tip-for-dismatch-cluster-names-v2.patch
ocfs2-move-some-definitions-to-header-file.patch
ocfs2-fix-some-small-problems.patch
ocfs2-add-kobject-for-online-file-check.patch
ocfs2-add-duplicative-ino-number-check.patch
ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock.patch
ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock-v2.patch
ocfs2-add-ocfs2_overwrite_io-function.patch
ocfs2-add-ocfs2_overwrite_io-function-v2.patch
ocfs2-nowait-aio-support.patch
ocfs2-nowait-aio-support-v2.patch

