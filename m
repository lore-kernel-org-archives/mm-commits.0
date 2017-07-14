From: akpm@linux-foundation.org
Subject: [folded-merged]
 fault-inject-simplify-access-check-for-fail-nth-fix-2.patch removed from
 -mm tree
Date: Fri, 14 Jul 2017 14:40:55 -0700
Message-ID: <59693a67.r90HvA0IJnvsbVuX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54610 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751012AbdGNVk4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2017 17:40:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, dvyukov@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fault-inject: avoid unwanted data race to task->fail_nth
has been removed from the -mm tree.  Its filename was
     fault-inject-simplify-access-check-for-fail-nth-fix-2.patch

This patch was dropped because it was folded into fault-inject-simplify-access-check-for-fail-nth.patch

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: fault-inject: avoid unwanted data race to task->fail_nth

The fault-inject-make-fail-nth-read-write-interface-symmetric.patch in
-mm tree allows users to set task->fail_nth for non current task by procfs.
On the other hand, the current task's fail_nth is decreased to zero in
fault-injection path without any specific locks.

So we need to prevent the task->fail_nth from being unexpected value by
data races (for example, setting task->fail_nth to zero while decreasing
the current->fail_nth).  In this fix, we use READ_ONCE() and WRITE_ONCE()
to prevent the compiler from creating unsolicited accesses.

Link: http://lkml.kernel.org/r/1499962492-8931-1-git-send-email-akinobu.mita@gmail.com
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c     |    5 +++--
 lib/fault-inject.c |    7 +++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN fs/proc/base.c~fault-inject-simplify-access-check-for-fail-nth-fix-2 fs/proc/base.c
--- a/fs/proc/base.c~fault-inject-simplify-access-check-for-fail-nth-fix-2
+++ a/fs/proc/base.c
@@ -1370,7 +1370,7 @@ static ssize_t proc_fail_nth_write(struc
 	task = get_proc_task(file_inode(file));
 	if (!task)
 		return -ESRCH;
-	task->fail_nth = n;
+	WRITE_ONCE(task->fail_nth, n);
 	put_task_struct(task);
 
 	return count;
@@ -1386,7 +1386,8 @@ static ssize_t proc_fail_nth_read(struct
 	task = get_proc_task(file_inode(file));
 	if (!task)
 		return -ESRCH;
-	len = snprintf(numbuf, sizeof(numbuf), "%u\n", task->fail_nth);
+	len = snprintf(numbuf, sizeof(numbuf), "%u\n",
+			READ_ONCE(task->fail_nth));
 	len = simple_read_from_buffer(buf, count, ppos, numbuf, len);
 	put_task_struct(task);
 
diff -puN lib/fault-inject.c~fault-inject-simplify-access-check-for-fail-nth-fix-2 lib/fault-inject.c
--- a/lib/fault-inject.c~fault-inject-simplify-access-check-for-fail-nth-fix-2
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

Patches currently in -mm which might be from akinobu.mita@gmail.com are

fault-inject-automatically-detect-the-number-base-for-fail-nth-write-interface.patch
fault-inject-parse-as-natural-1-based-value-for-fail-nth-write-interface.patch
fault-inject-make-fail-nth-read-write-interface-symmetric.patch
fault-inject-simplify-access-check-for-fail-nth.patch
fault-inject-add-proc-pid-fail-nth.patch

