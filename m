From: akpm@linux-foundation.org
Subject: +
 ocfs2-dlm-fix-misuse-of-list_move_tail-in-dlm_run_purge_list.patch added to -mm tree
Date: Tue, 17 Jun 2014 15:50:44 -0700
Message-ID: <53a0c644.5NtBLINEzhQNQLiE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965516AbaFQWup (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jun 2014 18:50:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.de, jlbec@evilplan.org, jiangyiwen@huawei.com, xuejiufei@huawei.com


The patch titled
     Subject: ocfs2/dlm: fix misuse of list_move_tail() in dlm_run_purge_list()
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-fix-misuse-of-list_move_tail-in-dlm_run_purge_list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-fix-misuse-of-list_move_tail-in-dlm_run_purge_list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-fix-misuse-of-list_move_tail-in-dlm_run_purge_list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-revert-the-patch-fix-null-pointer-dereference-when-dismount-and-ocfs2rec-simultaneously.patch
ocfs2-dlm-fix-misuse-of-list_move_tail-in-dlm_run_purge_list.patch
ocfs2-remove-convertion-of-total_backoff-in-dlm_join_domain.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch

