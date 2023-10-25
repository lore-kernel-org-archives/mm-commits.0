Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D97FEC27C48
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbjJYXtA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbjJYXsb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEDF198
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88982C433C8;
        Wed, 25 Oct 2023 23:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277708;
        bh=Q1Y7ogYy2TyRk0EiuzsD3RePeC8tc+VSpWTlv8Bqeh8=;
        h=Date:To:From:Subject:From;
        b=LN3j72/PUL37ouIRmyelCz1JCKcLrmiGwqYwjECwlyzY8LPHzD75sZy7C7s0hzg9J
         KQwsrfE7Kh1/xzLRBOYu9uxoxEzwKm/oi49xYBcdHAsjLmSysgMmYuC8GeBUdr5qOE
         K1RbPHYEvUHsoO+d7PFShhMTkYC1koLh3iPiOgH0=
Date:   Wed, 25 Oct 2023 16:48:27 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shakeelb@google.com,
        rientjes@google.com, naresh.kamboju@linaro.org,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        dennis@kernel.org, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg.patch removed from -mm tree
Message-Id: <20231025234828.88982C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kmem: make memcg keep a reference to the original objcg
has been removed from the -mm tree.  Its filename was
     mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: kmem: make memcg keep a reference to the original objcg
Date: Thu, 19 Oct 2023 15:53:43 -0700

Keep a reference to the original objcg object for the entire life of a
memcg structure.

This allows to simplify the synchronization on the kernel memory
allocation paths: pinning a (live) memcg will also pin the corresponding
objcg.

The memory overhead of this change is minimal because object cgroups
usually outlive their corresponding memory cgroups even without this
change, so it's only an additional pointer per memcg.

Link: https://lkml.kernel.org/r/20231019225346.1822282-4-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    8 +++++++-
 mm/memcontrol.c            |    5 +++++
 2 files changed, 12 insertions(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg
+++ a/include/linux/memcontrol.h
@@ -289,7 +289,13 @@ struct mem_cgroup {
 
 #ifdef CONFIG_MEMCG_KMEM
 	int kmemcg_id;
-	struct obj_cgroup __rcu *objcg;
+	/*
+	 * memcg->objcg is wiped out as a part of the objcg repaprenting
+	 * process. memcg->orig_objcg preserves a pointer (and a reference)
+	 * to the original objcg until the end of live of memcg.
+	 */
+	struct obj_cgroup __rcu	*objcg;
+	struct obj_cgroup	*orig_objcg;
 	/* list of inherited objcgs, protected by objcg_lock */
 	struct list_head objcg_list;
 #endif
--- a/mm/memcontrol.c~mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg
+++ a/mm/memcontrol.c
@@ -3899,6 +3899,8 @@ static int memcg_online_kmem(struct mem_
 
 	objcg->memcg = memcg;
 	rcu_assign_pointer(memcg->objcg, objcg);
+	obj_cgroup_get(objcg);
+	memcg->orig_objcg = objcg;
 
 	static_branch_enable(&memcg_kmem_online_key);
 
@@ -5406,6 +5408,9 @@ static void __mem_cgroup_free(struct mem
 {
 	int node;
 
+	if (memcg->orig_objcg)
+		obj_cgroup_put(memcg->orig_objcg);
+
 	for_each_node(node)
 		free_mem_cgroup_per_node_info(memcg, node);
 	kfree(memcg->vmstats);
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are


