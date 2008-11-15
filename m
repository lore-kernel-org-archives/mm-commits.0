From: akpm@linux-foundation.org
Subject: + mm-apply_to_range-call-pte-function-with-lazy-updates.patch added to -mm tree
Date: Fri, 14 Nov 2008 16:25:56 -0800
Message-ID: <200811150025.mAF0Pu1p018914@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751126AbYKOA0g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 19:26:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, hannes@cmpxchg.org, hugh@veritas.com, jeremy.fitzhardinge@citrix.com, nickpiggin@yahoo.com.au, venkatesh.pallipadi@intel.com


The patch titled
     mm/apply_to_range: call pte function with lazy updates
has been added to the -mm tree.  Its filename is
     mm-apply_to_range-call-pte-function-with-lazy-updates.patch

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
Subject: mm/apply_to_range: call pte function with lazy updates
From: Jeremy Fitzhardinge <jeremy@goop.org>

Make the pte-level function in apply_to_range be called in lazy mmu mode,
so that any pagetable modifications can be batched.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/memory.c~mm-apply_to_range-call-pte-function-with-lazy-updates mm/memory.c
--- a/mm/memory.c~mm-apply_to_range-call-pte-function-with-lazy-updates
+++ a/mm/memory.c
@@ -1564,6 +1564,8 @@ static int apply_to_pte_range(struct mm_
 
 	BUG_ON(pmd_huge(*pmd));
 
+	arch_enter_lazy_mmu_mode();
+
 	token = pmd_pgtable(*pmd);
 
 	do {
@@ -1572,6 +1574,8 @@ static int apply_to_pte_range(struct mm_
 			break;
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 
+	arch_leave_lazy_mmu_mode();
+
 	if (mm != &init_mm)
 		pte_unmap_unlock(pte-1, ptl);
 	return err;
_

Patches currently in -mm which might be from jeremy@goop.org are

linux-next.patch
mm-implement-remap_pfn_range-with-apply_to_page_range.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remap_pfn_range-restore-missing-flush.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch

