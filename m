From: akpm@linux-foundation.org
Subject: [merged]
 ratelimit-extend-to-print-suppressed-messages-on-release.patch removed from -mm tree
Date: Wed, 03 Aug 2016 11:12:11 -0700
Message-ID: <57a233fb.LQdKWfMgvUY2dg5v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643AbcHCSN3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@suse.de, dyoung@redhat.com, fbui@suse.com, gregkh@linuxfoundation.org, mingo@kernel.org, peterz@infradead.org, rostedt@goodmis.org, torvalds@linux-foundation.org, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ratelimit: extend to print suppressed messages on release
has been removed from the -mm tree.  Its filename was
     ratelimit-extend-to-print-suppressed-messages-on-release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Borislav Petkov <bp@suse.de>
Subject: ratelimit: extend to print suppressed messages on release

Extend the ratelimiting facility to print the amount of suppressed lines
when it is being released.

This use case is aimed at short-termed, burst-like users for which we want
to output the suppressed lines stats only once, after it has been disposed
of.  For an example, see /dev/kmsg usage in a follow-on patch.

Also, change the printk() line we issue on release to not use "callbacks"
as it is misleading: we're not suppressing callbacks but printk() calls.

This has been separated from a previous patch by Linus.

Link: http://lkml.kernel.org/r/20160716061745.15795-2-bp@alien8.de
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Dave Young <dyoung@redhat.com>
Cc: Franck Bui <fbui@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ratelimit.h |   38 +++++++++++++++++++++++++++++++-----
 lib/ratelimit.c           |   10 +++++----
 2 files changed, 39 insertions(+), 9 deletions(-)

diff -puN include/linux/ratelimit.h~ratelimit-extend-to-print-suppressed-messages-on-release include/linux/ratelimit.h
--- a/include/linux/ratelimit.h~ratelimit-extend-to-print-suppressed-messages-on-release
+++ a/include/linux/ratelimit.h
@@ -2,11 +2,15 @@
 #define _LINUX_RATELIMIT_H
 
 #include <linux/param.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 
 #define DEFAULT_RATELIMIT_INTERVAL	(5 * HZ)
 #define DEFAULT_RATELIMIT_BURST		10
 
+/* issue num suppressed message on exit */
+#define RATELIMIT_MSG_ON_RELEASE	BIT(0)
+
 struct ratelimit_state {
 	raw_spinlock_t	lock;		/* protect the state */
 
@@ -15,6 +19,7 @@ struct ratelimit_state {
 	int		printed;
 	int		missed;
 	unsigned long	begin;
+	unsigned long	flags;
 };
 
 #define RATELIMIT_STATE_INIT(name, interval_init, burst_init) {		\
@@ -34,12 +39,35 @@ struct ratelimit_state {
 static inline void ratelimit_state_init(struct ratelimit_state *rs,
 					int interval, int burst)
 {
+	memset(rs, 0, sizeof(*rs));
+
 	raw_spin_lock_init(&rs->lock);
-	rs->interval = interval;
-	rs->burst = burst;
-	rs->printed = 0;
-	rs->missed = 0;
-	rs->begin = 0;
+	rs->interval	= interval;
+	rs->burst	= burst;
+}
+
+static inline void ratelimit_default_init(struct ratelimit_state *rs)
+{
+	return ratelimit_state_init(rs, DEFAULT_RATELIMIT_INTERVAL,
+					DEFAULT_RATELIMIT_BURST);
+}
+
+static inline void ratelimit_state_exit(struct ratelimit_state *rs)
+{
+	if (!(rs->flags & RATELIMIT_MSG_ON_RELEASE))
+		return;
+
+	if (rs->missed) {
+		pr_warn("%s: %d output lines suppressed due to ratelimiting\n",
+			current->comm, rs->missed);
+		rs->missed = 0;
+	}
+}
+
+static inline void
+ratelimit_set_flags(struct ratelimit_state *rs, unsigned long flags)
+{
+	rs->flags = flags;
 }
 
 extern struct ratelimit_state printk_ratelimit_state;
diff -puN lib/ratelimit.c~ratelimit-extend-to-print-suppressed-messages-on-release lib/ratelimit.c
--- a/lib/ratelimit.c~ratelimit-extend-to-print-suppressed-messages-on-release
+++ a/lib/ratelimit.c
@@ -46,12 +46,14 @@ int ___ratelimit(struct ratelimit_state
 		rs->begin = jiffies;
 
 	if (time_is_before_jiffies(rs->begin + rs->interval)) {
-		if (rs->missed)
-			printk(KERN_WARNING "%s: %d callbacks suppressed\n",
-				func, rs->missed);
+		if (rs->missed) {
+			if (!(rs->flags & RATELIMIT_MSG_ON_RELEASE)) {
+				pr_warn("%s: %d callbacks suppressed\n", func, rs->missed);
+				rs->missed = 0;
+			}
+		}
 		rs->begin   = jiffies;
 		rs->printed = 0;
-		rs->missed  = 0;
 	}
 	if (rs->burst && rs->burst > rs->printed) {
 		rs->printed++;
_

Patches currently in -mm which might be from bp@suse.de are


