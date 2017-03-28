From: akpm@linux-foundation.org
Subject: + fault-inject-support-systematic-fault-injection.patch added to
 -mm tree
Date: Tue, 28 Mar 2017 14:40:59 -0700
Message-ID: <58dad86b.jE77W4PqXVNEt1O0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42808 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752401AbdC1VlG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2017 17:41:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fault-inject: support systematic fault injection
has been added to the -mm tree.  Its filename is
     fault-inject-support-systematic-fault-injection.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fault-inject-support-systematic-fault-injection.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fault-inject-support-systematic-fault-injection.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Vyukov <dvyukov@google.com>
Subject: fault-inject: support systematic fault injection

Add /proc/self/task/<current-tid>/fail-nth file that allows failing
0-th, 1-st, 2-nd and so on calls systematically.
Excerpt from the added documentation:

===
Write to this file of integer N makes N-th call in the current task fail
(N is 0-based). Read from this file returns a single char 'Y' or 'N'
that says if the fault setup with a previous write to this file was
injected or not, and disables the fault if it wasn't yet injected.
Note that this file enables all types of faults (slab, futex, etc).
This setting takes precedence over all other generic settings like
probability, interval, times, etc. But per-capability settings
(e.g. fail_futex/ignore-private) take precedence over it.
This feature is intended for systematic testing of faults in a single
system call. See an example below.
===

Why adding new setting:
1. Existing settings are global rather than per-task.
   So parallel testing is not possible.
2. attr->interval is close but it depends on attr->count
   which is non reset to 0, so interval does not work as expected.
3. Trying to model this with existing settings requires manipulations
   of all of probability, interval, times, space, task-filter and
   unexposed count and per-task make-it-fail files.
4. Existing settings are per-failure-type, and the set of failure
   types is potentially expanding.
5. make-it-fail can't be changed by unprivileged user and aggressive
   stress testing better be done from an unprivileged user.
   Similarly, this would require opening the debugfs files to the
   unprivileged user, as he would need to reopen at least times file
   (not possible to pre-open before dropping privs).

The proposed interface solves all of the above (see the example).

We want to integrate this into syzkaller fuzzer.  A prototype has found 10
bugs in kernel in first day of usage:
https://groups.google.com/forum/#!searchin/syzkaller/%22FAULT_INJECTION%22%7Csort:relevance

Link: http://lkml.kernel.org/r/20170328130128.101773-1-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fault-injection/fault-injection.txt |   78 ++++++++++++
 fs/proc/base.c                                    |   52 ++++++++
 include/linux/sched.h                             |    1 
 kernel/fork.c                                     |    4 
 lib/fault-inject.c                                |    7 +
 5 files changed, 142 insertions(+)

diff -puN Documentation/fault-injection/fault-injection.txt~fault-inject-support-systematic-fault-injection Documentation/fault-injection/fault-injection.txt
--- a/Documentation/fault-injection/fault-injection.txt~fault-inject-support-systematic-fault-injection
+++ a/Documentation/fault-injection/fault-injection.txt
@@ -134,6 +134,22 @@ use the boot option:
 	fail_futex=
 	mmc_core.fail_request=<interval>,<probability>,<space>,<times>
 
+o proc entries
+
+- /proc/self/task/<current-tid>/fail-nth:
+
+	Write to this file of integer N makes N-th call in the current task fail
+	(N is 0-based). Read from this file returns a single char 'Y' or 'N'
+	that says if the fault setup with a previous write to this file was
+	injected or not, and disables the fault if it wasn't yet injected.
+	Note that this file enables all types of faults (slab, futex, etc).
+	This setting takes precedence over all other generic debugfs settings
+	like probability, interval, times, etc. But per-capability settings
+	(e.g. fail_futex/ignore-private) take precedence over it.
+
+	This feature is intended for systematic testing of faults in a single
+	system call. See an example below.
+
 How to add new fault injection capability
 -----------------------------------------
 
@@ -278,3 +294,65 @@ allocation failure.
 	# env FAILCMD_TYPE=fail_page_alloc \
 		./tools/testing/fault-injection/failcmd.sh --times=100 \
                 -- make -C tools/testing/selftests/ run_tests
