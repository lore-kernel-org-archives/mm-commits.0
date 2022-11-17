Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3E38C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 17 Nov 2022 21:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235113AbiKQVZi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Nov 2022 16:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240550AbiKQVZV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2022 16:25:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BEEB4A3
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 13:23:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21CCD62277
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 21:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB90C433D6;
        Thu, 17 Nov 2022 21:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668720230;
        bh=RmibTiHK3MO/h5+lF+gZ0jpXnyRIMSKQXKy6PuBhHhc=;
        h=Date:To:From:Subject:From;
        b=lHlYkq4XEps08viJ1dpxPuQBaQDgZmjGcsmbg4ieA50527+YoIyvtGMwK/53DSGRI
         got1mGwp22LC+Qq38+kiGL7S7usBmiYSiFLV6kv1IUT7BOqys3tjZ9uYhknEWUu2wz
         n1eY7AlKhs7lh9hpQHS2kYq70EeKrpJGgBtHBDtg=
Date:   Thu, 17 Nov 2022 13:23:50 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, hughd@google.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-dissolve_free_huge_page-to-folios.patch added to mm-unstable branch
Message-Id: <20221117212350.7BB90C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert dissolve_free_huge_page() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-dissolve_free_huge_page-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-dissolve_free_huge_page-to-folios.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert dissolve_free_huge_page() to folios
Date: Thu, 17 Nov 2022 13:14:54 -0800

Remove compound_head() call by using a folio rather than a head page.

Link: https://lkml.kernel.org/r/20221117211501.17150-4-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-convert-dissolve_free_huge_page-to-folios
+++ a/mm/hugetlb.c
@@ -2126,21 +2126,21 @@ static struct page *remove_pool_huge_pag
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
 
@@ -2148,7 +2148,7 @@ retry:
 		 * We should make sure that the page is already on the free list
 		 * when it is dissolved.
 		 */
-		if (unlikely(!HPageFreed(head))) {
+		if (unlikely(!folio_test_hugetlb_freed(folio))) {
 			spin_unlock_irq(&hugetlb_lock);
 			cond_resched();
 
@@ -2163,7 +2163,7 @@ retry:
 			goto retry;
 		}
 
-		remove_hugetlb_page(h, head, false);
+		remove_hugetlb_page(h, &folio->page, false);
 		h->max_huge_pages--;
 		spin_unlock_irq(&hugetlb_lock);
 
@@ -2175,12 +2175,12 @@ retry:
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

mm-hugetlb_cgroup-convert-__set_hugetlb_cgroup-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_from_page-to-folios.patch
mm-hugetlb_cgroup-convert-set_hugetlb_cgroup-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios.patch
mm-hugetlb-convert-isolate_or_dissolve_huge_page-to-folios.patch
mm-hugetlb-convert-free_huge_page-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_uncharge_page-to-folios.patch
mm-hugeltb_cgroup-convert-hugetlb_cgroup_commit_charge-to-folios.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios.patch
mm-add-folio-dtor-and-order-setter-functions.patch
mm-hugetlb-convert-destroy_compound_gigantic_page-to-folios.patch
mm-hugetlb-convert-dissolve_free_huge_page-to-folios.patch
mm-hugetlb-convert-remove_hugetlb_page-to-folios.patch
mm-hugetlb-convert-update_and_free_page-to-folios.patch
mm-hugetlb-convert-add_hugetlb_page-to-folios-and-add-hugetlb_cma_folio.patch
mm-hugetlb-convert-enqueue_huge_page-to-folios.patch
mm-hugetlb-convert-free_gigantic_page-to-folios.patch
mm-hugetlb-convert-hugetlb-prep-functions-to-folios.patch
mm-hugetlb-change-hugetlb-allocation-functions-to-return-a-folio.patch

