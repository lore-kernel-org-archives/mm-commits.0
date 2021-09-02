Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F36C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EEC160F92
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345735AbhIBVL7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343703AbhIBVL7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:11:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6180360BD3;
        Thu,  2 Sep 2021 21:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630617060;
        bh=/KNGUA58b75/ln8Ver4EbRCRrX63xytTOsWQOPaSJfs=;
        h=Date:From:To:Subject:From;
        b=zd4HWvXTWsjGjp8+0Pkl17qU9gpdGvWDtr1Cy5z+ElP4yY/CvLCdp6+HQ0nlFaHGe
         wH5lhn1ud7Vbxchs7GxUs+Tih1w9kefKN/eWGhZgziep69neQAcU5O0S5SL+RCNpTx
         9Xhv/kFo/tZ8yQr1CjkfBFqP3UYAN11iaRiAYUeM=
Date:   Thu, 02 Sep 2021 14:11:00 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        sven@narfation.org, vbabka@suse.cz
Subject:  [folded-merged]
 mm-slub-convert-kmem_cpu_slab-protection-to-local_lock-fix-2.patch removed
 from -mm tree
Message-ID: <20210902211100.XyEv3jqXJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: fix kmem_cache_cpu fields alignment for double cmpxchg
has been removed from the -mm tree.  Its filename was
     mm-slub-convert-kmem_cpu_slab-protection-to-local_lock-fix-2.patch

This patch was dropped because it was folded into mm-slub-convert-kmem_cpu_slab-protection-to-local_lock.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: fix kmem_cache_cpu fields alignment for double cmpxchg

