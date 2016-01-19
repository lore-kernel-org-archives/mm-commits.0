From: akpm@linux-foundation.org
Subject: [merged] thp-increase-split_huge_page-success-rate.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 12:12:16 -0800
Message-ID: <569e98a0.6gZ3UyIeNTTdndJI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43807 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354AbcASUMR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:12:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: increase split_huge_page() success rate
has been removed from the -mm tree.  Its filename was
     thp-increase-split_huge_page-success-rate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: increase split_huge_page() success rate

During freeze_page(), we remove the page from rmap.  It munlocks the page
if it was mlocked.  clear_page_mlock() uses thelru cache, which temporary
pins the page.

Let's drain the lru cache before checking page's count vs.  mapcount.  The
change makes mlocked page split on first attempt, if it was not pinned by
somebody else.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/huge_memory.c~thp-increase-split_huge_page-success-rate mm/huge_memory.c
--- a/mm/huge_memory.c~thp-increase-split_huge_page-success-rate
+++ a/mm/huge_memory.c
@@ -3201,6 +3201,7 @@ int split_huge_page_to_list(struct page
 	struct page *head = compound_head(page);
 	struct anon_vma *anon_vma;
 	int count, mapcount, ret;
+	bool mlocked;
 
 	VM_BUG_ON_PAGE(is_huge_zero_page(page), page);
 	VM_BUG_ON_PAGE(!PageAnon(page), page);
@@ -3231,9 +3232,14 @@ int split_huge_page_to_list(struct page
 		goto out_unlock;
 	}
 
+	mlocked = PageMlocked(page);
 	freeze_page(anon_vma, head);
 	VM_BUG_ON_PAGE(compound_mapcount(head), head);
 
+	/* Make sure the page is not on per-CPU pagevec as it takes pin */
+	if (mlocked)
+		lru_add_drain();
+
 	/* Prevent deferred_split_scan() touching ->_count */
 	spin_lock(&split_queue_lock);
 	count = page_count(head);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

