From: akpm@linux-foundation.org
Subject: + watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix.patch
 added to -mm tree
Date: Tue, 05 May 2015 12:50:16 -0700
Message-ID: <55491ef8.oLKEdMAPkQJVpO38%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60325 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbbEETuR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2015 15:50:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhubbard@nvidia.com, cmetcalf@ezchip.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: Fix a watchdog crash in some configurations
has been added to the -mm tree.  Its filename is
     watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix.patch

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

Commit 8fcf2cc768acd845c1fed837bf9cfe2d7106336d in linux-next introduced a
regression in some configurations.  Specifically, with CONFIG_NO_HZ_FULL
set, and CONFIG_NO_HZ_FULL_ALL *not* set, the kernel will crash in
lockup_detector_init(), due to a NULL tick_nohz_full_mask pointer.

This is because the above commit uses tick_nohz_full_mask (in
lockup_detector_init), if CONFIG_NO_HZ_FULL is set, but
tick_nohz_full_mask only gets allocated if either:

    a) CONFIG_NO_HZ_FULL_ALL is set, or

    b) Someone passes in nohz_full=<any_value> on the boot
      args line.

To correct this, change lockup_detector_init so that it does a runtime
check instead of the ifdef check.  This fix is simpler than my original
proposed fix, thanks to Chris Metcalf for that.

Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN kernel/watchdog.c~watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix
+++ a/kernel/watchdog.c
@@ -920,14 +920,14 @@ void __init lockup_detector_init(void)
 {
 	set_sample_period();
 
-#ifdef CONFIG_NO_HZ_FULL
-	if (!cpumask_empty(tick_nohz_full_mask))
-		pr_info("Disabling watchdog on nohz_full cores by default\n");
-	cpumask_andnot(&watchdog_cpumask, cpu_possible_mask,
-		       tick_nohz_full_mask);
-#else
-	cpumask_copy(&watchdog_cpumask, cpu_possible_mask);
-#endif
+	if (tick_nohz_full_enabled()) {
+		if (!cpumask_empty(tick_nohz_full_mask))
+			pr_info("Disabling watchdog on nohz_full cores by default\n");
+		cpumask_andnot(&watchdog_cpumask, cpu_possible_mask,
+			       tick_nohz_full_mask);
+	}
+	else
+		cpumask_copy(&watchdog_cpumask, cpu_possible_mask);
 
 	if (watchdog_enabled)
 		watchdog_enable_all_cpus();
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix.patch

