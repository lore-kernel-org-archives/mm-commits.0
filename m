Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96528C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355097AbiCYBeU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357580AbiCYBd0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2563BD8AF
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5523561941
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2BEC340EC;
        Fri, 25 Mar 2022 01:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171912;
        bh=/tQbK/ICn9eImOQzqA7ZgMa6x8Z0Gt/KCSSuggQFqoc=;
        h=Date:To:From:Subject:From;
        b=rkyqqAaUE82U93K7RfAef5d+ltuULkWZbIROgMKAD7wHb62Xdwz/LcZsGMkNkdLHC
         0CeZkjC8C0IhB1UTE31w9+Ufdk64L/5AI4NNRz+OFZOhR3TvQ/2IAdpLmV23mOE3N6
         RholPlbqr18KPL1VDYeFOIPi+vjIIcQ8r+dQ1Hj4=
Date:   Thu, 24 Mar 2022 18:31:52 -0700
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        shy828301@gmail.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, bp@alien8.de, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-memory-failurec-make-non-lru-movable-pages-unhandlable.patch removed from -mm tree
Message-Id: <20220325013152.AE2BEC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: make non-LRU movable pages unhandlable
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-make-non-lru-movable-pages-unhandlable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: make non-LRU movable pages unhandlable

We can not really handle non-LRU movable pages in memory failure. 
Typically they are balloon, zsmalloc, etc.  Assuming we run into a base
(4K) non-LRU movable page, we could reach as far as identify_page_state(),
it should not fall into any category except me_unknown.

For the non-LRU compound movable pages, they could be taken for transhuge
pages but it's unexpected to split non-LRU movable pages using
split_huge_page_to_list in memory_failure.  So we could just simply make
non-LRU movable pages unhandlable to avoid these possible nasty cases.

Link: https://lkml.kernel.org/r/20220312074613.4798-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failurec-make-non-lru-movable-pages-unhandlable
+++ a/mm/memory-failure.c
@@ -1176,12 +1176,18 @@ void ClearPageHWPoisonTakenOff(struct pa
  * does not return true for hugetlb or device memory pages, so it's assumed
  * to be called only in the context where we never have such pages.
  */
-static inline bool HWPoisonHandlable(struct page *page)
+static inline bool HWPoisonHandlable(struct page *page, unsigned long flags)
 {
-	return PageLRU(page) || __PageMovable(page) || is_free_buddy_page(page);
+	bool movable = false;
+
+	/* Soft offline could mirgate non-LRU movable pages */
+	if ((flags & MF_SOFT_OFFLINE) && __PageMovable(page))
+		movable = true;
+
+	return movable || PageLRU(page) || is_free_buddy_page(page);
 }
 
-static int __get_hwpoison_page(struct page *page)
+static int __get_hwpoison_page(struct page *page, unsigned long flags)
 {
 	struct page *head = compound_head(page);
 	int ret = 0;
@@ -1196,7 +1202,7 @@ static int __get_hwpoison_page(struct pa
 	 * for any unsupported type of page in order to reduce the risk of
 	 * unexpected races caused by taking a page refcount.
 	 */
-	if (!HWPoisonHandlable(head))
+	if (!HWPoisonHandlable(head, flags))
 		return -EBUSY;
 
 	if (get_page_unless_zero(head)) {
@@ -1221,7 +1227,7 @@ static int get_any_page(struct page *p,
 
 try_again:
 	if (!count_increased) {
-		ret = __get_hwpoison_page(p);
+		ret = __get_hwpoison_page(p, flags);
 		if (!ret) {
 			if (page_count(p)) {
 				/* We raced with an allocation, retry. */
@@ -1249,7 +1255,7 @@ try_again:
 		}
 	}
 
-	if (PageHuge(p) || HWPoisonHandlable(p)) {
+	if (PageHuge(p) || HWPoisonHandlable(p, flags)) {
 		ret = 1;
 	} else {
 		/*
@@ -2302,7 +2308,7 @@ int soft_offline_page(unsigned long pfn,
 
 retry:
 	get_online_mems();
-	ret = get_hwpoison_page(page, flags);
+	ret = get_hwpoison_page(page, flags | MF_SOFT_OFFLINE);
 	put_online_mems();
 
 	if (ret > 0) {
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

