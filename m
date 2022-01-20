Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B17C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347855AbiATV15 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:27:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38136 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347854AbiATV14 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:27:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8181760A6C
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA78C340E0;
        Thu, 20 Jan 2022 21:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714075;
        bh=lNGv4VVhAJOWgM2866cJrRwU2b/rkTj4tycz238ATxA=;
        h=Date:From:To:Subject:From;
        b=2oMzNpzE1Hf8loTeHcR+B5EKkO9sJr71nykocVuJM7aC/Flulq8kMHtnl9n4iqesF
         5tU2mc/9YS/sOO2Tu7lrykJlY4mqL/6trsrnGapJhzRyNG/AsSDU3dup2WvAhV3VEk
         Y5OlY8ggv62BNjMojPgxSMo3SqFieYgxCZsGRL2o=
Date:   Thu, 20 Jan 2022 13:27:55 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, dennis@kernel.org, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com, tj@kernel.org, zhengqi.arch@bytedance.com
Subject:  [merged]
 mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups.patch removed
 from -mm tree
Message-ID: <20220120212755.a_N-WExVo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg/percpu: account extra objcg space to memory cgroups
has been removed from the -mm tree.  Its filename was
     mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: memcg/percpu: account extra objcg space to memory cgroups

Similar to slab memory allocator, for each accounted percpu object there
is an extra space which is used to store obj_cgroup membership.  Charge it
too.

[akpm@linux-foundation.org: fix layout]
Link: https://lkml.kernel.org/r/20211126040606.97836-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu-internal.h |   18 ++++++++++++++++++
 mm/percpu.c          |   10 +++++-----
 2 files changed, 23 insertions(+), 5 deletions(-)

--- a/mm/percpu.c~mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups
+++ a/mm/percpu.c
@@ -1635,7 +1635,7 @@ static bool pcpu_memcg_pre_alloc_hook(si
 	if (!objcg)
 		return true;
 
-	if (obj_cgroup_charge(objcg, gfp, size * num_possible_cpus())) {
+	if (obj_cgroup_charge(objcg, gfp, pcpu_obj_full_size(size))) {
 		obj_cgroup_put(objcg);
 		return false;
 	}
@@ -1656,10 +1656,10 @@ static void pcpu_memcg_post_alloc_hook(s
 
 		rcu_read_lock();
 		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
-				size * num_possible_cpus());
+				pcpu_obj_full_size(size));
 		rcu_read_unlock();
 	} else {
-		obj_cgroup_uncharge(objcg, size * num_possible_cpus());
+		obj_cgroup_uncharge(objcg, pcpu_obj_full_size(size));
 		obj_cgroup_put(objcg);
 	}
 }
@@ -1676,11 +1676,11 @@ static void pcpu_memcg_free_hook(struct
 		return;
 	chunk->obj_cgroups[off >> PCPU_MIN_ALLOC_SHIFT] = NULL;
 
-	obj_cgroup_uncharge(objcg, size * num_possible_cpus());
+	obj_cgroup_uncharge(objcg, pcpu_obj_full_size(size));
 
 	rcu_read_lock();
 	mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
-			-(size * num_possible_cpus()));
+			-pcpu_obj_full_size(size));
 	rcu_read_unlock();
 
 	obj_cgroup_put(objcg);
--- a/mm/percpu-internal.h~mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups
+++ a/mm/percpu-internal.h
@@ -113,6 +113,24 @@ static inline int pcpu_chunk_map_bits(st
 	return pcpu_nr_pages_to_map_bits(chunk->nr_pages);
 }
 
+#ifdef CONFIG_MEMCG_KMEM
+/**
+ * pcpu_obj_full_size - helper to calculate size of each accounted object
+ * @size: size of area to allocate in bytes
+ *
+ * For each accounted object there is an extra space which is used to store
+ * obj_cgroup membership. Charge it too.
+ */
+static inline size_t pcpu_obj_full_size(size_t size)
+{
+	size_t extra_size;
+
+	extra_size = size / PCPU_MIN_ALLOC_SIZE * sizeof(struct obj_cgroup *);
+
+	return size * num_possible_cpus() + extra_size;
+}
+#endif /* CONFIG_MEMCG_KMEM */
+
 #ifdef CONFIG_PERCPU_STATS
 
 #include <linux/spinlock.h>
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


