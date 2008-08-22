From: akpm@linux-foundation.org
Subject: + container-freezer-rename-check_if_frozen.patch added to -mm tree
Date: Fri, 22 Aug 2008 13:40:45 -0700
Message-ID: <200808222040.m7MKejxY015540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146AbYHVUqk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 16:46:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthltc@us.ibm.com


The patch titled
     container freezer: rename check_if_frozen()
has been added to the -mm tree.  Its filename is
     container-freezer-rename-check_if_frozen.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: container freezer: rename check_if_frozen()
From: Matt Helsley <matthltc@us.ibm.com>

check_if_frozen() sounds like it should return something when in fact it's
just updating the freezer state.

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup_freezer.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN kernel/cgroup_freezer.c~container-freezer-rename-check_if_frozen kernel/cgroup_freezer.c
--- a/kernel/cgroup_freezer.c~container-freezer-rename-check_if_frozen
+++ a/kernel/cgroup_freezer.c
@@ -201,8 +201,8 @@ static void freezer_fork(struct cgroup_s
 /*
  * caller must hold freezer->lock
  */
-static void check_if_frozen(struct cgroup *cgroup,
-			     struct freezer *freezer)
+static void update_freezer_state(struct cgroup *cgroup,
+				 struct freezer *freezer)
 {
 	struct cgroup_iter it;
 	struct task_struct *task;
@@ -222,6 +222,10 @@ static void check_if_frozen(struct cgrou
 	 */
 	if (nfrozen == ntotal)
 		freezer->state = CGROUP_FROZEN;
+	else if (nfrozen > 0)
+		freezer->state = CGROUP_FREEZING;
+	else
+		freezer->state = CGROUP_THAWED;
 	cgroup_iter_end(cgroup, &it);
 }
 
@@ -240,7 +244,7 @@ static int freezer_read(struct cgroup *c
 	if (state == CGROUP_FREEZING) {
 		/* We change from FREEZING to FROZEN lazily if the cgroup was
 		 * only partially frozen when we exitted write. */
-		check_if_frozen(cgroup, freezer);
+		update_freezer_state(cgroup, freezer);
 		state = freezer->state;
 	}
 	spin_unlock_irq(&freezer->lock);
@@ -301,7 +305,7 @@ static int freezer_change_state(struct c
 
 	freezer = cgroup_freezer(cgroup);
 	spin_lock_irq(&freezer->lock);
-	check_if_frozen(cgroup, freezer); /* may update freezer->state */
+	update_freezer_state(cgroup, freezer);
 	if (goal_state == freezer->state)
 		goto out;
 	switch (freezer->state) {
_

Patches currently in -mm which might be from matthltc@us.ibm.com are

container-freezer-add-tif_freeze-flag-to-all-architectures.patch
container-freezer-make-refrigerator-always-available.patch
container-freezer-implement-freezer-cgroup-subsystem.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process.patch
container-freezer-implement-freezer-cgroup-subsystem-cleanup-comment.patch
container-freezer-skip-frozen-cgroups-during-power-management-resume.patch
container-freezer-prevent-frozen-tasks-or-cgroups-from-changing.patch
container-freezer-make-freezer-state-names-less-generic.patch
container-freezer-rename-check_if_frozen.patch
container-freezer-document-the-cgroup-freezer-subsystem.patch

