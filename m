Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 814CCCDB465
	for <mm-commits@archiver.kernel.org>; Mon, 16 Oct 2023 22:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbjJPW6g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Oct 2023 18:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbjJPW6g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2023 18:58:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B369483
        for <mm-commits@vger.kernel.org>; Mon, 16 Oct 2023 15:58:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B279C433C7;
        Mon, 16 Oct 2023 22:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697497114;
        bh=8CVhhVU0rRApsRqUNcx4BY/C5TQeN3M97etGYCfTn8Q=;
        h=Date:To:From:Subject:From;
        b=ZHMiVY8Y1WOj4o9ndqBi6/Qk7+7uKKpeZrYBeA8fnjevVmHYFV7SFC6f6oeTtkeZg
         jklt89PTEUHGXuY0CORpKSizxLs2n+yAtD6Zuz3WAIUv3QDRBycfF95Hh53Q2Q999z
         C4owHuC4v+1YuVx7jRhAhhWwP4T96cK5fQP+6Erw=
Date:   Mon, 16 Oct 2023 15:58:33 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shakeelb@google.com,
        rientjes@google.com, naresh.kamboju@linaro.org,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        dennis@kernel.org, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmem-optimize-get_obj_cgroup_from_current.patch added to mm-unstable branch
Message-Id: <20231016225834.4B279C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmem: optimize get_obj_cgroup_from_current()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmem-optimize-get_obj_cgroup_from_current.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmem-optimize-get_obj_cgroup_from_current.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: kmem: optimize get_obj_cgroup_from_current()
Date: Mon, 16 Oct 2023 15:18:56 -0700

Patch series "mm: improve performance of accounted kernel memory
allocations", v3.

This patchset improves the performance of accounted kernel memory
allocations by ~30% as measured by a micro-benchmark [1].  The benchmark
is very straightforward: 1M of 64 bytes-large kmalloc() allocations.

Below are results with the disabled kernel memory accounting, the original
state and with this patchset applied.

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

Link: https://lkml.kernel.org/r/20231016221900.4031141-1-roman.gushchin@linux.dev
Link: https://lkml.kernel.org/r/20231016221900.4031141-2-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

--- a/mm/memcontrol.c~mm-kmem-optimize-get_obj_cgroup_from_current
+++ a/mm/memcontrol.c
@@ -1110,19 +1110,6 @@ struct mem_cgroup *get_mem_cgroup_from_m
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
@@ -3113,7 +3100,7 @@ static struct obj_cgroup *__get_obj_cgro
 
 	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
 		objcg = rcu_dereference(memcg->objcg);
-		if (objcg && obj_cgroup_tryget(objcg))
+		if (likely(objcg && obj_cgroup_tryget(objcg)))
 			break;
 		objcg = NULL;
 	}
@@ -3122,16 +3109,23 @@ static struct obj_cgroup *__get_obj_cgro
 
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

mm-kmem-optimize-get_obj_cgroup_from_current.patch
mm-kmem-add-direct-objcg-pointer-to-task_struct.patch
mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg.patch
mm-kmem-scoped-objcg-protection.patch
percpu-scoped-objcg-protection.patch

