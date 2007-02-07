From: akpm@linux-foundation.org
Subject: + rcutorture-style-cleanup-avoid-=-null-in-boolean-tests.patch added to -mm tree
Date: Wed, 07 Feb 2007 15:18:35 -0800
Message-ID: <200702072318.l17NIZcE030881@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44949 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161333AbXBGXXR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 18:23:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: josh@kernel.org, paulmck@us.ibm.com


The patch titled
     rcutorture: style cleanup: avoid != NULL in boolean tests
has been added to the -mm tree.  Its filename is
     rcutorture-style-cleanup-avoid-=-null-in-boolean-tests.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rcutorture: style cleanup: avoid != NULL in boolean tests
From: Josh Triplett <josh@kernel.org>

Signed-off-by: Josh Triplett <josh@kernel.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcutorture.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff -puN kernel/rcutorture.c~rcutorture-style-cleanup-avoid-=-null-in-boolean-tests kernel/rcutorture.c
--- a/kernel/rcutorture.c~rcutorture-style-cleanup-avoid-=-null-in-boolean-tests
+++ a/kernel/rcutorture.c
@@ -601,7 +601,7 @@ rcu_torture_writer(void *arg)
 		rp->rtort_mbtest = 1;
 		rcu_assign_pointer(rcu_torture_current, rp);
 		smp_wmb();
-		if (old_rp != NULL) {
+		if (old_rp) {
 			i = old_rp->rtort_pipe_count;
 			if (i > RCU_TORTURE_PIPE_LEN)
 				i = RCU_TORTURE_PIPE_LEN;
@@ -752,7 +752,7 @@ rcu_torture_printk(char *page)
 			       atomic_read(&rcu_torture_wcount[i]));
 	}
 	cnt += sprintf(&page[cnt], "\n");
-	if (cur_ops->stats != NULL)
+	if (cur_ops->stats)
 		cnt += cur_ops->stats(&page[cnt]);
 	return cnt;
 }
@@ -816,13 +816,13 @@ static void rcu_torture_shuffle_tasks(vo
 
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
@@ -875,21 +875,21 @@ rcu_torture_cleanup(void)
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
@@ -901,9 +901,9 @@ rcu_torture_cleanup(void)
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
@@ -914,7 +914,7 @@ rcu_torture_cleanup(void)
 		fakewriter_tasks = NULL;
 	}
 
-	if (stats_task != NULL) {
+	if (stats_task) {
 		VERBOSE_PRINTK_STRING("Stopping rcu_torture_stats task");
 		kthread_stop(stats_task);
 	}
@@ -925,7 +925,7 @@ rcu_torture_cleanup(void)
 
 	rcu_torture_stats_print();  /* -After- the stats thread is stopped! */
 
-	if (cur_ops->cleanup != NULL)
+	if (cur_ops->cleanup)
 		cur_ops->cleanup();
 	if (atomic_read(&n_rcu_torture_error))
 		rcu_torture_print_module_parms("End of test: FAILURE");
@@ -942,7 +942,7 @@ rcu_torture_init(void)
 
 	/* Process args and tell the world that the torturer is on the job. */
 
-	for (i = 0; cur_ops = torture_ops[i], cur_ops != NULL; i++) {
+	for (i = 0; cur_ops = torture_ops[i], cur_ops; i++) {
 		cur_ops = torture_ops[i];
 		if (strcmp(torture_type, cur_ops->name) == 0) {
 			break;
@@ -953,7 +953,7 @@ rcu_torture_init(void)
 		       torture_type);
 		return (-EINVAL);
 	}
-	if (cur_ops->init != NULL)
+	if (cur_ops->init)
 		cur_ops->init(); /* no "goto unwind" prior to this point!!! */
 
 	if (nreaders >= 0)
_

Patches currently in -mm which might be from josh@kernel.org are

usb-in-init_endpoint_class-use-ptr_err-to-obtain-an-errno-value-not-is_err.patch
rcutorture-style-cleanup-avoid-=-null-in-boolean-tests.patch
rcutorture-remove-redundant-assignment-to-cur_ops-in.patch
