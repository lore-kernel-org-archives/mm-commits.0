From: akpm@linux-foundation.org
Subject: [merged]
 timer-convert-timer_slack_ns-from-unsigned-long-to-u64.patch removed from
 -mm tree
Date: Mon, 21 Mar 2016 11:40:48 -0700
Message-ID: <56f04030.LG1yPl8c2bxguls5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650AbcCUT4O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: john.stultz@linaro.org, arjan@linux.intel.com, kandoiruchi@google.com, keescook@chromium.org, kernel-team@android.com, orenl@cellrox.com, romlem@android.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: timer: convert timer_slack_ns from unsigned long to u64
has been removed from the -mm tree.  Its filename was
     timer-convert-timer_slack_ns-from-unsigned-long-to-u64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Stultz <john.stultz@linaro.org>
Subject: timer: convert timer_slack_ns from unsigned long to u64

This patchset introduces a /proc/<pid>/timerslack_ns interface which would
allow controlling processes to be able to set the timerslack value on
other processes in order to save power by avoiding wakeups (Something
Android currently does via out-of-tree patches).

The first patch tries to fix the internal timer_slack_ns usage which was
defined as a long, which limits the slack range to ~4 seconds on 32bit
systems.  It converts it to a u64, which provides the same basically
unlimited slack (500 years) on both 32bit and 64bit machines.

The second patch introduces the /proc/<pid>/timerslack_ns interface which
allows the full 64bit slack range for a task to be read or set on both
32bit and 64bit machines.

With these two patches, on a 32bit machine, after setting the slack on
bash to 10 seconds:

$ time sleep 1

real    0m10.747s
user    0m0.001s
sys     0m0.005s


The first patch is a little ugly, since I had to chase the slack delta
arguments through a number of functions converting them to u64s.  Let me
know if it makes sense to break that up more or not.

Other than that things are fairly straightforward.



This patch (of 2):

The timer_slack_ns value in the task struct is currently a unsigned long. 
This means that on 32bit applications, the maximum slack is just over 4
seconds.  However, on 64bit machines, its much much larger (~500 years).

This disparity could make application development a little (as well as the
default_slack) to a u64.  This means both 32bit and 64bit systems have the
same effective internal slack range.

Now the existing ABI via PR_GET_TIMERSLACK and PR_SET_TIMERSLACK specify
the interface as a unsigned long, so we preserve that limitation on 32bit
systems, where SET_TIMERSLACK can only set the slack to a unsigned long
value, and GET_TIMERSLACK will return ULONG_MAX if the slack is actually
larger then what can be stored by an unsigned long.

This patch also modifies hrtimer functions which specified the slack delta
as a unsigned long.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Oren Laadan <orenl@cellrox.com>
Cc: Ruchi Kandoi <kandoiruchi@google.com>
Cc: Rom Lemarchand <romlem@android.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c          |    2 +-
 fs/select.c             |    8 ++++----
 include/linux/freezer.h |    2 +-
 include/linux/hrtimer.h |   12 +++++++-----
 include/linux/poll.h    |    2 +-
 include/linux/sched.h   |    4 ++--
 kernel/sys.c            |    5 ++++-
 kernel/time/hrtimer.c   |    8 ++++----
 kernel/time/timer.c     |    4 ++--
 9 files changed, 26 insertions(+), 21 deletions(-)

