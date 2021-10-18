Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F361AC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 19:52:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3C4360F9D
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 19:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbhJRTyk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Oct 2021 15:54:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230159AbhJRTyk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 Oct 2021 15:54:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B040E61002;
        Mon, 18 Oct 2021 19:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634586748;
        bh=+0AjmFADIwJsFwT8eCF8PWyDPV8otQy2+9agoa2ZQ4Y=;
        h=Date:From:To:Subject:From;
        b=2bEQ9wjGVrkayzE2tM8CVhrr/452VsHzyHvtpAGRVZeP7CooMMUSO8EC91S9FVVs8
         k5Rs1e/f/0jbUImUjgJMYggThhT3nutBtJazn908Hrh3b7NFtjc9+aft0g/TkbPqF5
         20PgZJCx1+NZMRT9yv4XsUzuaH5aMkjcyBHKJFSw=
Date:   Mon, 18 Oct 2021 12:52:28 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, mm-commits@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Subject:  +
 mm-page_alloc-use-migrate_disable-in-drain_local_pages_wq.patch added to
 -mm tree
Message-ID: <20211018195228.0B5-na_k0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: use migrate_disable() in drain_local_pages_wq()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-use-migrate_disable-in-drain_local_pages_wq.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-use-migrate_disable-in-drain_local_pages_wq.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-use-migrate_disable-in-drain_local_pages_wq.patch

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
@@ -3139,9 +3139,9 @@ static void drain_local_pages_wq(struct
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

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-page_alloc-use-migrate_disable-in-drain_local_pages_wq.patch
mm-disable-zsmalloc-on-preempt_rt.patch
documentation-kcov-include-typesh-in-the-example.patch
documentation-kcov-define-ip-in-the-example.patch
kcov-allocate-per-cpu-memory-on-the-relevant-node.patch
kcov-avoid-enabledisable-interrupts-if-in_task.patch
kcov-replace-local_irq_save-with-a-local_lock_t.patch

