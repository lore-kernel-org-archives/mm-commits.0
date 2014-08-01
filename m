From: akpm@linux-foundation.org
Subject: +
 mm-close-race-between-do_fault_around-and-fault_around_bytes_set.patch
 added to -mm tree
Date: Fri, 01 Aug 2014 13:24:06 -0700
Message-ID: <53dbf766.hZUXyUXhJC12CNt3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:58066 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206AbaHAUYI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Aug 2014 16:24:08 -0400
Received: by mail-vc0-f202.google.com with SMTP id hq11so604564vcb.5
        for <mm-commits@vger.kernel.org>; Fri, 01 Aug 2014 13:24:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, a.ryabinin@samsung.com, dave.hansen@intel.com, rientjes@google.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: close race between do_fault_around() and fault_around_bytes_set()
has been added to the -mm tree.  Its filename is
     mm-close-race-between-do_fault_around-and-fault_around_bytes_set.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-close-race-between-do_fault_around-and-fault_around_bytes_set.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-close-race-between-do_fault_around-and-fault_around_bytes_set.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: close race between do_fault_around() and fault_around_bytes_set()

Things can go wrong if fault_around_bytes will be changed under
do_fault_around(): between fault_around_mask() and fault_around_pages().

Let's read fault_around_bytes only once during do_fault_around() and
calculate mask based on the reading.

Note: fault_around_bytes can only be updated via debug interface.  Also
I've tried but was not able to trigger a bad behaviour without the patch. 
So I would not consider this patch as urgent.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff -puN mm/memory.c~mm-close-race-between-do_fault_around-and-fault_around_bytes_set mm/memory.c
--- a/mm/memory.c~mm-close-race-between-do_fault_around-and-fault_around_bytes_set
+++ a/mm/memory.c
@@ -2770,16 +2770,6 @@ void do_set_pte(struct vm_area_struct *v
 
 static unsigned long fault_around_bytes = rounddown_pow_of_two(65536);
 
-static inline unsigned long fault_around_pages(void)
-{
-	return fault_around_bytes >> PAGE_SHIFT;
-}
-
-static inline unsigned long fault_around_mask(void)
-{
-	return ~(fault_around_bytes - 1) & PAGE_MASK;
-}
-
 #ifdef CONFIG_DEBUG_FS
 static int fault_around_bytes_get(void *data, u64 *val)
 {
@@ -2844,12 +2834,15 @@ late_initcall(fault_around_debugfs);
 static void do_fault_around(struct vm_area_struct *vma, unsigned long address,
 		pte_t *pte, pgoff_t pgoff, unsigned int flags)
 {
-	unsigned long start_addr;
+	unsigned long start_addr, nr_pages, mask;
 	pgoff_t max_pgoff;
 	struct vm_fault vmf;
 	int off;
 
-	start_addr = max(address & fault_around_mask(), vma->vm_start);
+	nr_pages = ACCESS_ONCE(fault_around_bytes) >> PAGE_SHIFT;
+	mask = ~(nr_pages * PAGE_SIZE - 1) & PAGE_MASK;
+
+	start_addr = max(address & mask, vma->vm_start);
 	off = ((address - start_addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
 	pte -= off;
 	pgoff -= off;
@@ -2861,7 +2854,7 @@ static void do_fault_around(struct vm_ar
 	max_pgoff = pgoff - ((start_addr >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)) +
 		PTRS_PER_PTE - 1;
 	max_pgoff = min3(max_pgoff, vma_pages(vma) + vma->vm_pgoff - 1,
-			pgoff + fault_around_pages() - 1);
+			pgoff + nr_pages - 1);
 
 	/* Check if it makes any sense to call ->map_pages */
 	while (!pte_none(*pte)) {
@@ -2896,7 +2889,7 @@ static int do_read_fault(struct mm_struc
 	 * something).
 	 */
 	if (vma->vm_ops->map_pages && !(flags & FAULT_FLAG_NONLINEAR) &&
-	    fault_around_pages() > 1) {
+	    fault_around_bytes >> PAGE_SHIFT > 1) {
 		pte = pte_offset_map_lock(mm, pmd, address, &ptl);
 		do_fault_around(vma, address, pte, pgoff, flags);
 		if (!pte_same(*pte, orig_pte))
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch
mm-thp-move-invariant-bug-check-out-of-loop-in-__split_huge_page_map.patch
mm-thp-replace-smp_mb-after-atomic_add-by-smp_mb__after_atomic.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
mm-thp-only-collapse-hugepages-to-nodes-with-affinity-for-zone_reclaim_mode.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch
mm-oom-remove-unnecessary-check-for-null-zonelist.patch
mm-oom-rename-zonelist-locking-functions.patch
mm-close-race-between-do_fault_around-and-fault_around_bytes_set.patch
mm-mark-fault_around_bytes-__read_mostly.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-2.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

