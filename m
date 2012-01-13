From: akpm@linux-foundation.org
Subject: [merged] selftests-new-x86-breakpoints-selftest.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:37:13 -0800
Message-ID: <20120113203714.2C2C920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57647 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab2AMUhQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:37:16 -0500
Received: by mail-ee0-f74.google.com with SMTP id e50so23684eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:37:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, hpa@zytor.com, jason.wessel@windriver.com, mingo@elte.hu, mmarek@suse.cz, sam@ravnborg.org, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: new x86 breakpoints selftest
has been removed from the -mm tree.  Its filename was
     selftests-new-x86-breakpoints-selftest.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: selftests: new x86 breakpoints selftest

Bring a first selftest in the relevant directory.  This tests several
combinations of breakpoints and watchpoints in x86, as well as icebp traps
and int3 traps.  Given the amount of breakpoint regressions we raised
after we merged the generic breakpoint infrastructure, such selftest
became necessary and can still serve today as a basis for new patches that
touch the do_debug() path.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile                      |    2 
 tools/testing/selftests/breakpoints/Makefile          |   20 
 tools/testing/selftests/breakpoints/breakpoint_test.c |  394 ++++++++++
 tools/testing/selftests/run_tests                     |    2 
 4 files changed, 416 insertions(+), 2 deletions(-)

diff -puN tools/testing/selftests/Makefile~selftests-new-x86-breakpoints-selftest tools/testing/selftests/Makefile
--- a/tools/testing/selftests/Makefile~selftests-new-x86-breakpoints-selftest
+++ a/tools/testing/selftests/Makefile
@@ -1,4 +1,4 @@
-TARGETS =
+TARGETS = breakpoints
 
 all:
 	for TARGET in $(TARGETS); do \
