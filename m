Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38600EB64D7
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjFXAC6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjFXAC5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:02:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7812693
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:02:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BB306155C
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85D3C433C0;
        Sat, 24 Jun 2023 00:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564974;
        bh=CORnjewp0G4jbsSkB1z5xGsR7oH59DWpGB47gctyZW0=;
        h=Date:To:From:Subject:From;
        b=ZDmgSET4SOxIzj7ACnmfNE3G1jmrShSgwYvBkHwnZO/lfTNOJIwTWSFSuniyNvBmR
         MFF1sNCoOgazzNUZBWLr1s+lSKm7Ed2sePDfCDoWABddZNKy+dhY92f4rs1Ec8pSLH
         07NlnYmTR8VQ5C9DWU5AOA/R8zOHRPLZK3yjxpGI=
Date:   Fri, 23 Jun 2023 17:02:53 -0700
To:     mm-commits@vger.kernel.org, trix@redhat.com, sfr@canb.auug.org.au,
        pmladek@suse.com, npiggin@gmail.com, mpe@ellerman.id.au,
        ldufour@linux.ibm.com, christophe.leroy@csgroup.eu, arnd@arndb.de,
        dianders@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] powerpc-move-arch_trigger_cpumask_backtrace-from-nmih-to-irqh-v2.patch removed from -mm tree
Message-Id: <20230624000254.A85D3C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerpc-move-arch_trigger_cpumask_backtrace-from-nmih-to-irqh-v2
has been removed from the -mm tree.  Its filename was
     powerpc-move-arch_trigger_cpumask_backtrace-from-nmih-to-irqh-v2.patch

This patch was dropped because it was folded into powerpc-move-arch_trigger_cpumask_backtrace-from-nmih-to-irqh.patch

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

