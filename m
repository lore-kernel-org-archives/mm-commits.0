From: akpm@linux-foundation.org
Subject: [merged] o2dlm-fix-a-race-between-purge-and-master-query.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:55:16 -0800
Message-ID: <5489e894.Kp7b7hjj3WqfUZWK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758404AbaLKSzR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:55:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srinivas.eeda@oracle.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, wen.gang.wang@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: o2dlm: fix a race between purge and master query
has been removed from the -mm tree.  Its filename was
     o2dlm-fix-a-race-between-purge-and-master-query.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Srinivas Eeda <srinivas.eeda@oracle.com>
Subject: ocfs2: o2dlm: fix a race between purge and master query

Node A sends master query request to node B which is the master.  At this
time lockres happens to be on purgelist.  dlm_master_request_handler gets
the dlm spinlock, finds the resource and releases the dlm spin lock. 
Right at this dlm_thread on this node could purge the lockres. 
dlm_master_request_handler can then acquire lockres spinlock and reply to
Node A that node B is the master even though lockres on node B is purged.

The above scenario will now make node A falsely think node B is the master
which is inconsistent.  Further if another node C tries to master the same
resource, every node will respond they are not the master.  Node C then
masters the resource and sends assert master to all nodes.  This will now
make node A crash with the following message.

dlm_assert_master_handler:1831 ERROR: DIE! Mastery assert from 9, but current
owner is 10!

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Reviewed-by: Wengang Wang <wen.gang.wang@oracle.com>
Tested-by: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN fs/ocfs2/dlm/dlmmaster.c~o2dlm-fix-a-race-between-purge-and-master-query fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~o2dlm-fix-a-race-between-purge-and-master-query
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -1460,6 +1460,18 @@ way_up_top:
 
 		/* take care of the easy cases up front */
 		spin_lock(&res->spinlock);
+
+		/*
+		 * Right after dlm spinlock was released, dlm_thread could have
+		 * purged the lockres. Check if lockres got unhashed. If so
+		 * start over.
+		 */
+		if (hlist_unhashed(&res->hash_node)) {
+			spin_unlock(&res->spinlock);
+			dlm_lockres_put(res);
+			goto way_up_top;
+		}
+
 		if (res->state & (DLM_LOCK_RES_RECOVERING|
 				  DLM_LOCK_RES_MIGRATING)) {
 			spin_unlock(&res->spinlock);
_

Patches currently in -mm which might be from srinivas.eeda@oracle.com are

origin.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch

