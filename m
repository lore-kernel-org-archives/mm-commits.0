From: akpm@linux-foundation.org
Subject: - fix-printk-format-warnings-in-timer_listc.patch removed from -mm tree
Date: Wed, 09 May 2007 14:50:30 -0700
Message-ID: <200705092150.l49LoUVk002814@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756959AbXEIVuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:50:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Fix printk format warnings in timer_list.c
has been removed from the -mm tree.  Its filename was
     fix-printk-format-warnings-in-timer_listc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix printk format warnings in timer_list.c
From: David Miller <davem@davemloft.net>

u64 and s64 are not necessarily 'long long' on some 64-bit
platforms, so explicit the type to kill the compiler warnings.

Also consistently use '%Lu' which is unsigned.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timer_list.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff -puN kernel/time/timer_list.c~fix-printk-format-warnings-in-timer_listc kernel/time/timer_list.c
--- a/kernel/time/timer_list.c~fix-printk-format-warnings-in-timer_listc
+++ a/kernel/time/timer_list.c
@@ -65,7 +65,7 @@ print_timer(struct seq_file *m, struct h
 	SEQ_printf(m, ", %s/%d", tmp, timer->start_pid);
 #endif
 	SEQ_printf(m, "\n");
-	SEQ_printf(m, " # expires at %Ld nsecs [in %Ld nsecs]\n",
+	SEQ_printf(m, " # expires at %Lu nsecs [in %Lu nsecs]\n",
 		(unsigned long long)ktime_to_ns(timer->expires),
 		(unsigned long long)(ktime_to_ns(timer->expires) - now));
 }
@@ -111,14 +111,14 @@ print_base(struct seq_file *m, struct hr
 {
 	SEQ_printf(m, "  .index:      %d\n",
 			base->index);
-	SEQ_printf(m, "  .resolution: %Ld nsecs\n",
+	SEQ_printf(m, "  .resolution: %Lu nsecs\n",
 			(unsigned long long)ktime_to_ns(base->resolution));
 	SEQ_printf(m,   "  .get_time:   ");
 	print_name_offset(m, base->get_time);
 	SEQ_printf(m,   "\n");
 #ifdef CONFIG_HIGH_RES_TIMERS
-	SEQ_printf(m, "  .offset:     %Ld nsecs\n",
-			ktime_to_ns(base->offset));
+	SEQ_printf(m, "  .offset:     %Lu nsecs\n",
+		   (unsigned long long) ktime_to_ns(base->offset));
 #endif
 	SEQ_printf(m,   "active timers:\n");
 	print_active_timers(m, base, now);
@@ -135,10 +135,11 @@ static void print_cpu(struct seq_file *m
 		print_base(m, cpu_base->clock_base + i, now);
 	}
 #define P(x) \
-	SEQ_printf(m, "  .%-15s: %Ld\n", #x, (u64)(cpu_base->x))
+	SEQ_printf(m, "  .%-15s: %Lu\n", #x, \
+		   (unsigned long long)(cpu_base->x))
 #define P_ns(x) \
-	SEQ_printf(m, "  .%-15s: %Ld nsecs\n", #x, \
-		(u64)(ktime_to_ns(cpu_base->x)))
+	SEQ_printf(m, "  .%-15s: %Lu nsecs\n", #x, \
+		   (unsigned long long)(ktime_to_ns(cpu_base->x)))
 
 #ifdef CONFIG_HIGH_RES_TIMERS
 	P_ns(expires_next);
@@ -150,10 +151,11 @@ static void print_cpu(struct seq_file *m
 
 #ifdef CONFIG_TICK_ONESHOT
 # define P(x) \
-	SEQ_printf(m, "  .%-15s: %Ld\n", #x, (u64)(ts->x))
+	SEQ_printf(m, "  .%-15s: %Lu\n", #x, \
+		   (unsigned long long)(ts->x))
 # define P_ns(x) \
-	SEQ_printf(m, "  .%-15s: %Ld nsecs\n", #x, \
-		(u64)(ktime_to_ns(ts->x)))
+	SEQ_printf(m, "  .%-15s: %Lu nsecs\n", #x, \
+		   (unsigned long long)(ktime_to_ns(ts->x)))
 	{
 		struct tick_sched *ts = tick_get_tick_sched(cpu);
 		P(nohz_mode);
@@ -167,7 +169,8 @@ static void print_cpu(struct seq_file *m
 		P(last_jiffies);
 		P(next_jiffies);
 		P_ns(idle_expires);
-		SEQ_printf(m, "jiffies: %Ld\n", (u64)jiffies);
+		SEQ_printf(m, "jiffies: %Lu\n",
+			   (unsigned long long)jiffies);
 	}
 #endif
 
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
af_rxrpc-reduce-debugging-noise.patch
git-net.patch
sunrpc-fix-crash-in-rpc_malloc.patch
networking-fix-sending-netlink-message-when-replace-route.patch
remove-pci_dac_dma_-apis.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
