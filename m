Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF84C433B4
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 18:25:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6350A6124C
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 18:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245017AbhERS03 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 May 2021 14:26:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242486AbhERS03 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 May 2021 14:26:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA43D60FF2;
        Tue, 18 May 2021 18:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621362311;
        bh=+UUa0+R0iSb1fe+zlntQFat+eLvakIMaHgT1yFDcxrA=;
        h=Date:From:To:Subject:From;
        b=rnTr1Lkp/Wk05fqGmofVTEcfrD/dWoQN27sXQUK3f46t/3C8bgNCd8m9VvSt5cSJ0
         vdZ/V/PXgEMnXjLmRjoze12s9JE8bRx5+5pRkd7H1sbOAurb10BLwE/lQ7r7QN29a0
         dKA28hdhc2BnukfNfkkKlvvkw7N7BK1uCjiPab1k=
Date:   Tue, 18 May 2021 11:25:10 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        paulmck@kernel.org, penberg@kernel.org, rientjes@google.com,
        vbabka@suse.cz
Subject:  [merged]
 mm-slub-move-slub_debug-static-key-enabling-outside-slab_mutex.patch
 removed from -mm tree
Message-ID: <20210518182510.cLzD-IcAV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: move slub_debug static key enabling outside slab_mutex
has been removed from the -mm tree.  Its filename was
     mm-slub-move-slub_debug-static-key-enabling-outside-slab_mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: move slub_debug static key enabling outside slab_mutex

Paul E.  McKenney reported [1] that commit 1f0723a4c0df ("mm, slub: enable
slub_debug static key when creating cache with explicit debug flags")
results in the lockdep complaint:

 ======================================================
 WARNING: possible circular locking dependency detected
 5.12.0+ #15 Not tainted
 ------------------------------------------------------
 rcu_torture_sta/109 is trying to acquire lock:
 ffffffff96063cd0 (cpu_hotplug_lock){++++}-{0:0}, at: static_key_enable+0x9/0x20

 but task is already holding lock:
 ffffffff96173c28 (slab_mutex){+.+.}-{3:3}, at: kmem_cache_create_usercopy+0x2d/0x250

 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:

 -> #1 (slab_mutex){+.+.}-{3:3}:
        lock_acquire+0xb9/0x3a0
        __mutex_lock+0x8d/0x920
        slub_cpu_dead+0x15/0xf0
        cpuhp_invoke_callback+0x17a/0x7c0
        cpuhp_invoke_callback_range+0x3b/0x80
        _cpu_down+0xdf/0x2a0
        cpu_down+0x2c/0x50
        device_offline+0x82/0xb0
        remove_cpu+0x1a/0x30
        torture_offline+0x80/0x140
        torture_onoff+0x147/0x260
        kthread+0x10a/0x140
        ret_from_fork+0x22/0x30

 -> #0 (cpu_hotplug_lock){++++}-{0:0}:
        check_prev_add+0x8f/0xbf0
        __lock_acquire+0x13f0/0x1d80
        lock_acquire+0xb9/0x3a0
        cpus_read_lock+0x21/0xa0
        static_key_enable+0x9/0x20
        __kmem_cache_create+0x38d/0x430
        kmem_cache_create_usercopy+0x146/0x250
        kmem_cache_create+0xd/0x10
        rcu_torture_stats+0x79/0x280
        kthread+0x10a/0x140
        ret_from_fork+0x22/0x30

 other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(slab_mutex);
                                lock(cpu_hotplug_lock);
                                lock(slab_mutex);
   lock(cpu_hotplug_lock);

  *** DEADLOCK ***

 1 lock held by rcu_torture_sta/109:
  #0: ffffffff96173c28 (slab_mutex){+.+.}-{3:3}, at: kmem_cache_create_usercopy+0x2d/0x250

 stack backtrace:
 CPU: 3 PID: 109 Comm: rcu_torture_sta Not tainted 5.12.0+ #15
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
 Call Trace:
  dump_stack+0x6d/0x89
  check_noncircular+0xfe/0x110
  ? lock_is_held_type+0x98/0x110
  check_prev_add+0x8f/0xbf0
  __lock_acquire+0x13f0/0x1d80
  lock_acquire+0xb9/0x3a0
  ? static_key_enable+0x9/0x20
  ? mark_held_locks+0x49/0x70
  cpus_read_lock+0x21/0xa0
  ? static_key_enable+0x9/0x20
  static_key_enable+0x9/0x20
  __kmem_cache_create+0x38d/0x430
  kmem_cache_create_usercopy+0x146/0x250
  ? rcu_torture_stats_print+0xd0/0xd0
  kmem_cache_create+0xd/0x10
  rcu_torture_stats+0x79/0x280
  ? rcu_torture_stats_print+0xd0/0xd0
  kthread+0x10a/0x140
  ? kthread_park+0x80/0x80
  ret_from_fork+0x22/0x30

This is because there's one order of locking from the hotplug callbacks:

lock(cpu_hotplug_lock); // from hotplug machinery itself
lock(slab_mutex); // in e.g. slab_mem_going_offline_callback()

And commit 1f0723a4c0df made the reverse sequence possible:
lock(slab_mutex); // in kmem_cache_create_usercopy()
lock(cpu_hotplug_lock); // kmem_cache_open() -> static_key_enable()

The simplest fix is to move static_key_enable() to a place before slab_mutex is
taken. That means kmem_cache_create_usercopy() in mm/slab_common.c which is not
ideal for SLUB-specific code, but the #ifdef CONFIG_SLUB_DEBUG makes it
at least self-contained and obvious.

[1] https://lore.kernel.org/lkml/20210502171827.GA3670492@paulmck-ThinkPad-P17-Gen-1/

Link: https://lkml.kernel.org/r/20210504120019.26791-1-vbabka@suse.cz
Fixes: 1f0723a4c0df ("mm, slub: enable slub_debug static key when creating cache with explicit debug flags")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |   10 ++++++++++
 mm/slub.c        |    9 ---------
 2 files changed, 10 insertions(+), 9 deletions(-)

--- a/mm/slab_common.c~mm-slub-move-slub_debug-static-key-enabling-outside-slab_mutex
+++ a/mm/slab_common.c
@@ -318,6 +318,16 @@ kmem_cache_create_usercopy(const char *n
 	const char *cache_name;
 	int err;
 
+#ifdef CONFIG_SLUB_DEBUG
+	/*
+	 * If no slub_debug was enabled globally, the static key is not yet
+	 * enabled by setup_slub_debug(). Enable it if the cache is being
+	 * created with any of the debugging flags passed explicitly.
+	 */
+	if (flags & SLAB_DEBUG_FLAGS)
+		static_branch_enable(&slub_debug_enabled);
+#endif
+
 	mutex_lock(&slab_mutex);
 
 	err = kmem_cache_sanity_check(name, size);
--- a/mm/slub.c~mm-slub-move-slub_debug-static-key-enabling-outside-slab_mutex
+++ a/mm/slub.c
@@ -3828,15 +3828,6 @@ static int calculate_sizes(struct kmem_c
 
 static int kmem_cache_open(struct kmem_cache *s, slab_flags_t flags)
 {
-#ifdef CONFIG_SLUB_DEBUG
-	/*
-	 * If no slub_debug was enabled globally, the static key is not yet
-	 * enabled by setup_slub_debug(). Enable it if the cache is being
-	 * created with any of the debugging flags passed explicitly.
-	 */
-	if (flags & SLAB_DEBUG_FLAGS)
-		static_branch_enable(&slub_debug_enabled);
-#endif
 	s->flags = kmem_cache_flags(s->size, flags, s->name);
 #ifdef CONFIG_SLAB_FREELIST_HARDENED
 	s->random = get_random_long();
_

Patches currently in -mm which might be from vbabka@suse.cz are

kunit-make-test-lock-irq-safe.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-fix.patch

