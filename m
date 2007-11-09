From: akpm@linux-foundation.org
Subject: + crisv10-improve-and-bugfix-fasttimer.patch added to -mm tree
Date: Fri, 09 Nov 2007 15:19:37 -0800
Message-ID: <200711092319.lA9NJbfL004296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44617 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759778AbXKIXTn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 18:19:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, mikael.starvik@axis.com


The patch titled
     CRISv10 improve and bugfix fasttimer
has been added to the -mm tree.  Its filename is
     crisv10-improve-and-bugfix-fasttimer.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CRISv10 improve and bugfix fasttimer
From: Jesper Nilsson <jesper.nilsson@axis.com>

Improve and bugfix CRIS v10 fast timers.

- irq_handler_t now only takes two arguments.
- Keep interrupts disabled as long as we have a reference to the
  fasttimer list and only enable them while doing the callback.
  del_fast_timer may be called from other interrupt context.
- Fix bug where debug code could return without calling local_irq_restore.
- Use jiffies instead of usec (change from struct timeval to fasttime_t).
- Don't initialize static variables to zero.
- Remove obsolete #ifndef DECLARE_WAITQUEUE code.
- fast_timer_init should be __initcall.
- Change status/debug variables to unsigned.
- Remove CVS log and CVS id.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/kernel/fasttimer.c |  315 ++++++++----------------
 include/asm-cris/fasttimer.h          |   16 -
 2 files changed, 124 insertions(+), 207 deletions(-)

diff -puN arch/cris/arch-v10/kernel/fasttimer.c~crisv10-improve-and-bugfix-fasttimer arch/cris/arch-v10/kernel/fasttimer.c
--- a/arch/cris/arch-v10/kernel/fasttimer.c~crisv10-improve-and-bugfix-fasttimer
+++ a/arch/cris/arch-v10/kernel/fasttimer.c
@@ -1,97 +1,9 @@
-/* $Id: fasttimer.c,v 1.9 2005/03/04 08:16:16 starvik Exp $
+/*
  * linux/arch/cris/kernel/fasttimer.c
  *
  * Fast timers for ETRAX100/ETRAX100LX
- * This may be useful in other OS than Linux so use 2 space indentation...
  *
- * $Log: fasttimer.c,v $
- * Revision 1.9  2005/03/04 08:16:16  starvik
- * Merge of Linux 2.6.11.
- *
- * Revision 1.8  2005/01/05 06:09:29  starvik
- * cli()/sti() will be obsolete in 2.6.11.
- *
- * Revision 1.7  2005/01/03 13:35:46  starvik
- * Removed obsolete stuff.
- * Mark fast timer IRQ as not shared.
- *
- * Revision 1.6  2004/05/14 10:18:39  starvik
- * Export fast_timer_list
- *
- * Revision 1.5  2004/05/14 07:58:01  starvik
- * Merge of changes from 2.4
- *
- * Revision 1.4  2003/07/04 08:27:41  starvik
- * Merge of Linux 2.5.74
- *
- * Revision 1.3  2002/12/12 08:26:32  starvik
- * Don't use C-comments inside CVS comments
- *
- * Revision 1.2  2002/12/11 15:42:02  starvik
- * Extracted v10 (ETRAX 100LX) specific stuff from arch/cris/kernel/
- *
- * Revision 1.1  2002/11/18 07:58:06  starvik
- * Fast timers (from Linux 2.4)
- *
- * Revision 1.5  2002/10/15 06:21:39  starvik
- * Added call to init_waitqueue_head
- *
- * Revision 1.4  2002/05/28 17:47:59  johana
- * Added del_fast_timer()
- *
- * Revision 1.3  2002/05/28 16:16:07  johana
- * Handle empty fast_timer_list
- *
- * Revision 1.2  2002/05/27 15:38:42  johana
- * Made it compile without warnings on Linux 2.4.
- * (includes, wait_queue, PROC_FS and snprintf)
- *
- * Revision 1.1  2002/05/27 15:32:25  johana
- * arch/etrax100/kernel/fasttimer.c v1.8 from the elinux tree.
- *
- * Revision 1.8  2001/11/27 13:50:40  pkj
- * Disable interrupts while stopping the timer and while modifying the
- * list of active timers in timer1_handler() as it may be interrupted
- * by other interrupts (e.g., the serial interrupt) which may add fast
- * timers.
- *
- * Revision 1.7  2001/11/22 11:50:32  pkj
- * * Only store information about the last 16 timers.
- * * proc_fasttimer_read() now uses an allocated buffer, since it
- *   requires more space than just a page even for only writing the
- *   last 16 timers. The buffer is only allocated on request, so
- *   unless /proc/fasttimer is read, it is never allocated.
- * * Renamed fast_timer_started to fast_timers_started to match
- *   fast_timers_added and fast_timers_expired.
- * * Some clean-up.
- *
- * Revision 1.6  2000/12/13 14:02:08  johana
- * Removed volatile for fast_timer_list
- *
- * Revision 1.5  2000/12/13 13:55:35  johana
- * Added DEBUG_LOG, added som cli() and cleanup
- *
- * Revision 1.4  2000/12/05 13:48:50  johana
- * Added range check when writing proc file, modified timer int handling
- *
- * Revision 1.3  2000/11/23 10:10:20  johana
- * More debug/logging possibilities.
- * Moved GET_JIFFIES_USEC() to timex.h and time.c
- *
- * Revision 1.2  2000/11/01 13:41:04  johana
- * Clean up and bugfixes.
- * Created new do_gettimeofday_fast() that gets a timeval struct
- * with time based on jiffies and *R_TIMER0_DATA, uses a table
- * for fast conversion of timer value to microseconds.
- * (Much faster the standard do_gettimeofday() and we don't really
- * want to use the true time - we want the "uptime" so timers don't screw up
- * when we change the time.
- * TODO: Add efficient support for continuous timers as well.
- *
- * Revision 1.1  2000/10/26 15:49:16  johana
- * Added fasttimer, highresolution timers.
- *
- * Copyright (C) 2000,2001 2002 Axis Communications AB, Lund, Sweden
+ * Copyright (C) 2000-2007 Axis Communications AB, Lund, Sweden
  */
 
 #include <linux/errno.h>