+
+Systematic faults using fail-nth
+---------------------------------
+
+The following code systematically faults 0-th, 1-st, 2-nd and so on
+capabilities in the socketpair() system call.
+
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/socket.h>
+#include <sys/syscall.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <string.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <errno.h>
+
+int main()
+{
+	int i, err, res, fail_nth, fds[2];
+	char buf[128];
+
+	system("echo N > /sys/kernel/debug/failslab/ignore-gfp-wait");
+	sprintf(buf, "/proc/self/task/%ld/fail-nth", syscall(SYS_gettid));
+	fail_nth = open(buf, O_RDWR);
+	for (i = 0;; i++) {
+		sprintf(buf, "%d", i);
+		write(fail_nth, buf, strlen(buf));
+		res = socketpair(AF_LOCAL, SOCK_STREAM, 0, fds);
+		err = errno;
+		read(fail_nth, buf, 1);
+		if (res == 0) {
+			close(fds[0]);
+			close(fds[1]);
+		}
+		printf("%d-th fault %c: res=%d/%d\n", i, buf[0], res, err);
+		if (buf[0] != 'Y')
+			break;
+	}
+	return 0;
+}
+
+An example output:
+
+0-th fault Y: res=-1/23
+1-th fault Y: res=-1/23
+2-th fault Y: res=-1/23
+3-th fault Y: res=-1/12
+4-th fault Y: res=-1/12
+5-th fault Y: res=-1/23
+6-th fault Y: res=-1/23
+7-th fault Y: res=-1/23
+8-th fault Y: res=-1/12
+9-th fault Y: res=-1/12
+10-th fault Y: res=-1/12
+11-th fault Y: res=-1/12
+12-th fault Y: res=-1/12
+13-th fault Y: res=-1/12
+14-th fault Y: res=-1/12
+15-th fault Y: res=-1/12
+16-th fault N: res=0/12
diff -puN fs/proc/base.c~fault-inject-support-systematic-fault-injection fs/proc/base.c
--- a/fs/proc/base.c~fault-inject-support-systematic-fault-injection
+++ a/fs/proc/base.c
@@ -1358,6 +1358,53 @@ static const struct file_operations proc
 	.write		= proc_fault_inject_write,
 	.llseek		= generic_file_llseek,
 };
+
+static ssize_t proc_fail_nth_write(struct file *file, const char __user *buf,
+				   size_t count, loff_t *ppos)
+{
+	struct task_struct *task;
+	int err, n;
+
+	task = get_proc_task(file_inode(file));
+	if (!task)
+		return -ESRCH;
+	put_task_struct(task);
+	if (task != current)
+		return -EPERM;
+	err = kstrtoint_from_user(buf, count, 10, &n);
+	if (err)
+		return err;
+	if (n < 0 || n == INT_MAX)
+		return -EINVAL;
+	current->fail_nth = n + 1;
+	return len;
+}
+
+static ssize_t proc_fail_nth_read(struct file *file, char __user *buf,
+				  size_t count, loff_t *ppos)
+{
+	struct task_struct *task;
+	int err;
+
+	task = get_proc_task(file_inode(file));
+	if (!task)
+		return -ESRCH;
+	put_task_struct(task);
+	if (task != current)
+		return -EPERM;
+	if (count < 1)
+		return -EINVAL;
+	err = put_user((char)(current->fail_nth ? 'N' : 'Y'), buf);
+	if (err)
+		return err;
+	current->fail_nth = 0;
+	return 1;
+}
+
+static const struct file_operations proc_fail_nth_operations = {
+	.read		= proc_fail_nth_read,
+	.write		= proc_fail_nth_write,
+};
 #endif
 
 
@@ -3302,6 +3349,11 @@ static const struct pid_entry tid_base_s
 #endif
 #ifdef CONFIG_FAULT_INJECTION
 	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
+	/*
+	 * Operations on the file check that the task is current,
+	 * so we create it with 0666 to support testing under unprivileged user.
+	 */
+	REG("fail-nth", 0666, proc_fail_nth_operations),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 	ONE("io",	S_IRUSR, proc_tid_io_accounting),
diff -puN include/linux/sched.h~fault-inject-support-systematic-fault-injection include/linux/sched.h
--- a/include/linux/sched.h~fault-inject-support-systematic-fault-injection
+++ a/include/linux/sched.h
@@ -941,6 +941,7 @@ struct task_struct {
 
 #ifdef CONFIG_FAULT_INJECTION
 	int				make_it_fail;
+	int fail_nth;
 #endif
 	/*
 	 * When (nr_dirtied >= nr_dirtied_pause), it's time to call
diff -puN kernel/fork.c~fault-inject-support-systematic-fault-injection kernel/fork.c
--- a/kernel/fork.c~fault-inject-support-systematic-fault-injection
+++ a/kernel/fork.c
@@ -555,6 +555,10 @@ static struct task_struct *dup_task_stru
 
 	kcov_task_init(tsk);
 
+#ifdef CONFIG_FAULT_INJECTION
+	tsk->fail_nth = 0;
+#endif
+
 	return tsk;
 
 free_stack:
diff -puN lib/fault-inject.c~fault-inject-support-systematic-fault-injection lib/fault-inject.c
--- a/lib/fault-inject.c~fault-inject-support-systematic-fault-injection
+++ a/lib/fault-inject.c
@@ -107,6 +107,12 @@ static inline bool fail_stacktrace(struc
 
 bool should_fail(struct fault_attr *attr, ssize_t size)
 {
+	if (in_task() && current->fail_nth) {
+		if (--current->fail_nth == 0)
+			goto fail;
+		return false;
+	}
+
 	/* No need to check any other properties if the probability is 0 */
 	if (attr->probability == 0)
 		return false;
@@ -134,6 +140,7 @@ bool should_fail(struct fault_attr *attr
 	if (!fail_stacktrace(attr))
 		return false;
 
+fail:
 	fail_dump(attr);
 
 	if (atomic_read(&attr->times) != -1)
_

Patches currently in -mm which might be from dvyukov@google.com are

fault-inject-support-systematic-fault-injection.patch
kasan-allow-kasan_check_read-write-to-accept-pointers-to-volatiles.patch
asm-generic-x86-wrap-atomic-operations.patch
asm-generic-add-kasan-instrumentation-to-atomic-operations.patch
asm-generic-fix-compilation-failure-in-cmpxchg_double.patch

