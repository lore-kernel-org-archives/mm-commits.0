From: akpm@linux-foundation.org
Subject: + selftests-add-test-of-pmu-instruction-counting-on-powerpc.patch added to -mm tree
Date: Tue, 06 Aug 2013 14:47:36 -0700
Message-ID: <52016ef8.l3b6ca8P7u2+ulpV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56432 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915Ab3HFVrh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Aug 2013 17:47:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mikey@neuling.org, jk@ozlabs.org, benh@kernel.crashing.org, anton@samba.org, michael@ellerman.id.au

Subject: + selftests-add-test-of-pmu-instruction-counting-on-powerpc.patch added to -mm tree
To: michael@ellerman.id.au,anton@samba.org,benh@kernel.crashing.org,jk@ozlabs.org,mikey@neuling.org
From: akpm@linux-foundation.org
Date: Tue, 06 Aug 2013 14:47:36 -0700


The patch titled
     Subject: selftests: add test of PMU instruction counting on powerpc
has been added to the -mm tree.  Its filename is
     selftests-add-test-of-pmu-instruction-counting-on-powerpc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-add-test-of-pmu-instruction-counting-on-powerpc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-add-test-of-pmu-instruction-counting-on-powerpc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michael Ellerman <michael@ellerman.id.au>
Subject: selftests: add test of PMU instruction counting on powerpc

Add a test of instruction counting using the PMU on powerpc.

Although the bulk of the code is architecture agnostic, the code needs to
run a precisely sized loop which is implemented in assembler.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Cc: Anton Blanchard <anton@samba.org>
Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/powerpc/Makefile                 |    2 
 tools/testing/selftests/powerpc/pmu/Makefile             |   23 +
 tools/testing/selftests/powerpc/pmu/count_instructions.c |  135 ++++++++++
 tools/testing/selftests/powerpc/pmu/event.c              |  105 +++++++
 tools/testing/selftests/powerpc/pmu/event.h              |   39 ++
 tools/testing/selftests/powerpc/pmu/loop.S               |   46 +++
 6 files changed, 349 insertions(+), 1 deletion(-)

diff -puN tools/testing/selftests/powerpc/Makefile~selftests-add-test-of-pmu-instruction-counting-on-powerpc tools/testing/selftests/powerpc/Makefile
--- a/tools/testing/selftests/powerpc/Makefile~selftests-add-test-of-pmu-instruction-counting-on-powerpc
+++ a/tools/testing/selftests/powerpc/Makefile
@@ -13,7 +13,7 @@ CFLAGS := -Wall -O2 -flto -Wall -Werror
 
 export CC CFLAGS
 
-TARGETS =
+TARGETS = pmu
 
 endif
 
