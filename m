From: akpm@linux-foundation.org
Subject: + make-dmapool-code-use-__set_current_state.patch added to -mm tree
Date: Fri, 31 Aug 2007 12:02:31 -0700
Message-ID: <200708311902.l7VJ2Vkw022045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34466 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965842AbXHaTCj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 15:02:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@infradead.org, arjan@Linux.intel.com


The patch titled
     make dmapool code use __set_current_state()
has been added to the -mm tree.  Its filename is
     make-dmapool-code-use-__set_current_state.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make dmapool code use __set_current_state()
From: Arjan van de Ven <arjan@infradead.org>

Signed-off-by: Arjan van de Ven <arjan@Linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dmapool.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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

acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
security-convert-lsm-into-a-static-interface.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
make-dmapool-code-use-__set_current_state.patch
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
