From: akpm@linux-foundation.org
Subject: +
 kernel-hung_taskc-change-sysctl_hung_task_check_count-to-int.patch added to -mm tree
Date: Mon, 23 Sep 2013 15:46:16 -0700
Message-ID: <5240c4b8.WWOvV5pxBJSdloCm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56441 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab3IWWqR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Sep 2013 18:46:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mingo@kernel.org, lizefan@huawei.com

Subject: + kernel-hung_taskc-change-sysctl_hung_task_check_count-to-int.patch added to -mm tree
To: lizefan@huawei.com,mingo@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 23 Sep 2013 15:46:16 -0700


The patch titled
     Subject: kernel/hung_task.c: change sysctl_hung_task_check_count to int
has been added to the -mm tree.  Its filename is
     kernel-hung_taskc-change-sysctl_hung_task_check_count-to-int.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-hung_taskc-change-sysctl_hung_task_check_count-to-int.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-hung_taskc-change-sysctl_hung_task_check_count-to-int.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: kernel/hung_task.c: change sysctl_hung_task_check_count to int

As sysctl_hung_task_check_count is unsigned long, when this value is
assigned to max_count in check_hung_uninterruptible_tasks(), it's
truncated to int type.

Therefore if we write 2^32 to sysctl.hung_task_check_count, hung task
detection will be effectively disabled.

Not a big deal, but still it's better to fix this inconsistency.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/sysctl.h |    2 +-
 kernel/hung_task.c           |    2 +-
 kernel/sysctl.c              |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/sched/sysctl.h~kernel-hung_taskc-change-sysctl_hung_task_check_count-to-int include/linux/sched/sysctl.h
--- a/include/linux/sched/sysctl.h~kernel-hung_taskc-change-sysctl_hung_task_check_count-to-int
+++ a/include/linux/sched/sysctl.h
@@ -2,8 +2,8 @@
 #define _SCHED_SYSCTL_H
 
 #ifdef CONFIG_DETECT_HUNG_TASK
+extern int	     sysctl_hung_task_check_count;
 extern unsigned int  sysctl_hung_task_panic;
-extern unsigned long sysctl_hung_task_check_count;
 extern unsigned long sysctl_hung_task_timeout_secs;
 extern unsigned long sysctl_hung_task_warnings;
 extern int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
diff -puN kernel/hung_task.c~kernel-hung_taskc-change-sysctl_hung_task_check_count-to-int kernel/hung_task.c
--- a/kernel/hung_task.c~kernel-hung_taskc-change-sysctl_hung_task_check_count-to-int
+++ a/kernel/hung_task.c
@@ -20,7 +20,7 @@
 /*
  * The number of tasks checked:
  */
-unsigned long __read_mostly sysctl_hung_task_check_count = PID_MAX_LIMIT;
+int __read_mostly sysctl_hung_task_check_count = PID_MAX_LIMIT;
 
 /*
  * Limit number of tasks checked in a batch.
diff -puN kernel/sysctl.c~kernel-hung_taskc-change-sysctl_hung_task_check_count-to-int kernel/sysctl.c
--- a/kernel/sysctl.c~kernel-hung_taskc-change-sysctl_hung_task_check_count-to-int
+++ a/kernel/sysctl.c
@@ -962,9 +962,9 @@ static struct ctl_table kern_table[] = {
 	{
 		.procname	= "hung_task_check_count",
 		.data		= &sysctl_hung_task_check_count,
-		.maxlen		= sizeof(unsigned long),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 	},
 	{
 		.procname	= "hung_task_timeout_secs",
_

Patches currently in -mm which might be from lizefan@huawei.com are

kernel-hung_taskc-change-sysctl_hung_task_check_count-to-int.patch
linux-next.patch

