From: akpm@linux-foundation.org
Subject: - rcutorture-style-cleanup-avoid-=-null-in-boolean-tests.patch removed from -mm tree
Date: Tue, 08 May 2007 19:53:51 -0700
Message-ID: <200705090253.l492rpdt009742@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969854AbXEICzP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:55:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh@kernel.org, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     rcutorture: style cleanup: avoid != NULL in boolean tests
has been removed from the -mm tree.  Its filename was
     rcutorture-style-cleanup-avoid-=-null-in-boolean-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rcutorture: style cleanup: avoid != NULL in boolean tests
From: Josh Triplett <josh@kernel.org>

Signed-off-by: Josh Triplett <josh@kernel.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcutorture.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN kernel/rcutorture.c~rcutorture-style-cleanup-avoid-=-null-in-boolean-tests kernel/rcutorture.c
--- a/kernel/rcutorture.c~rcutorture-style-cleanup-avoid-=-null-in-boolean-tests
+++ a/kernel/rcutorture.c
@@ -534,7 +534,7 @@ rcu_torture_writer(void *arg)
 		rp->rtort_mbtest = 1;
 		rcu_assign_pointer(rcu_torture_current, rp);
 		smp_wmb();
-		if (old_rp != NULL) {
+		if (old_rp) {
 			i = old_rp->rtort_pipe_count;
 			if (i > RCU_TORTURE_PIPE_LEN)
 				i = RCU_TORTURE_PIPE_LEN;
@@ -685,7 +685,7 @@ rcu_torture_printk(char *page)
 			       atomic_read(&rcu_torture_wcount[i]));
 	}
 	cnt += sprintf(&page[cnt], "\n");
-	if (cur_ops->stats != NULL)
+	if (cur_ops->stats)
 		cnt += cur_ops->stats(&page[cnt]);
 	return cnt;
 }
@@ -749,13 +749,13 @@ static void rcu_torture_shuffle_tasks(vo
 
 	set_cpus_allowed(current, tmp_mask);
 
-	if (reader_tasks != NULL) {
+	if (reader_tasks) {
 		for (i = 0; i < nrealreaders; i++)
 			if (reader_tasks[i])
 				set_cpus_allowed(reader_tasks[i], tmp_mask);
 	}
 
-	if (fakewriter_tasks != NULL) {
+	if (fakewriter_tasks) {
 		for (i = 0; i < nfakewriters; i++)
 			if (fakewriter_tasks[i])
 				set_cpus_allowed(fakewriter_tasks[i], tmp_mask);
@@ -808,21 +808,21 @@ rcu_torture_cleanup(void)
 	int i;
 
 	fullstop = 1;
-	if (shuffler_task != NULL) {
+	if (shuffler_task) {
 		VERBOSE_PRINTK_STRING("Stopping rcu_torture_shuffle task");
 		kthread_stop(shuffler_task);
 	}
 	shuffler_task = NULL;
 
-	if (writer_task != NULL) {
+	if (writer_task) {
 		VERBOSE_PRINTK_STRING("Stopping rcu_torture_writer task");
 		kthread_stop(writer_task);
 	}
 	writer_task = NULL;
 
-	if (reader_tasks != NULL) {
+	if (reader_tasks) {
 		for (i = 0; i < nrealreaders; i++) {
-			if (reader_tasks[i] != NULL) {
+			if (reader_tasks[i]) {
 				VERBOSE_PRINTK_STRING(
 					"Stopping rcu_torture_reader task");
 				kthread_stop(reader_tasks[i]);
@@ -834,9 +834,9 @@ rcu_torture_cleanup(void)
 	}
 	rcu_torture_current = NULL;
 
-	if (fakewriter_tasks != NULL) {
+	if (fakewriter_tasks) {
 		for (i = 0; i < nfakewriters; i++) {
-			if (fakewriter_tasks[i] != NULL) {
+			if (fakewriter_tasks[i]) {
 				VERBOSE_PRINTK_STRING(
 					"Stopping rcu_torture_fakewriter task");
 				kthread_stop(fakewriter_tasks[i]);
@@ -847,7 +847,7 @@ rcu_torture_cleanup(void)
 		fakewriter_tasks = NULL;
 	}
 
-	if (stats_task != NULL) {
+	if (stats_task) {
 		VERBOSE_PRINTK_STRING("Stopping rcu_torture_stats task");
 		kthread_stop(stats_task);
 	}
@@ -858,7 +858,7 @@ rcu_torture_cleanup(void)
 
 	rcu_torture_stats_print();  /* -After- the stats thread is stopped! */
 
-	if (cur_ops->cleanup != NULL)
+	if (cur_ops->cleanup)
 		cur_ops->cleanup();
 	if (atomic_read(&n_rcu_torture_error))
 		rcu_torture_print_module_parms("End of test: FAILURE");
@@ -875,7 +875,7 @@ rcu_torture_init(void)
 
 	/* Process args and tell the world that the torturer is on the job. */
 
-	for (i = 0; cur_ops = torture_ops[i], cur_ops != NULL; i++) {
+	for (i = 0; cur_ops = torture_ops[i], cur_ops; i++) {
 		cur_ops = torture_ops[i];
 		if (strcmp(torture_type, cur_ops->name) == 0) {
 			break;
@@ -886,7 +886,7 @@ rcu_torture_init(void)
 		       torture_type);
 		return (-EINVAL);
 	}
-	if (cur_ops->init != NULL)
+	if (cur_ops->init)
 		cur_ops->init(); /* no "goto unwind" prior to this point!!! */
 
 	if (nreaders >= 0)
_

Patches currently in -mm which might be from josh@kernel.org are

origin.patch
