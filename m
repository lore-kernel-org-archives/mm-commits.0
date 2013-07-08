From: akpm@linux-foundation.org
Subject: [merged] selftests-add-basic-posix-timers-selftests.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:37:44 -0700
Message-ID: <51db1508.ajSsrbzLitLPcKQy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab3GHThp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:37:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, sgruszka@redhat.com, rostedt@goodmis.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com

Subject: [merged] selftests-add-basic-posix-timers-selftests.patch removed from -mm tree
To: fweisbec@gmail.com,a.p.zijlstra@chello.nl,rostedt@goodmis.org,sgruszka@redhat.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:37:44 -0700


The patch titled
     Subject: selftests: add basic posix timers selftests
has been removed from the -mm tree.  Its filename was
     selftests-add-basic-posix-timers-selftests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: selftests: add basic posix timers selftests

Add some initial basic tests on a few posix timers interface such as
setitimer() and timer_settime().

These simply check that expiration happens in a reasonable timeframe after
expected elapsed clock time (user time, user + system time, real time,
...).

This is helpful for finding basic breakages while hacking
on this subsystem.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile              |    1 
 tools/testing/selftests/timers/Makefile       |    8 
 tools/testing/selftests/timers/posix_timers.c |  221 ++++++++++++++++
 3 files changed, 230 insertions(+)

diff -puN tools/testing/selftests/Makefile~selftests-add-basic-posix-timers-selftests tools/testing/selftests/Makefile
--- a/tools/testing/selftests/Makefile~selftests-add-basic-posix-timers-selftests
+++ a/tools/testing/selftests/Makefile
@@ -6,6 +6,7 @@ TARGETS += memory-hotplug
 TARGETS += mqueue
 TARGETS += net
 TARGETS += ptrace
+TARGETS += timers
 TARGETS += vm
 
 all:
