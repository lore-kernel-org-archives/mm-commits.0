From: akpm@linux-foundation.org
Subject: [merged] kernel-rename-random32-to-prandom_u32.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:02:33 -0700
Message-ID: <20130430190233.6F17631C07C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:37704 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933507Ab3D3TCe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:02:34 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so87587qea.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:02:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/: rename random32() to prandom_u32()
has been removed from the -mm tree.  Its filename was
     kernel-rename-random32-to-prandom_u32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: kernel/: rename random32() to prandom_u32()

Use preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcutree.c      |    2 +-
 kernel/test_kprobes.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/rcutree.c~kernel-rename-random32-to-prandom_u32 kernel/rcutree.c
--- a/kernel/rcutree.c~kernel-rename-random32-to-prandom_u32
+++ a/kernel/rcutree.c
@@ -1319,7 +1319,7 @@ static int rcu_gp_init(struct rcu_state
 					    rnp->grphi, rnp->qsmask);
 		raw_spin_unlock_irq(&rnp->lock);
 #ifdef CONFIG_PROVE_RCU_DELAY
-		if ((random32() % (rcu_num_nodes * 8)) == 0)
+		if ((prandom_u32() % (rcu_num_nodes * 8)) == 0)
 			schedule_timeout_uninterruptible(2);
 #endif /* #ifdef CONFIG_PROVE_RCU_DELAY */
 		cond_resched();
diff -puN kernel/test_kprobes.c~kernel-rename-random32-to-prandom_u32 kernel/test_kprobes.c
--- a/kernel/test_kprobes.c~kernel-rename-random32-to-prandom_u32
+++ a/kernel/test_kprobes.c
@@ -365,7 +365,7 @@ int init_test_probes(void)
 	target2 = kprobe_target2;
 
 	do {
-		rand1 = random32();
+		rand1 = prandom_u32();
 	} while (rand1 <= div_factor);
 
 	printk(KERN_INFO "Kprobe smoke test started\n");
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
drivers-net-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix-fix.patch
remove-unused-random32-and-srandom32.patch
notifier-error-inject-fix-module-names-in-kconfig.patch

