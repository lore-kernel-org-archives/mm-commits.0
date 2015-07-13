From: akpm@linux-foundation.org
Subject: +
 watchdog-simplify-housekeeping-affinity-with-the-appropriate-mask.patch
 added to -mm tree
Date: Mon, 13 Jul 2015 14:55:44 -0700
Message-ID: <55a433e0.rArAo8Gee7PMEFa2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbbGMVzp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jul 2015 17:55:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, cmetcalf@ezchip.com, dzickus@redhat.com, peterz@infradead.org, tglx@linutronix.de, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: simplify housekeeping affinity with the appropriate mask
has been added to the -mm tree.  Its filename is
     watchdog-simplify-housekeeping-affinity-with-the-appropriate-mask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-simplify-housekeeping-affinity-with-the-appropriate-mask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-simplify-housekeeping-affinity-with-the-appropriate-mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: watchdog: simplify housekeeping affinity with the appropriate mask

housekeeping_mask gathers all the CPUs that aren't part of the nohz_full
set.  This is exactly what we want the watchdog to be affine to without
the need to use complicated cpumask operations.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/watchdog.c~watchdog-simplify-housekeeping-affinity-with-the-appropriate-mask kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-simplify-housekeeping-affinity-with-the-appropriate-mask
+++ a/kernel/watchdog.c
@@ -929,10 +929,8 @@ void __init lockup_detector_init(void)
 
 #ifdef CONFIG_NO_HZ_FULL
 	if (tick_nohz_full_enabled()) {
-		if (!cpumask_empty(tick_nohz_full_mask))
-			pr_info("Disabling watchdog on nohz_full cores by default\n");
-		cpumask_andnot(&watchdog_cpumask, cpu_possible_mask,
-			       tick_nohz_full_mask);
+		pr_info("Disabling watchdog on nohz_full cores by default\n");
+		cpumask_copy(&watchdog_cpumask, housekeeping_mask);
 	} else
 		cpumask_copy(&watchdog_cpumask, cpu_possible_mask);
 #else
_

Patches currently in -mm which might be from fweisbec@gmail.com are

smpboot-fix-memory-leak-on-error-handling.patch
smpboot-make-cleanup-to-mirror-setup.patch
smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration.patch
watchdog-simplify-housekeeping-affinity-with-the-appropriate-mask.patch
linux-next.patch

