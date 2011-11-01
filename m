From: akpm@linux-foundation.org
Subject: [merged] mremap-check-for-overflow-using-deltas.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:10:11 -0700
Message-ID: <201111012110.pA1LABGS026278@hpaq14.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:28953 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569Ab1KAVKS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:10:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, jweiner@redhat.com, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mremap: check for overflow using deltas
has been removed from the -mm tree.  Its filename was
     mremap-check-for-overflow-using-deltas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mremap: check for overflow using deltas

Using "- 1" relies on the old_end to be page aligned and PAGE_SIZE > 1,
those are reasonable requirements but the check remains obscure and it
looks more like an off by one error than an overflow check.  This I feel
will improve readability.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Johannes Weiner <jweiner@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/mremap.c~mremap-check-for-overflow-using-deltas mm/mremap.c
--- a/mm/mremap.c~mremap-check-for-overflow-using-deltas
+++ a/mm/mremap.c
@@ -141,9 +141,10 @@ unsigned long move_page_tables(struct vm
 	for (; old_addr < old_end; old_addr += extent, new_addr += extent) {
 		cond_resched();
 		next = (old_addr + PMD_SIZE) & PMD_MASK;
-		if (next - 1 > old_end)
-			next = old_end;
+		/* even if next overflowed, extent below will be ok */
 		extent = next - old_addr;
+		if (extent > old_end - old_addr)
+			extent = old_end - old_addr;
 		old_pmd = get_old_pmd(vma->vm_mm, old_addr);
 		if (!old_pmd)
 			continue;
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-tail-page-refcounting-fix-5.patch
powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast.patch
powerpc-get_hugepte-dont-put_page-the-wrong-page.patch
powerpc-gup_hugepte-avoid-to-free-the-head-page-too-many-times.patch
powerpc-gup_hugepte-support-thp-based-tail-recounting.patch
powerpc-gup_huge_pmd-return-0-if-pte-changes.patch
s390-gup_huge_pmd-support-thp-tail-recounting.patch
s390-gup_huge_pmd-return-0-if-pte-changes.patch
sparc-gup_pte_range-support-thp-based-tail-recounting.patch
thp-share-get_huge_page_tail.patch

