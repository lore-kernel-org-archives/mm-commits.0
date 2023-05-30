Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EEA6C7EE24
	for <mm-commits@archiver.kernel.org>; Tue, 30 May 2023 22:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbjE3W0P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 May 2023 18:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjE3W0P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2023 18:26:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FF697
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 15:26:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F72063446
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 22:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56BFC433D2;
        Tue, 30 May 2023 22:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685485573;
        bh=jvRxqCRRzdvdGa90aRZabxb3wvioLnCv8Ox1IGpnd8E=;
        h=Date:To:From:Subject:From;
        b=dipa+YaXWCZO1JfaU9oBCEFaOBU6c3p0nZ/SP2wZMh277uKWdz65l0ZsKD/MTxFn6
         vcJkLZMBF6KO34q+khnrSLRXoPvDyRbyqBuTdhqbZG71YqAVnDfIbRFlv2xlWhEEgF
         Dk406MuaOf+pu9XP1OkhMeC0n2bTTOppBDOFBLKk=
Date:   Tue, 30 May 2023 15:26:12 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com, npiggin@gmail.com,
        mpe@ellerman.id.au, davem@davemloft.net,
        christophe.leroy@csgroup.eu, dianders@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-hardlockup-have_nmi_watchdog-must-implement-watchdog_hardlockup_probe.patch added to mm-nonmm-unstable branch
Message-Id: <20230530222612.E56BFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog/hardlockup: HAVE_NMI_WATCHDOG must implement watchdog_hardlockup_probe()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-hardlockup-have_nmi_watchdog-must-implement-watchdog_hardlockup_probe.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-hardlockup-have_nmi_watchdog-must-implement-watchdog_hardlockup_probe.patch

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
From: Douglas Anderson <dianders@chromium.org>
Subject: watchdog/hardlockup: HAVE_NMI_WATCHDOG must implement watchdog_hardlockup_probe()
Date: Fri, 26 May 2023 18:41:32 -0700

Right now there is one arch (sparc64) that selects HAVE_NMI_WATCHDOG
without selecting HAVE_HARDLOCKUP_DETECTOR_ARCH.  Because of that one
architecture, we have some special case code in the watchdog core to
handle the fact that watchdog_hardlockup_probe() isn't implemented.

Let's implement watchdog_hardlockup_probe() for sparc64 and get rid of the
special case.

As a side effect of doing this, code inspection tells us that we could fix
a minor bug where the system won't properly realize that NMI watchdogs are
disabled.  Specifically, on powerpc if CONFIG_PPC_WATCHDOG is turned off
the arch might still select CONFIG_HAVE_HARDLOCKUP_DETECTOR_ARCH which
selects CONFIG_HAVE_NMI_WATCHDOG.  Since CONFIG_PPC_WATCHDOG was off then
nothing will override the "weak" watchdog_hardlockup_probe() and we'll
fallback to looking at CONFIG_HAVE_NMI_WATCHDOG.

Link: https://lkml.kernel.org/r/20230526184139.2.Ic6ebbf307ca0efe91f08ce2c1eb4a037ba6b0700@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Suggested-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig            |    3 ++-
 arch/sparc/kernel/nmi.c |    5 +++++
 kernel/watchdog.c       |   13 -------------
 3 files changed, 7 insertions(+), 14 deletions(-)

--- a/arch/Kconfig~watchdog-hardlockup-have_nmi_watchdog-must-implement-watchdog_hardlockup_probe
+++ a/arch/Kconfig
@@ -405,7 +405,8 @@ config HAVE_NMI_WATCHDOG
 	bool
 	help
 	  The arch provides a low level NMI watchdog. It provides
-	  asm/nmi.h, and defines its own arch_touch_nmi_watchdog().
+	  asm/nmi.h, and defines its own watchdog_hardlockup_probe() and
+	  arch_touch_nmi_watchdog().
 
 config HAVE_HARDLOCKUP_DETECTOR_ARCH
 	bool
