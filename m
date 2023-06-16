Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB952EB64D7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jun 2023 17:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjFPRTj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Jun 2023 13:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbjFPRTi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2023 13:19:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A961FEC
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 10:19:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C330B61DF5
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 17:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11926C433C8;
        Fri, 16 Jun 2023 17:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686935976;
        bh=izUWeimYW0VtDZKEmK1uRbEa8GtfMvMQIO+2l5M06so=;
        h=Date:To:From:Subject:From;
        b=un+rj0emAR06Pb8jYgeo8OnDJorHfl+WHYzdTflhyDv27joyY9I6McKvPtW4dQpf0
         Wk6qjGOuecjyXXszuKoxHQlOXxMZa39QFCRx5YIiBHVy9/weQprpd7MPts14rcqJ4a
         o7upqrgpESu4Gp9wf73XX6/EqvFLgdzXXC9xKQcM=
Date:   Fri, 16 Jun 2023 10:19:35 -0700
To:     mm-commits@vger.kernel.org, npiggin@gmail.com, mpe@ellerman.id.au,
        dianders@chromium.org, davem@davemloft.net,
        christophe.leroy@csgroup.eu, pmladek@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-hardlockup-sort-hardlockup-detector-related-config-values-a-logical-way.patch added to mm-nonmm-unstable branch
Message-Id: <20230616171936.11926C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog/hardlockup: sort hardlockup detector related config values a logical way
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-hardlockup-sort-hardlockup-detector-related-config-values-a-logical-way.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-hardlockup-sort-hardlockup-detector-related-config-values-a-logical-way.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: watchdog/hardlockup: sort hardlockup detector related config values a logical way
Date: Fri, 16 Jun 2023 17:06:13 +0200

Patch series "watchdog/hardlockup: Cleanup configuration of hardlockup
detectors", v2.

Clean up watchdog Kconfig after introducing the buddy detector.


This patch (of 6):

There are four possible variants of hardlockup detectors:

  + buddy: available when SMP is set.

  + perf: available when HAVE_HARDLOCKUP_DETECTOR_PERF is set.

  + arch-specific: available when HAVE_HARDLOCKUP_DETECTOR_ARCH is set.

  + sparc64 special variant: available when HAVE_NMI_WATCHDOG is set
	and HAVE_HARDLOCKUP_DETECTOR_ARCH is not set.

Only one hardlockup detector can be compiled in. The selection is done
using quite complex dependencies between several CONFIG variables.
The following patches will try to make it more straightforward.

As a first step, reorder the definitions of the various CONFIG variables.
The logical order is:

   1. HAVE_* variables define available variants. They are typically
      defined in the arch/ config files.

   2. HARDLOCKUP_DETECTOR y/n variable defines whether the hardlockup
      detector is enabled at all.

   3. HARDLOCKUP_DETECTOR_PREFER_BUDDY y/n variable defines whether
      the buddy detector should be preferred over the perf one.
      Note that the arch specific variants are always preferred when
      available.

   4. HARDLOCKUP_DETECTOR_PERF/BUDDY variables define whether the given
      detector is enabled in the end.

   5. HAVE_HARDLOCKUP_DETECTOR_NON_ARCH and HARDLOCKUP_DETECTOR_NON_ARCH
      are temporary variables that are going to be removed in
      a followup patch.

This is a preparation step for further cleanup. It will change the logic
without shuffling the definitions.

This change temporary breaks the C-like ordering where the variables are
declared or defined before they are used. It is not really needed for
Kconfig. Also the following patches will rework the logic so that
the ordering will be C-like in the end.

The patch just shuffles the definitions. It should not change the existing
behavior.

Link: https://lkml.kernel.org/r/20230616150618.6073-1-pmladek@suse.com
Link: https://lkml.kernel.org/r/20230616150618.6073-2-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |   78 ++++++++++++++++++++++----------------------
 1 file changed, 39 insertions(+), 39 deletions(-)

--- a/lib/Kconfig.debug~watchdog-hardlockup-sort-hardlockup-detector-related-config-values-a-logical-way
+++ a/lib/Kconfig.debug
@@ -1035,11 +1035,39 @@ config BOOTPARAM_SOFTLOCKUP_PANIC
 
 	  Say N if unsure.
 
