Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99568C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8152B61D04
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhF2Ckd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:40:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:32996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231348AbhF2Ckd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:40:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 800F761D06;
        Tue, 29 Jun 2021 02:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934286;
        bh=Hjr1fy7uYmD/F4jSMu35M3IOYZgcksEmBOjvnncbor4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=C5POhnZ3yvJ8nfXExRzoCH6DJhoUFfkSLheTeHApcJpREL/4Tt8MS8isWtXIh5Jjv
         xR2aoRasXZQ0CJKcg/nBMZcTmw8KmC8/4rBnx+kRNX7fIOO4EVsWetKVMNHkQf3GXI
         hMzMnIZcqM3c/g32mOfV8ffmOAId5V2vOGF5N7pU=
Date:   Mon, 28 Jun 2021 19:38:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, duanxiongchun@bytedance.com,
        guro@fb.com, hannes@cmpxchg.org, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com
Subject:  [patch 091/192] mm: memcontrol: move
 obj_cgroup_uncharge_pages() out of css_set_lock
Message-ID: <20210629023806.5Qh-u5G5E%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: move obj_cgroup_uncharge_pages() out of css_set_lock

The css_set_lock is used to guard the list of inherited objcgs.  So there
is no need to uncharge kernel memory under css_set_lock.  Just move it out
of the lock.

Link: https://lkml.kernel.org/r/20210417043538.9793-8-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-move-obj_cgroup_uncharge_pages-out-of-css_set_lock
+++ a/mm/memcontrol.c
@@ -289,9 +289,10 @@ static void obj_cgroup_release(struct pe
 	WARN_ON_ONCE(nr_bytes & (PAGE_SIZE - 1));
 	nr_pages = nr_bytes >> PAGE_SHIFT;
 
-	spin_lock_irqsave(&css_set_lock, flags);
 	if (nr_pages)
 		obj_cgroup_uncharge_pages(objcg, nr_pages);
+
+	spin_lock_irqsave(&css_set_lock, flags);
 	list_del(&objcg->list);
 	spin_unlock_irqrestore(&css_set_lock, flags);
 
_
