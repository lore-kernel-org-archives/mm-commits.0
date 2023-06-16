Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF57AEB64D7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jun 2023 17:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjFPRUM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Jun 2023 13:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbjFPRUC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2023 13:20:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47741FEC
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 10:20:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6869E614F5
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 17:20:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC50DC433C8;
        Fri, 16 Jun 2023 17:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686936000;
        bh=GblFUhJcJMDVYxMe+lnYg0tIiN/A8s7SWgI12RiX5zw=;
        h=Date:To:From:Subject:From;
        b=kPro1mtQ4EurG+ZA148/T+g3ibnjeyG9sr3g96elkcVm9f6XaXHBwa7EXDj7LI+33
         w8OLDG8+Wyz3+soFYUEuDx+8t4J2U72ZIgGA2DWcPZ8Qzf1zWLYPpZ1k3rVsUbczEN
         NUCKq4//wJenYulHeO1JvLd98bgeoMkFTEDLJpHo=
Date:   Fri, 16 Jun 2023 10:20:00 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com, npiggin@gmail.com,
        mpe@ellerman.id.au, davem@davemloft.net,
        christophe.leroy@csgroup.eu, dianders@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] watchdog-hardlockup-rename-have_hardlockup_detector_non_arch-to-_perf_or_buddy.patch removed from -mm tree
Message-Id: <20230616172000.BC50DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: watchdog/hardlockup: rename HAVE_HARDLOCKUP_DETECTOR_NON_ARCH to ..._PERF_OR_BUDDY
has been removed from the -mm tree.  Its filename was
     watchdog-hardlockup-rename-have_hardlockup_detector_non_arch-to-_perf_or_buddy.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: watchdog/hardlockup: rename HAVE_HARDLOCKUP_DETECTOR_NON_ARCH to ..._PERF_OR_BUDDY
Date: Fri, 26 May 2023 18:41:40 -0700

HAVE_HARDLOCKUP_DETECTOR_NON_ARCH is a mouthful and confusing. 
HAVE_HARDLOCKUP_DETECTOR_PERF_OR_BUDDY is even more of a mouthful, but
probably less confusing.  Rename the Kconfig names.

Link: https://lkml.kernel.org/r/20230526184139.10.I821fe7609e57608913fe05abd8f35b343e7a9aae@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/lib/Kconfig.debug~watchdog-hardlockup-rename-have_hardlockup_detector_non_arch-to-_perf_or_buddy
+++ a/lib/Kconfig.debug
@@ -1058,7 +1058,7 @@ config HARDLOCKUP_DETECTOR_BUDDY
 # needs SMP). In either case, using the "non-arch" code conflicts with
 # the NMI watchdog code (which is sometimes used directly and sometimes used
 # by the arch-provided hardlockup detector).
-config HAVE_HARDLOCKUP_DETECTOR_NON_ARCH
+config HAVE_HARDLOCKUP_DETECTOR_PERF_OR_BUDDY
 	bool
 	depends on (HAVE_HARDLOCKUP_DETECTOR_PERF || SMP) && !HAVE_NMI_WATCHDOG
 	default y
@@ -1077,10 +1077,10 @@ config HARDLOCKUP_DETECTOR_PREFER_BUDDY
 	  an arch-specific hardlockup detector or if resources needed
 	  for the hardlockup detector are better used for other things.
 
-# This will select the appropriate non-arch hardlockdup detector
-config HARDLOCKUP_DETECTOR_NON_ARCH
+# This will select the appropriate non-arch hardlockup detector
+config HARDLOCKUP_DETECTOR_PERF_OR_BUDDY
 	bool
-	depends on HAVE_HARDLOCKUP_DETECTOR_NON_ARCH
+	depends on HAVE_HARDLOCKUP_DETECTOR_PERF_OR_BUDDY
 	select HARDLOCKUP_DETECTOR_BUDDY if !HAVE_HARDLOCKUP_DETECTOR_PERF || HARDLOCKUP_DETECTOR_PREFER_BUDDY
 	select HARDLOCKUP_DETECTOR_PERF if HAVE_HARDLOCKUP_DETECTOR_PERF && !HARDLOCKUP_DETECTOR_PREFER_BUDDY
 
@@ -1098,9 +1098,9 @@ config HARDLOCKUP_CHECK_TIMESTAMP
 config HARDLOCKUP_DETECTOR
 	bool "Detect Hard Lockups"
 	depends on DEBUG_KERNEL && !S390
-	depends on HAVE_HARDLOCKUP_DETECTOR_NON_ARCH || HAVE_HARDLOCKUP_DETECTOR_ARCH
+	depends on HAVE_HARDLOCKUP_DETECTOR_PERF_OR_BUDDY || HAVE_HARDLOCKUP_DETECTOR_ARCH
 	select LOCKUP_DETECTOR
-	select HARDLOCKUP_DETECTOR_NON_ARCH if HAVE_HARDLOCKUP_DETECTOR_NON_ARCH
+	select HARDLOCKUP_DETECTOR_PERF_OR_BUDDY if HAVE_HARDLOCKUP_DETECTOR_PERF_OR_BUDDY
 
 	help
 	  Say Y here to enable the kernel to act as a watchdog to detect
_

Patches currently in -mm which might be from dianders@chromium.org are

watchdog-hardlockup-keep-kernelnmi_watchdog-sysctl-as-0444-if-probe-fails.patch
watchdog-hardlockup-have_nmi_watchdog-must-implement-watchdog_hardlockup_probe.patch
watchdog-hardlockup-dont-use-raw_cpu_ptr-in-watchdog_hardlockup_kick.patch
watchdog-hardlockup-in-watchdog_hardlockup_check-use-cpumask_copy.patch
watchdog-hardlockup-remove-softlockup-comment-in-touch_nmi_watchdog.patch
watchdog-buddy-cleanup-how-watchdog_buddy_check_hardlockup-is-called.patch
watchdog-buddy-dont-copy-the-cpumask-in-watchdog_next_cpu.patch
watchdog-buddy-simplify-the-dependency-for-hardlockup_detector_prefer_buddy.patch
watchdog-hardlockup-move-smp-barriers-from-common-code-to-buddy-code.patch