diff -puN /dev/null tools/testing/selftests/timers/Makefile
--- /dev/null
+++ a/tools/testing/selftests/timers/Makefile
@@ -0,0 +1,8 @@
+all:
+	gcc posix_timers.c -o posix_timers -lrt
+
+run_tests: all
+	./posix_timers
+
+clean:
+	rm -f ./posix_timers
diff -puN /dev/null tools/testing/selftests/timers/posix_timers.c
--- /dev/null
+++ a/tools/testing/selftests/timers/posix_timers.c
@@ -0,0 +1,221 @@
+/*
+ * Copyright (C) 2013 Red Hat, Inc., Frederic Weisbecker <fweisbec@redhat.com>
+ *
+ * Licensed under the terms of the GNU GPL License version 2
+ *
+ * Selftests for a few posix timers interface.
+ *
+ * Kernel loop code stolen from Steven Rostedt <srostedt@redhat.com>
+ */
+
+#include <sys/time.h>
+#include <stdio.h>
+#include <signal.h>
+#include <unistd.h>
+#include <time.h>
+#include <pthread.h>
+
+#define DELAY 2
+#define USECS_PER_SEC 1000000
+
+static volatile int done;
+
+/* Busy loop in userspace to elapse ITIMER_VIRTUAL */
+static void user_loop(void)
+{
+	while (!done);
+}
+
+/*
+ * Try to spend as much time as possible in kernelspace
+ * to elapse ITIMER_PROF.
+ */
+static void kernel_loop(void)
+{
+	void *addr = sbrk(0);
+
+	while (!done) {
+		brk(addr + 4096);
+		brk(addr);
+	}
+}
+
+/*
+ * Sleep until ITIMER_REAL expiration.
+ */
+static void idle_loop(void)
+{
+	pause();
+}
+
+static void sig_handler(int nr)
+{
+	done = 1;
+}
+
+/*
+ * Check the expected timer expiration matches the GTOD elapsed delta since
+ * we armed the timer. Keep a 0.5 sec error margin due to various jitter.
+ */
+static int check_diff(struct timeval start, struct timeval end)
+{
+	long long diff;
+
+	diff = end.tv_usec - start.tv_usec;
+	diff += (end.tv_sec - start.tv_sec) * USECS_PER_SEC;
+
+	if (abs(diff - DELAY * USECS_PER_SEC) > USECS_PER_SEC / 2) {
+		printf("Diff too high: %lld..", diff);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int check_itimer(int which)
+{
+	int err;
+	struct timeval start, end;
+	struct itimerval val = {
+		.it_value.tv_sec = DELAY,
+	};
+
+	printf("Check itimer ");
+
+	if (which == ITIMER_VIRTUAL)
+		printf("virtual... ");
+	else if (which == ITIMER_PROF)
+		printf("prof... ");
+	else if (which == ITIMER_REAL)
+		printf("real... ");
+
+	fflush(stdout);
+
+	done = 0;
+
+	if (which == ITIMER_VIRTUAL)
+		signal(SIGVTALRM, sig_handler);
+	else if (which == ITIMER_PROF)
+		signal(SIGPROF, sig_handler);
+	else if (which == ITIMER_REAL)
+		signal(SIGALRM, sig_handler);
+
+	err = gettimeofday(&start, NULL);
+	if (err < 0) {
+		perror("Can't call gettimeofday()\n");
+		return -1;
+	}
+
+	err = setitimer(which, &val, NULL);
+	if (err < 0) {
+		perror("Can't set timer\n");
+		return -1;
+	}
+
+	if (which == ITIMER_VIRTUAL)
+		user_loop();
+	else if (which == ITIMER_PROF)
+		kernel_loop();
+	else if (which == ITIMER_REAL)
+		idle_loop();
+
+	gettimeofday(&end, NULL);
+	if (err < 0) {
+		perror("Can't call gettimeofday()\n");
+		return -1;
+	}
+
+	if (!check_diff(start, end))
+		printf("[OK]\n");
+	else
+		printf("[FAIL]\n");
+
+	return 0;
+}
+
+static int check_timer_create(int which)
+{
+	int err;
+	timer_t id;
+	struct timeval start, end;
+	struct itimerspec val = {
+		.it_value.tv_sec = DELAY,
+	};
+
+	printf("Check timer_create() ");
+	if (which == CLOCK_THREAD_CPUTIME_ID) {
+		printf("per thread... ");
+	} else if (which == CLOCK_PROCESS_CPUTIME_ID) {
+		printf("per process... ");
+	}
+	fflush(stdout);
+
+	done = 0;
+	timer_create(which, NULL, &id);
+	if (err < 0) {
+		perror("Can't create timer\n");
+		return -1;
+	}
+	signal(SIGALRM, sig_handler);
+
+	err = gettimeofday(&start, NULL);
+	if (err < 0) {
+		perror("Can't call gettimeofday()\n");
+		return -1;
+	}
+
+	err = timer_settime(id, 0, &val, NULL);
+	if (err < 0) {
+		perror("Can't set timer\n");
+		return -1;
+	}
+
+	user_loop();
+
+	gettimeofday(&end, NULL);
+	if (err < 0) {
+		perror("Can't call gettimeofday()\n");
+		return -1;
+	}
+
+	if (!check_diff(start, end))
+		printf("[OK]\n");
+	else
+		printf("[FAIL]\n");
+
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	int err;
+
+	printf("Testing posix timers. False negative may happen on CPU execution \n");
+	printf("based timers if other threads run on the CPU...\n");
+
+	if (check_itimer(ITIMER_VIRTUAL) < 0)
+		return -1;
+
+	if (check_itimer(ITIMER_PROF) < 0)
+		return -1;
+
+	if (check_itimer(ITIMER_REAL) < 0)
+		return -1;
+
+	if (check_timer_create(CLOCK_THREAD_CPUTIME_ID) < 0)
+		return -1;
+
+	/*
+	 * It's unfortunately hard to reliably test a timer expiration
+	 * on parallel multithread cputime. We could arm it to expire
+	 * on DELAY * nr_threads, with nr_threads busy looping, then wait
+	 * the normal DELAY since the time is elapsing nr_threads faster.
+	 * But for that we need to ensure we have real physical free CPUs
+	 * to ensure true parallelism. So test only one thread until we
+	 * find a better solution.
+	 */
+	if (check_timer_create(CLOCK_PROCESS_CPUTIME_ID) < 0)
+		return -1;
+
+	return 0;
+}
_

Patches currently in -mm which might be from fweisbec@gmail.com are

origin.patch
linux-next.patch
ptrace-x86-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-powerpc-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-arm-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-sh-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints.patch
ptrace-x86-simplify-the-disable-logic-in-ptrace_write_dr7.patch
ptrace-x86-dont-delay-disable-till-second-pass-in-ptrace_write_dr7.patch
ptrace-x86-introduce-ptrace_register_breakpoint.patch
ptrace-x86-ptrace_write_dr7-should-create-bp-if-disabled.patch
ptrace-x86-cleanup-ptrace_set_debugreg.patch
ptrace-ptrace_detach-should-do-flush_ptrace_hw_breakpointchild.patch
ptrace-x86-flush_ptrace_hw_breakpoint-shoule-clear-the-virtual-debug-registers.patch

