Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 537B9C2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 23:36:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E615622470
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 23:36:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SpOhuxOq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgKTXgN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Nov 2020 18:36:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:50666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726172AbgKTXgN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Nov 2020 18:36:13 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEE5D2240C;
        Fri, 20 Nov 2020 23:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605915373;
        bh=jTqyPv1D2qjYtwfwkIYi5I++xeMKy4VsGepez164yGA=;
        h=Date:From:To:Subject:From;
        b=SpOhuxOqk1Vdm5uohl02o8rtQSMwx4ZGrldtZ4B1jO+44x7qryiujyQDibayt5OA9
         Mhnsugqv8gLRIO9FQv4ESE2pQEEu0HHp6JsDJJTrndnOUxA7GzH4GVkRGpbtGseIDh
         IIwqAvk/O4Hc4d2TLkDSSqHiYdSGGf4ijEt1PfU8=
Date:   Fri, 20 Nov 2020 15:36:12 -0800
From:   akpm@linux-foundation.org
To:     liu.xiang@zlingsmart.com, liuxiang_1999@126.com,
        ma.chenggong@zlingsmart.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, pan.jiagen@zlingsmart.com
Subject:  +
 =?US-ASCII?Q?mm-hugetlb-fix-type-of-delta-parameter-and-related-local-var?=
 =?US-ASCII?Q?iables-in-gather=5Fsurplus=5Fpages.patch?= added to -mm tree
Message-ID: <20201120233612.90qk8gCUh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: fix type of delta parameter and related local variables in gather_surplus_pages()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-type-of-delta-parameter-and-related-local-variables-in-gather_surplus_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-type-of-delta-parameter-and-related-local-variables-in-gather_surplus_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-type-of-delta-parameter-and-related-local-variables-in-gather_surplus_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Liu Xiang <liu.xiang@zlingsmart.com>
Subject: mm: hugetlb: fix type of delta parameter and related local variables in gather_surplus_pages()

On 64-bit machine, delta variable in hugetlb_acct_memory() may be larger
than 0xffffffff, but gather_surplus_pages() can only use the low 32-bit
value now.  So we need to fix type of delta parameter and related local
variables in gather_surplus_pages().

Link: https://lkml.kernel.org/r/1605793733-3573-1-git-send-email-liu.xiang@zlingsmart.com
Reported-by: Ma Chenggong <ma.chenggong@zlingsmart.com>
Signed-off-by: Liu Xiang <liu.xiang@zlingsmart.com>
Signed-off-by: Pan Jiagen <pan.jiagen@zlingsmart.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Liu Xiang <liuxiang_1999@126.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-type-of-delta-parameter-and-related-local-variables-in-gather_surplus_pages
+++ a/mm/hugetlb.c
@@ -1943,13 +1943,14 @@ struct page *alloc_huge_page_vma(struct
  * Increase the hugetlb pool such that it can accommodate a reservation
  * of size 'delta'.
  */
-static int gather_surplus_pages(struct hstate *h, int delta)
+static int gather_surplus_pages(struct hstate *h, long delta)
 	__must_hold(&hugetlb_lock)
 {
 	struct list_head surplus_list;
 	struct page *page, *tmp;
-	int ret, i;
-	int needed, allocated;
+	int ret;
+	long i;
+	long needed, allocated;
 	bool alloc_ok = true;
 
 	needed = (h->resv_huge_pages + delta) - h->free_huge_pages;
_

Patches currently in -mm which might be from liu.xiang@zlingsmart.com are

mm-hugetlb-fix-type-of-delta-parameter-and-related-local-variables-in-gather_surplus_pages.patch

