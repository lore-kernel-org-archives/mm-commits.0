From: akpm@linux-foundation.org
Subject: [merged]
 watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:08:48 -0700
Message-ID: <552eb740.OGzq+Ith0rFFwzTM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685AbbDOTIt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:08:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, dzickus@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: implement error handling for failure to set up hardware perf events
has been removed from the -mm tree.  Its filename was
     watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ulrich Obergfell <uobergfe@redhat.com>
Subject: watchdog: implement error handling for failure to set up hardware perf events

If watchdog_nmi_enable() fails to set up the hardware perf event of one
CPU, the entire hard lockup detector is deemed unreliable.  Hence, disable
the hard lockup detector and shut down the hardware perf events on all
CPUs.

[dzickus@redhat.com: update comments to explain some code]
Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff -puN kernel/watchdog.c~watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events
+++ a/kernel/watchdog.c
@@ -502,6 +502,21 @@ static void watchdog(unsigned int cpu)
 	__this_cpu_write(soft_lockup_hrtimer_cnt,
 			 __this_cpu_read(hrtimer_interrupts));
 	__touch_watchdog();
+
+	/*
+	 * watchdog_nmi_enable() clears the NMI_WATCHDOG_ENABLED bit in the
+	 * failure path. Check for failures that can occur asynchronously -
+	 * for example, when CPUs are on-lined - and shut down the hardware
+	 * perf event on each CPU accordingly.
+	 *
+	 * The only non-obvious place this bit can be cleared is through
+	 * watchdog_nmi_enable(), so a pr_info() is placed there.  Placing a
+	 * pr_info here would be too noisy as it would result in a message
+	 * every few seconds if the hardlockup was disabled but the softlockup
+	 * enabled.
+	 */
+	if (!(watchdog_enabled & NMI_WATCHDOG_ENABLED))
+		watchdog_nmi_disable(cpu);
 }
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
@@ -552,6 +567,18 @@ handle_err:
 		goto out_save;
 	}
 
+	/*
+	 * Disable the hard lockup detector if _any_ CPU fails to set up
+	 * set up the hardware perf event. The watchdog() function checks
+	 * the NMI_WATCHDOG_ENABLED bit periodically.
+	 *
+	 * The barriers are for syncing up watchdog_enabled across all the
+	 * cpus, as clear_bit() does not use barriers.
+	 */
+	smp_mb__before_atomic();
+	clear_bit(NMI_WATCHDOG_ENABLED_BIT, &watchdog_enabled);
+	smp_mb__after_atomic();
+
 	/* skip displaying the same error again */
 	if (cpu > 0 && (PTR_ERR(event) == cpu0_err))
 		return PTR_ERR(event);
@@ -565,6 +592,9 @@ handle_err:
 	else
 		pr_err("disabled (cpu%i): unable to create perf event: %ld\n",
 			cpu, PTR_ERR(event));
+
+	pr_info("Shutting down hard lockup detector on all cpus\n");
+
 	return PTR_ERR(event);
 
 	/* success path */
_

Patches currently in -mm which might be from uobergfe@redhat.com are

origin.patch
linux-next.patch

