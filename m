From: akpm@linux-foundation.org
Subject: - printk-ratelimiting-rewrite.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:55:33 -0700
Message-ID: <200807252255.m6PMtXaR002986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754537AbYGYXHB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, davem@davemloft.net, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     printk ratelimiting rewrite
has been removed from the -mm tree.  Its filename was
     printk-ratelimiting-rewrite.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk ratelimiting rewrite
From: Dave Young <hidave.darkstar@gmail.com>

All ratelimit user use same jiffies and burst params, so some messages
(callbacks) will be lost.

For example:
a call printk_ratelimit(5 * HZ, 1)
b call printk_ratelimit(5 * HZ, 1) before the 5*HZ timeout of a, then b will
will be supressed.

- rewrite __ratelimit, and use a ratelimit_state as parameter.  Thanks for
  hints from andrew.

- Add WARN_ON_RATELIMIT, update rcupreempt.h

- remove __printk_ratelimit

- use __ratelimit in net_ratelimit

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h  |    3 +
 include/linux/kernel.h     |    8 +---
 include/linux/net.h        |    3 -
 include/linux/ratelimit.h  |   27 ++++++++++++++++
 include/linux/rcupreempt.h |    9 ++++-
 kernel/printk.c            |   17 +---------
 kernel/sysctl.c            |    4 +-
 lib/ratelimit.c            |   57 +++++++++++++++++++----------------
 net/core/sysctl_net_core.c |    4 +-
 net/core/utils.c           |    5 +--
 10 files changed, 80 insertions(+), 57 deletions(-)

diff -puN include/asm-generic/bug.h~printk-ratelimiting-rewrite include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~printk-ratelimiting-rewrite
+++ a/include/asm-generic/bug.h
@@ -97,6 +97,9 @@ extern void warn_slowpath(const char *fi
 	unlikely(__ret_warn_once);				\
 })
 
+#define WARN_ON_RATELIMIT(condition, state)			\
+		WARN_ON((condition) && __ratelimit(state))
+
 #ifdef CONFIG_SMP
 # define WARN_ON_SMP(x)			WARN_ON(x)
 #else
diff -puN include/linux/kernel.h~printk-ratelimiting-rewrite include/linux/kernel.h
--- a/include/linux/kernel.h~printk-ratelimiting-rewrite
+++ a/include/linux/kernel.h
@@ -15,6 +15,7 @@
 #include <linux/bitops.h>
 #include <linux/log2.h>
 #include <linux/typecheck.h>
+#include <linux/ratelimit.h>
 #include <asm/byteorder.h>
 #include <asm/bug.h>
 
@@ -189,11 +190,8 @@ asmlinkage int vprintk(const char *fmt, 
 asmlinkage int printk(const char * fmt, ...)
 	__attribute__ ((format (printf, 1, 2))) __cold;
 
-extern int printk_ratelimit_jiffies;
-extern int printk_ratelimit_burst;
+extern struct ratelimit_state printk_ratelimit_state;
 extern int printk_ratelimit(void);
-extern int __ratelimit(int ratelimit_jiffies, int ratelimit_burst);
-extern int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst);
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
 #else
@@ -204,8 +202,6 @@ static inline int printk(const char *s, 
 	__attribute__ ((format (printf, 1, 2)));
 static inline int __cold printk(const char *s, ...) { return 0; }
 static inline int printk_ratelimit(void) { return 0; }
-static inline int __printk_ratelimit(int ratelimit_jiffies, \
-				     int ratelimit_burst) { return 0; }
 static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
 					  unsigned int interval_msec)	\
 		{ return false; }
diff -puN include/linux/net.h~printk-ratelimiting-rewrite include/linux/net.h
--- a/include/linux/net.h~printk-ratelimiting-rewrite
+++ a/include/linux/net.h
@@ -351,8 +351,7 @@ static const struct proto_ops name##_ops
 
 #ifdef CONFIG_SYSCTL
 #include <linux/sysctl.h>
-extern int net_msg_cost;
-extern int net_msg_burst;
+extern struct ratelimit_state net_ratelimit_state;
 #endif
 
 #endif /* __KERNEL__ */
