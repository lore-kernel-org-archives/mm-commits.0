Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61D61C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 12 Jan 2023 21:32:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbjALVcs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Jan 2023 16:32:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240624AbjALVcF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2023 16:32:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22960395C3
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 13:16:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC06EB82022
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 21:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73EA9C433F0;
        Thu, 12 Jan 2023 21:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673558195;
        bh=wVua3OWFi55eZFfJ8Qb/1lG7xU9DpmwtC2Z873HrYrU=;
        h=Date:To:From:Subject:From;
        b=YAZCmCaRU0kosH9Xci5RpqdTv9Cun0iAQjO3e1VJQA/Qbi3oyF/KpLmJyCpQazdEd
         K5vYzWuH65tVKowEsu0xPbOAUgbXHxEKY3FyQFDcq0uURnQ+jnmYmIgeoxXl5D8stt
         hP8XPpMFnHpyCf9141L19pVEmEzuQoBkC2tsmV/0=
Date:   Thu, 12 Jan 2023 13:16:34 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-convert-raw_hwp_list_head-to-folios.patch added to mm-unstable branch
Message-Id: <20230112211635.73EA9C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: convert raw_hwp_list_head() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-convert-raw_hwp_list_head-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-convert-raw_hwp_list_head-to-folios.patch

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
Subject: mm/memory-failure: convert raw_hwp_list_head() to folios
Date: Thu, 12 Jan 2023 14:46:05 -0600

Change raw_hwp_list_head() to take in a folio and modify its callers to
pass in a folio.  Also converts two users of hugetlb specific page macro
users to their folio equivalents.

Link: https://lkml.kernel.org/r/20230112204608.80136-6-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-convert-raw_hwp_list_head-to-folios
+++ a/mm/memory-failure.c
@@ -1695,9 +1695,9 @@ struct raw_hwp_page {
 	struct page *page;
 };
 
-static inline struct llist_head *raw_hwp_list_head(struct page *hpage)
+static inline struct llist_head *raw_hwp_list_head(struct folio *folio)
 {
-	return (struct llist_head *)&page_folio(hpage)->_hugetlb_hwpoison;
+	return (struct llist_head *)&folio->_hugetlb_hwpoison;
 }
 
 static unsigned long __free_raw_hwp_pages(struct page *hpage, bool move_flag)
@@ -1705,8 +1705,9 @@ static unsigned long __free_raw_hwp_page
 	struct llist_head *head;
 	struct llist_node *t, *tnode;
 	unsigned long count = 0;
+	struct folio *folio = page_folio(hpage);
 
-	head = raw_hwp_list_head(hpage);
+	head = raw_hwp_list_head(folio);
 	llist_for_each_safe(tnode, t, head->first) {
 		struct raw_hwp_page *p = container_of(tnode, struct raw_hwp_page, node);
 
@@ -1727,15 +1728,16 @@ static int hugetlb_set_page_hwpoison(str
 	struct raw_hwp_page *raw_hwp;
 	struct llist_node *t, *tnode;
 	int ret = TestSetPageHWPoison(hpage) ? -EHWPOISON : 0;
+	struct folio *folio = page_folio(hpage);
 
 	/*
 	 * Once the hwpoison hugepage has lost reliable raw error info,
 	 * there is little meaning to keep additional error info precisely,
 	 * so skip to add additional raw error info.
 	 */
-	if (HPageRawHwpUnreliable(hpage))
+	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
 		return -EHWPOISON;
-	head = raw_hwp_list_head(hpage);
+	head = raw_hwp_list_head(folio);
 	llist_for_each_safe(tnode, t, head->first) {
 		struct raw_hwp_page *p = container_of(tnode, struct raw_hwp_page, node);
 
@@ -1756,9 +1758,9 @@ static int hugetlb_set_page_hwpoison(str
 		 * hwpoisoned subpages, and we need refuse to free/dissolve
 		 * this hwpoisoned hugepage.
 		 */
-		SetHPageRawHwpUnreliable(hpage);
+		folio_set_hugetlb_raw_hwp_unreliable(folio);
 		/*
-		 * Once HPageRawHwpUnreliable is set, raw_hwp_page is not
+		 * Once hugetlb_raw_hwp_unreliable is set, raw_hwp_page is not
 		 * used any more, so free it.
 		 */
 		__free_raw_hwp_pages(hpage, false);
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

