From: akpm@linux-foundation.org
Subject: + fs-proc-truncate-proc-pid-comm-writes-to-first-task_comm_len-bytes.patch added to -mm tree
Date: Tue, 09 Apr 2013 13:03:10 -0700
Message-ID: <20130409200310.8A9235A425C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:53306 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761961Ab3DIUDM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Apr 2013 16:03:12 -0400
Received: by mail-ob0-f201.google.com with SMTP id uz6so1855891obc.2
        for <mm-commits@vger.kernel.org>; Tue, 09 Apr 2013 13:03:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, john.stultz@linaro.org


The patch titled
     Subject: fs, proc: truncate /proc/pid/comm writes to first TASK_COMM_LEN bytes
has been added to the -mm tree.  Its filename is
     fs-proc-truncate-proc-pid-comm-writes-to-first-task_comm_len-bytes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/proc/base.c~fs-proc-truncate-proc-pid-comm-writes-to-first-task_comm_len-bytes fs/proc/base.c
--- a/fs/proc/base.c~fs-proc-truncate-proc-pid-comm-writes-to-first-task_comm_len-bytes
+++ a/fs/proc/base.c
@@ -1347,11 +1347,10 @@ static ssize_t comm_write(struct file *f
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

linux-next.patch
mm-show_mem-suppress-page-counts-in-non-blockable-contexts.patch
mm-hugetlb-include-hugepages-in-meminfo.patch
mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes.patch
mm-speedup-in-__early_pfn_to_nid.patch
mm-speedup-in-__early_pfn_to_nid-fix.patch
thp-fix-comment-about-memory-barrier.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch
fs-proc-truncate-proc-pid-comm-writes-to-first-task_comm_len-bytes.patch

