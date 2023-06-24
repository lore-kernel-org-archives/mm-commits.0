Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E418C0015E
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbjFXAEf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjFXAEe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:04:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409132126
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:04:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D40FD6155C
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399BAC433C8;
        Sat, 24 Jun 2023 00:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687565072;
        bh=6PrNzWcOLZKlILG98OkAZbZ2SJGADXMiamAmGesbWcQ=;
        h=Date:To:From:Subject:From;
        b=iOLQuCVDgTb6DOh7hykp7uj2jE5BraoiXSPNviq/XiRIiBb/vJ/SXT9UYCTZmiboU
         rFNKFHkYN71C3VU/3kFF/Q1XjuU/HMIeCStGlmEPmNLbQ58LnxB+leXWKD2lBjTbE+
         X82DUX4OEwklCy4QhumE3/t8viV3MjOSUNq6VUcg=
Date:   Fri, 23 Jun 2023 17:04:31 -0700
To:     mm-commits@vger.kernel.org, trix@redhat.com, sfr@canb.auug.org.au,
        pmladek@suse.com, npiggin@gmail.com, mpe@ellerman.id.au,
        ldufour@linux.ibm.com, christophe.leroy@csgroup.eu, arnd@arndb.de,
        dianders@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] powerpc-move-arch_trigger_cpumask_backtrace-from-nmih-to-irqh.patch removed from -mm tree
Message-Id: <20230624000432.399BAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerpc: move arch_trigger_cpumask_backtrace from nmi.h to irq.h
has been removed from the -mm tree.  Its filename was
     powerpc-move-arch_trigger_cpumask_backtrace-from-nmih-to-irqh.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: powerpc: move arch_trigger_cpumask_backtrace from nmi.h to irq.h
Date: Wed, 21 Jun 2023 16:48:19 -0700

The powerpc architecture was the only one that defined
arch_trigger_cpumask_backtrace() in asm/nmi.h instead of
asm/irq.h. Move it to be consistent.

This fixes compile time errors introduced by commit 7ca8fe94aa92
("watchdog/hardlockup: define HARDLOCKUP_DETECTOR_ARCH"). That commit
caused <asm/nmi.h> to stop being included if the hardlockup detector
wasn't enabled. The specific errors were:
  error: implicit declaration of function `nmi_cpu_backtrace'
  error: implicit declaration of function `nmi_trigger_cpumask_backtrace'

NOTE: when moving this into irq.h, we also change the guards from just
checking if "CONFIG_NMI_IPI" is defined to also checking if
"CONFIG_PPC_BOOK3S_64" is defined. This matches the code in
arch/powerpc/kernel/stacktrace.c. Previously this worked because
<asm.nmi.h> was included if "CONFIG_HAVE_HARDLOCKUP_DETECTOR_ARCH" was
defined. For powerpc that's only selected if "CONFIG_PPC_BOOK3S_64" is
defined.

[dianders@chromium.org: change the guards to include CONFIG_PPC_BOOK3S_64]
  Link: https://lkml.kernel.org/r/20230622202816.v2.1.Ice67126857506712559078e7de26d32d26e64631@changeid
Link: https://lkml.kernel.org/r/20230621164809.1.Ice67126857506712559078e7de26d32d26e64631@changeid
Fixes: 7ca8fe94aa92 ("watchdog/hardlockup: define HARDLOCKUP_DETECTOR_ARCH")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Closes: https://lore.kernel.org/r/871qi5otdh.fsf@mail.lhotse
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/irq.h |    6 ++++++
 arch/powerpc/include/asm/nmi.h |    6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/powerpc/include/asm/irq.h~powerpc-move-arch_trigger_cpumask_backtrace-from-nmih-to-irqh
+++ a/arch/powerpc/include/asm/irq.h
@@ -53,5 +53,11 @@ void __do_IRQ(struct pt_regs *regs);
 
 int irq_choose_cpu(const struct cpumask *mask);
 
+#if defined(CONFIG_PPC_BOOK3S_64) && defined(CONFIG_NMI_IPI)
+extern void arch_trigger_cpumask_backtrace(const cpumask_t *mask,
+					   bool exclude_self);
+#define arch_trigger_cpumask_backtrace arch_trigger_cpumask_backtrace
+#endif
+
 #endif /* _ASM_IRQ_H */
 #endif /* __KERNEL__ */
--- a/arch/powerpc/include/asm/nmi.h~powerpc-move-arch_trigger_cpumask_backtrace-from-nmih-to-irqh
+++ a/arch/powerpc/include/asm/nmi.h
@@ -9,12 +9,6 @@ void watchdog_hardlockup_set_timeout_pct
 static inline void watchdog_hardlockup_set_timeout_pct(u64 pct) {}
 #endif
 
-#ifdef CONFIG_NMI_IPI
-extern void arch_trigger_cpumask_backtrace(const cpumask_t *mask,
-					   bool exclude_self);
-#define arch_trigger_cpumask_backtrace arch_trigger_cpumask_backtrace
-#endif
-
 extern void hv_nmi_check_nonrecoverable(struct pt_regs *regs);
 
 #endif /* _ASM_NMI_H */
_

Patches currently in -mm which might be from dianders@chromium.org are


