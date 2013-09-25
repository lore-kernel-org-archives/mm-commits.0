From: akpm@linux-foundation.org
Subject: [merged]
 kernel-hung_taskc-change-sysctl_hung_task_check_count-to-int.patch removed
 from -mm tree
Date: Wed, 25 Sep 2013 12:06:24 -0700
Message-ID: <52433430.0dZA96QQbit2+17m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab3IYTGY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 15:06:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mingo@kernel.org, lizefan@huawei.com

Subject: [merged] kernel-hung_taskc-change-sysctl_hung_task_check_count-to-int.patch removed from -mm tree
To: lizefan@huawei.com,mingo@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 12:06:24 -0700


The patch titled
     Subject: kernel/hung_task.c: change sysctl_hung_task_check_count to int
has been removed from the -mm tree.  Its filename was
     kernel-hung_taskc-change-sysctl_hung_task_check_count-to-int.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

