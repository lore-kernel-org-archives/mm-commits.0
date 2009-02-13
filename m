From: akpm@linux-foundation.org
Subject: + mm-disable-preemption-in-apply_to_pte_range.patch added to -mm tree
Date: Thu, 12 Feb 2009 17:29:16 -0800
Message-ID: <200902130129.n1D1TGJB022772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752287AbZBMB3q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Feb 2009 20:29:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, hugh@veritas.com, jeremy.fitzhardinge@citrix.com, nickpiggin@yahoo.com.au


The patch titled
     mm: disable preemption in apply_to_pte_range
has been added to the -mm tree.  Its filename is
     mm-disable-preemption-in-apply_to_pte_range.patch

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
Subject: mm: disable preemption in apply_to_pte_range
From: Jeremy Fitzhardinge <jeremy@goop.org>

Lazy mmu mode needs preemption disabled, so if we're apply to init_mm
(which doesn't require any pte locks), then explicitly disable preemption.
 (Do it unconditionally after checking we've successfully done the
allocation to simplify the error handling.)

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/memory.c~mm-disable-preemption-in-apply_to_pte_range mm/memory.c
--- a/mm/memory.c~mm-disable-preemption-in-apply_to_pte_range
+++ a/mm/memory.c
@@ -1718,6 +1718,7 @@ static int apply_to_pte_range(struct mm_
 
 	BUG_ON(pmd_huge(*pmd));
 
+	preempt_disable();
 	arch_enter_lazy_mmu_mode();
 
 	token = pmd_pgtable(*pmd);
@@ -1729,6 +1730,7 @@ static int apply_to_pte_range(struct mm_
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 
 	arch_leave_lazy_mmu_mode();
+	preempt_enable();
 
 	if (mm != &init_mm)
 		pte_unmap_unlock(pte-1, ptl);
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
linux-next.patch
mm-disable-preemption-in-apply_to_pte_range.patch

