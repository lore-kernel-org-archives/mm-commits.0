Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA0E0C2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 22:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7396D2242A
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 22:36:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lbmX8y1y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbgKTWgG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Nov 2020 17:36:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:35194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726898AbgKTWgG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Nov 2020 17:36:06 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 021DE22269;
        Fri, 20 Nov 2020 22:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605911764;
        bh=/1Bm/iEEr55bC52N+4g1gM7SXU6D44iH/T7CqeP8oVc=;
        h=Date:From:To:Subject:From;
        b=lbmX8y1yYpaw7VhDjyL6HzTOb7zYXYi9Pe9y/jmstM9cTJ1kYv3n093hXS/o/4hY9
         f3n1gYK4q86F90EniWQ7/QrON8u2IAT+U+nnFzTPSlRkEV5bq4VIviGuYr1V2WX9A6
         0rhj+u8sR6LZk+Qmkq32H9wDg7Y9MCMEgXlcKhV8=
Date:   Fri, 20 Nov 2020 14:36:03 -0800
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, bigeasy@linutronix.de, davem@davemloft.net,
        mm-commits@vger.kernel.org
Subject:  +
 ide-remove-bug_onin_interrupt-irqs_disabled-from-ide_unregister.patch added
 to -mm tree
Message-ID: <20201120223603.XQTzdurh8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ide: remove BUG_ON(in_interrupt() || irqs_disabled()) from ide_unregister()
has been added to the -mm tree.  Its filename is
     ide-remove-bug_onin_interrupt-irqs_disabled-from-ide_unregister.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ide-remove-bug_onin_interrupt-irqs_disabled-from-ide_unregister.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ide-remove-bug_onin_interrupt-irqs_disabled-from-ide_unregister.patch

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
Subject: ide: remove BUG_ON(in_interrupt() || irqs_disabled()) from ide_unregister()

Both BUG_ON() were introduced in commit
   4015c949fb465 ("[PATCH] update ide core")

when ide_unregister() was extended with semaphore based locking.  Both
checks won't complain about disabled preemption which is also wrong.

The might_sleep() in today's mutex_lock() will complain about the
missuses.

Remove the BUG_ON() statements.

Link: https://lkml.kernel.org/r/20201120092421.1023428-3-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Jens Axboe <axboe@kernel.dk>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-probe.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/ide/ide-probe.c~ide-remove-bug_onin_interrupt-irqs_disabled-from-ide_unregister
+++ a/drivers/ide/ide-probe.c
@@ -1592,9 +1592,6 @@ EXPORT_SYMBOL_GPL(ide_port_unregister_de
 
 static void ide_unregister(ide_hwif_t *hwif)
 {
-	BUG_ON(in_interrupt());
-	BUG_ON(irqs_disabled());
-
 	mutex_lock(&ide_cfg_mtx);
 
 	if (hwif->present) {
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

ide-remove-bug_onin_interrupt-irqs_disabled-from-ide_unregister.patch
lib-test_lockup-minimum-fix-to-get-it-compiled-on-preempt_rt.patch
rapidio-remove-unused-rio_get_asm-and-rio_get_device.patch

