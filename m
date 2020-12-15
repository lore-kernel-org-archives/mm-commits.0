Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4076FC2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03D7B223C8
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgLODEK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:04:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:60044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726919AbgLODEJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:04:09 -0500
Date:   Mon, 14 Dec 2020 19:03:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001408;
        bh=jJPG+A7ilcZMCAw2TU2tp2dNhFz5CptulM8mfDbkyxk=;
        h=From:To:Subject:In-Reply-To:From;
        b=dg9zHVpxs8Znmt2fnrkP9GgpGIZVBxBar3aGfY9qPIbVHTRNMUhn0+Z5Hl7wUoxwD
         c8TTzzH7eAwUKdAtLb+AdwrBfAYNMtTgcouA/t0ZXuOuqg40E1ewgcIVagxqiniSMM
         +0wBN1alMhWkEZ7Ljo1LVTT9lOIfW3h6zVUiU01k=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, bigeasy@linutronix.de,
        davem@davemloft.net, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 005/200] ide: remove BUG_ON(in_interrupt() ||
 irqs_disabled()) from ide_unregister()
Message-ID: <20201215030327.1xgifoCou%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