diff -puN /dev/null include/linux/ratelimit.h
--- /dev/null
+++ a/include/linux/ratelimit.h
@@ -0,0 +1,27 @@
+#ifndef _LINUX_RATELIMIT_H
+#define _LINUX_RATELIMIT_H
+#include <linux/param.h>
+
+#define DEFAULT_RATELIMIT_INTERVAL (5 * HZ)
+#define DEFAULT_RATELIMIT_BURST 10
+
+struct ratelimit_state {
+	int interval;
+	int burst;
+	int printed;
+	int missed;
+	unsigned long begin;
+};
+
+#define DEFINE_RATELIMIT_STATE(name, interval, burst)		\
+		struct ratelimit_state name = {interval, burst,}
+
+extern int __ratelimit(struct ratelimit_state *rs);
+
+static inline int ratelimit(void)
+{
+	static DEFINE_RATELIMIT_STATE(rs, DEFAULT_RATELIMIT_INTERVAL,
+					DEFAULT_RATELIMIT_BURST);
+	return __ratelimit(&rs);
+}
+#endif
diff -puN include/linux/rcupreempt.h~printk-ratelimiting-rewrite include/linux/rcupreempt.h
--- a/include/linux/rcupreempt.h~printk-ratelimiting-rewrite
+++ a/include/linux/rcupreempt.h
@@ -115,16 +115,21 @@ DECLARE_PER_CPU(struct rcu_dyntick_sched
 
 static inline void rcu_enter_nohz(void)
 {
+	static DEFINE_RATELIMIT_STATE(rs, 10 * HZ, 1);
+
 	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
 	__get_cpu_var(rcu_dyntick_sched).dynticks++;
-	WARN_ON(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1);
+	WARN_ON_RATELIMIT(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1, &rs);
 }
 
 static inline void rcu_exit_nohz(void)
 {
+	static DEFINE_RATELIMIT_STATE(rs, 10 * HZ, 1);
+
 	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
 	__get_cpu_var(rcu_dyntick_sched).dynticks++;
-	WARN_ON(!(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1));
+	WARN_ON_RATELIMIT(!(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1),
+				&rs);
 }
 
 #else /* CONFIG_NO_HZ */
diff -puN kernel/printk.c~printk-ratelimiting-rewrite kernel/printk.c
--- a/kernel/printk.c~printk-ratelimiting-rewrite
+++ a/kernel/printk.c
@@ -1308,6 +1308,8 @@ void tty_write_message(struct tty_struct
 }
 
 #if defined CONFIG_PRINTK
+
+DEFINE_RATELIMIT_STATE(printk_ratelimit_state, 5 * HZ, 10);
 /*
  * printk rate limiting, lifted from the networking subsystem.
  *
@@ -1315,22 +1317,9 @@ void tty_write_message(struct tty_struct
  * every printk_ratelimit_jiffies to make a denial-of-service
  * attack impossible.
  */
-int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst)
-{
-	return __ratelimit(ratelimit_jiffies, ratelimit_burst);
-}
-EXPORT_SYMBOL(__printk_ratelimit);
-
-/* minimum time in jiffies between messages */
-int printk_ratelimit_jiffies = 5 * HZ;
-
-/* number of messages we send before ratelimiting */
-int printk_ratelimit_burst = 10;
-
 int printk_ratelimit(void)
 {
-	return __printk_ratelimit(printk_ratelimit_jiffies,
-				printk_ratelimit_burst);
+	return __ratelimit(&printk_ratelimit_state);
 }
 EXPORT_SYMBOL(printk_ratelimit);
 