@@ -125,7 +37,7 @@
 
 #ifdef FAST_TIMER_SANITY_CHECKS
 #define SANITYCHECK(x) x
-static int sanity_failed = 0;
+static int sanity_failed;
 #else
 #define SANITYCHECK(x)
 #endif
@@ -136,13 +48,13 @@ static int sanity_failed = 0;
 
 #define __INLINE__ inline
 
-static int fast_timer_running = 0;
-static int fast_timers_added = 0;
-static int fast_timers_started = 0;
-static int fast_timers_expired = 0;
-static int fast_timers_deleted = 0;
-static int fast_timer_is_init = 0;
-static int fast_timer_ints = 0;
+static unsigned int fast_timer_running;
+static unsigned int fast_timers_added;
+static unsigned int fast_timers_started;
+static unsigned int fast_timers_expired;
+static unsigned int fast_timers_deleted;
+static unsigned int fast_timer_is_init;
+static unsigned int fast_timer_ints;
 
 struct fast_timer *fast_timer_list = NULL;
 
@@ -150,8 +62,8 @@ struct fast_timer *fast_timer_list = NUL
 #define DEBUG_LOG_MAX 128
 static const char * debug_log_string[DEBUG_LOG_MAX];
 static unsigned long debug_log_value[DEBUG_LOG_MAX];
-static int debug_log_cnt = 0;
-static int debug_log_cnt_wrapped = 0;
+static unsigned int debug_log_cnt;
+static unsigned int debug_log_cnt_wrapped;
 
 #define DEBUG_LOG(string, value) \
 { \
@@ -206,42 +118,26 @@ int timer_freq_settings[NUM_TIMER_STATS]
 int timer_delay_settings[NUM_TIMER_STATS];
 
 /* Not true gettimeofday, only checks the jiffies (uptime) + useconds */
-void __INLINE__ do_gettimeofday_fast(struct timeval *tv)
+void __INLINE__ do_gettimeofday_fast(struct fasttime_t *tv)
 {
-  unsigned long sec = jiffies;
-  unsigned long usec = GET_JIFFIES_USEC();
-
-  usec += (sec % HZ) * (1000000 / HZ);
-  sec = sec / HZ;
-
-  if (usec > 1000000)
-  {
-    usec -= 1000000;
-    sec++;
-  }
-  tv->tv_sec = sec;
-  tv->tv_usec = usec;
+	tv->tv_jiff = jiffies;
+	tv->tv_usec = GET_JIFFIES_USEC();
 }
 
-int __INLINE__ timeval_cmp(struct timeval *t0, struct timeval *t1)
+int __INLINE__ timeval_cmp(struct fasttime_t *t0, struct fasttime_t *t1)
 {
-  if (t0->tv_sec < t1->tv_sec)
-  {
-    return -1;
-  }
-  else if (t0->tv_sec > t1->tv_sec)
-  {
-    return 1;
-  }
-  if (t0->tv_usec < t1->tv_usec)
-  {
-    return -1;
-  }
-  else if (t0->tv_usec > t1->tv_usec)
-  {
-    return 1;
-  }
-  return 0;
+	/* Compare jiffies. Takes care of wrapping */
+	if (time_before(t0->tv_jiff, t1->tv_jiff))
+		return -1;
+	else if (time_after(t0->tv_jiff, t1->tv_jiff))
+		return 1;
+
+	/* Compare us */
+	if (t0->tv_usec < t1->tv_usec)
+		return -1;
+	else if (t0->tv_usec > t1->tv_usec)
+		return 1;
+	return 0;
 }
 
 void __INLINE__ start_timer1(unsigned long delay_us)
@@ -285,7 +181,7 @@ void __INLINE__ start_timer1(unsigned lo
   timer_freq_settings[fast_timers_started % NUM_TIMER_STATS] = freq_index;
   timer_delay_settings[fast_timers_started % NUM_TIMER_STATS] = delay_us;
 
-  D1(printk("start_timer1 : %d us freq: %i div: %i\n",
+	D1(printk(KERN_DEBUG "start_timer1 : %d us freq: %i div: %i\n",
             delay_us, freq_index, div));
   /* Clear timer1 irq */
   *R_IRQ_MASK0_CLR = IO_STATE(R_IRQ_MASK0_CLR, timer1, clr);
@@ -340,7 +236,7 @@ void start_one_shot_timer(struct fast_ti
         printk(KERN_WARNING
                "timer name: %s data: 0x%08lX already in list!\n", name, data);
         sanity_failed++;
-        return;
+				goto done;
       }
       else
       {
@@ -356,11 +252,11 @@ void start_one_shot_timer(struct fast_ti
   t->name = name;
 
   t->tv_expires.tv_usec = t->tv_set.tv_usec + delay_us % 1000000;
-  t->tv_expires.tv_sec  = t->tv_set.tv_sec  + delay_us / 1000000;
+	t->tv_expires.tv_jiff = t->tv_set.tv_jiff + delay_us / 1000000 / HZ;
   if (t->tv_expires.tv_usec > 1000000)
   {
     t->tv_expires.tv_usec -= 1000000;
-    t->tv_expires.tv_sec++;
+		t->tv_expires.tv_jiff += HZ;
   }
 #ifdef FAST_TIMER_LOG
   timer_added_log[fast_timers_added % NUM_TIMER_STATS] = *t;
@@ -401,6 +297,7 @@ void start_one_shot_timer(struct fast_ti
 
   D2(printk("start_one_shot_timer: %d us done\n", delay_us));
 
+done:
   local_irq_restore(flags);
 } /* start_one_shot_timer */
 
@@ -444,11 +341,18 @@ int del_fast_timer(struct fast_timer * t
 /* Timer 1 interrupt handler */
 
 static irqreturn_t
-timer1_handler(int irq, void *dev_id, struct pt_regs *regs)
+timer1_handler(int irq, void *dev_id)
 {
   struct fast_timer *t;
   unsigned long flags;
 
+	/* We keep interrupts disabled not only when we modify the
+	 * fast timer list, but any time we hold a reference to a
+	 * timer in the list, since del_fast_timer may be called
+	 * from (another) interrupt context.  Thus, the only time
+	 * when interrupts are enabled is when calling the timer
+	 * callback function.
+	 */
   local_irq_save(flags);
 
   /* Clear timer1 irq */
@@ -466,16 +370,17 @@ timer1_handler(int irq, void *dev_id, st
   fast_timer_running = 0;
   fast_timer_ints++;
 
-  local_irq_restore(flags);
-
   t = fast_timer_list;
   while (t)
   {
-    struct timeval tv;
+		struct fasttime_t tv;
+		fast_timer_function_type *f;
+		unsigned long d;
 
     /* Has it really expired? */
     do_gettimeofday_fast(&tv);
-    D1(printk("t: %is %06ius\n", tv.tv_sec, tv.tv_usec));
+		D1(printk(KERN_DEBUG "t: %is %06ius\n",
+			tv.tv_jiff, tv.tv_usec));
 
     if (timeval_cmp(&t->tv_expires, &tv) <= 0)
     {
@@ -486,7 +391,6 @@ timer1_handler(int irq, void *dev_id, st
       fast_timers_expired++;
 
       /* Remove this timer before call, since it may reuse the timer */
-      local_irq_save(flags);
       if (t->prev)
       {
         t->prev->next = t->next;
@@ -501,16 +405,23 @@ timer1_handler(int irq, void *dev_id, st
       }
       t->prev = NULL;
       t->next = NULL;
-      local_irq_restore(flags);
 
-      if (t->function != NULL)
-      {
-        t->function(t->data);
-      }
-      else
-      {
+			/* Save function callback data before enabling
+			 * interrupts, since the timer may be removed and
+			 * we don't know how it was allocated
+			 * (e.g. ->function and ->data may become overwritten
+			 * after deletion if the timer was stack-allocated).
+			 */
+			f = t->function;
+			d = t->data;
+
+			if (f != NULL) {
+				/* Run callback with interrupts enabled. */
+				local_irq_restore(flags);
+				f(d);
+				local_irq_save(flags);
+			} else
         DEBUG_LOG("!timer1 %i function==NULL!\n", fast_timer_ints);
-      }
     }
     else
     {
@@ -518,16 +429,20 @@ timer1_handler(int irq, void *dev_id, st
       D1(printk(".\n"));
     }
 
-    local_irq_save(flags);
     if ((t = fast_timer_list) != NULL)
     {
       /* Start next timer.. */
-      long us;
-      struct timeval tv;
+			long us = 0;
+			struct fasttime_t tv;
 
       do_gettimeofday_fast(&tv);
-      us = ((t->tv_expires.tv_sec - tv.tv_sec) * 1000000 +
-            t->tv_expires.tv_usec - tv.tv_usec);
+
+			/* time_after_eq takes care of wrapping */
+			if (time_after_eq(t->tv_expires.tv_jiff, tv.tv_jiff))
+				us = ((t->tv_expires.tv_jiff - tv.tv_jiff) *
+					1000000 / HZ + t->tv_expires.tv_usec -
+					tv.tv_usec);
+
       if (us > 0)
       {
         if (!fast_timer_running)
@@ -537,7 +452,6 @@ timer1_handler(int irq, void *dev_id, st
 #endif
           start_timer1(us);
         }
-        local_irq_restore(flags);
         break;
       }
       else
@@ -548,9 +462,10 @@ timer1_handler(int irq, void *dev_id, st
         D1(printk("e! %d\n", us));
       }
     }
-    local_irq_restore(flags);
   }
 
+	local_irq_restore(flags);
+
   if (!t)
   {
     D1(printk("t1 stop!\n"));
@@ -575,28 +490,17 @@ static void wake_up_func(unsigned long d
 void schedule_usleep(unsigned long us)
 {
   struct fast_timer t;
-#ifdef DECLARE_WAITQUEUE
   wait_queue_head_t sleep_wait;
   init_waitqueue_head(&sleep_wait);
-  {
-  DECLARE_WAITQUEUE(wait, current);
-#else
-  struct wait_queue *sleep_wait = NULL;
-  struct wait_queue wait = { current, NULL };
-#endif
 
   D1(printk("schedule_usleep(%d)\n", us));
-  add_wait_queue(&sleep_wait, &wait);
-  set_current_state(TASK_INTERRUPTIBLE);
   start_one_shot_timer(&t, wake_up_func, (unsigned long)&sleep_wait, us,
                        "usleep");
-  schedule();
-  set_current_state(TASK_RUNNING);
-  remove_wait_queue(&sleep_wait, &wait);
+	/* Uninterruptible sleep on the fast timer. (The condition is somewhat
+	 * redundant since the timer is what wakes us up.) */
+	wait_event(sleep_wait, !fast_timer_pending(&t));
+
   D1(printk("done schedule_usleep(%d)\n", us));
-#ifdef DECLARE_WAITQUEUE
-  }
-#endif  
 }
 
 #ifdef CONFIG_PROC_FS
@@ -616,7 +520,7 @@ static int proc_fasttimer_read(char *buf
   unsigned long flags;
   int i = 0;
   int num_to_show;
-  struct timeval tv;
+	struct fasttime_t tv;
   struct fast_timer *t, *nextt;
   static char *bigbuf = NULL;
   static unsigned long used;
@@ -624,7 +528,8 @@ static int proc_fasttimer_read(char *buf
   if (!bigbuf && !(bigbuf = vmalloc(BIG_BUF_SIZE)))
   {
     used = 0;
-    bigbuf[0] = '\0';
+	if (buf)
+		buf[0] = '\0';
     return 0;
   }
 
@@ -646,7 +551,7 @@ static int proc_fasttimer_read(char *buf
     used += sprintf(bigbuf + used, "Fast timer running:    %s\n",
                     fast_timer_running ? "yes" : "no");
     used += sprintf(bigbuf + used, "Current time:          %lu.%06lu\n",
-                    (unsigned long)tv.tv_sec,
+			(unsigned long)tv.tv_jiff,
                     (unsigned long)tv.tv_usec);
 #ifdef FAST_TIMER_SANITY_CHECKS
     used += sprintf(bigbuf + used, "Sanity failed:         %i\n",
@@ -696,9 +601,9 @@ static int proc_fasttimer_read(char *buf
                       "d: %6li us data: 0x%08lX"
                       "\n",
                       t->name,
-                      (unsigned long)t->tv_set.tv_sec,
+			(unsigned long)t->tv_set.tv_jiff,
                       (unsigned long)t->tv_set.tv_usec,
-                      (unsigned long)t->tv_expires.tv_sec,
+			(unsigned long)t->tv_expires.tv_jiff,
                       (unsigned long)t->tv_expires.tv_usec,
                       t->delay_us,
                       t->data
@@ -718,9 +623,9 @@ static int proc_fasttimer_read(char *buf
                       "d: %6li us data: 0x%08lX"
                       "\n",
                       t->name,
-                      (unsigned long)t->tv_set.tv_sec,
+			(unsigned long)t->tv_set.tv_jiff,
                       (unsigned long)t->tv_set.tv_usec,
-                      (unsigned long)t->tv_expires.tv_sec,
+			(unsigned long)t->tv_expires.tv_jiff,
                       (unsigned long)t->tv_expires.tv_usec,
                       t->delay_us,
                       t->data
@@ -738,9 +643,9 @@ static int proc_fasttimer_read(char *buf
                       "d: %6li us data: 0x%08lX"
                       "\n",
                       t->name,
-                      (unsigned long)t->tv_set.tv_sec,
+			(unsigned long)t->tv_set.tv_jiff,
                       (unsigned long)t->tv_set.tv_usec,
-                      (unsigned long)t->tv_expires.tv_sec,
+			(unsigned long)t->tv_expires.tv_jiff,
                       (unsigned long)t->tv_expires.tv_usec,
                       t->delay_us,
                       t->data
@@ -761,15 +666,15 @@ static int proc_fasttimer_read(char *buf
 /*                      " func: 0x%08lX" */
                       "\n",
                       t->name,
-                      (unsigned long)t->tv_set.tv_sec,
+			(unsigned long)t->tv_set.tv_jiff,
                       (unsigned long)t->tv_set.tv_usec,
-                      (unsigned long)t->tv_expires.tv_sec,
+			(unsigned long)t->tv_expires.tv_jiff,
                       (unsigned long)t->tv_expires.tv_usec,
                       t->delay_us,
                       t->data
 /*                      , t->function */
                       );
-      local_irq_disable();
+	local_irq_save(flags);
       if (t->next != nextt)
       {
         printk(KERN_WARNING "timer removed!\n");
@@ -798,7 +703,7 @@ static volatile int num_test_timeout = 0
 static struct fast_timer tr[10];
 static int exp_num[10];
 
-static struct timeval tv_exp[100];
+static struct fasttime_t tv_exp[100];
 
 static void test_timeout(unsigned long data)
 {
@@ -836,7 +741,7 @@ static void fast_timer_test(void)
   int prev_num;
   int j;
 
-  struct timeval tv, tv0, tv1, tv2;
+	struct fasttime_t tv, tv0, tv1, tv2;
 
   printk("fast_timer_test() start\n");
   do_gettimeofday_fast(&tv);
@@ -849,7 +754,8 @@ static void fast_timer_test(void)
   {
     do_gettimeofday_fast(&tv_exp[j]);
   }
-  printk("fast_timer_test() %is %06i\n", tv.tv_sec, tv.tv_usec);
+	printk(KERN_DEBUG "fast_timer_test() %is %06i\n",
+		tv.tv_jiff, tv.tv_usec);
 
   for (j = 0; j < 1000; j++)
   {
@@ -858,12 +764,12 @@ static void fast_timer_test(void)
   }
   for (j = 0; j < 100; j++)
   {
-    printk("%i.%i %i.%i %i.%i %i.%i %i.%i\n",
-           tv_exp[j].tv_sec,tv_exp[j].tv_usec,
-           tv_exp[j+1].tv_sec,tv_exp[j+1].tv_usec,
-           tv_exp[j+2].tv_sec,tv_exp[j+2].tv_usec,
-           tv_exp[j+3].tv_sec,tv_exp[j+3].tv_usec,
-           tv_exp[j+4].tv_sec,tv_exp[j+4].tv_usec);
+		printk(KERN_DEBUG "%i.%i %i.%i %i.%i %i.%i %i.%i\n",
+			tv_exp[j].tv_jiff, tv_exp[j].tv_usec,
+			tv_exp[j+1].tv_jiff, tv_exp[j+1].tv_usec,
+			tv_exp[j+2].tv_jiff, tv_exp[j+2].tv_usec,
+			tv_exp[j+3].tv_jiff, tv_exp[j+3].tv_usec,
+			tv_exp[j+4].tv_jiff, tv_exp[j+4].tv_usec);
     j += 4;
   }
   do_gettimeofday_fast(&tv0);
@@ -895,9 +801,12 @@ static void fast_timer_test(void)
     }
   }
   do_gettimeofday_fast(&tv2);
-  printk("Timers started    %is %06i\n", tv0.tv_sec, tv0.tv_usec);
-  printk("Timers started at %is %06i\n", tv1.tv_sec, tv1.tv_usec);
-  printk("Timers done       %is %06i\n", tv2.tv_sec, tv2.tv_usec);
+	printk(KERN_DEBUG "Timers started    %is %06i\n",
+		tv0.tv_jiff, tv0.tv_usec);
+	printk(KERN_DEBUG "Timers started at %is %06i\n",
+		tv1.tv_jiff, tv1.tv_usec);
+	printk(KERN_DEBUG "Timers done       %is %06i\n",
+		tv2.tv_jiff, tv2.tv_usec);
   DP(printk("buf0:\n");
      printk(buf0);
      printk("buf1:\n");
@@ -919,9 +828,9 @@ static void fast_timer_test(void)
     printk("%-10s set: %6is %06ius exp: %6is %06ius "
            "data: 0x%08X func: 0x%08X\n",
            t->name,
-           t->tv_set.tv_sec,
+			t->tv_set.tv_jiff,
            t->tv_set.tv_usec,
-           t->tv_expires.tv_sec,
+			t->tv_expires.tv_jiff,
            t->tv_expires.tv_usec,
            t->data,
            t->function
@@ -929,10 +838,12 @@ static void fast_timer_test(void)
 
     printk("           del: %6ius     did exp: %6is %06ius as #%i error: %6li\n",
            t->delay_us,
-           tv_exp[j].tv_sec,
+			tv_exp[j].tv_jiff,
            tv_exp[j].tv_usec,
            exp_num[j],
-           (tv_exp[j].tv_sec - t->tv_expires.tv_sec)*1000000 + tv_exp[j].tv_usec - t->tv_expires.tv_usec);
+			(tv_exp[j].tv_jiff - t->tv_expires.tv_jiff) *
+				1000000 + tv_exp[j].tv_usec -
+				t->tv_expires.tv_usec);
   }
   proc_fasttimer_read(buf5, NULL, 0, 0, 0);
   printk("buf5 after all done:\n");
@@ -942,7 +853,7 @@ static void fast_timer_test(void)
 #endif
 
 
-void fast_timer_init(void)
+int fast_timer_init(void)
 {
   /* For some reason, request_irq() hangs when called froom time_init() */
   if (!fast_timer_is_init)
@@ -975,4 +886,6 @@ void fast_timer_init(void)
     fast_timer_test();
 #endif
   }
+	return 0;
 }
+__initcall(fast_timer_init);
diff -puN include/asm-cris/fasttimer.h~crisv10-improve-and-bugfix-fasttimer include/asm-cris/fasttimer.h
--- a/include/asm-cris/fasttimer.h~crisv10-improve-and-bugfix-fasttimer
+++ a/include/asm-cris/fasttimer.h
@@ -1,9 +1,8 @@
-/* $Id: fasttimer.h,v 1.3 2004/05/14 10:19:19 starvik Exp $
+/*
  * linux/include/asm-cris/fasttimer.h
  *
  * Fast timers for ETRAX100LX
- * This may be useful in other OS than Linux so use 2 space indentation...
- * Copyright (C) 2000, 2002 Axis Communications AB
+ * Copyright (C) 2000-2007 Axis Communications AB
  */
 #include <linux/time.h> /* struct timeval */
 #include <linux/timex.h>
@@ -12,11 +11,16 @@
 
 typedef void fast_timer_function_type(unsigned long);
 
+struct fasttime_t {
+	unsigned long tv_jiff;  /* jiffies */
+	unsigned long tv_usec;  /* microseconds */
+};
+
 struct fast_timer{ /* Close to timer_list */
   struct fast_timer *next;
   struct fast_timer *prev;
-  struct timeval tv_set;
-  struct timeval tv_expires;
+	struct fasttime_t tv_set;
+	struct fasttime_t tv_expires;
   unsigned long delay_us;
   fast_timer_function_type *function;
   unsigned long data;
@@ -38,6 +42,6 @@ int del_fast_timer(struct fast_timer * t
 void schedule_usleep(unsigned long us);
 
 
-void fast_timer_init(void);
+int fast_timer_init(void);
 
 #endif
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

git-mtd.patch
cris-build-fixes-fix-csum_tcpudp_magic-declaration.patch
cris-build-fixes-add-missing-syscalls.patch
cris-build-fixes-hardirqh-include-asm-irqh.patch
cris-build-fixes-atomich-needs-compilerh.patch
cris-build-fixes-atomich-needs-compilerh-fix.patch
cris-build-fixes-irq-fixes.patch
cris-build-fixes-sys_crisc-needs-fsh.patch
cris-build-fixes-add-baud-rate-defines.patch
cris-build-fixes-update-eth_v10c-ethernet-driver.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
cris-build-fixes-corrected-and-improved-nmi-and-irq-handling.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec-checkpatch-fixes.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec.patch
cris-build-fixes-setupc-needs-paramh.patch
cris-build-fixes-fix-crisksymsc.patch
cris-build-fixes-defconfig-updates.patch
cris-dont-include-bitopsh-in-posix_typesh.patch
crisv10-serial-driver-rewrite-take-three.patch
cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two.patch
cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two-checkpatch-fixes.patch
crisv10-fix-timer-interrupt-parameters.patch
crisv10-improve-and-bugfix-fasttimer.patch
