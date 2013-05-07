From: akpm@linux-foundation.org
Subject: [merged] mm-use-vm_unmapped_area-on-powerpc-architecture.patch removed from -mm tree
Date: Tue, 07 May 2013 10:51:40 -0700
Message-ID: <20130507175140.8002B5A451C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:50715 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3EGRvl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:51:41 -0400
Received: by mail-yh0-f73.google.com with SMTP id a41so86521yho.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:51:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, david@gibson.dropbear.id.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use vm_unmapped_area() on powerpc architecture
has been removed from the -mm tree.  Its filename was
     mm-use-vm_unmapped_area-on-powerpc-architecture.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: use vm_unmapped_area() on powerpc architecture

Update the powerpc slice_get_unmapped_area function to make use of
vm_unmapped_area() instead of implementing a brute force search.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Tested-by: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/slice.c |  123 ++++++++++++++++++++++++--------------
 1 file changed, 78 insertions(+), 45 deletions(-)

diff -puN arch/powerpc/mm/slice.c~mm-use-vm_unmapped_area-on-powerpc-architecture arch/powerpc/mm/slice.c
--- a/arch/powerpc/mm/slice.c~mm-use-vm_unmapped_area-on-powerpc-architecture
+++ a/arch/powerpc/mm/slice.c
@@ -237,36 +237,69 @@ static void slice_convert(struct mm_stru
 #endif
 }
 
+/*
+ * Compute which slice addr is part of;
+ * set *boundary_addr to the start or end boundary of that slice
+ * (depending on 'end' parameter);
+ * return boolean indicating if the slice is marked as available in the
+ * 'available' slice_mark.
+ */
+static bool slice_scan_available(unsigned long addr,
+				 struct slice_mask available,
+				 int end,
+				 unsigned long *boundary_addr)
+{
+	unsigned long slice;
+	if (addr < SLICE_LOW_TOP) {
+		slice = GET_LOW_SLICE_INDEX(addr);
+		*boundary_addr = (slice + end) << SLICE_LOW_SHIFT;
+		return !!(available.low_slices & (1u << slice));
+	} else {
+		slice = GET_HIGH_SLICE_INDEX(addr);
+		*boundary_addr = (slice + end) ?
+			((slice + end) << SLICE_HIGH_SHIFT) : SLICE_LOW_TOP;
+		return !!(available.high_slices & (1u << slice));
+	}
+}
+
 static unsigned long slice_find_area_bottomup(struct mm_struct *mm,
 					      unsigned long len,
 					      struct slice_mask available,
 					      int psize)
 {
-	struct vm_area_struct *vma;
-	unsigned long addr;
-	struct slice_mask mask;
 	int pshift = max_t(int, mmu_psize_defs[psize].shift, PAGE_SHIFT);
+	unsigned long addr, found, next_end;
+	struct vm_unmapped_area_info info;
 
-	addr = TASK_UNMAPPED_BASE;
+	info.flags = 0;
+	info.length = len;
+	info.align_mask = PAGE_MASK & ((1ul << pshift) - 1);
+	info.align_offset = 0;
 
-	for (;;) {
-		addr = _ALIGN_UP(addr, 1ul << pshift);
-		if ((TASK_SIZE - len) < addr)
-			break;
-		vma = find_vma(mm, addr);
-		BUG_ON(vma && (addr >= vma->vm_end));
-
-		mask = slice_range_to_mask(addr, len);
-		if (!slice_check_fit(mask, available)) {
-			if (addr < SLICE_LOW_TOP)
-				addr = _ALIGN_UP(addr + 1,  1ul << SLICE_LOW_SHIFT);
-			else
-				addr = _ALIGN_UP(addr + 1,  1ul << SLICE_HIGH_SHIFT);
+	addr = TASK_UNMAPPED_BASE;
+	while (addr < TASK_SIZE) {
+		info.low_limit = addr;
+		if (!slice_scan_available(addr, available, 1, &addr))
 			continue;
+
+ next_slice:
+		/*
+		 * At this point [info.low_limit; addr) covers
+		 * available slices only and ends at a slice boundary.
+		 * Check if we need to reduce the range, or if we can
+		 * extend it to cover the next available slice.
+		 */
+		if (addr >= TASK_SIZE)
+			addr = TASK_SIZE;
+		else if (slice_scan_available(addr, available, 1, &next_end)) {
+			addr = next_end;
+			goto next_slice;
 		}
-		if (!vma || addr + len <= vma->vm_start)
-			return addr;
-		addr = vma->vm_end;
+		info.high_limit = addr;
+
+		found = vm_unmapped_area(&info);
+		if (!(found & ~PAGE_MASK))
+			return found;
 	}
 
 	return -ENOMEM;
@@ -277,39 +310,39 @@ static unsigned long slice_find_area_top
 					     struct slice_mask available,
 					     int psize)
 {
-	struct vm_area_struct *vma;
-	unsigned long addr;
-	struct slice_mask mask;
 	int pshift = max_t(int, mmu_psize_defs[psize].shift, PAGE_SHIFT);
+	unsigned long addr, found, prev;
+	struct vm_unmapped_area_info info;
+
+	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
+	info.length = len;
+	info.align_mask = PAGE_MASK & ((1ul << pshift) - 1);
+	info.align_offset = 0;
 
 	addr = mm->mmap_base;
-	while (addr > len) {
-		/* Go down by chunk size */
-		addr = _ALIGN_DOWN(addr - len, 1ul << pshift);
-
-		/* Check for hit with different page size */
-		mask = slice_range_to_mask(addr, len);
-		if (!slice_check_fit(mask, available)) {
-			if (addr < SLICE_LOW_TOP)
-				addr = _ALIGN_DOWN(addr, 1ul << SLICE_LOW_SHIFT);
-			else if (addr < (1ul << SLICE_HIGH_SHIFT))
-				addr = SLICE_LOW_TOP;
-			else
-				addr = _ALIGN_DOWN(addr, 1ul << SLICE_HIGH_SHIFT);
+	while (addr > PAGE_SIZE) {
+		info.high_limit = addr;
+		if (!slice_scan_available(addr - 1, available, 0, &addr))
 			continue;
-		}
 
+ prev_slice:
 		/*
-		 * Lookup failure means no vma is above this address,
-		 * else if new region fits below vma->vm_start,
-		 * return with success:
+		 * At this point [addr; info.high_limit) covers
+		 * available slices only and starts at a slice boundary.
+		 * Check if we need to reduce the range, or if we can
+		 * extend it to cover the previous available slice.
 		 */
-		vma = find_vma(mm, addr);
-		if (!vma || (addr + len) <= vma->vm_start)
-			return addr;
+		if (addr < PAGE_SIZE)
+			addr = PAGE_SIZE;
+		else if (slice_scan_available(addr - 1, available, 0, &prev)) {
+			addr = prev;
+			goto prev_slice;
+		}
+		info.low_limit = addr;
 
-		/* try just below the current vma->vm_start */
-		addr = vma->vm_start;
+		found = vm_unmapped_area(&info);
+		if (!(found & ~PAGE_MASK))
+			return found;
 	}
 
 	/*
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
mm-remove-free_area_cache.patch
mutex-subsystem-synchro-test-module.patch

