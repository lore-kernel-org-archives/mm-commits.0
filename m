Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33945C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:09:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E68EB64F20
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235242AbhBXUJu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:09:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:32926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235243AbhBXUJW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:09:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C793B64F0C;
        Wed, 24 Feb 2021 20:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197321;
        bh=B3j6aQ5k4nwbd/NDC8Jy9OtgrbJbOTgeQPo39FtirZE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Azm8Rfk1XsdfrdYh6f8kz02UHqm5Q8mULS5jXGVsMZDFioDh4Q3dddNmfA1Pg0n4e
         QhFzIIXhX0ZBXuorjyy5FVxb6+qa+eywBFiOFbHpL11r+bfgVF5DJy8JXajd4lKfmU
         nuoO33UaQ0SF60ccjju5BHH4tUfEk8o+bXczD3wM=
Date:   Wed, 24 Feb 2021 12:08:40 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com, guro@fb.com,
        hannes@cmpxchg.org, hughd@google.com, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        vdavydov.dev@gmail.com, willy@infradead.org, yuzhao@google.com
Subject:  [patch 143/173] include/linux/mm_inline.h: fold
 __update_lru_size() into its sole caller
Message-ID: <20210224200840.g4YLXIUDy%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yu Zhao <yuzhao@google.com>
Subject: include/linux/mm_inline.h: fold __update_lru_size() into its sole caller

All other references to the function were removed after commit
a892cb6b977f ("mm/vmscan.c: use update_lru_size() in update_lru_sizes()").

Link: https://lore.kernel.org/linux-mm/20201207220949.830352-10-yuzhao@google.com/
Link: https://lkml.kernel.org/r/20210122220600.906146-10-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/include/linux/mm_inline.h~mm-fold-__update_lru_size-into-its-sole-caller
+++ a/include/linux/mm_inline.h
@@ -24,7 +24,7 @@ static inline int page_is_file_lru(struc
 	return !PageSwapBacked(page);
 }
 
-static __always_inline void __update_lru_size(struct lruvec *lruvec,
+static __always_inline void update_lru_size(struct lruvec *lruvec,
 				enum lru_list lru, enum zone_type zid,
 				int nr_pages)
 {
@@ -33,13 +33,6 @@ static __always_inline void __update_lru
 	__mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
 	__mod_zone_page_state(&pgdat->node_zones[zid],
 				NR_ZONE_LRU_BASE + lru, nr_pages);
-}
-
-static __always_inline void update_lru_size(struct lruvec *lruvec,
-				enum lru_list lru, enum zone_type zid,
-				int nr_pages)
-{
-	__update_lru_size(lruvec, lru, zid, nr_pages);
 #ifdef CONFIG_MEMCG
 	mem_cgroup_update_lru_size(lruvec, lru, zid, nr_pages);
 #endif
_
