Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3284FC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbiCVVq2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236383AbiCVVqW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:46:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423405F8C1
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:44:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD526B81DB9
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79723C340EE;
        Tue, 22 Mar 2022 21:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985491;
        bh=zCEyjdx5mHzAsw8Q2UZPFRSoRBqMsxXVKNHia3WkJyw=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=GCY75yYEe/eZ1v1mAWx6vqle7Po4M6FgQuNM4h3RwC4rj21re+bA9HAhyRnlbxtS5
         CjeqRHaw5CkOt0j8EsZmZNUnSX5vSjcsQYypVM9iJBeGNhgknCbhg+CbvOC/VVO3yt
         3tfNl+hR89ffpYN26TVoADCZOpkiRctcD0Wpg7ug=
Date:   Tue, 22 Mar 2022 14:44:50 -0700
To:     tony.luck@intel.com, shy828301@gmail.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, bp@alien8.de, linmiaohe@huawei.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 125/227] mm/memory-failure.c: make non-LRU movable pages unhandlable
Message-Id: <20220322214451.79723C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
