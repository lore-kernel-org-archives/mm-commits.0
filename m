From: akpm@linux-foundation.org
Subject: +
 ocfs2-race-between-umount-and-unfinished-remastering-during-recovery.patch
 added to -mm tree
Date: Thu, 17 Jul 2014 14:09:01 -0700
Message-ID: <53c83b6d.yCiuamNOk++7eDUh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:42504 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbaGQVJC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jul 2014 17:09:02 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so264201oig.3
        for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2014 14:09:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tariq.x.saeed@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: race between umount and unfinished remastering during recovery
has been added to the -mm tree.  Its filename is
     ocfs2-race-between-umount-and-unfinished-remastering-during-recovery.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-race-between-umount-and-unfinished-remastering-during-recovery.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-race-between-umount-and-unfinished-remastering-during-recovery.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-race-between-umount-and-unfinished-remastering-during-recovery.patch