diff -puN fs/eventpoll.c~timer-convert-timer_slack_ns-from-unsigned-long-to-u64 fs/eventpoll.c
--- a/fs/eventpoll.c~timer-convert-timer_slack_ns-from-unsigned-long-to-u64
+++ a/fs/eventpoll.c
@@ -1616,7 +1616,7 @@ static int ep_poll(struct eventpoll *ep,
 {
 	int res = 0, eavail, timed_out = 0;
 	unsigned long flags;
-	long slack = 0;
+	u64 slack = 0;
 	wait_queue_t wait;
 	ktime_t expires, *to = NULL;
 
diff -puN fs/select.c~timer-convert-timer_slack_ns-from-unsigned-long-to-u64 fs/select.c
--- a/fs/select.c~timer-convert-timer_slack_ns-from-unsigned-long-to-u64
+++ a/fs/select.c
@@ -70,9 +70,9 @@ static long __estimate_accuracy(struct t
 	return slack;
 }
 
-long select_estimate_accuracy(struct timespec *tv)
+u64 select_estimate_accuracy(struct timespec *tv)
 {
-	unsigned long ret;
+	u64 ret;
 	struct timespec now;
 
 	/*
@@ -402,7 +402,7 @@ int do_select(int n, fd_set_bits *fds, s
 	struct poll_wqueues table;
 	poll_table *wait;
 	int retval, i, timed_out = 0;
-	unsigned long slack = 0;
+	u64 slack = 0;
 	unsigned int busy_flag = net_busy_loop_on() ? POLL_BUSY_LOOP : 0;
 	unsigned long busy_end = 0;
 
@@ -784,7 +784,7 @@ static int do_poll(struct poll_list *lis
 	poll_table* pt = &wait->pt;
 	ktime_t expire, *to = NULL;
 	int timed_out = 0, count = 0;
-	unsigned long slack = 0;
+	u64 slack = 0;
 	unsigned int busy_flag = net_busy_loop_on() ? POLL_BUSY_LOOP : 0;
 	unsigned long busy_end = 0;
 
diff -puN include/linux/freezer.h~timer-convert-timer_slack_ns-from-unsigned-long-to-u64 include/linux/freezer.h
--- a/include/linux/freezer.h~timer-convert-timer_slack_ns-from-unsigned-long-to-u64
+++ a/include/linux/freezer.h
@@ -231,7 +231,7 @@ static inline long freezable_schedule_ti
  * call this with locks held.
  */
 static inline int freezable_schedule_hrtimeout_range(ktime_t *expires,
-		unsigned long delta, const enum hrtimer_mode mode)
+		u64 delta, const enum hrtimer_mode mode)
 {
 	int __retval;
 	freezer_do_not_count();
diff -puN include/linux/hrtimer.h~timer-convert-timer_slack_ns-from-unsigned-long-to-u64 include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~timer-convert-timer_slack_ns-from-unsigned-long-to-u64
+++ a/include/linux/hrtimer.h
@@ -220,7 +220,7 @@ static inline void hrtimer_set_expires_r
 	timer->node.expires = ktime_add_safe(time, delta);
 }
 
-static inline void hrtimer_set_expires_range_ns(struct hrtimer *timer, ktime_t time, unsigned long delta)
+static inline void hrtimer_set_expires_range_ns(struct hrtimer *timer, ktime_t time, u64 delta)
 {
 	timer->_softexpires = time;
 	timer->node.expires = ktime_add_safe(time, ns_to_ktime(delta));
@@ -378,7 +378,7 @@ static inline void destroy_hrtimer_on_st
 
 /* Basic timer operations: */
 extern void hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
-			unsigned long range_ns, const enum hrtimer_mode mode);
+				   u64 range_ns, const enum hrtimer_mode mode);
 
 /**
  * hrtimer_start - (re)start an hrtimer on the current CPU
@@ -399,7 +399,7 @@ extern int hrtimer_try_to_cancel(struct
 static inline void hrtimer_start_expires(struct hrtimer *timer,
 					 enum hrtimer_mode mode)
 {
-	unsigned long delta;
+	u64 delta;
 	ktime_t soft, hard;
 	soft = hrtimer_get_softexpires(timer);
 	hard = hrtimer_get_expires(timer);
@@ -477,10 +477,12 @@ extern long hrtimer_nanosleep_restart(st
 extern void hrtimer_init_sleeper(struct hrtimer_sleeper *sl,
 				 struct task_struct *tsk);
 
-extern int schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
+extern int schedule_hrtimeout_range(ktime_t *expires, u64 delta,
 						const enum hrtimer_mode mode);
 extern int schedule_hrtimeout_range_clock(ktime_t *expires,
-		unsigned long delta, const enum hrtimer_mode mode, int clock);
+					  u64 delta,
+					  const enum hrtimer_mode mode,
+					  int clock);
 extern int schedule_hrtimeout(ktime_t *expires, const enum hrtimer_mode mode);
 
 /* Soft interrupt function to run the hrtimer queues: */
diff -puN include/linux/poll.h~timer-convert-timer_slack_ns-from-unsigned-long-to-u64 include/linux/poll.h
--- a/include/linux/poll.h~timer-convert-timer_slack_ns-from-unsigned-long-to-u64
+++ a/include/linux/poll.h
@@ -96,7 +96,7 @@ extern void poll_initwait(struct poll_wq
 extern void poll_freewait(struct poll_wqueues *pwq);
 extern int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
 				 ktime_t *expires, unsigned long slack);
-extern long select_estimate_accuracy(struct timespec *tv);
+extern u64 select_estimate_accuracy(struct timespec *tv);
 
 
 static inline int poll_schedule(struct poll_wqueues *pwq, int state)
diff -puN include/linux/sched.h~timer-convert-timer_slack_ns-from-unsigned-long-to-u64 include/linux/sched.h
--- a/include/linux/sched.h~timer-convert-timer_slack_ns-from-unsigned-long-to-u64
+++ a/include/linux/sched.h
@@ -1792,8 +1792,8 @@ struct task_struct {
 	 * time slack values; these are used to round up poll() and
 	 * select() etc timeout values. These are in nanoseconds.
 	 */
-	unsigned long timer_slack_ns;
-	unsigned long default_timer_slack_ns;
+	u64 timer_slack_ns;
+	u64 default_timer_slack_ns;
 
 #ifdef CONFIG_KASAN
 	unsigned int kasan_depth;
diff -puN kernel/sys.c~timer-convert-timer_slack_ns-from-unsigned-long-to-u64 kernel/sys.c
--- a/kernel/sys.c~timer-convert-timer_slack_ns-from-unsigned-long-to-u64
+++ a/kernel/sys.c
@@ -2169,7 +2169,10 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 		error = perf_event_task_enable();
 		break;
 	case PR_GET_TIMERSLACK:
-		error = current->timer_slack_ns;
+		if (current->timer_slack_ns > ULONG_MAX)
+			error = ULONG_MAX;
+		else
+			error = current->timer_slack_ns;
 		break;
 	case PR_SET_TIMERSLACK:
 		if (arg2 <= 0)
diff -puN kernel/time/hrtimer.c~timer-convert-timer_slack_ns-from-unsigned-long-to-u64 kernel/time/hrtimer.c
--- a/kernel/time/hrtimer.c~timer-convert-timer_slack_ns-from-unsigned-long-to-u64
+++ a/kernel/time/hrtimer.c
@@ -979,7 +979,7 @@ static inline ktime_t hrtimer_update_low
  *		relative (HRTIMER_MODE_REL)
  */
 void hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
-			    unsigned long delta_ns, const enum hrtimer_mode mode)
+			    u64 delta_ns, const enum hrtimer_mode mode)
 {
 	struct hrtimer_clock_base *base, *new_base;
 	unsigned long flags;
@@ -1548,7 +1548,7 @@ long hrtimer_nanosleep(struct timespec *
 	struct restart_block *restart;
 	struct hrtimer_sleeper t;
 	int ret = 0;
-	unsigned long slack;
+	u64 slack;
 
 	slack = current->timer_slack_ns;
 	if (dl_task(current) || rt_task(current))
@@ -1724,7 +1724,7 @@ void __init hrtimers_init(void)
  * @clock:	timer clock, CLOCK_MONOTONIC or CLOCK_REALTIME
  */
 int __sched
-schedule_hrtimeout_range_clock(ktime_t *expires, unsigned long delta,
+schedule_hrtimeout_range_clock(ktime_t *expires, u64 delta,
 			       const enum hrtimer_mode mode, int clock)
 {
 	struct hrtimer_sleeper t;
@@ -1792,7 +1792,7 @@ schedule_hrtimeout_range_clock(ktime_t *
  *
  * Returns 0 when the timer has expired otherwise -EINTR
  */
-int __sched schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
+int __sched schedule_hrtimeout_range(ktime_t *expires, u64 delta,
 				     const enum hrtimer_mode mode)
 {
 	return schedule_hrtimeout_range_clock(expires, delta, mode,
diff -puN kernel/time/timer.c~timer-convert-timer_slack_ns-from-unsigned-long-to-u64 kernel/time/timer.c
--- a/kernel/time/timer.c~timer-convert-timer_slack_ns-from-unsigned-long-to-u64
+++ a/kernel/time/timer.c
@@ -1698,10 +1698,10 @@ EXPORT_SYMBOL(msleep_interruptible);
 static void __sched do_usleep_range(unsigned long min, unsigned long max)
 {
 	ktime_t kmin;
-	unsigned long delta;
+	u64 delta;
 
 	kmin = ktime_set(0, min * NSEC_PER_USEC);
-	delta = (max - min) * NSEC_PER_USEC;
+	delta = (u64)(max - min) * NSEC_PER_USEC;
 	schedule_hrtimeout_range(&kmin, delta, HRTIMER_MODE_REL);
 }
 
_

Patches currently in -mm which might be from john.stultz@linaro.org are


