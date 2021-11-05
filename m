Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EBB7C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEDAA611C0
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbhKEUne (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:43:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233035AbhKEUnd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:43:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDC1661262;
        Fri,  5 Nov 2021 20:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144853;
        bh=kRVAicR0RFgPFMeoHCQB41ZDmeTS5LoBsuX8BL9G2Hc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=B4PjbjfbxO/+w4CIcqtNASyrqv8uh3sRp60VN+FZ8ZjPYJdzkIp2Tuo3+skNO4jiI
         EudpciNS5BHW6mKYFgiKI5vonNF7j+YnltqPQEIAof73hr2tpDtzj29P8Fik5eb3OM
         ybvNE80xKW3tdw5x5dg49PzRNQrMbUPek6xKaoME=
Date:   Fri, 05 Nov 2021 13:40:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de,
        torvalds@linux-foundation.org
Subject:  [patch 119/262] mm: page_alloc: use migrate_disable() in
 drain_local_pages_wq()
Message-ID: <20211105204052.cwfJA8ksK%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm: page_alloc: use migrate_disable() in drain_local_pages_wq()

drain_local_pages_wq() disables preemption to avoid CPU migration during
CPU hotplug and can't use cpus_read_lock().

Using migrate_disable() works here, too.  The scheduler won't take the CPU
offline until the task left the migrate-disable section.  The problem with
disabled preemption here is that drain_local_pages() acquires locks which
are turned into sleeping locks on PREEMPT_RT and can't be acquired with
disabled preemption.

Use migrate_disable() in drain_local_pages_wq().

Link: https://lkml.kernel.org/r/20211015210933.viw6rjvo64qtqxn4@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-migrate_disable-in-drain_local_pages_wq
+++ a/mm/page_alloc.c
@@ -3141,9 +3141,9 @@ static void drain_local_pages_wq(struct
 	 * cpu which is alright but we also have to make sure to not move to
 	 * a different one.
 	 */
-	preempt_disable();
+	migrate_disable();
 	drain_local_pages(drain->zone);
-	preempt_enable();
+	migrate_enable();
 }
 
 /*
_
