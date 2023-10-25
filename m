Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCBC2C27C46
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232112AbjJYXtA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233173AbjJYXs3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987A618A
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9A6C433CB;
        Wed, 25 Oct 2023 23:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277706;
        bh=TAQPNmHVdUCP7ZyCr7r7CSDKHdpcI/EwbnPumzsoQqY=;
        h=Date:To:From:Subject:From;
        b=vn1+CAxZUnWCGyrLcmCAVB4WKmiQQLsHgAmZwj2qUjpxxFfQGdL7Sdj45un7DsD6W
         pckXINyg0LIe8119698NNxstGGotd+0yns+kKjlf/4500wn4DvBP7Cz2LwdIpkUVfU
         d45SzQ1RkAXd7FG2D8iSpApCfIM3G4RMLDF60IIA=
Date:   Wed, 25 Oct 2023 16:48:25 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shakeelb@google.com,
        rientjes@google.com, naresh.kamboju@linaro.org,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        dennis@kernel.org, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmem-optimize-get_obj_cgroup_from_current.patch removed from -mm tree
Message-Id: <20231025234826.5D9A6C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kmem: optimize get_obj_cgroup_from_current()
has been removed from the -mm tree.  Its filename was
     mm-kmem-optimize-get_obj_cgroup_from_current.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: kmem: optimize get_obj_cgroup_from_current()
Date: Thu, 19 Oct 2023 15:53:41 -0700

Patch series "mm: improve performance of accounted kernel memory
allocations", v5.

This patchset improves the performance of accounted kernel memory
allocations by ~30% as measured by a micro-benchmark [1].  The benchmark
is very straightforward: 1M of 64 bytes-large kmalloc() allocations.

Below are results with the disabled kernel memory accounting, the original state
and with this patchset applied.

|             | Kmem disabled | Original | Patched |  Delta |
|-------------+---------------+----------+---------+--------|
| User cgroup |         29764 |    84548 |   59078 | -30.0% |
| Root cgroup |         29742 |    48342 |   31501 | -34.8% |

As we can see, the patchset removes the majority of the overhead when
there is no actual accounting (a task belongs to the root memory cgroup)
and almost halves the accounting overhead otherwise.

The main idea is to get rid of unnecessary memcg to objcg conversions and
switch to a scope-based protection of objcgs, which eliminates extra
operations with objcg reference counters under a rcu read lock.  More
details are provided in individual commit descriptions.


This patch (of 5):

Manually inline memcg_kmem_bypass() and active_memcg() to speed up
get_obj_cgroup_from_current() by avoiding duplicate in_task() checks and
active_memcg() readings.

Also add a likely() macro to __get_obj_cgroup_from_memcg():
obj_cgroup_tryget() should succeed at almost all times except a very
unlikely race with the memcg deletion path.

Link: https://lkml.kernel.org/r/20231019225346.1822282-1-roman.gushchin@linux.dev
Link: https://lkml.kernel.org/r/20231019225346.1822282-2-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

--- a/mm/memcontrol.c~mm-kmem-optimize-get_obj_cgroup_from_current
+++ a/mm/memcontrol.c
@@ -1086,19 +1086,6 @@ struct mem_cgroup *get_mem_cgroup_from_m
 }
 EXPORT_SYMBOL(get_mem_cgroup_from_mm);
 
-static __always_inline bool memcg_kmem_bypass(void)
-{
-	/* Allow remote memcg charging from any context. */
-	if (unlikely(active_memcg()))
-		return false;
-
-	/* Memcg to charge can't be determined. */
-	if (!in_task() || !current->mm || (current->flags & PF_KTHREAD))
-		return true;
-
-	return false;
-}
-
 /**
  * get_mem_cgroup_from_current - Obtain a reference on current task's memcg.
  */
@@ -3089,7 +3076,7 @@ static struct obj_cgroup *__get_obj_cgro
 
 	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
 		objcg = rcu_dereference(memcg->objcg);
-		if (objcg && obj_cgroup_tryget(objcg))
+		if (likely(objcg && obj_cgroup_tryget(objcg)))
 			break;
 		objcg = NULL;
 	}
@@ -3098,16 +3085,23 @@ static struct obj_cgroup *__get_obj_cgro
 
 __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
 {
-	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
 
-	if (memcg_kmem_bypass())
-		return NULL;
+	if (in_task()) {
+		memcg = current->active_memcg;
+
+		/* Memcg to charge can't be determined. */
+		if (likely(!memcg) && (!current->mm || (current->flags & PF_KTHREAD)))
+			return NULL;
+	} else {
+		memcg = this_cpu_read(int_active_memcg);
+		if (likely(!memcg))
+			return NULL;
+	}
 
 	rcu_read_lock();
-	if (unlikely(active_memcg()))
-		memcg = active_memcg();
-	else
+	if (!memcg)
 		memcg = mem_cgroup_from_task(current);
 	objcg = __get_obj_cgroup_from_memcg(memcg);
 	rcu_read_unlock();
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are


