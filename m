Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 638D8C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237443AbiFQCMg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379699AbiFQCM3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:12:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F25264BEF
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:12:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E063B61C0A
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F25C3411A;
        Fri, 17 Jun 2022 02:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655431944;
        bh=kywV6E0sCgK0Kl4XVjmDuSEat8WwjEdLFpyoa/4B8lQ=;
        h=Date:To:From:Subject:From;
        b=0hecKLlVNyJEN/NsK7Pp8IthE1yZgdPm/snsU4h+QEF5Qf9DfqiucOTHrUDznJXwW
         2knQtd0Kczlrat/wSYC0OoI3E5QKKfPMfvL5EKHj27NTWmfichCVAoteVmjdgqQ6zG
         3ekeL0ONLyGMfP/hgMG2wBMjldTOWws20lrN12WY=
Date:   Thu, 16 Jun 2022 19:12:23 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com,
        john.ogness@linutronix.de, glider@google.com,
        geert+renesas@glider.be, geert@linux-m68k.org, elver@google.com,
        dvyukov@google.com, Jason@zx2c4.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-kfence-select-random-number-before-taking-raw-lock.patch removed from -mm tree
Message-Id: <20220617021224.45F25C3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/kfence: select random number before taking raw lock
has been removed from the -mm tree.  Its filename was
     mm-kfence-select-random-number-before-taking-raw-lock.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: d4150779e60f ("random32: use real rng for non-deterministic randomness")
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


