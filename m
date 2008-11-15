From: akpm@linux-foundation.org
Subject: + mm-dont-mark_page_accessed-in-shmem_fault.patch added to -mm tree
Date: Fri, 14 Nov 2008 17:11:08 -0800
Message-ID: <200811150111.mAF1B88I008853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259AbYKOBLY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 20:11:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, hannes@saeurebad.de, npiggin@suse.de


The patch titled
     mm: don't mark_page_accessed in shmem_fault
has been added to the -mm tree.  Its filename is
     mm-dont-mark_page_accessed-in-shmem_fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: don't mark_page_accessed in shmem_fault
From: Hugh Dickins <hugh@veritas.com>

Following "mm: don't mark_page_accessed in fault path", which now
places a mark_page_accessed() in zap_pte_range(), we should remove
the mark_page_accessed() from shmem_fault().

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/shmem.c~mm-dont-mark_page_accessed-in-shmem_fault mm/shmem.c
--- a/mm/shmem.c~mm-dont-mark_page_accessed-in-shmem_fault
+++ a/mm/shmem.c
@@ -1444,7 +1444,6 @@ static int shmem_fault(struct vm_area_st
 	if (error)
 		return ((error == -ENOMEM) ? VM_FAULT_OOM : VM_FAULT_SIGBUS);
 
-	mark_page_accessed(vmf->page);
 	return ret | VM_FAULT_LOCKED;
 }
 
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
linux-next.patch
sprint_symbol-use-less-stack.patch
migration-fix-writepage-error.patch
vmscan-let-gfp_nofs-go-to-swap-again.patch
dont-unlink-an-active-swapfile.patch
mm-remove-unevictables-show_page_path.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-implement-remap_pfn_range-with-apply_to_page_range.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remap_pfn_range-restore-missing-flush.patch
memcg-handle-swap-caches.patch
memcg-memswap-controller-core.patch
prio_tree-debugging-patch.patch

