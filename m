From: akpm@linux-foundation.org
Subject: + fault-inject-simplify-access-check-for-fail-nth.patch added to
 -mm tree
Date: Thu, 06 Apr 2017 15:56:44 -0700
Message-ID: <58e6c7ac.vE9ko0BK8K5i5VLT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49210 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752117AbdDFW4p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2017 18:56:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, dvyukov@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fault-inject: simplify access check for fail-nth
has been added to the -mm tree.  Its filename is
     fault-inject-simplify-access-check-for-fail-nth.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fault-inject-simplify-access-check-for-fail-nth.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fault-inject-simplify-access-check-for-fail-nth.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: fault-inject: simplify access check for fail-nth

The fail-nth file is created with 0666 and the access is permitted if
and only if the task is current.

This file is owned by the currnet user.  So we can create it with 0644 and
allow the owner to write it.  This enables to watch the status of
task->fail_nth from another processes.

Link: http://lkml.kernel.org/r/1491490561-10485-5-git-send-email-akinobu.mita@gmail.com
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff -puN fs/proc/base.c~fault-inject-simplify-access-check-for-fail-nth fs/proc/base.c
--- a/fs/proc/base.c~fault-inject-simplify-access-check-for-fail-nth
+++ a/fs/proc/base.c
@@ -1366,16 +1366,16 @@ static ssize_t proc_fail_nth_write(struc
 	int err;
 	unsigned int n;
 
+	err = kstrtoint_from_user(buf, count, 0, &n);
+	if (err)
+		return err;
+
 	task = get_proc_task(file_inode(file));
 	if (!task)
 		return -ESRCH;
+	task->fail_nth = n;
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
 
@@ -1389,11 +1389,9 @@ static ssize_t proc_fail_nth_read(struct
 	task = get_proc_task(file_inode(file));
 	if (!task)
 		return -ESRCH;
-	put_task_struct(task);
-	if (task != current)
-		return -EPERM;
 	len = snprintf(numbuf, sizeof(numbuf), "%u\n", task->fail_nth);
 	len = simple_read_from_buffer(buf, count, ppos, numbuf, len);
+	put_task_struct(task);
 
 	return len;
 }
@@ -3346,11 +3344,7 @@ static const struct pid_entry tid_base_s
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
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

fault-inject-automatically-detect-the-number-base-for-fail-nth-write-interface.patch
fault-inject-parse-as-natural-1-based-value-for-fail-nth-write-interface.patch
fault-inject-make-fail-nth-read-write-interface-symmetric.patch
fault-inject-simplify-access-check-for-fail-nth.patch
fault-inject-add-proc-pid-fail-nth.patch

