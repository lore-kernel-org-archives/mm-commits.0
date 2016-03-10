From: akpm@linux-foundation.org
Subject: [merged]
 sched-kasan-remove-stale-kasan-poison-after-hotplug.patch removed from -mm
 tree
Date: Thu, 10 Mar 2016 10:58:04 -0800
Message-ID: <56e1c3bc.xrPUvszk3tjTkF21%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbcCJS6F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2016 13:58:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mark.rutland@arm.com, aryabinin@virtuozzo.com, catalin.marinas@arm.com, glider@google.com, lorenzo.pieralisi@arm.com, mingo@kernel.org, peterz@infradead.org, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sched/kasan: remove stale KASAN poison after hotplug
has been removed from the -mm tree.  Its filename was
     sched-kasan-remove-stale-kasan-poison-after-hotplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mark Rutland <mark.rutland@arm.com>
Subject: sched/kasan: remove stale KASAN poison after hotplug

Functions which the compiler has instrumented for KASAN place poison on
the stack shadow upon entry and remove this poision prior to returning.

In the case of CPU hotplug, CPUs exit the kernel a number of levels deep
in C code.  Any instrumented functions on this critical path will leave
portions of the stack shadow poisoned.

When a CPU is subsequently brought back into the kernel via a different
path, depending on stackframe, layout calls to instrumented functions may
hit this stale poison, resulting in (spurious) KASAN splats to the
console.

To avoid this, clear any stale poison from the idle thread for a CPU prior
to bringing a CPU online.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/core.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/sched/core.c~sched-kasan-remove-stale-kasan-poison-after-hotplug kernel/sched/core.c
--- a/kernel/sched/core.c~sched-kasan-remove-stale-kasan-poison-after-hotplug
+++ a/kernel/sched/core.c
@@ -26,6 +26,7 @@
  *              Thomas Gleixner, Mike Kravetz
  */
 
+#include <linux/kasan.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/nmi.h>
@@ -5096,6 +5097,8 @@ void init_idle(struct task_struct *idle,
 	idle->state = TASK_RUNNING;
 	idle->se.exec_start = sched_clock();
 
+	kasan_unpoison_task_stack(idle);
+
 #ifdef CONFIG_SMP
 	/*
 	 * Its possible that init_idle() gets called multiple times on a task,
_

Patches currently in -mm which might be from mark.rutland@arm.com are


