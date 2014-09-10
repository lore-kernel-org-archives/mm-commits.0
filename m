From: akpm@linux-foundation.org
Subject: + mm-softdirty-unmapped-addresses-between-vmas-are-clean.patch
 added to -mm tree
Date: Wed, 10 Sep 2014 16:36:38 -0700
Message-ID: <5410e086.NChFMyoWam281e3S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbaIJXgj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Sep 2014 19:36:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pfeiner@google.com, gorcunov@openvz.org, hughd@google.com, jamieliu@google.com, kirill@shutemov.name, n-horiguchi@ah.jp.nec.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: softdirty: unmapped addresses between VMAs are clean
has been added to the -mm tree.  Its filename is
     mm-softdirty-unmapped-addresses-between-vmas-are-clean.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-softdirty-unmapped-addresses-between-vmas-are-clean.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-softdirty-unmapped-addresses-between-vmas-are-clean.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Peter Feiner <pfeiner@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Jamie Liu <jamieliu@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   59 ++++++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 20 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-softdirty-unmapped-addresses-between-vmas-are-clean fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-softdirty-unmapped-addresses-between-vmas-are-clean
+++ a/fs/proc/task_mmu.c
@@ -1038,7 +1038,6 @@ static int pagemap_pte_range(pmd_t *pmd,
 	spinlock_t *ptl;
 	pte_t *pte;
 	int err = 0;
-	pagemap_entry_t pme = make_pme(PM_NOT_PRESENT(pm->v2));
 
 	/* find the first VMA at or above 'addr' */
 	vma = find_vma(walk->mm, addr);
@@ -1052,6 +1051,7 @@ static int pagemap_pte_range(pmd_t *pmd,
 
 		for (; addr != end; addr += PAGE_SIZE) {
 			unsigned long offset;
+			pagemap_entry_t pme;
 
 			offset = (addr & ~PAGEMAP_WALK_MASK) >>
 					PAGE_SHIFT;
@@ -1066,32 +1066,51 @@ static int pagemap_pte_range(pmd_t *pmd,
 
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
+		unsigned long vm_start = end;
+		unsigned long vm_end = end;
+		unsigned long vm_flags = 0;
+
+		if (vma) {
+			/*
+			 * We can't possibly be in a hugetlb VMA. In general,
+			 * for a mm_walk with a pmd_entry and a hugetlb_entry,
+			 * the pmd_entry can only be called on addresses in a
+			 * hugetlb if the walk starts in a non-hugetlb VMA and
+			 * spans a hugepage VMA. Since pagemap_read walks are
+			 * PMD-sized and PMD-aligned, this will never be true.
+			 */
+			BUG_ON(is_vm_hugetlb_page(vma));
+			vm_start = vma->vm_start;
+			vm_end = min(end, vma->vm_end);
+			vm_flags = vma->vm_flags;
 		}
 
-		/* check that 'vma' actually covers this address,
-		 * and that it isn't a huge page vma */
-		if (vma && (vma->vm_start <= addr) &&
-		    !is_vm_hugetlb_page(vma)) {
+		/* Addresses before the VMA. */
+		for (; addr < vm_start; addr += PAGE_SIZE) {
+			pagemap_entry_t pme = make_pme(PM_NOT_PRESENT(pm->v2));
+
+			err = add_to_pagemap(addr, &pme, pm);
+			if (err)
+				return err;
+		}
+
+		/* Addresses in the VMA. */
+		for (; addr < vm_end; addr += PAGE_SIZE) {
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

mm-softdirty-addresses-before-vmas-in-pte-holes-arent-softdirty.patch
mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared.patch
mm-softdirty-unmapped-addresses-between-vmas-are-clean.patch

