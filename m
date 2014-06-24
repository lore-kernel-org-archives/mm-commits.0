From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-fix-misuse-of-list_move_tail-in-dlm_run_purge_list.patch removed
 from -mm tree
Date: Tue, 24 Jun 2014 12:02:59 -0700
Message-ID: <53a9cb63.JY8wvji85oI6Lm+X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35673 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbaFXTDA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 15:03:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jiangyiwen@huawei.com, jlbec@evilplan.org, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: fix misuse of list_move_tail() in dlm_run_purge_list()
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-fix-misuse-of-list_move_tail-in-dlm_run_purge_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2/dlm: fix misuse of list_move_tail() in dlm_run_purge_list()

When a lockres in purge list but is still in use, it should be moved to
the tail of purge list.  dlm_thread will continue to check next lockres in
purge list.  However, code list_move_tail(&dlm->purge_list,
&lockres->purge) will do *no* movements, so dlm_thread will purge the same
lockres in this loop again and again.  If it is in use for a long time,
other lockres will not be processed.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmthread.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmthread.c~ocfs2-dlm-fix-misuse-of-list_move_tail-in-dlm_run_purge_list fs/ocfs2/dlm/dlmthread.c
--- a/fs/ocfs2/dlm/dlmthread.c~ocfs2-dlm-fix-misuse-of-list_move_tail-in-dlm_run_purge_list
+++ a/fs/ocfs2/dlm/dlmthread.c
@@ -264,7 +264,7 @@ static void dlm_run_purge_list(struct dl
 			     "used %d, state %d\n", dlm->name,
 			     lockres->lockname.len, lockres->lockname.name,
 			     !unused, lockres->state);
-			list_move_tail(&dlm->purge_list, &lockres->purge);
+			list_move_tail(&lockres->purge, &dlm->purge_list);
 			spin_unlock(&lockres->spinlock);
 			continue;
 		}
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

origin.patch
ocfs2-remove-convertion-of-total_backoff-in-dlm_join_domain.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch

