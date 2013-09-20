From: akpm@linux-foundation.org
Subject: +
 ocfs2-delay-migration-when-the-lockres-is-in-migration-state.patch added to -mm tree
Date: Fri, 20 Sep 2013 13:50:15 -0700
Message-ID: <523cb507.fb2pYLOuCrNZ86rl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab3ITUuQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Sep 2013 16:50:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, xuejiufei@huawei.com

Subject: + ocfs2-delay-migration-when-the-lockres-is-in-migration-state.patch added to -mm tree
To: xuejiufei@huawei.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Fri, 20 Sep 2013 13:50:15 -0700


The patch titled
     Subject: ocfs2: delay migration when the lockres is in migration state
has been added to the -mm tree.  Its filename is
     ocfs2-delay-migration-when-the-lockres-is-in-migration-state.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-delay-migration-when-the-lockres-is-in-migration-state.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-delay-migration-when-the-lockres-is-in-migration-state.patch

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

ocfs2-skip-locks-in-the-blocked-list.patch
ocfs2-delay-migration-when-the-lockres-is-in-migration-state.patch
linux-next.patch

