From: akpm@linux-foundation.org
Subject: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
Date: Tue, 14 Feb 2012 15:15:41 -0800
Message-ID: <20120214231541.72DC3A023F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:40671 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932616Ab2BNXPm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2012 18:15:42 -0500
Received: by yenm1 with SMTP id m1so70864yen.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2012 15:15:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, adobriyan@gmail.com, andi@firstfloor.org, avagin@openvz.org, ebiederm@xmission.com, eric.dumazet@gmail.com, fweisbec@gmail.com, glommer@parallels.com, hpa@zytor.com, kosaki.motohiro@gmail.com, matthltc@us.ibm.com, mingo@elte.hu, mmarek@suse.cz, penberg@kernel.org, segoon@openwall.com, tglx@linutronix.de, tj@kernel.org, xemul@parallels.com


The patch titled
     Subject: syscalls, x86: add __NR_kcmp syscall
has been added to the -mm tree.  Its filename is
     syscalls-x86-add-__nr_kcmp-syscall-v8.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: syscalls, x86: add __NR_kcmp syscall

While doing the checkpoint-restore in the user space one need to determine
whether various kernel objects (like mm_struct-s of file_struct-s) are
shared between tasks and restore this state.

The 2nd step can be solved by using appropriate CLONE_ flags and the
unshare syscall, while there's currently no ways for solving the 1st one.

One of the ways for checking whether two tasks share e.g.  mm_struct is to
provide some mm_struct ID of a task to its proc file, but showing such
info considered to be not that good for security reasons.

Thus after some debates we end up in conclusion that using that named
'comparison' syscall might be the best candidate.  So here is it --
__NR_kcmp.

It takes up to 5 arguments - the pids of the two tasks (which
characteristics should be compared), the comparison type and (in case of
comparison of files) two file descriptors.

Lookups for pids are done in the caller's PID namespace only.

At moment only x86 is supported and tested.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Valdis.Kletnieks@vt.edu
Cc: Michal Marek <mmarek@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/syscalls/syscall_32.tbl         |    1 
 arch/x86/syscalls/syscall_64.tbl         |    1 
 include/linux/kcmp.h                     |   17 ++
 include/linux/syscalls.h                 |    2 
 kernel/Makefile                          |    3 
 kernel/kcmp.c                            |  155 +++++++++++++++++++++
 kernel/sys_ni.c                          |    3 
 tools/testing/selftests/kcmp/Makefile    |   36 ++++
 tools/testing/selftests/kcmp/kcmp_test.c |   84 +++++++++++
 9 files changed, 302 insertions(+)

diff -puN arch/x86/syscalls/syscall_32.tbl~syscalls-x86-add-__nr_kcmp-syscall-v8 arch/x86/syscalls/syscall_32.tbl
--- a/arch/x86/syscalls/syscall_32.tbl~syscalls-x86-add-__nr_kcmp-syscall-v8
+++ a/arch/x86/syscalls/syscall_32.tbl
@@ -355,3 +355,4 @@
 346	i386	setns			sys_setns
 347	i386	process_vm_readv	sys_process_vm_readv		compat_sys_process_vm_readv
 348	i386	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
+349	i386	kcmp			sys_kcmp
diff -puN arch/x86/syscalls/syscall_64.tbl~syscalls-x86-add-__nr_kcmp-syscall-v8 arch/x86/syscalls/syscall_64.tbl
--- a/arch/x86/syscalls/syscall_64.tbl~syscalls-x86-add-__nr_kcmp-syscall-v8
+++ a/arch/x86/syscalls/syscall_64.tbl
@@ -318,3 +318,4 @@
 309	64	getcpu			sys_getcpu
 310	64	process_vm_readv	sys_process_vm_readv
 311	64	process_vm_writev	sys_process_vm_writev
+312	64	kcmp			sys_kcmp
diff -puN /dev/null include/linux/kcmp.h
--- /dev/null
+++ a/include/linux/kcmp.h
@@ -0,0 +1,17 @@
+#ifndef _LINUX_KCMP_H
+#define _LINUX_KCMP_H
+
+/* Comparison type */
+enum kcmp_type {
+	KCMP_FILE,
+	KCMP_VM,
+	KCMP_FILES,
+	KCMP_FS,
+	KCMP_SIGHAND,
+	KCMP_IO,
+	KCMP_SYSVSEM,
+
+	KCMP_TYPES,
+};
+
+#endif /* _LINUX_KCMP_H */
diff -puN include/linux/syscalls.h~syscalls-x86-add-__nr_kcmp-syscall-v8 include/linux/syscalls.h
--- a/include/linux/syscalls.h~syscalls-x86-add-__nr_kcmp-syscall-v8
+++ a/include/linux/syscalls.h
@@ -857,4 +857,6 @@ asmlinkage long sys_process_vm_writev(pi
 				      unsigned long riovcnt,
 				      unsigned long flags);
 
+asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
+			 unsigned long idx1, unsigned long idx2);
 #endif
