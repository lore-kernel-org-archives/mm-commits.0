Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E352C001DD
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjFSX2X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjFSX2F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:28:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D988019AF
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:26:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD1E4610A6
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1329CC433C8;
        Mon, 19 Jun 2023 23:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217179;
        bh=gkop/y3ZsmvH/8cnJ+U/SWx/NhOgfgbrAHq9+Et2eRg=;
        h=Date:To:From:Subject:From;
        b=WKtJsl9N2pD2/QWuFEANhzobTQ+WG30RBNhr1IfFxYQNoqaZO2jR0nqveISJlOvyk
         9/jlWc82hhdFtrR8Wq2zu5ydJXsc+xg4wkMGSs5pOhN9g8Zq/Gq2CkxCA6KB5admBn
         oX7rGhjm9NL1TH+/G/wKKtw3YprJ2U6NSys6Sb00=
Date:   Mon, 19 Jun 2023 16:26:18 -0700
To:     mm-commits@vger.kernel.org, npiggin@gmail.com, mpe@ellerman.id.au,
        dianders@chromium.org, davem@davemloft.net,
        christophe.leroy@csgroup.eu, pmladek@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-hardlockup-make-the-config-checks-more-straightforward.patch removed from -mm tree
Message-Id: <20230619232619.1329CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: watchdog/hardlockup: make the config checks more straightforward
has been removed from the -mm tree.  Its filename was
     watchdog-hardlockup-make-the-config-checks-more-straightforward.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: watchdog/hardlockup: make the config checks more straightforward
Date: Fri, 16 Jun 2023 17:06:14 +0200

There are four possible variants of hardlockup detectors:

  + buddy: available when SMP is set.

  + perf: available when HAVE_HARDLOCKUP_DETECTOR_PERF is set.

  + arch-specific: available when HAVE_HARDLOCKUP_DETECTOR_ARCH is set.

  + sparc64 special variant: available when HAVE_NMI_WATCHDOG is set
	and HAVE_HARDLOCKUP_DETECTOR_ARCH is not set.

The check for the sparc64 variant is more complicated because
HAVE_NMI_WATCHDOG is used to #ifdef code used by both arch-specific
and sparc64 specific variant. Therefore it is automatically
selected with HAVE_HARDLOCKUP_DETECTOR_ARCH.

This complexity is partly hidden in HAVE_HARDLOCKUP_DETECTOR_NON_ARCH.
It reduces the size of some checks but it makes them harder to follow.

Finally, the other temporary variable HARDLOCKUP_DETECTOR_NON_ARCH
is used to re-compute HARDLOCKUP_DETECTOR_PERF/BUDDY when the global
HARDLOCKUP_DETECTOR switch is enabled/disabled.

Make the logic more straightforward by the following changes:

  + Better explain the role of HAVE_HARDLOCKUP_DETECTOR_ARCH and
    HAVE_NMI_WATCHDOG in comments.

  + Add HAVE_HARDLOCKUP_DETECTOR_BUDDY so that there is separate
    HAVE_* for all four hardlockup detector variants.

    Use it in the other conditions instead of SMP. It makes it
    clear that it is about the buddy detector.

  + Open code HAVE_HARDLOCKUP_DETECTOR_NON_ARCH in HARDLOCKUP_DETECTOR
    and HARDLOCKUP_DETECTOR_PREFER_BUDDY. It helps to understand
    the conditions between the four hardlockup detector variants.

  + Define the exact conditions when HARDLOCKUP_DETECTOR_PERF/BUDDY
    can be enabled. It explains the dependency on the other
    hardlockup detector variants.

    Also it allows to remove HARDLOCKUP_DETECTOR_NON_ARCH by using "imply".
    It triggers re-evaluating HARDLOCKUP_DETECTOR_PERF/BUDDY when
    the global HARDLOCKUP_DETECTOR switch is changed.

  + Add dependency on HARDLOCKUP_DETECTOR so that the affected variables
    disappear when the hardlockup detectors are disabled.

    Another nice side effect is that HARDLOCKUP_DETECTOR_PREFER_BUDDY
    value is not preserved when the global switch is disabled.
    The user has to make the decision again when it gets re-enabled.