diff -puN kernel/sysctl.c~printk-ratelimiting-rewrite kernel/sysctl.c
--- a/kernel/sysctl.c~printk-ratelimiting-rewrite
+++ a/kernel/sysctl.c
@@ -624,7 +624,7 @@ static struct ctl_table kern_table[] = {
 	{
 		.ctl_name	= KERN_PRINTK_RATELIMIT,
 		.procname	= "printk_ratelimit",
-		.data		= &printk_ratelimit_jiffies,
+		.data		= &printk_ratelimit_state.interval,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
@@ -633,7 +633,7 @@ static struct ctl_table kern_table[] = {
 	{
 		.ctl_name	= KERN_PRINTK_RATELIMIT_BURST,
 		.procname	= "printk_ratelimit_burst",
-		.data		= &printk_ratelimit_burst,
+		.data		= &printk_ratelimit_state.burst,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
diff -puN lib/ratelimit.c~printk-ratelimiting-rewrite lib/ratelimit.c
--- a/lib/ratelimit.c~printk-ratelimiting-rewrite
+++ a/lib/ratelimit.c
@@ -3,6 +3,9 @@
  *
  * Isolated from kernel/printk.c by Dave Young <hidave.darkstar@gmail.com>
  *
+ * 2008-05-01 rewrite the function and use a ratelimit_state data struct as
+ * parameter. Now every user can use their own standalone ratelimit_state.
+ *
  * This file is released under the GPLv2.
  *
  */
@@ -11,41 +14,43 @@
 #include <linux/jiffies.h>
 #include <linux/module.h>
 
+static DEFINE_SPINLOCK(ratelimit_lock);
+static unsigned long flags;
+
 /*
  * __ratelimit - rate limiting
- * @ratelimit_jiffies: minimum time in jiffies between two callbacks
- * @ratelimit_burst: number of callbacks we do before ratelimiting
+ * @rs: ratelimit_state data
  *
- * This enforces a rate limit: not more than @ratelimit_burst callbacks
- * in every ratelimit_jiffies
+ * This enforces a rate limit: not more than @rs->ratelimit_burst callbacks
+ * in every @rs->ratelimit_jiffies
  */
-int __ratelimit(int ratelimit_jiffies, int ratelimit_burst)
+int __ratelimit(struct ratelimit_state *rs)
 {
-	static DEFINE_SPINLOCK(ratelimit_lock);
-	static unsigned toks = 10 * 5 * HZ;
-	static unsigned long last_msg;
-	static int missed;
-	unsigned long flags;
-	unsigned long now = jiffies;
+	if (!rs->interval)
+		return 1;
 
 	spin_lock_irqsave(&ratelimit_lock, flags);
-	toks += now - last_msg;
-	last_msg = now;
-	if (toks > (ratelimit_burst * ratelimit_jiffies))
-		toks = ratelimit_burst * ratelimit_jiffies;
-	if (toks >= ratelimit_jiffies) {
-		int lost = missed;
-
-		missed = 0;
-		toks -= ratelimit_jiffies;
-		spin_unlock_irqrestore(&ratelimit_lock, flags);
-		if (lost)
-			printk(KERN_WARNING "%s: %d messages suppressed\n",
-				__func__, lost);
-		return 1;
+	if (!rs->begin)
+		rs->begin = jiffies;
+
+	if (time_is_before_jiffies(rs->begin + rs->interval)) {
+		if (rs->missed)
+			printk(KERN_WARNING "%s: %d callbacks suppressed\n",
+				__func__, rs->missed);
+		rs->begin = 0;
+		rs->printed = 0;
+		rs->missed = 0;
 	}
-	missed++;
+	if (rs->burst && rs->burst > rs->printed)
+		goto print;
+
+	rs->missed++;
 	spin_unlock_irqrestore(&ratelimit_lock, flags);
 	return 0;
+
+print:
+	rs->printed++;
+	spin_unlock_irqrestore(&ratelimit_lock, flags);
+	return 1;
 }
 EXPORT_SYMBOL(__ratelimit);
diff -puN net/core/sysctl_net_core.c~printk-ratelimiting-rewrite net/core/sysctl_net_core.c
--- a/net/core/sysctl_net_core.c~printk-ratelimiting-rewrite
+++ a/net/core/sysctl_net_core.c
@@ -67,7 +67,7 @@ static struct ctl_table net_core_table[]
 	{
 		.ctl_name	= NET_CORE_MSG_COST,
 		.procname	= "message_cost",
-		.data		= &net_msg_cost,
+		.data		= &net_ratelimit_state.interval,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
@@ -76,7 +76,7 @@ static struct ctl_table net_core_table[]
 	{
 		.ctl_name	= NET_CORE_MSG_BURST,
 		.procname	= "message_burst",
-		.data		= &net_msg_burst,
+		.data		= &net_ratelimit_state.burst,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
diff -puN net/core/utils.c~printk-ratelimiting-rewrite net/core/utils.c
--- a/net/core/utils.c~printk-ratelimiting-rewrite
+++ a/net/core/utils.c
@@ -31,17 +31,16 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 
-int net_msg_cost __read_mostly = 5*HZ;
-int net_msg_burst __read_mostly = 10;
 int net_msg_warn __read_mostly = 1;
 EXPORT_SYMBOL(net_msg_warn);
 
+DEFINE_RATELIMIT_STATE(net_ratelimit_state, 5 * HZ, 10);
 /*
  * All net warning printk()s should be guarded by this function.
  */
 int net_ratelimit(void)
 {
-	return __printk_ratelimit(net_msg_cost, net_msg_burst);
+	return __ratelimit(&net_ratelimit_state);
 }
 EXPORT_SYMBOL(net_ratelimit);
 
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch

