From: akpm@linux-foundation.org
Subject: [merged]
 mm-softdirty-unmapped-addresses-between-vmas-are-clean.patch removed from
 -mm tree
Date: Mon, 13 Oct 2014 11:20:49 -0700
Message-ID: <543c1801.69+5fuYQRF3F3ih2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaJMSUt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:20:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pfeiner@google.com, gorcunov@openvz.org, hughd@google.com, jamieliu@google.com, kirill@shutemov.name, n-horiguchi@ah.jp.nec.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: softdirty: unmapped addresses between VMAs are clean
has been removed from the -mm tree.  Its filename was
     mm-softdirty-unmapped-addresses-between-vmas-are-clean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Feiner <pfeiner@google.com>
Subject: mm: softdirty: unmapped addresses between VMAs are clean

If a /proc/pid/pagemap read spans a [VMA, an unmapped region, then a
VM_SOFTDIRTY VMA], the virtual pages in the unmapped region are reported
as softdirty.  Here's a program to demonstrate the bug:

int main() {
	const uint64_t PAGEMAP_SOFTDIRTY = 1ul << 55;
	uint64_t pme[3];
	int fd = open("/proc/self/pagemap", O_RDONLY);;
	char *m = mmap(NULL, 3 * getpagesize(), PROT_READ,
	               MAP_ANONYMOUS | MAP_SHARED, -1, 0);
	munmap(m + getpagesize(), getpagesize());
	pread(fd, pme, 24, (unsigned long) m / getpagesize() * 8);
	assert(pme[0] & PAGEMAP_SOFTDIRTY);    /* passes */
	assert(!(pme[1] & PAGEMAP_SOFTDIRTY)); /* fails */
	assert(pme[2] & PAGEMAP_SOFTDIRTY);    /* passes */
	return 0;
}

(Note that all pages in new VMAs are softdirty until cleared).

Tested:
	Used the program given above. I'm going to include this code in
	a selftest in the future.

[n-horiguchi@ah.jp.nec.com: prevent pagemap_pte_range() from overrunning]
Signed-off-by: Peter Feiner <pfeiner@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Jamie Liu <jamieliu@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   59 ++++++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 20 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-softdirty-unmapped-addresses-between-vmas-are-clean fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-softdirty-unmapped-addresses-between-vmas-are-clean
+++ a/fs/proc/task_mmu.c
@@ -1027,7 +1027,6 @@ static int pagemap_pte_range(pmd_t *pmd,
 	spinlock_t *ptl;
 	pte_t *pte;
 	int err = 0;
-	pagemap_entry_t pme = make_pme(PM_NOT_PRESENT(pm->v2));
 
 	/* find the first VMA at or above 'addr' */
 	vma = find_vma(walk->mm, addr);
@@ -1041,6 +1040,7 @@ static int pagemap_pte_range(pmd_t *pmd,
 
 		for (; addr != end; addr += PAGE_SIZE) {
 			unsigned long offset;
+			pagemap_entry_t pme;
 
 			offset = (addr & ~PAGEMAP_WALK_MASK) >>
 					PAGE_SHIFT;
@@ -1055,32 +1055,51 @@ static int pagemap_pte_range(pmd_t *pmd,
 
 	if (pmd_trans_unstable(pmd))
 		return 0;
-	for (; addr != end; addr += PAGE_SIZE) {
-		int flags2;
 
-		/* check to see if we've left 'vma' behind
-		 * and need a new, higher one */
-		if (vma && (addr >= vma->vm_end)) {
-			vma = find_vma(walk->mm, addr);
-			if (vma && (vma->vm_flags & VM_SOFTDIRTY))
-				flags2 = __PM_SOFT_DIRTY;
-			else
-				flags2 = 0;
-			pme = make_pme(PM_NOT_PRESENT(pm->v2) | PM_STATUS2(pm->v2, flags2));
+	while (1) {
+		/* End of address space hole, which we mark as non-present. */
+		unsigned long hole_end;
+
+		if (vma)
+			hole_end = min(end, vma->vm_start);
+		else
+			hole_end = end;
+
+		for (; addr < hole_end; addr += PAGE_SIZE) {
+			pagemap_entry_t pme = make_pme(PM_NOT_PRESENT(pm->v2));
+
+			err = add_to_pagemap(addr, &pme, pm);
+			if (err)
+				return err;
 		}
 
-		/* check that 'vma' actually covers this address,
-		 * and that it isn't a huge page vma */
-		if (vma && (vma->vm_start <= addr) &&
-		    !is_vm_hugetlb_page(vma)) {
+		if (!vma || vma->vm_start >= end)
+			break;
+		/*
+		 * We can't possibly be in a hugetlb VMA. In general,
+		 * for a mm_walk with a pmd_entry and a hugetlb_entry,
+		 * the pmd_entry can only be called on addresses in a
+		 * hugetlb if the walk starts in a non-hugetlb VMA and
+		 * spans a hugepage VMA. Since pagemap_read walks are
+		 * PMD-sized and PMD-aligned, this will never be true.
+		 */
+		BUG_ON(is_vm_hugetlb_page(vma));
+
+		/* Addresses in the VMA. */
+		for (; addr < min(end, vma->vm_end); addr += PAGE_SIZE) {
+			pagemap_entry_t pme;
 			pte = pte_offset_map(pmd, addr);
 			pte_to_pagemap_entry(&pme, pm, vma, addr, *pte);
-			/* unmap before userspace copy */
 			pte_unmap(pte);
+			err = add_to_pagemap(addr, &pme, pm);
+			if (err)
+				return err;
 		}
-		err = add_to_pagemap(addr, &pme, pm);
-		if (err)
-			return err;
+
+		if (addr == end)
+			break;
+
+		vma = find_vma(walk->mm, addr);
 	}
 
 	cond_resched();
_

Patches currently in -mm which might be from pfeiner@google.com are

origin.patch
mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared.patch
mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared-fix.patch

