From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Tue, 07 Nov 2017 11:33:06 -0800
Message-ID: <20171107193306.ms4kJHGSz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53508 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757462AbdKGTdI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Nov 2017 14:33:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/idle/intel_idle.c |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN drivers/idle/intel_idle.c~linux-next-git-rejects drivers/idle/intel_idle.c
--- a/drivers/idle/intel_idle.c~linux-next-git-rejects
+++ a/drivers/idle/intel_idle.c
@@ -913,14 +913,8 @@ static __cpuidle int intel_idle(struct c
 	struct cpuidle_state *state = &drv->states[index];
 	unsigned long eax = flg2MWAIT(state->flags);
 	unsigned int cstate;
-<<<<<<< HEAD
-	int cpu = smp_processor_id();
-
-	cstate = (((eax) >> MWAIT_SUBSTATE_SIZE) & MWAIT_CSTATE_MASK) + 1;
-=======
 	bool uninitialized_var(tick);
 	int cpu = smp_processor_id();
->>>>>>> linux-next/akpm-base
 
 	/*
 	 * leave_mm() to avoid costly and often unnecessary wakeups
@@ -929,10 +923,6 @@ static __cpuidle int intel_idle(struct c
 	if (state->flags & CPUIDLE_FLAG_TLB_FLUSHED)
 		leave_mm(cpu);
 
-<<<<<<< HEAD
-	if (!(lapic_timer_reliable_states & (1 << (cstate))))
-		tick_broadcast_enter();
-=======
 	if (!static_cpu_has(X86_FEATURE_ARAT)) {
 		cstate = (((eax) >> MWAIT_SUBSTATE_SIZE) &
 				MWAIT_CSTATE_MASK) + 1;
@@ -942,7 +932,6 @@ static __cpuidle int intel_idle(struct c
 			tick_broadcast_enter();
 		}
 	}
->>>>>>> linux-next/akpm-base
 
 	mwait_idle_with_hints(eax, ecx);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
slab-slub-slob-convert-slab_flags_t-to-32-bit-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-drop-migrate-type-checks-from-has_unmovable_pages-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
f2fs-simplify-page-iteration-loops-fix.patch
mm-consolidate-page-table-accounting-fix-fix.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch
mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch
support-resetting-warn_once-checkpatch-fixes.patch
support-resetting-warn_once-for-all-architectures-v2-fix.patch
support-resetting-warn_once-for-all-architectures-v2-fix-fix.patch
support-resetting-warn_once-for-all-architectures-v2-fix-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

