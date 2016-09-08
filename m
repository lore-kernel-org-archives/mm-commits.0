From: akpm@linux-foundation.org
Subject: +
 relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup.patch added
 to -mm tree
Date: Thu, 08 Sep 2016 16:45:04 -0700
Message-ID: <57d1f800.Yzh1taWEHEk50hoN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47553 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbcIHXpF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2016 19:45:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterz@infradead.org, akash.goel@intel.com, chris@chris-wilson.co.uk, tvrtko.ursulin@intel.com, tzanussi@gmail.com, zanussi@comcast.net, mm-commits@vger.kernel.org


The patch titled
     Subject: relay: Use irq_work instead of plain timer for deferred wakeup
has been added to the -mm tree.  Its filename is
     relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Zijlstra <peterz@infradead.org>
Subject: relay: Use irq_work instead of plain timer for deferred wakeup

Relay avoids calling wake_up_interruptible() for doing the wakeup of
readers/consumers, waiting for the generation of new data, from the
context of a process which produced the data.  This is apparently done to
prevent the possibility of a deadlock in case Scheduler itself is is
generating data for the relay, after acquiring rq->lock.

The following patch used a timer (to be scheduled at next jiffy), for
delegating the wakeup to another context.
	commit 7c9cb38302e78d24e37f7d8a2ea7eed4ae5f2fa7
	Author: Tom Zanussi <zanussi@comcast.net>
	Date:   Wed May 9 02:34:01 2007 -0700

	relay: use plain timer instead of delayed work

	relay doesn't need to use schedule_delayed_work() for waking readers
	when a simple timer will do.

Scheduling a plain timer, at next jiffies boundary, to do the wakeup
causes a significant wakeup latency for the Userspace client, which makes
relay less suitable for the high-frequency low-payload use cases where the
data gets generated at a very high rate, like multiple sub buffers getting
filled within a milli second.  Moreover the timer is re-scheduled on every
newly produced sub buffer so the timer keeps getting pushed out if sub
buffers are filled in a very quick succession (less than a jiffy gap
between filling of 2 sub buffers).  As a result relay runs out of sub
buffers to store the new data.

By using irq_work it is ensured that wakeup of userspace client, blocked
in the poll call, is done at earliest (through self IPI or next timer
tick) enabling it to always consume the data in time.  Also this makes
relay consistent with printk & ring buffers (trace), as they too use
irq_work for deferred wake up of readers.

Link: http://lkml.kernel.org/r/1472906487-1559-1-git-send-email-akash.goel@intel.com
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Akash Goel <akash.goel@intel.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/relay.h |    3 ++-
 kernel/relay.c        |   22 ++++++++++++----------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff -puN include/linux/relay.h~relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup include/linux/relay.h
--- a/include/linux/relay.h~relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup
+++ a/include/linux/relay.h
@@ -19,6 +19,7 @@
 #include <linux/fs.h>
 #include <linux/poll.h>
 #include <linux/kref.h>
+#include <linux/irq_work.h>
 
 /*
  * Tracks changes to rchan/rchan_buf structs
@@ -37,7 +38,7 @@ struct rchan_buf
 	size_t subbufs_consumed;	/* count of sub-buffers consumed */
 	struct rchan *chan;		/* associated channel */
 	wait_queue_head_t read_wait;	/* reader wait queue */
-	struct timer_list timer; 	/* reader wake-up timer */
+	struct irq_work wakeup_work;	/* reader wakeup */
 	struct dentry *dentry;		/* channel file dentry */
 	struct kref kref;		/* channel buffer refcount */
 	struct page **page_array;	/* array of current buffer pages */
diff -puN kernel/relay.c~relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup kernel/relay.c
--- a/kernel/relay.c~relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup
+++ a/kernel/relay.c
@@ -328,13 +328,13 @@ static struct rchan_callbacks default_ch
 
 /**
  *	wakeup_readers - wake up readers waiting on a channel
- *	@data: contains the channel buffer
+ *	@work: contains the channel buffer
  *
- *	This is the timer function used to defer reader waking.
+ *	This is the function used to defer reader waking
  */
-static void wakeup_readers(unsigned long data)
+static void wakeup_readers(struct irq_work *work)
 {
-	struct rchan_buf *buf = (struct rchan_buf *)data;
+	struct rchan_buf *buf = container_of(work, struct rchan_buf, wakeup_work);
 	wake_up_interruptible(&buf->read_wait);
 }
 
@@ -352,9 +352,10 @@ static void __relay_reset(struct rchan_b
 	if (init) {
 		init_waitqueue_head(&buf->read_wait);
 		kref_init(&buf->kref);
-		setup_timer(&buf->timer, wakeup_readers, (unsigned long)buf);
-	} else
-		del_timer_sync(&buf->timer);
+		init_irq_work(&buf->wakeup_work, wakeup_readers);
+	} else {
+		irq_work_sync(&buf->wakeup_work);
+	}
 
 	buf->subbufs_produced = 0;
 	buf->subbufs_consumed = 0;
@@ -486,7 +487,7 @@ free_buf:
 static void relay_close_buf(struct rchan_buf *buf)
 {
 	buf->finalized = 1;
-	del_timer_sync(&buf->timer);
+	irq_work_sync(&buf->wakeup_work);
 	buf->chan->cb->remove_buf_file(buf->dentry);
 	kref_put(&buf->kref, relay_remove_buf);
 }
@@ -768,14 +769,15 @@ size_t relay_switch_subbuf(struct rchan_
 			buf->early_bytes += buf->chan->subbuf_size -
 					    buf->padding[old_subbuf];
 		smp_mb();
-		if (waitqueue_active(&buf->read_wait))
+		if (waitqueue_active(&buf->read_wait)) {
 			/*
 			 * Calling wake_up_interruptible() from here
 			 * will deadlock if we happen to be logging
 			 * from the scheduler (trying to re-grab
 			 * rq->lock), so defer it.
 			 */
-			mod_timer(&buf->timer, jiffies + 1);
+			irq_work_queue(&buf->wakeup_work);
+		}
 	}
 
 	old = buf->data;
_

Patches currently in -mm which might be from peterz@infradead.org are

relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup.patch

