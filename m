From: akpm@linux-foundation.org
Subject: + use-num_possible_cpus-instead-of-nr_cpus-for-timer.patch added to -mm tree
Date: Fri, 17 Aug 2007 11:48:32 -0700
Message-ID: <200708171848.l7HImWLP024269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54646 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515AbXHQStU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 14:49:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, tglx@linutronix.de


The patch titled
     Use num_possible_cpus() instead of NR_CPUS for timer distribution
has been added to the -mm tree.  Its filename is
     use-num_possible_cpus-instead-of-nr_cpus-for-timer.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use num_possible_cpus() instead of NR_CPUS for timer distribution
From: john stultz <johnstul@us.ibm.com>

To avoid lock contention, we distribute the sched_timer calls across the
cpus so they do not trigger at the same instant.  However, I used NR_CPUS,
which can cause needless grouping on small smp systems depending on your
kernel config.  This patch converts to using num_possible_cpus() so we
spread it as evenly as possible on every machine.

Briefly tested w/ NR_CPUS=255 and verified reduced contention.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-sched.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time/tick-sched.c~use-num_possible_cpus-instead-of-nr_cpus-for-timer kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~use-num_possible_cpus-instead-of-nr_cpus-for-timer
+++ a/kernel/time/tick-sched.c
@@ -574,7 +574,7 @@ void tick_setup_sched_timer(void)
 	/* Get the next period (per cpu) */
 	ts->sched_timer.expires = tick_init_jiffy_update();
 	offset = ktime_to_ns(tick_period) >> 1;
-	do_div(offset, NR_CPUS);
+	do_div(offset, num_possible_cpus());
 	offset *= smp_processor_id();
 	ts->sched_timer.expires = ktime_add_ns(ts->sched_timer.expires, offset);
 
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

futex_unlock_pi-hurts-my-brain-and-may-cause.patch
git-acpi.patch
geode-mfgpt-clock-event-device-support.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
kernel-time-timekeepingc-cleanups.patch
use-num_possible_cpus-instead-of-nr_cpus-for-timer.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
