From: akpm@linux-foundation.org
Subject: [folded-merged]
 watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-3.patch removed
 from -mm tree
Date: Wed, 24 Jun 2015 16:44:24 -0700
Message-ID: <558b40d8.4sotrbAi10aYJ2F4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40533 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbbFXXoZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jun 2015 19:44:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhubbard@nvidia.com, cmetcalf@ezchip.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: Fix a watchdog crash in some configurations
has been removed from the -mm tree.  Its filename was
     watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-3.patch

This patch was dropped because it was folded into watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz.patch

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: watchdog: Fix a watchdog crash in some configurations

Commit <8fcf2cc768acd845c> in linux-next
introduced a regression in some configurations. Specifically,
with CONFIG_NO_HZ_FULL set, and CONFIG_NO_HZ_FULL_ALL *not* set,
the kernel will crash in lockup_detector_init(), due to a
NULL tick_nohz_full_mask pointer.

This is because the above commit uses tick_nohz_full_mask
(in lockup_detector_init), if CONFIG_NO_HZ_FULL is set, but
tick_nohz_full_mask only gets allocated if either:

    a) CONFIG_NO_HZ_FULL_ALL is set, or

    b) Someone passes in nohz_full=<any_value> on the boot
      args line.

To correct this, change lockup_detector_init so that it does
a runtime check in addition to the ifdef check. This fix is
simpler than my original proposed fix, thanks to Chris Metcalf
for that.

Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Chris Metcalf <cmetcalf@ezchip.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN kernel/watchdog.c~watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-3 kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-3
+++ a/kernel/watchdog.c
@@ -931,10 +931,13 @@ void __init lockup_detector_init(void)
 	set_sample_period();
 
 #ifdef CONFIG_NO_HZ_FULL
-	if (!cpumask_empty(tick_nohz_full_mask))
-		pr_info("Disabling watchdog on nohz_full cores by default\n");
-	cpumask_andnot(&watchdog_cpumask, cpu_possible_mask,
-		       tick_nohz_full_mask);
+	if (tick_nohz_full_enabled()) {
+		if (!cpumask_empty(tick_nohz_full_mask))
+			pr_info("Disabling watchdog on nohz_full cores by default\n");
+		cpumask_andnot(&watchdog_cpumask, cpu_possible_mask,
+			       tick_nohz_full_mask);
+	} else
+		cpumask_copy(&watchdog_cpumask, cpu_possible_mask);
 #else
 	cpumask_copy(&watchdog_cpumask, cpu_possible_mask);
 #endif
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz.patch

