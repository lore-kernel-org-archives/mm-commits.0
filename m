From: akpm@linux-foundation.org
Subject: +
 watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events.patch added to -mm tree
Date: Mon, 23 Feb 2015 13:20:49 -0800
Message-ID: <54eb99b1.iM4dxtJl7Jl7n9Oq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45192 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbbBWVUu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 16:20:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, dzickus@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: implement error handling for failure to set up hardware perf events
has been added to the -mm tree.  Its filename is
     watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ulrich Obergfell <uobergfe@redhat.com>
Subject: watchdog: implement error handling for failure to set up hardware perf events

If watchdog_nmi_enable() fails to set up the hardware perf event of one
CPU, the entire hard lockup detector is deemed unreliable.  Hence, disable
the hard lockup detector and shut down the hardware perf events on all
CPUs.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN kernel/watchdog.c~watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events
+++ a/kernel/watchdog.c
@@ -502,6 +502,15 @@ static void watchdog(unsigned int cpu)
 	__this_cpu_write(soft_lockup_hrtimer_cnt,
 			 __this_cpu_read(hrtimer_interrupts));
 	__touch_watchdog();
+
+	/*
+	 * watchdog_nmi_enable() clears the NMI_WATCHDOG_ENABLED bit in the
+	 * failure path. Check for failures that can occur asynchronously -
+	 * for example, when CPUs are on-lined - and shut down the hardware
+	 * perf event on each CPU accordingly.
+	 */
+	if (!(watchdog_enabled & NMI_WATCHDOG_ENABLED))
+		watchdog_nmi_disable(cpu);
 }
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
@@ -552,6 +561,15 @@ handle_err:
 		goto out_save;
 	}
 
+	/*
+	 * Disable the hard lockup detector if _any_ CPU fails to set up
+	 * set up the hardware perf event. The watchdog() function checks
+	 * the NMI_WATCHDOG_ENABLED bit periodically.
+	 */
+	smp_mb__before_atomic();
+	clear_bit(NMI_WATCHDOG_ENABLED_BIT, &watchdog_enabled);
+	smp_mb__after_atomic();
+
 	/* skip displaying the same error again */
 	if (cpu > 0 && (PTR_ERR(event) == cpu0_err))
 		return PTR_ERR(event);
_

Patches currently in -mm which might be from uobergfe@redhat.com are

watchdog-new-definitions-and-variables-initialization.patch
watchdog-introduce-the-proc_watchdog_update-function.patch
watchdog-move-definition-of-watchdog_proc_mutex-outside-of-proc_dowatchdog.patch
watchdog-introduce-the-proc_watchdog_common-function.patch
watchdog-introduce-separate-handlers-for-parameters-in-proc-sys-kernel.patch
watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events.patch
watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism.patch
watchdog-clean-up-some-function-names-and-arguments.patch
watchdog-introduce-the-hardlockup_detector_disable-function.patch

