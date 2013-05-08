From: akpm@linux-foundation.org
Subject: [merged] wait-add-wait_event_hrtimeout.patch removed from -mm tree
Date: Wed, 08 May 2013 11:35:28 -0700
Message-ID: <20130508183528.F257F31C088@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:58614 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758176Ab3EHSfb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 14:35:31 -0400
Received: by mail-gh0-f202.google.com with SMTP id g24so195964ghb.5
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 11:35:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, mingo@elte.hu, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tglx@linutronix.de, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: wait: add wait_event_hrtimeout()
has been removed from the -mm tree.  Its filename was
     wait-add-wait_event_hrtimeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: wait: add wait_event_hrtimeout()

Analagous to wait_event_timeout() and friends, this adds
wait_event_hrtimeout() and wait_event_interruptible_hrtimeout().

Note that unlike the versions that use regular timers, these don't return
the amount of time remaining when they return - instead, they return 0 or
-ETIME if they timed out.  because I was uncomfortable with the semantics
of doing it the other way (that I could get it right, anyways).

If the timer expires, there's no real guarantee that expire_time -
current_time would be <= 0 - due to timer slack certainly, and I'm not
sure I want to know the implications of the different clock bases in
hrtimers.

If the timer does expire and the code calculates that the time remaining
is nonnegative, that could be even worse if the calling code then reuses
that timeout.  Probably safer to just return 0 then, but I could imagine
weird bugs or at least unintended behaviour arising from that too.

I came to the conclusion that if other users end up actually needing the
amount of time remaining, the sanest thing to do would be to create a
version that uses absolute timeouts instead of relative.

[akpm@linux-foundation.org: fix description of `timeout' arg]
Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Zach Brown <zab@redhat.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/wait.h |   86 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff -puN include/linux/wait.h~wait-add-wait_event_hrtimeout include/linux/wait.h
--- a/include/linux/wait.h~wait-add-wait_event_hrtimeout
+++ a/include/linux/wait.h
@@ -330,6 +330,92 @@ do {									\
 	__ret;								\
 })
 
+#define __wait_event_hrtimeout(wq, condition, timeout, state)		\
+({									\
+	int __ret = 0;							\
+	DEFINE_WAIT(__wait);						\
+	struct hrtimer_sleeper __t;					\
+									\
+	hrtimer_init_on_stack(&__t.timer, CLOCK_MONOTONIC,		\
+			      HRTIMER_MODE_REL);			\
+	hrtimer_init_sleeper(&__t, current);				\
+	if ((timeout).tv64 != KTIME_MAX)				\
+		hrtimer_start_range_ns(&__t.timer, timeout,		\
+				       current->timer_slack_ns,		\
+				       HRTIMER_MODE_REL);		\
+									\
+	for (;;) {							\
+		prepare_to_wait(&wq, &__wait, state);			\
+		if (condition)						\
+			break;						\
+		if (state == TASK_INTERRUPTIBLE &&			\
+		    signal_pending(current)) {				\
+			__ret = -ERESTARTSYS;				\
+			break;						\
+		}							\
+		if (!__t.task) {					\
+			__ret = -ETIME;					\
+			break;						\
+		}							\
+		schedule();						\
+	}								\
+									\
+	hrtimer_cancel(&__t.timer);					\
+	destroy_hrtimer_on_stack(&__t.timer);				\
+	finish_wait(&wq, &__wait);					\
+	__ret;								\
+})
+
+/**
+ * wait_event_hrtimeout - sleep until a condition gets true or a timeout elapses
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ * @timeout: timeout, as a ktime_t
+ *
+ * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
+ * @condition evaluates to true or a signal is received.
+ * The @condition is checked each time the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * The function returns 0 if @condition became true, or -ETIME if the timeout
+ * elapsed.
+ */
+#define wait_event_hrtimeout(wq, condition, timeout)			\
+({									\
+	int __ret = 0;							\
+	if (!(condition))						\
+		__ret = __wait_event_hrtimeout(wq, condition, timeout,	\
+					       TASK_UNINTERRUPTIBLE);	\
+	__ret;								\
+})
+
+/**
+ * wait_event_interruptible_hrtimeout - sleep until a condition gets true or a timeout elapses
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ * @timeout: timeout, as a ktime_t
+ *
+ * The process is put to sleep (TASK_INTERRUPTIBLE) until the
+ * @condition evaluates to true or a signal is received.
+ * The @condition is checked each time the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * The function returns 0 if @condition became true, -ERESTARTSYS if it was
+ * interrupted by a signal, or -ETIME if the timeout elapsed.
+ */
+#define wait_event_interruptible_hrtimeout(wq, condition, timeout)	\
+({									\
+	long __ret = 0;							\
+	if (!(condition))						\
+		__ret = __wait_event_hrtimeout(wq, condition, timeout,	\
+					       TASK_INTERRUPTIBLE);	\
+	__ret;								\
+})
+
 #define __wait_event_interruptible_exclusive(wq, condition, ret)	\
 do {									\
 	DEFINE_WAIT(__wait);						\
_

Patches currently in -mm which might be from koverstreet@google.com are

origin.patch
linux-next.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
block-prep-work-for-batch-completion.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

