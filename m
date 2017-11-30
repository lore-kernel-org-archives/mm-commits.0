From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-give-an-obvious-tip-for-dismatch-cluster-names-v2.patch removed from
 -mm tree
Date: Thu, 30 Nov 2017 14:18:09 -0800
Message-ID: <5a2083a1.n7y1txZIqSDWDQ9l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35386 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750768AbdK3WSL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 17:18:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-give-an-obvious-tip-for-dismatch-cluster-names-v2
has been removed from the -mm tree.  Its filename was
     ocfs2-give-an-obvious-tip-for-dismatch-cluster-names-v2.patch

This patch was dropped because it was folded into ocfs2-give-an-obvious-tip-for-dismatch-cluster-names.patch

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject: ocfs2-give-an-obvious-tip-for-dismatch-cluster-names-v2

Compare with initial version, we only print this error tip when the user
uses pcmk stack.  since in o2cb stack, the user will not meet this error.

Link: http://lkml.kernel.org/r/1495419305-3780-1-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/super.c~ocfs2-give-an-obvious-tip-for-dismatch-cluster-names-v2 fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-give-an-obvious-tip-for-dismatch-cluster-names-v2
+++ a/fs/ocfs2/super.c
@@ -1844,7 +1844,7 @@ static int ocfs2_mount_volume(struct sup
 	status = ocfs2_dlm_init(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		if (status == -EBADR)
+		if (status == -EBADR && ocfs2_userspace_stack(osb))
 			mlog(ML_ERROR, "couldn't mount because cluster name on"
 			" disk does not match the running cluster name.\n");
 		goto leave;
_

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-get-rid-of-ocfs2_is_o2cb_active-function.patch
ocfs2-give-an-obvious-tip-for-dismatch-cluster-names.patch
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

