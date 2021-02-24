Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4329AC433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:09:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00E6A64F26
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235319AbhBXUJm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:09:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:60690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235382AbhBXUIz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:08:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2619E64F08;
        Wed, 24 Feb 2021 20:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197294;
        bh=Ze2kz5wkXUpGaQd+JexYlvhuZCedOXyxG0IKush6dYY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XvsQK8316P2PFdaAR7obv0j5PqYFXjw0knyLMZah5IovFgkWvrLMpdYoI3iD2p3Su
         iDK89Cu07UsMm4QxbfU4YXiDckO1UpzYSduVy/8K3MIcVuv6DM0+jgPeATCQ5YVZVr
         5QIcHojw+M0PpwFCH4UcXTyA4K78apqS53Sj3ts0=
Date:   Wed, 24 Feb 2021 12:08:13 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com, guro@fb.com,
        hannes@cmpxchg.org, hughd@google.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        vdavydov.dev@gmail.com, willy@infradead.org, yuzhao@google.com
Subject:  [patch 136/173] include/linux/mm_inline.h: shuffle lru
 list addition and deletion functions
Message-ID: <20210224200813.841lGEZQx%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
