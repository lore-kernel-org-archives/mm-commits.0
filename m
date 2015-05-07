From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 07 May 2015 11:31:57 -0700
Message-ID: <554baf9d.NiyBOY8HVtz7Ckc5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbbEGSb6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2015 14:31:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcu/tree.c |   14 --------------
 1 file changed, 14 deletions(-)

diff -puN kernel/rcu/tree.c~linux-next-git-rejects kernel/rcu/tree.c
--- a/kernel/rcu/tree.c~linux-next-git-rejects
+++ a/kernel/rcu/tree.c
@@ -169,8 +169,6 @@ static int kthread_prio = IS_ENABLED(CON
 module_param(kthread_prio, int, 0644);
 
 /* Delay in jiffies for grace-period initialization delays, debug only. */
-<<<<<<< HEAD
-=======
 
 #ifdef CONFIG_RCU_TORTURE_TEST_SLOW_PREINIT
 static int gp_preinit_delay = CONFIG_RCU_TORTURE_TEST_SLOW_PREINIT_DELAY;
@@ -179,16 +177,12 @@ module_param(gp_preinit_delay, int, 0644
 static const int gp_preinit_delay;
 #endif /* #else #ifdef CONFIG_RCU_TORTURE_TEST_SLOW_PREINIT */
 
->>>>>>> linux-next/akpm-base
 #ifdef CONFIG_RCU_TORTURE_TEST_SLOW_INIT
 static int gp_init_delay = CONFIG_RCU_TORTURE_TEST_SLOW_INIT_DELAY;
 module_param(gp_init_delay, int, 0644);
 #else /* #ifdef CONFIG_RCU_TORTURE_TEST_SLOW_INIT */
 static const int gp_init_delay;
 #endif /* #else #ifdef CONFIG_RCU_TORTURE_TEST_SLOW_INIT */
-<<<<<<< HEAD
-#define PER_RCU_NODE_PERIOD 10	/* Number of grace periods between delays. */
-=======
 
 #ifdef CONFIG_RCU_TORTURE_TEST_SLOW_CLEANUP
 static int gp_cleanup_delay = CONFIG_RCU_TORTURE_TEST_SLOW_CLEANUP_DELAY;
@@ -207,7 +201,6 @@ static const int gp_cleanup_delay;
  * need for fast grace periods to increase other race probabilities.
  */
 #define PER_RCU_NODE_PERIOD 3	/* Number of grace periods between delays. */
->>>>>>> linux-next/akpm-base
 
 /*
  * Track the rcutorture test sequence number and the update version
@@ -1894,14 +1887,7 @@ static int rcu_gp_init(struct rcu_state
 					    rnp->grphi, rnp->qsmask);
 		raw_spin_unlock_irq(&rnp->lock);
 		cond_resched_rcu_qs();
-<<<<<<< HEAD
-		ACCESS_ONCE(rsp->gp_activity) = jiffies;
-		if (gp_init_delay > 0 &&
-		    !(rsp->gpnum % (rcu_num_nodes * PER_RCU_NODE_PERIOD)))
-			schedule_timeout_uninterruptible(gp_init_delay);
-=======
 		WRITE_ONCE(rsp->gp_activity, jiffies);
->>>>>>> linux-next/akpm-base
 	}
 
 	return 1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-rtc-rtc-armada38xc-remove-unused-local-flags.patch
gfp-add-__gfp_noaccount-v2-fix.patch
cma-page_isolation-check-buddy-before-access-it-fix.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
linux-next.patch
linux-next-rejects.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

