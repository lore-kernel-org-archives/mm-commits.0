Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDEA0EB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjFSX2U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjFSX2D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:28:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4149B19AA
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:26:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB66761141
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33488C433C8;
        Mon, 19 Jun 2023 23:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217169;
        bh=U7HNKGfT3lXAsSSjHcl/8UiFpiR4h9+vzx9f1o+QG3s=;
        h=Date:To:From:Subject:From;
        b=WLbveXacIdmG0as2ux6vnT/Vx3hOpjZ1Oj/f7Ag5yocjvnvkAu5sbdU03jrOGdoei
         DKyYXvH3CJ2m3Ts8Q8Jx0D4evZz93umjwnI3XPJ0amYABApzLxbqPR52S/lXT6b7Pi
         yMYNi9/ot8ybJyjuLrHP8XqDhw967n0h5xwfgyQ8=
Date:   Mon, 19 Jun 2023 16:26:08 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com, npiggin@gmail.com,
        mpe@ellerman.id.au, davem@davemloft.net,
        christophe.leroy@csgroup.eu, dianders@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-hardlockup-have_nmi_watchdog-must-implement-watchdog_hardlockup_probe.patch removed from -mm tree
Message-Id: <20230619232609.33488C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: watchdog/hardlockup: HAVE_NMI_WATCHDOG must implement watchdog_hardlockup_probe()
has been removed from the -mm tree.  Its filename was
     watchdog-hardlockup-have_nmi_watchdog-must-implement-watchdog_hardlockup_probe.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


