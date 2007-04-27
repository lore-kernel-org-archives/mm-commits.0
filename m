From: akpm@linux-foundation.org
Subject: - smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:12:40 -0700
Message-ID: <200704270812.l3R8Ce8p023003@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755488AbXD0IMt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:12:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, clameter@sgi.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     smaps: flush tlb only once for each vma
has been removed from the -mm tree.  Its filename was
     smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch

This patch was dropped because it was folded into smaps-add-clear_refs-file-to-clear-reference.patch

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

slab-x86_64-skip-cache_free_alien-on-non-numa.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
smaps-add-clear_refs-file-to-clear-reference-cleanup.patch
smaps-use-ptep_test_and_clear_young.patch
smaps-add-clear_refs-file-to-clear-reference-docs.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
cpusets-allow-tif_memdie-threads-to-allocate-anywhere.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
oom-fix-constraint-deadlock.patch
