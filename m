Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0934DC6379F
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 03:46:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96CF820866
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 03:46:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LAzsio21"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgKXDqT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 22:46:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:43840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbgKXDqT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 22:46:19 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9D8720857;
        Tue, 24 Nov 2020 03:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606189577;
        bh=cirMHIj4AiRRfR4IdbKTnyL6wTcr080d06eR7WNiP2Y=;
        h=Date:From:To:Subject:From;
        b=LAzsio21XffVHhvGsbesJ1IzRz/YJoMuVUvscwV+EpGeEbMlw9WvTZ7jOzQlHJgDp
         IyyApU0W/Si4TlhYbP7x25Le/r2ukvln4Rl21ViSxsu6zQmw+qUBysEAKre+VDLgoY
         V7QQSariQs0/TtbhNqK8qkZHFlRrse8oVUDwfV/I=
Date:   Mon, 23 Nov 2020 19:46:16 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, davem@davemloft.net,
        mm-commits@vger.kernel.org
Subject:  + ide-falcon-remove-in_interrupt-usage.patch added to -mm
 tree
Message-ID: <20201124034616.FOqkQJbBa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ide/falcon: remove in_interrupt() usage
has been added to the -mm tree.  Its filename is
     ide-falcon-remove-in_interrupt-usage.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ide-falcon-remove-in_interrupt-usage.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ide-falcon-remove-in_interrupt-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: ide/falcon: remove in_interrupt() usage

falconide_get_lock() is called by ide_lock_host() and its caller
(ide_issue_rq()) has already a might_sleep() check.

stdma_lock() has wait_event() which also has a might_sleep() check.

Remove the in_interrupt() check.

Link: https://lkml.kernel.org/r/20201113161021.2217361-2-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/falconide.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/ide/falconide.c~ide-falcon-remove-in_interrupt-usage
+++ a/drivers/ide/falconide.c
@@ -51,8 +51,6 @@ static void falconide_release_lock(void)
 static void falconide_get_lock(irq_handler_t handler, void *data)
 {
 	if (falconide_intr_lock == 0) {
-		if (in_interrupt() > 0)
-			panic("Falcon IDE hasn't ST-DMA lock in interrupt");
 		stdma_lock(handler, data);
 		falconide_intr_lock = 1;
 	}
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

ide-falcon-remove-in_interrupt-usage.patch
ide-remove-bug_onin_interrupt-irqs_disabled-from-ide_unregister.patch
lib-test_lockup-minimum-fix-to-get-it-compiled-on-preempt_rt.patch
rapidio-remove-unused-rio_get_asm-and-rio_get_device.patch

