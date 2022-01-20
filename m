Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD6AC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377835AbiATVZJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347775AbiATVZI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:25:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81879C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:25:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30AD7B81E68
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7547C340E0;
        Thu, 20 Jan 2022 21:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713905;
        bh=OohgaHvi0cxYUfLWisjZrZqkzJo0X8mGhouSoajNlbQ=;
        h=Date:From:To:Subject:From;
        b=Vg6XVmUbcWLNM5OLH0tTCEXzqJYz5HPkCTGzqX9f8cRUQysZl1x3Q1GSagRqsFnSQ
         cP+TZ8r4oBGgKa9YO2FdKupJCL7beZLOBfg3CO6cYTr3yHz10qZb9Br6pQF4dzkLaz
         zwIcdE4ad7zxPH+debcmy/7e1/K1JJgd/fn8RMQ4=
Date:   Thu, 20 Jan 2022 13:25:05 -0800
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com,
        wangweiyang2@huawei.com
Subject:  [merged] mm-memcg-use-struct_size-helper-in-kzalloc.patch
 removed from -mm tree
Message-ID: <20220120212505.BRiGlA7YL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: use struct_size() helper in kzalloc()
has been removed from the -mm tree.  Its filename was
     mm-memcg-use-struct_size-helper-in-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from wangweiyang2@huawei.com are


