From: akpm@linux-foundation.org
Subject: [merged] mm-revert-mremap-pud_free-anti-fix.patch removed from
 -mm tree
Date: Thu, 17 Oct 2013 11:13:33 -0700
Message-ID: <526028cd.IHj6pOJ7aWLHK/97%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759631Ab3JQSNd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:13:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gang.chen@asianux.com, hughd@google.com

Subject: [merged] mm-revert-mremap-pud_free-anti-fix.patch removed from -mm tree
To: hughd@google.com,gang.chen@asianux.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:13:33 -0700


The patch titled
     Subject: mm: revert mremap pud_free anti-fix
has been removed from the -mm tree.  Its filename was
     mm-revert-mremap-pud_free-anti-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: revert mremap pud_free anti-fix

Revert 1ecfd533f4c5 ("mm/mremap.c: call pud_free() after fail calling
pmd_alloc()").  The original code was correct: pud_alloc(), pmd_alloc(),
pte_alloc_map() ensure that the pud, pmd, pt is already allocated, and
seldom do they need to allocate; on failure, upper levels are freed if
appropriate by the subsequent do_munmap().  Whereas 1ecfd533f4c5 did an
unconditional pud_free() of a most-likely still-in-use pud: saved only by
the near-impossiblity of pmd_alloc() failing.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/mremap.c~mm-revert-mremap-pud_free-anti-fix mm/mremap.c
--- a/mm/mremap.c~mm-revert-mremap-pud_free-anti-fix
+++ a/mm/mremap.c
@@ -25,7 +25,6 @@
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
-#include <asm/pgalloc.h>
 
 #include "internal.h"
 
@@ -63,10 +62,8 @@ static pmd_t *alloc_new_pmd(struct mm_st
 		return NULL;
 
 	pmd = pmd_alloc(mm, pud, addr);
-	if (!pmd) {
-		pud_free(mm, pud);
+	if (!pmd)
 		return NULL;
-	}
 
 	VM_BUG_ON(pmd_trans_huge(*pmd));
 
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch
swap-fix-setting-page_size-blocksize-during-swapoff-swapon-race.patch
mm-rearrange-madvise-code-to-allow-for-reuse.patch
mm-add-a-field-to-store-names-for-private-anonymous-memory.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

