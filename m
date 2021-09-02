Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13271C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E409C60FC4
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346748AbhIBVJQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:09:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346837AbhIBVJP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:09:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB659610A0;
        Thu,  2 Sep 2021 21:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630616897;
        bh=VBvHT2pjwNHk32Z+GwqR4Paoy0otfUYNO4CSdldNLqg=;
        h=Date:From:To:Subject:From;
        b=nL9Eu7JaofrTz7O6hhoBYdQUa063ldRWEFnWcAsqCpCEzHkHNEeAEj+b44vsZ5eWH
         WBrn40d52+F0xMPAUIEtDk4wxNl2j/dyKgyLmL2XFImfdLzaBT5fuaRGjtL+pomzSq
         qwDVX2xzlQdBMbtzLqyr+O14KnMfoEXh2bCQF8TY=
Date:   Thu, 02 Sep 2021 14:08:16 -0700
From:   akpm@linux-foundation.org
To:     efault@gmx.de, mm-commits@vger.kernel.org, vbabka@suse.cz,
        williams@redhat.com
Subject:  [folded-merged]
 mm-slub-do-initial-checks-in-___slab_alloc-with-irqs-enabled-fix.patch
 removed from -mm tree
Message-ID: <20210902210816.ZlkcLRgom%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: prevent VM_BUG_ON in PageSlabPfmemalloc from ___slab_alloc
has been removed from the -mm tree.  Its filename was
     mm-slub-do-initial-checks-in-___slab_alloc-with-irqs-enabled-fix.patch

This patch was dropped because it was folded into mm-slub-do-initial-checks-in-___slab_alloc-with-irqs-enabled.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: prevent VM_BUG_ON in PageSlabPfmemalloc from ___slab_alloc

