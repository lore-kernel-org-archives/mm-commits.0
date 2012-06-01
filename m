From: akpm@linux-foundation.org
Subject: [merged] powerpc-use-clear_tasks_mm_cpumask.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:34:15 -0700
Message-ID: <20120601193415.60433A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:62969 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759165Ab2FATeQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:34:16 -0400
Received: by qabg24 with SMTP id g24so93284qab.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:34:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton.vorontsov@linaro.org, benh@kernel.crashing.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: use clear_tasks_mm_cpumask()
has been removed from the -mm tree.  Its filename was
     powerpc-use-clear_tasks_mm_cpumask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: powerpc: use clear_tasks_mm_cpumask()

Current CPU hotplug code has some task->mm handling issues:

1. Working with task->mm w/o getting mm or grabing the task lock is
   dangerous as ->mm might disappear (exit_mm() assigns NULL under
   task_lock(), so tasklist lock is not enough).

   We can't use get_task_mm()/mmput() pair as mmput() might sleep,
   so we must take the task lock while handle its mm.

2. Checking for process->mm is not enough because process' main
   thread may exit or detach its mm via use_mm(), but other threads
   may still have a valid mm.

   To fix this we would need to use find_lock_task_mm(), which would
   walk up all threads and returns an appropriate task (with task
   lock held).

clear_tasks_mm_cpumask() has all the issues fixed, so let's use it.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mmu_context_nohash.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff -puN arch/powerpc/mm/mmu_context_nohash.c~powerpc-use-clear_tasks_mm_cpumask arch/powerpc/mm/mmu_context_nohash.c
--- a/arch/powerpc/mm/mmu_context_nohash.c~powerpc-use-clear_tasks_mm_cpumask
+++ a/arch/powerpc/mm/mmu_context_nohash.c
@@ -333,9 +333,7 @@ static int __cpuinit mmu_context_cpu_not
 					    unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned int)(long)hcpu;
-#ifdef CONFIG_HOTPLUG_CPU
-	struct task_struct *p;
-#endif
+
 	/* We don't touch CPU 0 map, it's allocated at aboot and kept
 	 * around forever
 	 */
@@ -358,12 +356,7 @@ static int __cpuinit mmu_context_cpu_not
 		stale_map[cpu] = NULL;
 
 		/* We also clear the cpu_vm_mask bits of CPUs going away */
-		read_lock(&tasklist_lock);
-		for_each_process(p) {
-			if (p->mm)
-				cpumask_clear_cpu(cpu, mm_cpumask(p->mm));
-		}
-		read_unlock(&tasklist_lock);
+		clear_tasks_mm_cpumask(cpu);
 	break;
 #endif /* CONFIG_HOTPLUG_CPU */
 	}
_

Patches currently in -mm which might be from anton.vorontsov@linaro.org are

origin.patch
sh-use-clear_tasks_mm_cpumask.patch
blackfin-a-couple-of-task-mm-handling-fixes.patch
blackfin-fix-possible-deadlock-in-decode_address.patch
um-should-hold-tasklist_lock-while-traversing-processes.patch
um-fix-possible-race-on-task-mm.patch
um-properly-check-all-process-threads-for-a-live-mm.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch

