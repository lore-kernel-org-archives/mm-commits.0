From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm_request_all_locks-should-deal-with-the-status-sent-from-target-node.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:41:23 -0700
Message-ID: <523218e3.EPDTZkgwiqmcSmX5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab3ILTlY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:41:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, xuejiufei@huawei.com

Subject: [merged] ocfs2-dlm_request_all_locks-should-deal-with-the-status-sent-from-target-node.patch removed from -mm tree
To: xuejiufei@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:41:23 -0700


The patch titled
     Subject: ocfs2: dlm_request_all_locks() should deal with the status sent from target node
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm_request_all_locks-should-deal-with-the-status-sent-from-target-node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: dlm_request_all_locks() should deal with the status sent from target node

dlm_request_all_locks() should deal with the status sent from target node
if DLM_LOCK_REQUEST_MSG is sent successfully, or recovery master will fall
into endless loop, waiting for other nodes to send locks and
DLM_RECO_DATA_DONE_MSG to me.

        NodeA                                  NodeB
                                     selected as recovery master
                                     dlm_remaster_locks()
                                     ->dlm_request_all_locks()
                                     send DLM_LOCK_REQUEST_MSG to nodeA

It happened that NodeA cannot alloc memory when it processes this message.
 dlm_request_all_locks_handler() do not queue dlm_request_all_locks_worker
and returns -ENOMEM.  It will never send locks andDLM_RECO_DATA_DONE_MSG
to NodeB.

                                    NodeB do not deal with the status
                                    sent from nodeA, and will fall in
                                    endless loop waiting for the
                                    recovery state of NodeA to be
                                    changed.

Signed-off-by: joyce <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Jeff Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm_request_all_locks-should-deal-with-the-status-sent-from-target-node fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm_request_all_locks-should-deal-with-the-status-sent-from-target-node
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -787,6 +787,7 @@ static int dlm_request_all_locks(struct
 {
 	struct dlm_lock_request lr;
 	int ret;
+	int status;
 
 	mlog(0, "\n");
 
@@ -800,13 +801,15 @@ static int dlm_request_all_locks(struct
 
 	// send message
 	ret = o2net_send_message(DLM_LOCK_REQUEST_MSG, dlm->key,
-				 &lr, sizeof(lr), request_from, NULL);
+				 &lr, sizeof(lr), request_from, &status);
 
 	/* negative status is handled by caller */
 	if (ret < 0)
 		mlog(ML_ERROR, "%s: Error %d send LOCK_REQUEST to node %u "
 		     "to recover dead node %u\n", dlm->name, ret,
 		     request_from, dead_node);
+	else
+		ret = status;
 	// return from here, then
 	// sleep until all received or error
 	return ret;
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

origin.patch

