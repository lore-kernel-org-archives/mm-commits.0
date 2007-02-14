From: akpm@linux-foundation.org
Subject: + smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch added to -mm tree
Date: Wed, 14 Feb 2007 15:10:07 -0800
Message-ID: <200702142310.l1ENAGTZ012317@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50417 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964812AbXBNXK0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 18:10:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, clameter@sgi.com, lethal@linux-sh.org


The patch titled
     smaps: flush tlb only once for each vma
has been added to the -mm tree.  Its filename is
     smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: smaps: flush tlb only once for each vma
From: David Rientjes <rientjes@google.com>

Flush the entire user address space from the TLB for each VMA in the
task_struct list when clearing reference bits with /proc/pid/clear_refs. 
It's more efficient than flushing each page individually depending on
pte_young().

Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~smaps-add-clear_refs-file-to-clear-reference-fix-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~smaps-add-clear_refs-file-to-clear-reference-fix-fix
+++ a/fs/proc/task_mmu.c
@@ -276,7 +276,6 @@ static void clear_refs_one_pmd(struct vm
 		if (pte_young(ptent)) {
 			ptent = pte_mkold(ptent);
 			set_pte_at(vma->vm_mm, addr, pte, ptent);
-			flush_tlb_page(vma, addr);
 		}
 		ClearPageReferenced(page);
 	}
@@ -358,6 +357,7 @@ void clear_refs_smap(struct mm_struct *m
 	for (vma = mm->mmap; vma; vma = vma->vm_next)
 		if (vma->vm_mm && !is_vm_hugetlb_page(vma))
 			for_each_pmd(vma, clear_refs_one_pmd, NULL);
+	flush_tlb_mm(mm);
 	up_read(&mm->mmap_sem);
 }
 
_

Patches currently in -mm which might be from rientjes@google.com are

smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
smaps-add-clear_refs-file-to-clear-reference-docs.patch
