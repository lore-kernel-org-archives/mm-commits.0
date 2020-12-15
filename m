Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC5A5C2BB40
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:07:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DAC3224F4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:07:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgLODHV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:07:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:35182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbgLODHQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:07:16 -0500
Date:   Mon, 14 Dec 2020 19:06:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001596;
        bh=p2/fELHAYg6nST8U+7iCRiH6jBhYCBTMR7xj6/Kw7GA=;
        h=From:To:Subject:In-Reply-To:From;
        b=nWZGSob23pbztHHZEU9O1lSwpKbZOsBe+p4d0waDRuUUqHzivrtzajW3F5oY2lJ2a
         ZWexw1iXp3M9zsVTPpcqoJlY+CZwdWSMaVTf/RJfO8egCYSJfxnM880q/of2YTvsZe
         ECV6N/W0FQG/Fe1Aa+BdxcDVfNNCPOQYFaDZbfv8=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name,
        christian.brauner@ubuntu.com, guro@fb.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, laoar.shao@gmail.com, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com
Subject:  [patch 059/200] mm: memcg/slab: fix use after free in
 obj_cgroup_charge
Message-ID: <20201215030635.lLOIalSP1%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcg/slab: fix use after free in obj_cgroup_charge

The rcu_read_lock/unlock only can guarantee that the memcg will not be
freed, but it cannot guarantee the success of css_get to memcg.

If the whole process of a cgroup offlining is completed between reading a
objcg->memcg pointer and bumping the css reference on another CPU, and
there are exactly 0 external references to this memory cgroup (how we get
to the obj_cgroup_charge() then?), css_get() can change the ref counter
from 0 back to 1.

Link: https://lkml.kernel.org/r/20201028035013.99711-2-songmuchun@bytedance.com
Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-slab-fix-use-after-free-in-obj_cgroup_charge
+++ a/mm/memcontrol.c
@@ -3235,8 +3235,10 @@ int obj_cgroup_charge(struct obj_cgroup
 	 * independently later.
 	 */
 	rcu_read_lock();
+retry:
 	memcg = obj_cgroup_memcg(objcg);
-	css_get(&memcg->css);
+	if (unlikely(!css_tryget(&memcg->css)))
+		goto retry;
 	rcu_read_unlock();
 
 	nr_pages = size >> PAGE_SHIFT;
_
