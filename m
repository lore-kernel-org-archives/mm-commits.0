From: akpm@linux-foundation.org
Subject: [merged] mm-dmapoolc-use-task_uninterruptible-in-dma_pool_alloc.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:49:09 -0800
Message-ID: <201101142251.p0EMpxnM005560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449Ab1ANWwL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:52:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, eike-kernel@sf-tec.de, mm-commits@vger.kernel.org


The patch titled
     mm/dmapool.c: use TASK_UNINTERRUPTIBLE in dma_pool_alloc()
has been removed from the -mm tree.  Its filename was
     mm-dmapoolc-use-task_uninterruptible-in-dma_pool_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/dmapool.c: use TASK_UNINTERRUPTIBLE in dma_pool_alloc()
From: Andrew Morton <akpm@linux-foundation.org>

As it stands this code will degenerate into a busy-wait if the calling task
has signal_pending().

Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/dmapool.c~mm-dmapoolc-use-task_uninterruptible-in-dma_pool_alloc mm/dmapool.c
--- a/mm/dmapool.c~mm-dmapoolc-use-task_uninterruptible-in-dma_pool_alloc
+++ a/mm/dmapool.c
@@ -324,7 +324,7 @@ void *dma_pool_alloc(struct dma_pool *po
 		if (mem_flags & __GFP_WAIT) {
 			DECLARE_WAITQUEUE(wait, current);
 
-			__set_current_state(TASK_INTERRUPTIBLE);
+			__set_current_state(TASK_UNINTERRUPTIBLE);
 			__add_wait_queue(&pool->waitq, &wait);
 			spin_unlock_irqrestore(&pool->lock, flags);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-nfc-pn544c-fix-min_t-warnings.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
mm-deactivate-invalidated-pages-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

