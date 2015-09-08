From: akpm@linux-foundation.org
Subject: [merged]
 watchdog-simplify-housekeeping-affinity-with-the-appropriate-mask.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:03:05 -0700
Message-ID: <55ef22d9.jgEIq4BJzqiebf78%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbbIHSDG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:03:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, cmetcalf@ezchip.com, dzickus@redhat.com, peterz@infradead.org, tglx@linutronix.de, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: simplify housekeeping affinity with the appropriate mask
has been removed from the -mm tree.  Its filename was
     watchdog-simplify-housekeeping-affinity-with-the-appropriate-mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

kmod-bunch-of-internal-functions-renames.patch
kmod-remove-unecessary-explicit-wide-cpu-affinity-setting.patch
kmod-add-up-to-date-explanations-on-the-purpose-of-each-asynchronous-levels.patch
kmod-use-system_unbound_wq-instead-of-khelper.patch
kmod-handle-umh_wait_proc-from-system-unbound-workqueue.patch

