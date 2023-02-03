Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31505C636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbjBCGha (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:37:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbjBCGgX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:36:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B32D8D622
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53447B82980
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D58C433D2;
        Fri,  3 Feb 2023 06:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406173;
        bh=w2kOTyT4S8NtekkRjuyTJt9WX1h4o70d4KjStgVVqUA=;
        h=Date:To:From:Subject:From;
        b=vI/2n6u9AGzPQUL1emYOfbmzHgf2UnQzcjF9ivdpO4q021UlzantS2wazsAgeIHo8
         pGLKDNoNixQ3QH9e6VJy7dsZIS9PK9uXymh+HnQ9hVe/TKxd+CRqP7F/NTDdcY9h1D
         a2Gu/pX73x+d31nEf6yZ5aDZrf9ejGhxSp2I/XVE=
Date:   Thu, 02 Feb 2023 22:36:12 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-convert-hugetlb_set_page_hwpoison-to-folios.patch removed from -mm tree
Message-Id: <20230203063612.E5D58C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory-failure: convert hugetlb_set_page_hwpoison() to folios
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-convert-hugetlb_set_page_hwpoison-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/memory-failure: convert hugetlb_set_page_hwpoison() to folios
Date: Thu, 12 Jan 2023 14:46:07 -0600

Change hugetlb_set_page_hwpoison() to folio_set_hugetlb_hwpoison() and use
a folio internally.

Link: https://lkml.kernel.org/r/20230112204608.80136-8-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory-failure.c~mm-memory-failure-convert-hugetlb_set_page_hwpoison-to-folios
+++ a/mm/memory-failure.c
@@ -1721,13 +1721,12 @@ static unsigned long __folio_free_raw_hw
 	return count;
 }
 
-static int hugetlb_set_page_hwpoison(struct page *hpage, struct page *page)
+static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
 {
 	struct llist_head *head;
 	struct raw_hwp_page *raw_hwp;
 	struct llist_node *t, *tnode;
-	int ret = TestSetPageHWPoison(hpage) ? -EHWPOISON : 0;
-	struct folio *folio = page_folio(hpage);
+	int ret = folio_test_set_hwpoison(folio) ? -EHWPOISON : 0;
 
 	/*
 	 * Once the hwpoison hugepage has lost reliable raw error info,
@@ -1830,7 +1829,7 @@ int __get_huge_page_for_hwpoison(unsigne
 			goto out;
 	}
 
-	if (hugetlb_set_page_hwpoison(&folio->page, page)) {
+	if (folio_set_hugetlb_hwpoison(folio, page)) {
 		ret = -EHWPOISON;
 		goto out;
 	}
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-hugetlb-convert-isolate_hugetlb-to-folios.patch
mm-hugetlb-convert-__update_and_free_page-to-folios.patch
mm-hugetlb-convert-dequeue_hugetlb_page-functions-to-folios.patch
mm-hugetlb-convert-alloc_surplus_huge_page-to-folios.patch
mm-hugetlb-increase-use-of-folios-in-alloc_huge_page.patch
mm-hugetlb-convert-alloc_migrate_huge_page-to-folios.patch
mm-hugetlb-convert-restore_reserve_on_error-to-folios.patch
mm-hugetlb-convert-demote_free_huge_page-to-folios.patch
mm-hugetlb-convert-hugetlb_install_page-to-folios.patch
mm-hugetlb-convert-hugetlbfs_pagecache_present-to-folios.patch
mm-hugetlb-convert-putback_active_hugepage-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb-fault-paths-to-use-alloc_hugetlb_folio.patch
mm-hugetlb-convert-restore_reserve_on_error-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_add_to_page_cache-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_wp-to-take-in-a-folio.patch
documentation-mm-update-hugetlbfs-documentation-to-mention-alloc_hugetlb_folio.patch

