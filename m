From: akpm@linux-foundation.org
Subject: [merged] powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:24:43 -0800
Message-ID: <201111072024.pA7KOhch021943@hpaq3.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:46770 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab1KGUZV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:25:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, david@gibson.dropbear.id.au, hughd@google.com, jweiner@redhat.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.


The patch titled
     Subject: powerpc: remove superfluous PageTail checks on the pte gup_fast
has been removed from the -mm tree.  Its filename was
     powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: powerpc: remove superfluous PageTail checks on the pte gup_fast

This part of gup_fast doesn't seem capable of handling hugetlbfs ptes,
those should be handled by gup_hugepd only, so these checks are
superfluous.

Plus if this wasn't a noop, it would have oopsed because, the insistence
of using the speculative refcounting would trigger a VM_BUG_ON if a tail
page was encountered in the page_cache_get_speculative().

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

 arch/powerpc/mm/gup.c |   13 -------------
 1 file changed, 13 deletions(-)

diff -puN arch/powerpc/mm/gup.c~powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast arch/powerpc/mm/gup.c
--- a/arch/powerpc/mm/gup.c~powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast
+++ a/arch/powerpc/mm/gup.c
@@ -16,17 +16,6 @@
 
 #ifdef __HAVE_ARCH_PTE_SPECIAL
 
-static inline void get_huge_page_tail(struct page *page)
-{
-	/*
-	 * __split_huge_page_refcount() cannot run
-	 * from under us.
-	 */
-	VM_BUG_ON(page_mapcount(page) < 0);
-	VM_BUG_ON(atomic_read(&page->_count) != 0);
-	atomic_inc(&page->_mapcount);
-}
