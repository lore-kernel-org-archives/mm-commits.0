From: akpm@linux-foundation.org
Subject: [merged] sparc-gup_pte_range-support-thp-based-tail-recounting.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:25:31 -0800
Message-ID: <201111072025.pA7KPVio011844@hpaq14.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5060 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab1KGUZy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:25:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, davem@davemloft.net, david@gibson.dropbear.id.au, heiko.carstens@de.ibm.com, hughd@google.com, jweiner@redhat.co


The patch titled
     Subject: sparc: gup_pte_range() support THP based tail recounting
has been removed from the -mm tree.  Its filename was
     sparc-gup_pte_range-support-thp-based-tail-recounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: sparc: gup_pte_range() support THP based tail recounting

Up to this point the code assumed old refcounting for hugepages (pre-thp).
 This updates the code directly to the thp mapcount tail page refcounting.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/gup.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN arch/sparc/mm/gup.c~sparc-gup_pte_range-support-thp-based-tail-recounting arch/sparc/mm/gup.c
--- a/arch/sparc/mm/gup.c~sparc-gup_pte_range-support-thp-based-tail-recounting
+++ a/arch/sparc/mm/gup.c
@@ -12,6 +12,17 @@
 #include <linux/rwsem.h>
 #include <asm/pgtable.h>
 
+static inline void get_huge_page_tail(struct page *page)
+{
+	/*
+	 * __split_huge_page_refcount() cannot run
+	 * from under us.
+	 */
+	VM_BUG_ON(page_mapcount(page) < 0);
+	VM_BUG_ON(atomic_read(&page->_count) != 0);
+	atomic_inc(&page->_mapcount);
+}
+
 /*
  * The performance critical leaf functions are made noinline otherwise gcc
  * inlines everything into a single function which results in too much
@@ -56,6 +67,8 @@ static noinline int gup_pte_range(pmd_t 
 			put_page(head);
 			return 0;
 		}
+		if (head != page)
+			get_huge_page_tail(page);
 
 		pages[*nr] = page;
 		(*nr)++;
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch

