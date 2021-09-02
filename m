Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0CCFC433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC5E5603E9
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347587AbhIBV5B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:57:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347572AbhIBV4z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:56:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E10D610A1;
        Thu,  2 Sep 2021 21:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619756;
        bh=lkfI4s6iZ3Y2BG4fNzcJl+33PnS5p0mtvfcdmAqs/nE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BozePRq+f+yWc7uK4ZmQsytuWbnzALeXiAF5iagm0gsAxzfP8lpiNLhuPecPBIIGn
         QuRPQCTfVHyx8sPDKLJFshhfg/3TaFQk02svKPyu3mjeMiWzac3VGfISMZ3IPLLncj
         7EigPpOS1aMMIlcqHzY6R+uwWtOQJE0JnfD2hgJs=
Date:   Thu, 02 Sep 2021 14:55:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexs@kernel.org, guro@fb.com,
        linmiaohe@huawei.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        shakeelb@google.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com,
        willy@infradead.org
Subject:  [patch 111/212] mm, memcg: remove unused functions
Message-ID: <20210902215556.81Qfz_nkh%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, memcg: remove unused functions

Since commit 2d146aa3aa84 ("mm: memcontrol: switch to rstat"), last user
of memcg_stat_item_in_bytes() is gone.  And since commit fa40d1ee9f15
("mm: vmscan: memcontrol: remove mem_cgroup_select_victim_node()"), only
the declaration of mem_cgroup_select_victim_node() is remained here. 
Remove them.

Link: https://lkml.kernel.org/r/20210807082835.61281-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   12 ------------
 1 file changed, 12 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-remove-unused-functions
+++ a/include/linux/memcontrol.h
@@ -593,13 +593,6 @@ static inline struct obj_cgroup **page_o
 }
 #endif
 
-static __always_inline bool memcg_stat_item_in_bytes(int idx)
-{
-	if (idx == MEMCG_PERCPU_B)
-		return true;
-	return vmstat_item_in_bytes(idx);
-}
-
 static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
 {
 	return (memcg == root_mem_cgroup);
@@ -904,11 +897,6 @@ static inline bool mem_cgroup_online(str
 	return !!(memcg->css.flags & CSS_ONLINE);
 }
 
-/*
- * For memory reclaim.
- */
-int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
-
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 		int zid, int nr_pages);
 
_
