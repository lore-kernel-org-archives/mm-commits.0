From: akpm@linux-foundation.org
Subject: - powerpc-fix-debug_preempt-warning-when-warning.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:17:25 -0500
Message-ID: <200802150720.m1F7Kl3X025854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53571 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763276AbYBOH31 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:29:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: fix DEBUG_PREEMPT warning when warning
has been removed from the -mm tree.  Its filename was
     powerpc-fix-debug_preempt-warning-when-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: fix DEBUG_PREEMPT warning when warning
From: Hugh Dickins <hugh@veritas.com>

The powerpc show_regs prints CPU using smp_processor_id: change that to
raw_smp_processor_id, so that when it's showing a WARN_ON backtrace without
preemption disabled, DEBUG_PREEMPT doesn't mess up that warning with its
own.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/kernel/process.c~powerpc-fix-debug_preempt-warning-when-warning arch/powerpc/kernel/process.c
--- a/arch/powerpc/kernel/process.c~powerpc-fix-debug_preempt-warning-when-warning
+++ a/arch/powerpc/kernel/process.c
@@ -462,7 +462,7 @@ void show_regs(struct pt_regs * regs)
 	       current, task_pid_nr(current), current->comm, task_thread_info(current));
 
 #ifdef CONFIG_SMP
-	printk(" CPU: %d", smp_processor_id());
+	printk(" CPU: %d", raw_smp_processor_id());
 #endif /* CONFIG_SMP */
 
 	for (i = 0;  i < 32;  i++) {
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
git-unionfs.patch
percpu-fix-debug_preempt-per_cpu-checking.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
prio_tree-debugging-patch.patch
