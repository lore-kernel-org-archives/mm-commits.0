Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74478C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 356D164F26
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235283AbhBXUIW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:08:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:59162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234283AbhBXUH4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:07:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6348664F1B;
        Wed, 24 Feb 2021 20:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197243;
        bh=MPMYyb7bAp0/VLqCjy8OzVun3Or16xOaDaXsakgvwx4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0G+D+NxM3hgQFO05WJx5IaRYaKNUa0wjTUk96gCp9jt6paaYX52wmkI+/FuoBHi1O
         69mQrKvP5ohPrR68bS50S1i9xETKiVs8kUaGt4Mo0WQ+xUwrDrHtJ64/oRm9R6/dtN
         jz2vRRDT45WgCXozoB9oBKExIOWud8qn2SZdknew=
Date:   Wed, 24 Feb 2021 12:07:22 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, yanfei.xu@windriver.com
Subject:  [patch 122/173] mm/hugetlb: remove redundant check in
 preparing and destroying gigantic page
Message-ID: <20210224200722.kWLDke_bB%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yanfei Xu <yanfei.xu@windriver.com>
Subject: mm/hugetlb: remove redundant check in preparing and destroying gigantic page

Gigantic page is a compound page and its order is more than 1.  Thus it
must be available for hpage_pincount.  Let's remove the redundant check
for gigantic page.

Link: https://lkml.kernel.org/r/20210202112002.73170-1-yanfei.xu@windriver.com
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-remove-redundant-check-in-preparing-and-destroying-gigantic-page
+++ a/mm/hugetlb.c
@@ -1234,8 +1234,7 @@ static void destroy_compound_gigantic_pa
 	struct page *p = page + 1;
 
 	atomic_set(compound_mapcount_ptr(page), 0);
-	if (hpage_pincount_available(page))
-		atomic_set(compound_pincount_ptr(page), 0);
+	atomic_set(compound_pincount_ptr(page), 0);
 
 	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
 		clear_compound_head(p);
@@ -1563,9 +1562,7 @@ static void prep_compound_gigantic_page(
 		set_compound_head(p, page);
 	}
 	atomic_set(compound_mapcount_ptr(page), -1);
-
-	if (hpage_pincount_available(page))
-		atomic_set(compound_pincount_ptr(page), 0);
+	atomic_set(compound_pincount_ptr(page), 0);
 }
 
 /*
_
