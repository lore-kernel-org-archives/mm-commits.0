Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3DADC4320A
	for <mm-commits@archiver.kernel.org>; Fri, 13 Aug 2021 23:54:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA574610C8
	for <mm-commits@archiver.kernel.org>; Fri, 13 Aug 2021 23:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235804AbhHMXzK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Aug 2021 19:55:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235397AbhHMXzK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Aug 2021 19:55:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 150E0610FC;
        Fri, 13 Aug 2021 23:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628898882;
        bh=54r1TL585LlmFiGUPyCQ4Ab6mRQKDCBPHd9HTVWsoi4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=FFpKhJAuffTHAJnKpDIxfGa55+P+u378YWhi1+BWexP2//xpT+E+tbA/K2cNOVwOL
         pxXRHWbMHUqb6JYdp83401rE/b8ATevHPR0lj+qWHoRMh+ScYAgja+JTdax6ClHic4
         Av8oMO0dtLurU0z7pxWjk7m/BkJVyhBRPw0wPN2E=
Date:   Fri, 13 Aug 2021 16:54:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        chris@chrisdown.name, cl@linux.com, guro@fb.com,
        hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, laoar.shao@gmail.com,
        linux-mm@kvack.org, longman@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, msys.mizuma@gmail.com,
        penberg@kernel.org, richard.weiyang@gmail.com, rientjes@google.com,
        shakeelb@google.com, songmuchun@bytedance.com, tj@kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        vdavydov.dev@gmail.com, willy@infradead.org,
        zhengjun.xing@linux.intel.com
Subject:  [patch 6/7] mm/memcg: fix incorrect flushing of lruvec
 data in obj_stock
Message-ID: <20210813235441.2QVRIvRYV%akpm@linux-foundation.org>
In-Reply-To: <20210813165350.dc9afa56d27eadbd8ce629c0@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Waiman Long <longman@redhat.com>
Subject: mm/memcg: fix incorrect flushing of lruvec data in obj_stock

When mod_objcg_state() is called with a pgdat that is different from that
in the obj_stock, the old lruvec data cached in obj_stock are flushed out.
Unfortunately, they were flushed to the new pgdat and so the data go to
the wrong node.  This will screw up the slab data reported in
/sys/devices/system/node/node*/meminfo.

Fix that by flushing the data to the cached pgdat instead.

Link: https://lkml.kernel.org/r/20210802143834.30578-1-longman@redhat.com
Fixes: 68ac5b3c8db2 ("mm/memcg: cache vmstat data in percpu memcg_stock_pcp")
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-fix-incorrect-flushing-of-lruvec-data-in-obj_stock
+++ a/mm/memcontrol.c
@@ -3106,13 +3106,15 @@ void mod_objcg_state(struct obj_cgroup *
 		stock->cached_pgdat = pgdat;
 	} else if (stock->cached_pgdat != pgdat) {
 		/* Flush the existing cached vmstat data */
+		struct pglist_data *oldpg = stock->cached_pgdat;
+
 		if (stock->nr_slab_reclaimable_b) {
-			mod_objcg_mlstate(objcg, pgdat, NR_SLAB_RECLAIMABLE_B,
+			mod_objcg_mlstate(objcg, oldpg, NR_SLAB_RECLAIMABLE_B,
 					  stock->nr_slab_reclaimable_b);
 			stock->nr_slab_reclaimable_b = 0;
 		}
 		if (stock->nr_slab_unreclaimable_b) {
-			mod_objcg_mlstate(objcg, pgdat, NR_SLAB_UNRECLAIMABLE_B,
+			mod_objcg_mlstate(objcg, oldpg, NR_SLAB_UNRECLAIMABLE_B,
 					  stock->nr_slab_unreclaimable_b);
 			stock->nr_slab_unreclaimable_b = 0;
 		}
_
