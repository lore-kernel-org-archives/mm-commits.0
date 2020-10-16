Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD80C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3580F2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817540;
	bh=hZJ7IDPfE2iiF4yamOZcSBr7NJL3j1MrnxSHubN5nxc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=YhiidnM2tnZblwPsVuXRDkT42BrHSJOJcXTo8C9P1aYJVRtCY2m8TZ6MZckQsIlef
	 SrjKrHn7clDy6KmaoEROGN3gyOwmAFUqaM4INWec+/eQ1CNlnYRDUymzCRrlJNaBaF
	 LWWrSaJAvmoRKIbh3olpwshxDRwH3RRvvrJu5w0E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393940AbgJPDFj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:05:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbgJPDFj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:05:39 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14DE820789;
        Fri, 16 Oct 2020 03:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817537;
        bh=hZJ7IDPfE2iiF4yamOZcSBr7NJL3j1MrnxSHubN5nxc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=He3Koc+0/ArysxUk5kcYCXrSxkYV9gVcbywfDZshEJXOl89+IRrcWtsn+VQY66LpG
         moJ3gxceqCZut8tFxFCU8ML2ublfZlEfWtj5OT3gxgGImtqCt0RO9Xw5//V76YR9qI
         I7IKkN+i/3wMdhU5xgXWkrn3TiaZubSWkbdCBu48=
Date:   Thu, 15 Oct 2020 20:05:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, kirill@shutemov.name,
        mm-commits@vger.kernel.org, sjpark@amazon.de,
        torvalds@linux-foundation.org, willy@infradead.org,
        ying.huang@intel.com
Subject:  [patch 023/156] mm/huge_memory: fix split assumption of
 page size
Message-ID: <20201016030536.7W9s4Vm6Y%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm/huge_memory: fix split assumption of page size

File THPs may now be of arbitrary size, and we can't rely on that size
after doing the split so remember the number of pages before we start the
split.

Link: https://lkml.kernel.org/r/20200908195539.25896-6-willy@infradead.org
Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: SeongJae Park <sjpark@amazon.de>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-split-assumption-of-page-size
+++ a/mm/huge_memory.c
@@ -2335,13 +2335,13 @@ static void unmap_page(struct page *page
 	VM_BUG_ON_PAGE(!unmap_success, page);
 }
 
-static void remap_page(struct page *page)
+static void remap_page(struct page *page, unsigned int nr)
 {
 	int i;
 	if (PageTransHuge(page)) {
 		remove_migration_ptes(page, page, true);
 	} else {
-		for (i = 0; i < HPAGE_PMD_NR; i++)
+		for (i = 0; i < nr; i++)
 			remove_migration_ptes(page + i, page + i, true);
 	}
 }
@@ -2419,6 +2419,7 @@ static void __split_huge_page(struct pag
 	struct lruvec *lruvec;
 	struct address_space *swap_cache = NULL;
 	unsigned long offset = 0;
+	unsigned int nr = thp_nr_pages(head);
 	int i;
 
 	lruvec = mem_cgroup_page_lruvec(head, pgdat);
@@ -2434,7 +2435,7 @@ static void __split_huge_page(struct pag
 		xa_lock(&swap_cache->i_pages);
 	}
 
-	for (i = HPAGE_PMD_NR - 1; i >= 1; i--) {
+	for (i = nr - 1; i >= 1; i--) {
 		__split_huge_page_tail(head, i, lruvec, list);
 		/* Some pages can be beyond i_size: drop them from page cache */
 		if (head[i].index >= end) {
@@ -2454,7 +2455,7 @@ static void __split_huge_page(struct pag
 
 	ClearPageCompound(head);
 
-	split_page_owner(head, HPAGE_PMD_NR);
+	split_page_owner(head, nr);
 
 	/* See comment in __split_huge_page_tail() */
 	if (PageAnon(head)) {
@@ -2473,9 +2474,9 @@ static void __split_huge_page(struct pag
 
 	spin_unlock_irqrestore(&pgdat->lru_lock, flags);
 
-	remap_page(head);
+	remap_page(head, nr);
 
-	for (i = 0; i < HPAGE_PMD_NR; i++) {
+	for (i = 0; i < nr; i++) {
 		struct page *subpage = head + i;
 		if (subpage == page)
 			continue;
@@ -2729,7 +2730,7 @@ int split_huge_page_to_list(struct page
 fail:		if (mapping)
 			xa_unlock(&mapping->i_pages);
 		spin_unlock_irqrestore(&pgdata->lru_lock, flags);
-		remap_page(head);
+		remap_page(head, thp_nr_pages(head));
 		ret = -EBUSY;
 	}
 
_
