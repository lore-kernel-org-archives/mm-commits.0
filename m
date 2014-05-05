From: akpm@linux-foundation.org
Subject: + printk-disable-preemption-for-printk_sched.patch added to -mm
 tree
Date: Mon, 05 May 2014 15:07:12 -0700
Message-ID: <53680b90.9dlgLgQcC06ywc69%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782AbaEEWHN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2014 18:07:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, rostedt@goodmis.org, peterz@infradead.org, mingo@redhat.com, jbohac@suse.cz, jack@suse.cz, john.stultz@linaro.org

Subject: + printk-disable-preemption-for-printk_sched.patch added to -mm tree
To: john.stultz@linaro.org,jack@suse.cz,jbohac@suse.cz,mingo@redhat.com,peterz@infradead.org,rostedt@goodmis.org,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Mon, 05 May 2014 15:07:12 -0700


The patch titled
     Subject: printk: disable preemption for printk_sched
has been added to the -mm tree.  Its filename is
     printk-disable-preemption-for-printk_sched.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-disable-preemption-for-printk_sched.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-disable-preemption-for-printk_sched.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Stultz <john.stultz@linaro.org>
Subject: printk: disable preemption for printk_sched

An earlier change in -mm (printk: remove separate printk_sched
buffers...), removed the printk_sched irqsave/restore lines since it was
safe for current users.  Since we may be expanding usage of
printk_sched(), disable preepmtion for this function to make it more
generally safe to call.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/printk/printk.c~printk-disable-preemption-for-printk_sched kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-disable-preemption-for-printk_sched
+++ a/kernel/printk/printk.c
@@ -2589,12 +2589,14 @@ int printk_sched(const char *fmt, ...)
 	va_list args;
 	int r;
 
+	preempt_disable();
 	va_start(args, fmt);
 	r = vprintk_emit(0, SCHED_MESSAGE_LOGLEVEL, NULL, 0, fmt, args);
 	va_end(args);
 
 	__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
 	irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
+	preempt_enable();
 
 	return r;
 }
_

Patches currently in -mm which might be from john.stultz@linaro.org are

printk-disable-preemption-for-printk_sched.patch
printk-rename-printk_sched-to-printk_deferred.patch
printk-add-printk_deferred_once.patch
timekeeping-use-printk_deferred-when-holding-timekeeping-seqlock.patch

