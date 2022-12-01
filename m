Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEFA5C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbiLAAAx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiLAAAj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEAF5AE26
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A02F861E6C
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBAADC433B5;
        Thu,  1 Dec 2022 00:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852829;
        bh=sjktd8v37+aU/V5BVLkqw4pukOTAk/KVFzewDpK4ksA=;
        h=Date:To:From:Subject:From;
        b=S6qwYga46DE5tCU/PunHN24Vt6LjkL/f+8dCgLgciQnoR/sniK8Wgk3fnCuaqAU8Y
         lab/JjbVeKXvbTvHdIt1zTUVl5lKe9mwLZAezYT7zTn9uk0tgdopQy38LKG9I+RRQL
         zFzjFr1/QJqN19LlzvML3TaD46sNExcD9wipCv4Y=
Date:   Wed, 30 Nov 2022 16:00:28 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, minhquangbui99@gmail.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        aneesh.kumar@linux.ibm.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-convert-isolate_or_dissolve_huge_page-to-folios.patch removed from -mm tree
Message-Id: <20221201000028.EBAADC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: convert isolate_or_dissolve_huge_page to folios
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-isolate_or_dissolve_huge_page-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert isolate_or_dissolve_huge_page to folios
Date: Tue, 1 Nov 2022 15:30:55 -0700

Removes a call to compound_head() by using a folio when operating on the
head page of a hugetlb compound page.

Link: https://lkml.kernel.org/r/20221101223059.460937-6-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Bui Quang Minh <minhquangbui99@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mina Almasry <almasrymina@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-convert-isolate_or_dissolve_huge_page-to-folios
+++ a/mm/hugetlb.c
@@ -2832,7 +2832,7 @@ free_new:
 int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list)
 {
 	struct hstate *h;
-	struct page *head;
+	struct folio *folio = page_folio(page);
 	int ret = -EBUSY;
 
 	/*
@@ -2841,9 +2841,8 @@ int isolate_or_dissolve_huge_page(struct
 	 * Return success when racing as if we dissolved the page ourselves.
 	 */
 	spin_lock_irq(&hugetlb_lock);
-	if (PageHuge(page)) {
-		head = compound_head(page);
-		h = page_hstate(head);
+	if (folio_test_hugetlb(folio)) {
+		h = folio_hstate(folio);
 	} else {
 		spin_unlock_irq(&hugetlb_lock);
 		return 0;
@@ -2858,10 +2857,10 @@ int isolate_or_dissolve_huge_page(struct
 	if (hstate_is_gigantic(h))
 		return -ENOMEM;
 
-	if (page_count(head) && !isolate_hugetlb(head, list))
+	if (folio_ref_count(folio) && !isolate_hugetlb(&folio->page, list))
 		ret = 0;
-	else if (!page_count(head))
-		ret = alloc_and_dissolve_huge_page(h, head, list);
+	else if (!folio_ref_count(folio))
+		ret = alloc_and_dissolve_huge_page(h, &folio->page, list);
 
 	return ret;
 }
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

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

