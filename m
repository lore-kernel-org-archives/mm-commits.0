From: akpm@linux-foundation.org
Subject: [merged] arm-use-clear_tasks_mm_cpumask.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:34:13 -0700
Message-ID: <20120601193413.60EF8A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:44792 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759112Ab2FATeO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:34:14 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so245076ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:34:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton.vorontsov@linaro.org, oleg@redhat.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: use clear_tasks_mm_cpumask()
has been removed from the -mm tree.  Its filename was
     arm-use-clear_tasks_mm_cpumask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: arm: use clear_tasks_mm_cpumask()

Checking for process->mm is not enough because process' main thread may
exit or detach its mm via use_mm(), but other threads may still have a
valid mm.

To fix this we would need to use find_lock_task_mm(), which would walk up
all threads and returns an appropriate task (with task lock held).

clear_tasks_mm_cpumask() has this issue fixed, so let's use it.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/smp.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN arch/arm/kernel/smp.c~arm-use-clear_tasks_mm_cpumask arch/arm/kernel/smp.c
--- a/arch/arm/kernel/smp.c~arm-use-clear_tasks_mm_cpumask
+++ a/arch/arm/kernel/smp.c
@@ -109,7 +109,6 @@ static void percpu_timer_stop(void);
 int __cpu_disable(void)
 {
 	unsigned int cpu = smp_processor_id();
-	struct task_struct *p;
 	int ret;
 
 	ret = platform_cpu_disable(cpu);
@@ -139,12 +138,7 @@ int __cpu_disable(void)
 	flush_cache_all();
 	local_flush_tlb_all();
 
-	read_lock(&tasklist_lock);
-	for_each_process(p) {
-		if (p->mm)
-			cpumask_clear_cpu(cpu, mm_cpumask(p->mm));
-	}
-	read_unlock(&tasklist_lock);
+	clear_tasks_mm_cpumask(cpu);
 
 	return 0;
 }
_

Patches currently in -mm which might be from anton.vorontsov@linaro.org are

origin.patch
powerpc-use-clear_tasks_mm_cpumask.patch
sh-use-clear_tasks_mm_cpumask.patch
blackfin-a-couple-of-task-mm-handling-fixes.patch
blackfin-fix-possible-deadlock-in-decode_address.patch
um-should-hold-tasklist_lock-while-traversing-processes.patch
um-fix-possible-race-on-task-mm.patch
um-properly-check-all-process-threads-for-a-live-mm.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch

