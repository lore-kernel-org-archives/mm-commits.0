From: akpm@linux-foundation.org
Subject: [merged] dax-split-pmd-map-when-fallback-on-cow.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 12:13:16 -0800
Message-ID: <569e98dc.7ODtknQtomAkwcoo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930AbcASUNR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:13:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hpe.com, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: Split pmd map when fallback on COW
has been removed from the -mm tree.  Its filename was
     dax-split-pmd-map-when-fallback-on-cow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Toshi Kani <toshi.kani@hpe.com>
Subject: dax: Split pmd map when fallback on COW

An infinite loop of PMD faults was observed when attempted to mlock() a
private read-only PMD mmap'd range of a DAX file.

__dax_pmd_fault() simply returns with VM_FAULT_FALLBACK when falling back
to PTE on COW.  However, __handle_mm_fault() returns without falling back
to handle_pte_fault() because a PMD map is present in this case.

Change __dax_pmd_fault() to split the PMD map, if present, before
returning with VM_FAULT_FALLBACK.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/dax.c~dax-split-pmd-map-when-fallback-on-cow fs/dax.c
--- a/fs/dax.c~dax-split-pmd-map-when-fallback-on-cow
+++ a/fs/dax.c
@@ -578,8 +578,10 @@ int __dax_pmd_fault(struct vm_area_struc
 		return VM_FAULT_FALLBACK;
 
 	/* Fall back to PTEs if we're going to COW */
-	if (write && !(vma->vm_flags & VM_SHARED))
+	if (write && !(vma->vm_flags & VM_SHARED)) {
+		split_huge_pmd(vma, pmd, address);
 		return VM_FAULT_FALLBACK;
+	}
 	/* If the PMD would extend outside the VMA */
 	if (pmd_addr < vma->vm_start)
 		return VM_FAULT_FALLBACK;
_

Patches currently in -mm which might be from toshi.kani@hpe.com are


