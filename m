Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 376B2C433ED
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 00:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EF08613D2
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 00:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhEJAyD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 20:54:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229941AbhEJAyD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 May 2021 20:54:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDCEF60FD8;
        Mon, 10 May 2021 00:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620607978;
        bh=jRgFMkF/SqVNtfx122n5LDWz2SSMAVe/GFoHn9S9fTA=;
        h=Date:From:To:Subject:From;
        b=b7D+KUApLikvYM/49qaiKNFqCCN3pDCkcylRAwGvH5qjHCnTULjcmiXj7FyeYeF66
         zv3ZhdZVTcRUxpL5ZDJd9takXc5q6eIJt0kZeAkPMlPm8eCRLLcOQp4B9twVx9s03F
         n9GXoAY6/K4mfgVLu5KHhmuW4I/1IQjZ8iHX7BRc=
Date:   Sun, 09 May 2021 17:52:57 -0700
From:   akpm@linux-foundation.org
To:     duanxiongchun@bytedance.com, guro@fb.com, hannes@cmpxchg.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com
Subject:  + mm-memcontrol-fix-root_mem_cgroup-charging.patch
 tentatively added to -mm tree
Message-ID: <20210510005257.d0VcCngV1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix root_mem_cgroup charging
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-root_mem_cgroup-charging.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-root_mem_cgroup-charging.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-root_mem_cgroup-charging.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: fix root_mem_cgroup charging

The below scenario can cause the page counters of the root_mem_cgroup to
be out of balance.

CPU0:                                   CPU1:

objcg = get_obj_cgroup_from_current()
obj_cgroup_charge_pages(objcg)
                                        memcg_reparent_objcgs()
                                            // reparent to root_mem_cgroup
                                            WRITE_ONCE(iter->memcg, parent)
    // memcg == root_mem_cgroup
    memcg = get_mem_cgroup_from_objcg(objcg)
    // do not charge to the root_mem_cgroup
    try_charge(memcg)

obj_cgroup_uncharge_pages(objcg)
    memcg = get_mem_cgroup_from_objcg(objcg)
    // uncharge from the root_mem_cgroup
    refill_stock(memcg)
        drain_stock(memcg)
            page_counter_uncharge(&memcg->memory)

get_obj_cgroup_from_current() never returns a root_mem_cgroup's objcg, so
we never explicitly charge the root_mem_cgroup.  And it's not going to
change.  It's all about a race when we got an obj_cgroup pointing at some
non-root memcg, but before we were able to charge it, the cgroup was gone,
objcg was reparented to the root and so we're skipping the charging.  Then
we store the objcg pointer and later use to uncharge the root_mem_cgroup.

This can cause the page counter to be less than the actual value. 
Although we do not display the value (mem_cgroup_usage) so there shouldn't
be any actual problem, but there is a WARN_ON_ONCE in the
page_counter_cancel().  Who knows if it will trigger?  So it is better to
fix it.

Link: https://lkml.kernel.org/r/20210425075410.19255-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-root_mem_cgroup-charging
+++ a/mm/memcontrol.c
@@ -2567,8 +2567,8 @@ out:
 	css_put(&memcg->css);
 }
 
-static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
-		      unsigned int nr_pages)
+static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
+			unsigned int nr_pages)
 {
 	unsigned int batch = max(MEMCG_CHARGE_BATCH, nr_pages);
 	int nr_retries = MAX_RECLAIM_RETRIES;
@@ -2580,8 +2580,6 @@ static int try_charge(struct mem_cgroup
 	bool drained = false;
 	unsigned long pflags;
 
-	if (mem_cgroup_is_root(memcg))
-		return 0;
 retry:
 	if (consume_stock(memcg, nr_pages))
 		return 0;
@@ -2761,6 +2759,15 @@ done_restock:
 	return 0;
 }
 
+static inline int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
+			     unsigned int nr_pages)
+{
+	if (mem_cgroup_is_root(memcg))
+		return 0;
+
+	return try_charge_memcg(memcg, gfp_mask, nr_pages);
+}
+
 #if defined(CONFIG_MEMCG_KMEM) || defined(CONFIG_MMU)
 static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
@@ -2996,7 +3003,7 @@ static int obj_cgroup_charge_pages(struc
 
 	memcg = get_mem_cgroup_from_objcg(objcg);
 
-	ret = try_charge(memcg, gfp, nr_pages);
+	ret = try_charge_memcg(memcg, gfp, nr_pages);
 	if (ret)
 		goto out;
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-fix-root_mem_cgroup-charging.patch

