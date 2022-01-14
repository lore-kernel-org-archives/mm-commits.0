Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3276C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbiANWJR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:09:17 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:38092 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiANWJQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:09:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2F495CE2498
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D3DC36AED;
        Fri, 14 Jan 2022 22:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198153;
        bh=MVKBiCbgfbFPrjIK9rQgMu8XnzgLeX+0UI6C6gCEpV4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zqaHT1uZ9C8x53yDPeXscKhH5zQ2OE2SmRVg6bEtfoKCUdPCHK5Hz0NHaViKlyGH9
         tK0TVAS1UfM4S1ddW00kBjajY+Nk7xN94POjsV0y51N/mEhkiOOtc/Uij7HeobQJSq
         ryrJ/VdOL/CW6a8DLtOK7qAHest7juc1AI9LQ0yU=
Date:   Fri, 14 Jan 2022 14:09:12 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, dennis@kernel.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com, tj@kernel.org,
        torvalds@linux-foundation.org, zhengqi.arch@bytedance.com
Subject:  [patch 114/146] mm: memcg/percpu: account extra objcg
 space to memory cgroups
Message-ID: <20220114220912.5x99uuvei%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
