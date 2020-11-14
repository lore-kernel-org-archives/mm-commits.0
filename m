Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A791C4742C
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 00:25:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED9932225D
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 00:25:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vj0dOW7h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbgKNAZk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Nov 2020 19:25:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:34434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbgKNAZk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Nov 2020 19:25:40 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D40E22258;
        Sat, 14 Nov 2020 00:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605313539;
        bh=k8SsmWOZaTKmktt26Mblo93asu+GGBQmuAP3WmsFArE=;
        h=Date:From:To:Subject:From;
        b=Vj0dOW7hjorw66iB4cD2jYWLB7QYE4CJHjnO511WfoH2KnjojvVCnE8A/pE5VX+1p
         2jxVe0MKUefdkVEGOxMwjp3hnv5xzClPRX7lO+2Nl44tnOoiNTrStMCVikCxYYyP9J
         s921PhG2hvioyWFPMnHuHQk+hyns6HEnm8u94pgs=
Date:   Fri, 13 Nov 2020 16:25:39 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, ink@jurassic.park.msu.ru,
        mattst88@gmail.com, mm-commits@vger.kernel.org, rth@twiddle.net,
        tglx@linutronix.de
Subject:  + alpha-replace-bogus-in_interrupt.patch added to -mm
 tree
Message-ID: <20201114002539.EicLPqL0i%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: Replace bogus in_interrupt()
has been added to the -mm tree.  Its filename is
     alpha-replace-bogus-in_interrupt.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/alpha-replace-bogus-in_interrupt.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/alpha-replace-bogus-in_interrupt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thomas Gleixner <tglx@linutronix.de>
Subject: alpha: Replace bogus in_interrupt()

in_interrupt() is true for a variety of things including bottom half
disabled regions.  Deducing hard interrupt context from it is dubious at
best.

Use in_irq() which is true if called in hard interrupt context.  Otherwise
calling irq_exit() would do more harm than good.

Link: https://lkml.kernel.org/r/20201113135832.2202833-1-bigeasy@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/alpha/kernel/process.c~alpha-replace-bogus-in_interrupt
+++ a/arch/alpha/kernel/process.c
@@ -134,7 +134,7 @@ common_shutdown_1(void *generic_ptr)
 #ifdef CONFIG_DUMMY_CONSOLE
 		/* If we've gotten here after SysRq-b, leave interrupt
 		   context before taking over the console. */
-		if (in_interrupt())
+		if (in_irq())
 			irq_exit();
 		/* This has the effect of resetting the VGA video origin.  */
 		console_lock();
_

Patches currently in -mm which might be from tglx@linutronix.de are

alpha-replace-bogus-in_interrupt.patch

