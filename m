From: akpm@linux-foundation.org
Subject: - lib-swiotlbc-avoid-endless-loops.patch removed from -mm tree
Date: Mon, 17 Mar 2008 13:59:10 -0700
Message-ID: <200803172059.m2HKxAZN030758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752279AbYCQU7u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 16:59:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, ak@suse.de, fujita.tomonori@lab.ntt.co.jp, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     lib/swiotlb.c: avoid endless loops
has been removed from the -mm tree.  Its filename was
     lib-swiotlbc-avoid-endless-loops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/swiotlb.c: avoid endless loops
From: "Jan Beulich" <jbeulich@novell.com>

Commit 681cc5cd3efbeafca6386114070e0bfb5012e249 introduced two
possibilities for entering an endless loop in lib/swiotlb.c:

- if max_slots is zero (possible if mask is ~0UL)
- if the number of slots requested fits into a swiotlb segment, but is
  too large for the part of a segment which remains after considering
  offset_slots

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/swiotlb.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff -puN lib/swiotlb.c~lib-swiotlbc-avoid-endless-loops lib/swiotlb.c
--- a/lib/swiotlb.c~lib-swiotlbc-avoid-endless-loops
+++ a/lib/swiotlb.c
@@ -310,7 +310,9 @@ map_single(struct device *hwdev, char *b
 	start_dma_addr = virt_to_bus(io_tlb_start) & mask;
 
 	offset_slots = ALIGN(start_dma_addr, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
-	max_slots = ALIGN(mask + 1, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
+	max_slots = mask + 1
+		    ? ALIGN(mask + 1, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT
+		    : 1UL << (BITS_PER_LONG - IO_TLB_SHIFT);
 
 	/*
 	 * For mappings greater than a page, we limit the stride (and
@@ -333,16 +335,18 @@ map_single(struct device *hwdev, char *b
 		index = ALIGN(io_tlb_index, stride);
 		if (index >= io_tlb_nslabs)
 			index = 0;
-
-		while (is_span_boundary(index, nslots, offset_slots,
-					max_slots)) {
-			index += stride;
-			if (index >= io_tlb_nslabs)
-				index = 0;
-		}
 		wrap = index;
 
 		do {
+			while (is_span_boundary(index, nslots, offset_slots,
+						max_slots)) {
+				index += stride;
+				if (index >= io_tlb_nslabs)
+					index = 0;
+				if (index == wrap)
+					goto not_found;
+			}
+
 			/*
 			 * If we find a slot that indicates we have 'nslots'
 			 * number of contiguous buffers, we allocate the
@@ -367,14 +371,12 @@ map_single(struct device *hwdev, char *b
 
 				goto found;
 			}
-			do {
-				index += stride;
-				if (index >= io_tlb_nslabs)
-					index = 0;
-			} while (is_span_boundary(index, nslots, offset_slots,
-						  max_slots));
+			index += stride;
+			if (index >= io_tlb_nslabs)
+				index = 0;
 		} while (index != wrap);
 
+  not_found:
 		spin_unlock_irqrestore(&io_tlb_lock, flags);
 		return NULL;
 	}
_

Patches currently in -mm which might be from jbeulich@novell.com are

lib-swiotlbc-avoid-endless-loops-fix.patch
git-x86.patch
lib-swiotlbc-cleanups.patch

