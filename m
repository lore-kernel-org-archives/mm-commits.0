From: akpm@linux-foundation.org
Subject: [merged] sh-use-clear_tasks_mm_cpumask.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:34:17 -0700
Message-ID: <20120601193417.631B1A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:42114 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759170Ab2FATeT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:34:19 -0400
Received: by were53 with SMTP id e53so140327wer.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:34:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton.vorontsov@linaro.org, lethal@linux-sh.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: use clear_tasks_mm_cpumask()
has been removed from the -mm tree.  Its filename was
     sh-use-clear_tasks_mm_cpumask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: sh: use clear_tasks_mm_cpumask()

Checking for process->mm is not enough because process' main thread may
exit or detach its mm via use_mm(), but other threads may still have a
valid mm.

To fix this we would need to use find_lock_task_mm(), which would walk up
all threads and returns an appropriate task (with task lock held).

clear_tasks_mm_cpumask() has the issue fixed, so let's use it.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/smp.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN arch/sh/kernel/smp.c~sh-use-clear_tasks_mm_cpumask arch/sh/kernel/smp.c
--- a/arch/sh/kernel/smp.c~sh-use-clear_tasks_mm_cpumask
+++ a/arch/sh/kernel/smp.c
@@ -123,7 +123,6 @@ void native_play_dead(void)
 int __cpu_disable(void)
 {
 	unsigned int cpu = smp_processor_id();
-	struct task_struct *p;
 	int ret;
 
 	ret = mp_ops->cpu_disable(cpu);
@@ -153,11 +152,7 @@ int __cpu_disable(void)
 	flush_cache_all();
 	local_flush_tlb_all();
 
-	read_lock(&tasklist_lock);
-	for_each_process(p)
-		if (p->mm)
-			cpumask_clear_cpu(cpu, mm_cpumask(p->mm));
-	read_unlock(&tasklist_lock);
+	clear_tasks_mm_cpumask(cpu);
 
 	return 0;
 }
_

Patches currently in -mm which might be from anton.vorontsov@linaro.org are

origin.patch
blackfin-a-couple-of-task-mm-handling-fixes.patch
blackfin-fix-possible-deadlock-in-decode_address.patch
um-should-hold-tasklist_lock-while-traversing-processes.patch
um-fix-possible-race-on-task-mm.patch
um-properly-check-all-process-threads-for-a-live-mm.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch

