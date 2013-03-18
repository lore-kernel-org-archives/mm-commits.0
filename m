From: akpm@linux-foundation.org
Subject: + selftests-add-basic-posix-timers-selftests.patch added to -mm tree
Date: Mon, 18 Mar 2013 14:25:10 -0700
Message-ID: <20130318212510.D7C2431C022@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:55578 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933126Ab3CRVZM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Mar 2013 17:25:12 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so625057qcs.5
        for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2013 14:25:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fweisbec@gmail.com, a.p.zijlstra@chello.nl, rostedt@goodmis.org, sgruszka@redhat.com, tglx@linutronix.de


The patch titled
     Subject: selftests: add basic posix timers selftests
has been added to the -mm tree.  Its filename is
     selftests-add-basic-posix-timers-selftests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -5,6 +5,7 @@ TARGETS += vm
 TARGETS += cpu-hotplug
 TARGETS += memory-hotplug
 TARGETS += efivarfs
+TARGETS += timers
 
 all:
 	for TARGET in $(TARGETS); do \
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

linux-next.patch
irq_workh-fix-warning-when-config_irq_work=n.patch
printk-provide-a-wake_up_klogd-off-case.patch
printk-provide-a-wake_up_klogd-off-case-fix.patch
posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
selftests-add-basic-posix-timers-selftests.patch
mm-trace-filemap-add-and-del.patch
mm-trace-filemap-add-and-del-v2.patch
printk-tracing-rework-console-tracing.patch