Link: https://lkml.kernel.org/r/20230616150618.6073-3-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig      |   23 ++++++++++++----
 lib/Kconfig.debug |   62 +++++++++++++++++++++++++-------------------
 2 files changed, 53 insertions(+), 32 deletions(-)

--- a/arch/Kconfig~watchdog-hardlockup-make-the-config-checks-more-straightforward
+++ a/arch/Kconfig
@@ -404,17 +404,28 @@ config HAVE_NMI_WATCHDOG
 	depends on HAVE_NMI
 	bool
 	help
-	  The arch provides a low level NMI watchdog. It provides
-	  asm/nmi.h, and defines its own watchdog_hardlockup_probe() and
-	  arch_touch_nmi_watchdog().
+	  The arch provides its own hardlockup detector implementation instead
+	  of the generic ones.
+
+	  Sparc64 defines this variable without HAVE_HARDLOCKUP_DETECTOR_ARCH.
+	  It is the last arch-specific implementation which was developed before
+	  adding the common infrastructure for handling hardlockup detectors.
+	  It is always built. It does _not_ use the common command line
+	  parameters and sysctl interface, except for
+	  /proc/sys/kernel/nmi_watchdog.
 
 config HAVE_HARDLOCKUP_DETECTOR_ARCH
 	bool
 	select HAVE_NMI_WATCHDOG
 	help
-	  The arch chooses to provide its own hardlockup detector, which is
-	  a superset of the HAVE_NMI_WATCHDOG. It also conforms to config
-	  interfaces and parameters provided by hardlockup detector subsystem.
+	  The arch provides its own hardlockup detector implementation instead
+	  of the generic ones.
+
+	  It uses the same command line parameters, and sysctl interface,
+	  as the generic hardlockup detectors.
+
+	  HAVE_NMI_WATCHDOG is selected to build the code shared with
+	  the sparc64 specific implementation.
 
 config HAVE_PERF_REGS
 	bool
--- a/lib/Kconfig.debug~watchdog-hardlockup-make-the-config-checks-more-straightforward
+++ a/lib/Kconfig.debug
@@ -1035,16 +1035,33 @@ config BOOTPARAM_SOFTLOCKUP_PANIC
 
 	  Say N if unsure.
 
+config HAVE_HARDLOCKUP_DETECTOR_BUDDY
+	bool
+	depends on SMP
+	default y
+
+#
+# Global switch whether to build a hardlockup detector at all. It is available
+# only when the architecture supports at least one implementation. There are
+# two exceptions. The hardlockup detector is never enabled on:
 #
-# arch/ can define HAVE_HARDLOCKUP_DETECTOR_ARCH to provide their own hard
-# lockup detector rather than the perf based detector.
+#	s390: it reported many false positives there
+#
+#	sparc64: has a custom implementation which is not using the common
+#		hardlockup command line options and sysctl interface.
+#
+# Note that HAVE_NMI_WATCHDOG is used to distinguish the sparc64 specific
+# implementaion. It is automatically enabled also for other arch-specific
+# variants which set HAVE_HARDLOCKUP_DETECTOR_ARCH. It makes the check
+# of avaialable and supported variants quite tricky.
 #
 config HARDLOCKUP_DETECTOR
 	bool "Detect Hard Lockups"
 	depends on DEBUG_KERNEL && !S390
-	depends on HAVE_HARDLOCKUP_DETECTOR_NON_ARCH || HAVE_HARDLOCKUP_DETECTOR_ARCH
+	depends on ((HAVE_HARDLOCKUP_DETECTOR_PERF || HAVE_HARDLOCKUP_DETECTOR_BUDDY) && !HAVE_NMI_WATCHDOG) || HAVE_HARDLOCKUP_DETECTOR_ARCH
+	imply HARDLOCKUP_DETECTOR_PERF
+	imply HARDLOCKUP_DETECTOR_BUDDY
 	select LOCKUP_DETECTOR
