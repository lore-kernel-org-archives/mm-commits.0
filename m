Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FC48C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 19:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D4FA61154
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 19:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbhJSTv4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Oct 2021 15:51:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230147AbhJSTv4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Oct 2021 15:51:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3DE5610CC;
        Tue, 19 Oct 2021 19:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634672983;
        bh=I43GIxoJtwRKKPK+IoUDXyfUk+BsZA/G6cNxw4ic9FY=;
        h=Date:From:To:Subject:From;
        b=z9qntjzISsh6yHJrmSFhohqxD3ApiTKjPl80wuRlSTeddtNehzDv7awFMpDqz4qSz
         ZMZxtATDa25tdsvlc8oMYVK+DtTGAbIYeoK1uDlyhSzmYNxdwAEzzPBCedjGZd7iu3
         wmXa1Mj8zDze5K/Q0x/CjyOSnV+kJHl1htVY6vPg=
Date:   Tue, 19 Oct 2021 12:49:42 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, vvs@virtuozzo.com
Subject:  + memcg-kmem-further-deprecate-kmemlimit_in_bytes.patch
 added to -mm tree
Message-ID: <20211019194942.TDJuHqPY9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg, kmem: further deprecate kmem.limit_in_bytes
has been added to the -mm tree.  Its filename is
     memcg-kmem-further-deprecate-kmemlimit_in_bytes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-kmem-further-deprecate-kmemlimit_in_bytes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-kmem-further-deprecate-kmemlimit_in_bytes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: memcg, kmem: further deprecate kmem.limit_in_bytes

The deprecation process of kmem.limit_in_bytes started with the commit
0158115f702 ("memcg, kmem: deprecate kmem.limit_in_bytes") which also
explains in detail the motivation behind the deprecation.  To summarize,
it is the unexpected behavior on hitting the kmem limit.  This patch moves
the deprecation process to the next stage by disallowing to set the kmem
limit.  In future we might just remove the kmem.limit_in_bytes file
completely.

Link: https://lkml.kernel.org/r/20211019153408.2916808-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst |   11 ----
 mm/memcontrol.c                                |   35 +--------------
 2 files changed, 6 insertions(+), 40 deletions(-)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst~memcg-kmem-further-deprecate-kmemlimit_in_bytes
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -87,10 +87,8 @@ Brief summary of control files.
  memory.oom_control		     set/show oom controls.
  memory.numa_stat		     show the number of memory usage per numa
 				     node
- memory.kmem.limit_in_bytes          set/show hard limit for kernel memory
-                                     This knob is deprecated and shouldn't be
-                                     used. It is planned that this be removed in
-                                     the foreseeable future.
+ memory.kmem.limit_in_bytes          This knob is deprecated and writing to
+                                     it will return -ENOTSUPP.
  memory.kmem.usage_in_bytes          show current kernel memory allocation
  memory.kmem.failcnt                 show the number of kernel memory usage
 				     hits limits
@@ -518,11 +516,6 @@ will be charged as a new owner of it.
   charged file caches. Some out-of-use page caches may keep charged until
   memory pressure happens. If you want to avoid that, force_empty will be useful.
 
-  Also, note that when memory.kmem.limit_in_bytes is set the charges due to
-  kernel pages will still be seen. This is not considered a failure and the
-  write will still return success. In this case, it is expected that
-  memory.kmem.usage_in_bytes == memory.usage_in_bytes.
-
 5.2 stat file
 -------------
 
--- a/mm/memcontrol.c~memcg-kmem-further-deprecate-kmemlimit_in_bytes
+++ a/mm/memcontrol.c
@@ -3000,7 +3000,6 @@ static void obj_cgroup_uncharge_pages(st
 static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
 				   unsigned int nr_pages)
 {
-	struct page_counter *counter;
 	struct mem_cgroup *memcg;
 	int ret;
 
@@ -3010,21 +3009,8 @@ static int obj_cgroup_charge_pages(struc
 	if (ret)
 		goto out;
 
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
-	    !page_counter_try_charge(&memcg->kmem, nr_pages, &counter)) {
-
-		/*
-		 * Enforce __GFP_NOFAIL allocation because callers are not
-		 * prepared to see failures and likely do not have any failure
-		 * handling code.
-		 */
-		if (gfp & __GFP_NOFAIL) {
-			page_counter_charge(&memcg->kmem, nr_pages);
-			goto out;
-		}
-		cancel_charge(memcg, nr_pages);
-		ret = -ENOMEM;
-	}
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		page_counter_charge(&memcg->kmem, nr_pages);
 out:
 	css_put(&memcg->css);
 
@@ -3714,17 +3700,6 @@ static void memcg_offline_kmem(struct me
 }
 #endif /* CONFIG_MEMCG_KMEM */
 
-static int memcg_update_kmem_max(struct mem_cgroup *memcg,
-				 unsigned long max)
-{
-	int ret;
-
-	mutex_lock(&memcg_max_mutex);
-	ret = page_counter_set_max(&memcg->kmem, max);
-	mutex_unlock(&memcg_max_mutex);
-	return ret;
-}
-
 static int memcg_update_tcp_max(struct mem_cgroup *memcg, unsigned long max)
 {
 	int ret;
@@ -3790,10 +3765,8 @@ static ssize_t mem_cgroup_write(struct k
 			ret = mem_cgroup_resize_max(memcg, nr_pages, true);
 			break;
 		case _KMEM:
-			pr_warn_once("kmem.limit_in_bytes is deprecated and will be removed. "
-				     "Please report your usecase to linux-mm@kvack.org if you "
-				     "depend on this functionality.\n");
-			ret = memcg_update_kmem_max(memcg, nr_pages);
+			/* kmem.limit_in_bytes is deprecated. */
+			ret = -ENOTSUPP;
 			break;
 		case _TCP:
 			ret = memcg_update_tcp_max(memcg, nr_pages);
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-page_alloc-skip-bulk-allocator-for-__gfp_account.patch
memcg-flush-stats-only-if-updated.patch
memcg-unify-memcg-stat-flushing.patch
memcg-kmem-further-deprecate-kmemlimit_in_bytes.patch

