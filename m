From: akpm@linux-foundation.org
Subject: + ocfs2-dlm-fix-recovery-hung.patch added to -mm tree
Date: Fri, 21 Feb 2014 13:50:26 -0800
Message-ID: <5307ca22.CcXMIsFLcqY7ZWYD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaBUVu1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 16:50:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wen.gang.wang@oracle.com, stable@vger.kernel.org, srinivas.eeda@oracle.com, mfasheh@suse.com, jlbec@evilplan.org, junxiao.bi@oracle.com

Subject: + ocfs2-dlm-fix-recovery-hung.patch added to -mm tree
To: junxiao.bi@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,srinivas.eeda@oracle.com,stable@vger.kernel.org,wen.gang.wang@oracle.com
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 13:50:26 -0800


The patch titled
     Subject: ocfs2: dlm: fix recovery hung
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-fix-recovery-hung.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-fix-recovery-hung.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-fix-recovery-hung.patch

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
Subject: ocfs2: dlm: fix recovery hung

There is a race window in dlm_do_recovery() between dlm_remaster_locks()
and dlm_reset_recovery() when the recovery master nearly finish the
recovery process for a dead node.  After the master sends FINALIZE_RECO
message in dlm_remaster_locks(), another node may become the recovery
master for another dead node, and then send the BEGIN_RECO message to all
the nodes included the old master, in the handler of this message
dlm_begin_reco_handler() of old master, dlm->reco.dead_node and
dlm->reco.new_master will be set to the second dead node and the new
master, then in dlm_reset_recovery(), these two variables will be reset to
default value.  This will cause new recovery master can not finish the
recovery process and hung, at last the whole cluster will hung for
recovery.

old recovery master:                                 new recovery master:
dlm_remaster_locks()
                                                  become recovery master for
                                                  another dead node.
                                                  dlm_send_begin_reco_message()
dlm_begin_reco_handler()
{
 if (dlm->reco.state & DLM_RECO_STATE_FINALIZE) {
  return -EAGAIN;
 }
 dlm_set_reco_master(dlm, br->node_idx);
 dlm_set_reco_dead_node(dlm, br->dead_node);
}
dlm_reset_recovery()
{
 dlm_set_reco_dead_node(dlm, O2NM_INVALID_NODE_NUM);
 dlm_set_reco_master(dlm, O2NM_INVALID_NODE_NUM);
}
                                                  will hang in dlm_remaster_locks() for
                                                  request dlm locks info

Before send FINALIZE_RECO message, recovery master should set
DLM_RECO_STATE_FINALIZE for itself and clear it after the recovery done,
this can break the race windows as the BEGIN_RECO messages will not be
handled before DLM_RECO_STATE_FINALIZE flag is cleared.

A similar race may happen between new recovery master and normal node
which is in dlm_finalize_reco_handler(), also fix it.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Reviewed-by: Wengang Wang <wen.gang.wang@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-fix-recovery-hung fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-fix-recovery-hung
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -537,7 +537,10 @@ master_here:
 		/* success!  see if any other nodes need recovery */
 		mlog(0, "DONE mastering recovery of %s:%u here(this=%u)!\n",
 		     dlm->name, dlm->reco.dead_node, dlm->node_num);
-		dlm_reset_recovery(dlm);
+		spin_lock(&dlm->spinlock);
+		__dlm_reset_recovery(dlm);
+		dlm->reco.state &= ~DLM_RECO_STATE_FINALIZE;
+		spin_unlock(&dlm->spinlock);
 	}
 	dlm_end_recovery(dlm);
 
@@ -695,6 +698,14 @@ static int dlm_remaster_locks(struct dlm
 		if (all_nodes_done) {
 			int ret;
 
+			/* Set this flag on recovery master to avoid
+			 * a new recovery for another dead node start
+			 * before the recovery is not done. That may
+			 * cause recovery hung.*/
+			spin_lock(&dlm->spinlock);
+			dlm->reco.state |= DLM_RECO_STATE_FINALIZE;
+			spin_unlock(&dlm->spinlock);
+
 			/* all nodes are now in DLM_RECO_NODE_DATA_DONE state
 	 		 * just send a finalize message to everyone and
 	 		 * clean up */
@@ -2882,8 +2893,8 @@ int dlm_finalize_reco_handler(struct o2n
 				BUG();
 			}
 			dlm->reco.state &= ~DLM_RECO_STATE_FINALIZE;
+			__dlm_reset_recovery(dlm);
 			spin_unlock(&dlm->spinlock);
-			dlm_reset_recovery(dlm);
 			dlm_kick_recovery_thread(dlm);
 			break;
 		default:
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-dlm-fix-recovery-hung.patch

