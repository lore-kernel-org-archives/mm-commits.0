From: akpm@linux-foundation.org
Subject: +
 watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events-fix.patch added to -mm tree
Date: Tue, 03 Mar 2015 12:43:56 -0800
Message-ID: <54f61d0c.95G/WHQ9ixFWUh4h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35267 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806AbbCCUn5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2015 15:43:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dzickus@redhat.com, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: update comments to explain some code
has been added to the -mm tree.  Its filename is
     watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Don Zickus <dzickus@redhat.com>
Subject: watchdog: update comments to explain some code

This patch was written to update some comments and concerns from Andrew
and is expected to be folded into patch

watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events.patch

Resolves:
- comments around barriers
- comments around blind shutdown of hardware lockup detector
- printk letting someone know hardlockup detector is being shut down

Signed-off-by: Don Zickus <dzickus@redhat.com>
Suggested-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN kernel/watchdog.c~watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events-fix kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events-fix
+++ a/kernel/watchdog.c
@@ -508,6 +508,12 @@ static void watchdog(unsigned int cpu)
 	 * failure path. Check for failures that can occur asynchronously -
 	 * for example, when CPUs are on-lined - and shut down the hardware
 	 * perf event on each CPU accordingly.
+	 *
+	 * The only non-obvious place this bit can be cleared is through
+	 * watchdog_nmi_enable(), so a pr_info() is placed there.  Placing a
+	 * pr_info here would be too noisy as it would result in a message
+	 * every few seconds if the hardlockup was disabled but the softlockup
+	 * enabled.
 	 */
 	if (!(watchdog_enabled & NMI_WATCHDOG_ENABLED))
 		watchdog_nmi_disable(cpu);
@@ -565,6 +571,9 @@ handle_err:
 	 * Disable the hard lockup detector if _any_ CPU fails to set up
 	 * set up the hardware perf event. The watchdog() function checks
 	 * the NMI_WATCHDOG_ENABLED bit periodically.
+	 *
+	 * The barriers are for syncing up watchdog_enabled across all the
+	 * cpus, as clear_bit() does not use barriers.
 	 */
 	smp_mb__before_atomic();
 	clear_bit(NMI_WATCHDOG_ENABLED_BIT, &watchdog_enabled);
@@ -583,6 +592,9 @@ handle_err:
 	else
 		pr_err("disabled (cpu%i): unable to create perf event: %ld\n",
 			cpu, PTR_ERR(event));
+
+	pr_info("Shutting down hard lockup detector on all cpus\n");
+
 	return PTR_ERR(event);
 
 	/* success path */
_

Patches currently in -mm which might be from dzickus@redhat.com are

watchdog-new-definitions-and-variables-initialization.patch
watchdog-introduce-the-proc_watchdog_update-function.patch
watchdog-move-definition-of-watchdog_proc_mutex-outside-of-proc_dowatchdog.patch
watchdog-introduce-the-proc_watchdog_common-function.patch
watchdog-introduce-separate-handlers-for-parameters-in-proc-sys-kernel.patch
watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events.patch
watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events-fix.patch
watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism.patch
watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism-fix.patch
watchdog-clean-up-some-function-names-and-arguments.patch
watchdog-introduce-the-hardlockup_detector_disable-function.patch
linux-next.patch

