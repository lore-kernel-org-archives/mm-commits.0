From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlbc-avoid-double-unlock_page-in-hugetlb_fault.patch removed from -mm tree
Date: Tue, 07 Dec 2010 11:46:29 -0800
Message-ID: <201012071948.oB7Jm4mj004580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144Ab0LGTsR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2010 14:48:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dnelson@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm/hugetlb.c: avoid double unlock_page() in hugetlb_fault()
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-avoid-double-unlock_page-in-hugetlb_fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/hugetlb.c: avoid double unlock_page() in hugetlb_fault()
From: Dean Nelson <dnelson@redhat.com>

Have hugetlb_fault() call unlock_page(page) only if it had previously
called lock_page(page).

Setting CONFIG_DEBUG_VM=y and then running the libhugetlbfs test suite,
resulted in the tripping of VM_BUG_ON(!PageLocked(page)) in unlock_page()
having been called by hugetlb_fault() when page == pagecache_page.  This
patch remedied the problem.

Signed-off-by: Dean Nelson <dnelson@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlbc-avoid-double-unlock_page-in-hugetlb_fault mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbc-avoid-double-unlock_page-in-hugetlb_fault
+++ a/mm/hugetlb.c
@@ -2738,7 +2738,8 @@ out_page_table_lock:
 		unlock_page(pagecache_page);
 		put_page(pagecache_page);
 	}
-	unlock_page(page);
+	if (page != pagecache_page)
+		unlock_page(page);
 
 out_mutex:
 	mutex_unlock(&hugetlb_instantiation_mutex);
_

Patches currently in -mm which might be from dnelson@redhat.com are


