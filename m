Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA4EC2BB40
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:30:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB738224B2
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgLODHE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:07:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:34636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgLODG6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:06:58 -0500
Date:   Mon, 14 Dec 2020 19:06:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001603;
        bh=ozY+Qlr+SL9P7E1/ff7eCmgXxQqpR4J2tXFPaOQrkMc=;
        h=From:To:Subject:In-Reply-To:From;
        b=KqbmFn/FEiBO8j0G3Xda3uUsE1JowBQdL7N9Ffd/eD4UvV4k7z9GU3yFB3Nz47GBv
         BUdqx2njlHZ7KdOO80E220WKyiLY0yl28sGutZoB6y7ulBXAQlGFBpoFe4hxEZO7D3
         7rmde1Q8y//ilgsy5emYgZeSW9R5aS2r29sF6jQ0=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com
Subject:  [patch 061/200] mm/memcg: update page struct member in
 comments
Message-ID: <20201215030642.xBAnKq_Mb%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/memcg: update page struct member in comments

The page->mem_cgroup member is replaced by memcg_data, and add a helper
page_memcg() for it.  Need to update comments to avoid confusing.

Link: https://lkml.kernel.org/r/1491c150-1cc0-6062-08ea-9c891548a3bc@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-update-page-struct-member-in-comments
+++ a/mm/memcontrol.c
@@ -1324,7 +1324,7 @@ int mem_cgroup_scan_tasks(struct mem_cgr
  * @page: the page
  * @pgdat: pgdat of the page
  *
- * This function relies on page->mem_cgroup being stable - see the
+ * This function relies on page's memcg being stable - see the
  * access rules in commit_charge().
  */
 struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgdat)
@@ -2879,7 +2879,7 @@ static void commit_charge(struct page *p
 {
 	VM_BUG_ON_PAGE(page->mem_cgroup, page);
 	/*
-	 * Any of the following ensures page->mem_cgroup stability:
+	 * Any of the following ensures page's memcg stability:
 	 *
 	 * - the page lock
 	 * - LRU isolation
_
