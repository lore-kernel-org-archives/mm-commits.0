Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB2FEC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B542161263
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbhKEUkZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:40:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233038AbhKEUkY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:40:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D72C611C0;
        Fri,  5 Nov 2021 20:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144664;
        bh=3jo0PsGxHwQQciMl73+65yoyer6IErrgt1+PUuPanXg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Pg/8w3lKzjuYEvP3xmBWqDov+e2Bs+yYKq9uzJ7K34hcOMSE0r4HDUuCsWy0vsdPT
         Y+kiX7vWM0ZmWhlQ48BtWT1iw2R9yv/LrOnBMWKL7p503b0W5w0w31JUufnnHK3SNG
         aNk/PlfmNwiNQfS8tUAv6wQ6MgdIFWZng3otaDN0=
Date:   Fri, 05 Nov 2021 13:37:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        vvs@virtuozzo.com
Subject:  [patch 059/262] memcg, kmem: further deprecate
 kmem.limit_in_bytes
Message-ID: <20211105203744.FeAxCRHkX%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>
Subject: memcg, kmem: further deprecate kmem.limit_in_bytes

The deprecation process of kmem.limit_in_bytes started with the commit
0158115f702 ("memcg, kmem: deprecate kmem.limit_in_bytes") which also
explains in detail the motivation behind the deprecation.  To summarize,
it is the unexpected behavior on hitting the kmem limit.  This patch moves
the deprecation process to the next stage by disallowing to set the kmem
limit.  In future we might just remove the kmem.limit_in_bytes file
completely.

[akpm@linux-foundation.org: s/ENOTSUPP/EOPNOTSUPP/]
[arnd@arndb.de: mark cancel_charge() inline]
  Link: https://lkml.kernel.org/r/20211022070542.679839-1-arnd@kernel.org
Link: https://lkml.kernel.org/r/20211019153408.2916808-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst |   11 ----
 mm/memcontrol.c                                |   39 +--------------
 2 files changed, 7 insertions(+), 43 deletions(-)

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
@@ -2771,8 +2771,7 @@ static inline int try_charge(struct mem_
 	return try_charge_memcg(memcg, gfp_mask, nr_pages);
 }
 
-#if defined(CONFIG_MEMCG_KMEM) || defined(CONFIG_MMU)
-static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
+static inline void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	if (mem_cgroup_is_root(memcg))
 		return;
@@ -2781,7 +2780,6 @@ static void cancel_charge(struct mem_cgr
 	if (do_memsw_account())
 		page_counter_uncharge(&memcg->memsw, nr_pages);
 }
-#endif
 
 static void commit_charge(struct page *page, struct mem_cgroup *memcg)
 {
@@ -3000,7 +2998,6 @@ static void obj_cgroup_uncharge_pages(st
 static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
 				   unsigned int nr_pages)
 {
-	struct page_counter *counter;
 	struct mem_cgroup *memcg;
 	int ret;
 
@@ -3010,21 +3007,8 @@ static int obj_cgroup_charge_pages(struc
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
 
@@ -3714,17 +3698,6 @@ static void memcg_offline_kmem(struct me
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
@@ -3790,10 +3763,8 @@ static ssize_t mem_cgroup_write(struct k
 			ret = mem_cgroup_resize_max(memcg, nr_pages, true);
 			break;
 		case _KMEM:
-			pr_warn_once("kmem.limit_in_bytes is deprecated and will be removed. "
-				     "Please report your usecase to linux-mm@kvack.org if you "
-				     "depend on this functionality.\n");
-			ret = memcg_update_kmem_max(memcg, nr_pages);
+			/* kmem.limit_in_bytes is deprecated. */
+			ret = -EOPNOTSUPP;
 			break;
 		case _TCP:
 			ret = memcg_update_tcp_max(memcg, nr_pages);
_