-	select HARDLOCKUP_DETECTOR_NON_ARCH if HAVE_HARDLOCKUP_DETECTOR_NON_ARCH
 
 	help
 	  Say Y here to enable the kernel to act as a watchdog to detect
@@ -1055,9 +1072,14 @@ config HARDLOCKUP_DETECTOR
 	  chance to run.  The current stack trace is displayed upon detection
 	  and the system will stay locked up.
 
+#
+# Note that arch-specific variants are always preferred.
+#
 config HARDLOCKUP_DETECTOR_PREFER_BUDDY
 	bool "Prefer the buddy CPU hardlockup detector"
-	depends on HAVE_HARDLOCKUP_DETECTOR_PERF && SMP
+	depends on HARDLOCKUP_DETECTOR
+	depends on HAVE_HARDLOCKUP_DETECTOR_PERF && HAVE_HARDLOCKUP_DETECTOR_BUDDY
+	depends on !HAVE_NMI_WATCHDOG
 	help
 	  Say Y here to prefer the buddy hardlockup detector over the perf one.
 
@@ -1071,39 +1093,27 @@ config HARDLOCKUP_DETECTOR_PREFER_BUDDY
 
 config HARDLOCKUP_DETECTOR_PERF
 	bool
-	depends on HAVE_HARDLOCKUP_DETECTOR_PERF
+	depends on HARDLOCKUP_DETECTOR
+	depends on HAVE_HARDLOCKUP_DETECTOR_PERF && !HARDLOCKUP_DETECTOR_PREFER_BUDDY
+	depends on !HAVE_NMI_WATCHDOG
 	select HARDLOCKUP_DETECTOR_COUNTS_HRTIMER
 
 config HARDLOCKUP_DETECTOR_BUDDY
 	bool
-	depends on SMP
+	depends on HARDLOCKUP_DETECTOR
+	depends on HAVE_HARDLOCKUP_DETECTOR_BUDDY
+	depends on !HAVE_HARDLOCKUP_DETECTOR_PERF || HARDLOCKUP_DETECTOR_PREFER_BUDDY
+	depends on !HAVE_NMI_WATCHDOG
 	select HARDLOCKUP_DETECTOR_COUNTS_HRTIMER
 
+#
 # Both the "perf" and "buddy" hardlockup detectors count hrtimer
 # interrupts. This config enables functions managing this common code.
+#
 config HARDLOCKUP_DETECTOR_COUNTS_HRTIMER
 	bool
 	select SOFTLOCKUP_DETECTOR
 
-# For hardlockup detectors you can have one directly provided by the arch
-# or use a "non-arch" one. If you're using a "non-arch" one that is
-# further divided the perf hardlockup detector (which, confusingly, needs
-# arch-provided perf support) and the buddy hardlockup detector (which just
-# needs SMP). In either case, using the "non-arch" code conflicts with
-# the NMI watchdog code (which is sometimes used directly and sometimes used
-# by the arch-provided hardlockup detector).
-config HAVE_HARDLOCKUP_DETECTOR_NON_ARCH
-	bool
-	depends on (HAVE_HARDLOCKUP_DETECTOR_PERF || SMP) && !HAVE_NMI_WATCHDOG
-	default y
-
-# This will select the appropriate non-arch hardlockdup detector
-config HARDLOCKUP_DETECTOR_NON_ARCH
-	bool
-	depends on HAVE_HARDLOCKUP_DETECTOR_NON_ARCH
-	select HARDLOCKUP_DETECTOR_BUDDY if !HAVE_HARDLOCKUP_DETECTOR_PERF || HARDLOCKUP_DETECTOR_PREFER_BUDDY
-	select HARDLOCKUP_DETECTOR_PERF if HAVE_HARDLOCKUP_DETECTOR_PERF && !HARDLOCKUP_DETECTOR_PREFER_BUDDY
-
 #
 # Enables a timestamp based low pass filter to compensate for perf based
 # hard lockup detection which runs too fast due to turbo modes.
_

Patches currently in -mm which might be from pmladek@suse.com are


