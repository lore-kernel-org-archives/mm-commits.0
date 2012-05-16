From: akpm@linux-foundation.org
Subject: [merged] hugetlb-prevent-bug_on-in-hugetlb_fault-hugetlb_cow.patch removed from -mm tree
Date: Wed, 16 May 2012 11:46:51 -0700
Message-ID: <20120516184651.93455A028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:38970 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760287Ab2EPSqw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 May 2012 14:46:52 -0400
Received: by yenl3 with SMTP id l3so125568yen.1
        for <mm-commits@vger.kernel.org>; Wed, 16 May 2012 11:46:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmetcalf@tilera.com, dhillf@gmail.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: prevent BUG_ON in hugetlb_fault() -> hugetlb_cow()
has been removed from the -mm tree.  Its filename was
     hugetlb-prevent-bug_on-in-hugetlb_fault-hugetlb_cow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Chris Metcalf <cmetcalf@tilera.com>
Subject: hugetlb: prevent BUG_ON in hugetlb_fault() -> hugetlb_cow()

66aebce747eaf ("hugetlb: fix race condition in hugetlb_fault()") added
code to avoid a race condition by elevating the page refcount in
hugetlb_fault() while calling hugetlb_cow().

However, one code path in hugetlb_cow() includes an assertion that the
page count is 1, whereas it may now also have the value 2 in this path. 

The consensus is that this BUG_ON has served its purpose, so rather than
extending it to cover both cases, we just remove it.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Hillf Danton <dhillf@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>	[3.0.29+, 3.2.16+, 3.3.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-prevent-bug_on-in-hugetlb_fault-hugetlb_cow mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-prevent-bug_on-in-hugetlb_fault-hugetlb_cow
+++ a/mm/hugetlb.c
@@ -2498,7 +2498,6 @@ retry_avoidcopy:
 		if (outside_reserve) {
 			BUG_ON(huge_pte_none(pte));
 			if (unmap_ref_private(mm, vma, old_page, address)) {
-				BUG_ON(page_count(old_page) != 1);
 				BUG_ON(huge_pte_none(pte));
 				spin_lock(&mm->page_table_lock);
 				ptep = huge_pte_offset(mm, address & huge_page_mask(h));
_

Patches currently in -mm which might be from cmetcalf@tilera.com are

linux-next.patch
list_debug-warn-for-adding-something-already-in-the-list.patch

