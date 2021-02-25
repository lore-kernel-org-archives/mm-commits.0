Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC7AC4332D
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:33:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D2B664F28
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbhBYTdc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:33:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:38166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234598AbhBYTaN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:30:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9446E64F2B;
        Thu, 25 Feb 2021 19:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280620;
        bh=FmB+2OBz9s3wt+8GPtw5CPlzE2PeNALn76GYc6jZzx4=;
        h=Date:From:To:Subject:From;
        b=OL7BJpnzVC4iY+EeDBEQyBKwTCAJhLyqafkOdu9BuXP9IKAnZAgAg6nYLM4YHocEY
         1a2ZE/kMYC4GCap7BTodb6Y12KWLI9gB7tyVZ13DrCZ7exBpGsDuVxGMNhidFDqOCs
         Yc0PVl7G9ojaevtUdJAy7MBBZwyjBUCvpjidzpts=
Date:   Thu, 25 Feb 2021 11:17:00 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, yanfei.xu@windriver.com
Subject:  [merged]
 =?US-ASCII?Q?mm-hugetlb-remove-redundant-check-in-preparing-and-destro?=
 =?US-ASCII?Q?ying-gigantic-page.patch?= removed from -mm tree
Message-ID: <20210225191700.CJrsKZRtD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: remove redundant check in preparing and destroying gigantic page
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-redundant-check-in-preparing-and-destroying-gigantic-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from yanfei.xu@windriver.com are


