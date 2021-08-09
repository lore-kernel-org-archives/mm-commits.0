Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B169CC4338F
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 17:30:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E72860E76
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 17:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234227AbhHIRbG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Aug 2021 13:31:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233996AbhHIRbG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 9 Aug 2021 13:31:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D465F60560;
        Mon,  9 Aug 2021 17:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628530245;
        bh=PIxbiWXXxGuxYaUVAEAxKJH6h6CWAulHBfyMGAwJB1I=;
        h=Date:From:To:Subject:From;
        b=lPHy+cE4oznC5p9LQa36Pwyp/y4c6i1QXyr3UnU5/wyush9jRP0o3+fj5RB+uGD1q
         0ufn5eHc446fetv2kEt91GRfiCjCDcVY/Q0iiiGckWIVi2rx0KQOOshW+fPPQxe109
         rD1SNr/e3cb72nIfe1msh67qVW/IlljLzTf70WfY=
Date:   Mon, 09 Aug 2021 10:30:45 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20210809173045.76LQtP5o_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
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

 drivers/dma/idxd/idxd.h                 |    5 --
 drivers/dma/idxd/init.c                 |    4 --
 drivers/dma/idxd/irq.c                  |   40 ----------------------
 drivers/dma/idxd/submit.c               |   22 ------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    3 -
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h     |    4 --
 sound/usb/card.c                        |    4 --
 sound/usb/clock.c                       |    8 ----
 8 files changed, 90 deletions(-)

--- a/drivers/dma/idxd/idxd.h~linux-next-git-rejects
+++ a/drivers/dma/idxd/idxd.h
@@ -327,10 +327,6 @@ enum idxd_completion_status {
 	IDXD_COMP_DESC_ABORT = 0xff,
 };
 
-<<<<<<< HEAD
-#define confdev_to_idxd(dev) container_of(dev, struct idxd_device, conf_dev)
-#define confdev_to_wq(dev) container_of(dev, struct idxd_wq, conf_dev)
-=======
 #define idxd_confdev(idxd) &idxd->idxd_dev.conf_dev
 #define wq_confdev(wq) &wq->idxd_dev.conf_dev
 #define engine_confdev(engine) &engine->idxd_dev.conf_dev
@@ -385,7 +381,6 @@ static inline void idxd_dev_set_type(str
 
 	idev->type = type;
 }
->>>>>>> linux-next/akpm-base
 
 extern struct bus_type dsa_bus_type;
 
