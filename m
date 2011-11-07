From: akpm@linux-foundation.org
Subject: [merged] powerpc-get_hugepte-dont-put_page-the-wrong-page.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:24:56 -0800
Message-ID: <201111072024.pA7KOurn010965@hpaq12.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:4906 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab1KGUZ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:25:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, david@gibson.dropbear.id.au, hughd@google.com, jweiner@redhat.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.


The patch titled
     Subject: powerpc: get_hugepte() don't put_page() the wrong page
has been removed from the -mm tree.  Its filename was
     powerpc-get_hugepte-dont-put_page-the-wrong-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: powerpc: get_hugepte() don't put_page() the wrong page

"page" may have changed to point to the next hugepage after the loop
completed, The references have been taken on the head page, so the
put_page must happen there too.

This is a longstanding issue pre-thp inclusion.

It's totally unclear how these page_cache_add_speculative and pte_val(pte)
!= pte_val(*ptep) checks are necessary across all the powerpc gup_fast
code, when x86 doesn't need any of that: there's no way the page can be
freed with irq disabled so we're guaranteed the atomic_inc will happen on
a page with page_count > 0 (so not needing the speculative check).  The
pte check is also meaningless on x86: no need to rollback on x86 if the
pte changed, because the pte can still change a CPU tick after the check
succeeded and it won't be rolled back in that case.  The important thing
is we got a reference on a valid page that was mapped there a CPU tick
ago.  So not knowing the soft tlb refill code of ppc64 in great detail I'm
not removing the "speculative" page_count increase and the pte checks
across all the code, but unless there's a strong reason for it they should
be later cleaned up too.

If a pte can change from huge to non-huge (like it could happen with THP)
passing a pte_t *ptep to gup_hugepte() would also require to repeat the
is_hugepd in gup_hugepte(), but that shouldn't happen with hugetlbfs only
so I'm not altering that.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/hugetlbpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/mm/hugetlbpage.c~powerpc-get_hugepte-dont-put_page-the-wrong-page arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~powerpc-get_hugepte-dont-put_page-the-wrong-page
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -429,7 +429,7 @@ static noinline int gup_hugepte(pte_t *p
 	if (unlikely(pte_val(pte) != pte_val(*ptep))) {
 		/* Could be optimized better */
 		while (*nr) {
-			put_page(page);
+			put_page(head);
 			(*nr)--;
 		}
 	}
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch

