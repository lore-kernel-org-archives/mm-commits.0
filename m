From: akpm@linux-foundation.org
Subject: [merged] fs-proc-truncate-proc-pid-comm-writes-to-first-task_comm_len-bytes.patch removed from -mm tree
Date: Tue, 07 May 2013 10:49:41 -0700
Message-ID: <20130507174941.804EA5A4343@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:44958 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406Ab3EGRtm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:49:42 -0400
Received: by mail-qe0-f74.google.com with SMTP id 1so85375qec.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:49:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, john.stultz@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, proc: truncate /proc/pid/comm writes to first TASK_COMM_LEN bytes
has been removed from the -mm tree.  Its filename was
     fs-proc-truncate-proc-pid-comm-writes-to-first-task_comm_len-bytes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: fs, proc: truncate /proc/pid/comm writes to first TASK_COMM_LEN bytes

Currently, a write to a procfs file will return the number of bytes
successfully written.  If the actual string is longer than this, the
remainder of the string will not be be written and userspace will complete
the operation by issuing additional write()s.

Hence

	$ echo -n "abcdefghijklmnopqrs" > /proc/self/comm

results in

	$ cat /proc/$$/comm
	pqrs

since the final four bytes were written with a second write() since
TASK_COMM_LEN == 16.  This is obviously an undesired result and not
equivalent to prctl(PR_SET_NAME).  The implementation should not need to
know the definition of TASK_COMM_LEN.

This patch truncates the string to the first TASK_COMM_LEN bytes and
returns the bytes written as the length of the string written so the
second write() is suppressed.

	$ cat /proc/$$/comm
	abcdefghijklmno

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/proc/base.c~fs-proc-truncate-proc-pid-comm-writes-to-first-task_comm_len-bytes fs/proc/base.c
--- a/fs/proc/base.c~fs-proc-truncate-proc-pid-comm-writes-to-first-task_comm_len-bytes
+++ a/fs/proc/base.c
@@ -1348,11 +1348,10 @@ static ssize_t comm_write(struct file *f
 	struct inode *inode = file_inode(file);
 	struct task_struct *p;
 	char buffer[TASK_COMM_LEN];
+	const size_t maxlen = sizeof(buffer) - 1;
 
 	memset(buffer, 0, sizeof(buffer));
-	if (count > sizeof(buffer) - 1)
-		count = sizeof(buffer) - 1;
-	if (copy_from_user(buffer, buf, count))
+	if (copy_from_user(buffer, buf, count > maxlen ? maxlen : count))
 		return -EFAULT;
 
 	p = get_proc_task(inode);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
mm-memcg-add-rss_huge-stat-to-memorystat.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

