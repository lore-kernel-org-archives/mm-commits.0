From: akpm@linux-foundation.org
Subject: [to-be-updated]
 printk-rename-printk_sched-to-printk_deferred.patch removed from -mm tree
Date: Mon, 05 May 2014 15:05:00 -0700
Message-ID: <53680b0c.KQCUvv6uCZC7rE9n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51915 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762AbaEEWFB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2014 18:05:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, rostedt@goodmis.org, peterz@infradead.org, mingo@redhat.com, jbohac@suse.cz, jack@suse.cz, john.stultz@linaro.org

Subject: [to-be-updated] printk-rename-printk_sched-to-printk_deferred.patch removed from -mm tree
To: john.stultz@linaro.org,jack@suse.cz,jbohac@suse.cz,mingo@redhat.com,peterz@infradead.org,rostedt@goodmis.org,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 May 2014 15:05:00 -0700


The patch titled
     Subject: printk: rename printk_sched to printk_deferred
has been removed from the -mm tree.  Its filename was
     printk-rename-printk_sched-to-printk_deferred.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: John Stultz <john.stultz@linaro.org>
Subject: printk: rename printk_sched to printk_deferred

After learning we'll need some sort of deferred printk functionality in
the timekeeping core, Peter suggested we rename the printk_sched function
so it can be reused by needed subsystems.

This only changes the function name and name of the associated buffer.  No
logic changes.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h  |    6 +++---
 kernel/printk/printk.c  |    2 +-
 kernel/sched/core.c     |    2 +-
 kernel/sched/deadline.c |    2 +-
 kernel/sched/rt.c       |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff -puN include/linux/printk.h~printk-rename-printk_sched-to-printk_deferred include/linux/printk.h
--- a/include/linux/printk.h~printk-rename-printk_sched-to-printk_deferred
+++ a/include/linux/printk.h
@@ -128,9 +128,9 @@ asmlinkage __printf(1, 2) __cold
 int printk(const char *fmt, ...);
 
 /*
- * Special printk facility for scheduler use only, _DO_NOT_USE_ !
+ * Special printk facility for scheduler/timekeeping use only, _DO_NOT_USE_ !
  */
-__printf(1, 2) __cold int printk_sched(const char *fmt, ...);
+__printf(1, 2) __cold int printk_deferred(const char *fmt, ...);
 
 /*
  * Please don't use printk_ratelimit(), because it shares ratelimiting state
@@ -165,7 +165,7 @@ int printk(const char *s, ...)
 	return 0;
 }
 static inline __printf(1, 2) __cold
-int printk_sched(const char *s, ...)
+int printk_deferred(const char *s, ...)
 {
 	return 0;
 }
diff -puN kernel/printk/printk.c~printk-rename-printk_sched-to-printk_deferred kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-rename-printk_sched-to-printk_deferred
+++ a/kernel/printk/printk.c
@@ -2584,7 +2584,7 @@ void wake_up_klogd(void)
 	preempt_enable();
 }
 
-int printk_sched(const char *fmt, ...)
+int printk_deferred(const char *fmt, ...)
 {
 	unsigned long flags;
 	va_list args;
diff -puN kernel/sched/core.c~printk-rename-printk_sched-to-printk_deferred kernel/sched/core.c
--- a/kernel/sched/core.c~printk-rename-printk_sched-to-printk_deferred
+++ a/kernel/sched/core.c
@@ -1320,7 +1320,7 @@ out:
 		 * leave kernel.
 		 */
 		if (p->mm && printk_ratelimit()) {
-			printk_sched("process %d (%s) no longer affine to cpu%d\n",
+			printk_deferred("process %d (%s) no longer affine to cpu%d\n",
 					task_pid_nr(p), p->comm, cpu);
 		}
 	}
diff -puN kernel/sched/deadline.c~printk-rename-printk_sched-to-printk_deferred kernel/sched/deadline.c
--- a/kernel/sched/deadline.c~printk-rename-printk_sched-to-printk_deferred
+++ a/kernel/sched/deadline.c
@@ -352,7 +352,7 @@ static void replenish_dl_entity(struct s
 
 		if (!lag_once) {
 			lag_once = true;
-			printk_sched("sched: DL replenish lagged to much\n");
+			printk_deferred("sched: DL replenish lagged to much\n");
 		}
 		dl_se->deadline = rq_clock(rq) + pi_se->dl_deadline;
 		dl_se->runtime = pi_se->dl_runtime;
diff -puN kernel/sched/rt.c~printk-rename-printk_sched-to-printk_deferred kernel/sched/rt.c
--- a/kernel/sched/rt.c~printk-rename-printk_sched-to-printk_deferred
+++ a/kernel/sched/rt.c
@@ -857,7 +857,7 @@ static int sched_rt_runtime_exceeded(str
 
 			if (!once) {
 				once = true;
-				printk_sched("sched: RT throttling activated\n");
+				printk_deferred("sched: RT throttling activated\n");
 			}
 		} else {
 			/*
_

Patches currently in -mm which might be from john.stultz@linaro.org are

printk-add-printk_once_deferred.patch
timekeeping-use-printk_deferred-when-holding-timekeeping-seqlock.patch

