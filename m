From: akpm@linux-foundation.org
Subject: [merged] mbind-add-bug_onvma-in-new_vma_page.patch removed from
 -mm tree
Date: Thu, 12 Sep 2013 12:44:31 -0700
Message-ID: <5232199f.BUWwLWqZ6rZHnTvU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3ILTob (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:44:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dan.carpenter@oracle.com, n-horiguchi@ah.jp.nec.com

Subject: [merged] mbind-add-bug_onvma-in-new_vma_page.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,dan.carpenter@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:44:31 -0700


The patch titled
     Subject: mbind: add BUG_ON(!vma) in new_vma_page()
has been removed from the -mm tree.  Its filename was
     mbind-add-bug_onvma-in-new_vma_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mbind: add BUG_ON(!vma) in new_vma_page()

new_vma_page() is called only by page migration called from do_mbind(),
where pages to be migrated are queued into a pagelist by
queue_pages_range().  queue_pages_range() confirms that a queued page
belongs to some vma, so !vma case is not supposed to be happen.  This
patch adds BUG_ON() to catch this unexpected case.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/mempolicy.c~mbind-add-bug_onvma-in-new_vma_page mm/mempolicy.c
--- a/mm/mempolicy.c~mbind-add-bug_onvma-in-new_vma_page
+++ a/mm/mempolicy.c
@@ -1196,12 +1196,14 @@ static struct page *new_vma_page(struct
 			break;
 		vma = vma->vm_next;
 	}
+	/*
+	 * queue_pages_range() confirms that @page belongs to some vma,
+	 * so vma shouldn't be NULL.
+	 */
+	BUG_ON(!vma);
 
 	if (PageHuge(page))
 		return alloc_huge_page_noerr(vma, address, 1);
-	/*
-	 * if !vma, alloc_page_vma() will use task or system default policy
-	 */
 	return alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
 }
 #else
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch

