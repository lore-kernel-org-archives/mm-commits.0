Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA59C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C733661469
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238391AbhGABvJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:51:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238384AbhGABvJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:51:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AB3B6120C;
        Thu,  1 Jul 2021 01:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104118;
        bh=nQ0gbeppwSM962tSymacgiCh73iB7vJGWKuZvbkVpjM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=apJgT3a1t2kdPZxfua7IXAUpj0yqiIxcuTcHrxH4avYdsBuCOVlgEkmuwDDXV7apg
         jiCvdjRSxAW8vXNT7HTzICGSOzdsBEPQAWg1swCsSDTUab6GFgalnJK1VdFwk3L+/f
         9rJf2FiZYg1CpmNtvQSqXQx1pHGxdA2w9j+0KoqI=
Date:   Wed, 30 Jun 2021 18:48:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de,
        torvalds@linux-foundation.org
Subject:  [patch 029/192] mm/hwpoison: disable pcp for
 page_handle_poison()
Message-ID: <20210701014838.TSZ9CNH3C%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm/hwpoison: disable pcp for page_handle_poison()

Recent changes by patch "mm/page_alloc: allow high-order pages to be
stored on the per-cpu lists" makes kernels determine whether to use pcp by
pcp_allowed_order(), which breaks soft-offline for hugetlb pages.

Soft-offline dissolves a migration source page, then removes it from buddy
free list, so it's assumed that any subpage of the soft-offlined hugepage
are recognized as a buddy page just after returning from
dissolve_free_huge_page().  pcp_allowed_order() returns true for hugetlb,
so this assumption is no longer true.

So disable pcp during dissolve_free_huge_page() and take_page_off_buddy()
to prevent soft-offlined hugepages from linking to pcp lists. 
Soft-offline should not be common events so the impact on performance
should be minimal.  And I think that the optimization of Mel's patch could
benefit to hugetlb so zone_pcp_disable() is called only in hwpoison
context.

Link: https://lkml.kernel.org/r/20210617092626.291006-1-nao.horiguchi@gmail.com
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-disable-pcp-for-page_handle_poison
+++ a/mm/memory-failure.c
@@ -66,6 +66,19 @@ int sysctl_memory_failure_recovery __rea
 
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
+static bool __page_handle_poison(struct page *page)
+{
+	bool ret;
+
+	zone_pcp_disable(page_zone(page));
+	ret = dissolve_free_huge_page(page);
+	if (!ret)
+		ret = take_page_off_buddy(page);
+	zone_pcp_enable(page_zone(page));
+
+	return ret;
+}
+
 static bool page_handle_poison(struct page *page, bool hugepage_or_freepage, bool release)
 {
 	if (hugepage_or_freepage) {
@@ -73,7 +86,7 @@ static bool page_handle_poison(struct pa
 		 * Doing this check for free pages is also fine since dissolve_free_huge_page
 		 * returns 0 for non-hugetlb pages as well.
 		 */
-		if (dissolve_free_huge_page(page) || !take_page_off_buddy(page))
+		if (!__page_handle_poison(page))
 			/*
 			 * We could fail to take off the target page from buddy
 			 * for example due to racy page allocation, but that's
@@ -985,7 +998,7 @@ static int me_huge_page(struct page *p,
 		 */
 		if (PageAnon(hpage))
 			put_page(hpage);
-		if (!dissolve_free_huge_page(p) && take_page_off_buddy(p)) {
+		if (__page_handle_poison(p)) {
 			page_ref_inc(p);
 			res = MF_RECOVERED;
 		}
@@ -1446,7 +1459,7 @@ static int memory_failure_hugetlb(unsign
 			}
 			unlock_page(head);
 			res = MF_FAILED;
-			if (!dissolve_free_huge_page(p) && take_page_off_buddy(p)) {
+			if (__page_handle_poison(p)) {
 				page_ref_inc(p);
 				res = MF_RECOVERED;
 			}
_
