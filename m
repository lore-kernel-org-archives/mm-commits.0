From: akpm@linux-foundation.org
Subject: + synchro-test-module-add-spinlock-test.patch added to -mm tree
Date: Wed, 02 Jan 2013 14:34:16 -0800
Message-ID: <20130102223417.1B45F100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:57439 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab3ABWeS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jan 2013 17:34:18 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so1554137vcd.1
        for <mm-commits@vger.kernel.org>; Wed, 02 Jan 2013 14:34:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, dhowells@redhat.com, riel@redhat.com


The patch titled
     Subject: synchro-test module: add spinlock test
has been added to the -mm tree.  Its filename is
     synchro-test-module-add-spinlock-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: synchro-test module: add spinlock test

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/synchro-test.c |   76 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 70 insertions(+), 6 deletions(-)

diff -puN kernel/synchro-test.c~synchro-test-module-add-spinlock-test kernel/synchro-test.c
--- a/kernel/synchro-test.c~synchro-test-module-add-spinlock-test
+++ a/kernel/synchro-test.c
@@ -41,6 +41,7 @@
 # define VALIDATE_OPERATORS
 #endif
 
+static int numsp;
 static int nummx;
 static int numsm, seminit = 4;
 static int numrd, numwr, numdg;
@@ -54,6 +55,9 @@ MODULE_LICENSE("GPL");
 module_param_named(v, verbose, int, 0);
 MODULE_PARM_DESC(verbose, "Verbosity");
 
+module_param_named(sp, numsp, int, 0);
+MODULE_PARM_DESC(numsp, "Number of spinlock threads");
+
 module_param_named(mx, nummx, int, 0);
 MODULE_PARM_DESC(nummx, "Number of mutex threads");
 
@@ -85,6 +89,7 @@ module_param(do_sched, int, 0);
 MODULE_PARM_DESC(do_sched, "True if each thread should schedule regularly");
 
 /* the semaphores under test */
+static spinlock_t ____cacheline_aligned spinlock;
 static struct mutex ____cacheline_aligned mutex;
 static struct semaphore ____cacheline_aligned sem;
 static struct rw_semaphore ____cacheline_aligned rwsem;
@@ -92,18 +97,21 @@ static struct rw_semaphore ____cacheline
 static atomic_t ____cacheline_aligned do_stuff		= ATOMIC_INIT(0);
 
 #ifdef VALIDATE_OPERATORS
+static atomic_t ____cacheline_aligned spinlocks		= ATOMIC_INIT(0);
 static atomic_t ____cacheline_aligned mutexes		= ATOMIC_INIT(0);
 static atomic_t ____cacheline_aligned semaphores	= ATOMIC_INIT(0);
 static atomic_t ____cacheline_aligned readers		= ATOMIC_INIT(0);
 static atomic_t ____cacheline_aligned writers		= ATOMIC_INIT(0);
 #endif
 
+static unsigned int ____cacheline_aligned spinlocks_taken	[MAX_THREADS];
 static unsigned int ____cacheline_aligned mutexes_taken		[MAX_THREADS];
 static unsigned int ____cacheline_aligned semaphores_taken	[MAX_THREADS];
 static unsigned int ____cacheline_aligned reads_taken		[MAX_THREADS];
 static unsigned int ____cacheline_aligned writes_taken		[MAX_THREADS];
 static unsigned int ____cacheline_aligned downgrades_taken	[MAX_THREADS];
 
+static struct completion ____cacheline_aligned sp_comp[MAX_THREADS];
 static struct completion ____cacheline_aligned mx_comp[MAX_THREADS];
 static struct completion ____cacheline_aligned sm_comp[MAX_THREADS];
 static struct completion ____cacheline_aligned rd_comp[MAX_THREADS];
