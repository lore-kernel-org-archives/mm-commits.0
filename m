From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-disallow-node-joining-when-recovery-is-on-going.patch removed
 from -mm tree
Date: Thu, 05 Jun 2014 12:42:52 -0700
Message-ID: <5390c83c.d2+3RxsXpZ+KKDNO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaFETmx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:42:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, xuejiufei@huawei.com

Subject: [merged] ocfs2-dlm-disallow-node-joining-when-recovery-is-on-going.patch removed from -mm tree
To: xuejiufei@huawei.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:42:52 -0700


The patch titled
     Subject: ocfs2/dlm: disallow node joining when recovery is on going
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-disallow-node-joining-when-recovery-is-on-going.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2/dlm: disallow node joining when recovery is on going

We found a race situation when dlm recovery and node joining occurs
simultaneously if the network state is bad.

N1                                      N4
start joining dlm and send
query join to all live nodes
                            set joining node to N1, return OK
send query join to other
live nodes and it may take
a while

call dlm_send_join_assert()
to send assert join message
when N2 is down, so keep
trying to send message to N2
until find N2 is down

send assert join message to
N3, but connection is down
with N3, so it may take a
while
                            become the recovery master for N2
                            and send begin reco message to other
                            nodes in domain map but no N1
connection with N3 is rebuild,
then send assert join to N4
                            call dlm_assert_joined_handler(),
                            add N1 to domain_map

                            dlm recovery done, send finalize message
                            to nodes in domain map, including N1
receiving finalize message,
trigger the BUG() because
recovery master mismatch.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdomain.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmdomain.c~ocfs2-dlm-disallow-node-joining-when-recovery-is-on-going fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-dlm-disallow-node-joining-when-recovery-is-on-going
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -959,6 +959,14 @@ static int dlm_assert_joined_handler(str
 		 * domain. Set him in the map and clean up our
 		 * leftover join state. */
 		BUG_ON(dlm->joining_node != assert->node_idx);
+
+		if (dlm->reco.state & DLM_RECO_STATE_ACTIVE) {
+			mlog(0, "dlm recovery is ongoing, disallow join\n");
+			spin_unlock(&dlm->spinlock);
+			spin_unlock(&dlm_domain_lock);
+			return -EAGAIN;
+		}
+
 		set_bit(assert->node_idx, dlm->domain_map);
 		clear_bit(assert->node_idx, dlm->exit_domain_map);
 		__dlm_set_joining_node(dlm, DLM_LOCK_RES_OWNER_UNKNOWN);
@@ -1517,6 +1525,7 @@ static int dlm_send_one_join_assert(stru
 				    unsigned int node)
 {
 	int status;
+	int ret;
 	struct dlm_assert_joined assert_msg;
 
 	mlog(0, "Sending join assert to node %u\n", node);
@@ -1528,11 +1537,13 @@ static int dlm_send_one_join_assert(stru
 
 	status = o2net_send_message(DLM_ASSERT_JOINED_MSG, DLM_MOD_KEY,
 				    &assert_msg, sizeof(assert_msg), node,
-				    NULL);
+				    &ret);
 	if (status < 0)
 		mlog(ML_ERROR, "Error %d when sending message %u (key 0x%x) to "
 		     "node %u\n", status, DLM_ASSERT_JOINED_MSG, DLM_MOD_KEY,
 		     node);
+	else
+		status = ret;
 
 	return status;
 }
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

origin.patch
ocfs2-revert-the-patch-fix-null-pointer-dereference-when-dismount-and-ocfs2rec-simultaneously.patch
ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
linux-next.patch

