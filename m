From: akpm@linux-foundation.org
Subject: [merged] mm-huge_memory-fix-copying-user-highpage.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:12:19 -0700
Message-ID: <201111012112.pA1LCJaZ027362@hpaq14.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29405 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab1KAVMZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:12:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, aarcange@redhat.com, jweiner@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: fix copying user highpage
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-copying-user-highpage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: mm/huge_memory: fix copying user highpage

The THP copy-on-write handler falls back to regular-sized pages for a huge
page replacement upon allocation failure or if THP has been individually
disabled in the target VMA.  The loop responsible for copying page-sized
chunks accidentally uses multiples of PAGE_SHIFT instead of PAGE_SIZE as
the virtual address arg for copy_user_highpage().

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Acked-by: Johannes Weiner <jweiner@redhat.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-huge_memory-fix-copying-user-highpage mm/huge_memory.c
--- a/mm/huge_memory.c~mm-huge_memory-fix-copying-user-highpage
+++ a/mm/huge_memory.c
@@ -830,7 +830,7 @@ static int do_huge_pmd_wp_page_fallback(
 
 	for (i = 0; i < HPAGE_PMD_NR; i++) {
 		copy_user_highpage(pages[i], page + i,
-				   haddr + PAGE_SHIFT*i, vma);
+				   haddr + PAGE_SIZE * i, vma);
 		__SetPageUptodate(pages[i]);
 		cond_resched();
 	}
_

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
linux-next.patch

