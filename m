From: akpm@linux-foundation.org
Subject: - use-warn_on_secs-in-rcupreempth.patch removed from -mm tree
Date: Tue, 06 May 2008 12:24:30 -0700
Message-ID: <200805061924.m46JOUqU023114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43183 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757915AbYEFTZm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 15:25:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Use WARN_ON_SECS in rcupreempt.h
has been removed from the -mm tree.  Its filename was
     use-warn_on_secs-in-rcupreempth.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use WARN_ON_SECS in rcupreempt.h
From: Dave Young <hidave.darkstar@gmail.com>

Use WARN_ON_SECS in rcupreempt.h to avoid warning flood

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rcupreempt.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/rcupreempt.h~use-warn_on_secs-in-rcupreempth include/linux/rcupreempt.h
--- a/include/linux/rcupreempt.h~use-warn_on_secs-in-rcupreempth
+++ a/include/linux/rcupreempt.h
@@ -117,14 +117,14 @@ static inline void rcu_enter_nohz(void)
 {
 	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
 	__get_cpu_var(rcu_dyntick_sched).dynticks++;
-	WARN_ON(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1);
+	WARN_ON_SECS(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1, 10);
 }
 
 static inline void rcu_exit_nohz(void)
 {
 	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
 	__get_cpu_var(rcu_dyntick_sched).dynticks++;
-	WARN_ON(!(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1));
+	WARN_ON_SECS(!(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1), 10);
 }
 
 #else /* CONFIG_NO_HZ */
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
printk-ratelimiting-rewrite.patch
use-warn_on_secs-in-rcupreempth.patch

