Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91377C2BBCA
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:16:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 538FA22D2B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:16:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730243AbgLOXQh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:16:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:56702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731025AbgLOXQd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:16:33 -0500
Date:   Tue, 15 Dec 2020 15:15:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074149;
        bh=OELmQrBrYMBtUaNCpt6lSnCXMZsFWXUPXRZFDkYzZTA=;
        h=From:To:Subject:From;
        b=tMnvhWmvEt+ULNeg/Quj2DnFfsT93K8odk9vdyJx/BveHtYrjruiG2tzvKQajOBuK
         ht/KS2XlNLRnjcebySpHPp+h5lg2pL1b1AkcnzRWZxB5LB/PNK8U2NVm0Spilv5Qj/
         NK6Me99r8b75OEP9aKjmL0NCioeaHIEhT4byfPPc=
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, bigeasy@linutronix.de, davem@davemloft.net,
        mm-commits@vger.kernel.org
Subject:  [merged]
 ide-remove-bug_onin_interrupt-irqs_disabled-from-ide_unregister.patch
 removed from -mm tree
Message-ID: <20201215231549.IPkWnIWh-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ide: remove BUG_ON(in_interrupt() || irqs_disabled()) from ide_unregister()
has been removed from the -mm tree.  Its filename was
     ide-remove-bug_onin_interrupt-irqs_disabled-from-ide_unregister.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: ide: remove BUG_ON(in_interrupt() || irqs_disabled()) from ide_unregister()

In the discussion about preempt count consistency across kernel
configurations:

 https://lore.kernel.org/r/20200914204209.256266093@linutronix.de/

it was concluded that the usage of in_interrupt() and related context
checks should be removed from non-core code.


Both BUG_ON()s in ide-probe.c were introduced in commit
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

lib-test_lockup-minimum-fix-to-get-it-compiled-on-preempt_rt.patch
rapidio-remove-unused-rio_get_asm-and-rio_get_device.patch

