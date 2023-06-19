Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA6EEB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:28:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjFSX2Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjFSX2F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:28:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0F61BF6
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:26:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 845DA610A4
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0845C433C8;
        Mon, 19 Jun 2023 23:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217178;
        bh=104vleFe96uDovrrFepuyyqfkmPN70Ksx+//95GIvi8=;
        h=Date:To:From:Subject:From;
        b=KrxRgincBz9ZZvOe5wteDsiuIpWmMuj83Ne12eo3PsIvaGT/cFqvzgaJxWG0QuFmQ
         d4EQwD39EiSRYWepJcXDM4L+pmOyxDGGj05VRzuo355WY3BrB5bGt3WEm/sPPRI1ND
         9/tdQRx0rW/NiNNBomH5HaPjc85vUSrYIKvIshzs=
Date:   Mon, 19 Jun 2023 16:26:17 -0700
To:     mm-commits@vger.kernel.org, npiggin@gmail.com, mpe@ellerman.id.au,
        dianders@chromium.org, davem@davemloft.net,
        christophe.leroy@csgroup.eu, pmladek@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-hardlockup-sort-hardlockup-detector-related-config-values-a-logical-way.patch removed from -mm tree
Message-Id: <20230619232617.E0845C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: watchdog/hardlockup: sort hardlockup detector related config values a logical way
has been removed from the -mm tree.  Its filename was
     watchdog-hardlockup-sort-hardlockup-detector-related-config-values-a-logical-way.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


