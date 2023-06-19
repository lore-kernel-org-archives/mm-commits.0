Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C5DFEB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjFSX2T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjFSX2D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:28:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399A519A9
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:26:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C41E6610A4
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18EA2C433C0;
        Mon, 19 Jun 2023 23:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217168;
        bh=hp9xv0uM+c1R/wBCCktgSlzdA7spS65QbwgcyEDIbX8=;
        h=Date:To:From:Subject:From;
        b=jU0IPphYF/ZWv72oIwM9P3THoWlynvClcCepIxH9EmxPydX7HIiXQcmZnKF8nJoHh
         AypdMxnTngNxVBn8QYeaIV/AXQxbofKMDETOMczbZf+KOa0s0d1DckfebAGZIJiLN5
         pekHKeKzDfnSIr6EnGkY+mlrnk4zlkVzIQatizh0=
Date:   Mon, 19 Jun 2023 16:26:07 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com, npiggin@gmail.com,
        mpe@ellerman.id.au, davem@davemloft.net,
        christophe.leroy@csgroup.eu, dianders@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-hardlockup-keep-kernelnmi_watchdog-sysctl-as-0444-if-probe-fails.patch removed from -mm tree
Message-Id: <20230619232608.18EA2C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: watchdog/hardlockup: keep kernel.nmi_watchdog sysctl as 0444 if probe fails
has been removed from the -mm tree.  Its filename was
     watchdog-hardlockup-keep-kernelnmi_watchdog-sysctl-as-0444-if-probe-fails.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: watchdog/hardlockup: keep kernel.nmi_watchdog sysctl as 0444 if probe fails
Date: Fri, 26 May 2023 18:41:31 -0700

Patch series "watchdog: Cleanup / fixes after buddy series v5 reviews".

This patch series attempts to finish resolving the feedback received
from Petr Mladek on the v5 series I posted.

Probably the only thing that wasn't fully as clean as Petr requested was
the Kconfig stuff.  I couldn't find a better way to express it without a
more major overhaul.  In the very least, I renamed "NON_ARCH" to
"PERF_OR_BUDDY" in the hopes that will make it marginally better.

Nothing in this series is terribly critical and even the bugfixes are
small.  However, it does cleanup a few things that were pointed out in
review.


This patch (of 10):

The permissions for the kernel.nmi_watchdog sysctl have always been set at
compile time despite the fact that a watchdog can fail to probe.  Let's
fix this and set the permissions based on whether the hardlockup detector
actually probed.

Link: https://lkml.kernel.org/r/20230527014153.2793931-1-dianders@chromium.org
Link: https://lkml.kernel.org/r/20230526184139.1.I0d75971cc52a7283f495aac0bd5c3041aadc734e@changeid
Fixes: a994a3147e4c ("watchdog/hardlockup/perf: Implement init time detection of perf")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reported-by: Petr Mladek <pmladek@suse.com>
Closes: https://lore.kernel.org/r/ZHCn4hNxFpY5-9Ki@alley
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h |    6 ------
 kernel/watchdog.c   |   30 ++++++++++++++++++++----------
 2 files changed, 20 insertions(+), 16 deletions(-)

--- a/include/linux/nmi.h~watchdog-hardlockup-keep-kernelnmi_watchdog-sysctl-as-0444-if-probe-fails
+++ a/include/linux/nmi.h
@@ -95,12 +95,6 @@ void watchdog_hardlockup_check(unsigned
 static inline void arch_touch_nmi_watchdog(void) { }
 #endif
 
-#if defined(CONFIG_HAVE_NMI_WATCHDOG) || defined(CONFIG_HARDLOCKUP_DETECTOR)
-# define NMI_WATCHDOG_SYSCTL_PERM	0644
-#else
-# define NMI_WATCHDOG_SYSCTL_PERM	0444
-#endif
-
 #if defined(CONFIG_HARDLOCKUP_DETECTOR_PERF)
 extern void hardlockup_detector_perf_stop(void);
 extern void hardlockup_detector_perf_restart(void);
--- a/kernel/watchdog.c~watchdog-hardlockup-keep-kernelnmi_watchdog-sysctl-as-0444-if-probe-fails
+++ a/kernel/watchdog.c
@@ -881,15 +881,6 @@ static struct ctl_table watchdog_sysctls
 		.extra2		= (void *)&sixty,
 	},
 	{
-		.procname       = "nmi_watchdog",
-		.data		= &watchdog_hardlockup_user_enabled,
-		.maxlen		= sizeof(int),
-		.mode		= NMI_WATCHDOG_SYSCTL_PERM,
-		.proc_handler   = proc_nmi_watchdog,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-	{
 		.procname	= "watchdog_cpumask",
 		.data		= &watchdog_cpumask_bits,
 		.maxlen		= NR_CPUS,
@@ -952,10 +943,28 @@ static struct ctl_table watchdog_sysctls
 	{}
 };
 
+static struct ctl_table watchdog_hardlockup_sysctl[] = {
+	{
+		.procname       = "nmi_watchdog",
+		.data		= &watchdog_hardlockup_user_enabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler   = proc_nmi_watchdog,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{}
+};
+
 static void __init watchdog_sysctl_init(void)
 {
 	register_sysctl_init("kernel", watchdog_sysctls);
+
+	if (watchdog_hardlockup_available)
+		watchdog_hardlockup_sysctl[0].mode = 0644;
+	register_sysctl_init("kernel", watchdog_hardlockup_sysctl);
 }
+
 #else
 #define watchdog_sysctl_init() do { } while (0)
 #endif /* CONFIG_SYSCTL */
@@ -1011,6 +1020,8 @@ static int __init lockup_detector_check(
 	/* Make sure no work is pending. */
 	flush_work(&detector_work);
 
+	watchdog_sysctl_init();
+
 	return 0;
 
 }
@@ -1030,5 +1041,4 @@ void __init lockup_detector_init(void)
 		allow_lockup_detector_init_retry = true;
 
 	lockup_detector_setup();
-	watchdog_sysctl_init();
 }
_

Patches currently in -mm which might be from dianders@chromium.org are


