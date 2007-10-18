From: akpm@linux-foundation.org
Subject: - use-num_possible_cpus-instead-of-nr_cpus-for-timer.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:56:34 -0700
Message-ID: <200710180656.l9I6uY3H030711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53802 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761887AbXJRHQy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:16:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Use num_possible_cpus() instead of NR_CPUS for timer distribution
has been removed from the -mm tree.  Its filename was
     use-num_possible_cpus-instead-of-nr_cpus-for-timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time/tick-sched.c~use-num_possible_cpus-instead-of-nr_cpus-for-timer kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~use-num_possible_cpus-instead-of-nr_cpus-for-timer
+++ a/kernel/time/tick-sched.c
@@ -570,7 +570,7 @@ void tick_setup_sched_timer(void)
 	/* Get the next period (per cpu) */
 	ts->sched_timer.expires = tick_init_jiffy_update();
 	offset = ktime_to_ns(tick_period) >> 1;
-	do_div(offset, NR_CPUS);
+	do_div(offset, num_possible_cpus());
 	offset *= smp_processor_id();
 	ts->sched_timer.expires = ktime_add_ns(ts->sched_timer.expires, offset);
 
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

origin.patch
git-acpi.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
