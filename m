Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECC96EB64DA
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jun 2023 17:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbjFPRT7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Jun 2023 13:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346169AbjFPRTs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2023 13:19:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242FB1FEC
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 10:19:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A98A361B79
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 17:19:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0895BC433C8;
        Fri, 16 Jun 2023 17:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686935986;
        bh=LrFA5Dg5H+laThmPVyahMf53+AHao1MCRDFyM1C42c8=;
        h=Date:To:From:Subject:From;
        b=NrCaAc4ckhDElgOOkkAW6J1UG7ykPXr0Pq2FmF1OVNEe/TVo6Kjmu9ilcghBKITUn
         6N9Qi/WEsJGxNMBgRwWBUzL9fdi3AW1KpxdS9Z1S/q5qtw9S6mGtP3g/0FojeM0kVD
         atfFwDZN85Sz+3T55HLRW8hD/IPDKSES8NQZYRJQ=
Date:   Fri, 16 Jun 2023 10:19:45 -0700
To:     mm-commits@vger.kernel.org, npiggin@gmail.com, mpe@ellerman.id.au,
        dianders@chromium.org, davem@davemloft.net,
        christophe.leroy@csgroup.eu, pmladek@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-sparc64-define-hardlockup_detector_sparc64.patch added to mm-nonmm-unstable branch
Message-Id: <20230616171946.0895BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog/sparc64: define HARDLOCKUP_DETECTOR_SPARC64
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-sparc64-define-hardlockup_detector_sparc64.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-sparc64-define-hardlockup_detector_sparc64.patch

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
Subject: watchdog/sparc64: define HARDLOCKUP_DETECTOR_SPARC64
Date: Fri, 16 Jun 2023 17:06:17 +0200

The HAVE_ prefix means that the code could be enabled. Add another
variable for HAVE_HARDLOCKUP_DETECTOR_SPARC64 without this prefix.
It will be set when it should be built. It will make it compatible
with the other hardlockup detectors.

Before, it is far from obvious that the SPARC64 variant is actually used:

$> make ARCH=sparc64 defconfig
$> grep HARDLOCKUP_DETECTOR .config
CONFIG_HAVE_HARDLOCKUP_DETECTOR_BUDDY=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_SPARC64=y

After, it is more clear:

$> make ARCH=sparc64 defconfig
$> grep HARDLOCKUP_DETECTOR .config
CONFIG_HAVE_HARDLOCKUP_DETECTOR_BUDDY=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_SPARC64=y
CONFIG_HARDLOCKUP_DETECTOR_SPARC64=y

Link: https://lkml.kernel.org/r/20230616150618.6073-6-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/Kconfig.debug |    7 ++++++-
 include/linux/nmi.h      |    4 ++--
 kernel/watchdog.c        |    2 +-
 lib/Kconfig.debug        |    2 +-
 4 files changed, 10 insertions(+), 5 deletions(-)

--- a/arch/sparc/Kconfig.debug~watchdog-sparc64-define-hardlockup_detector_sparc64
+++ a/arch/sparc/Kconfig.debug
@@ -16,10 +16,15 @@ config FRAME_POINTER
 	default y
 
 config HAVE_HARDLOCKUP_DETECTOR_SPARC64
-	depends on HAVE_NMI
 	bool
+	depends on HAVE_NMI
+	select HARDLOCKUP_DETECTOR_SPARC64
 	help
 	  Sparc64 hardlockup detector is the last one developed before adding
 	  the common infrastructure for handling hardlockup detectors. It is
 	  always built. It does _not_ use the common command line parameters
 	  and sysctl interface, except for /proc/sys/kernel/nmi_watchdog.
+
+config HARDLOCKUP_DETECTOR_SPARC64
+	bool
+	depends on HAVE_HARDLOCKUP_DETECTOR_SPARC64
--- a/include/linux/nmi.h~watchdog-sparc64-define-hardlockup_detector_sparc64
+++ a/include/linux/nmi.h
@@ -9,7 +9,7 @@
 #include <asm/irq.h>
 
 /* Arch specific watchdogs might need to share extra watchdog-related APIs. */
-#if defined(CONFIG_HAVE_HARDLOCKUP_DETECTOR_ARCH) || defined(CONFIG_HAVE_HARDLOCKUP_DETECTOR_SPARC64)
+#if defined(CONFIG_HAVE_HARDLOCKUP_DETECTOR_ARCH) || defined(CONFIG_HARDLOCKUP_DETECTOR_SPARC64)
 #include <asm/nmi.h>
 #endif
 
@@ -90,7 +90,7 @@ static inline void hardlockup_detector_d
 #endif
 
 /* Sparc64 has special implemetantion that is always enabled. */
-#if defined(CONFIG_HARDLOCKUP_DETECTOR) || defined(CONFIG_HAVE_HARDLOCKUP_DETECTOR_SPARC64)
+#if defined(CONFIG_HARDLOCKUP_DETECTOR) || defined(CONFIG_HARDLOCKUP_DETECTOR_SPARC64)
 void arch_touch_nmi_watchdog(void);
 #else
 static inline void arch_touch_nmi_watchdog(void) { }
--- a/kernel/watchdog.c~watchdog-sparc64-define-hardlockup_detector_sparc64
+++ a/kernel/watchdog.c
@@ -29,7 +29,7 @@
 
 static DEFINE_MUTEX(watchdog_mutex);
 
-#if defined(CONFIG_HARDLOCKUP_DETECTOR) || defined(CONFIG_HAVE_HARDLOCKUP_DETECTOR_SPARC64)
+#if defined(CONFIG_HARDLOCKUP_DETECTOR) || defined(CONFIG_HARDLOCKUP_DETECTOR_SPARC64)
 # define WATCHDOG_HARDLOCKUP_DEFAULT	1
 #else
 # define WATCHDOG_HARDLOCKUP_DEFAULT	0
--- a/lib/Kconfig.debug~watchdog-sparc64-define-hardlockup_detector_sparc64
+++ a/lib/Kconfig.debug
@@ -1052,7 +1052,7 @@ config HAVE_HARDLOCKUP_DETECTOR_BUDDY
 #
 config HARDLOCKUP_DETECTOR
 	bool "Detect Hard Lockups"
-	depends on DEBUG_KERNEL && !S390 && !HAVE_HARDLOCKUP_DETECTOR_SPARC64
+	depends on DEBUG_KERNEL && !S390 && !HARDLOCKUP_DETECTOR_SPARC64
 	depends on HAVE_HARDLOCKUP_DETECTOR_PERF || HAVE_HARDLOCKUP_DETECTOR_BUDDY || HAVE_HARDLOCKUP_DETECTOR_ARCH
 	imply HARDLOCKUP_DETECTOR_PERF
 	imply HARDLOCKUP_DETECTOR_BUDDY
_

Patches currently in -mm which might be from pmladek@suse.com are

watchdog-hardlockup-sort-hardlockup-detector-related-config-values-a-logical-way.patch
watchdog-hardlockup-make-the-config-checks-more-straightforward.patch
watchdog-hardlockup-declare-arch_touch_nmi_watchdog-only-in-linux-nmih.patch
watchdog-hardlockup-make-have_nmi_watchdog-sparc64-specific.patch
watchdog-sparc64-define-hardlockup_detector_sparc64.patch
watchdog-hardlockup-define-hardlockup_detector_arch.patch

