From: akpm@linux-foundation.org
Subject: [to-be-updated]
 timekeeping-use-printk_deferred-when-holding-timekeeping-seqlock.patch
 removed from -mm tree
Date: Mon, 05 May 2014 15:05:04 -0700
Message-ID: <53680b10.mnoCp/THmdn45PDC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784AbaEEWFF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2014 18:05:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, rostedt@goodmis.org, peterz@infradead.org, mingo@redhat.com, jbohac@suse.cz, jack@suse.cz, john.stultz@linaro.org

Subject: [to-be-updated] timekeeping-use-printk_deferred-when-holding-timekeeping-seqlock.patch removed from -mm tree
To: john.stultz@linaro.org,jack@suse.cz,jbohac@suse.cz,mingo@redhat.com,peterz@infradead.org,rostedt@goodmis.org,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 May 2014 15:05:04 -0700


The patch titled
     Subject: timekeeping: use printk_deferred() when holding timekeeping seqlock
has been removed from the -mm tree.  Its filename was
     timekeeping-use-printk_deferred-when-holding-timekeeping-seqlock.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: John Stultz <john.stultz@linaro.org>
Subject: timekeeping: use printk_deferred() when holding timekeeping seqlock

Jiri Bohac pointed out that there are rare but potential deadlock
possibilities when calling printk while holding the timekeeping seqlock.

This is due to printk() triggering console sem wakeup, which can cause
scheduling code to trigger hrtimers which may try to read the time.

Specifically, as Jiri pointed out, that path is:
  printk
    vprintk_emit
      console_unlock
        up(&console_sem)
          __up
	    wake_up_process
	      try_to_wake_up
	        ttwu_do_activate
		  ttwu_activate
		    activate_task
		      enqueue_task
		        enqueue_task_fair
			  hrtick_update
			    hrtick_start_fair
			      hrtick_start_fair
			        get_time
				  ktime_get
				    --> endless loop on
				    read_seqcount_retry(&timekeeper_seq, ...)

This patch tries to avoid this issue by using printk_deferred (previously
named printk_sched) which should defer printing via a irq_work_queue.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Reported-by: Jiri Bohac <jbohac@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/ntp.c         |   15 +++++++++------
 kernel/time/timekeeping.c |    7 ++++---
 2 files changed, 13 insertions(+), 9 deletions(-)

diff -puN kernel/time/ntp.c~timekeeping-use-printk_deferred-when-holding-timekeeping-seqlock kernel/time/ntp.c
--- a/kernel/time/ntp.c~timekeeping-use-printk_deferred-when-holding-timekeeping-seqlock
+++ a/kernel/time/ntp.c
@@ -786,8 +786,9 @@ static long hardpps_update_freq(struct p
 		time_status |= STA_PPSERROR;
 		pps_errcnt++;
 		pps_dec_freq_interval();
-		pr_err("hardpps: PPSERROR: interval too long - %ld s\n",
-				freq_norm.sec);
+		printk_deferred(KERN_ERR
+			"hardpps: PPSERROR: interval too long - %ld s\n",
+			freq_norm.sec);
 		return 0;
 	}
 
@@ -800,7 +801,8 @@ static long hardpps_update_freq(struct p
 	delta = shift_right(ftemp - pps_freq, NTP_SCALE_SHIFT);
 	pps_freq = ftemp;
 	if (delta > PPS_MAXWANDER || delta < -PPS_MAXWANDER) {
-		pr_warning("hardpps: PPSWANDER: change=%ld\n", delta);
+		printk_deferred(KERN_WARNING
+				"hardpps: PPSWANDER: change=%ld\n", delta);
 		time_status |= STA_PPSWANDER;
 		pps_stbcnt++;
 		pps_dec_freq_interval();
@@ -844,8 +846,9 @@ static void hardpps_update_phase(long er
 	 * the time offset is updated.
 	 */
 	if (jitter > (pps_jitter << PPS_POPCORN)) {
-		pr_warning("hardpps: PPSJITTER: jitter=%ld, limit=%ld\n",
-		       jitter, (pps_jitter << PPS_POPCORN));
+		printk_deferred(KERN_WARNING
+				"hardpps: PPSJITTER: jitter=%ld, limit=%ld\n",
+				jitter, (pps_jitter << PPS_POPCORN));
 		time_status |= STA_PPSJITTER;
 		pps_jitcnt++;
 	} else if (time_status & STA_PPSTIME) {
@@ -902,7 +905,7 @@ void __hardpps(const struct timespec *ph
 		time_status |= STA_PPSJITTER;
 		/* restart the frequency calibration interval */
 		pps_fbase = *raw_ts;
-		pr_err("hardpps: PPSJITTER: bad pulse\n");
+		printk_deferred(KERN_ERR "hardpps: PPSJITTER: bad pulse\n");
 		return;
 	}
 
diff -puN kernel/time/timekeeping.c~timekeeping-use-printk_deferred-when-holding-timekeeping-seqlock kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~timekeeping-use-printk_deferred-when-holding-timekeeping-seqlock
+++ a/kernel/time/timekeeping.c
@@ -852,8 +852,9 @@ static void __timekeeping_inject_sleepti
 							struct timespec *delta)
 {
 	if (!timespec_valid_strict(delta)) {
-		printk(KERN_WARNING "__timekeeping_inject_sleeptime: Invalid "
-					"sleep delta value!\n");
+		printk_deferred(KERN_WARNING
+				"__timekeeping_inject_sleeptime: Invalid "
+				"sleep delta value!\n");
 		return;
 	}
 	tk_xtime_add(tk, delta);
@@ -1157,7 +1158,7 @@ static void timekeeping_adjust(struct ti
 
 	if (unlikely(tk->clock->maxadj &&
 		(tk->mult + adj > tk->clock->mult + tk->clock->maxadj))) {
-		printk_once(KERN_WARNING
+		printk_once_deferred(KERN_WARNING
 			"Adjusting %s more than 11%% (%ld vs %ld)\n",
 			tk->clock->name, (long)tk->mult + adj,
 			(long)tk->clock->mult + tk->clock->maxadj);
_

Patches currently in -mm which might be from john.stultz@linaro.org are


