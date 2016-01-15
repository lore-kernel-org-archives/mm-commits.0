From: akpm@linux-foundation.org
Subject: [merged] mm-thp-use-list_first_entry_or_null.patch removed from
 -mm tree
Date: Fri, 15 Jan 2016 14:33:22 -0800
Message-ID: <569973b2.KBSSbYNBVC8vaURb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59363 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbcAOWdW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:33:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: use list_first_entry_or_null()
has been removed from the -mm tree.  Its filename was
     mm-thp-use-list_first_entry_or_null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: mm, thp: use list_first_entry_or_null()

Simplify the code with list_first_entry_or_null().

Signed-off-by: Geliang Tang <geliangtang@163.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pgtable-generic.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN mm/pgtable-generic.c~mm-thp-use-list_first_entry_or_null mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~mm-thp-use-list_first_entry_or_null
+++ a/mm/pgtable-generic.c
@@ -176,13 +176,10 @@ pgtable_t pgtable_trans_huge_withdraw(st
 
 	/* FIFO */
 	pgtable = pmd_huge_pte(mm, pmdp);
-	if (list_empty(&pgtable->lru))
-		pmd_huge_pte(mm, pmdp) = NULL;
-	else {
-		pmd_huge_pte(mm, pmdp) = list_entry(pgtable->lru.next,
-					      struct page, lru);
+	pmd_huge_pte(mm, pmdp) = list_first_entry_or_null(&pgtable->lru,
+							  struct page, lru);
+	if (pmd_huge_pte(mm, pmdp))
 		list_del(&pgtable->lru);
-	}
 	return pgtable;
 }
 #endif
_

Patches currently in -mm which might be from geliangtang@163.com are

mm-swapfilec-use-list_for_each_entry_safe-in-free_swap_count_continuations.patch
mm-move-lru_to_page-to-mm_inlineh.patch
mm-zbud-use-list_last_entry-instead-of-list_tail_entry.patch
hfs-use-list_for_each_entry-in-hfs_cat_delete.patch
kexec-use-list_for_each_entry_safe-in-kimage_free_page_list.patch
rapidio-use-kobj_to_dev.patch
dma-mapping-use-offset_in_page-macro.patch