--- a/arch/sparc/kernel/nmi.c~watchdog-hardlockup-have_nmi_watchdog-must-implement-watchdog_hardlockup_probe
+++ a/arch/sparc/kernel/nmi.c
@@ -65,6 +65,11 @@ void arch_touch_nmi_watchdog(void)
 }
 EXPORT_SYMBOL(arch_touch_nmi_watchdog);
 
+int __init watchdog_hardlockup_probe(void)
+{
+	return 0;
+}
+
 static void die_nmi(const char *str, struct pt_regs *regs, int do_panic)
 {
 	int this_cpu = smp_processor_id();
--- a/kernel/watchdog.c~watchdog-hardlockup-have_nmi_watchdog-must-implement-watchdog_hardlockup_probe
+++ a/kernel/watchdog.c
@@ -217,19 +217,6 @@ void __weak watchdog_hardlockup_disable(
  */
 int __weak __init watchdog_hardlockup_probe(void)
 {
-	/*
-	 * If CONFIG_HAVE_NMI_WATCHDOG is defined then an architecture
-	 * is assumed to have the hard watchdog available and we return 0.
-	 */
-	if (IS_ENABLED(CONFIG_HAVE_NMI_WATCHDOG))
-		return 0;
-
-	/*
-	 * Hardlockup detectors other than those using CONFIG_HAVE_NMI_WATCHDOG
-	 * are required to implement a non-weak version of this probe function
-	 * to tell whether they are available. If they don't override then
-	 * we'll return -ENODEV.
-	 */
 	return -ENODEV;
 }
 
_

Patches currently in -mm which might be from dianders@chromium.org are

migrate_pages-avoid-blocking-for-io-in-migrate_sync_light.patch
watchdog-perf-define-dummy-watchdog_update_hrtimer_threshold-on-correct-config.patch
watchdog-perf-more-properly-prevent-false-positives-with-turbo-modes.patch
watchdog-hardlockup-add-comments-to-touch_nmi_watchdog.patch
watchdog-perf-rename-watchdog_hldc-to-watchdog_perfc.patch
watchdog-hardlockup-move-perf-hardlockup-checking-panic-to-common-watchdogc.patch
watchdog-hardlockup-style-changes-to-watchdog_hardlockup_check-is_hardlockup.patch
watchdog-hardlockup-add-a-cpu-param-to-watchdog_hardlockup_check.patch
watchdog-hardlockup-move-perf-hardlockup-watchdog-petting-to-watchdogc.patch
watchdog-hardlockup-rename-some-nmi-watchdog-constants-function.patch
watchdog-hardlockup-have-the-perf-hardlockup-use-__weak-functions-more-cleanly.patch
watchdog-hardlockup-detect-hard-lockups-using-secondary-buddy-cpus.patch
watchdog-perf-add-a-weak-function-for-an-arch-to-detect-if-perf-can-use-nmis.patch
arm64-enable-perf-events-based-hard-lockup-detector.patch
arm64-enable-perf-events-based-hard-lockup-detector-fix.patch
watchdog-hardlockup-keep-kernelnmi_watchdog-sysctl-as-0444-if-probe-fails.patch
watchdog-hardlockup-have_nmi_watchdog-must-implement-watchdog_hardlockup_probe.patch
watchdog-hardlockup-dont-use-raw_cpu_ptr-in-watchdog_hardlockup_kick.patch
watchdog-hardlockup-in-watchdog_hardlockup_check-use-cpumask_copy.patch
watchdog-hardlockup-remove-softlockup-comment-in-touch_nmi_watchdog.patch
watchdog-buddy-cleanup-how-watchdog_buddy_check_hardlockup-is-called.patch
watchdog-buddy-dont-copy-the-cpumask-in-watchdog_next_cpu.patch
watchdog-buddy-simplify-the-dependency-for-hardlockup_detector_prefer_buddy.patch
watchdog-hardlockup-move-smp-barriers-from-common-code-to-buddy-code.patch
watchdog-hardlockup-rename-have_hardlockup_detector_non_arch-to-_perf_or_buddy.patch

