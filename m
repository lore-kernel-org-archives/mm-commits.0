Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E9AC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EAE561872
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234629AbhKKC44 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:56:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:60214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234627AbhKKC44 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:56:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9425A61361;
        Thu, 11 Nov 2021 02:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599247;
        bh=MJU819B+OGQ00Jyn7YQBRX212a+N2F554L3nrBHBk94=;
        h=Date:From:To:Subject:From;
        b=U8DvgWBYn6Otj8Wpk9dEhryukI0MZ9TPcwIL8sTc7DSdEKzjJDQJDXC20GBmcjFoJ
         TAAhLZmjWft6gmy8Gpg/NKf4RLf7vA81Wgdl592ggG1OeDNg5yH9CTTn1/71/Nj+i8
         aVTJdVdx5TWz0aIdK/bOjYNjfwN5/IVXi1Cg4A9Q=
Date:   Wed, 10 Nov 2021 18:54:07 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, bigeasy@linutronix.de, dvyukov@google.com,
        elver@google.com, mm-commits@vger.kernel.org, rostedt@goodmis.org,
        williams@redhat.com
Subject:  [merged]
 kcov-avoid-enabledisable-interrupts-if-in_task.patch removed from -mm tree
Message-ID: <20211111025407.1Mma3htxo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: avoid enable+disable interrupts if !in_task()
has been removed from the -mm tree.  Its filename was
     kcov-avoid-enabledisable-interrupts-if-in_task.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from bigeasy@linutronix.de are


