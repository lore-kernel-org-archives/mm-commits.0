From: akpm@linux-foundation.org
Subject: - make-rcutorture-rng-use-temporal-entropy.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:56:36 -0700
Message-ID: <200710180656.l9I6uaw0030714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48239 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760072AbXJRH2G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:28:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmck@linux.vnet.ibm.com, ego@in.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Make rcutorture RNG use temporal entropy
has been removed from the -mm tree.  Its filename was
     make-rcutorture-rng-use-temporal-entropy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make rcutorture RNG use temporal entropy
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Repost of http://lkml.org/lkml/2007/8/10/472 made available by request.

The locking used by get_random_bytes() can conflict with the
preempt_disable() and synchronize_sched() form of RCU.  This patch changes
rcutorture's RNG to gather entropy from the new cpu_clock() interface
(relying on interrupts, preemption, daemons, and rcutorture's reader
thread's rock-bottom scheduling priority to provide useful entropy), and
also adds and EXPORT_SYMBOL_GPL() to make that interface available to GPLed
kernel modules such as rcutorture.

Passes several hours of rcutorture.

[ego@in.ibm.com: Use raw_smp_processor_id() in rcu_random()]
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcutorture.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN kernel/rcutorture.c~make-rcutorture-rng-use-temporal-entropy kernel/rcutorture.c
--- a/kernel/rcutorture.c~make-rcutorture-rng-use-temporal-entropy
+++ a/kernel/rcutorture.c
@@ -41,7 +41,6 @@
 #include <linux/notifier.h>
 #include <linux/freezer.h>
 #include <linux/cpu.h>
-#include <linux/random.h>
 #include <linux/delay.h>
 #include <linux/byteorder/swabb.h>
 #include <linux/stat.h>
@@ -165,16 +164,14 @@ struct rcu_random_state {
 
 /*
  * Crude but fast random-number generator.  Uses a linear congruential
- * generator, with occasional help from get_random_bytes().
+ * generator, with occasional help from cpu_clock().
  */
 static unsigned long
 rcu_random(struct rcu_random_state *rrsp)
 {
-	long refresh;
-
 	if (--rrsp->rrs_count < 0) {
-		get_random_bytes(&refresh, sizeof(refresh));
-		rrsp->rrs_state += refresh;
+		rrsp->rrs_state +=
+			(unsigned long)cpu_clock(raw_smp_processor_id());
 		rrsp->rrs_count = RCU_RANDOM_REFRESH;
 	}
 	rrsp->rrs_state = rrsp->rrs_state * RCU_RANDOM_MULT + RCU_RANDOM_ADD;
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

origin.patch
make-access-to-tasks-nsproxy-lighter.patch
make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare.patch
make-access-to-tasks-nsproxy-lighter-update-get_net_ns_by_pid.patch
