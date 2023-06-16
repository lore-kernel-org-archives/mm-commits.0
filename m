Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79B6AEB64DB
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jun 2023 17:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbjFPRT5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Jun 2023 13:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346174AbjFPRTv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2023 13:19:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82E02103
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 10:19:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 557BB6237B
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 17:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE28EC433C0;
        Fri, 16 Jun 2023 17:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686935988;
        bh=de8VBuIsWREqaLbpBc3Uk2Xd9iEo6PxA3M7NwxQqYh8=;
        h=Date:To:From:Subject:From;
        b=ReLF0F+P1KhZEZGXY7QwOLe7Wi9qm4jQCUqdTBaIQx0Ls7PHQxbRZdi9yrVq9FDxl
         aSMJoPDsyNVEWfAjAP2MB3Dcu17w/1ZjMzSq5B2hC1BggYu9uKIeMhQpVQ2YkolRfM
         SnM4YIHnmQ9Hdq6Hf1juyLoeWtjpKXBnEjywOZF4=
Date:   Fri, 16 Jun 2023 10:19:48 -0700
To:     mm-commits@vger.kernel.org, npiggin@gmail.com, mpe@ellerman.id.au,
        dianders@chromium.org, davem@davemloft.net,
        christophe.leroy@csgroup.eu, pmladek@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-hardlockup-define-hardlockup_detector_arch.patch added to mm-nonmm-unstable branch
Message-Id: <20230616171948.AE28EC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog/hardlockup: define HARDLOCKUP_DETECTOR_ARCH
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-hardlockup-define-hardlockup_detector_arch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-hardlockup-define-hardlockup_detector_arch.patch

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
Subject: watchdog/hardlockup: define HARDLOCKUP_DETECTOR_ARCH
Date: Fri, 16 Jun 2023 17:06:18 +0200

The HAVE_ prefix means that the code could be enabled. Add another
variable for HAVE_HARDLOCKUP_DETECTOR_ARCH without this prefix.
It will be set when it should be built. It will make it compatible
with the other hardlockup detectors.

The change allows to clean up dependencies of PPC_WATCHDOG
and HAVE_HARDLOCKUP_DETECTOR_PERF definitions for powerpc.

As a result HAVE_HARDLOCKUP_DETECTOR_PERF has the same dependencies
on arm, x86, powerpc architectures.

Link: https://lkml.kernel.org/r/20230616150618.6073-7-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |    5 ++---
 include/linux/nmi.h  |    2 +-
 lib/Kconfig.debug    |    9 +++++++++
 3 files changed, 12 insertions(+), 4 deletions(-)

--- a/arch/powerpc/Kconfig~watchdog-hardlockup-define-hardlockup_detector_arch
+++ a/arch/powerpc/Kconfig
@@ -90,8 +90,7 @@ config NMI_IPI
 
 config PPC_WATCHDOG
 	bool
-	depends on HARDLOCKUP_DETECTOR
-	depends on HAVE_HARDLOCKUP_DETECTOR_ARCH
+	depends on HARDLOCKUP_DETECTOR_ARCH
 	default y
 	help
 	  This is a placeholder when the powerpc hardlockup detector
@@ -240,7 +239,7 @@ config PPC
 	select HAVE_GCC_PLUGINS			if GCC_VERSION >= 50200   # plugin support on gcc <= 5.1 is buggy on PPC
 	select HAVE_GENERIC_VDSO
 	select HAVE_HARDLOCKUP_DETECTOR_ARCH	if PPC_BOOK3S_64 && SMP
-	select HAVE_HARDLOCKUP_DETECTOR_PERF	if PERF_EVENTS && HAVE_PERF_EVENTS_NMI && !HAVE_HARDLOCKUP_DETECTOR_ARCH
+	select HAVE_HARDLOCKUP_DETECTOR_PERF	if PERF_EVENTS && HAVE_PERF_EVENTS_NMI
 	select HAVE_HW_BREAKPOINT		if PERF_EVENTS && (PPC_BOOK3S || PPC_8xx)
 	select HAVE_IOREMAP_PROT
 	select HAVE_IRQ_TIME_ACCOUNTING
--- a/include/linux/nmi.h~watchdog-hardlockup-define-hardlockup_detector_arch
+++ a/include/linux/nmi.h
@@ -9,7 +9,7 @@
 #include <asm/irq.h>
 
 /* Arch specific watchdogs might need to share extra watchdog-related APIs. */
-#if defined(CONFIG_HAVE_HARDLOCKUP_DETECTOR_ARCH) || defined(CONFIG_HARDLOCKUP_DETECTOR_SPARC64)
+#if defined(CONFIG_HARDLOCKUP_DETECTOR_ARCH) || defined(CONFIG_HARDLOCKUP_DETECTOR_SPARC64)
 #include <asm/nmi.h>
 #endif
 
--- a/lib/Kconfig.debug~watchdog-hardlockup-define-hardlockup_detector_arch
+++ a/lib/Kconfig.debug
@@ -1056,6 +1056,7 @@ config HARDLOCKUP_DETECTOR
 	depends on HAVE_HARDLOCKUP_DETECTOR_PERF || HAVE_HARDLOCKUP_DETECTOR_BUDDY || HAVE_HARDLOCKUP_DETECTOR_ARCH
 	imply HARDLOCKUP_DETECTOR_PERF
 	imply HARDLOCKUP_DETECTOR_BUDDY
+	imply HARDLOCKUP_DETECTOR_ARCH
 	select LOCKUP_DETECTOR
 
 	help
@@ -1101,6 +1102,14 @@ config HARDLOCKUP_DETECTOR_BUDDY
 	depends on !HAVE_HARDLOCKUP_DETECTOR_ARCH
 	select HARDLOCKUP_DETECTOR_COUNTS_HRTIMER
 
+config HARDLOCKUP_DETECTOR_ARCH
+	bool
+	depends on HARDLOCKUP_DETECTOR
+	depends on HAVE_HARDLOCKUP_DETECTOR_ARCH
+	help
+	  The arch-specific implementation of the hardlockup detector will
+	  be used.
+
 #
 # Both the "perf" and "buddy" hardlockup detectors count hrtimer
 # interrupts. This config enables functions managing this common code.
_

Patches currently in -mm which might be from pmladek@suse.com are

watchdog-hardlockup-sort-hardlockup-detector-related-config-values-a-logical-way.patch
watchdog-hardlockup-make-the-config-checks-more-straightforward.patch
watchdog-hardlockup-declare-arch_touch_nmi_watchdog-only-in-linux-nmih.patch
watchdog-hardlockup-make-have_nmi_watchdog-sparc64-specific.patch
watchdog-sparc64-define-hardlockup_detector_sparc64.patch
watchdog-hardlockup-define-hardlockup_detector_arch.patch

