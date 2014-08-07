From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-race-between-umount-and-unfinished-remastering-during-recovery.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:02:43 -0700
Message-ID: <53e3db63.BbGcnx5YBK5YPAYJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:38397 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbaHGUCo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:02:44 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so1175157pab.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:02:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tariq.x.saeed@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: race between umount and unfinished remastering during recovery
has been removed from the -mm tree.  Its filename was
     ocfs2-race-between-umount-and-unfinished-remastering-during-recovery.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tariq Saeed <tariq.x.saeed@oracle.com>
Subject: ocfs2: race between umount and unfinished remastering during recovery

Orabug: 19074140

When umount is issued during recovery on the new master that has not
finished remastering locks, it triggers BUG() in
dlm_send_mig_lockres_msg().  Here is the situation:

1) node A has a lock on resource X mastered by node B.

2) node B dies ->  node A sets recovering flag for res X

3) Node C becomes the new master for resources owned by the
   dead node and is remastering locks of the dead node but
   has not finished the remastering process yet.

4) umount is issued on node C.

5) During processing of umount, ignoring unfished recovery,
   node C attempts to migrate resource X to node A.

6) node A finds res X in DLM_LOCK_RES_RECOVERING state, considers
   it a logic error and sends back -EFAULT.

7) node C asserts BUG() upon seeing EFAULT resp from node B.

Fix is to delay migrating res X  till remastering is finished
at which point recovering flag will be cleared on both A and C.

Signed-off-by: Tariq Saeed <tariq.x.saeed@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-race-between-umount-and-unfinished-remastering-during-recovery fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-race-between-umount-and-unfinished-remastering-during-recovery
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2405,6 +2405,10 @@ static int dlm_is_lockres_migrateable(st
 	if (res->state & DLM_LOCK_RES_MIGRATING)
 		return 0;
 
+	/* delay migration when the lockres is in RECOCERING state */
+	if (res->state & DLM_LOCK_RES_RECOVERING)
+		return 0;
+
 	if (res->owner != dlm->node_num)
 		return 0;
 
_

Patches currently in -mm which might be from tariq.x.saeed@oracle.com are

origin.patch

