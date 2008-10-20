From: akpm@linux-foundation.org
Subject: - container-freezer-make-freezer-state-names-less-generic.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:34:28 -0700
Message-ID: <200810202034.m9KKYSxJ010856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753672AbYJTUe7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:34:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthltc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     container freezer: make freezer state names less generic
has been removed from the -mm tree.  Its filename was
     container-freezer-make-freezer-state-names-less-generic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: container freezer: make freezer state names less generic
From: Matt Helsley <matthltc@us.ibm.com>

Rename cgroup freezer states to be less generic to avoid any name
collisions while also better describing what each state is.

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup_freezer.c |   56 +++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff -puN kernel/cgroup_freezer.c~container-freezer-make-freezer-state-names-less-generic kernel/cgroup_freezer.c
--- a/kernel/cgroup_freezer.c~container-freezer-make-freezer-state-names-less-generic
+++ a/kernel/cgroup_freezer.c
@@ -22,9 +22,9 @@
 #include <linux/seq_file.h>
 
 enum freezer_state {
-	STATE_RUNNING = 0,
-	STATE_FREEZING,
-	STATE_FROZEN,
+	CGROUP_THAWED = 0,
+	CGROUP_FREEZING,
+	CGROUP_FROZEN,
 };
 
 struct freezer {
@@ -57,7 +57,7 @@ int cgroup_frozen(struct task_struct *ta
 	state = freezer->state;
 	task_unlock(task);
 
-	return state == STATE_FROZEN;
+	return state == CGROUP_FROZEN;
 }
 
 /*
@@ -65,7 +65,7 @@ int cgroup_frozen(struct task_struct *ta
  * CGROUP_LOCAL_BUFFER_SIZE
  */
 static const char *freezer_state_strs[] = {
-	"RUNNING",
+	"THAWED",
 	"FREEZING",
 	"FROZEN",
 };
@@ -75,10 +75,10 @@ static const char *freezer_state_strs[] 
  * Transitions are caused by userspace writes to the freezer.state file.
  * The values in parenthesis are state labels. The rest are edge labels.
  *
- * (RUNNING) --FROZEN--> (FREEZING) --FROZEN--> (FROZEN)
- *    ^ ^                     |                       |
- *    | \_______RUNNING_______/                       |
- *    \_____________________________RUNNING___________/
+ * (THAWED) --FROZEN--> (FREEZING) --FROZEN--> (FROZEN)
+ *    ^ ^                    |                     |
+ *    | \_______THAWED_______/                     |
+ *    \__________________________THAWED____________/
  */
 
 struct cgroup_subsys freezer_subsys;
@@ -135,7 +135,7 @@ static struct cgroup_subsys_state *freez
 		return ERR_PTR(-ENOMEM);
 
 	spin_lock_init(&freezer->lock);
-	freezer->state = STATE_RUNNING;
+	freezer->state = CGROUP_THAWED;
 	return &freezer->css;
 }
 
@@ -170,13 +170,13 @@ static int freezer_can_attach(struct cgr
 		return -EBUSY;
 
 	freezer = cgroup_freezer(new_cgroup);
-	if (freezer->state == STATE_FROZEN)
+	if (freezer->state == CGROUP_FROZEN)
 		return -EBUSY;
 
 	retval = 0;
 	task_lock(task);
 	freezer = task_freezer(task);
-	if (freezer->state == STATE_FROZEN)
+	if (freezer->state == CGROUP_FROZEN)
 		retval = -EBUSY;
 	task_unlock(task);
 	return retval;
@@ -190,10 +190,10 @@ static void freezer_fork(struct cgroup_s
 	freezer = task_freezer(task);
 	task_unlock(task);
 
-	BUG_ON(freezer->state == STATE_FROZEN);
+	BUG_ON(freezer->state == CGROUP_FROZEN);
 	spin_lock_irq(&freezer->lock);
-	/* Locking avoids race with FREEZING -> RUNNING transitions. */
-	if (freezer->state == STATE_FREEZING)
+	/* Locking avoids race with FREEZING -> THAWED transitions. */
+	if (freezer->state == CGROUP_FREEZING)
 		freeze_task(task, true);
 	spin_unlock_irq(&freezer->lock);
 }
@@ -221,7 +221,7 @@ static void check_if_frozen(struct cgrou
 	 * tasks.
 	 */
 	if (nfrozen == ntotal)
-		freezer->state = STATE_FROZEN;
+		freezer->state = CGROUP_FROZEN;
 	cgroup_iter_end(cgroup, &it);
 }
 
@@ -237,7 +237,7 @@ static int freezer_read(struct cgroup *c
 	freezer = cgroup_freezer(cgroup);
 	spin_lock_irq(&freezer->lock);
 	state = freezer->state;
-	if (state == STATE_FREEZING) {
+	if (state == CGROUP_FREEZING) {
 		/* We change from FREEZING to FROZEN lazily if the cgroup was
 		 * only partially frozen when we exitted write. */
 		check_if_frozen(cgroup, freezer);
@@ -257,7 +257,7 @@ static int try_to_freeze_cgroup(struct c
 	struct task_struct *task;
 	unsigned int num_cant_freeze_now = 0;
 
-	freezer->state = STATE_FREEZING;
+	freezer->state = CGROUP_FREEZING;
 	cgroup_iter_start(cgroup, &it);
 	while ((task = cgroup_iter_next(cgroup, &it))) {
 		if (!freeze_task(task, true))
@@ -288,7 +288,7 @@ static int unfreeze_cgroup(struct cgroup
 			wake_up_process(task);
 	}
 	cgroup_iter_end(cgroup, &it);
-	freezer->state = STATE_RUNNING;
+	freezer->state = CGROUP_THAWED;
 
 	return 0;
 }
@@ -305,18 +305,18 @@ static int freezer_change_state(struct c
 	if (goal_state == freezer->state)
 		goto out;
 	switch (freezer->state) {
-	case STATE_RUNNING:
+	case CGROUP_THAWED:
 		retval = try_to_freeze_cgroup(cgroup, freezer);
 		break;
-	case STATE_FREEZING:
-		if (goal_state == STATE_FROZEN) {
+	case CGROUP_FREEZING:
+		if (goal_state == CGROUP_FROZEN) {
 			/* Userspace is retrying after
 			 * "/bin/echo FROZEN > freezer.state" returned -EBUSY */
 			retval = try_to_freeze_cgroup(cgroup, freezer);
 			break;
 		}
-		/* state == FREEZING and goal_state == RUNNING, so unfreeze */
-	case STATE_FROZEN:
+		/* state == FREEZING and goal_state == THAWED, so unfreeze */
+	case CGROUP_FROZEN:
 		retval = unfreeze_cgroup(cgroup, freezer);
 		break;
 	default:
@@ -335,10 +335,10 @@ static int freezer_write(struct cgroup *
 	int retval;
 	enum freezer_state goal_state;
 
-	if (strcmp(buffer, freezer_state_strs[STATE_RUNNING]) == 0)
-		goal_state = STATE_RUNNING;
-	else if (strcmp(buffer, freezer_state_strs[STATE_FROZEN]) == 0)
-		goal_state = STATE_FROZEN;
+	if (strcmp(buffer, freezer_state_strs[CGROUP_THAWED]) == 0)
+		goal_state = CGROUP_THAWED;
+	else if (strcmp(buffer, freezer_state_strs[CGROUP_FROZEN]) == 0)
+		goal_state = CGROUP_FROZEN;
 	else
 		return -EIO;
 
_

Patches currently in -mm which might be from matthltc@us.ibm.com are

origin.patch

