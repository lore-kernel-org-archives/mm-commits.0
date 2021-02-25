Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E45E8C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EC9B64F28
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234928AbhBYTfN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:35:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:41322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235072AbhBYTc7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:32:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9392D64FAB;
        Thu, 25 Feb 2021 19:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280687;
        bh=bVOUURG91TjvuD+EVIvJptDzIZx8lfT8Z/H7yoLwyOo=;
        h=Date:From:To:Subject:From;
        b=z7shkX4hz9OZq4EpV9Ab7Y+h/uPVzo65/fPOf6Omt4Y0bf/j/AODTTWPNpsMmob4U
         YaBSu2h760+H77ElDBUA6rb1/kQheAiA7M3FPM4Z2OCrjl+v+X2AOJSAdlYKCHNTWW
         DnXJO0Jfq/xlN3d35qlTE+/joq4xKFOaKyir863o=
Date:   Thu, 25 Feb 2021 11:18:06 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, guro@fb.com, hannes@cmpxchg.org,
        hughd@google.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        vbabka@suse.cz, vdavydov.dev@gmail.com, willy@infradead.org,
        yuzhao@google.com
Subject:  [merged] mm-make-lruvec_lru_size-static.patch removed
 from -mm tree
Message-ID: <20210225191806.0eUmTfh1f%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: make lruvec_lru_size() static
has been removed from the -mm tree.  Its filename was
     mm-make-lruvec_lru_size-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/vmscan.c: make lruvec_lru_size() static

All other references to the function were removed after
commit b910718a948a ("mm: vmscan: detect file thrashing at the reclaim
root").

Link: https://lore.kernel.org/linux-mm/20201207220949.830352-11-yuzhao@google.com/
Link: https://lkml.kernel.org/r/20210122220600.906146-11-yuzhao@google.com
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

 include/linux/mmzone.h |    2 --
 mm/vmscan.c            |    3 ++-
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/include/linux/mmzone.h~mm-make-lruvec_lru_size-static
+++ a/include/linux/mmzone.h
@@ -892,8 +892,6 @@ static inline struct pglist_data *lruvec
 #endif
 }
 
-extern unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone_idx);
-
 #ifdef CONFIG_HAVE_MEMORYLESS_NODES
 int local_memory_node(int node_id);
 #else
--- a/mm/vmscan.c~mm-make-lruvec_lru_size-static
+++ a/mm/vmscan.c
@@ -310,7 +310,8 @@ unsigned long zone_reclaimable_pages(str
  * @lru: lru to use
  * @zone_idx: zones to consider (use MAX_NR_ZONES for the whole LRU list)
  */
-unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone_idx)
+static unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru,
+				     int zone_idx)
 {
 	unsigned long size = 0;
 	int zid;
_

Patches currently in -mm which might be from yuzhao@google.com are


