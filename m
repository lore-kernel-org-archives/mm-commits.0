Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07733C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D169A206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195980;
	bh=919WNOuqeI0/4N1NsINVedBgAFNVJTZjo/sFaR+44NQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=L0bi0cmSOsMa5RI8yThnWOGfgmkO9Ebp5ZO9VX6trmfhUMN8dje8Ax5JsCWHxs+x/
	 fg/J6bPdhTR5oOS6jd20oj8UYB6BVzIfvypoigsc6IwUNl1PfqD90Ns39TYNm3GvkI
	 JWg+FClPEf1f024p+Wx70NOvukzGvsEZn+MUc7ag=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgHLBdA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:33:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBdA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:33:00 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACD41207DA;
        Wed, 12 Aug 2020 01:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195979;
        bh=919WNOuqeI0/4N1NsINVedBgAFNVJTZjo/sFaR+44NQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LMgsar/Bqpbqkj2jsVvQhbc/Juc9ZOs60GjNCrGZuXqf9PMR9K56roxQI6QBIfrfq
         3N/BQCGbL10ShpuugunohbxWqdEbwuwa22Sm/9TGSet435UF3m47CoKWA3e9v6i1Cu
         bI986zonXLFKb39B+/7rp7ycajVT6D+o0okE9MIo=
Date:   Tue, 11 Aug 2020 18:32:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org,
        ziy@nvidia.com
Subject:  [patch 051/165] mm/hugetlb.c: delete duplicated words
Message-ID: <20200812013259.IQW5xfOau%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/hugetlb.c: delete duplicated words

Drop the repeated word "the" in two places.

Link: http://lkml.kernel.org/r/20200801173822.14973-5-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlbc-delete-duplicated-words
+++ a/mm/hugetlb.c
@@ -133,7 +133,7 @@ void hugepage_put_subpool(struct hugepag
 /*
  * Subpool accounting for allocating and reserving pages.
  * Return -ENOMEM if there are not enough resources to satisfy the
- * the request.  Otherwise, return the number of pages by which the
+ * request.  Otherwise, return the number of pages by which the
  * global pools must be adjusted (upward).  The returned value may
  * only be different than the passed value (delta) in the case where
  * a subpool minimum size must be maintained.
@@ -2167,7 +2167,7 @@ static void return_unused_surplus_pages(
 	 * evenly across all nodes with memory. Iterate across these nodes
 	 * until we can no longer free unreserved surplus pages. This occurs
 	 * when the nodes with surplus pages have no free pages.
-	 * free_pool_huge_page() will balance the the freed pages across the
+	 * free_pool_huge_page() will balance the freed pages across the
 	 * on-line nodes with memory and will handle the hstate accounting.
 	 *
 	 * Note that we decrement resv_huge_pages as we free the pages.  If
_
