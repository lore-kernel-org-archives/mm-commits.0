Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 110DDEB64D7
	for <mm-commits@archiver.kernel.org>; Thu, 22 Jun 2023 00:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjFVAa0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jun 2023 20:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjFVAaZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jun 2023 20:30:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7FE1A1
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 17:30:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23D7261703
        for <mm-commits@vger.kernel.org>; Thu, 22 Jun 2023 00:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F52C433C0;
        Thu, 22 Jun 2023 00:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687393823;
        bh=4c95DrvBXWUhpTOCQxQrVJT207VaZEAIY5VeSptgQCg=;
        h=Date:To:From:Subject:From;
        b=OJA0n78/Ouz+aSWsH6omI8TztW5eeVtTfdY5CllkgFdYPEQ6LUeAnki61pl0kUJiP
         RaaF7k4e3N2JlMekEWkgGPRNnDPvYtMGnNuYEw5MoKnGLVwzUHl2f+sle7zRJVZ+3v
         Ln8veVXRLLbtMUQx8KMR5+rWhBeSA0FZhaJyrl9k=
Date:   Wed, 21 Jun 2023 17:30:22 -0700
To:     mm-commits@vger.kernel.org, trix@redhat.com, sfr@canb.auug.org.au,
        pmladek@suse.com, npiggin@gmail.com, mpe@ellerman.id.au,
        ldufour@linux.ibm.com, christophe.leroy@csgroup.eu, arnd@arndb.de,
        dianders@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-move-arch_trigger_cpumask_backtrace-from-nmih-to-irqh.patch added to mm-nonmm-unstable branch
Message-Id: <20230622003023.69F52C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: move arch_trigger_cpumask_backtrace from nmi.h to irq.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     powerpc-move-arch_trigger_cpumask_backtrace-from-nmih-to-irqh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-move-arch_trigger_cpumask_backtrace-from-nmih-to-irqh.patch

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
Subject: powerpc: move arch_trigger_cpumask_backtrace from nmi.h to irq.h
Date: Wed, 21 Jun 2023 16:48:19 -0700

The powerpc architecture was the only one that defined
arch_trigger_cpumask_backtrace() in asm/nmi.h instead of asm/irq.h.  Move
it to be consistent.

This fixes compile time errors introduced by commit 7ca8fe94aa92
("watchdog/hardlockup: define HARDLOCKUP_DETECTOR_ARCH"). That commit
caused <asm/nmi.h> to stop being included if the hardlockup detector
wasn't enabled. The specific errors were:
  error: implicit declaration of function `nmi_cpu_backtrace'
  error: implicit declaration of function `nmi_trigger_cpumask_backtrace'

Link: https://lkml.kernel.org/r/20230621164809.1.Ice67126857506712559078e7de26d32d26e64631@changeid
Fixes: 7ca8fe94aa92 ("watchdog/hardlockup: define HARDLOCKUP_DETECTOR_ARCH")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Closes: https://lore.kernel.org/r/871qi5otdh.fsf@mail.lhotse
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>
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
 
+#ifdef CONFIG_NMI_IPI
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

powerpc-move-arch_trigger_cpumask_backtrace-from-nmih-to-irqh.patch

