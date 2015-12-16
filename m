From: akpm@linux-foundation.org
Subject: + dax-split-pmd-map-when-fallback-on-cow.patch added to -mm tree
Date: Tue, 15 Dec 2015 16:16:43 -0800
Message-ID: <5670ad6b.eQjj954XiJaLVRBr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47231 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbbLPAQo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2015 19:16:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hpe.com, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: Split pmd map when fallback on COW
has been added to the -mm tree.  Its filename is
     dax-split-pmd-map-when-fallback-on-cow.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-split-pmd-map-when-fallback-on-cow.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-split-pmd-map-when-fallback-on-cow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

dax-split-pmd-map-when-fallback-on-cow.patch

