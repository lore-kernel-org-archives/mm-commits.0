From: akpm@linux-foundation.org
Subject: + ocfs2-fix-cluster-hang-after-a-node-dies.patch added to -mm
 tree
Date: Tue, 17 Oct 2017 15:40:50 -0700
Message-ID: <59e686f2.uUIYE0yvnX2sSn/v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58226 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753242AbdJQWkw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 18:40:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, v.mayatskih@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix cluster hang after a node dies
has been added to the -mm tree.  Its filename is
     ocfs2-fix-cluster-hang-after-a-node-dies.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-cluster-hang-after-a-node-dies.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-cluster-hang-after-a-node-dies.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Changwei Ge <ge.changwei@h3c.com>
Subject: ocfs2: fix cluster hang after a node dies

When a node dies, other live nodes have to choose a new master for an
existed lock resource mastered by the dead node.

As for ocfs2/dlm implementation, this is done by function -
dlm_move_lockres_to_recovery_list which marks those lock rsources as
DLM_LOCK_RES_RECOVERING and manages them via a list from which DLM changes
lock resource's master later.

So without invoking dlm_move_lockres_to_recovery_list, no master will be
choosed after dlm recovery accomplishment since no lock resource can be
found through ::resource list.

What's worse is that if DLM_LOCK_RES_RECOVERING is not marked for lock
resources mastered a dead node, it will break up synchronization among
nodes.

So invoke dlm_move_lockres_to_recovery_list again.

Fixs: 'commit ee8f7fcbe638 ("ocfs2/dlm: continue to purge recovery lockres when recovery master goes down")'
Link: http://lkml.kernel.org/r/63ADC13FD55D6546B7DECE290D39E373CED6E0F9@H3CMLB14-EX.srv.huawei-3com.com
Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
Reported-by: Vitaly Mayatskih <v.mayatskih@gmail.com>
Tested-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-fix-cluster-hang-after-a-node-dies fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-fix-cluster-hang-after-a-node-dies
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -2419,6 +2419,7 @@ static void dlm_do_local_recovery_cleanu
 					dlm_lockres_put(res);
 					continue;
 				}
+				dlm_move_lockres_to_recovery_list(dlm, res);
 			} else if (res->owner == dlm->node_num) {
 				dlm_free_dead_locks(dlm, res, dead_node);
 				__dlm_lockres_calc_usage(dlm, res);
_

Patches currently in -mm which might be from ge.changwei@h3c.com are

ocfs2-fix-cluster-hang-after-a-node-dies.patch

