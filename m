From: akpm@linux-foundation.org
Subject: - smaps-use-ptep_test_and_clear_young.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:12:49 -0700
Message-ID: <200704270812.l3R8Cotb023012@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755501AbXD0INE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:13:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     smaps: use ptep_test_and_clear_young
has been removed from the -mm tree.  Its filename was
     smaps-use-ptep_test_and_clear_young.patch

This patch was dropped because it was folded into smaps-add-clear_refs-file-to-clear-reference.patch

------------------------------------------------------
Subject: smaps: use ptep_test_and_clear_young
From: David Rientjes <rientjes@google.com>

Use arch-specified ptep_test_and_clear_young() to clear the pte accessed
bits for /proc/pid/clear_refs.  This avoids a race condition if a pte is
modified between pte_mkold() and set_pte_at().

Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/proc/task_mmu.c~smaps-use-ptep_test_and_clear_young fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~smaps-use-ptep_test_and_clear_young
+++ a/fs/proc/task_mmu.c
@@ -273,10 +273,7 @@ static void clear_refs_pte_range(struct 
 			continue;
 
 		/* Clear accessed and referenced bits. */
-		if (pte_young(ptent)) {
-			ptent = pte_mkold(ptent);
-			set_pte_at(vma->vm_mm, addr, pte, ptent);
-		}
+		ptep_test_and_clear_young(vma, addr, pte);
 		ClearPageReferenced(page);
 	}
 	pte_unmap_unlock(pte - 1, ptl);
_

Patches currently in -mm which might be from rientjes@google.com are

slab-x86_64-skip-cache_free_alien-on-non-numa.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
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
