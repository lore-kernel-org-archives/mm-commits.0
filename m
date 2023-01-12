Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE617C61DB3
	for <mm-commits@archiver.kernel.org>; Thu, 12 Jan 2023 21:32:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbjALVcn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Jan 2023 16:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbjALVcS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2023 16:32:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE892395E6
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 13:16:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 221FF62197
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 21:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794B3C433F0;
        Thu, 12 Jan 2023 21:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673558199;
        bh=eccZKXJn3ARgtyzzn//0FWQ6tZxV9DRztlB3dliQ4rE=;
        h=Date:To:From:Subject:From;
        b=l/J/XONYiZ5dfqR7qp7B/leoWJS9r0vW4xBXnXSNcmb+1mIrKc6IOiyPvtdDMWDoo
         WT/Z6zDqKNrf8RJJWUnl61Ad8yAOEkMany3xfbaZ/10lYVuJmjux2O/7eoYs92ONpZ
         r6LTT2Xo57LBSQnSBLGrncdL0b6+jwD763lF6gwo=
Date:   Thu, 12 Jan 2023 13:16:38 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-convert-hugetlb_set_page_hwpoison-to-folios.patch added to mm-unstable branch
Message-Id: <20230112211639.794B3C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: convert hugetlb_set_page_hwpoison() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-convert-hugetlb_set_page_hwpoison-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-convert-hugetlb_set_page_hwpoison-to-folios.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/memory-failure: convert hugetlb_set_page_hwpoison() to folios
Date: Thu, 12 Jan 2023 14:46:07 -0600

Change hugetlb_set_page_hwpoison() to folio_set_hugetlb_hwpoison() and use
a folio internally.

Link: https://lkml.kernel.org/r/20230112204608.80136-8-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

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

mm-move-folio_set_compound_order-to-mm-internalh.patch
mm-introduce-folio_is_pfmemalloc.patch
mm-remove-the-hugetlb-field-from-struct-page.patch
mm-memory-failure-convert-__get_huge_page_for_hwpoison-to-folios.patch
mm-memory-failure-convert-try_memory_failure_hugetlb-to-folios.patch
mm-memory-failure-convert-hugetlb_clear_page_hwpoison-to-folios.patch
mm-memory-failure-convert-free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-raw_hwp_list_head-to-folios.patch
mm-memory-failure-convert-__free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-hugetlb_set_page_hwpoison-to-folios.patch
mm-memory-failure-convert-unpoison_memory-to-folios.patch

