From: akpm@linux-foundation.org
Subject: - hugetlb-ensure-we-do-not-reference-a-surplus-page-after-handing-it-to-buddy.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:44:24 -0800
Message-ID: <200802250044.m1P0iOd5006107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753275AbYBYApG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:45:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, agl@us.ibm.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     hugetlb: ensure we do not reference a surplus page after handing it to buddy
has been removed from the -mm tree.  Its filename was
     hugetlb-ensure-we-do-not-reference-a-surplus-page-after-handing-it-to-buddy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: ensure we do not reference a surplus page after handing it to buddy
From: Andy Whitcroft <apw@shadowen.org>

When we free a page via free_huge_page and we detect that we are in surplus
the page will be returned to the buddy.  After this we no longer own the page.
 However at the end free_huge_page we clear out our mapping pointer from page
private.  Even where the page is not a surplus we free the page to the
hugepage pool, drop the pool locks and then clear page private.  In either
case the page may have been reallocated.  BAD.

Make sure we clear out page private before we free the page.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Adam Litke <agl@us.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-ensure-we-do-not-reference-a-surplus-page-after-handing-it-to-buddy mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-ensure-we-do-not-reference-a-surplus-page-after-handing-it-to-buddy
+++ a/mm/hugetlb.c
@@ -120,6 +120,7 @@ static void free_huge_page(struct page *
 	struct address_space *mapping;
 
 	mapping = (struct address_space *) page_private(page);
+	set_page_private(page, 0);
 	BUG_ON(page_count(page));
 	INIT_LIST_HEAD(&page->lru);
 
@@ -134,7 +135,6 @@ static void free_huge_page(struct page *
 	spin_unlock(&hugetlb_lock);
 	if (mapping)
 		hugetlb_put_quota(mapping, 1);
-	set_page_private(page, 0);
 }
 
 /*
_

Patches currently in -mm which might be from apw@shadowen.org are

kthread-add-a-missing-memory-barrier-to-kthread_stop.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
update-checkpatchpl-to-version-015.patch
init-move-setup-of-nr_cpu_ids-to-as-early-as-possible-v3.patch
generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3.patch
x86_64-fold-pda-into-per-cpu-area-v3.patch
x86_64-cleanup-non-smp-usage-of-cpu-maps-v3.patch
page-owner-tracking-leak-detector.patch
