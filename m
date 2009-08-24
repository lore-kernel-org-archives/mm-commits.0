From: akpm@linux-foundation.org
Subject: [merged] lib-swiotlbc-fix-strange-panic-message-selection-logic-when-swiotlb-fills-up.patch removed from -mm tree
Date: Mon, 24 Aug 2009 12:00:05 -0700
Message-ID: <200908241900.n7OJ05v7031375@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724AbZHXTAg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 15:00:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cdahlin@redhat.com, beckyb@kernel.crashing.org, fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lib/swiotlb.c: fix strange panic message selection logic when swiotlb fills up
has been removed from the -mm tree.  Its filename was
     lib-swiotlbc-fix-strange-panic-message-selection-logic-when-swiotlb-fills-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/swiotlb.c: fix strange panic message selection logic when swiotlb fills up
From: Casey Dahlin <cdahlin@redhat.com>

swiotlb_full in lib/swiotlb.c throws one of two panic messages based on
whether the direction of transfer is from the device or to the device. 
The logic around this is somewhat weird in the case of bidirectional
transfers.  It appears to want to throw both in succession, but since its
a panic only the first makes it.

This patch adds a third, separate error for DMA_BIDIRECTIONAL to make
things a bit clearer.

Signed-off-by: Casey Dahlin <cdahlin@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Becky Bruce <beckyb@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/swiotlb.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN lib/swiotlb.c~lib-swiotlbc-fix-strange-panic-message-selection-logic-when-swiotlb-fills-up lib/swiotlb.c
--- a/lib/swiotlb.c~lib-swiotlbc-fix-strange-panic-message-selection-logic-when-swiotlb-fills-up
+++ a/lib/swiotlb.c
@@ -581,12 +581,15 @@ swiotlb_full(struct device *dev, size_t 
 	printk(KERN_ERR "DMA: Out of SW-IOMMU space for %zu bytes at "
 	       "device %s\n", size, dev ? dev_name(dev) : "?");
 
-	if (size > io_tlb_overflow && do_panic) {
-		if (dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)
-			panic("DMA: Memory would be corrupted\n");
-		if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
-			panic("DMA: Random memory would be DMAed\n");
-	}
+	if (size <= io_tlb_overflow || !do_panic)
+		return;
+
+	if (dir == DMA_BIDIRECTIONAL)
+		panic("DMA: Random memory could be corrupted or DMAed\n");
+	if (dir == DMA_FROM_DEVICE)
+		panic("DMA: Memory would be corrupted\n");
+	if (dir == DMA_TO_DEVICE)
+		panic("DMA: Random memory would be DMAed\n");
 }
 
 /*
_

Patches currently in -mm which might be from cdahlin@redhat.com are

linux-next.patch

