Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5F53C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A13866112F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235866AbhICU7I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:59:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349933AbhICU7H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:59:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7105A6112E;
        Fri,  3 Sep 2021 20:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702686;
        bh=obuRskh7hlDc+Fl3yvXI++PTn8iz594hlzbQ6wxvOF0=;
        h=Date:From:To:Subject:From;
        b=shGs29VQww8DIDFch9TMhb+ggoukIUwr3ZGVcddRELYxg5GbWdArwHcBwDDsgt8Ti
         bvmKkkNWSnd2qBQjauT40SL4stPvc4ptl2+hzJQLm+dKLG/VzaiwUzV+uc5uOIzkDX
         uAVpk6bFwi2g5egJBjs1qe9DRSlV/l2O7AM7vxyo=
Date:   Fri, 03 Sep 2021 13:58:06 -0700
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, guro@fb.com, linmiaohe@huawei.com,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com,
        willy@infradead.org
Subject:  [merged] mm-memcg-remove-unused-functions.patch removed
 from -mm tree
Message-ID: <20210903205806.5h1z7n6xR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: remove unused functions
has been removed from the -mm tree.  Its filename was
     mm-memcg-remove-unused-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

