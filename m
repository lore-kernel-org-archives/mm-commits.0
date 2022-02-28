Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D871C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 16:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbiB1QXW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 11:23:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiB1QXW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 11:23:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130A91C10C
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 08:22:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2CAD611BE
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 16:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC211C340E7;
        Mon, 28 Feb 2022 16:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646065362;
        bh=6JyymrsisQY9Y+5+sZovdVnoH2Z2CaKYL0dXRD+0eyQ=;
        h=Date:To:From:Subject:From;
        b=LTXlkRuJVGcKTFgkEvkZow2j3nHTzQ7ivDSsqILyJuHMVTtXkZEMXhdMWGd1hzfs6
         kYNnmzRmmmDY91ISSadW0UvtYCUu3RWrNF//E0bdwh4RfQv859WWj8WaBWmffaqQ43
         SFDwDZuofOIjcPdg0jFow7wH95BJe5rsKt+xJY8k=
Date:   Mon, 28 Feb 2022 08:22:41 -0800
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Message-Id: <20220228162241.EC211C340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pinctrl/pinctrl-starfive.c |    5 -----
 drivers/spi/spi-rockchip.c         |    3 ---
 fs/btrfs/lzo.c                     |    4 ----
 mm/mmap.c                          |    6 ------
 4 files changed, 18 deletions(-)

--- a/drivers/pinctrl/pinctrl-starfive.c~linux-next-git-rejects
+++ a/drivers/pinctrl/pinctrl-starfive.c
@@ -1308,11 +1308,6 @@ static int starfive_probe(struct platfor
 	sfp->gc.base = -1;
 	sfp->gc.ngpio = NR_GPIOS;
 
-<<<<<<< HEAD
-	starfive_irq_chip.parent_device = dev;
-
-=======
->>>>>>> linux-next/akpm-base
 	sfp->gc.irq.chip = &starfive_irq_chip;
 	sfp->gc.irq.parent_handler = starfive_gpio_irq_handler;
 	sfp->gc.irq.num_parents = 1;
--- a/drivers/spi/spi-rockchip.c~linux-next-git-rejects
+++ a/drivers/spi/spi-rockchip.c
@@ -645,10 +645,7 @@ static int rockchip_spi_slave_abort(stru
 		rs->xfer->len = (unsigned int)(rs->rx - rs->xfer->rx_buf);
 	}
 
-<<<<<<< HEAD
-=======
 out:
->>>>>>> linux-next/akpm-base
 	if (atomic_read(&rs->state) & RXDMA)
 		dmaengine_terminate_sync(ctlr->dma_rx);
 	if (atomic_read(&rs->state) & TXDMA)
--- a/fs/btrfs/lzo.c~linux-next-git-rejects
+++ a/fs/btrfs/lzo.c
@@ -383,11 +383,7 @@ int lzo_decompress_bio(struct list_head
 		kunmap(cur_page);
 		cur_in += LZO_LEN;
 
-<<<<<<< HEAD
-		if (seg_len > lzo1x_worst_compress(PAGE_SIZE)) {
-=======
 		if (seg_len > WORKSPACE_CBUF_LENGTH) {
->>>>>>> linux-next/akpm-base
 			/*
 			 * seg_len shouldn't be larger than we have allocated
 			 * for workspace->cbuf
--- a/mm/mmap.c~linux-next-git-rejects
+++ a/mm/mmap.c
@@ -3114,11 +3114,6 @@ void exit_mmap(struct mm_struct *mm)
 		remove_vma(vma);
 		count++;
 		cond_resched();
-<<<<<<< HEAD
-	}
-	mm->mmap = NULL;
-	mmap_write_unlock(mm);
-=======
 	} while ((vma = mas_find(&mas, ULONG_MAX)) != NULL);
 
 	BUG_ON(count != mm->map_count);
@@ -3127,7 +3122,6 @@ void exit_mmap(struct mm_struct *mm)
 	__mt_destroy(&mm->mm_mt);
 	rwsem_release(&mm->mmap_lock.dep_map, _THIS_IP_);
 
->>>>>>> linux-next/akpm-base
 	vm_unacct_memory(nr_accounted);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
x86-mm-enable-arch_has_vm_get_page_prot-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
drivers-gpu-drm-dp-drm_dpc-fix-build.patch
arch-x86-kernel-resourcec-needs-spinlockh.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

