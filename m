From: akpm@linux-foundation.org
Subject: [patch 08/13] fault-inject: simplify access check for fail-nth
Date: Fri, 14 Jul 2017 14:49:57 -0700
Message-ID: <59693c85.nvCDoKFfMpnVHhhT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55776 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751178AbdGNVt6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2017 17:49:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, akinobu.mita@gmail.com, dvyukov@google.com

From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: fault-inject: simplify access check for fail-nth

The fail-nth file is created with 0666 and the access is permitted if
and only if the task is current.

This file is owned by the currnet user.  So we can create it with 0644 and
allow the owner to write it.  This enables to watch the status of
task->fail_nth from another processes.

[akinobu.mita@gmail.com: don't convert unsigned type value as signed int]
  Link: http://lkml.kernel.org/r/1492444483-9239-1-git-send-email-akinobu.mita@gmail.com
[akinobu.mita@gmail.com: avoid unwanted data race to task->fail_nth]
  Link: http://lkml.kernel.org/r/1499962492-8931-1-git-send-email-akinobu.mita@gmail.com
Link: http://lkml.kernel.org/r/1491490561-10485-5-git-send-email-akinobu.mita@gmail.com
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c     |   25 ++++++++++---------------
 lib/fault-inject.c |    7 +++++--
 2 files changed, 15 insertions(+), 17 deletions(-)

diff -puN fs/proc/base.c~fault-inject-simplify-access-check-for-fail-nth fs/proc/base.c
--- a/fs/proc/base.c~fault-inject-simplify-access-check-for-fail-nth
+++ a/fs/proc/base.c
@@ -1363,16 +1363,16 @@ static ssize_t proc_fail_nth_write(struc
 	int err;
 	unsigned int n;
 
+	err = kstrtouint_from_user(buf, count, 0, &n);
+	if (err)
+		return err;
+
 	task = get_proc_task(file_inode(file));
 	if (!task)
 		return -ESRCH;
+	WRITE_ONCE(task->fail_nth, n);
 	put_task_struct(task);
-	if (task != current)
-		return -EPERM;
-	err = kstrtouint_from_user(buf, count, 0, &n);
-	if (err)
-		return err;
-	current->fail_nth = n;
+
 	return count;
 }
 
@@ -1386,11 +1386,10 @@ static ssize_t proc_fail_nth_read(struct
 	task = get_proc_task(file_inode(file));
 	if (!task)
 		return -ESRCH;
-	put_task_struct(task);
-	if (task != current)
-		return -EPERM;
-	len = snprintf(numbuf, sizeof(numbuf), "%u\n", task->fail_nth);
+	len = snprintf(numbuf, sizeof(numbuf), "%u\n",
+			READ_ONCE(task->fail_nth));
 	len = simple_read_from_buffer(buf, count, ppos, numbuf, len);
+	put_task_struct(task);
 
 	return len;
 }
@@ -3355,11 +3354,7 @@ static const struct pid_entry tid_base_s
 #endif
 #ifdef CONFIG_FAULT_INJECTION
 	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
-	/*
-	 * Operations on the file check that the task is current,
-	 * so we create it with 0666 to support testing under unprivileged user.
-	 */
-	REG("fail-nth", 0666, proc_fail_nth_operations),
+	REG("fail-nth", 0644, proc_fail_nth_operations),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 	ONE("io",	S_IRUSR, proc_tid_io_accounting),
diff -puN lib/fault-inject.c~fault-inject-simplify-access-check-for-fail-nth lib/fault-inject.c
--- a/lib/fault-inject.c~fault-inject-simplify-access-check-for-fail-nth
+++ a/lib/fault-inject.c
@@ -107,9 +107,12 @@ static inline bool fail_stacktrace(struc
 
 bool should_fail(struct fault_attr *attr, ssize_t size)
 {
-	if (in_task() && current->fail_nth) {
-		if (--current->fail_nth == 0)
+	if (in_task()) {
+		unsigned int fail_nth = READ_ONCE(current->fail_nth);
+
+		if (fail_nth && !WRITE_ONCE(current->fail_nth, fail_nth - 1))
 			goto fail;
+
 		return false;
 	}
 
_
