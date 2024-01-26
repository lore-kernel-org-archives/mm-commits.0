Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AD7125DB
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 07:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255689; cv=none; b=ROjl+yLTqSlcMDMPQrPBs/d6u20AESv3xRYf1PoExeGHcL0C4evXdoG/YFUq0gX6qH1lOtulIUbm/jMQ0y0KBP5tuFVx0ocb9LelBh86p+m1YqTR/tCW3xQFeoifo27Sb2/ByXJGReKKam08+hRjkrXybkJ8Qc1nJJ8LIir7Dts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255689; c=relaxed/simple;
	bh=aP6nbJ9GFLiezWUfhJywI+wsY/mrh8BHs+NaqLjHpV4=;
	h=Date:To:From:Subject:Message-Id; b=HuLQh84uVSE65BmQb6B1fzD1OtbdZ2EvzZdsI2F/BzMAUghApChHlhGsBTfLjHNweF0CUYnAf8HgjGm6FWNFYHtbBZLFWHc7con1KH/mtD2oOMAgdENwypDv/B8KIlFVre3u7qxk8NM2zN+EjekAqb4aBp10kzcjV9jalOiywXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sjS5Zfci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sjS5Zfci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9E2C433F1;
	Fri, 26 Jan 2024 07:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706255689;
	bh=aP6nbJ9GFLiezWUfhJywI+wsY/mrh8BHs+NaqLjHpV4=;
	h=Date:To:From:Subject:From;
	b=sjS5ZfciQFJZSfHbYwbsvc+AQ4mrMDTNuMHrDdFuka4a3hR88ey+xAfAbeEw7jkJJ
	 rvZgYgaMNs5M6bUbOUVlItaT9rRw+fUcgCwOfN4epcp2Gv5joIUYj74n7hzUB0Ik64
	 yNTfhMouGpqlL5IczrJLY3/+wH9HQrnTAa72lW+Q=
Date: Thu, 25 Jan 2024 23:54:45 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tj@kernel.org,shakeelb@google.com,schatzberg.dan@gmail.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcontrol-dont-throttle-dying-tasks-on-memoryhigh-v2.patch removed from -mm tree
Message-Id: <20240126075448.8C9E2C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memcontrol-dont-throttle-dying-tasks-on-memoryhigh-v2
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-dont-throttle-dying-tasks-on-memoryhigh-v2.patch

This patch was dropped because it was folded into mm-memcontrol-dont-throttle-dying-tasks-on-memoryhigh.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-memcontrol-dont-throttle-dying-tasks-on-memoryhigh-v2
Date: Thu, 11 Jan 2024 14:28:07 -0500

also handle the case when tasks are being killed during the reclaim

Link: https://lkml.kernel.org/r/20240111192807.GA424308@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-dont-throttle-dying-tasks-on-memoryhigh-v2
+++ a/mm/memcontrol.c
@@ -2624,8 +2624,8 @@ static unsigned long calculate_high_dela
 
 /*
  * Reclaims memory over the high limit. Called directly from
- * try_charge() when possible, but also scheduled to be called from
- * the userland return path where reclaim is always able to block.
+ * try_charge() (context permitting), as well as from the userland
+ * return path where reclaim is always able to block.
  */
 void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 {
@@ -2645,6 +2645,17 @@ void mem_cgroup_handle_over_high(gfp_t g
 
 retry_reclaim:
 	/*
+	 * Bail if the task is already exiting. Unlike memory.max,
+	 * memory.high enforcement isn't as strict, and there is no
+	 * OOM killer involved, which means the excess could already
+	 * be much bigger (and still growing) than it could for
+	 * memory.max; the dying task could get stuck in fruitless
+	 * reclaim for a long time, which isn't desirable.
+	 */
+	if (task_is_dying())
+		goto out;
+
+	/*
 	 * The allocating task should reclaim at least the batch size, but for
 	 * subsequent retries we only want to do what's necessary to prevent oom
 	 * or breaching resource isolation.
@@ -2892,24 +2903,16 @@ done_restock:
 	} while ((memcg = parent_mem_cgroup(memcg)));
 
 	/*
-	 * Reclaim is scheduled for the userland return path already,
-	 * but also attempt synchronous reclaim to avoid excessive
-	 * overrun while the task is still inside the kernel. If this
-	 * is successful, the return path will see it when it rechecks
-	 * the overage, and simply bail out.
-	 *
-	 * Skip if the task is already dying, though. Unlike
-	 * memory.max, memory.high enforcement isn't as strict, and
-	 * there is no OOM killer involved, which means the excess
-	 * could already be much bigger (and still growing) than it
-	 * could for memory.max; the dying task could get stuck in
-	 * fruitless reclaim for a long time, which isn't desirable.
+	 * Reclaim is set up above to be called from the userland
+	 * return path. But also attempt synchronous reclaim to avoid
+	 * excessive overrun while the task is still inside the
+	 * kernel. If this is successful, the return path will see it
+	 * when it rechecks the overage and simply bail out.
 	 */
 	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
-	    !(current->flags & PF_MEMALLOC) && !task_is_dying() &&
-	    gfpflags_allow_blocking(gfp_mask)) {
+	    !(current->flags & PF_MEMALLOC) &&
+	    gfpflags_allow_blocking(gfp_mask))
 		mem_cgroup_handle_over_high(gfp_mask);
-	}
 	return 0;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-dont-throttle-dying-tasks-on-memoryhigh.patch