-# Both the "perf" and "buddy" hardlockup detectors count hrtimer
-# interrupts. This config enables functions managing this common code.
-config HARDLOCKUP_DETECTOR_COUNTS_HRTIMER
-	bool
-	select SOFTLOCKUP_DETECTOR
+#
+# arch/ can define HAVE_HARDLOCKUP_DETECTOR_ARCH to provide their own hard
+# lockup detector rather than the perf based detector.
+#
+config HARDLOCKUP_DETECTOR
+	bool "Detect Hard Lockups"
+	depends on DEBUG_KERNEL && !S390
+	depends on HAVE_HARDLOCKUP_DETECTOR_NON_ARCH || HAVE_HARDLOCKUP_DETECTOR_ARCH
+	select LOCKUP_DETECTOR
+	select HARDLOCKUP_DETECTOR_NON_ARCH if HAVE_HARDLOCKUP_DETECTOR_NON_ARCH
+
+	help
+	  Say Y here to enable the kernel to act as a watchdog to detect
+	  hard lockups.
+
+	  Hardlockups are bugs that cause the CPU to loop in kernel mode
+	  for more than 10 seconds, without letting other interrupts have a
+	  chance to run.  The current stack trace is displayed upon detection
+	  and the system will stay locked up.
+
+config HARDLOCKUP_DETECTOR_PREFER_BUDDY
+	bool "Prefer the buddy CPU hardlockup detector"
+	depends on HAVE_HARDLOCKUP_DETECTOR_PERF && SMP
+	help
+	  Say Y here to prefer the buddy hardlockup detector over the perf one.
+
+	  With the buddy detector, each CPU uses its softlockup hrtimer
+	  to check that the next CPU is processing hrtimer interrupts by
+	  verifying that a counter is increasing.
+
+	  This hardlockup detector is useful on systems that don't have
+	  an arch-specific hardlockup detector or if resources needed
+	  for the hardlockup detector are better used for other things.
 
 config HARDLOCKUP_DETECTOR_PERF
 	bool
@@ -1051,6 +1079,12 @@ config HARDLOCKUP_DETECTOR_BUDDY
 	depends on SMP
 	select HARDLOCKUP_DETECTOR_COUNTS_HRTIMER
 
+# Both the "perf" and "buddy" hardlockup detectors count hrtimer
+# interrupts. This config enables functions managing this common code.
+config HARDLOCKUP_DETECTOR_COUNTS_HRTIMER
+	bool
+	select SOFTLOCKUP_DETECTOR
+
 # For hardlockup detectors you can have one directly provided by the arch
 # or use a "non-arch" one. If you're using a "non-arch" one that is
 # further divided the perf hardlockup detector (which, confusingly, needs
@@ -1063,20 +1097,6 @@ config HAVE_HARDLOCKUP_DETECTOR_NON_ARCH
 	depends on (HAVE_HARDLOCKUP_DETECTOR_PERF || SMP) && !HAVE_NMI_WATCHDOG
 	default y
 
-config HARDLOCKUP_DETECTOR_PREFER_BUDDY
-	bool "Prefer the buddy CPU hardlockup detector"
-	depends on HAVE_HARDLOCKUP_DETECTOR_PERF && SMP
-	help
-	  Say Y here to prefer the buddy hardlockup detector over the perf one.
-
-	  With the buddy detector, each CPU uses its softlockup hrtimer
-	  to check that the next CPU is processing hrtimer interrupts by
-	  verifying that a counter is increasing.
-
-	  This hardlockup detector is useful on systems that don't have
-	  an arch-specific hardlockup detector or if resources needed
-	  for the hardlockup detector are better used for other things.
-
 # This will select the appropriate non-arch hardlockdup detector
 config HARDLOCKUP_DETECTOR_NON_ARCH
 	bool
@@ -1091,26 +1111,6 @@ config HARDLOCKUP_DETECTOR_NON_ARCH
 config HARDLOCKUP_CHECK_TIMESTAMP
 	bool
 
-#
-# arch/ can define HAVE_HARDLOCKUP_DETECTOR_ARCH to provide their own hard
-# lockup detector rather than the perf based detector.
-#
-config HARDLOCKUP_DETECTOR
-	bool "Detect Hard Lockups"
-	depends on DEBUG_KERNEL && !S390
-	depends on HAVE_HARDLOCKUP_DETECTOR_NON_ARCH || HAVE_HARDLOCKUP_DETECTOR_ARCH
-	select LOCKUP_DETECTOR
-	select HARDLOCKUP_DETECTOR_NON_ARCH if HAVE_HARDLOCKUP_DETECTOR_NON_ARCH
-
-	help
-	  Say Y here to enable the kernel to act as a watchdog to detect
-	  hard lockups.
-
-	  Hardlockups are bugs that cause the CPU to loop in kernel mode
-	  for more than 10 seconds, without letting other interrupts have a
-	  chance to run.  The current stack trace is displayed upon detection
-	  and the system will stay locked up.
-
 config BOOTPARAM_HARDLOCKUP_PANIC
 	bool "Panic (Reboot) On Hard Lockups"
 	depends on HARDLOCKUP_DETECTOR
_

Patches currently in -mm which might be from pmladek@suse.com are

watchdog-hardlockup-sort-hardlockup-detector-related-config-values-a-logical-way.patch
watchdog-hardlockup-make-the-config-checks-more-straightforward.patch
watchdog-hardlockup-declare-arch_touch_nmi_watchdog-only-in-linux-nmih.patch
watchdog-hardlockup-make-have_nmi_watchdog-sparc64-specific.patch
watchdog-sparc64-define-hardlockup_detector_sparc64.patch
watchdog-hardlockup-define-hardlockup_detector_arch.patch