diff -puN /dev/null tools/testing/selftests/powerpc/pmu/Makefile
--- /dev/null
+++ a/tools/testing/selftests/powerpc/pmu/Makefile
@@ -0,0 +1,23 @@
+noarg:
+	$(MAKE) -C ../
+
+PROGS := count_instructions
+EXTRA_SOURCES := ../harness.c event.c
+
+all: $(PROGS)
+
+$(PROGS): $(EXTRA_SOURCES)
+
+# loop.S can only be built 64-bit
+count_instructions: loop.S count_instructions.c $(EXTRA_SOURCES)
+	$(CC) $(CFLAGS) -m64 -o $@ $^
+
+run_tests: all
+	@-for PROG in $(PROGS); do \
+		./$$PROG; \
+	done;
+
+clean:
+	rm -f $(PROGS) loop.o
+
+.PHONY: all run_tests clean
diff -puN /dev/null tools/testing/selftests/powerpc/pmu/count_instructions.c
--- /dev/null
+++ a/tools/testing/selftests/powerpc/pmu/count_instructions.c
@@ -0,0 +1,135 @@
+/*
+ * Copyright 2013, Michael Ellerman, IBM Corp.
+ * Licensed under GPLv2.
+ */
+
+#define _GNU_SOURCE
+
+#include <stdio.h>
+#include <stdbool.h>
+#include <string.h>
+#include <sys/prctl.h>
+
+#include "event.h"
+#include "utils.h"
+
+extern void thirty_two_instruction_loop(u64 loops);
+
+static void setup_event(struct event *e, u64 config, char *name)
+{
+	event_init_opts(e, config, PERF_TYPE_HARDWARE, name);
+
+	e->attr.disabled = 1;
+	e->attr.exclude_kernel = 1;
+	e->attr.exclude_hv = 1;
+	e->attr.exclude_idle = 1;
+}
+
+static int do_count_loop(struct event *events, u64 instructions,
+			 u64 overhead, bool report)
+{
+	s64 difference, expected;
+	double percentage;
+
+	prctl(PR_TASK_PERF_EVENTS_ENABLE);
+
+	/* Run for 1M instructions */
+	thirty_two_instruction_loop(instructions >> 5);
+
+	prctl(PR_TASK_PERF_EVENTS_DISABLE);
+
+	event_read(&events[0]);
+	event_read(&events[1]);
+
+	expected = instructions + overhead;
+	difference = events[0].result.value - expected;
+	percentage = (double)difference / events[0].result.value * 100;
+
+	if (report) {
+		event_report(&events[0]);
+		event_report(&events[1]);
+
+		printf("Looped for %llu instructions, overhead %llu\n", instructions, overhead);
+		printf("Expected %llu\n", expected);
+		printf("Actual   %llu\n", events[0].result.value);
+		printf("Delta    %lld, %f%%\n", difference, percentage);
+	}
+
+	event_reset(&events[0]);
+	event_reset(&events[1]);
+
+	if (difference < 0)
+		difference = -difference;
+
+	/* Tolerate a difference below 0.0001 % */
+	difference *= 10000 * 100;
+	if (difference / events[0].result.value)
+		return -1;
+
+	return 0;
+}
+
+/* Count how many instructions it takes to do a null loop */
+static u64 determine_overhead(struct event *events)
+{
+	u64 current, overhead;
+	int i;
+
+	do_count_loop(events, 0, 0, false);
+	overhead = events[0].result.value;
+
+	for (i = 0; i < 100; i++) {
+		do_count_loop(events, 0, 0, false);
+		current = events[0].result.value;
+		if (current < overhead) {
+			printf("Replacing overhead %llu with %llu\n", overhead, current);
+			overhead = current;
+		}
+	}
+
+	return overhead;
+}
+
+static int count_instructions(void)
+{
+	struct event events[2];
+	u64 overhead;
+
+	setup_event(&events[0], PERF_COUNT_HW_INSTRUCTIONS, "instructions");
+	setup_event(&events[1], PERF_COUNT_HW_CPU_CYCLES, "cycles");
+
+	if (event_open(&events[0])) {
+		perror("perf_event_open");
+		return -1;
+	}
+
+	if (event_open_with_group(&events[1], events[0].fd)) {
+		perror("perf_event_open");
+		return -1;
+	}
+
+	overhead = determine_overhead(events);
+	printf("Overhead of null loop: %llu instructions\n", overhead);
+
+	/* Run for 1M instructions */
+	FAIL_IF(do_count_loop(events, 0x100000, overhead, true));
+
+	/* Run for 10M instructions */
+	FAIL_IF(do_count_loop(events, 0xa00000, overhead, true));
+
+	/* Run for 100M instructions */
+	FAIL_IF(do_count_loop(events, 0x6400000, overhead, true));
+
+	/* Run for 1G instructions */
+	FAIL_IF(do_count_loop(events, 0x40000000, overhead, true));
+
+	event_close(&events[0]);
+	event_close(&events[1]);
+
+	return 0;
+}
+
+int main(void)
+{
+	return test_harness(count_instructions, "count_instructions");
+}
diff -puN /dev/null tools/testing/selftests/powerpc/pmu/event.c
--- /dev/null
+++ a/tools/testing/selftests/powerpc/pmu/event.c
@@ -0,0 +1,105 @@
+/*
+ * Copyright 2013, Michael Ellerman, IBM Corp.
+ * Licensed under GPLv2.
+ */
+
+#define _GNU_SOURCE
+#include <unistd.h>
+#include <sys/syscall.h>
+#include <string.h>
+#include <stdio.h>
+#include <sys/ioctl.h>
+
+#include "event.h"
+
+
+int perf_event_open(struct perf_event_attr *attr, pid_t pid, int cpu,
+		int group_fd, unsigned long flags)
+{
+	return syscall(__NR_perf_event_open, attr, pid, cpu,
+			   group_fd, flags);
+}
+
+void event_init_opts(struct event *e, u64 config, int type, char *name)
+{
+	memset(e, 0, sizeof(*e));
+
+	e->name = name;
+
+	e->attr.type = type;
+	e->attr.config = config;
+	e->attr.size = sizeof(e->attr);
+	/* This has to match the structure layout in the header */
+	e->attr.read_format = PERF_FORMAT_TOTAL_TIME_ENABLED | \
+				  PERF_FORMAT_TOTAL_TIME_RUNNING;
+}
+
+void event_init_named(struct event *e, u64 config, char *name)
+{
+	event_init_opts(e, config, PERF_TYPE_RAW, name);
+}
+
+#define PERF_CURRENT_PID	0
+#define PERF_NO_CPU		-1
+#define PERF_NO_GROUP		-1
+
+int event_open_with_options(struct event *e, pid_t pid, int cpu, int group_fd)
+{
+	e->fd = perf_event_open(&e->attr, pid, cpu, group_fd, 0);
+	if (e->fd == -1) {
+		perror("perf_event_open");
+		return -1;
+	}
+
+	return 0;
+}
+
+int event_open_with_group(struct event *e, int group_fd)
+{
+	return event_open_with_options(e, PERF_CURRENT_PID, PERF_NO_CPU, group_fd);
+}
+
+int event_open(struct event *e)
+{
+	return event_open_with_options(e, PERF_CURRENT_PID, PERF_NO_CPU, PERF_NO_GROUP);
+}
+
+void event_close(struct event *e)
+{
+	close(e->fd);
+}
+
+int event_reset(struct event *e)
+{
+	return ioctl(e->fd, PERF_EVENT_IOC_RESET);
+}
+
+int event_read(struct event *e)
+{
+	int rc;
+
+	rc = read(e->fd, &e->result, sizeof(e->result));
+	if (rc != sizeof(e->result)) {
+		fprintf(stderr, "read error on event %p!\n", e);
+		return -1;
+	}
+
+	return 0;
+}
+
+void event_report_justified(struct event *e, int name_width, int result_width)
+{
+	printf("%*s: result %*llu ", name_width, e->name, result_width,
+	       e->result.value);
+
+	if (e->result.running == e->result.enabled)
+		printf("running/enabled %llu\n", e->result.running);
+	else
+		printf("running %llu enabled %llu\n", e->result.running,
+			e->result.enabled);
+}
+
+void event_report(struct event *e)
+{
+	event_report_justified(e, 0, 0);
+}
diff -puN /dev/null tools/testing/selftests/powerpc/pmu/event.h
--- /dev/null
+++ a/tools/testing/selftests/powerpc/pmu/event.h
@@ -0,0 +1,39 @@
+/*
+ * Copyright 2013, Michael Ellerman, IBM Corp.
+ * Licensed under GPLv2.
+ */
+
+#ifndef _SELFTESTS_POWERPC_PMU_EVENT_H
+#define _SELFTESTS_POWERPC_PMU_EVENT_H
+
+#include <unistd.h>
+#include <linux/perf_event.h>
+
+#include "utils.h"
+
+
+struct event {
+	struct perf_event_attr attr;
+	char *name;
+	int fd;
+	/* This must match the read_format we use */
+	struct {
+		u64 value;
+		u64 running;
+		u64 enabled;
+	} result;
+};
+
+void event_init(struct event *e, u64 config);
+void event_init_named(struct event *e, u64 config, char *name);
+void event_init_opts(struct event *e, u64 config, int type, char *name);
+int event_open_with_options(struct event *e, pid_t pid, int cpu, int group_fd);
+int event_open_with_group(struct event *e, int group_fd);
+int event_open(struct event *e);
+void event_close(struct event *e);
+int event_reset(struct event *e);
+int event_read(struct event *e);
+void event_report_justified(struct event *e, int name_width, int result_width);
+void event_report(struct event *e);
+
+#endif /* _SELFTESTS_POWERPC_PMU_EVENT_H */
diff -puN /dev/null tools/testing/selftests/powerpc/pmu/loop.S
--- /dev/null
+++ a/tools/testing/selftests/powerpc/pmu/loop.S
@@ -0,0 +1,46 @@
+/*
+ * Copyright 2013, Michael Ellerman, IBM Corp.
+ * Licensed under GPLv2.
+ */
+
+	.text
+
+	.global thirty_two_instruction_loop
+	.type .thirty_two_instruction_loop,@function
+	.section ".opd","aw",@progbits
+thirty_two_instruction_loop:
+	.quad .thirty_two_instruction_loop, .TOC.@tocbase, 0
+	.previous
+.thirty_two_instruction_loop:
+	cmpwi	%r3,0
+	beqlr
+	addi	%r4,%r3,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1
+	addi	%r4,%r4,1	# 28 addi's
+	subi	%r3,%r3,1
+	b	.thirty_two_instruction_loop
_

Patches currently in -mm which might be from michael@ellerman.id.au are

selftests-add-infrastructure-for-powerpc-selftests.patch
selftests-add-support-files-for-powerpc-tests.patch
selftests-add-test-of-pmu-instruction-counting-on-powerpc.patch
linux-next.patch

