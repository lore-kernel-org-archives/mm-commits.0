From: akpm@linux-foundation.org
Subject: + cgroup_freezer-update_freezer_state-does-incorrect-state-transitions.patch added to -mm tree
Date: Thu, 12 Aug 2010 12:32:35 -0700
Message-ID: <201008121932.o7CJWZaL008586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753158Ab0HLTct (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Aug 2010 15:32:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomasz.buchert@inria.fr, lizf@cn.fujitsu.com, matthltc@us.ibm.com, menage@google.com


The patch titled
     cgroup_freezer: update_freezer_state() does incorrect state transitions
has been added to the -mm tree.  Its filename is
     cgroup_freezer-update_freezer_state-does-incorrect-state-transitions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup_freezer: update_freezer_state() does incorrect state transitions
From: Tomasz Buchert <tomasz.buchert@inria.fr>

There are 4 state transitions possible for a freezer.  Only FREEZING ->
FROZEN transaction is done lazily.  This patch allows update_freezer_state
only to perform this transaction and renames the function to
update_if_frozen.

Moreover is_task_frozen_enough function is removed and its every occurence
is replaced with frozen().  Therefore for a group to become FROZEN every
task must be frozen.

The previous version could trigger a following bug: When cgroup is in the
process of freezing (but none of its tasks are frozen yet),
update_freezer_state() (called from freezer_read or freezer_write) would
incorrectly report that a group is 'THAWED' (because nfrozen = 0),
allowing the transaction FREEZING -> THAWED without writing anything to
'freezer.state'.  This is incorrect according to the documentation.  This
could result in a 'THAWED' cgroup with frozen tasks inside.

A code to reproduce this bug is available here:
http://pentium.hopto.org/~thinred/repos/linux-misc/freezer_bug2.c

Signed-off-by: Tomasz Buchert <tomasz.buchert@inria.fr>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup_freezer.c |   40 ++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

diff -puN kernel/cgroup_freezer.c~cgroup_freezer-update_freezer_state-does-incorrect-state-transitions kernel/cgroup_freezer.c
--- a/kernel/cgroup_freezer.c~cgroup_freezer-update_freezer_state-does-incorrect-state-transitions
+++ a/kernel/cgroup_freezer.c
@@ -153,13 +153,6 @@ static void freezer_destroy(struct cgrou
 	kfree(cgroup_freezer(cgroup));
 }
 
-/* Task is frozen or will freeze immediately when next it gets woken */
-static bool is_task_frozen_enough(struct task_struct *task)
-{
-	return frozen(task) ||
-		(task_is_stopped_or_traced(task) && freezing(task));
-}
-
 /*
  * The call to cgroup_lock() in the freezer.state write method prevents
  * a write to that file racing against an attach, and hence the
@@ -236,31 +229,32 @@ static void freezer_fork(struct cgroup_s
 /*
  * caller must hold freezer->lock
  */
-static void update_freezer_state(struct cgroup *cgroup,
+static void update_if_frozen(struct cgroup *cgroup,
 				 struct freezer *freezer)
 {
 	struct cgroup_iter it;
 	struct task_struct *task;
 	unsigned int nfrozen = 0, ntotal = 0;
+	enum freezer_state old_state = freezer->state;
 
 	cgroup_iter_start(cgroup, &it);
 	while ((task = cgroup_iter_next(cgroup, &it))) {
 		ntotal++;
-		if (is_task_frozen_enough(task))
+		if (frozen(task))
 			nfrozen++;
 	}
 
-	/*
-	 * Transition to FROZEN when no new tasks can be added ensures
-	 * that we never exist in the FROZEN state while there are unfrozen
-	 * tasks.
-	 */
-	if (nfrozen == ntotal)
-		freezer->state = CGROUP_FROZEN;
-	else if (nfrozen > 0)
-		freezer->state = CGROUP_FREEZING;
-	else
-		freezer->state = CGROUP_THAWED;
+	if (old_state == CGROUP_THAWED) {
+		BUG_ON(nfrozen > 0);
+	}
+	else if (old_state == CGROUP_FREEZING) {
+		if (nfrozen == ntotal)
+			freezer->state = CGROUP_FROZEN;
+	}
+	else { /* old_state == CGROUP_FROZEN */
+		BUG_ON(nfrozen != ntotal);
+	}
+
 	cgroup_iter_end(cgroup, &it);
 }
 
@@ -279,7 +273,7 @@ static int freezer_read(struct cgroup *c
 	if (state == CGROUP_FREEZING) {
 		/* We change from FREEZING to FROZEN lazily if the cgroup was
 		 * only partially frozen when we exitted write. */
-		update_freezer_state(cgroup, freezer);
+		update_if_frozen(cgroup, freezer);
 		state = freezer->state;
 	}
 	spin_unlock_irq(&freezer->lock);
@@ -301,7 +295,7 @@ static int try_to_freeze_cgroup(struct c
 	while ((task = cgroup_iter_next(cgroup, &it))) {
 		if (!freeze_task(task, true))
 			continue;
-		if (is_task_frozen_enough(task))
+		if (frozen(task))
 			continue;
 		if (!freezing(task) && !freezer_should_skip(task))
 			num_cant_freeze_now++;
@@ -335,7 +329,7 @@ static int freezer_change_state(struct c
 
 	spin_lock_irq(&freezer->lock);
 
-	update_freezer_state(cgroup, freezer);
+	update_if_frozen(cgroup, freezer);
 	if (goal_state == freezer->state)
 		goto out;
 
_

Patches currently in -mm which might be from tomasz.buchert@inria.fr are

cgroup_freezer-unnecessary-test-in-cgroup_freezing_or_frozen.patch
cgroup_freezer-fix-can_attach-to-prohibit-moving-from-to-freezing-frozen-cgroups.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions.patch

