From: akpm@linux-foundation.org
Subject: - container-freezer-rename-check_if_frozen.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:34:30 -0700
Message-ID: <200810202034.m9KKYUNa010859@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40371 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753511AbYJTUq1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthltc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     container freezer: rename check_if_frozen()
has been removed from the -mm tree.  Its filename was
     container-freezer-rename-check_if_frozen.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

