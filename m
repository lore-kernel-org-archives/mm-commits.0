From: akpm@linux-foundation.org
Subject: + watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-3.patch added to -mm tree
Date: Wed, 06 May 2015 13:05:00 -0700
Message-ID: <554a73ec.viTQgvLtB83PuKFW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbbEFUFB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2015 16:05:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhubbard@nvidia.com, cmetcalf@ezchip.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: Fix a watchdog crash in some configurations
has been added to the -mm tree.  Its filename is
     watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN kernel/watchdog.c~watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-3 kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-3
+++ a/kernel/watchdog.c
@@ -921,10 +921,13 @@ void __init lockup_detector_init(void)
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

watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-3.patch

