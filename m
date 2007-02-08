From: akpm@linux-foundation.org
Subject: - user-of-the-jiffies-rounding-code-networking.patch removed from -mm tree
Date: Thu, 08 Feb 2007 13:52:23 -0800
Message-ID: <200702082152.l18LqNE6027639@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41369 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423461AbXBHVw0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 16:52:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     user of the jiffies rounding code: Networking
has been removed from the -mm tree.  Its filename was
     user-of-the-jiffies-rounding-code-networking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: user of the jiffies rounding code: Networking
From: Arjan van de Ven <arjan@linux.intel.com>

This patch introduces users of the round_jiffies() function in the networking
code.

These timers all were of the "about once a second" or "about once every X
seconds" variety and several showed up in the "what wakes the cpu up" profiles
that the tickless patches provide.  Some timers are highly dynamic based on
network load; but even on low activity systems they still show up so the
rounding is done only in cases of low activity, allowing higher frequency
timers in the high activity case.

The various hardware watchdogs are an obvious case; they run every 2 seconds
but aren't otherwise specific of exactly when they need to run.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/dst.c          |    9 ++++++++-
 net/core/neighbour.c    |    5 ++++-
 net/sched/sch_generic.c |    2 +-
 3 files changed, 13 insertions(+), 3 deletions(-)

diff -puN net/core/dst.c~user-of-the-jiffies-rounding-code-networking net/core/dst.c
--- a/net/core/dst.c~user-of-the-jiffies-rounding-code-networking
+++ a/net/core/dst.c
@@ -99,7 +99,14 @@ static void dst_run_gc(unsigned long dum
 	printk("dst_total: %d/%d %ld\n",
 	       atomic_read(&dst_total), delayed,  dst_gc_timer_expires);
 #endif
-	mod_timer(&dst_gc_timer, jiffies + dst_gc_timer_expires);
+	/* if the next desired timer is more than 4 seconds in the future
+	 * then round the timer to whole seconds
+	 */
+	if (dst_gc_timer_expires > 4*HZ)
+		mod_timer(&dst_gc_timer,
+			round_jiffies(jiffies + dst_gc_timer_expires));
+	else
+		mod_timer(&dst_gc_timer, jiffies + dst_gc_timer_expires);
 
 out:
 	spin_unlock(&dst_lock);
diff -puN net/core/neighbour.c~user-of-the-jiffies-rounding-code-networking net/core/neighbour.c
--- a/net/core/neighbour.c~user-of-the-jiffies-rounding-code-networking
+++ a/net/core/neighbour.c
@@ -696,7 +696,10 @@ next_elt:
 	if (!expire)
 		expire = 1;
 
- 	mod_timer(&tbl->gc_timer, now + expire);
+	if (expire>HZ)
+		mod_timer(&tbl->gc_timer, round_jiffies(now + expire));
+	else
+	 	mod_timer(&tbl->gc_timer, now + expire);
 
 	write_unlock(&tbl->lock);
 }
diff -puN net/sched/sch_generic.c~user-of-the-jiffies-rounding-code-networking net/sched/sch_generic.c
--- a/net/sched/sch_generic.c~user-of-the-jiffies-rounding-code-networking
+++ a/net/sched/sch_generic.c
@@ -209,7 +209,7 @@ static void dev_watchdog(unsigned long a
 				       dev->name);
 				dev->tx_timeout(dev);
 			}
-			if (!mod_timer(&dev->watchdog_timer, jiffies + dev->watchdog_timeo))
+			if (!mod_timer(&dev->watchdog_timer, round_jiffies(jiffies + dev->watchdog_timeo)))
 				dev_hold(dev);
 		}
 	}
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
git-libata-all.patch
user-of-the-jiffies-rounding-code-e1000.patch
git-net.patch
mark-struct-file_operations-const-1.patch
mark-struct-file_operations-const-2.patch
mark-struct-file_operations-const-2-fix.patch
mark-struct-file_operations-const-3.patch
mark-struct-file_operations-const-4.patch
mark-struct-file_operations-const-4-fix.patch
mark-struct-file_operations-const-5.patch
mark-struct-file_operations-const-6.patch
mark-struct-file_operations-const-7.patch
mark-struct-file_operations-const-8.patch
mark-struct-file_operations-const-9.patch
mark-struct-inode_operations-const-1.patch
mark-struct-inode_operations-const-2.patch
mark-struct-inode_operations-const-3.patch
