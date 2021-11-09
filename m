Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA999C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4DCB619E5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238127AbhKICi0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:38:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:53822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241923AbhKICiX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:38:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4821617E4;
        Tue,  9 Nov 2021 02:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425338;
        bh=+6aCSN1WBcxmm7trjnHrwbBSnVymibzZJZPeq5CTC0s=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=M3bOgFIjMktIDxPbxAVWNN0nel3a/xMFYcUCyEMv0UPsoOluCj3LLM2KYdZN7y8HX
         aUlBR6Oj60Ebi9QnIhwBnI59VYJ/d26Fj5AGIDv8OBetJ5so7jq24WTwYUEeUNbihh
         wfk3g0prJB1ubjVRxxXm3Q7VpwcST873EeBb2fP0=
Date:   Mon, 08 Nov 2021 18:35:37 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        bigeasy@linutronix.de, dvyukov@google.com, elver@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rostedt@goodmis.org, torvalds@linux-foundation.org,
        williams@redhat.com
Subject:  [patch 79/87] kcov: avoid enable+disable interrupts if
 !in_task()
Message-ID: <20211109023537.MOlW3u0_N%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: kcov: avoid enable+disable interrupts if !in_task()

kcov_remote_start() may need to allocate memory in the in_task() case
(otherwise per-CPU memory has been pre-allocated) and therefore requires
enabled interrupts.

The interrupts are enabled before checking if the allocation is required
so if no allocation is required then the interrupts are needlessly enabled
and disabled again.

Enable interrupts only if memory allocation is performed.

Link: https://lkml.kernel.org/r/20210923164741.1859522-5-bigeasy@linutronix.de
Link: https://lore.kernel.org/r/20210830172627.267989-5-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Marco Elver <elver@google.com>
Tested-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Clark Williams <williams@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/kcov.c~kcov-avoid-enabledisable-interrupts-if-in_task
+++ a/kernel/kcov.c
@@ -869,19 +869,19 @@ void kcov_remote_start(u64 handle)
 		size = CONFIG_KCOV_IRQ_AREA_SIZE;
 		area = this_cpu_ptr(&kcov_percpu_data)->irq_area;
 	}
-	spin_unlock_irqrestore(&kcov_remote_lock, flags);
+	spin_unlock(&kcov_remote_lock);
 
 	/* Can only happen when in_task(). */
 	if (!area) {
+		local_irqrestore(flags);
 		area = vmalloc(size * sizeof(unsigned long));
 		if (!area) {
 			kcov_put(kcov);
 			return;
 		}
+		local_irq_save(flags);
 	}
 
-	local_irq_save(flags);
-
 	/* Reset coverage size. */
 	*(u64 *)area = 0;
 
_
