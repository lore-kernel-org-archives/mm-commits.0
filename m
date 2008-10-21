From: akpm@linux-foundation.org
Subject: + freezer_cg-simplify-freezer_change_state.patch added to -mm tree
Date: Tue, 21 Oct 2008 13:58:30 -0700
Message-ID: <200810212058.m9LKwUsW018423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752000AbYJUU6l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 16:58:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, clg@fr.ibm.com


The patch titled
     freezer_cg: simplify freezer_change_state()
has been added to the -mm tree.  Its filename is
     freezer_cg-simplify-freezer_change_state.patch

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
Subject: freezer_cg: simplify freezer_change_state()
From: Li Zefan <lizf@cn.fujitsu.com>

Just call unfreeze_cgroup() if goal_state == THAWED, and call
try_to_freeze_cgroup() if goal_state == FROZEN.

No behavior has been changed.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup_freezer.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff -puN kernel/cgroup_freezer.c~freezer_cg-simplify-freezer_change_state kernel/cgroup_freezer.c
--- a/kernel/cgroup_freezer.c~freezer_cg-simplify-freezer_change_state
+++ a/kernel/cgroup_freezer.c
@@ -296,27 +296,22 @@ static int freezer_change_state(struct c
 	int retval = 0;
 
 	freezer = cgroup_freezer(cgroup);
+
 	spin_lock_irq(&freezer->lock);
+
 	update_freezer_state(cgroup, freezer);
 	if (goal_state == freezer->state)
 		goto out;
-	switch (freezer->state) {
+
+	switch (goal_state) {
 	case CGROUP_THAWED:
-		retval = try_to_freeze_cgroup(cgroup, freezer);
+		unfreeze_cgroup(cgroup, freezer);
 		break;
-	case CGROUP_FREEZING:
-		if (goal_state == CGROUP_FROZEN) {
-			/* Userspace is retrying after
-			 * "/bin/echo FROZEN > freezer.state" returned -EBUSY */
-			retval = try_to_freeze_cgroup(cgroup, freezer);
-			break;
-		}
-		/* state == FREEZING and goal_state == THAWED, so unfreeze */
 	case CGROUP_FROZEN:
-		unfreeze_cgroup(cgroup, freezer);
+		retval = try_to_freeze_cgroup(cgroup, freezer);
 		break;
 	default:
-		break;
+		BUG();
 	}
 out:
 	spin_unlock_irq(&freezer->lock);
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
freezer_cg-fix-improper-bug_on-causing-oops.patch
freezer_cg-remove-redundant-check-in-freezer_can_attach.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch
freezer_cg-simplify-freezer_change_state.patch
cgroups-tiny-cleanups.patch