Clark Williams reported [1] a VM_BUG_ON in PageSlabPfmemalloc:

 page:000000009ac5dd73 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1ab3db
 flags: 0x17ffffc0000000(node=0|zone=2|lastcpupid=0x1fffff)
 raw: 0017ffffc0000000 ffffee1286aceb88 ffffee1287b66288 0000000000000000
 raw: 0000000000000000 0000000000100000 00000000ffffffff 0000000000000000
 page dumped because: VM_BUG_ON_PAGE(!PageSlab(page))
 ------------[ cut here ]------------
 kernel BUG at include/linux/page-flags.h:814!
 invalid opcode: 0000 [#1] PREEMPT_RT SMP PTI
 CPU: 3 PID: 12345 Comm: hackbench Not tainted 5.14.0-rc5-rt8+ #12
 Hardware name:  /NUC5i7RYB, BIOS RYBDWi35.86A.0359.2016.0906.1028 09/06/2016
 RIP: 0010:___slab_alloc+0x340/0x940
 Code: c6 48 0f a3 05 b1 7b 57 03 72 99 c7 85 78 ff ff ff ff ff ff ff 48 8b 7d 88 e9 8d fd ff ff 48 c7 c6 50 5a 7c b0 e>
 RSP: 0018:ffffba1c4a8b7ab0 EFLAGS: 00010293
 RAX: 0000000000000000 RBX: 0000000000000002 RCX: ffff9bb765118000
 RDX: 0000000000000000 RSI: ffffffffaf426050 RDI: 00000000ffffffff
 RBP: ffffba1c4a8b7b70 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000000 R11: 0000000000000000 R12: ffff9bb7410d3600
 R13: 0000000000400cc0 R14: 00000000001f7770 R15: ffff9bbe76df7770
 FS:  00007f474b1be740(0000) GS:ffff9bbe76c00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f60c04bdaf8 CR3: 0000000124f3a003 CR4: 00000000003706e0
 Call Trace:
  ? __alloc_skb+0x1db/0x270
  ? __alloc_skb+0x1db/0x270
  ? kmem_cache_alloc_node+0xa4/0x2b0
  kmem_cache_alloc_node+0xa4/0x2b0
  __alloc_skb+0x1db/0x270
  alloc_skb_with_frags+0x64/0x250
  sock_alloc_send_pskb+0x260/0x2b0
  ? bpf_lsm_socket_getpeersec_dgram+0xa/0x10
  unix_stream_sendmsg+0x27c/0x550
  ? unix_seqpacket_recvmsg+0x60/0x60
  sock_sendmsg+0xbd/0xd0
  sock_write_iter+0xb9/0x120
  new_sync_write+0x175/0x200
  vfs_write+0x3c4/0x510
  ksys_write+0xc9/0x110
  do_syscall_64+0x3b/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae

The problem is that we are opportunistically checking flags on a page in
irq enabled section.  If we are interrupted and the page is freed, it's
not an issue as we detect it after disabling irqs.  But on kernels with
CONFIG_DEBUG_VM.  The check for PageSlab flag in PageSlabPfmemalloc() can
fail.

Fix this by creating an "unsafe" version of the check that doesn't check
PageSlab.

[1] https://lore.kernel.org/lkml/20210812151803.52f84aaf@theseus.lan/

Link: https://lkml.kernel.org/r/f4756ee5-a7e9-ab02-3aba-1355f77b7c79@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Clark Williams <williams@redhat.com>
Tested-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    9 +++++++++
 mm/slub.c                  |   15 ++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

--- a/include/linux/page-flags.h~mm-slub-do-initial-checks-in-___slab_alloc-with-irqs-enabled-fix
+++ a/include/linux/page-flags.h
@@ -815,6 +815,15 @@ static inline int PageSlabPfmemalloc(str
 	return PageActive(page);
 }
 
+/*
+ * A version of PageSlabPfmemalloc() for opportunistic checks where the page
+ * might have been freed under us and not be a PageSlab anymore.
+ */
+static inline int __PageSlabPfmemalloc(struct page *page)
+{
+	return PageActive(page);
+}
+
 static inline void SetPageSlabPfmemalloc(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageSlab(page), page);
--- a/mm/slub.c~mm-slub-do-initial-checks-in-___slab_alloc-with-irqs-enabled-fix
+++ a/mm/slub.c
@@ -2607,6 +2607,19 @@ static inline bool pfmemalloc_match(stru
 }
 
 /*
+ * A variant of pfmemalloc_match() that tests page flags without asserting
+ * PageSlab. Intended for opportunistic checks before taking a lock and
+ * rechecking that nobody else freed the page under us.
+ */
+static inline bool pfmemalloc_match_unsafe(struct page *page, gfp_t gfpflags)
+{
+	if (unlikely(__PageSlabPfmemalloc(page)))
+		return gfp_pfmemalloc_allowed(gfpflags);
+
+	return true;
+}
+
+/*
  * Check the page->freelist of a page and either transfer the freelist to the
  * per cpu freelist or deactivate the page.
  *
@@ -2707,7 +2720,7 @@ redo:
 	 * PFMEMALLOC but right now, we are losing the pfmemalloc
 	 * information when the page leaves the per-cpu allocator
 	 */
-	if (unlikely(!pfmemalloc_match(page, gfpflags)))
+	if (unlikely(!try_pfmemalloc_match(page, gfpflags)))
 		goto deactivate_slab;
 
 	/* must check again c->page in case IRQ handler changed it */
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
mm-slub-do-initial-checks-in-___slab_alloc-with-irqs-enabled-fix-fix.patch
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
mm-slub-move-flush_cpu_slab-invocations-__free_slab-invocations-out-of-irq-context-fix.patch
mm-slub-move-flush_cpu_slab-invocations-__free_slab-invocations-out-of-irq-context-fix-2.patch
mm-slub-optionally-save-restore-irqs-in-slab_lock.patch
mm-slub-make-slab_lock-disable-irqs-with-preempt_rt.patch
mm-slub-protect-put_cpu_partial-with-disabled-irqs-instead-of-cmpxchg.patch
mm-slub-use-migrate_disable-on-preempt_rt.patch
mm-slub-convert-kmem_cpu_slab-protection-to-local_lock.patch
mm-slub-convert-kmem_cpu_slab-protection-to-local_lock-fix.patch
mm-slub-convert-kmem_cpu_slab-protection-to-local_lock-fix-2.patch
mm-vmscan-guarantee-drop_slab_node-termination.patch
mm-vmscan-guarantee-drop_slab_node-termination-fix.patch

