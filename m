Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF42C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 28 Nov 2021 00:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbhK1AJn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Nov 2021 19:09:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbhK1AHn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Nov 2021 19:07:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C52EC06174A
        for <mm-commits@vger.kernel.org>; Sat, 27 Nov 2021 16:04:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF0CF60F0D
        for <mm-commits@vger.kernel.org>; Sun, 28 Nov 2021 00:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB2DC53FAD;
        Sun, 28 Nov 2021 00:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638057867;
        bh=PHY7RBhHvSSpzWrzGABZteKww+N26QfS0RzNaMcE7oA=;
        h=Date:From:To:Subject:From;
        b=f8OY3apUmrdXywj55rcTlM7n1NuVdUlZEQMuFcc4yXBs2HOBL7+ymdZNflPJZ/igP
         iLxIF0p2wsWLhXTCzLYpo1MLeIZtbMPufjx5ieMCEog7Dqd3FSD5PUPRZpTBUSccGT
         yOIJek59IUzvX32UVxl8XOrVeqZZjY/eR0gjPOWE=
Date:   Sat, 27 Nov 2021 16:04:26 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, dennis@kernel.org, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com, tj@kernel.org, zhengqi.arch@bytedance.com
Subject:  +
 mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups.patch added to
 -mm tree
Message-ID: <20211128000426.z-EdzU3AU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg/percpu: account extra objcg space to memory cgroups
has been added to the -mm tree.  Its filename is
     mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: memcg/percpu: account extra objcg space to memory cgroups

Similar to slab memory allocator, for each accounted percpu object there
is an extra space which is used to store obj_cgroup membership.  Charge it
too.

Link: https://lkml.kernel.org/r/20211126040606.97836-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu-internal.h |   17 +++++++++++++++++
 mm/percpu.c          |   10 +++++-----
 2 files changed, 22 insertions(+), 5 deletions(-)

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
@@ -113,6 +113,23 @@ static inline int pcpu_chunk_map_bits(st
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
+	size_t extra_size =
+		size / PCPU_MIN_ALLOC_SIZE * sizeof(struct obj_cgroup *);
+
+	return size * num_possible_cpus() + extra_size;
+}
+#endif /* CONFIG_MEMCG_KMEM */
+
 #ifdef CONFIG_PERCPU_STATS
 
 #include <linux/spinlock.h>
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-remove-redundant-check-about-fault_flag_allow_retry-bit.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups.patch

