From: akpm@linux-foundation.org
Subject: [merged] mm-use-vm_unmapped_area-in-hugetlbfs-on-ia64-architecture.patch removed from -mm tree
Date: Wed, 27 Feb 2013 12:51:02 -0800
Message-ID: <20130227205102.B447431C26C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:37190 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758303Ab3B0UvD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 15:51:03 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so111603vch.0
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 12:51:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, riel@redhat.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use vm_unmapped_area() in hugetlbfs on ia64 architecture
has been removed from the -mm tree.  Its filename was
     mm-use-vm_unmapped_area-in-hugetlbfs-on-ia64-architecture.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: use vm_unmapped_area() in hugetlbfs on ia64 architecture

Update the ia64 hugetlb_get_unmapped_area function to make use of
vm_unmapped_area() instead of implementing a brute force search.

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/hugetlbpage.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff -puN arch/ia64/mm/hugetlbpage.c~mm-use-vm_unmapped_area-in-hugetlbfs-on-ia64-architecture arch/ia64/mm/hugetlbpage.c
--- a/arch/ia64/mm/hugetlbpage.c~mm-use-vm_unmapped_area-in-hugetlbfs-on-ia64-architecture
+++ a/arch/ia64/mm/hugetlbpage.c
@@ -148,7 +148,7 @@ void hugetlb_free_pgd_range(struct mmu_g
 unsigned long hugetlb_get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 		unsigned long pgoff, unsigned long flags)
 {
-	struct vm_area_struct *vmm;
+	struct vm_unmapped_area_info info;
 
 	if (len > RGN_MAP_LIMIT)
 		return -ENOMEM;
@@ -165,16 +165,14 @@ unsigned long hugetlb_get_unmapped_area(
 	/* This code assumes that RGN_HPAGE != 0. */
 	if ((REGION_NUMBER(addr) != RGN_HPAGE) || (addr & (HPAGE_SIZE - 1)))
 		addr = HPAGE_REGION_BASE;
-	else
-		addr = ALIGN(addr, HPAGE_SIZE);
-	for (vmm = find_vma(current->mm, addr); ; vmm = vmm->vm_next) {
-		/* At this point:  (!vmm || addr < vmm->vm_end). */
-		if (REGION_OFFSET(addr) + len > RGN_MAP_LIMIT)
-			return -ENOMEM;
-		if (!vmm || (addr + len) <= vmm->vm_start)
-			return addr;
-		addr = ALIGN(vmm->vm_end, HPAGE_SIZE);
-	}
+
+	info.flags = 0;
+	info.length = len;
+	info.low_limit = addr;
+	info.high_limit = HPAGE_REGION_BASE + RGN_MAP_LIMIT;
+	info.align_mask = PAGE_MASK & (HPAGE_SIZE - 1);
+	info.align_offset = 0;
+	return vm_unmapped_area(&info);
 }
 
 static int __init hugetlb_setup_sz(char *str)
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
linux-next.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
mm-use-vm_unmapped_area-on-parisc-architecture-fix.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch
mm-remove-free_area_cache-use-in-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-powerpc-architecture.patch
mm-remove-free_area_cache.patch
mm-use-vm_unmapped_area-on-frv-architecture.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch
mutex-subsystem-synchro-test-module.patch

