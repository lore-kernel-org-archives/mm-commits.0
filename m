Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD087C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:42:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97A5E2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816136;
	bh=zHASiUDz758IL+Etgbjq3oRtoew3nAEe4RdntxV5XTM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=HMOgX28Xe5E/+zO16maPRktD3ScdLhJY05HPZHap/0rtaYTsKAEWeWGDju2xUwzRz
	 1ywDWyHx4nsXxGnFwDCN7whu+ODGqwHnja3voM6pioisPwB7xr4nXQqmVJD4ivREpv
	 4rBZHOJ7JppgE8zZGH/8tzTKFMpqzUSffaV8oPp8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404298AbgJPCmQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:42:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728688AbgJPCmQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:42:16 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E09312087D;
        Fri, 16 Oct 2020 02:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816134;
        bh=zHASiUDz758IL+Etgbjq3oRtoew3nAEe4RdntxV5XTM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=m/roYdpTtJszbqwKr8/8JWGW9j6tCwY9zNfLrJuRFf4Sso920sWI7TZfv9oN+ErH5
         Syjihra/fP+0z5+zjYPF4tu0B/e1+EB7vUdZPqSUJ96i8xSz8Uru8JElMEooTCh0g/
         RDlSTvImfcwYXZhFl+5J3k5c6FqzqzcPA58mvSXE=
Date:   Thu, 15 Oct 2020 19:42:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, kirill@shutemov.name,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, sjpark@amazon.de,
        torvalds@linux-foundation.org, willy@infradead.org,
        ying.huang@intel.com
Subject:  [patch 022/156] mm/huge_memory: fix total_mapcount
 assumption of page size
Message-ID: <20201016024213.uqBvLymdF%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
