From: akpm@linux-foundation.org
Subject: - rcutorture-remove-redundant-assignment-to-cur_ops-in.patch removed from -mm tree
Date: Tue, 08 May 2007 19:53:53 -0700
Message-ID: <200705090253.l492rrFJ009746@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969180AbXEICzJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:55:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh@kernel.org, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     rcutorture: Remove redundant assignment to cur_ops in for loop
has been removed from the -mm tree.  Its filename was
     rcutorture-remove-redundant-assignment-to-cur_ops-in.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rcutorture: Remove redundant assignment to cur_ops in for loop
From: Josh Triplett <josh@kernel.org>

The for loop in rcutorture_init uses the condition
cur_ops = torture_ops[i], cur_ops
but then makes the same assignment to cur_ops inside the loop.  Remove the
redundant assignment inside the loop, and remove now-unnecessary braces.

Signed-off-by: Josh Triplett <josh@kernel.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcutorture.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN kernel/rcutorture.c~rcutorture-remove-redundant-assignment-to-cur_ops-in kernel/rcutorture.c
--- a/kernel/rcutorture.c~rcutorture-remove-redundant-assignment-to-cur_ops-in
+++ a/kernel/rcutorture.c
@@ -502,10 +502,6 @@ static struct rcu_torture_ops sched_ops 
 	.name = "sched"
 };
 
-static struct rcu_torture_ops *torture_ops[] =
-	{ &rcu_ops, &rcu_sync_ops, &rcu_bh_ops, &rcu_bh_sync_ops, &srcu_ops,
-	  &sched_ops, NULL };
-
 /*
  * RCU torture writer kthread.  Repeatedly substitutes a new structure
  * for that pointed to by rcu_torture_current, freeing the old structure
@@ -872,16 +868,17 @@ rcu_torture_init(void)
 	int i;
 	int cpu;
 	int firsterr = 0;
+	static struct rcu_torture_ops *torture_ops[] =
+		{ &rcu_ops, &rcu_sync_ops, &rcu_bh_ops, &rcu_bh_sync_ops,
+		  &srcu_ops, &sched_ops, };
 
 	/* Process args and tell the world that the torturer is on the job. */
-
-	for (i = 0; cur_ops = torture_ops[i], cur_ops; i++) {
+	for (i = 0; i < ARRAY_SIZE(torture_ops); i++) {
 		cur_ops = torture_ops[i];
-		if (strcmp(torture_type, cur_ops->name) == 0) {
+		if (strcmp(torture_type, cur_ops->name) == 0)
 			break;
-		}
 	}
-	if (cur_ops == NULL) {
+	if (i == ARRAY_SIZE(torture_ops)) {
 		printk(KERN_ALERT "rcutorture: invalid torture type: \"%s\"\n",
 		       torture_type);
 		return (-EINVAL);
_

Patches currently in -mm which might be from josh@kernel.org are

origin.patch