@@ -130,6 +138,23 @@ do {									\
 #define CHECK(var, cond, val)	do {} while(0)
 #endif
 
+static inline void do_spin_lock(unsigned int N)
+{
+	spin_lock(&spinlock);
+
+	ACCOUNT(spinlocks, N);
+	TRACK(spinlocks, inc);
+	CHECK(spinlocks, ==, 1);
+}
+
+static inline void do_spin_unlock(unsigned int N)
+{
+	CHECK(spinlocks, ==, 1);
+	TRACK(spinlocks, dec);
+
+	spin_unlock(&spinlock);
+}
+
 static inline void do_mutex_lock(unsigned int N)
 {
 	mutex_lock(&mutex);
@@ -221,6 +246,27 @@ static inline void sched(void)
 		schedule();
 }
 
+static int spinlocker(void *arg)
+{
+	unsigned int N = (unsigned long) arg;
+
+	set_user_nice(current, 19);
+
+	while (atomic_read(&do_stuff)) {
+		do_spin_lock(N);
+		if (load)
+			udelay(load);
+		do_spin_unlock(N);
+		sched();
+		if (interval)
+			udelay(interval);
+	}
+
+	if (verbose >= 2)
+		printk("%s: done\n", current->comm);
+	complete_and_exit(&sp_comp[N], 0);
+}
+
 static int mutexer(void *arg)
 {
 	unsigned int N = (unsigned long) arg;
@@ -388,9 +434,11 @@ static unsigned int total(const char *wh
 static int __init do_tests(void)
 {
 	unsigned long loop;
-	unsigned int mutex_total, sem_total, rd_total, wr_total, dg_total;
+	unsigned int spinlock_total, mutex_total, sem_total;
+	unsigned int rd_total, wr_total, dg_total;
 
-	if (nummx < 0 || nummx > MAX_THREADS ||
+	if (numsp < 0 || numsp > MAX_THREADS ||
+	    nummx < 0 || nummx > MAX_THREADS ||
 	    numsm < 0 || numsm > MAX_THREADS ||
 	    numrd < 0 || numrd > MAX_THREADS ||
 	    numwr < 0 || numwr > MAX_THREADS ||
@@ -404,12 +452,12 @@ static int __init do_tests(void)
 		return -ERANGE;
 	}
 
-	if ((nummx | numsm | numrd | numwr | numdg) == 0) {
+	if ((numsp | nummx | numsm | numrd | numwr | numdg) == 0) {
 		int num = num_online_cpus();
 
 		if (num > MAX_THREADS)
 			num = MAX_THREADS;
-		nummx = numsm = numrd = numwr = numdg = num;
+		numsp = nummx = numsm = numrd = numwr = numdg = num;
 
 		load = 1;
 		interval = 1;
@@ -420,6 +468,7 @@ static int __init do_tests(void)
 	if (verbose)
 		printk("\nStarting synchronisation primitive tests...\n");
 
+	spin_lock_init(&spinlock);
 	mutex_init(&mutex);
 	sema_init(&sem, seminit);
 	init_rwsem(&rwsem);
@@ -427,6 +476,12 @@ static int __init do_tests(void)
 
 	/* kick off all the children */
 	for (loop = 0; loop < MAX_THREADS; loop++) {
+		if (loop < numsp) {
+			init_completion(&sp_comp[loop]);
+			kthread_run(spinlocker, (void *) loop,
+				    "Spinlock%lu", loop);
+		}
+
 		if (loop < nummx) {
 			init_completion(&mx_comp[loop]);
 			kthread_run(mutexer, (void *) loop, "Mutex%lu", loop);
@@ -460,6 +515,9 @@ static int __init do_tests(void)
 	add_timer(&timer);
 
 	/* now wait until it's all done */
+	for (loop = 0; loop < numsp; loop++)
+		wait_for_completion(&sp_comp[loop]);
+
 	for (loop = 0; loop < nummx; loop++)
 		wait_for_completion(&mx_comp[loop]);
 
@@ -478,10 +536,14 @@ static int __init do_tests(void)
 	atomic_set(&do_stuff, 0);
 	del_timer(&timer);
 
+	if (spin_is_locked(&spinlock))
+		printk(KERN_ERR "Spinlock is still locked!\n");
+
 	if (mutex_is_locked(&mutex))
 		printk(KERN_ERR "Mutex is still locked!\n");
 
 	/* count up */
+	spinlock_total	= total("SP ", spinlocks_taken, numsp);
 	mutex_total	= total("MTX", mutexes_taken, nummx);
 	sem_total	= total("SEM", semaphores_taken, numsm);
 	rd_total	= total("RD ", reads_taken, numrd);
@@ -490,6 +552,7 @@ static int __init do_tests(void)
 
 	/* print the results */
 	if (verbose) {
+		printk("spinlocks taken: %u\n", spinlock_total);
 		printk("mutexes taken: %u\n", mutex_total);
 		printk("semaphores taken: %u\n", sem_total);
 		printk("reads taken: %u\n", rd_total);
@@ -501,10 +564,11 @@ static int __init do_tests(void)
 
 		sprintf(buf, "%d/%d", interval, load);
 
-		printk("%3d %3d %3d %3d %3d %c %5s %9u %9u %9u %9u %9u\n",
-		       nummx, numsm, numrd, numwr, numdg,
+		printk("%3d %3d %3d %3d %3d %3d %c %5s %9u %9u %9u %9u %9u %9u\n",
+		       numsp, nummx, numsm, numrd, numwr, numdg,
 		       do_sched ? 's' : '-',
 		       buf,
+		       spinlock_total,
 		       mutex_total,
 		       sem_total,
 		       rd_total,
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch
synchro-test-module-add-spinlock-test.patch
document-default-load-and-interval-values-in-synchro-test-module.patch

