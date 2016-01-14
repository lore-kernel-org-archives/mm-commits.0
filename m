From: akpm@linux-foundation.org
Subject: [folded-merged]
 thp-increase-split_huge_page-success-rate-fix.patch removed from -mm tree
Date: Thu, 14 Jan 2016 14:44:22 -0800
Message-ID: <569824c6.TS8v4kWU6lX+CJRP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbcANWoX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:44:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-increase-split_huge_page-success-rate-fix
has been removed from the -mm tree.  Its filename was
     thp-increase-split_huge_page-success-rate-fix.patch

This patch was dropped because it was folded into thp-increase-split_huge_page-success-rate.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: thp-increase-split_huge_page-success-rate-fix



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-increase-split_huge_page-success-rate-fix mm/huge_memory.c
--- a/mm/huge_memory.c~thp-increase-split_huge_page-success-rate-fix
+++ a/mm/huge_memory.c
@@ -3260,6 +3260,7 @@ int split_huge_page_to_list(struct page
 	struct page *head = compound_head(page);
 	struct anon_vma *anon_vma;
 	int count, mapcount, ret;
+	bool mlocked;
 
 	VM_BUG_ON_PAGE(is_huge_zero_page(page), page);
 	VM_BUG_ON_PAGE(!PageAnon(page), page);
@@ -3290,11 +3291,13 @@ int split_huge_page_to_list(struct page
 		goto out_unlock;
 	}
 
+	mlocked = PageMlocked(page);
 	freeze_page(anon_vma, head);
 	VM_BUG_ON_PAGE(compound_mapcount(head), head);
 
 	/* Make sure the page is not on per-CPU pagevec as it takes pin */
-	lru_add_drain();
+	if (mlocked)
+		lru_add_drain();
 
 	/* Prevent deferred_split_scan() touching ->_count */
 	spin_lock(&split_queue_lock);
_

Patches currently in -mm which might be from kirill@shutemov.name are

thp-increase-split_huge_page-success-rate.patch
mm-add-page_check_address_transhuge-helper-fix-fix.patch

