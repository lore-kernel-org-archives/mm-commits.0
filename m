Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A6A4E94130
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233859AbjJFVrn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233860AbjJFVra (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:47:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F23106
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:47:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B11C433C7;
        Fri,  6 Oct 2023 21:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628846;
        bh=Snqsp6FTrv1z+q208khmWzmgqIiFLAY5zZIi+kiG+Ds=;
        h=Date:To:From:Subject:From;
        b=EnPE5XzvJjMwqjJmOEhgQj7xvaDS05pNyrRC7NkzsJfTiE0BzpKEIy6mw/crSpNLP
         yThvrjzK7fA+BPom6gtp3q3TWdAbwfTQKppi1nUkkyHCpV+TOppuO52d4iKqjsV/qo
         Gxyv/gSkQkSoU8AiJQsnLff5J8wf6L+7wMCmxig0=
Date:   Fri, 06 Oct 2023 14:47:23 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        wangkefeng.wang@huawei.com, tj@kernel.org,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-remove-unused-do_memsw_account-in-memcg1_stat_format.patch removed from -mm tree
Message-Id: <20231006214725.A3B11C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg: remove unused do_memsw_account in memcg1_stat_format
has been removed from the -mm tree.  Its filename was
     memcg-remove-unused-do_memsw_account-in-memcg1_stat_format.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: memcg: remove unused do_memsw_account in memcg1_stat_format
Date: Fri, 15 Sep 2023 18:58:45 +0800

Since commit b25806dcd3d5("mm: memcontrol: deprecate swapaccounting=0
mode") do_memsw_account() is synonymous with
!cgroup_subsys_on_dfl(memory_cgrp_subsys), It always equals true in
memcg1_stat_format().  Remove the unused code.

Link: https://lkml.kernel.org/r/20230915105845.3199656-3-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Suggested-by: Michal Koutný <mkoutny@suse.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Tejun heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/mm/memcontrol.c~memcg-remove-unused-do_memsw_account-in-memcg1_stat_format
+++ a/mm/memcontrol.c
@@ -4113,8 +4113,6 @@ static void memcg1_stat_format(struct me
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
 
-		if (memcg1_stats[i] == MEMCG_SWAP && !do_memsw_account())
-			continue;
 		nr = memcg_page_state_local(memcg, memcg1_stats[i]);
 		seq_buf_printf(s, "%s %lu\n", memcg1_stat_names[i],
 			   nr * memcg_page_state_unit(memcg1_stats[i]));
@@ -4137,15 +4135,12 @@ static void memcg1_stat_format(struct me
 	}
 	seq_buf_printf(s, "hierarchical_memory_limit %llu\n",
 		       (u64)memory * PAGE_SIZE);
-	if (do_memsw_account())
-		seq_buf_printf(s, "hierarchical_memsw_limit %llu\n",
-			       (u64)memsw * PAGE_SIZE);
+	seq_buf_printf(s, "hierarchical_memsw_limit %llu\n",
+		       (u64)memsw * PAGE_SIZE);
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
 
-		if (memcg1_stats[i] == MEMCG_SWAP && !do_memsw_account())
-			continue;
 		nr = memcg_page_state(memcg, memcg1_stats[i]);
 		seq_buf_printf(s, "total_%s %llu\n", memcg1_stat_names[i],
 			   (u64)nr * memcg_page_state_unit(memcg1_stats[i]));
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space.patch
mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space-v6.patch

