From: akpm@linux-foundation.org
Subject: [folded] tools-selftests-add-mq_perf_tests-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 31 May 2012 16:18:21 -0700
Message-ID: <20120531231821.90231A009B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:46679 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758594Ab2EaXSY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 19:18:24 -0400
Received: by wgbdt11 with SMTP id dt11so83516wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 16:18:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dledford@redhat.com, fweisbec@gmail.com, kosaki.motohiro@jp.fujitsu.com, manfred@colorfullife.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: tools-selftests-add-mq_perf_tests-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     tools-selftests-add-mq_perf_tests-checkpatch-fixes.patch

This patch was dropped because it was folded into tools-selftests-add-mq_perf_tests.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: tools-selftests-add-mq_perf_tests-checkpatch-fixes

Cc: Doug Ledford <dledford@redhat.com>

ERROR: space required after that ',' (ctx:VxV)
#117: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:73:
+#define min(a,b) ((a) < (b) ? (a) : (b))
              ^

ERROR: that open brace { should be on the previous line
#145: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:101:
+const struct poptOption options[] =
+{

WARNING: externs should be avoided in .c files
#196: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:152:
+void shutdown(int exit_val, char *err_cause, int line_no);

WARNING: externs should be avoided in .c files
#197: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:153:
+void sig_action_SIGUSR1(int signum, siginfo_t *info, void *context);

WARNING: externs should be avoided in .c files
#198: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:154:
+void sig_action(int signum, siginfo_t *info, void *context);

WARNING: externs should be avoided in .c files
#205: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:161:
+void increase_limits(void);

ERROR: do not initialise statics to 0 or NULL
#217: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:173:
+	static int in_shutdown = 0;

ERROR: spaces required around that '=' (ctx:VxV)
#225: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:181:
+	for (i=0; i < num_cpus_to_pin; i++)
 	      ^

WARNING: quoted string split across lines
#258: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:214:
+		fprintf(stderr, "Caught signal %d in SIGUSR1 handler, "
+			"exiting\n", signum);

ERROR: do not use assignment in if condition
#336: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:292:
+	if ((queue = mq_open(queue_path, flags, perms, attr)) == -1)

ERROR: spaces required around that '=' (ctx:VxV)
#352: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:308:
+	for (i=0; i < num_cpus_to_pin; i++)
 	      ^

ERROR: space required before the open parenthesis '('
#357: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:313:
+	while(1) ;

ERROR: trailing statements should be on next line
#357: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:313:
+	while(1) ;

ERROR: spaces required around that '=' (ctx:VxV)
#365: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:321:
+	for (i=0; i < num_cpus_to_pin; i++)
 	      ^

ERROR: space required before the open parenthesis '('
#370: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:326:
+	while(1) {

ERROR: space required before the open parenthesis '('
#371: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:327:
+		while(mq_send(queue, buff, sizeof(buff), 0) == 0);

ERROR: trailing statements should be on next line
#371: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:327:
+		while(mq_send(queue, buff, sizeof(buff), 0) == 0);

ERROR: Macros with complex values should be enclosed in parenthesis
#376: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:332:
+#define drain_queue() \
+	while (mq_receive(queue, buff, MSG_SIZE, &prio_in) == MSG_SIZE)

ERROR: space required before the open parenthesis '('
#383: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:339:
+	} while(0)

WARNING: Statements terminations use 1 semicolon
#423: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:379:
+		*prio = 0;;

ERROR: do not use assignment in if condition
#475: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:431:
+	if ((mq_prio_max = sysconf(_SC_MQ_PRIO_MAX)) == -1)

WARNING: quoted string split across lines
#490: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:446:
+	printf("\n\tTest #1: Time send/recv message, queue "
+	       "empty\n");

ERROR: trailing statements should be on next line
#566: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:522:
+	while (try_set(max_msgs, cur_max_msgs += 10));

ERROR: trailing statements should be on next line
#568: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:524:
+	while (try_set(max_msgsize, cur_max_msgsize += 1024));

ERROR: do not use assignment in if condition
#593: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:549:
+	if ((cpu_set = CPU_ALLOC(cpus_online)) == NULL) {

WARNING: quoted string split across lines
#615: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:571:
+					fprintf(stderr, "CPU %d exceeds "
+						"cpus online, ignoring.\n",

WARNING: quoted string split across lines
#628: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:584:
+					fprintf(stderr, "Any given CPU may "
+						"only be given once.\n");

WARNING: quoted string split across lines
#660: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:616:
+		fprintf(stderr, "Must pass at least one CPU to continuous "
+			"mode.\n");

WARNING: quoted string split across lines
#670: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:626:
+		fprintf(stderr, "Not running as root, but almost all tests "
+			"require root in order to modify\nsystem settings.  "

ERROR: spaces required around that '=' (ctx:VxV)
#721: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:677:
+	for(cpu=1; cpu < num_cpus_to_pin; cpu++)
 	       ^

ERROR: space required before the open parenthesis '('
#721: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:677:
+	for(cpu=1; cpu < num_cpus_to_pin; cpu++)

ERROR: spaces required around that '=' (ctx:VxV)
#750: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:706:
+	for (i=0; i < num_cpus_to_pin; i++) {
 	      ^

ERROR: space required before the open parenthesis '('
#776: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:732:
+		while(1) sleep(1);

ERROR: trailing statements should be on next line
#776: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:732:
+		while(1) sleep(1);

ERROR: space required after that ',' (ctx:VxV)
#777: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:733:
+	shutdown(0,"",0);
 	          ^

ERROR: space required after that ',' (ctx:VxV)
#777: FILE: tools/testing/selftests/mqueue/mq_perf_tests.c:733:
+	shutdown(0,"",0);
 	             ^

total: 25 errors, 11 warnings, 747 lines checked

./patches/tools-selftests-add-mq_perf_tests.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Doug Ledford <dledford@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mqueue/mq_perf_tests.c |   55 ++++++++-------
 1 file changed, 31 insertions(+), 24 deletions(-)

diff -puN tools/testing/selftests/mqueue/mq_perf_tests.c~tools-selftests-add-mq_perf_tests-checkpatch-fixes tools/testing/selftests/mqueue/mq_perf_tests.c
--- a/tools/testing/selftests/mqueue/mq_perf_tests.c~tools-selftests-add-mq_perf_tests-checkpatch-fixes
+++ a/tools/testing/selftests/mqueue/mq_perf_tests.c
@@ -70,7 +70,7 @@ static char *usage =
 char *MAX_MSGS = "/proc/sys/fs/mqueue/msg_max";
 char *MAX_MSGSIZE = "/proc/sys/fs/mqueue/msgsize_max";
 
-#define min(a,b) ((a) < (b) ? (a) : (b))
+#define min(a, b) ((a) < (b) ? (a) : (b))
 #define MAX_CPUS 64
 char *cpu_option_string;
 int cpus_to_pin[MAX_CPUS];
@@ -97,8 +97,7 @@ mqd_t queue = -1;
 struct mq_attr result;
 int mq_prio_max;
 
-const struct poptOption options[] =
-{
+const struct poptOption options[] = {
 	{
 		.longName = "continuous",
 		.shortName = 'c',
@@ -178,7 +177,7 @@ void shutdown(int exit_val, char *err_ca
 	if (in_shutdown++)
 		return;
 
-	for (i=0; i < num_cpus_to_pin; i++)
+	for (i = 0; i < num_cpus_to_pin; i++)
 		if (cpu_threads[i]) {
 			pthread_kill(cpu_threads[i], SIGUSR1);
 			pthread_join(cpu_threads[i], NULL);
@@ -211,7 +210,7 @@ void sig_action_SIGUSR1(int signum, sigi
 		pthread_exit(0);
 	else {
 		fprintf(stderr, "Caught signal %d in SIGUSR1 handler, "
-			"exiting\n", signum);
+				"exiting\n", signum);
 		shutdown(0, "", 0);
 		fprintf(stderr, "\n\nReturned from shutdown?!?!\n\n");
 		exit(0);
@@ -289,7 +288,8 @@ static inline void open_queue(struct mq_
 	int flags = O_RDWR | O_EXCL | O_CREAT | O_NONBLOCK;
 	int perms = DEFFILEMODE;
 
-	if ((queue = mq_open(queue_path, flags, perms, attr)) == -1)
+	queue = mq_open(queue_path, flags, perms, attr);
+	if (queue == -1)
 		shutdown(1, "mq_open()", __LINE__);
 	if (mq_getattr(queue, &result))
 		shutdown(1, "mq_getattr()", __LINE__);
@@ -305,12 +305,13 @@ void *fake_cont_thread(void *arg)
 {
 	int i;
 
-	for (i=0; i < num_cpus_to_pin; i++)
+	for (i = 0; i < num_cpus_to_pin; i++)
 		if (cpu_threads[i] == pthread_self())
 			break;
 	printf("\tStarted fake continuous mode thread %d on CPU %d\n", i,
 	       cpus_to_pin[i]);
-	while(1) ;
+	while (1)
+		;
 }
 
 void *cont_thread(void *arg)
@@ -318,13 +319,14 @@ void *cont_thread(void *arg)
 	char buff[MSG_SIZE];
 	int i, priority;
 
-	for (i=0; i < num_cpus_to_pin; i++)
+	for (i = 0; i < num_cpus_to_pin; i++)
 		if (cpu_threads[i] == pthread_self())
 			break;
 	printf("\tStarted continuous mode thread %d on CPU %d\n", i,
 	       cpus_to_pin[i]);
-	while(1) {
-		while(mq_send(queue, buff, sizeof(buff), 0) == 0);
+	while (1) {
+		while (mq_send(queue, buff, sizeof(buff), 0) == 0)
+			;
 		mq_receive(queue, buff, sizeof(buff), &priority);
 	}
 }
@@ -336,7 +338,7 @@ void *cont_thread(void *arg)
 	do { \
 		if (mq_send(queue, buff, MSG_SIZE, prio_out)) \
 			shutdown(3, "Test send failure", __LINE__); \
-	} while(0)
+	} while (0)
 
 #define do_send_recv() \
 	do { \
@@ -376,7 +378,7 @@ void const_prio(int *prio)
 void inc_prio(int *prio)
 {
 	if (++*prio == mq_prio_max)
-		*prio = 0;;
+		*prio = 0;
 }
 
 void dec_prio(int *prio)
@@ -428,7 +430,8 @@ void *perf_test_thread(void *arg)
 	t = &cpu_threads[0];
 	printf("\n\tStarted mqueue performance test thread on CPU %d\n",
 	       cpus_to_pin[0]);
-	if ((mq_prio_max = sysconf(_SC_MQ_PRIO_MAX)) == -1)
+	mq_prio_max = sysconf(_SC_MQ_PRIO_MAX);
+	if (mq_prio_max == -1)
 		shutdown(2, "sysconf(_SC_MQ_PRIO_MAX)", __LINE__);
 	if (pthread_getcpuclockid(cpu_threads[0], &clock) != 0)
 		shutdown(2, "pthread_getcpuclockid", __LINE__);
@@ -442,8 +445,7 @@ void *perf_test_thread(void *arg)
 
 
 
-	printf("\n\tTest #1: Time send/recv message, queue "
-	       "empty\n");
+	printf("\n\tTest #1: Time send/recv message, queue empty\n");
 	printf("\t\t(%d iterations)\n", TEST1_LOOPS);
 	prio_out = 0;
 	send_total.tv_sec = 0;
@@ -519,9 +521,11 @@ void increase_limits(void)
 	cur_limits.rlim_cur = RLIM_INFINITY;
 	cur_limits.rlim_max = RLIM_INFINITY;
 	setr(RLIMIT_MSGQUEUE, &cur_limits);
-	while (try_set(max_msgs, cur_max_msgs += 10));
+	while (try_set(max_msgs, cur_max_msgs += 10))
+		;
 	cur_max_msgs = get(max_msgs);
-	while (try_set(max_msgsize, cur_max_msgsize += 1024));
+	while (try_set(max_msgsize, cur_max_msgsize += 1024))
+		;
 	cur_max_msgsize = get(max_msgsize);
 	if (setpriority(PRIO_PROCESS, 0, -20) != 0)
 		shutdown(2, "setpriority()", __LINE__);
@@ -546,7 +550,8 @@ int main(int argc, char *argv[])
 		exit(1);
 	}
 	cpus_online = min(MAX_CPUS, sysconf(_SC_NPROCESSORS_ONLN));
-	if ((cpu_set = CPU_ALLOC(cpus_online)) == NULL) {
+	cpu_set = CPU_ALLOC(cpus_online);
+	if (cpu_set == NULL) {
 		perror("CPU_ALLOC()");
 		exit(1);
 	}
@@ -674,7 +679,7 @@ int main(int argc, char *argv[])
 	       (continuous_mode_fake ? "fake mode" : "enabled") :
 	       "disabled");
 	printf("\tCPUs to pin:\t\t\t\t%d", cpus_to_pin[0]);
-	for(cpu=1; cpu < num_cpus_to_pin; cpu++)
+	for (cpu = 1; cpu < num_cpus_to_pin; cpu++)
 			printf(",%d", cpus_to_pin[cpu]);
 	printf("\n");
 
@@ -703,7 +708,7 @@ int main(int argc, char *argv[])
 		attr.mq_msgsize = MSG_SIZE;
 		open_queue(&attr);
 	}
-	for (i=0; i < num_cpus_to_pin; i++) {
+	for (i = 0; i < num_cpus_to_pin; i++) {
 		pthread_attr_t thread_attr;
 		void *thread_func;
 
@@ -728,7 +733,9 @@ int main(int argc, char *argv[])
 	if (!continuous_mode) {
 		pthread_join(cpu_threads[0], &retval);
 		shutdown((long)retval, "perf_test_thread()", __LINE__);
-	} else
-		while(1) sleep(1);
-	shutdown(0,"",0);
+	} else {
+		while (1)
+			sleep(1);
+	}
+	shutdown(0, "", 0);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
isdn-add-missing-kern_cont.patch
kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format.patch
vsprintf-further-optimize-decimal-conversion.patch
proc-clean-up-proc-pid-environ-handling.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch
ipc-mqueue-improve-performance-of-send-recv.patch
ipc-mqueue-correct-mq_attr_ok-test.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation.patch
tools-selftests-add-mq_perf_tests.patch
ipc-mqueue-add-rbtree-node-caching-support-checkpatch-fixes.patch
pidns-make-killed-children-autoreap-checkpatch-fixes.patch
fs-nls-add-apple-nls-fix.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch

