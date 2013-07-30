From: akpm@linux-foundation.org
Subject: [to-be-updated] relay-fix-timer-madness.patch removed from -mm
 tree
Date: Tue, 30 Jul 2013 15:43:59 -0700
Message-ID: <51f841af.tFBBjGIe1NHXo9Vy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48443 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3G3WoA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jul 2013 18:44:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, rostedt@goodmis.org, jovi.zhangwei@huawei.com, edumazet@google.com, axboe@kernel.dk, mingo@elte.hu

Subject: [to-be-updated] relay-fix-timer-madness.patch removed from -mm tree
To: mingo@elte.hu,axboe@kernel.dk,edumazet@google.com,jovi.zhangwei@huawei.com,rostedt@goodmis.org,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 30 Jul 2013 15:43:59 -0700


The patch titled
     Subject: relay: fix timer madness
has been removed from the -mm tree.  Its filename was
     relay-fix-timer-madness.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Ingo Molnar <mingo@elte.hu>
Subject: relay: fix timer madness

When I'm using below ktap script to trace all event tracepoints, without
this patch, the system will hang in few seconds, the patch indeed fix the
problem as the changelog pointed.

	function eventfun (e) {
        	printf("%d %d\t%s\t%s", cpu(), pid(), execname(), e.annotate)
	}

	kdebug.probe("tp:", eventfun)

	kdebug.probe_end(function () {
        	printf("probe end\n")
	})

This patch is old, I can found the original patch discussion in 2007. 
http://marc.info/?l=linux-kernel&m=118544794717162&w=2 (In that mail
thread, the patch didn't fix that problem, but it fix the problem I
encountered now)

Ingo's original changelog:

Remove timer calls (!!!) from deep within the tracing infrastructure.
This was totally bogus code that can cause lockups and worse.
Poll the buffer every 2 jiffies for now.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN kernel/relay.c~relay-fix-timer-madness kernel/relay.c
--- a/kernel/relay.c~relay-fix-timer-madness
+++ a/kernel/relay.c
@@ -339,6 +339,10 @@ static void wakeup_readers(unsigned long
 {
 	struct rchan_buf *buf = (struct rchan_buf *)data;
 	wake_up_interruptible(&buf->read_wait);
+	/*
+	 * Stupid polling for now:
+	 */
+	mod_timer(&buf->timer, jiffies + 1);
 }
 
 /**
@@ -356,6 +360,7 @@ static void __relay_reset(struct rchan_b
 		init_waitqueue_head(&buf->read_wait);
 		kref_init(&buf->kref);
 		setup_timer(&buf->timer, wakeup_readers, (unsigned long)buf);
+		mod_timer(&buf->timer, jiffies + 1);
 	} else
 		del_timer_sync(&buf->timer);
 
@@ -739,15 +744,6 @@ size_t relay_switch_subbuf(struct rchan_
 		else
 			buf->early_bytes += buf->chan->subbuf_size -
 					    buf->padding[old_subbuf];
-		smp_mb();
-		if (waitqueue_active(&buf->read_wait))
-			/*
-			 * Calling wake_up_interruptible() from here
-			 * will deadlock if we happen to be logging
-			 * from the scheduler (trying to re-grab
-			 * rq->lock), so defer it.
-			 */
-			mod_timer(&buf->timer, jiffies + 1);
 	}
 
 	old = buf->data;
_

Patches currently in -mm which might be from mingo@elte.hu are

include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
watchdog-trigger-all-cpu-backtrace-when-locked-up-and-going-to-panic.patch
mm-vmstats-tlb-flush-counters.patch
mm-vmstats-track-tlb-flush-stats-on-up-too.patch
mm-hotplug-x86-disable-arch_memory_probe-by-default.patch
kernel-spinlockc-add-default-arch__relax-definitions-for-generic_lockbreak.patch
smp-give-warning-when-calling-smp_call_function_many-single-in-serving-irq.patch
relay-fix-timer-madness-v2.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch

