Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3EE6C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:05:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiANWFq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiANWFp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:05:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB96FC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:05:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 698F5B8260F
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2ED4C36AE9;
        Fri, 14 Jan 2022 22:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197943;
        bh=JexHpmoYiIAWantUDQDX6rbtfMsRQ+uyVXiLRCHcRLg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PE5EYzOe0G1G5WjElw6bvndsE/3W2jz6AAxalB/p/zNHtS0y1A7vtn0TRfPsDRxLt
         0FFkgAKaZ0xwW4fRK31ryrcPnMbD+/72pyf+fzK4gyFOt9xIivF5t10t0zVasWdKju
         V3RgsxWqQzf2c2RtE+ab5wNoO9yrZNnpH2pnchXA=
Date:   Fri, 14 Jan 2022 14:05:42 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com, wangweiyang2@huawei.com
Subject:  [patch 052/146] mm/memcg: use struct_size() helper in
 kzalloc()
Message-ID: <20220114220542.X_Xm3i4Ga%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wang Weiyang <wangweiyang2@huawei.com>
Subject: mm/memcg: use struct_size() helper in kzalloc()

Make use of the struct_size() helper instead of an open-coded version, in
order to avoid any potential type mistakes or integer overflows that, in
the worst scenario, could lead to heap overflows.

Link: https://github.com/KSPP/linux/issues/160
Link: https://lkml.kernel.org/r/20211216022024.127375-1-wangweiyang2@huawei.com
Signed-off-by: Wang Weiyang <wangweiyang2@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-use-struct_size-helper-in-kzalloc
+++ a/mm/memcontrol.c
@@ -5122,15 +5122,11 @@ static void mem_cgroup_free(struct mem_c
 static struct mem_cgroup *mem_cgroup_alloc(void)
 {
 	struct mem_cgroup *memcg;
-	unsigned int size;
 	int node;
 	int __maybe_unused i;
 	long error = -ENOMEM;
 
-	size = sizeof(struct mem_cgroup);
-	size += nr_node_ids * sizeof(struct mem_cgroup_per_node *);
-
-	memcg = kzalloc(size, GFP_KERNEL);
+	memcg = kzalloc(struct_size(memcg, nodeinfo, nr_node_ids), GFP_KERNEL);
 	if (!memcg)
 		return ERR_PTR(error);
 
_
