From: akpm@linux-foundation.org
Subject: + freezer_cg-use-thaw_process-in-unfreeze_cgroup.patch added to -mm tree
Date: Tue, 21 Oct 2008 13:58:26 -0700
Message-ID: <200810212058.m9LKwQt1018401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752469AbYJUU6g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 16:58:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, clg@fr.ibm.com


The patch titled
     freezer_cg: use thaw_process() in unfreeze_cgroup()
has been added to the -mm tree.  Its filename is
     freezer_cg-use-thaw_process-in-unfreeze_cgroup.patch

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
Subject: freezer_cg: use thaw_process() in unfreeze_cgroup()
From: Li Zefan <lizf@cn.fujitsu.com>

Don't duplicate the implementation of thaw_process().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup_freezer.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff -puN kernel/cgroup_freezer.c~freezer_cg-use-thaw_process-in-unfreeze_cgroup kernel/cgroup_freezer.c
--- a/kernel/cgroup_freezer.c~freezer_cg-use-thaw_process-in-unfreeze_cgroup
+++ a/kernel/cgroup_freezer.c
@@ -275,25 +275,18 @@ static int try_to_freeze_cgroup(struct c
 	return num_cant_freeze_now ? -EBUSY : 0;
 }
 
-static int unfreeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
+static void unfreeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
 {
 	struct cgroup_iter it;
 	struct task_struct *task;
 
 	cgroup_iter_start(cgroup, &it);
 	while ((task = cgroup_iter_next(cgroup, &it))) {
-		int do_wake;
-
-		task_lock(task);
-		do_wake = __thaw_process(task);
-		task_unlock(task);
-		if (do_wake)
-			wake_up_process(task);
+		thaw_process(task);
 	}
 	cgroup_iter_end(cgroup, &it);
-	freezer->state = CGROUP_THAWED;
 
-	return 0;
+	freezer->state = CGROUP_THAWED;
 }
 
 static int freezer_change_state(struct cgroup *cgroup,
@@ -320,7 +313,7 @@ static int freezer_change_state(struct c
 		}
 		/* state == FREEZING and goal_state == THAWED, so unfreeze */
 	case CGROUP_FROZEN:
-		retval = unfreeze_cgroup(cgroup, freezer);
+		unfreeze_cgroup(cgroup, freezer);
 		break;
 	default:
 		break;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
freezer_cg-fix-improper-bug_on-causing-oops.patch
freezer_cg-remove-redundant-check-in-freezer_can_attach.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch
freezer_cg-simplify-freezer_change_state.patch
cgroups-tiny-cleanups.patch

