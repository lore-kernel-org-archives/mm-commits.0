From: akpm@linux-foundation.org
Subject: - hugetlb-preserve-hugetlb-pte-dirty-state.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:21:20 -0800
Message-ID: <200702100521.l1A5LK6R004474@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36651 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbXBJFXl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:23:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenchen@google.com, agl@us.ibm.com, david@gibson.dropbear.id.au, hugh@veritas.com, nish.aravamudan@gmail.com, stable@kernel.org, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: preserve hugetlb pte dirty state
has been removed from the -mm tree.  Its filename was
     hugetlb-preserve-hugetlb-pte-dirty-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hugetlb: preserve hugetlb pte dirty state
From: "Ken Chen" <kenchen@google.com>

__unmap_hugepage_range() is buggy that it does not preserve dirty state of
huge_pte when unmapping hugepage range.  It causes data corruption in the
event of dop_caches being used by sys admin.  For example, an application
creates a hugetlb file, modify pages, then unmap it.  While leaving the
hugetlb file alive, comes along sys admin doing a "echo 3 >
/proc/sys/vm/drop_caches".

drop_pagecache_sb() will happily free all pages that aren't marked dirty if
there are no active mapping.  Later when application remaps the hugetlb
file back and all data are gone, triggering catastrophic flip over on
application.

Not only that, the internal resv_huge_pages count will also get all messed
up.  Fix it up by marking page dirty appropriately.

Signed-off-by: Ken Chen <kenchen@google.com>
Cc: "Nish Aravamudan" <nish.aravamudan@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: <stable@kernel.org>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    5 ++++-
 mm/hugetlb.c         |    2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/hugetlbfs/inode.c~hugetlb-preserve-hugetlb-pte-dirty-state fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlb-preserve-hugetlb-pte-dirty-state
+++ a/fs/hugetlbfs/inode.c
@@ -449,10 +449,13 @@ static int hugetlbfs_symlink(struct inod
 }
 
 /*
- * For direct-IO reads into hugetlb pages
+ * mark the head page dirty
  */
 static int hugetlbfs_set_page_dirty(struct page *page)
 {
+	struct page *head = (struct page *)page_private(page);
+
+	SetPageDirty(head);
 	return 0;
 }
 
diff -puN mm/hugetlb.c~hugetlb-preserve-hugetlb-pte-dirty-state mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-preserve-hugetlb-pte-dirty-state
+++ a/mm/hugetlb.c
@@ -389,6 +389,8 @@ void __unmap_hugepage_range(struct vm_ar
 			continue;
 
 		page = pte_page(pte);
+		if (pte_dirty(pte))
+			set_page_dirty(page);
 		list_add(&page->lru, &page_list);
 	}
 	spin_unlock(&mm->page_table_lock);
_

Patches currently in -mm which might be from kenchen@google.com are

origin.patch
simplify-shmem_aopsset_page_dirty-method.patch
convert-ramfs-to-use-__set_page_dirty_no_writeback.patch
do-not-disturb-page-referenced-state-when-unmapping-memory-range.patch
