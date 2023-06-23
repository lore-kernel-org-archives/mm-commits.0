Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF30EB64D7
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jun 2023 03:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjFWDdC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Jun 2023 23:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjFWDdA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jun 2023 23:33:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213A710F4
        for <mm-commits@vger.kernel.org>; Thu, 22 Jun 2023 20:32:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D8F161938
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 03:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9307C433C0;
        Fri, 23 Jun 2023 03:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687491177;
        bh=UfPFRcopNyeJdr6laufjAGRM5RVwikL+KAq1OzyxRq4=;
        h=Date:To:From:Subject:From;
        b=mHHkSCX/3yaA/27D6JRXs2bgV6of5drEhui1M5rU7/c9HmF3QYWPnU6JqrJI/FeJy
         qSNW+YlR1gBVOmMv1WfRrY6EJApu/dzOJMKwpRtQmqvQVL7lhUIPK5nqNyfepIqim7
         084KSVZcXj22k2bKQcDq99cMSiGAM+0f2Ue2+VXQ=
Date:   Thu, 22 Jun 2023 20:32:57 -0700
To:     mm-commits@vger.kernel.org, trix@redhat.com, sfr@canb.auug.org.au,
        pmladek@suse.com, npiggin@gmail.com, mpe@ellerman.id.au,
        ldufour@linux.ibm.com, christophe.leroy@csgroup.eu, arnd@arndb.de,
        dianders@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-move-arch_trigger_cpumask_backtrace-from-nmih-to-irqh-v2.patch added to mm-nonmm-unstable branch
Message-Id: <20230623033257.B9307C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-move-arch_trigger_cpumask_backtrace-from-nmih-to-irqh-v2
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     powerpc-move-arch_trigger_cpumask_backtrace-from-nmih-to-irqh-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-move-arch_trigger_cpumask_backtrace-from-nmih-to-irqh-v2.patch

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
Subject: powerpc-move-arch_trigger_cpumask_backtrace-from-nmih-to-irqh-v2
Date: Thu, 22 Jun 2023 20:28:25 -0700

change the guards to include CONFIG_PPC_BOOK3S_64

Link: https://lkml.kernel.org/r/20230622202816.v2.1.Ice67126857506712559078e7de26d32d26e64631@changeid
Fixes: 7ca8fe94aa92 ("watchdog/hardlockup: define HARDLOCKUP_DETECTOR_ARCH")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Closes: https://lore.kernel.org/r/871qi5otdh.fsf@mail.lhotse
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/irq.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/irq.h~powerpc-move-arch_trigger_cpumask_backtrace-from-nmih-to-irqh-v2
+++ a/arch/powerpc/include/asm/irq.h
@@ -53,7 +53,7 @@ void __do_IRQ(struct pt_regs *regs);
 
 int irq_choose_cpu(const struct cpumask *mask);
 
-#ifdef CONFIG_NMI_IPI
+#if defined(CONFIG_PPC_BOOK3S_64) && defined(CONFIG_NMI_IPI)
 extern void arch_trigger_cpumask_backtrace(const cpumask_t *mask,
 					   bool exclude_self);
 #define arch_trigger_cpumask_backtrace arch_trigger_cpumask_backtrace
_

Patches currently in -mm which might be from dianders@chromium.org are

powerpc-move-arch_trigger_cpumask_backtrace-from-nmih-to-irqh.patch
powerpc-move-arch_trigger_cpumask_backtrace-from-nmih-to-irqh-v2.patch

