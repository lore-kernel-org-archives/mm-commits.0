Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A9CC001B2
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbiLLCQE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiLLCOe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:14:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED29CDEF9
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE116B80B3C
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520EBC433F1;
        Mon, 12 Dec 2022 02:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811257;
        bh=7w9vdXj5oJ9CpVZNmnxDAlDhoR2pnFb6tc/9/4urC0k=;
        h=Date:To:From:Subject:From;
        b=jg9Prh2tHuY+j/LPMZu3P4q22fEKDYcbe58Tbhwled3s/oVP0t8W0dzEjV6OpZPiI
         yQGmltwSiC8xbSiNGNlZ4MWjnEZo/aecz4aXaH1ZW0DmNnfGyspog+vZndvG0FlODH
         iUvI5EJOVFYh0k5QBjUxqLb8cePMbPh+RUZJxy+s=
Date:   Sun, 11 Dec 2022 18:14:16 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsahu@linux.ibm.com, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linux@rasmusvillemoes.dk,
        linmiaohe@huawei.com, jhubbard@nvidia.com,
        harperchen1110@gmail.com, david@redhat.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-convert-dissolve_free_huge_page-to-folios.patch removed from -mm tree
Message-Id: <20221212021417.520EBC433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: convert dissolve_free_huge_page() to folios
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-dissolve_free_huge_page-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert dissolve_free_huge_page() to folios
Date: Tue, 29 Nov 2022 14:50:32 -0800

Removes compound_head() call by using a folio rather than a head page.

Link: https://lkml.kernel.org/r/20221129225039.82257-4-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Tarun Sahu <tsahu@linux.ibm.com>
Cc: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-convert-dissolve_free_huge_page-to-folios
+++ a/mm/hugetlb.c
@@ -2128,21 +2128,21 @@ static struct page *remove_pool_huge_pag
 int dissolve_free_huge_page(struct page *page)
 {
 	int rc = -EBUSY;
+	struct folio *folio = page_folio(page);
 
 retry:
 	/* Not to disrupt normal path by vainly holding hugetlb_lock */
-	if (!PageHuge(page))
+	if (!folio_test_hugetlb(folio))
 		return 0;
 
 	spin_lock_irq(&hugetlb_lock);
-	if (!PageHuge(page)) {
+	if (!folio_test_hugetlb(folio)) {
 		rc = 0;
 		goto out;
 	}
 
-	if (!page_count(page)) {
-		struct page *head = compound_head(page);
-		struct hstate *h = page_hstate(head);
+	if (!folio_ref_count(folio)) {
+		struct hstate *h = folio_hstate(folio);
 		if (!available_huge_pages(h))
 			goto out;
 
@@ -2150,7 +2150,7 @@ retry:
 		 * We should make sure that the page is already on the free list
 		 * when it is dissolved.
 		 */
-		if (unlikely(!HPageFreed(head))) {
+		if (unlikely(!folio_test_hugetlb_freed(folio))) {
 			spin_unlock_irq(&hugetlb_lock);
 			cond_resched();
 
@@ -2165,7 +2165,7 @@ retry:
 			goto retry;
 		}
 
-		remove_hugetlb_page(h, head, false);
+		remove_hugetlb_page(h, &folio->page, false);
 		h->max_huge_pages--;
 		spin_unlock_irq(&hugetlb_lock);
 
@@ -2177,12 +2177,12 @@ retry:
 		 * Attempt to allocate vmemmmap here so that we can take
 		 * appropriate action on failure.
 		 */
-		rc = hugetlb_vmemmap_restore(h, head);
+		rc = hugetlb_vmemmap_restore(h, &folio->page);
 		if (!rc) {
-			update_and_free_page(h, head, false);
+			update_and_free_page(h, &folio->page, false);
 		} else {
 			spin_lock_irq(&hugetlb_lock);
-			add_hugetlb_page(h, head, false);
+			add_hugetlb_page(h, &folio->page, false);
 			h->max_huge_pages++;
 			spin_unlock_irq(&hugetlb_lock);
 		}
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


