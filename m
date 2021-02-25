Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D361EC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FBCB64F28
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbhBYTeb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:34:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:38106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234392AbhBYTcR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:32:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C183764F9B;
        Thu, 25 Feb 2021 19:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280663;
        bh=5A0213ArIUigo97y6E3E7ZR+GhqGPFOx2w9K1qDIlrw=;
        h=Date:From:To:Subject:From;
        b=hw0APL0MkCinv0gBYCBQwv6W2ubXzqvYcUgb87QtT5MUNjryv00FRuM0j7+i3FSeP
         W1SDznMCbo8reCz4WezL4AmB44ktdrXIBvW9wCQAALcHsFDVWuN/RfVQWpexa7vAeu
         RLgiV87yaUskNxNbauedP0WHOsXQCJZqOvKL6vj4=
Date:   Thu, 25 Feb 2021 11:17:42 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, guro@fb.com, hannes@cmpxchg.org,
        hughd@google.com, linmiaohe@huawei.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz, vdavydov.dev@gmail.com,
        willy@infradead.org, yuzhao@google.com
Subject:  [merged]
 mm-shuffle-lru-list-addition-and-deletion-functions.patch removed from -mm
 tree
Message-ID: <20210225191742.4EBuQE6ey%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mm_inline.h: shuffle lru list addition and deletion functions
has been removed from the -mm tree.  Its filename was
     mm-shuffle-lru-list-addition-and-deletion-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: include/linux/mm_inline.h: shuffle lru list addition and deletion functions

These functions will call page_lru() in the following patches.  Move them
below page_lru() to avoid the forward declaration.

Link: https://lore.kernel.org/linux-mm/20201207220949.830352-3-yuzhao@google.com/
Link: https://lkml.kernel.org/r/20210122220600.906146-3-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   42 ++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

--- a/include/linux/mm_inline.h~mm-shuffle-lru-list-addition-and-deletion-functions
+++ a/include/linux/mm_inline.h
@@ -45,27 +45,6 @@ static __always_inline void update_lru_s
 #endif
 }
 
-static __always_inline void add_page_to_lru_list(struct page *page,
-				struct lruvec *lruvec, enum lru_list lru)
-{
-	update_lru_size(lruvec, lru, page_zonenum(page), thp_nr_pages(page));
-	list_add(&page->lru, &lruvec->lists[lru]);
-}
-
-static __always_inline void add_page_to_lru_list_tail(struct page *page,
-				struct lruvec *lruvec, enum lru_list lru)
-{
-	update_lru_size(lruvec, lru, page_zonenum(page), thp_nr_pages(page));
-	list_add_tail(&page->lru, &lruvec->lists[lru]);
-}
-
-static __always_inline void del_page_from_lru_list(struct page *page,
-				struct lruvec *lruvec, enum lru_list lru)
-{
-	list_del(&page->lru);
-	update_lru_size(lruvec, lru, page_zonenum(page), -thp_nr_pages(page));
-}
-
 /**
  * page_lru_base_type - which LRU list type should a page be on?
  * @page: the page to test
@@ -125,4 +104,25 @@ static __always_inline enum lru_list pag
 	}
 	return lru;
 }
+
+static __always_inline void add_page_to_lru_list(struct page *page,
+				struct lruvec *lruvec, enum lru_list lru)
+{
+	update_lru_size(lruvec, lru, page_zonenum(page), thp_nr_pages(page));
+	list_add(&page->lru, &lruvec->lists[lru]);
+}
+
+static __always_inline void add_page_to_lru_list_tail(struct page *page,
+				struct lruvec *lruvec, enum lru_list lru)
+{
+	update_lru_size(lruvec, lru, page_zonenum(page), thp_nr_pages(page));
+	list_add_tail(&page->lru, &lruvec->lists[lru]);
+}
+
+static __always_inline void del_page_from_lru_list(struct page *page,
+				struct lruvec *lruvec, enum lru_list lru)
+{
+	list_del(&page->lru);
+	update_lru_size(lruvec, lru, page_zonenum(page), -thp_nr_pages(page));
+}
 #endif
_

Patches currently in -mm which might be from yuzhao@google.com are


