Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA014C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Jun 2022 16:56:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244627AbiFIQ4q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Jun 2022 12:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238833AbiFIQ4p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2022 12:56:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18662B190
        for <mm-commits@vger.kernel.org>; Thu,  9 Jun 2022 09:56:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54C45B82D85
        for <mm-commits@vger.kernel.org>; Thu,  9 Jun 2022 16:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E538EC34114;
        Thu,  9 Jun 2022 16:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654793801;
        bh=BbC+cQnnYJitqpALCQn4g/q8rA7NkUbMY+rfYSIj3DY=;
        h=Date:To:From:Subject:From;
        b=qHRHPbh3ahX7TlXHeRxMgT31v6qB69o20m6fiVSfeOk/8dwPmG4ukbQgtp3OI9P5T
         UcvJd6nOSj+7mJE6VGXN5xz9AFm8hfiIX5DvPd0poFl/ahJRm7MZe6eJycsEWEy2Ke
         GS6uflqOm5YvUqHhtDkqfDVdT/SobWK9K0E+STeI=
Date:   Thu, 09 Jun 2022 09:56:40 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com,
        john.ogness@linutronix.de, glider@google.com,
        geert+renesas@glider.be, geert@linux-m68k.org, elver@google.com,
        dvyukov@google.com, Jason@zx2c4.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kfence-select-random-number-before-taking-raw-lock.patch added to mm-unstable branch
Message-Id: <20220609165640.E538EC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kfence: select random number before taking raw lock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kfence-select-random-number-before-taking-raw-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kfence-select-random-number-before-taking-raw-lock.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: mm/kfence: select random number before taking raw lock
Date: Thu, 9 Jun 2022 14:33:19 +0200

The RNG uses vanilla spinlocks, not raw spinlocks, so kfence should pick
its random numbers before taking its raw spinlocks.  This also has the
nice effect of doing less work inside the lock.  It should fix a splat
that Geert saw with CONFIG_PROVE_RAW_LOCK_NESTING:

     dump_backtrace.part.0+0x98/0xc0
     show_stack+0x14/0x28
     dump_stack_lvl+0xac/0xec
     dump_stack+0x14/0x2c
     __lock_acquire+0x388/0x10a0
     lock_acquire+0x190/0x2c0
     _raw_spin_lock_irqsave+0x6c/0x94
     crng_make_state+0x148/0x1e4
     _get_random_bytes.part.0+0x4c/0xe8
     get_random_u32+0x4c/0x140
     __kfence_alloc+0x460/0x5c4
     kmem_cache_alloc_trace+0x194/0x1dc
     __kthread_create_on_node+0x5c/0x1a8
     kthread_create_on_node+0x58/0x7c
     printk_start_kthread.part.0+0x34/0xa8
     printk_activate_kthreads+0x4c/0x54
     do_one_initcall+0xec/0x278
     kernel_init_freeable+0x11c/0x214
     kernel_init+0x24/0x124
     ret_from_fork+0x10/0x20

Link: https://lkml.kernel.org/r/20220609123319.17576-1-Jason@zx2c4.com
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/kfence/core.c~mm-kfence-select-random-number-before-taking-raw-lock
+++ a/mm/kfence/core.c
@@ -360,6 +360,9 @@ static void *kfence_guarded_alloc(struct
 	unsigned long flags;
 	struct slab *slab;
 	void *addr;
+	const bool random_right_allocate = prandom_u32_max(2);
+	const bool random_fault = CONFIG_KFENCE_STRESS_TEST_FAULTS &&
+				  !prandom_u32_max(CONFIG_KFENCE_STRESS_TEST_FAULTS);
 
 	/* Try to obtain a free object. */
 	raw_spin_lock_irqsave(&kfence_freelist_lock, flags);
@@ -404,7 +407,7 @@ static void *kfence_guarded_alloc(struct
 	 * is that the out-of-bounds accesses detected are deterministic for
 	 * such allocations.
 	 */
-	if (prandom_u32_max(2)) {
+	if (random_right_allocate) {
 		/* Allocate on the "right" side, re-calculate address. */
 		meta->addr += PAGE_SIZE - size;
 		meta->addr = ALIGN_DOWN(meta->addr, cache->align);
@@ -444,7 +447,7 @@ static void *kfence_guarded_alloc(struct
 	if (cache->ctor)
 		cache->ctor(addr);
 
-	if (CONFIG_KFENCE_STRESS_TEST_FAULTS && !prandom_u32_max(CONFIG_KFENCE_STRESS_TEST_FAULTS))
+	if (random_fault)
 		kfence_protect(meta->addr); /* Random "faults" by protecting the object. */
 
 	atomic_long_inc(&counters[KFENCE_COUNTER_ALLOCATED]);
_

Patches currently in -mm which might be from Jason@zx2c4.com are

mm-kfence-select-random-number-before-taking-raw-lock.patch

