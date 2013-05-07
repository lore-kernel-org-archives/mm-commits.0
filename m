From: akpm@linux-foundation.org
Subject: [merged] selftest-add-a-test-case-for-ptrace_peeksiginfo.patch removed from -mm tree
Date: Tue, 07 May 2013 10:49:03 -0700
Message-ID: <20130507174903.8F69F5A4228@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:61955 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab3EGRtF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:49:05 -0400
Received: by mail-ve0-f202.google.com with SMTP id 15so85157vea.5
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:49:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, davej@redhat.com, dhowells@redhat.com, mtk.manpages@gmail.com, oleg@redhat.com, palves@redhat.com, paulmck@linux.vnet.ibm.com, roland@redhat.com, torvalds@linux-foundation.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftest: add a test case for PTRACE_PEEKSIGINFO
has been removed from the -mm tree.  Its filename was
     selftest-add-a-test-case-for-ptrace_peeksiginfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Vagin <avagin@openvz.org>
Subject: selftest: add a test case for PTRACE_PEEKSIGINFO

* Dump signals from process-wide and per-thread queues with
  different sizes of buffers.
* Check error paths for buffers with restricted permissions. A part of
  buffer or a whole buffer is for read-only.
* Try to get nonexistent signal.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pedro Alves <palves@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile             |    1 
 tools/testing/selftests/ptrace/Makefile      |   10 
 tools/testing/selftests/ptrace/peeksiginfo.c |  214 +++++++++++++++++
 3 files changed, 225 insertions(+)

diff -puN tools/testing/selftests/Makefile~selftest-add-a-test-case-for-ptrace_peeksiginfo tools/testing/selftests/Makefile
--- a/tools/testing/selftests/Makefile~selftest-add-a-test-case-for-ptrace_peeksiginfo
+++ a/tools/testing/selftests/Makefile
@@ -4,6 +4,7 @@ TARGETS += efivarfs
 TARGETS += kcmp
 TARGETS += memory-hotplug
 TARGETS += mqueue
+TARGETS += ptrace
 TARGETS += soft-dirty
 TARGETS += vm
 
