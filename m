From: akpm@linux-foundation.org
Subject: [merged]
 mm-huge_memoryc-use-head-to-emphasize-the-purpose-of-page.patch removed
 from -mm tree
Date: Fri, 31 Jan 2020 15:18:56 -0800
Message-ID: <20200131231856.sE3iYSqwc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726561AbgAaXS5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:18:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com


The patch titled
     Subject: mm/huge_memory.c: use head to emphasize the purpose of page
has been removed from the -mm tree.  Its filename was
     mm-huge_memoryc-use-head-to-emphasize-the-purpose-of-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: mm/huge_memory.c: use head to emphasize the purpose of page

During split huge page, it checks the property of the page.  Currently we
do the check on page and head without emphasizing the check is on the
compound page.  In case the page passed to split_huge_page_to_list is a
tail page, audience would take some time to think about whether the check
is on compound page or tail page itself.

To make it explicit, use head instead of page for those checks.  After
this, audience would be more clear about the checks are on compound page
and the page is used to do the split and dump error message if failed.

Link: http://lkml.kernel.org/r/20200110032610.26499-2-richardw.yang@linux.intel.com
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memoryc-use-head-to-emphasize-the-purpose-of-page
+++ a/mm/huge_memory.c
@@ -2704,7 +2704,7 @@ int split_huge_page_to_list(struct page
 {
 	struct page *head = compound_head(page);
 	struct pglist_data *pgdata = NODE_DATA(page_to_nid(head));
-	struct deferred_split *ds_queue = get_deferred_split_queue(page);
+	struct deferred_split *ds_queue = get_deferred_split_queue(head);
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
 	int count, mapcount, extra_pins, ret;
@@ -2713,10 +2713,10 @@ int split_huge_page_to_list(struct page
 	pgoff_t end;
 
 	VM_BUG_ON_PAGE(is_huge_zero_page(head), head);
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(!PageCompound(page), page);
+	VM_BUG_ON_PAGE(!PageLocked(head), head);
+	VM_BUG_ON_PAGE(!PageCompound(head), head);
 
-	if (PageWriteback(page))
+	if (PageWriteback(head))
 		return -EBUSY;
 
 	if (PageAnon(head)) {
@@ -2767,7 +2767,7 @@ int split_huge_page_to_list(struct page
 		goto out_unlock;
 	}
 
-	mlocked = PageMlocked(page);
+	mlocked = PageMlocked(head);
 	unmap_page(head);
 	VM_BUG_ON_PAGE(compound_mapcount(head), head);
 
@@ -2800,10 +2800,10 @@ int split_huge_page_to_list(struct page
 			list_del(page_deferred_list(head));
 		}
 		if (mapping) {
-			if (PageSwapBacked(page))
-				__dec_node_page_state(page, NR_SHMEM_THPS);
+			if (PageSwapBacked(head))
+				__dec_node_page_state(head, NR_SHMEM_THPS);
 			else
-				__dec_node_page_state(page, NR_FILE_THPS);
+				__dec_node_page_state(head, NR_FILE_THPS);
 		}
 
 		spin_unlock(&ds_queue->split_queue_lock);
_

Patches currently in -mm which might be from richardw.yang@linux.intel.com are
