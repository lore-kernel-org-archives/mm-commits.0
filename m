Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 187D5C35296
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E78FE22CAE
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgLOX7x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:32844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729792AbgLOX0I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:26:08 -0500
Date:   Tue, 15 Dec 2020 15:18:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074302;
        bh=xyukLdPbA5ayF0jKGb0xP0ZX9vmzDcWIg65mZjX9hi8=;
        h=From:To:Subject:From;
        b=1cZxV+/hsCMewlpOVzBWbqm9hKEnJTaZSyItcYFgVdhp0OhXInSUsxPWmTvxCC1Qk
         GPOUWKGjMqqcuHwdUZ4GFlS2QFUgGJsdrTW2dKW5B0W8GvugDR07tjC3g971gH0+9S
         ydszCdn6KLJbGk+BhUzyfwWrL6i9z+45Q7l/YzL4=
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  [merged] mm-memcg-fix-obsolete-code-comments.patch
 removed from -mm tree
Message-ID: <20201215231822.BHZiHeJ4O%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: fix obsolete code comments
has been removed from the -mm tree.  Its filename was
     mm-memcg-fix-obsolete-code-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from guro@fb.com are

mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch
mm-slub-call-account_slab_page-after-slab-page-initialization.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-v2.patch

