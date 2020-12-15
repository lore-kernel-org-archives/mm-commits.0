Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CACBDC2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A40E8224D2
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725806AbgLODHy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:07:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:35364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbgLODHc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:07:32 -0500
Date:   Mon, 14 Dec 2020 19:06:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001606;
        bh=N1qrfYji3AqTzr0PUYrcXGm16N7KdNYjttS6SFfWRl4=;
        h=From:To:Subject:In-Reply-To:From;
        b=lurEK5W9qzcG//Mfo04TZ0SN4Xuzu9Axd8SfNwkL8//To0Ov/6dfxPhjvm2GqRtM3
         vLNfk+QYcdo6Jsof0Y+RSoOOndU+AC/BdH/lthmzaIX8O3FsOCT9/92hRjAvKaWp50
         rpX6O8D4CgLFQIeShpHihqZ/IBkT9NkqcxXpeqxc=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, torvalds@linux-foundation.org
Subject:  [patch 062/200] mm: memcg: fix obsolete code comments
Message-ID: <20201215030645.8_J1qVjuV%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg: fix obsolete code comments

This patch fixes/removes some obsolete comments in the code related
to the kernel memory accounting:
- kmem_cache->memcg_params.memcg_caches has been removed
  by commit 9855609bde03 ("mm: memcg/slab: use a single set of
  kmem_caches for all accounted allocations")
- memcg->kmemcg_id is not used as a gate for kmem accounting since
  commit 0b8f73e10428 ("mm: memcontrol: clean up alloc, online,
  offline, free functions")

Link: https://lkml.kernel.org/r/20201110184615.311974-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++----
 mm/memcontrol.c            |    6 ------
 2 files changed, 2 insertions(+), 10 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-fix-obsolete-code-comments
+++ a/include/linux/memcontrol.h
@@ -296,7 +296,6 @@ struct mem_cgroup {
 	int			tcpmem_pressure;
 
 #ifdef CONFIG_MEMCG_KMEM
-        /* Index in the kmem_cache->memcg_params.memcg_caches array */
 	int kmemcg_id;
 	enum memcg_kmem_state kmem_state;
 	struct obj_cgroup __rcu *objcg;
@@ -1562,9 +1561,8 @@ static inline void memcg_kmem_uncharge(s
 }
 
 /*
- * helper for accessing a memcg's index. It will be used as an index in the
- * child cache array in kmem_cache, and also to derive its name. This function
- * will return -1 when this is not a kmem-limited memcg.
+ * A helper for accessing memcg's kmem_id, used for getting
+ * corresponding LRU lists.
  */
 static inline int memcg_cache_id(struct mem_cgroup *memcg)
 {
--- a/mm/memcontrol.c~mm-memcg-fix-obsolete-code-comments
+++ a/mm/memcontrol.c
@@ -3703,12 +3703,6 @@ static int memcg_online_kmem(struct mem_
 
 	static_branch_enable(&memcg_kmem_enabled_key);
 
-	/*
-	 * A memory cgroup is considered kmem-online as soon as it gets
-	 * kmemcg_id. Setting the id after enabling static branching will
-	 * guarantee no one starts accounting before all call sites are
-	 * patched.
-	 */
 	memcg->kmemcg_id = memcg_id;
 	memcg->kmem_state = KMEM_ONLINE;
 
_
