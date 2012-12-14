From: akpm@linux-foundation.org
Subject: [merged] hwpoison-hugetlbfs-fix-warning-on-freeing-hwpoisoned-hugepage.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:30:15 -0800
Message-ID: <20121214233016.3558620005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40753 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945931Ab2LNXaS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:30:18 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so208792eei.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:30:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi.kleen@intel.com, aneesh.kumar@linux.vnet.ibm.com, fengguang.wu@intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: fix warning on freeing hwpoisoned hugepage
has been removed from the -mm tree.  Its filename was
     hwpoison-hugetlbfs-fix-warning-on-freeing-hwpoisoned-hugepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/hugetlb.c: fix warning on freeing hwpoisoned hugepage

Fix the warning from __list_del_entry() which is triggered when a process
tries to do free_huge_page() for a hwpoisoned hugepage.

free_huge_page() can be called for hwpoisoned hugepage from
unpoison_memory().  This function gets refcount once and clears
PageHWPoison, and then puts refcount twice to return the hugepage back to
free pool.  The second put_page() finally reaches free_huge_page().

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hwpoison-hugetlbfs-fix-warning-on-freeing-hwpoisoned-hugepage mm/hugetlb.c
--- a/mm/hugetlb.c~hwpoison-hugetlbfs-fix-warning-on-freeing-hwpoisoned-hugepage
+++ a/mm/hugetlb.c
@@ -3172,7 +3172,13 @@ int dequeue_hwpoisoned_huge_page(struct 
 
 	spin_lock(&hugetlb_lock);
 	if (is_hugepage_on_freelist(hpage)) {
-		list_del(&hpage->lru);
+		/*
+		 * Hwpoisoned hugepage isn't linked to activelist or freelist,
+		 * but dangling hpage->lru can trigger list-debug warnings
+		 * (this happens when we call unpoison_memory() on it),
+		 * so let it point to itself with list_del_init().
+		 */
+		list_del_init(&hpage->lru);
 		set_page_refcounted(hpage);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-print-out-information-of-file-affected-by-memory-error.patch