Sven Eckelmann reports [1] that the addition of local_lock to kmem_cache_cpu
breaks a config with 64BIT+LOCK_STAT:

    general protection fault, maybe for address 0xffff888007fcf1c8: 0000 [#1] NOPTI
    CPU: 0 PID: 0 Comm: swapper Not tainted 5.14.0-rc5+ #7
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
    RIP: 0010:kmem_cache_alloc+0x81/0x180
    Code: 79 48 00 4c 8b 41 38 0f 84 89 00 00 00 4d 85 c0 0f 84 80 00 00 00 41 8b 44 24 28 49 8b 3c 24 48 8d 4a 01 49 8b 1c 00 4c 89 c0 <48> 0f c7 4f 38 0f 943
    RSP: 0000:ffffffff81803c10 EFLAGS: 00000286
    RAX: ffff88800244e7c0 RBX: ffff88800244e800 RCX: 0000000000000024
    RDX: 0000000000000023 RSI: 0000000000000100 RDI: ffff888007fcf190
    RBP: ffffffff81803c38 R08: ffff88800244e7c0 R09: 0000000000000dc0
    R10: 0000000000004000 R11: 0000000000000000 R12: ffff8880024413c0
    R13: ffffffff810d18f4 R14: 0000000000000dc0 R15: 0000000000000100
    FS:  0000000000000000(0000) GS:ffffffff81840000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: ffff888002001000 CR3: 0000000001824000 CR4: 00000000000006b0
    Call Trace:
     __get_vm_area_node.constprop.0.isra.0+0x74/0x150
     __vmalloc_node_range+0x5a/0x2b0
     ? kernel_clone+0x88/0x390
     ? copy_process+0x1ac/0x17e0
     copy_process+0x768/0x17e0
     ? kernel_clone+0x88/0x390
     kernel_clone+0x88/0x390
     ? _vm_unmap_aliases.part.0+0xe9/0x110
     ? change_page_attr_set_clr+0x10d/0x180
     kernel_thread+0x43/0x50
     ? rest_init+0x100/0x100
     rest_init+0x1e/0x100
     arch_call_rest_init+0x9/0xc
     start_kernel+0x481/0x493
     x86_64_start_reservations+0x24/0x26
     x86_64_start_kernel+0x80/0x84
     secondary_startup_64_no_verify+0xc2/0xcb
    random: get_random_bytes called from oops_exit+0x34/0x60 with crng_init=0
    ---[ end trace 2cac18ac38f640c1 ]---
    RIP: 0010:kmem_cache_alloc+0x81/0x180
    Code: 79 48 00 4c 8b 41 38 0f 84 89 00 00 00 4d 85 c0 0f 84 80 00 00 00 41 8b 44 24 28 49 8b 3c 24 48 8d 4a 01 49 8b 1c 00 4c 89 c0 <48> 0f c7 4f 38 0f 943
    RSP: 0000:ffffffff81803c10 EFLAGS: 00000286
    RAX: ffff88800244e7c0 RBX: ffff88800244e800 RCX: 0000000000000024
    RDX: 0000000000000023 RSI: 0000000000000100 RDI: ffff888007fcf190
    RBP: ffffffff81803c38 R08: ffff88800244e7c0 R09: 0000000000000dc0
    R10: 0000000000004000 R11: 0000000000000000 R12: ffff8880024413c0
    R13: ffffffff810d18f4 R14: 0000000000000dc0 R15: 0000000000000100
    FS:  0000000000000000(0000) GS:ffffffff81840000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: ffff888002001000 CR3: 0000000001824000 CR4: 00000000000006b0
    Kernel panic - not syncing: Attempted to kill the idle task!
    ---[ end Kernel panic - not syncing: Attempted to kill the idle task! ]---

Decoding the RIP points to this_cpu_cmpxchg_double() call in slab_alloc_node().

The problem is the particular size of local_lock_t with LOCK_STAT resulting
in the following layout:

struct kmem_cache_cpu {
        local_lock_t               lock;                 /*     0    56 */
        void * *                   freelist;             /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        long unsigned int          tid;                  /*    64     8 */
        struct page *              page;                 /*    72     8 */
        struct page *              partial;              /*    80     8 */

        /* size: 88, cachelines: 2, members: 5 */
        /* last cacheline: 24 bytes */
};

As pointed out by Sebastian Andrzej Siewior, this_cpu_cmpxchg_double()
needs the freelist and tid fields to be aligned to sum of their sizes
(16 bytes) but they are not in this configuration. This didn't happen
with non-debug RT and !RT configs as well as lockdep.

To fix this, move the lock field below partial field, so that it doesn't
affect the layout.

[1] https://lore.kernel.org/linux-mm/2666777.vCjUEy5FO1@sven-desktop/

This is a fixup for mmotm patch
mm-slub-convert-kmem_cpu_slab-protection-to-local_lock.patch

Link: https://lkml.kernel.org/r/e907c2b6-6df1-8038-8c6c-aa9c1fd11259@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Sven Eckelmann <sven@narfation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/slub_def.h~mm-slub-convert-kmem_cpu_slab-protection-to-local_lock-fix-2
+++ a/include/linux/slub_def.h
@@ -41,14 +41,18 @@ enum stat_item {
 	CPU_PARTIAL_DRAIN,	/* Drain cpu partial to node partial */
 	NR_SLUB_STAT_ITEMS };
 
+/*
+ * When changing the layout, make sure freelist and tid are still compatible
+ * with this_cpu_cmpxchg_double() alignment requirements.
+ */
 struct kmem_cache_cpu {
-	local_lock_t lock;	/* Protects the fields below except stat */
 	void **freelist;	/* Pointer to next available object */
 	unsigned long tid;	/* Globally unique transaction id */
 	struct page *page;	/* The slab from which we are allocating */
 #ifdef CONFIG_SLUB_CPU_PARTIAL
 	struct page *partial;	/* Partially allocated frozen slabs */
 #endif
+	local_lock_t lock;	/* Protects the fields above */
 #ifdef CONFIG_SLUB_STATS
 	unsigned stat[NR_SLUB_STAT_ITEMS];
 #endif
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-dont-call-flush_all-from-slab_debug_trace_open.patch
mm-slub-allocate-private-object-map-for-debugfs-listings.patch
mm-slub-allocate-private-object-map-for-validate_slab_cache.patch
mm-slub-dont-disable-irq-for-debug_check_no_locks_freed.patch
mm-slub-remove-redundant-unfreeze_partials-from-put_cpu_partial.patch
mm-slub-unify-cmpxchg_double_slab-and-__cmpxchg_double_slab.patch
mm-slub-extract-get_partial-from-new_slab_objects.patch
mm-slub-dissolve-new_slab_objects-into-___slab_alloc.patch
mm-slub-return-slab-page-from-get_partial-and-set-c-page-afterwards.patch
mm-slub-restructure-new-page-checks-in-___slab_alloc.patch
mm-slub-simplify-kmem_cache_cpu-and-tid-setup.patch
mm-slub-move-disabling-enabling-irqs-to-___slab_alloc.patch
mm-slub-do-initial-checks-in-___slab_alloc-with-irqs-enabled.patch
mm-slub-move-disabling-irqs-closer-to-get_partial-in-___slab_alloc.patch
mm-slub-restore-irqs-around-calling-new_slab.patch
mm-slub-validate-slab-from-partial-list-or-page-allocator-before-making-it-cpu-slab.patch
mm-slub-check-new-pages-with-restored-irqs.patch
mm-slub-stop-disabling-irqs-around-get_partial.patch
mm-slub-move-reset-of-c-page-and-freelist-out-of-deactivate_slab.patch
mm-slub-make-locking-in-deactivate_slab-irq-safe.patch
mm-slub-call-deactivate_slab-without-disabling-irqs.patch
mm-slub-move-irq-control-into-unfreeze_partials.patch
mm-slub-discard-slabs-in-unfreeze_partials-without-irqs-disabled.patch
mm-slub-detach-whole-partial-list-at-once-in-unfreeze_partials.patch
mm-slub-separate-detaching-of-partial-list-in-unfreeze_partials-from-unfreezing.patch
mm-slub-only-disable-irq-with-spin_lock-in-__unfreeze_partials.patch
mm-slub-dont-disable-irqs-in-slub_cpu_dead.patch
mm-slab-make-flush_slab-possible-to-call-with-irqs-enabled.patch
mm-slub-optionally-save-restore-irqs-in-slab_lock.patch
mm-slub-make-slab_lock-disable-irqs-with-preempt_rt.patch
mm-slub-protect-put_cpu_partial-with-disabled-irqs-instead-of-cmpxchg.patch
mm-slub-use-migrate_disable-on-preempt_rt.patch
mm-slub-convert-kmem_cpu_slab-protection-to-local_lock.patch
mm-vmscan-guarantee-drop_slab_node-termination.patch
mm-vmscan-guarantee-drop_slab_node-termination-fix.patch

