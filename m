From: akpm@linux-foundation.org
Subject: +
 ocfs2-dlm-wait-until-dlm_lock_res_setref_inprog-is-cleared-in-dlm_deref_lockres_worker.patch added to -mm tree
Date: Wed, 09 Dec 2015 16:15:14 -0800
Message-ID: <5668c412.E7EhOnzyGDyfYVXz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbbLJAPP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Dec 2015 19:15:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiangyiwen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: wait until DLM_LOCK_RES_SETREF_INPROG is cleared in dlm_deref_lockres_worker
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-wait-until-dlm_lock_res_setref_inprog-is-cleared-in-dlm_deref_lockres_worker.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-wait-until-dlm_lock_res_setref_inprog-is-cleared-in-dlm_deref_lockres_worker.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-wait-until-dlm_lock_res_setref_inprog-is-cleared-in-dlm_deref_lockres_worker.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2/dlm: wait until DLM_LOCK_RES_SETREF_INPROG is cleared in dlm_deref_lockres_worker

commit f3f854648de6 ("ocfs2_dlm: Ensure correct ordering of set/clear
refmap bit on lockres") still exists a race which can't ensure the
ordering is exactly correct.

Node1               Node2                    Node3
umount, migrate
lockres to Node2
                    migrate finished,
                    send migrate request
                    to Node3
                                              received migrate request,
                                              create a migration_mle,
                                              respond to Node2.
                    set DLM_LOCK_RES_SETREF_INPROG
                    and send assert master to
                    Node3
                                              delete migration_mle in
                                              assert_master_handler,
                                              Node3 umount without response
                                              dlm_thread purge
                                              this lockres, send drop
                                              deref message to Node2
                    found the flag of
                    DLM_LOCK_RES_SETREF_INPROG
                    is set, dispatch
                    dlm_deref_lockres_worker to
                    clear refmap, but in function of
                    dlm_deref_lockres_worker,
                    only if node in refmap it wait
                    DLM_LOCK_RES_SETREF_INPROG
                    to be cleared. So worker is
                    done successfully

                                              purge lockres, send
                                              assert master response
                                              to Node1, and finish umount
                    set Node3 in refmap, and it
                    won't be cleared forever, thus
                    lead to umount hung

so wait until DLM_LOCK_RES_SETREF_INPROG is cleared in
dlm_deref_lockres_worker.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-wait-until-dlm_lock_res_setref_inprog-is-cleared-in-dlm_deref_lockres_worker fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-wait-until-dlm_lock_res_setref_inprog-is-cleared-in-dlm_deref_lockres_worker
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2388,8 +2388,8 @@ static void dlm_deref_lockres_worker(str
 
 	spin_lock(&res->spinlock);
 	BUG_ON(res->state & DLM_LOCK_RES_DROPPING_REF);
+	__dlm_wait_on_lockres_flags(res, DLM_LOCK_RES_SETREF_INPROG);
 	if (test_bit(node, res->refmap)) {
-		__dlm_wait_on_lockres_flags(res, DLM_LOCK_RES_SETREF_INPROG);
 		dlm_lockres_clear_refmap_bit(dlm, res, node);
 		cleared = 1;
 	}
_

Patches currently in -mm which might be from jiangyiwen@huawei.com are

ocfs2-dlm-wait-until-dlm_lock_res_setref_inprog-is-cleared-in-dlm_deref_lockres_worker.patch
ocfs2-avoid-occurring-deadlock-by-changing-ocfs2_wq-from-global-to-local.patch
ocfs2-solve-a-problem-of-crossing-the-boundary-in-updating-backups.patch

