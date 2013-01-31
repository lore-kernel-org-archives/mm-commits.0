From: akpm@linux-foundation.org
Subject: + mm-use-vm_unmapped_area-on-powerpc-architecture.patch added to -mm tree
Date: Thu, 31 Jan 2013 13:55:50 -0800
Message-ID: <20130131215551.3147D5A422A@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:49663 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab3AaVzw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Jan 2013 16:55:52 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so238114ves.3
        for <mm-commits@vger.kernel.org>; Thu, 31 Jan 2013 13:55:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     Subject: mm: use vm_unmapped_area() on powerpc architecture
has been added to the -mm tree.  Its filename is
     mm-use-vm_unmapped_area-on-powerpc-architecture.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: use vm_unmapped_area() on powerpc architecture

Update the powerpc slice_get_unmapped_area function to make use of
vm_unmapped_area() instead of implementing a brute force search.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
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
-
-	for (;;) {
-		addr = _ALIGN_UP(addr, 1ul << pshift);
-		if ((TASK_SIZE - len) < addr)
-			break;
-		vma = find_vma(mm, addr);
-		BUG_ON(vma && (addr >= vma->vm_end));
+	info.flags = 0;
+	info.length = len;
+	info.align_mask = PAGE_MASK & ((1ul << pshift) - 1);
+	info.align_offset = 0;
 
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
 
-	addr = mm->mmap_base;
-	while (addr > len) {
-		/* Go down by chunk size */
-		addr = _ALIGN_DOWN(addr - len, 1ul << pshift);
+	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
+	info.length = len;
+	info.align_mask = PAGE_MASK & ((1ul << pshift) - 1);
+	info.align_offset = 0;
 
-		/* Check for hit with different page size */
-		mask = slice_range_to_mask(addr, len);
-		if (!slice_check_fit(mask, available)) {
-			if (addr < SLICE_LOW_TOP)
-				addr = _ALIGN_DOWN(addr, 1ul << SLICE_LOW_SHIFT);
-			else if (addr < (1ul << SLICE_HIGH_SHIFT))
-				addr = SLICE_LOW_TOP;
-			else
-				addr = _ALIGN_DOWN(addr, 1ul << SLICE_HIGH_SHIFT);
+	addr = mm->mmap_base;
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

thp-avoid-dumping-huge-zero-page.patch
linux-next.patch
mm-make-mlockall-preserve-flags-other-than-vm_locked-in-def_flags.patch
mm-remap_file_pages-fixes.patch
mm-introduce-mm_populate-for-populating-new-vmas.patch
mm-use-mm_populate-for-blocking-remap_file_pages.patch
mm-use-mm_populate-when-adjusting-brk-with-mcl_future-in-effect.patch
mm-use-mm_populate-for-mremap-of-vm_locked-vmas.patch
mm-remove-flags-argument-to-mmap_region.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
mm-directly-use-__mlock_vma_pages_range-in-find_extend_vma.patch
mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs.patch
mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool.patch
mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
mm-use-vm_unmapped_area-on-alpha-architecture.patch
mm-use-vm_unmapped_area-on-frv-architecture.patch
mm-use-vm_unmapped_area-on-ia64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-ia64-architecture.patch
mm-remove-free_area_cache-use-in-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-powerpc-architecture.patch
mm-remove-free_area_cache.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch
mutex-subsystem-synchro-test-module.patch

