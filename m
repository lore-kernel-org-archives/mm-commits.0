From: akpm@linux-foundation.org
Subject: +
 printk-do-cond_resched-between-lines-while-outputting-to-consoles.patch
 added to -mm tree
Date: Wed, 02 Dec 2015 15:57:14 -0800
Message-ID: <565f855a./bN6NB3bZKjpF4Wa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39949 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627AbbLBX5P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2015 18:57:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, calvinowens@fb.com, davej@codemonkey.org.uk, jack@suse.com, kyle@kernel.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: do cond_resched() between lines while outputting to consoles
has been added to the -mm tree.  Its filename is
     printk-do-cond_resched-between-lines-while-outputting-to-consoles.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-do-cond_resched-between-lines-while-outputting-to-consoles.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-do-cond_resched-between-lines-while-outputting-to-consoles.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: printk: do cond_resched() between lines while outputting to consoles

@console_may_schedule tracks whether console_sem was acquired through lock
or trylock.  If the former, we're inside a sleepable context and
console_conditional_schedule() performs cond_resched().  This allows
console drivers which use console_lock for synchronization to yield while
performing time-consuming operations such as scrolling.

However, the actual console outputting is performed while holding irq-safe
logbuf_lock, so console_unlock() clears @console_may_schedule before
starting outputting lines.  Also, only a few drivers call
console_conditional_schedule() to begin with.  This means that when a lot
of lines need to be output by console_unlock(), for example on a console
registration, the task doing console_unlock() may not yield for a long
time on a non-preemptible kernel.

If this happens with a slow console devices, for example a serial console,
the outputting task may occupy the cpu for a very long time.  Long enough
to trigger softlockup and/or RCU stall warnings, which in turn pile more
messages, sometimes enough to trigger the next cycle of warnings
incapacitating the system.

Fix it by making console_unlock() insert cond_resched() between lines if
@console_may_schedule.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Calvin Owens <calvinowens@fb.com>
Acked-by: Jan Kara <jack@suse.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Kyle McMartin <kyle@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff -puN kernel/printk/printk.c~printk-do-cond_resched-between-lines-while-outputting-to-consoles kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-do-cond_resched-between-lines-while-outputting-to-consoles
+++ a/kernel/printk/printk.c
@@ -2234,13 +2234,24 @@ void console_unlock(void)
 	static u64 seen_seq;
 	unsigned long flags;
 	bool wake_klogd = false;
-	bool retry;
+	bool do_cond_resched, retry;
 
 	if (console_suspended) {
 		up_console_sem();
 		return;
 	}
 
+	/*
+	 * Console drivers are called under logbuf_lock, so
+	 * @console_may_schedule should be cleared before; however, we may
+	 * end up dumping a lot of lines, for example, if called from
+	 * console registration path, and should invoke cond_resched()
+	 * between lines if allowable.  Not doing so can cause a very long
+	 * scheduling stall on a slow console leading to RCU stall and
+	 * softlockup warnings which exacerbate the issue with more
+	 * messages practically incapacitating the system.
+	 */
+	do_cond_resched = console_may_schedule;
 	console_may_schedule = 0;
 
 	/* flush buffered message fragment immediately to console */
@@ -2312,6 +2323,9 @@ skip:
 		call_console_drivers(level, ext_text, ext_len, text, len);
 		start_critical_timings();
 		local_irq_restore(flags);
+
+		if (do_cond_resched)
+			cond_resched();
 	}
 	console_locked = 0;
 
_

Patches currently in -mm which might be from tj@kernel.org are

printk-do-cond_resched-between-lines-while-outputting-to-consoles.patch

