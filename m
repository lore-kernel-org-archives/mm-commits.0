From: akpm@linux-foundation.org
Subject: [nacked] mm-disable-preemption-in-apply_to_pte_range.patch removed from -mm tree
Date: Wed, 10 Jun 2009 11:35:03 -0700
Message-ID: <200906101835.n5AIZ4mZ007471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211AbZFJSfI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 14:35:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, hugh.dickins@tiscali.co.uk, jeremy.fitzhardinge@citrix.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm: disable preemption in apply_to_pte_range
has been removed from the -mm tree.  Its filename was
     mm-disable-preemption-in-apply_to_pte_range.patch

This patch was dropped because it was nacked

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
@@ -1725,6 +1725,7 @@ static int apply_to_pte_range(struct mm_
 
 	BUG_ON(pmd_huge(*pmd));
 
+	preempt_disable();
 	arch_enter_lazy_mmu_mode();
 
 	token = pmd_pgtable(*pmd);
@@ -1736,6 +1737,7 @@ static int apply_to_pte_range(struct mm_
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 
 	arch_leave_lazy_mmu_mode();
+	preempt_enable();
 
 	if (mm != &init_mm)
 		pte_unmap_unlock(pte-1, ptl);
_

Patches currently in -mm which might be from jeremy@goop.org are

linux-next.patch
mm-disable-preemption-in-apply_to_pte_range.patch

