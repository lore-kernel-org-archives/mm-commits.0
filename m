From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-delay-migration-when-the-lockres-is-in-migration-state.patch removed
 from -mm tree
Date: Wed, 13 Nov 2013 12:37:20 -0800
Message-ID: <5283e300.JhQ2+kf60Jly2U/h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42439 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3KMUhV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:37:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tariq.x.saeed@oracle.com, srinivas.eeda@oracle.com, mfasheh@suse.com, jlbec@evilplan.org, xuejiufei@huawei.com

Subject: [merged] ocfs2-delay-migration-when-the-lockres-is-in-migration-state.patch removed from -mm tree
To: xuejiufei@huawei.com,jlbec@evilplan.org,mfasheh@suse.com,srinivas.eeda@oracle.com,tariq.x.saeed@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:37:20 -0800


The patch titled
     Subject: ocfs2: delay migration when the lockres is in migration state
has been removed from the -mm tree.  Its filename was
     ocfs2-delay-migration-when-the-lockres-is-in-migration-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: delay migration when the lockres is in migration state

We trigger a bug in __dlm_lockres_reserve_ast() when we parallel umount 4
nodes.  The situation is as follows:

1) Node A migrate all lockres it owned(eg.  lockres A) to other nodes
   say node B when it umounts.

2) Receiving MIG_LOCKRES message from A, Node B masters the lockres A
   with DLM_LOCK_RES_MIGRATING state set.

3) Then we umount ocfs2 on node B.  It also should migrate lockres A to
   another node, say node C.  But now, DLM_LOCK_RES_MIGRATING state of
   lockers A is not cleared.  Node B triggered the BUG on lockres with
   state DLM_LOCK_RES_MIGRATING.

Signed-off-by: Xuejiufei <xuejiufei@huawei.com>
Signed-off-by: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Tariq Saeed <tariq.x.saeed@oracle.com>
Cc: Srinivas Eeda <srinivas.eeda@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-delay-migration-when-the-lockres-is-in-migration-state fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-delay-migration-when-the-lockres-is-in-migration-state
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2354,6 +2354,10 @@ static int dlm_is_lockres_migrateable(st
 
 	assert_spin_locked(&res->spinlock);
 
+	/* delay migration when the lockres is in MIGRATING state */
+	if (res->state & DLM_LOCK_RES_MIGRATING)
+		return 0;
+
 	if (res->owner != dlm->node_num)
 		return 0;
 
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

origin.patch

