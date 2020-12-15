Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2032EC2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0F9F22509
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgLODEQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:04:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:59988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726640AbgLODEJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:04:09 -0500
Date:   Mon, 14 Dec 2020 19:03:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001405;
        bh=NNKMgSsdowveW++tOUkrCtO2ywoW+rnZadFOgwlhzqU=;
        h=From:To:Subject:In-Reply-To:From;
        b=jMOgVjeq6UnRcyLBRoALjaTuP95HXSM0Si4b9fmn0Tugx0a56stdeqTnTkWK3zGsV
         l/wwG8/dHs/jNEDF1ipR/h3BapfcM/42+4+zMU5YLHmZLxhwImq8BmuldnAu+boqA+
         QdJUX3H/4E2eUWuUuxGm8masc1iPzZDYMdXNbAEc=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        davem@davemloft.net, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 004/200] ide/falcon: remove in_interrupt() usage
Message-ID: <20201215030324.MDB_qxAgD%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
