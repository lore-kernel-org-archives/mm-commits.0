From: akpm@linux-foundation.org
Subject: + arm-use-clear_tasks_mm_cpumask.patch added to -mm tree
Date: Thu, 26 Apr 2012 17:05:54 -0700
Message-ID: <20120427000554.358CDA042D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:60768 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab2D0AFz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Apr 2012 20:05:55 -0400
Received: by qabg24 with SMTP id g24so7213qab.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Apr 2012 17:05:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton.vorontsov@linaro.org, oleg@redhat.com, rmk@arm.linux.org.uk


The patch titled
     Subject: arm: use clear_tasks_mm_cpumask()
has been added to the -mm tree.  Its filename is
     arm-use-clear_tasks_mm_cpumask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -130,7 +130,6 @@ static void percpu_timer_stop(void);
 int __cpu_disable(void)
 {
 	unsigned int cpu = smp_processor_id();
-	struct task_struct *p;
 	int ret;
 
 	ret = platform_cpu_disable(cpu);
@@ -160,12 +159,7 @@ int __cpu_disable(void)
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
Subject: Subject: arm: use clear_tasks_mm_cpumask()

Patches currently in -mm which might be from anton.vorontsov@linaro.org are

cpu-introduce-clear_tasks_mm_cpumask-helper.patch
arm-use-clear_tasks_mm_cpumask.patch
powerpc-use-clear_tasks_mm_cpumask.patch
sh-use-clear_tasks_mm_cpumask.patch
blackfin-a-couple-of-task-mm-handling-fixes.patch
blackfin-fix-possible-deadlock-in-decode_address.patch
um-should-hold-tasklist_lock-while-traversing-processes.patch
um-fix-possible-race-on-task-mm.patch
um-properly-check-all-process-threads-for-a-live-mm.patch

