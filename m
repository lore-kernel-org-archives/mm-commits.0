From: akpm@linux-foundation.org
Subject: - make-dmapool-code-use-__set_current_state.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:59:38 -0700
Message-ID: <200710180659.l9I6xc7R031000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49963 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757087AbXJRG7q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 02:59:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@infradead.org, arjan@Linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     make dmapool code use __set_current_state()
has been removed from the -mm tree.  Its filename was
     make-dmapool-code-use-__set_current_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make dmapool code use __set_current_state()
From: Arjan van de Ven <arjan@infradead.org>

Signed-off-by: Arjan van de Ven <arjan@Linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dmapool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/dmapool.c~make-dmapool-code-use-__set_current_state drivers/base/dmapool.c
--- a/drivers/base/dmapool.c~make-dmapool-code-use-__set_current_state
+++ a/drivers/base/dmapool.c
@@ -302,7 +302,7 @@ restart:
 		if (mem_flags & __GFP_WAIT) {
 			DECLARE_WAITQUEUE (wait, current);
 
-			current->state = TASK_INTERRUPTIBLE;
+			__set_current_state(TASK_INTERRUPTIBLE);
 			add_wait_queue (&pool->waitq, &wait);
 			spin_unlock_irqrestore (&pool->lock, flags);
 
_

Patches currently in -mm which might be from arjan@infradead.org are

origin.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-fix.patch
pm-qos-infrastructure-and-interface-vs-git-acpi.patch
pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers-checkpatch-fixes.patch
latencyc-use-qos-infrastructure.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-optimize-sg-map-unmap-calls.patch
uninline-forkc-exitc.patch
uninline-forkc-exitc-checkpatch-fixes.patch
