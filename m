From: akpm@linux-foundation.org
Subject: + mremap-check-for-overflow-using-deltas.patch added to -mm tree
Date: Tue, 23 Aug 2011 14:14:55 -0700
Message-ID: <201108232114.p7NLEu47007112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752730Ab1HWVPC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Aug 2011 17:15:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, hughd@google.com, jweiner@redhat.com, mgorman@suse.de, riel@redhat.com


The patch titled
     mremap: check for overflow using deltas
has been added to the -mm tree.  Its filename is
     mremap-check-for-overflow-using-deltas.patch

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
Subject: mremap: check for overflow using deltas
From: Andrea Arcangeli <aarcange@redhat.com>

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

mm-compaction-trivial-clean-up-in-acct_isolated.patch
mm-change-isolate-mode-from-define-to-bitwise-type.patch
mm-compaction-make-isolate_lru_page-filter-aware.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch
mm-migration-clean-up-unmap_and_move.patch
mremap-check-for-overflow-using-deltas.patch
mremap-avoid-sending-one-ipi-per-page.patch
thp-mremap-support-and-tlb-optimization.patch
thp-mremap-support-and-tlb-optimization-fix.patch

