Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2108C3526E
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDE9222D72
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbgLOX6v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:58:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:56710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731000AbgLOXQb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:16:31 -0500
Date:   Tue, 15 Dec 2020 15:15:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074147;
        bh=vym/XK3FakOXHFgj2R/8JoadZUQTX0oKtiPg0YbfKYs=;
        h=From:To:Subject:From;
        b=ibcXNKZwh3K3ippsu12Kwl31F/DqfydfQF+4JXbD4zDAs9ry6mDJfmV9qv1BwcV7v
         kh4zLQhV8Jh4c6M9vMlyxfEvnnVNfgRojNZCd1mAuH5c9//pq9j4rgdRyzZ4DZ+1Pg
         JSZAmsY/pngDmPe6W0nd0pIIJxuz5n4oBKUWO6ks=
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, davem@davemloft.net,
        mm-commits@vger.kernel.org
Subject:  [merged] ide-falcon-remove-in_interrupt-usage.patch
 removed from -mm tree
Message-ID: <20201215231547.H4ll-N-pq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ide/falcon: remove in_interrupt() usage
has been removed from the -mm tree.  Its filename was
     ide-falcon-remove-in_interrupt-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

lib-test_lockup-minimum-fix-to-get-it-compiled-on-preempt_rt.patch
rapidio-remove-unused-rio_get_asm-and-rio_get_device.patch