diff -puN /dev/null tools/testing/selftests/ptrace/Makefile
--- /dev/null
+++ a/tools/testing/selftests/ptrace/Makefile
@@ -0,0 +1,10 @@
+CFLAGS += -iquote../../../../include/uapi -Wall
+peeksiginfo: peeksiginfo.c
+
+all: peeksiginfo
+
+clean:
+	rm -f peeksiginfo
+
+run_tests: all
+	@./peeksiginfo || echo "peeksiginfo selftests: [FAIL]"
diff -puN /dev/null tools/testing/selftests/ptrace/peeksiginfo.c
--- /dev/null
+++ a/tools/testing/selftests/ptrace/peeksiginfo.c
@@ -0,0 +1,214 @@
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <signal.h>
+#include <unistd.h>
+#include <errno.h>
+#include <linux/types.h>
+#include <sys/wait.h>
+#include <sys/syscall.h>
+#include <sys/user.h>
+#include <sys/mman.h>
+
+#include "linux/ptrace.h"
+
+static int sys_rt_sigqueueinfo(pid_t tgid, int sig, siginfo_t *uinfo)
+{
+	return syscall(SYS_rt_sigqueueinfo, tgid, sig, uinfo);
+}
+
+static int sys_rt_tgsigqueueinfo(pid_t tgid, pid_t tid,
+					int sig, siginfo_t *uinfo)
+{
+	return syscall(SYS_rt_tgsigqueueinfo, tgid, tid, sig, uinfo);
+}
+
+static int sys_ptrace(int request, pid_t pid, void *addr, void *data)
+{
+	return syscall(SYS_ptrace, request, pid, addr, data);
+}
+
+#define SIGNR 10
+#define TEST_SICODE_PRIV	-1
+#define TEST_SICODE_SHARE	-2
+
+#define err(fmt, ...)						\
+		fprintf(stderr,					\
+			"Error (%s:%d): " fmt,			\
+			__FILE__, __LINE__, ##__VA_ARGS__)
+
+static int check_error_paths(pid_t child)
+{
+	struct ptrace_peeksiginfo_args arg;
+	int ret, exit_code = -1;
+	void *addr_rw, *addr_ro;
+
+	/*
+	 * Allocate two contiguous pages. The first one is for read-write,
+	 * another is for read-only.
+	 */
+	addr_rw = mmap(NULL, 2 * PAGE_SIZE, PROT_READ | PROT_WRITE,
+				MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (addr_rw == MAP_FAILED) {
+		err("mmap() failed: %m\n");
+		return 1;
+	}
+
+	addr_ro = mmap(addr_rw + PAGE_SIZE, PAGE_SIZE, PROT_READ,
+			MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
+	if (addr_ro == MAP_FAILED) {
+		err("mmap() failed: %m\n");
+		goto out;
+	}
+
+	arg.nr = SIGNR;
+	arg.off = 0;
+
+	/* Unsupported flags */
+	arg.flags = ~0;
+	ret = sys_ptrace(PTRACE_PEEKSIGINFO, child, &arg, addr_rw);
+	if (ret != -1 || errno != EINVAL) {
+		err("sys_ptrace() returns %d (expected -1),"
+				" errno %d (expected %d): %m\n",
+				ret, errno, EINVAL);
+		goto out;
+	}
+	arg.flags = 0;
+
+	/* A part of the buffer is read-only */
+	ret = sys_ptrace(PTRACE_PEEKSIGINFO, child, &arg,
+					addr_ro - sizeof(siginfo_t) * 2);
+	if (ret != 2) {
+		err("sys_ptrace() returns %d (expected 2): %m\n", ret);
+		goto out;
+	}
+
+	/* Read-only buffer */
+	ret = sys_ptrace(PTRACE_PEEKSIGINFO, child, &arg, addr_ro);
+	if (ret != -1 && errno != EFAULT) {
+		err("sys_ptrace() returns %d (expected -1),"
+				" errno %d (expected %d): %m\n",
+				ret, errno, EFAULT);
+		goto out;
+	}
+
+	exit_code = 0;
+out:
+	munmap(addr_rw, 2 * PAGE_SIZE);
+	return exit_code;
+}
+
+int check_direct_path(pid_t child, int shared, int nr)
+{
+	struct ptrace_peeksiginfo_args arg = {.flags = 0, .nr = nr, .off = 0};
+	int i, j, ret, exit_code = -1;
+	siginfo_t siginfo[SIGNR];
+	int si_code;
+
+	if (shared == 1) {
+		arg.flags = PTRACE_PEEKSIGINFO_SHARED;
+		si_code = TEST_SICODE_SHARE;
+	} else {
+		arg.flags = 0;
+		si_code = TEST_SICODE_PRIV;
+	}
+
+	for (i = 0; i < SIGNR; ) {
+		arg.off = i;
+		ret = sys_ptrace(PTRACE_PEEKSIGINFO, child, &arg, siginfo);
+		if (ret == -1) {
+			err("ptrace() failed: %m\n");
+			goto out;
+		}
+
+		if (ret == 0)
+			break;
+
+		for (j = 0; j < ret; j++, i++) {
+			if (siginfo[j].si_code == si_code &&
+			    siginfo[j].si_int == i)
+				continue;
+
+			err("%d: Wrong siginfo i=%d si_code=%d si_int=%d\n",
+			     shared, i, siginfo[j].si_code, siginfo[j].si_int);
+			goto out;
+		}
+	}
+
+	if (i != SIGNR) {
+		err("Only %d signals were read\n", i);
+		goto out;
+	}
+
+	exit_code = 0;
+out:
+	return exit_code;
+}
+
+int main(int argc, char *argv[])
+{
+	siginfo_t siginfo[SIGNR];
+	int i, exit_code = 1;
+	sigset_t blockmask;
+	pid_t child;
+
+	sigemptyset(&blockmask);
+	sigaddset(&blockmask, SIGRTMIN);
+	sigprocmask(SIG_BLOCK, &blockmask, NULL);
+
+	child = fork();
+	if (child == -1) {
+		err("fork() failed: %m");
+		return 1;
+	} else if (child == 0) {
+		pid_t ppid = getppid();
+		while (1) {
+			if (ppid != getppid())
+				break;
+			sleep(1);
+		}
+		return 1;
+	}
+
+	/* Send signals in process-wide and per-thread queues */
+	for (i = 0; i < SIGNR; i++) {
+		siginfo->si_code = TEST_SICODE_SHARE;
+		siginfo->si_int = i;
+		sys_rt_sigqueueinfo(child, SIGRTMIN, siginfo);
+
+		siginfo->si_code = TEST_SICODE_PRIV;
+		siginfo->si_int = i;
+		sys_rt_tgsigqueueinfo(child, child, SIGRTMIN, siginfo);
+	}
+
+	if (sys_ptrace(PTRACE_ATTACH, child, NULL, NULL) == -1)
+		return 1;
+
+	waitpid(child, NULL, 0);
+
+	/* Dump signals one by one*/
+	if (check_direct_path(child, 0, 1))
+		goto out;
+	/* Dump all signals for one call */
+	if (check_direct_path(child, 0, SIGNR))
+		goto out;
+
+	/*
+	 * Dump signal from the process-wide queue.
+	 * The number of signals is not multible to the buffer size
+	 */
+	if (check_direct_path(child, 1, 3))
+		goto out;
+
+	if (check_error_paths(child))
+		goto out;
+
+	printf("PASS\n");
+	exit_code = 0;
+out:
+	if (sys_ptrace(PTRACE_KILL, child, NULL, NULL) == -1)
+		return 1;
+
+	waitpid(child, NULL, 0);
+
+	return exit_code;
+}
_

Patches currently in -mm which might be from avagin@openvz.org are

origin.patch