--- a/drivers/dma/idxd/init.c~linux-next-git-rejects
+++ a/drivers/dma/idxd/init.c
@@ -815,11 +815,7 @@ static void idxd_remove(struct pci_dev *
 	pci_disable_device(pdev);
 	destroy_workqueue(idxd->wq);
 	perfmon_pmu_remove(idxd);
-<<<<<<< HEAD
-	device_unregister(&idxd->conf_dev);
-=======
 	device_unregister(idxd_confdev(idxd));
->>>>>>> linux-next/akpm-base
 }
 
 static struct pci_driver idxd_pci_driver = {
--- a/drivers/dma/idxd/irq.c~linux-next-git-rejects
+++ a/drivers/dma/idxd/irq.c
@@ -177,26 +177,6 @@ irqreturn_t idxd_misc_thread(int vec, vo
 	return IRQ_HANDLED;
 }
 
-<<<<<<< HEAD
-static inline bool match_fault(struct idxd_desc *desc, u64 fault_addr)
-{
-	/*
-	 * Completion address can be bad as well. Check fault address match for descriptor
-	 * and completion address.
-	 */
-	if ((u64)desc->hw == fault_addr || (u64)desc->completion == fault_addr) {
-		struct idxd_device *idxd = desc->wq->idxd;
-		struct device *dev = &idxd->pdev->dev;
-
-		dev_warn(dev, "desc with fault address: %#llx\n", fault_addr);
-		return true;
-	}
-
-	return false;
-}
-
-=======
->>>>>>> linux-next/akpm-base
 static int irq_process_pending_llist(struct idxd_irq_entry *irq_entry,
 				     int *processed, u64 data)
 {
@@ -214,27 +194,17 @@ static int irq_process_pending_llist(str
 		u8 status = desc->completion->status & DSA_COMP_STATUS_MASK;
 
 		if (status) {
-<<<<<<< HEAD
-			if (unlikely(status == IDXD_COMP_DESC_ABORT)) {
-=======
 			/*
 			 * Check against the original status as ABORT is software defined
 			 * and 0xff, which DSA_COMP_STATUS_MASK can mask out.
 			 */
 			if (unlikely(desc->completion->status == IDXD_COMP_DESC_ABORT)) {
->>>>>>> linux-next/akpm-base
 				complete_desc(desc, IDXD_COMPLETE_ABORT);
 				(*processed)++;
 				continue;
 			}
 
-<<<<<<< HEAD
-			if (unlikely(status != DSA_COMP_SUCCESS))
-				match_fault(desc, data);
-			complete_desc(desc, reason);
-=======
 			complete_desc(desc, IDXD_COMPLETE_NORMAL);
->>>>>>> linux-next/akpm-base
 			(*processed)++;
 		} else {
 			spin_lock_irqsave(&irq_entry->list_lock, flags);
@@ -284,26 +254,16 @@ static int irq_process_work_list(struct
 	list_for_each_entry(desc, &flist, list) {
 		u8 status = desc->completion->status & DSA_COMP_STATUS_MASK;
 
-<<<<<<< HEAD
-		if (unlikely(status == IDXD_COMP_DESC_ABORT)) {
-=======
 		/*
 		 * Check against the original status as ABORT is software defined
 		 * and 0xff, which DSA_COMP_STATUS_MASK can mask out.
 		 */
 		if (unlikely(desc->completion->status == IDXD_COMP_DESC_ABORT)) {
->>>>>>> linux-next/akpm-base
 			complete_desc(desc, IDXD_COMPLETE_ABORT);
 			continue;
 		}
 
-<<<<<<< HEAD
-		if (unlikely(status != DSA_COMP_SUCCESS))
-			match_fault(desc, data);
-		complete_desc(desc, reason);
-=======
 		complete_desc(desc, IDXD_COMPLETE_NORMAL);
->>>>>>> linux-next/akpm-base
 	}
 
 	return queued;
--- a/drivers/dma/idxd/submit.c~linux-next-git-rejects
+++ a/drivers/dma/idxd/submit.c
@@ -25,25 +25,10 @@ static struct idxd_desc *__get_desc(stru
 	 * On host, MSIX vecotr 0 is used for misc interrupt. Therefore when we match
 	 * vector 1:1 to the WQ id, we need to add 1
 	 */
-<<<<<<< HEAD
-	wq->vec_ptr = desc->vector = (wq->vec_ptr % idxd->num_wq_irqs) + 1;
-	if (!idxd->int_handles) {
-		desc->hw->int_handle = wq->vec_ptr;
-	} else {
-		/*
-		 * int_handles are only for descriptor completion. However for device
-		 * MSIX enumeration, vec 0 is used for misc interrupts. Therefore even
-		 * though we are rotating through 1...N for descriptor interrupts, we
-		 * need to acqurie the int_handles from 0..N-1.
-		 */
-		desc->hw->int_handle = idxd->int_handles[desc->vector - 1];
-	}
-=======
 	if (!idxd->int_handles)
 		desc->hw->int_handle = wq->id + 1;
 	else
 		desc->hw->int_handle = idxd->int_handles[wq->id];
->>>>>>> linux-next/akpm-base
 
 	return desc;
 }
@@ -175,11 +160,7 @@ int idxd_submit_desc(struct idxd_wq *wq,
 	 * that we designated the descriptor to.
 	 */
 	if (desc->hw->flags & IDXD_OP_FLAG_RCI) {
-<<<<<<< HEAD
-		ie = &idxd->irq_entries[desc->vector];
-=======
 		ie = &idxd->irq_entries[wq->id + 1];
->>>>>>> linux-next/akpm-base
 		llist_add(&desc->llnode, &ie->pending_llist);
 	}
 
@@ -194,10 +175,7 @@ int idxd_submit_desc(struct idxd_wq *wq,
 		 */
 		rc = enqcmds(portal, desc->hw);
 		if (rc < 0) {
-<<<<<<< HEAD
-=======
 			percpu_ref_put(&wq->wq_active);
->>>>>>> linux-next/akpm-base
 			if (ie)
 				llist_abort_desc(wq, ie, desc);
 			return rc;
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1219,8 +1219,6 @@ static const struct pci_device_id pciidl
 	{0x1002, 0x7423, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BEIGE_GOBY},
 	{0x1002, 0x743F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BEIGE_GOBY},
 
-<<<<<<< HEAD
-=======
 	/* CYAN_SKILLFISH */
 	{0x1002, 0x13FE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYAN_SKILLFISH|AMD_IS_APU},
 
@@ -1231,7 +1229,6 @@ static const struct pci_device_id pciidl
 	{0x1002, 0x7423, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BEIGE_GOBY},
 	{0x1002, 0x743F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BEIGE_GOBY},
 
->>>>>>> linux-next/akpm-base
 	{0, 0, 0}
 };
 
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h~linux-next-git-rejects
+++ a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -492,11 +492,7 @@ struct vmw_private {
 	resource_size_t io_start;
 	resource_size_t vram_start;
 	resource_size_t vram_size;
-<<<<<<< HEAD
-	resource_size_t prim_bb_mem;
-=======
 	resource_size_t max_primary_mem;
->>>>>>> linux-next/akpm-base
 	u32 __iomem *rmmio;
 	u32 *fifo_mem;
 	resource_size_t fifo_mem_size;
--- a/sound/usb/card.c~linux-next-git-rejects
+++ a/sound/usb/card.c
@@ -941,11 +941,7 @@ static void usb_audio_disconnect(struct
 		}
 	}
 
-<<<<<<< HEAD
-	if (chip->quirk_type == QUIRK_SETUP_DISABLE_AUTOSUSPEND)
-=======
 	if (chip->quirk_flags & QUIRK_FLAG_DISABLE_AUTOSUSPEND)
->>>>>>> linux-next/akpm-base
 		usb_enable_autosuspend(interface_to_usbdev(intf));
 
 	chip->num_interfaces--;
--- a/sound/usb/clock.c~linux-next-git-rejects
+++ a/sound/usb/clock.c
@@ -324,16 +324,8 @@ static int __uac_clock_find_source(struc
 					      sources[ret - 1],
 					      visited, validate);
 		if (ret > 0) {
-<<<<<<< HEAD
-			/*
-			 * For Samsung USBC Headset (AKG), setting clock selector again
-			 * will result in incorrect default clock setting problems
-			 */
-			if (chip->usb_id == USB_ID(0x04e8, 0xa051))
-=======
 			/* Skip setting clock selector again for some devices */
 			if (chip->quirk_flags & QUIRK_FLAG_SKIP_CLOCK_SELECTOR)
->>>>>>> linux-next/akpm-base
 				return ret;
 			err = uac_clock_selector_set_val(chip, entity_id, cur);
 			if (err < 0)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix.patch
mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix-fix.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-compaction-optimize-proactive-compaction-deferrals-fix.patch
mm-compaction-support-triggering-of-proactive-compaction-by-user-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch
log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

