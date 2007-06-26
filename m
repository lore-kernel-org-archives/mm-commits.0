From: akpm@linux-foundation.org
Subject: + force-rcutorture-tasks-to-spread-over-cpus.patch added to -mm tree
Date: Tue, 26 Jun 2007 16:13:25 -0700
Message-ID: <200706262313.l5QNDPqE004638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41394 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760560AbXFZXNo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 19:13:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, josh@kernel.org, mingo@elte.hu


The patch titled
     Force rcutorture tasks to spread over CPUs
has been added to the -mm tree.  Its filename is
     force-rcutorture-tasks-to-spread-over-cpus.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Force rcutorture tasks to spread over CPUs
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Of late, the scheduler seems to have decided to make things too easy for
RCU -- on some configurations, all of the rcutorture tasks end up on the
same CPU, which doesn't do a very good job of torturing RCU.  This patch
helps the scheduler spread these tasks out by forcing a 20-millisecond
burst of CPU-bound execution on each of rcutorture's tasks, which seems to
work reasonably well in practice.

My challenge for those working on the scheduler is to make this patch
unnecessary.  ;-)

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Josh Triplett <josh@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcutorture.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+)

diff -puN kernel/rcutorture.c~force-rcutorture-tasks-to-spread-over-cpus kernel/rcutorture.c
--- a/kernel/rcutorture.c~force-rcutorture-tasks-to-spread-over-cpus
+++ a/kernel/rcutorture.c
@@ -103,6 +103,8 @@ struct rcu_torture {
 };
 
 static int fullstop = 0;	/* stop generating callbacks at test end. */
+static int startwriters;	/* force load-balancing of writers. */
+static int startreaders;	/* force load-balancing of readers. */
 static LIST_HEAD(rcu_torture_freelist);
 static struct rcu_torture *rcu_torture_current = NULL;
 static long rcu_torture_current_version = 0;
@@ -518,6 +520,8 @@ rcu_torture_writer(void *arg)
 	static DEFINE_RCU_RANDOM(rand);
 
 	VERBOSE_PRINTK_STRING("rcu_torture_writer task started");
+	while (!startwriters)
+		barrier();	/* Force scheduler to spread over CPUs. */
 	set_user_nice(current, 19);
 
 	do {
@@ -557,6 +561,8 @@ rcu_torture_fakewriter(void *arg)
 	DEFINE_RCU_RANDOM(rand);
 
 	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task started");
+	while (!startwriters)
+		barrier();	/* Force scheduler to spread over CPUs. */
 	set_user_nice(current, 19);
 
 	do {
@@ -587,6 +593,8 @@ rcu_torture_reader(void *arg)
 	int pipe_count;
 
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
+	while (!startreaders)
+		barrier();	/* Force scheduler to spread over CPUs. */
 	set_user_nice(current, 19);
 
 	do {
@@ -920,6 +928,8 @@ rcu_torture_init(void)
 
 	/* Start up the kthreads. */
 
+	startwriters = 0;
+	barrier();
 	VERBOSE_PRINTK_STRING("Creating rcu_torture_writer task");
 	writer_task = kthread_run(rcu_torture_writer, NULL,
 				  "rcu_torture_writer");
@@ -947,6 +957,12 @@ rcu_torture_init(void)
 			goto unwind;
 		}
 	}
+	barrier();
+	startwriters = 1;
+	schedule_timeout_interruptible(round_jiffies_relative(HZ/50));
+
+	startreaders = 0;
+	barrier();
 	reader_tasks = kzalloc(nrealreaders * sizeof(reader_tasks[0]),
 			       GFP_KERNEL);
 	if (reader_tasks == NULL) {
@@ -965,6 +981,10 @@ rcu_torture_init(void)
 			goto unwind;
 		}
 	}
+	schedule_timeout_interruptible(round_jiffies_relative(HZ/50));
+	barrier();
+	startreaders = 1;
+
 	if (stat_interval > 0) {
 		VERBOSE_PRINTK_STRING("Creating rcu_torture_stats task");
 		stats_task = kthread_run(rcu_torture_stats, NULL,
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

document-the-fact-that-rcu-callbacks-can-run-in-parallel.patch
force-rcutorture-tasks-to-spread-over-cpus.patch
