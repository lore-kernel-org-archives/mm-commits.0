From: akpm@linux-foundation.org
Subject: [patch 06/13] fault-inject: parse as natural 1-based value for
 fail-nth write interface
Date: Fri, 14 Jul 2017 14:49:52 -0700
Message-ID: <59693c80.Bh8+VDwjhjgt9zZG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55760 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751118AbdGNVtx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2017 17:49:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, akinobu.mita@gmail.com, dvyukov@google.com

From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: fault-inject: parse as natural 1-based value for fail-nth write interface

The value written to fail-nth file is parsed as 0-based.  Parsing as
one-based is more natural to understand and it enables to cancel the
previous setup by simply writing '0'.

This change also converts task->fail_nth from signed to unsigned int.

Link: http://lkml.kernel.org/r/1491490561-10485-3-git-send-email-akinobu.mita@gmail.com
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fault-injection/fault-injection.txt |    7 +++----
 fs/proc/base.c                                    |    9 ++++-----
 include/linux/sched.h                             |    2 +-
 3 files changed, 8 insertions(+), 10 deletions(-)

diff -puN Documentation/fault-injection/fault-injection.txt~fault-inject-parse-as-natural-1-based-value-for-fail-nth-write-interface Documentation/fault-injection/fault-injection.txt
--- a/Documentation/fault-injection/fault-injection.txt~fault-inject-parse-as-natural-1-based-value-for-fail-nth-write-interface
+++ a/Documentation/fault-injection/fault-injection.txt
@@ -138,8 +138,8 @@ o proc entries
 
 - /proc/self/task/<current-tid>/fail-nth:
 
-	Write to this file of integer N makes N-th call in the current task fail
-	(N is 0-based). Read from this file returns a single char 'Y' or 'N'
+	Write to this file of integer N makes N-th call in the task fail.
+	Read from this file returns a single char 'Y' or 'N'
 	that says if the fault setup with a previous write to this file was
 	injected or not, and disables the fault if it wasn't yet injected.
 	Note that this file enables all types of faults (slab, futex, etc).
@@ -320,7 +320,7 @@ int main()
 	system("echo N > /sys/kernel/debug/failslab/ignore-gfp-wait");
 	sprintf(buf, "/proc/self/task/%ld/fail-nth", syscall(SYS_gettid));
 	fail_nth = open(buf, O_RDWR);
-	for (i = 0;; i++) {
+	for (i = 1;; i++) {
 		sprintf(buf, "%d", i);
 		write(fail_nth, buf, strlen(buf));
 		res = socketpair(AF_LOCAL, SOCK_STREAM, 0, fds);
@@ -339,7 +339,6 @@ int main()
 
 An example output:
 
-0-th fault Y: res=-1/23
 1-th fault Y: res=-1/23
 2-th fault Y: res=-1/23
 3-th fault Y: res=-1/12
diff -puN fs/proc/base.c~fault-inject-parse-as-natural-1-based-value-for-fail-nth-write-interface fs/proc/base.c
--- a/fs/proc/base.c~fault-inject-parse-as-natural-1-based-value-for-fail-nth-write-interface
+++ a/fs/proc/base.c
@@ -1360,7 +1360,8 @@ static ssize_t proc_fail_nth_write(struc
 				   size_t count, loff_t *ppos)
 {
 	struct task_struct *task;
-	int err, n;
+	int err;
+	unsigned int n;
 
 	task = get_proc_task(file_inode(file));
 	if (!task)
@@ -1368,12 +1369,10 @@ static ssize_t proc_fail_nth_write(struc
 	put_task_struct(task);
 	if (task != current)
 		return -EPERM;
-	err = kstrtoint_from_user(buf, count, 0, &n);
+	err = kstrtouint_from_user(buf, count, 0, &n);
 	if (err)
 		return err;
-	if (n < 0 || n == INT_MAX)
-		return -EINVAL;
-	current->fail_nth = n + 1;
+	current->fail_nth = n;
 	return count;
 }
 
diff -puN include/linux/sched.h~fault-inject-parse-as-natural-1-based-value-for-fail-nth-write-interface include/linux/sched.h
--- a/include/linux/sched.h~fault-inject-parse-as-natural-1-based-value-for-fail-nth-write-interface
+++ a/include/linux/sched.h
@@ -974,7 +974,7 @@ struct task_struct {
 
 #ifdef CONFIG_FAULT_INJECTION
 	int				make_it_fail;
-	int fail_nth;
+	unsigned int			fail_nth;
 #endif
 	/*
 	 * When (nr_dirtied >= nr_dirtied_pause), it's time to call
_
