From: akpm@linux-foundation.org
Subject: + thp-mremap-support-and-tlb-optimization-fix-fix-fix.patch added to -mm tree
Date: Tue, 23 Aug 2011 15:33:52 -0700
Message-ID: <201108232233.p7NMXqfl011214@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108Ab1HWWe0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Aug 2011 18:34:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com


The patch titled
     thp-mremap-support-and-tlb-optimization-fix-fix-fix
has been added to the -mm tree.  Its filename is
     thp-mremap-support-and-tlb-optimization-fix-fix-fix.patch

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
Subject: thp-mremap-support-and-tlb-optimization-fix-fix-fix
From: Andrea Arcangeli <aarcange@redhat.com>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-mremap-support-and-tlb-optimization-fix-fix-fix mm/huge_memory.c
--- a/mm/huge_memory.c~thp-mremap-support-and-tlb-optimization-fix-fix-fix
+++ a/mm/huge_memory.c
@@ -1064,7 +1064,7 @@ int move_huge_pmd(struct vm_area_struct 
 
 	if ((old_addr & ~HPAGE_PMD_MASK) ||
 	    (new_addr & ~HPAGE_PMD_MASK) ||
-	    (old_addr + HPAGE_PMD_SIZE) > old_end ||
+	    old_end - old_addr < HPAGE_PMD_SIZE ||
 	    (new_vma->vm_flags & VM_NOHUGEPAGE))
 		goto out;
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-compaction-trivial-clean-up-in-acct_isolated.patch
mm-change-isolate-mode-from-define-to-bitwise-type.patch
mm-compaction-make-isolate_lru_page-filter-aware.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch
mm-migration-clean-up-unmap_and_move.patch
mremap-check-for-overflow-using-deltas.patch
mremap-avoid-sending-one-ipi-per-page.patch
thp-mremap-support-and-tlb-optimization.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix-fix.patch

