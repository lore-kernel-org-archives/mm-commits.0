Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E4EC433E9
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BC7564F1D
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235098AbhBXUIT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:08:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:59816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235325AbhBXUHn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:07:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D369F64F19;
        Wed, 24 Feb 2021 20:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197223;
        bh=XpOa6CoMVvrGtFIGWWAhgEEXehR2Y6aQUgckuO2DBxs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Se5s58OJfggXjYY+G359KjjrVAcC4tcTyTIP+1cL3TfmIJhpnJLqbk2E/0NAiNNIn
         kOm7us/coZz09p/vOZ+GRsHZzYbwAO1JmYI/0SHAQBLPD9ZoPP50QFXEfTEclnzO9P
         V1+K9XLZQO1MP1T16Zv3UewtUQHf4gsGEVSrXHss=
Date:   Wed, 24 Feb 2021 12:07:01 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 116/173] mm/hugetlb: use helper huge_page_order
 and pages_per_huge_page
Message-ID: <20210224200701._da-PYkZ7%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: use helper huge_page_order and pages_per_huge_page

Since commit a5516438959d ("hugetlb: modular state for hugetlb page
size"), we can use huge_page_order to access hstate->order and
pages_per_huge_page to fetch the pages per huge page.  But
gather_bootmem_prealloc() forgot to use it.

Link: https://lkml.kernel.org/r/20210114114435.40075-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-helper-huge_page_order-and-pages_per_huge_page
+++ a/mm/hugetlb.c
@@ -2476,7 +2476,7 @@ static void __init gather_bootmem_preall
 		struct hstate *h = m->hstate;
 
 		WARN_ON(page_count(page) != 1);
-		prep_compound_huge_page(page, h->order);
+		prep_compound_huge_page(page, huge_page_order(h));
 		WARN_ON(PageReserved(page));
 		prep_new_huge_page(h, page, page_to_nid(page));
 		put_page(page); /* free it into the hugepage allocator */
@@ -2488,7 +2488,7 @@ static void __init gather_bootmem_preall
 		 * side-effects, like CommitLimit going negative.
 		 */
 		if (hstate_is_gigantic(h))
-			adjust_managed_page_count(page, 1 << h->order);
+			adjust_managed_page_count(page, pages_per_huge_page(h));
 		cond_resched();
 	}
 }
_
