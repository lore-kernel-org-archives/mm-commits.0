Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33926C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF65321655
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881301;
	bh=wS3a+YTUcammXbQJVAWattlbcdAZNd8o6Apa7D/EImU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=xazTiPekYMbdAZKStOtzjL0+tRYM73tWZ0S83sOBBQJQa4ZmxJmOpaT18O5Nps+rk
	 AcLYMsFYHRFrCBkVjXGbpdC5EB0V402QMjReMiRJXuXEKQyplbb7K0OOuZyZZmEJyM
	 dQcMZ8HzBP4K7pdfEtvDA4HbUPCDNw8S6cvFaNVA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392676AbgJPUsV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:48:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392697AbgJPUsV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:48:21 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C996D214DB;
        Fri, 16 Oct 2020 20:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881299;
        bh=wS3a+YTUcammXbQJVAWattlbcdAZNd8o6Apa7D/EImU=;
        h=Date:From:To:Subject:From;
        b=AjjWGO1vs/o3/fEL5IP3sL55ssQeUJ4gTdSyeMMb5yOarVwyjJcR5vziu/JnXmFqv
         q6Dnrp/fW6+J86YLUiRVy2fyJ/CbOe6S/P4sxVnzlC1yLyj6jLbP3kP+cyUhQxuRAA
         Hxupwys63gbQUT5Kf/ih4iqNGAbP7q606XE4G1uk=
Date:   Fri, 16 Oct 2020 13:48:18 -0700
From:   akpm@linux-foundation.org
To:     kirill@shutemov.name, mm-commits@vger.kernel.org, sjpark@amazon.de,
        willy@infradead.org, ying.huang@intel.com
Subject:  [merged]
 mm-huge_memory-fix-total_mapcount-assumption-of-page-size.patch removed
 from -mm tree
Message-ID: <20201016204818.POopRjgg1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: fix total_mapcount assumption of page size
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-total_mapcount-assumption-of-page-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm/huge_memory: fix total_mapcount assumption of page size

File THPs may now be of arbitrary order.

Link: https://lkml.kernel.org/r/20200908195539.25896-5-willy@infradead.org
Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: SeongJae Park <sjpark@amazon.de>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-total_mapcount-assumption-of-page-size
+++ a/mm/huge_memory.c
@@ -2494,7 +2494,7 @@ static void __split_huge_page(struct pag
 
 int total_mapcount(struct page *page)
 {
-	int i, compound, ret;
+	int i, compound, nr, ret;
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
@@ -2502,16 +2502,17 @@ int total_mapcount(struct page *page)
 		return atomic_read(&page->_mapcount) + 1;
 
 	compound = compound_mapcount(page);
+	nr = compound_nr(page);
 	if (PageHuge(page))
 		return compound;
 	ret = compound;
-	for (i = 0; i < HPAGE_PMD_NR; i++)
+	for (i = 0; i < nr; i++)
 		ret += atomic_read(&page[i]._mapcount) + 1;
 	/* File pages has compound_mapcount included in _mapcount */
 	if (!PageAnon(page))
-		return ret - compound * HPAGE_PMD_NR;
+		return ret - compound * nr;
 	if (PageDoubleMap(page))
-		ret -= HPAGE_PMD_NR;
+		ret -= nr;
 	return ret;
 }
 
_

Patches currently in -mm which might be from kirill@shutemov.name are


