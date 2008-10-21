From: akpm@linux-foundation.org
Subject: + freezer_cg-fix-improper-bug_on-causing-oops.patch added to -mm tree
Date: Tue, 21 Oct 2008 13:58:22 -0700
Message-ID: <200810212058.m9LKwMHI018387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752499AbYJUU75 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 16:59:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, clg@fr.ibm.com


The patch titled
     freezer_cg: fix improper BUG_ON() causing oops
has been added to the -mm tree.  Its filename is
     freezer_cg-fix-improper-bug_on-causing-oops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: freezer_cg: fix improper BUG_ON() causing oops
From: Li Zefan <lizf@cn.fujitsu.com>

The BUG_ON() should be protected by freezer->lock, otherwise it can be
triggered easily when a task has been unfreezed but the corresponding
cgroup hasn't been changed to FROZEN state.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup_freezer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/cgroup_freezer.c~freezer_cg-fix-improper-bug_on-causing-oops kernel/cgroup_freezer.c
--- a/kernel/cgroup_freezer.c~freezer_cg-fix-improper-bug_on-causing-oops
+++ a/kernel/cgroup_freezer.c
@@ -190,8 +190,9 @@ static void freezer_fork(struct cgroup_s
 	freezer = task_freezer(task);
 	task_unlock(task);
 
-	BUG_ON(freezer->state == CGROUP_FROZEN);
 	spin_lock_irq(&freezer->lock);
+	BUG_ON(freezer->state == CGROUP_FROZEN);
+
 	/* Locking avoids race with FREEZING -> THAWED transitions. */
 	if (freezer->state == CGROUP_FREEZING)
 		freeze_task(task, true);
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
freezer_cg-fix-improper-bug_on-causing-oops.patch
freezer_cg-remove-redundant-check-in-freezer_can_attach.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch
freezer_cg-simplify-freezer_change_state.patch
cgroups-tiny-cleanups.patch

