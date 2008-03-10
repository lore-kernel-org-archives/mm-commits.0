From: akpm@linux-foundation.org
Subject: + isolate-ratelimit-from-printkc-for-other-use.patch added to -mm tree
Date: Mon, 10 Mar 2008 13:52:03 -0700
Message-ID: <200803102052.m2AKq4x2004931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382AbYCJU5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 16:57:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, paulmck@linux.vnet.ibm.com


The patch titled
     isolate ratelimit from printk.c for other use
has been added to the -mm tree.  Its filename is
     isolate-ratelimit-from-printkc-for-other-use.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isolate ratelimit from printk.c for other use
From: Dave Young <hidave.darkstar@gmail.com>

Due to the rcupreempt.h WARN_ON trigged, I got 2G syslog file.  For some
serious complaining of kernel, we need repeat the warnings, so here I isolate
the ratelimit part of printk.c to a standalone file.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    1 
 kernel/printk.c        |   26 -------------------
 lib/Makefile           |    2 -
 lib/ratelimit.c        |   51 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 54 insertions(+), 26 deletions(-)

diff -puN include/linux/kernel.h~isolate-ratelimit-from-printkc-for-other-use include/linux/kernel.h
--- a/include/linux/kernel.h~isolate-ratelimit-from-printkc-for-other-use
+++ a/include/linux/kernel.h
@@ -188,6 +188,7 @@ extern int log_buf_copy(char *dest, int 
 extern int printk_ratelimit_jiffies;
 extern int printk_ratelimit_burst;
 extern int printk_ratelimit(void);
+extern int __ratelimit(int ratelimit_jiffies, int ratelimit_burst);
 extern int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst);
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
diff -puN kernel/printk.c~isolate-ratelimit-from-printkc-for-other-use kernel/printk.c
--- a/kernel/printk.c~isolate-ratelimit-from-printkc-for-other-use
+++ a/kernel/printk.c
@@ -1261,31 +1261,7 @@ void tty_write_message(struct tty_struct
  */
 int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst)
 {
-	static DEFINE_SPINLOCK(ratelimit_lock);
-	static unsigned toks = 10 * 5 * HZ;
-	static unsigned long last_msg;
-	static int missed;
-	unsigned long flags;
-	unsigned long now = jiffies;
-
-	spin_lock_irqsave(&ratelimit_lock, flags);
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
-			printk(KERN_WARNING "printk: %d messages suppressed.\n", lost);
-		return 1;
-	}
-	missed++;
-	spin_unlock_irqrestore(&ratelimit_lock, flags);
-	return 0;
+	return __ratelimit(ratelimit_jiffies, ratelimit_burst);
 }
 EXPORT_SYMBOL(__printk_ratelimit);
 
diff -puN lib/Makefile~isolate-ratelimit-from-printkc-for-other-use lib/Makefile
--- a/lib/Makefile~isolate-ratelimit-from-printkc-for-other-use
+++ a/lib/Makefile
@@ -6,7 +6,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
-	 proportions.o prio_heap.o
+	 proportions.o prio_heap.o ratelimit.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
diff -puN /dev/null lib/ratelimit.c
--- /dev/null
+++ a/lib/ratelimit.c
@@ -0,0 +1,51 @@
+/*
+ * ratelimit.c - Do something with rate limit.
+ *
+ * Isolated from kernel/printk.c by Dave Young <hidave.darkstar@gmail.com>
+ *
+ * This file is released under the GPLv2.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/jiffies.h>
+#include <linux/module.h>
+
+/*
+ * __ratelimit - rate limiting
+ * @ratelimit_jiffies: minimum time in jiffies between too callbacks
+ * @ratelimit_burst: number of callbacks we do before ratelimiting
+ *
+ * This enforces a rate limit: not more than @ratelimit_burst callbacks
+ * in every ratelimit_jiffies
+ */
+int __ratelimit(int ratelimit_jiffies, int ratelimit_burst)
+{
+	static DEFINE_SPINLOCK(ratelimit_lock);
+	static unsigned toks = 10 * 5 * HZ;
+	static unsigned long last_msg;
+	static int missed;
+	unsigned long flags;
+	unsigned long now = jiffies;
+
+	spin_lock_irqsave(&ratelimit_lock, flags);
+	toks += now - last_msg;
+	last_msg = now;
+	if (toks > (ratelimit_burst * ratelimit_jiffies))
+		toks = ratelimit_burst * ratelimit_jiffies;
+	if (toks >= ratelimit_jiffies) {
+		int lost = missed;
+
+		missed = 0;
+		toks -= ratelimit_jiffies;
+		spin_unlock_irqrestore(&ratelimit_lock, flags);
+		if (lost)
+			printk(KERN_WARNING "__ratelimit: %d messages"
+				" suppressed.\n", lost);
+		return 1;
+	}
+	missed++;
+	spin_unlock_irqrestore(&ratelimit_lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL(__ratelimit);
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
git-net.patch
isolate-ratelimit-from-printkc-for-other-use.patch
add-warn_on_secs-macro.patch
use-warn_on_secs-in-rcupreempth.patch

