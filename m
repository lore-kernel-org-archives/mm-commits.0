From: akpm@linux-foundation.org
Subject: - fix-swiotlb_sync_single_range.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:33:37 -0700
Message-ID: <200707230933.l6N9XbLD016313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48634 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755757AbXGWJeS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:34:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Keir.Fraser@cl.cam.ac.uk, ak@suse.de, keir.fraser@cl.cam.ac.uk, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Fix swiotlb_sync_single_range()
has been removed from the -mm tree.  Its filename was
     fix-swiotlb_sync_single_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix swiotlb_sync_single_range()
From: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>

If the swiotlb maps a multi-slab region, swiotlb_sync_single_range() can be
invoked to sync a sub-region which does not include the first slab. 
Unfortunately io_tlb_orig_addr[] is only initialised for the first slab,
and hence the call to sync_single() will read a garbage orig_addr in this
case.

This patch fixes the issue by initialising all mapped slabs in
io_tlb_orig_addr[].  It also correctly adjusts the buffer pointer in
sync_single() to handle the case that the given dma_addr is not aligned on
a slab boundary.

Signed-off-by: Keir Fraser <keir.fraser@cl.cam.ac.uk>
Cc: "Luck, Tony" <tony.luck@intel.com>
Acked-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/swiotlb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN lib/swiotlb.c~fix-swiotlb_sync_single_range lib/swiotlb.c
--- a/lib/swiotlb.c~fix-swiotlb_sync_single_range
+++ a/lib/swiotlb.c
@@ -357,7 +357,8 @@ map_single(struct device *hwdev, char *b
 	 * This is needed when we sync the memory.  Then we sync the buffer if
 	 * needed.
 	 */
-	io_tlb_orig_addr[index] = buffer;
+	for (i = 0; i < nslots; i++)
+		io_tlb_orig_addr[index+i] = buffer + (i << IO_TLB_SHIFT);
 	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
 		memcpy(dma_addr, buffer, size);
 
@@ -418,6 +419,8 @@ sync_single(struct device *hwdev, char *
 	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
 	char *buffer = io_tlb_orig_addr[index];
 
+	buffer += ((unsigned long)dma_addr & ((1 << IO_TLB_SHIFT) - 1));
+
 	switch (target) {
 	case SYNC_FOR_CPU:
 		if (likely(dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL))
_

Patches currently in -mm which might be from Keir.Fraser@cl.cam.ac.uk are