diff -puN /dev/null tools/testing/selftests/breakpoints/Makefile
--- /dev/null
+++ a/tools/testing/selftests/breakpoints/Makefile
@@ -0,0 +1,20 @@
+# Taken from perf makefile
+uname_M := $(shell uname -m 2>/dev/null || echo not)
+ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
+ifeq ($(ARCH),i386)
+        ARCH := x86
+endif
+ifeq ($(ARCH),x86_64)
+	ARCH := x86
+endif
+
+
+all:
+ifeq ($(ARCH),x86)
+	gcc breakpoint_test.c -o run_test
+else
+	echo "Not an x86 target, can't build breakpoints selftests"
+endif
+
+clean:
+	rm -fr run_test
diff -puN /dev/null tools/testing/selftests/breakpoints/breakpoint_test.c
--- /dev/null
+++ a/tools/testing/selftests/breakpoints/breakpoint_test.c
@@ -0,0 +1,394 @@
+/*
+ * Copyright (C) 2011 Red Hat, Inc., Frederic Weisbecker <fweisbec@redhat.com>
+ *
+ * Licensed under the terms of the GNU GPL License version 2
+ *
+ * Selftests for breakpoints (and more generally the do_debug() path) in x86.
+ */
+
+
+#include <sys/ptrace.h>
+#include <unistd.h>
+#include <stddef.h>
+#include <sys/user.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <signal.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+
+
+/* Breakpoint access modes */
+enum {
+	BP_X = 1,
+	BP_RW = 2,
+	BP_W = 4,
+};
+
+static pid_t child_pid;
+
+/*
+ * Ensures the child and parent are always "talking" about
+ * the same test sequence. (ie: that we haven't forgotten
+ * to call check_trapped() somewhere).
+ */
+static int nr_tests;
+
+static void set_breakpoint_addr(void *addr, int n)
+{
+	int ret;
+
+	ret = ptrace(PTRACE_POKEUSER, child_pid,
+		     offsetof(struct user, u_debugreg[n]), addr);
+	if (ret) {
+		perror("Can't set breakpoint addr\n");
+		exit(-1);
+	}
+}
+
+static void toggle_breakpoint(int n, int type, int len,
+			      int local, int global, int set)
+{
+	int ret;
+
+	int xtype, xlen;
+	unsigned long vdr7, dr7;
+
+	switch (type) {
+	case BP_X:
+		xtype = 0;
+		break;
+	case BP_W:
+		xtype = 1;
+		break;
+	case BP_RW:
+		xtype = 3;
+		break;
+	}
+
+	switch (len) {
+	case 1:
+		xlen = 0;
+		break;
+	case 2:
+		xlen = 4;
+		break;
+	case 4:
+		xlen = 0xc;
+		break;
+	case 8:
+		xlen = 8;
+		break;
+	}
+
+	dr7 = ptrace(PTRACE_PEEKUSER, child_pid,
+		     offsetof(struct user, u_debugreg[7]), 0);
+
+	vdr7 = (xlen | xtype) << 16;
+	vdr7 <<= 4 * n;
+
+	if (local) {
+		vdr7 |= 1 << (2 * n);
+		vdr7 |= 1 << 8;
+	}
+	if (global) {
+		vdr7 |= 2 << (2 * n);
+		vdr7 |= 1 << 9;
+	}
+
+	if (set)
+		dr7 |= vdr7;
+	else
+		dr7 &= ~vdr7;
+
+	ret = ptrace(PTRACE_POKEUSER, child_pid,
+		     offsetof(struct user, u_debugreg[7]), dr7);
+	if (ret) {
+		perror("Can't set dr7");
+		exit(-1);
+	}
+}
+
+/* Dummy variables to test read/write accesses */
+static unsigned long long dummy_var[4];
+
+/* Dummy functions to test execution accesses */
+static void dummy_func(void) { }
+static void dummy_func1(void) { }
+static void dummy_func2(void) { }
+static void dummy_func3(void) { }
+
+static void (*dummy_funcs[])(void) = {
+	dummy_func,
+	dummy_func1,
+	dummy_func2,
+	dummy_func3,
+};
+
+static int trapped;
+
+static void check_trapped(void)
+{
+	/*
+	 * If we haven't trapped, wake up the parent
+	 * so that it notices the failure.
+	 */
+	if (!trapped)
+		kill(getpid(), SIGUSR1);
+	trapped = 0;
+
+	nr_tests++;
+}
+
+static void write_var(int len)
+{
+	char *pcval; short *psval; int *pival; long long *plval;
+	int i;
+
+	for (i = 0; i < 4; i++) {
+		switch (len) {
+		case 1:
+			pcval = (char *)&dummy_var[i];
+			*pcval = 0xff;
+			break;
+		case 2:
+			psval = (short *)&dummy_var[i];
+			*psval = 0xffff;
+			break;
+		case 4:
+			pival = (int *)&dummy_var[i];
+			*pival = 0xffffffff;
+			break;
+		case 8:
+			plval = (long long *)&dummy_var[i];
+			*plval = 0xffffffffffffffffLL;
+			break;
+		}
+		check_trapped();
+	}
+}
+
+static void read_var(int len)
+{
+	char cval; short sval; int ival; long long lval;
+	int i;
+
+	for (i = 0; i < 4; i++) {
+		switch (len) {
+		case 1:
+			cval = *(char *)&dummy_var[i];
+			break;
+		case 2:
+			sval = *(short *)&dummy_var[i];
+			break;
+		case 4:
+			ival = *(int *)&dummy_var[i];
+			break;
+		case 8:
+			lval = *(long long *)&dummy_var[i];
+			break;
+		}
+		check_trapped();
+	}
+}
+
+/*
+ * Do the r/w/x accesses to trigger the breakpoints. And run
+ * the usual traps.
+ */
+static void trigger_tests(void)
+{
+	int len, local, global, i;
+	char val;
+	int ret;
+
+	ret = ptrace(PTRACE_TRACEME, 0, NULL, 0);
+	if (ret) {
+		perror("Can't be traced?\n");
+		return;
+	}
+
+	/* Wake up father so that it sets up the first test */
+	kill(getpid(), SIGUSR1);
+
+	/* Test instruction breakpoints */
+	for (local = 0; local < 2; local++) {
+		for (global = 0; global < 2; global++) {
+			if (!local && !global)
+				continue;
+
+			for (i = 0; i < 4; i++) {
+				dummy_funcs[i]();
+				check_trapped();
+			}
+		}
+	}
+
+	/* Test write watchpoints */
+	for (len = 1; len <= sizeof(long); len <<= 1) {
+		for (local = 0; local < 2; local++) {
+			for (global = 0; global < 2; global++) {
+				if (!local && !global)
+					continue;
+				write_var(len);
+			}
+		}
+	}
+
+	/* Test read/write watchpoints (on read accesses) */
+	for (len = 1; len <= sizeof(long); len <<= 1) {
+		for (local = 0; local < 2; local++) {
+			for (global = 0; global < 2; global++) {
+				if (!local && !global)
+					continue;
+				read_var(len);
+			}
+		}
+	}
+
+	/* Icebp trap */
+	asm(".byte 0xf1\n");
+	check_trapped();
+
+	/* Int 3 trap */
+	asm("int $3\n");
+	check_trapped();
+
+	kill(getpid(), SIGUSR1);
+}
+
+static void check_success(const char *msg)
+{
+	const char *msg2;
+	int child_nr_tests;
+	int status;
+
+	/* Wait for the child to SIGTRAP */
+	wait(&status);
+
+	msg2 = "Failed";
+
+	if (WSTOPSIG(status) == SIGTRAP) {
+		child_nr_tests = ptrace(PTRACE_PEEKDATA, child_pid,
+					&nr_tests, 0);
+		if (child_nr_tests == nr_tests)
+			msg2 = "Ok";
+		if (ptrace(PTRACE_POKEDATA, child_pid, &trapped, 1)) {
+			perror("Can't poke\n");
+			exit(-1);
+		}
+	}
+
+	nr_tests++;
+
+	printf("%s [%s]\n", msg, msg2);
+}
+
+static void launch_instruction_breakpoints(char *buf, int local, int global)
+{
+	int i;
+
+	for (i = 0; i < 4; i++) {
+		set_breakpoint_addr(dummy_funcs[i], i);
+		toggle_breakpoint(i, BP_X, 1, local, global, 1);
+		ptrace(PTRACE_CONT, child_pid, NULL, 0);
+		sprintf(buf, "Test breakpoint %d with local: %d global: %d",
+			i, local, global);
+		check_success(buf);
+		toggle_breakpoint(i, BP_X, 1, local, global, 0);
+	}
+}
+
+static void launch_watchpoints(char *buf, int mode, int len,
+			       int local, int global)
+{
+	const char *mode_str;
+	int i;
+
+	if (mode == BP_W)
+		mode_str = "write";
+	else
+		mode_str = "read";
+
+	for (i = 0; i < 4; i++) {
+		set_breakpoint_addr(&dummy_var[i], i);
+		toggle_breakpoint(i, mode, len, local, global, 1);
+		ptrace(PTRACE_CONT, child_pid, NULL, 0);
+		sprintf(buf, "Test %s watchpoint %d with len: %d local: "
+			"%d global: %d", mode_str, i, len, local, global);
+		check_success(buf);
+		toggle_breakpoint(i, mode, len, local, global, 0);
+	}
+}
+
+/* Set the breakpoints and check the child successfully trigger them */
+static void launch_tests(void)
+{
+	char buf[1024];
+	int len, local, global, i;
+
+	/* Instruction breakpoints */
+	for (local = 0; local < 2; local++) {
+		for (global = 0; global < 2; global++) {
+			if (!local && !global)
+				continue;
+			launch_instruction_breakpoints(buf, local, global);
+		}
+	}
+
+	/* Write watchpoint */
+	for (len = 1; len <= sizeof(long); len <<= 1) {
+		for (local = 0; local < 2; local++) {
+			for (global = 0; global < 2; global++) {
+				if (!local && !global)
+					continue;
+				launch_watchpoints(buf, BP_W, len,
+						   local, global);
+			}
+		}
+	}
+
+	/* Read-Write watchpoint */
+	for (len = 1; len <= sizeof(long); len <<= 1) {
+		for (local = 0; local < 2; local++) {
+			for (global = 0; global < 2; global++) {
+				if (!local && !global)
+					continue;
+				launch_watchpoints(buf, BP_RW, len,
+						   local, global);
+			}
+		}
+	}
+
+	/* Icebp traps */
+	ptrace(PTRACE_CONT, child_pid, NULL, 0);
+	check_success("Test icebp");
+
+	/* Int 3 traps */
+	ptrace(PTRACE_CONT, child_pid, NULL, 0);
+	check_success("Test int 3 trap");
+
+	ptrace(PTRACE_CONT, child_pid, NULL, 0);
+}
+
+int main(int argc, char **argv)
+{
+	pid_t pid;
+	int ret;
+
+	pid = fork();
+	if (!pid) {
+		trigger_tests();
+		return 0;
+	}
+
+	child_pid = pid;
+
+	wait(NULL);
+
+	launch_tests();
+
+	wait(NULL);
+
+	return 0;
+}
diff -puN tools/testing/selftests/run_tests~selftests-new-x86-breakpoints-selftest tools/testing/selftests/run_tests
--- a/tools/testing/selftests/run_tests~selftests-new-x86-breakpoints-selftest
+++ a/tools/testing/selftests/run_tests
@@ -1,6 +1,6 @@
 #!/bin/bash
 
-TARGETS=
+TARGETS=breakpoints
 
 for TARGET in $TARGETS
 do
_

Patches currently in -mm which might be from fweisbec@gmail.com are

origin.patch
linux-next.patch

