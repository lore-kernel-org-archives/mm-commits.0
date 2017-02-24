From: akpm@linux-foundation.org
Subject: [patch 068/124] mm/memory.c: use NULL instead of literal 0
Date: Fri, 24 Feb 2017 14:58:59 -0800
Message-ID: <58b0bab3.SsY06InCe4DN0Uqo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38602 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751611AbdBXW7F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:59:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, me@tobin.cc, kirill.shutemov@linux.intel.com

From: Tobin C Harding <me@tobin.cc>
Subject: mm/memory.c: use NULL instead of literal 0

Patch fixes sparse warning: Using plain integer as NULL pointer. Replaces
assignment of 0 to pointer with NULL assignment.

Link: http://lkml.kernel.org/r/1485992240-10986-2-git-send-email-me@tobin.cc
Signed-off-by: Tobin C Harding <me@tobin.cc>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memory.c~mm-fix-sparse-use-plain-integer-as-null-pointer mm/memory.c
--- a/mm/memory.c~mm-fix-sparse-use-plain-integer-as-null-pointer
+++ a/mm/memory.c
@@ -2920,7 +2920,7 @@ static int pte_alloc_one_map(struct vm_f
 		atomic_long_inc(&vma->vm_mm->nr_ptes);
 		pmd_populate(vma->vm_mm, vmf->pmd, vmf->prealloc_pte);
 		spin_unlock(vmf->ptl);
-		vmf->prealloc_pte = 0;
+		vmf->prealloc_pte = NULL;
 	} else if (unlikely(pte_alloc(vma->vm_mm, vmf->pmd, vmf->address))) {
 		return VM_FAULT_OOM;
 	}
@@ -2968,7 +2968,7 @@ static void deposit_prealloc_pte(struct
 	 * count that as nr_ptes.
 	 */
 	atomic_long_inc(&vma->vm_mm->nr_ptes);
-	vmf->prealloc_pte = 0;
+	vmf->prealloc_pte = NULL;
 }
 
 static int do_set_pmd(struct vm_fault *vmf, struct page *page)
@@ -3374,7 +3374,7 @@ static int do_fault(struct vm_fault *vmf
 	/* preallocated pagetable is unused: free it */
 	if (vmf->prealloc_pte) {
 		pte_free(vma->vm_mm, vmf->prealloc_pte);
-		vmf->prealloc_pte = 0;
+		vmf->prealloc_pte = NULL;
 	}
 	return ret;
 }
_
