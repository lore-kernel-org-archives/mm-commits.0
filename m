Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62060C4338F
	for <mm-commits@archiver.kernel.org>; Mon,  2 Aug 2021 20:39:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47DF8610FB
	for <mm-commits@archiver.kernel.org>; Mon,  2 Aug 2021 20:39:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbhHBUjk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Aug 2021 16:39:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231165AbhHBUjk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Aug 2021 16:39:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C31FC60F35;
        Mon,  2 Aug 2021 20:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627936770;
        bh=mzGksDy4itf1yKiBpyCx4o9H8h8SJp9+Ge0ZfmCG+gI=;
        h=Date:From:To:Subject:From;
        b=f9WJH/9WqVV5WPhpB5zoPZNu6GwVsxeOsW/NVWEBiBq0LhqIgl8BsuYAfU4C4ckin
         9yTLtRWvJzcJXnDlTKeup+lAoIAgfFrcRikktGg0B/j4zt5lWS3a+4PklTUvptDFjG
         1ZdpZebs/u2vDqMewkvR9zTWo2d9ElI2sTb4l6NQ=
Date:   Mon, 02 Aug 2021 13:39:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zhengjun.xing@linux.intel.com,
        willy@infradead.org, vdavydov.dev@gmail.com, vbabka@suse.cz,
        tj@kernel.org, songmuchun@bytedance.com, shakeelb@google.com,
        rientjes@google.com, richard.weiyang@gmail.com, penberg@kernel.org,
        msys.mizuma@gmail.com, mhocko@suse.com, laoar.shao@gmail.com,
        iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, guro@fb.com,
        cl@linux.com, chris@chrisdown.name, alex.shi@linux.alibaba.com,
        longman@redhat.com
Subject:  +
 mm-memcg-fix-incorrect-flushing-of-lruvec-data-in-obj_stock.patch added to
 -mm tree
Message-ID: <20210802203929.6YcjK%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: fix incorrect flushing of lruvec data in obj_stock
has been added to the -mm tree.  Its filename is
     mm-memcg-fix-incorrect-flushing-of-lruvec-data-in-obj_stock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-fix-incorrect-flushing-of-lruvec-data-in-obj_stock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-fix-incorrect-flushing-of-lruvec-data-in-obj_stock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Roman Gushchin <guro@fb.com>
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

Patches currently in -mm which might be from longman@redhat.com are

mm-memcg-fix-incorrect-flushing-of-lruvec-data-in-obj_stock.patch