diff -puN kernel/Makefile~syscalls-x86-add-__nr_kcmp-syscall-v8 kernel/Makefile
--- a/kernel/Makefile~syscalls-x86-add-__nr_kcmp-syscall-v8
+++ a/kernel/Makefile
@@ -25,6 +25,9 @@ endif
 obj-y += sched/
 obj-y += power/
 
+ifeq ($(CONFIG_CHECKPOINT_RESTORE),y)
+obj-$(CONFIG_X86) += kcmp.o
+endif
 obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
diff -puN /dev/null kernel/kcmp.c
--- /dev/null
+++ a/kernel/kcmp.c
@@ -0,0 +1,155 @@
+#include <linux/kernel.h>
+#include <linux/syscalls.h>
+#include <linux/fdtable.h>
+#include <linux/string.h>
+#include <linux/random.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/cache.h>
+#include <linux/bug.h>
+#include <linux/err.h>
+#include <linux/kcmp.h>
+
+#include <asm/unistd.h>
+
+/*
+ * We don't expose real in-memory order of objects for security
+ * reasons, still the comparison results should be suitable for
+ * sorting. Thus, we obfuscate kernel pointers values and compare
+ * the production instead.
+ */
+static unsigned long cookies[KCMP_TYPES][2] __read_mostly;
+
+static long kptr_obfuscate(long v, int type)
+{
+	return (v ^ cookies[type][0]) * cookies[type][1];
+}
+
+/*
+ * 0 - equal, i.e. v1 = v2
+ * 1 - less than, i.e. v1 < v2
+ * 2 - greater than, i.e. v1 > v2
+ * 3 - not equal but ordering unavailable (reserved for future)
+ */
+static int kcmp_ptr(void *v1, void *v2, enum kcmp_type type)
+{
+	long ret;
+
+	ret = kptr_obfuscate((long)v1, type) - kptr_obfuscate((long)v2, type);
+
+	return (ret < 0) | ((ret > 0) << 1);
+}
+
+/* The caller must have pinned the task */
+static struct file *
+get_file_raw_ptr(struct task_struct *task, unsigned int idx)
+{
+	struct fdtable *fdt;
+	struct file *file;
+
+	spin_lock(&task->files->file_lock);
+	fdt = files_fdtable(task->files);
+	if (idx < fdt->max_fds)
+		file = fdt->fd[idx];
+	else
+		file = NULL;
+	spin_unlock(&task->files->file_lock);
+
+	return file;
+}
+
+SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t, pid2, int, type,
+		unsigned long, idx1, unsigned long, idx2)
+{
+	struct task_struct *task1, *task2;
+	int ret;
+
+	rcu_read_lock();
+
+	/*
+	 * Tasks are looked up in caller's PID namespace only.
+	 */
+	task1 = find_task_by_vpid(pid1);
+	task2 = find_task_by_vpid(pid2);
+	if (!task1 || !task2)
+		goto err_no_task;
+
+	get_task_struct(task1);
+	get_task_struct(task2);
+
+	rcu_read_unlock();
+
+	/*
+	 * One should have enough rights to inspect task details.
+	 */
+	if (!ptrace_may_access(task1, PTRACE_MODE_READ) ||
+	    !ptrace_may_access(task2, PTRACE_MODE_READ)) {
+		ret = -EACCES;
+		goto err;
+	}
+
+	switch (type) {
+	case KCMP_FILE: {
+		struct file *filp1, *filp2;
+
+		filp1 = get_file_raw_ptr(task1, idx1);
+		filp2 = get_file_raw_ptr(task2, idx2);
+
+		if (filp1 && filp2)
+			ret = kcmp_ptr(filp1, filp2, KCMP_FILE);
+		else
+			ret = -EBADF;
+		break;
+	}
+	case KCMP_VM:
+		ret = kcmp_ptr(task1->mm, task2->mm, KCMP_VM);
+		break;
+	case KCMP_FILES:
+		ret = kcmp_ptr(task1->files, task2->files, KCMP_FILES);
+		break;
+	case KCMP_FS:
+		ret = kcmp_ptr(task1->fs, task2->fs, KCMP_FS);
+		break;
+	case KCMP_SIGHAND:
+		ret = kcmp_ptr(task1->sighand, task2->sighand, KCMP_SIGHAND);
+		break;
+	case KCMP_IO:
+		ret = kcmp_ptr(task1->io_context, task2->io_context, KCMP_IO);
+		break;
+	case KCMP_SYSVSEM:
+#ifdef CONFIG_SYSVIPC
+		ret = kcmp_ptr(task1->sysvsem.undo_list,
+			       task2->sysvsem.undo_list,
+			       KCMP_SYSVSEM);
+#else
+		ret = -EOPNOTSUP;
+#endif
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+err:
+	put_task_struct(task1);
+	put_task_struct(task2);
+
+	return ret;
+
+err_no_task:
+	rcu_read_unlock();
+	return -ESRCH;
+}
+
+static __init int kcmp_cookies_init(void)
+{
+	int i;
+
+	get_random_bytes(cookies, sizeof(cookies));
+
+	for (i = 0; i < KCMP_TYPES; i++)
+		cookies[i][1] |= (~(~0UL >>  1) | 1);
+
+	return 0;
+}
+arch_initcall(kcmp_cookies_init);
diff -puN kernel/sys_ni.c~syscalls-x86-add-__nr_kcmp-syscall-v8 kernel/sys_ni.c
--- a/kernel/sys_ni.c~syscalls-x86-add-__nr_kcmp-syscall-v8
+++ a/kernel/sys_ni.c
@@ -203,3 +203,6 @@ cond_syscall(sys_fanotify_mark);
 cond_syscall(sys_name_to_handle_at);
 cond_syscall(sys_open_by_handle_at);
 cond_syscall(compat_sys_open_by_handle_at);
+
+/* compare kernel pointers */
+cond_syscall(sys_kcmp);
diff -puN /dev/null tools/testing/selftests/kcmp/Makefile
--- /dev/null
+++ a/tools/testing/selftests/kcmp/Makefile
@@ -0,0 +1,36 @@
+ifeq ($(strip $(V)),)
+	E = @echo
+	Q = @
+else
+	E = @\#
+	Q =
+endif
+export E Q
+
+uname_M := $(shell uname -m 2>/dev/null || echo not)
+ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
+ifeq ($(ARCH),i386)
+        ARCH := X86
+	CFLAGS := -DCONFIG_X86_32 -D__i386__
+endif
+ifeq ($(ARCH),x86_64)
+	ARCH := X86
+	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
+endif
+
+CFLAGS += -I../../../../arch/x86/include/generated/
+CFLAGS += -I../../../../include/
+CFLAGS += -I../../../../usr/include/
+
+all:
+ifeq ($(ARCH),X86)
+	$(E) "  CC run_test"
+	$(Q) gcc $(CFLAGS) kcmp_test.c -o run_test
+else
+	$(E) "Not an x86 target, can't build kcmp selftest"
+endif
+
+clean:
+	$(E) "  CLEAN"
+	$(Q) rm -fr ./run_test
+	$(Q) rm -fr ./test-file
diff -puN /dev/null tools/testing/selftests/kcmp/kcmp_test.c
--- /dev/null
+++ a/tools/testing/selftests/kcmp/kcmp_test.c
@@ -0,0 +1,84 @@
+#define _GNU_SOURCE
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <signal.h>
+#include <limits.h>
+#include <unistd.h>
+#include <errno.h>
+#include <string.h>
+#include <fcntl.h>
+
+#include <linux/unistd.h>
+#include <linux/kcmp.h>
+
+#include <sys/syscall.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
+
+static long sys_kcmp(int pid1, int pid2, int type, int fd1, int fd2)
+{
+	return syscall(__NR_kcmp, pid1, pid2, type, fd1, fd2);
+}
+
+int main(int argc, char **argv)
+{
+	const char kpath[] = "kcmp-test-file";
+	int pid1, pid2;
+	int fd1, fd2;
+	int status;
+
+	fd1 = open(kpath, O_RDWR | O_CREAT | O_TRUNC, 0644);
+	pid1 = getpid();
+
+	if (fd1 < 0) {
+		perror("Can't create file");
+		exit(1);
+	}
+
+	pid2 = fork();
+	if (pid2 < 0) {
+		perror("fork failed");
+		exit(1);
+	}
+
+	if (!pid2) {
+		int pid2 = getpid();
+		int ret;
+
+		fd2 = open(kpath, O_RDWR, 0644);
+		if (fd2 < 0) {
+			perror("Can't open file");
+			exit(1);
+		}
+
+		/* An example of output and arguments */
+		printf("pid1: %6d pid2: %6d FD: %2d FILES: %2d VM: %2d FS: %2d "
+		       "SIGHAND: %2d IO: %2d SYSVSEM: %2d INV: %2d\n",
+		       pid1, pid2,
+		       sys_kcmp(pid1, pid2, KCMP_FILE,		fd1, fd2),
+		       sys_kcmp(pid1, pid2, KCMP_FILES,		0, 0),
+		       sys_kcmp(pid1, pid2, KCMP_VM,		0, 0),
+		       sys_kcmp(pid1, pid2, KCMP_FS,		0, 0),
+		       sys_kcmp(pid1, pid2, KCMP_SIGHAND,	0, 0),
+		       sys_kcmp(pid1, pid2, KCMP_IO,		0, 0),
+		       sys_kcmp(pid1, pid2, KCMP_SYSVSEM,	0, 0),
+
+			/* This one should fail */
+		       sys_kcmp(pid1, pid2, KCMP_TYPES + 1,	0, 0));
+
+		/* This one should return same fd */
+		ret = sys_kcmp(pid1, pid2, KCMP_FILE, fd1, fd1);
+		if (ret) {
+			printf("FAIL: 0 expected but %d returned\n", ret);
+			ret = -1;
+		} else
+			printf("PASS: 0 returned as expected\n");
+		exit(ret);
+	}
+
+	waitpid(pid2, &status, P_ALL);
+
+	return 0;
+}
_
Subject: Subject: syscalls, x86: add __NR_kcmp syscall

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch

