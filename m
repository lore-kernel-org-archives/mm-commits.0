Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A3B2C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E56F2078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266175;
	bh=CzopMsf+5IPRnkA0CZmqTMPp+LaTFWBSi7hpV5x+m3Y=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=0l3HQCOdzkThEE9e8l/nL9nkiGn1JQddPBnQrukfgySRqJcZUjztMrQjdA/MGZFfY
	 GwkLyk44m34m/VuqfatNRnPEU11095dh3JsoK1c5MZM+a2XpqkSbGwrVNOq3kI5wBA
	 a4zk1dwf4jJNxIdkIVsrl+vN0UA0OwUEbSugJT3w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgHLVCy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:02:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:51318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgHLVCy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:02:54 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7582920774;
        Wed, 12 Aug 2020 21:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266173;
        bh=CzopMsf+5IPRnkA0CZmqTMPp+LaTFWBSi7hpV5x+m3Y=;
        h=Date:From:To:Subject:From;
        b=ANm5LhSnRPNKBghY2Zwvlu/mGdjzvfKUnGH0DjBMeuk6vnoqUVMjqFdD55VlPI03F
         p+RPVWuxyBHGENgF0M8I5Vsaa5yyh4nV2VEyzb7809L8Xh5fnefI7dQC9uTHI6KdU0
         keTvP8+NXT0KgDo+kJk1DHsdvAbiXSYIZEHD0Q2g=
Date:   Wed, 12 Aug 2020 14:02:53 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org, ziy@nvidia.com
Subject:  [merged] mm-hugetlbc-delete-duplicated-words.patch
 removed from -mm tree
Message-ID: <20200812210253.szDM439QY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: delete duplicated words
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-delete-duplicated-words.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from rdunlap@infradead.org are


