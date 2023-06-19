Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54472EB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjFSX2Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjFSX2F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:28:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD7DE6E
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:26:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE49C61141
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6C5C433C8;
        Mon, 19 Jun 2023 23:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217180;
        bh=YfbzW8R+1+SI2CxSDXG9XejS1yy14RetQGB2XU+zQpg=;
        h=Date:To:From:Subject:From;
        b=zA1Kii26YKJtPpUFJCKguax6pEmFgnRUvRg9/zSf7jyoGWjYRma8bga7vQU5IzaXm
         toccIncihB6jQ68jh95u0QsngjBaiX9WbHjdEABmaMcex4qQgvlNJ101QxuKAjMvMt
         VwH/d/Hl9R89AEdje0q4ql/uQjEHQ146OdC8T7Kc=
Date:   Mon, 19 Jun 2023 16:26:19 -0700
To:     mm-commits@vger.kernel.org, npiggin@gmail.com, mpe@ellerman.id.au,
        dianders@chromium.org, davem@davemloft.net,
        christophe.leroy@csgroup.eu, pmladek@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-hardlockup-declare-arch_touch_nmi_watchdog-only-in-linux-nmih.patch removed from -mm tree
Message-Id: <20230619232620.2F6C5C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: watchdog/hardlockup: declare arch_touch_nmi_watchdog() only in linux/nmi.h
has been removed from the -mm tree.  Its filename was
     watchdog-hardlockup-declare-arch_touch_nmi_watchdog-only-in-linux-nmih.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: watchdog/hardlockup: declare arch_touch_nmi_watchdog() only in linux/nmi.h
Date: Fri, 16 Jun 2023 17:06:15 +0200

arch_touch_nmi_watchdog() needs a different implementation for various
hardlockup detector implementations. And it does nothing when
any hardlockup detector is not built at all.

arch_touch_nmi_watchdog() is declared via linux/nmi.h. And it must be
defined as an empty function when there is no hardlockup detector.
It is done directly in this header file for the perf and buddy detectors.
And it is done in the included asm/linux.h for arch specific detectors.

The reason probably is that the arch specific variants build the code
using another conditions. For example, powerpc64/sparc64 builds the code
when CONFIG_PPC_WATCHDOG is enabled.

Another reason might be that these architectures define more functions
in asm/nmi.h anyway.

However the generic code actually knows when the function will be
implemented. It happens when some full featured or the sparc64-specific
hardlockup detector is built.

In particular, CONFIG_HARDLOCKUP_DETECTOR can be enabled only when
a generic or arch-specific full featured hardlockup detector is available.
The only exception is sparc64 which can be built even when the global
HARDLOCKUP_DETECTOR switch is disabled.

The information about sparc64 is a bit complicated. The hardlockup
detector is built there when CONFIG_HAVE_NMI_WATCHDOG is set and
CONFIG_HAVE_HARDLOCKUP_DETECTOR_ARCH is not set.

People might wonder whether this change really makes things easier.
The motivation is:

  + The current logic in linux/nmi.h is far from obvious.
    For example, arch_touch_nmi_watchdog() is defined as {} when
    neither CONFIG_HARDLOCKUP_DETECTOR_COUNTS_HRTIMER nor
    CONFIG_HAVE_NMI_WATCHDOG is defined.

  + The change synchronizes the checks in lib/Kconfig.debug and
    in the generic code.

  + It is a step that will help cleaning HAVE_NMI_WATCHDOG related
    checks.

The change should not change the existing behavior.

Link: https://lkml.kernel.org/r/20230616150618.6073-4-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/nmi.h |    2 --
 arch/sparc/include/asm/nmi.h   |    1 -
 include/linux/nmi.h            |   13 ++++++++++---
 3 files changed, 10 insertions(+), 6 deletions(-)

--- a/arch/powerpc/include/asm/nmi.h~watchdog-hardlockup-declare-arch_touch_nmi_watchdog-only-in-linux-nmih
+++ a/arch/powerpc/include/asm/nmi.h
@@ -3,11 +3,9 @@
 #define _ASM_NMI_H
 
 #ifdef CONFIG_PPC_WATCHDOG
-extern void arch_touch_nmi_watchdog(void);
 long soft_nmi_interrupt(struct pt_regs *regs);
 void watchdog_hardlockup_set_timeout_pct(u64 pct);
 #else
-static inline void arch_touch_nmi_watchdog(void) {}
 static inline void watchdog_hardlockup_set_timeout_pct(u64 pct) {}
 #endif
 
--- a/arch/sparc/include/asm/nmi.h~watchdog-hardlockup-declare-arch_touch_nmi_watchdog-only-in-linux-nmih
+++ a/arch/sparc/include/asm/nmi.h
@@ -8,7 +8,6 @@ void nmi_adjust_hz(unsigned int new_hz);
 
 extern atomic_t nmi_active;
 
-void arch_touch_nmi_watchdog(void);
 void start_nmi_watchdog(void *unused);
 void stop_nmi_watchdog(void *unused);
 
--- a/include/linux/nmi.h~watchdog-hardlockup-declare-arch_touch_nmi_watchdog-only-in-linux-nmih
+++ a/include/linux/nmi.h
@@ -7,6 +7,8 @@
 
 #include <linux/sched.h>
 #include <asm/irq.h>
+
+/* Arch specific watchdogs might need to share extra watchdog-related APIs. */
 #if defined(CONFIG_HAVE_NMI_WATCHDOG)
 #include <asm/nmi.h>
 #endif
@@ -87,12 +89,17 @@ extern unsigned int hardlockup_panic;
 static inline void hardlockup_detector_disable(void) {}
 #endif
 
-#if defined(CONFIG_HARDLOCKUP_DETECTOR_COUNTS_HRTIMER)
+/* Sparc64 has special implemetantion that is always enabled. */
+#if defined(CONFIG_HARDLOCKUP_DETECTOR) || \
+    (defined(CONFIG_HAVE_NMI_WATCHDOG) && !defined(CONFIG_HAVE_HARDLOCKUP_DETECTOR_ARCH))
 void arch_touch_nmi_watchdog(void);
+#else
+static inline void arch_touch_nmi_watchdog(void) { }
+#endif
+
+#if defined(CONFIG_HARDLOCKUP_DETECTOR_COUNTS_HRTIMER)
 void watchdog_hardlockup_touch_cpu(unsigned int cpu);
 void watchdog_hardlockup_check(unsigned int cpu, struct pt_regs *regs);
-#elif !defined(CONFIG_HAVE_NMI_WATCHDOG)
-static inline void arch_touch_nmi_watchdog(void) { }
 #endif
 
 #if defined(CONFIG_HARDLOCKUP_DETECTOR_PERF)
_

Patches currently in -mm which might be from pmladek@suse.com are


