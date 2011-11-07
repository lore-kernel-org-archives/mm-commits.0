From: akpm@linux-foundation.org
Subject: [merged] powerpc-gup_hugepte-avoid-to-free-the-head-page-too-many-times.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:25:03 -0800
Message-ID: <201111072025.pA7KP4VP027303@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:46780 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab1KGUZX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:25:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, david@gibson.dropbear.id.au, hughd@google.com, jweiner@redhat.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.


The patch titled
     Subject: powerpc: gup_hugepte() avoid freeing the head page too many times
has been removed from the -mm tree.  Its filename was
     powerpc-gup_hugepte-avoid-to-free-the-head-page-too-many-times.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: powerpc: gup_hugepte() avoid freeing the head page too many times

We only taken "refs" pins on the head page not "*nr" pins.

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

 arch/powerpc/mm/hugetlbpage.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/mm/hugetlbpage.c~powerpc-gup_hugepte-avoid-to-free-the-head-page-too-many-times arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~powerpc-gup_hugepte-avoid-to-free-the-head-page-too-many-times
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -428,10 +428,9 @@ static noinline int gup_hugepte(pte_t *p
 
 	if (unlikely(pte_val(pte) != pte_val(*ptep))) {
 		/* Could be optimized better */
-		while (*nr) {
+		*nr -= refs;
+		while (refs--)
 			put_page(head);
-			(*nr)--;
-		}
 	}
 
 	return 1;
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch

