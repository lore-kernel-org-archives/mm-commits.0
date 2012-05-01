From: akpm@linux-foundation.org
Subject: + hugetlb-prevent-bug_on-in-hugetlb_fault-hugetlb_cow.patch added to -mm tree
Date: Tue, 01 May 2012 11:52:52 -0700
Message-ID: <20120501185252.A95E0A0270@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:62581 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab2EASwz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2012 14:52:55 -0400
Received: by bkty5 with SMTP id y5so35490bkt.1
        for <mm-commits@vger.kernel.org>; Tue, 01 May 2012 11:52:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cmetcalf@tilera.com, dhillf@gmail.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, stable@vger.kernel.org


The patch titled
     Subject: hugetlb: prevent BUG_ON in hugetlb_fault() -> hugetlb_cow()
has been added to the -mm tree.  Its filename is
     hugetlb-prevent-bug_on-in-hugetlb_fault-hugetlb_cow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2499,7 +2499,6 @@ retry_avoidcopy:
 		if (outside_reserve) {
 			BUG_ON(huge_pte_none(pte));
 			if (unmap_ref_private(mm, vma, old_page, address)) {
-				BUG_ON(page_count(old_page) != 1);
 				BUG_ON(huge_pte_none(pte));
 				spin_lock(&mm->page_table_lock);
 				ptep = huge_pte_offset(mm, address & huge_page_mask(h));
_
Subject: Subject: hugetlb: prevent BUG_ON in hugetlb_fault() -> hugetlb_cow()

Patches currently in -mm which might be from cmetcalf@tilera.com are

linux-next.patch
hugetlb-prevent-bug_on-in-hugetlb_fault-hugetlb_cow.patch
list_debug-warn-for-adding-something-already-in-the-list.patch

