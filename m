Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97853C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 705992332A
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgLPEn7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:43:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:49448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbgLPEn7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:43:59 -0500
Date:   Tue, 15 Dec 2020 20:42:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093750;
        bh=SycMikhgQKZbcj+vyD93K7LGP1ppNlRHLSNuj8zaYHk=;
        h=From:To:Subject:In-Reply-To:From;
        b=pLtA1NrHqSpeSMbG8mw/n1ih1l9vAftg7uMQ4JQ6HPGTTJEjO2zNB+5lkQ0Gu0FYi
         TV4xwy2jyYFGQo1VN8La7N9ac3n0e1L5M71Lrx41TpL3XdvVwd/t0LC+BVTRsanyxO
         74geg8Dk4BFx3YO9hBXXTuS9Ykj5ytProqj3mmUs=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, belyshev@depni.sinp.msu.ru,
        bigeasy@linutronix.de, ink@jurassic.park.msu.ru,
        linux-mm@kvack.org, mattst88@gmail.com, mm-commits@vger.kernel.org,
        rth@twiddle.net, tglx@linutronix.de, torvalds@linux-foundation.org
Subject:  [patch 03/95] alpha: replace bogus in_interrupt()
Message-ID: <20201216044229.2LRiyYBCE%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Subject: alpha: replace bogus in_interrupt()

in_interrupt() is true for a variety of things including bottom half
disabled regions.  Deducing hard interrupt context from it is dubious at
best.

Use in_irq() which is true if called in hard interrupt context.  Otherwise
calling irq_exit() would do more harm than good.

Link: https://lkml.kernel.org/r/20201113135832.2202833-1-bigeasy@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Serge Belyshev <belyshev@depni.sinp.msu.ru>
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
