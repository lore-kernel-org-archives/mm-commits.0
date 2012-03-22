From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-bail-out-unmapping-after-serving-reference-page.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:18:24 -0700
Message-ID: <20120322201824.79109A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:60535 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757795Ab2CVUSZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:18:25 -0400
Received: by mail-gy0-f202.google.com with SMTP id z15so402093ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:18:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: bail out unmapping after serving reference page
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-bail-out-unmapping-after-serving-reference-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: mm: hugetlb: bail out unmapping after serving reference page

When unmapping a given VM range, we could bail out if a reference page is
supplied and is unmapped, which is a minor optimization.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/hugetlb.c~mm-hugetlb-bail-out-unmapping-after-serving-reference-page mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-bail-out-unmapping-after-serving-reference-page
+++ a/mm/hugetlb.c
@@ -2280,6 +2280,10 @@ void __unmap_hugepage_range(struct vm_ar
 		if (pte_dirty(pte))
 			set_page_dirty(page);
 		list_add(&page->lru, &page_list);
+
+		/* Bail out after unmapping reference page if supplied */
+		if (ref_page)
+			break;
 	}
 	flush_tlb_range(vma, start, end);
 	spin_unlock(&mm->page_table_lock);
_

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch

