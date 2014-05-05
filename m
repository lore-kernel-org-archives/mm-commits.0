From: akpm@linux-foundation.org
Subject: [to-be-updated] printk-add-printk_once_deferred.patch removed
 from -mm tree
Date: Mon, 05 May 2014 15:05:02 -0700
Message-ID: <53680b0e.ZKEK5GVBlEDeSvrC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784AbaEEWFD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2014 18:05:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, rostedt@goodmis.org, peterz@infradead.org, mingo@redhat.com, jbohac@suse.cz, jack@suse.cz, john.stultz@linaro.org

Subject: [to-be-updated] printk-add-printk_once_deferred.patch removed from -mm tree
To: john.stultz@linaro.org,jack@suse.cz,jbohac@suse.cz,mingo@redhat.com,peterz@infradead.org,rostedt@goodmis.org,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 May 2014 15:05:02 -0700


The patch titled
     Subject: printk: add printk_once_deferred()
has been removed from the -mm tree.  Its filename was
     printk-add-printk_once_deferred.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: John Stultz <john.stultz@linaro.org>
Subject: printk: add printk_once_deferred()

Two of the three prink_deferred uses are really printk_once style uses, so
add a printk_once_deferred macro to simplify those call sites.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h  |   11 +++++++++++
 kernel/sched/deadline.c |    7 +------
 kernel/sched/rt.c       |    8 +-------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff -puN include/linux/printk.h~printk-add-printk_once_deferred include/linux/printk.h
--- a/include/linux/printk.h~printk-add-printk_once_deferred
+++ a/include/linux/printk.h
@@ -266,9 +266,20 @@ extern asmlinkage void dump_stack(void)
 		printk(fmt, ##__VA_ARGS__);			\
 	}							\
 })
+#define printk_once_deferred(fmt, ...)				\
+({								\
+	static bool __print_once __read_mostly;			\
+								\
+	if (!__print_once) {					\
+		__print_once = true;				\
+		printk_deferred(fmt, ##__VA_ARGS__);		\
+	}							\
+})
 #else
 #define printk_once(fmt, ...)					\
 	no_printk(fmt, ##__VA_ARGS__)
+#define printk_once_deferred(fmt, ...)				\
+	no_printk(fmt, ##__VA_ARGS__)
 #endif
 
 #define pr_emerg_once(fmt, ...)					\
diff -puN kernel/sched/deadline.c~printk-add-printk_once_deferred kernel/sched/deadline.c
--- a/kernel/sched/deadline.c~printk-add-printk_once_deferred
+++ a/kernel/sched/deadline.c
@@ -348,12 +348,7 @@ static void replenish_dl_entity(struct s
 	 * entity.
 	 */
 	if (dl_time_before(dl_se->deadline, rq_clock(rq))) {
-		static bool lag_once = false;
-
-		if (!lag_once) {
-			lag_once = true;
-			printk_deferred("sched: DL replenish lagged to much\n");
-		}
+		printk_once_deferred("sched: DL replenish lagged to much\n");
 		dl_se->deadline = rq_clock(rq) + pi_se->dl_deadline;
 		dl_se->runtime = pi_se->dl_runtime;
 	}
diff -puN kernel/sched/rt.c~printk-add-printk_once_deferred kernel/sched/rt.c
--- a/kernel/sched/rt.c~printk-add-printk_once_deferred
+++ a/kernel/sched/rt.c
@@ -851,14 +851,8 @@ static int sched_rt_runtime_exceeded(str
 		 * but accrue some time due to boosting.
 		 */
 		if (likely(rt_b->rt_runtime)) {
-			static bool once = false;
-
 			rt_rq->rt_throttled = 1;
