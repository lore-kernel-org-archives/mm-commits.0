From: akpm@linux-foundation.org
Subject: + kernel-rename-random32-to-prandom_u32.patch added to -mm tree
Date: Tue, 05 Mar 2013 17:02:01 -0800
Message-ID: <20130306010201.AE9C65A4253@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:62182 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab3CFBCC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 20:02:02 -0500
Received: by mail-ye0-f201.google.com with SMTP id m12so809311yen.2
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 17:02:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     Subject: kernel/: rename random32() to prandom_u32()
has been added to the -mm tree.  Its filename is
     kernel-rename-random32-to-prandom_u32.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
raid6test-use-prandom_bytes.patch
uuid-use-prandom_bytes.patch
x86-pageattr-test-remove-srandom32-call.patch
x86-rename-random32-to-prandom_u32.patch
lib-rename-random32-to-prandom_u32.patch
mm-rename-random32-to-prandom_u32.patch
kernel-rename-random32-to-prandom_u32.patch
drbd-rename-random32-to-prandom_u32.patch
infiniband-rename-random32-to-prandom_u32.patch
mmc-rename-random32-to-prandom_u32.patch
video-uvesafb-rename-random32-to-prandom_u32.patch
xfs-rename-random32-to-prandom_u32.patch
uwb-rename-random32-to-prandom_u32.patch
lguest-rename-random32-to-prandom_u32.patch
scsi-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32.patch
net-sunrpc-rename-random32-to-prandom_u32.patch
net-sched-rename-random32-to-prandom_u32.patch
net-netfilter-rename-random32-to-prandom_u32.patch
net-core-rename-random32-to-prandom_u32.patch
net-core-remove-duplicate-statements-by-do-while-loop.patch
net-rename-random32-to-prandom.patch
remove-unused-random32-and-srandom32.patch

