From: akpm@linux-foundation.org
Subject: + relay-fix-timer-madness.patch added to -mm tree
Date: Tue, 23 Apr 2013 14:28:28 -0700
Message-ID: <20130423212828.74A2331C1F9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:47394 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab3DWV2a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Apr 2013 17:28:30 -0400
Received: by mail-vc0-f201.google.com with SMTP id hz11so121394vcb.2
        for <mm-commits@vger.kernel.org>; Tue, 23 Apr 2013 14:28:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, axboe@kernel.dk, edumazet@google.com, jovi.zhangwei@huawei.com, rostedt@goodmis.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: relay: fix timer madness
has been added to the -mm tree.  Its filename is
     relay-fix-timer-madness.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ingo Molnar <mingo@elte.hu>
Subject: relay: fix timer madness

When I'm using below ktap script to tracing all event tracepoints, without
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
Cc: Steven Rostedt <rostedt@goodmis.org
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
@@ -340,6 +340,10 @@ static void wakeup_readers(unsigned long
 {
 	struct rchan_buf *buf = (struct rchan_buf *)data;
 	wake_up_interruptible(&buf->read_wait);
+	/*
+	 * Stupid polling for now:
+	 */
+	mod_timer(&buf->timer, jiffies + 1);
 }
 
 /**
@@ -357,6 +361,7 @@ static void __relay_reset(struct rchan_b
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

linux-next.patch
posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch
debug_locksh-make-warning-more-verbose.patch
watchdog-trigger-all-cpu-backtrace-when-locked-up-and-going-to-panic.patch
mm-try-harder-to-allocate-vmemmap-blocks.patch
sparse-vmemmap-specify-vmemmap-population-range-in-bytes.patch
x86-64-remove-dead-debugging-code-for-pse-setups.patch
x86-64-use-vmemmap_populate_basepages-for-pse-setups.patch
x86-64-fall-back-to-regular-page-vmemmap-on-allocation-failure.patch
mm-speedup-in-__early_pfn_to_nid.patch
mm-speedup-in-__early_pfn_to_nid-fix.patch
numa-cpu-hotplug-change-links-of-cpu-and-node-when-changing-node-number-by-onlining-cpu.patch
smp-give-warning-when-calling-smp_call_function_many-single-in-serving-irq.patch
kernel-smpc-cleanups.patch
drivers-rtc-rtc-cmosc-dont-disable-hpet-emulation-on-suspend.patch
relay-fix-timer-madness.patch
wait-add-wait_event_hrtimeout.patch
decompressor-add-lz4-decompressor-module.patch
lib-add-support-for-lz4-compressed-kernel.patch
arm-add-support-for-lz4-compressed-kernel.patch
x86-add-support-for-lz4-compressed-kernel.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch

