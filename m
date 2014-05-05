From: akpm@linux-foundation.org
Subject: [to-be-updated]
 printk-re-add-irqsave-restore-in-printk_sched.patch removed from -mm tree
Date: Mon, 05 May 2014 15:04:58 -0700
Message-ID: <53680b0a.wHZ/5rsdwnpPb2gE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51906 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762AbaEEWE7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2014 18:04:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, rostedt@goodmis.org, peterz@infradead.org, mingo@redhat.com, jbohac@suse.cz, jack@suse.cz, john.stultz@linaro.org

Subject: [to-be-updated] printk-re-add-irqsave-restore-in-printk_sched.patch removed from -mm tree
To: john.stultz@linaro.org,jack@suse.cz,jbohac@suse.cz,mingo@redhat.com,peterz@infradead.org,rostedt@goodmis.org,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 May 2014 15:04:58 -0700


The patch titled
     Subject: printk: re-add irqsave/restore in printk_sched
has been removed from the -mm tree.  Its filename was
     printk-re-add-irqsave-restore-in-printk_sched.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: John Stultz <john.stultz@linaro.org>
Subject: printk: re-add irqsave/restore in printk_sched

Recently, Jiri pointed out a potential deadlock when calling printk while
holding the timekeeping seqlock.

Annoyingly, the seqlock lockdep enablement doesn't catch this, as printk
disables lockdep.

When looking for possible solutions, one idea was to use a local buffer
and defer the printk to later.  Ends up there is already similar
functionality in printk_sched() to avoid similar style deadlocks w/ the
scheduler.

Thus this patchset renames printk_sched to printk_deferred and then moves
the affected timekeeping printks to make use of it.

There were some points in the discussion between Jan and Peter that made
it seem that there may still be problems lurking in the console layer, and
I'm not sure I fully understand their point, so this solution may be
incomplete.

Additionally, the same issue likely affects any WARN_ONs as well, but I
wanted to get some thoughts on this approach before trying to remove or
convert affected WARN_ONS.


This patch (of 4)

A commit in akpm's tree (printk: remove separate printk_sched buffers...),
removed the printk_sched irqsave/restore lines since it was safe for
current users.  Since we may be expanding usage of printk_sched(), re-add
the irqsave/restore logic to make the functionality more generally safe.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/printk/printk.c~printk-re-add-irqsave-restore-in-printk_sched kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-re-add-irqsave-restore-in-printk_sched
+++ a/kernel/printk/printk.c
@@ -2586,15 +2586,18 @@ void wake_up_klogd(void)
 
 int printk_sched(const char *fmt, ...)
 {
+	unsigned long flags;
 	va_list args;
 	int r;
 
+	local_irq_save(flags);
 	va_start(args, fmt);
 	r = vprintk_emit(0, SCHED_MESSAGE_LOGLEVEL, NULL, 0, fmt, args);
 	va_end(args);
 
 	__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
 	irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
+	local_irq_restore(flags);
 
 	return r;
 }
_

Patches currently in -mm which might be from john.stultz@linaro.org are

printk-rename-printk_sched-to-printk_deferred.patch
printk-add-printk_once_deferred.patch
timekeeping-use-printk_deferred-when-holding-timekeeping-seqlock.patch

