From: akpm@linux-foundation.org
Subject: + smaps-use-ptep_test_and_clear_young.patch added to -mm tree
Date: Sun, 25 Mar 2007 17:07:48 -0800
Message-ID: <200703260107.l2Q17mkV008776@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38657 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933450AbXCZBH6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 21:07:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, hugh@veritas.com


The patch titled
     smaps: use ptep_test_and_clear_young
has been added to the -mm tree.  Its filename is
     smaps-use-ptep_test_and_clear_young.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

x86_64-configurable-fake-numa-node-sizes.patch
x86_64-configurable-fake-numa-node-sizes-fix.patch
x86_64-split-remaining-fake-nodes-equally.patch
x86_64-fixed-size-remaining-fake-nodes.patch
x86_64-map-fake-nodes-to-real-nodes.patch
x86_64-disable-alien-cache-for-fake-numa.patch
x86_64-export-physnode-mapping-to-userspace.patch
x86_64-fake-numa-for-cpusets-document.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
smaps-add-clear_refs-file-to-clear-reference-cleanup.patch
smaps-use-ptep_test_and_clear_young.patch
smaps-add-clear_refs-file-to-clear-reference-docs.patch
