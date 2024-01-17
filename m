Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F39250F7
	for <mm-commits@vger.kernel.org>; Wed, 17 Jan 2024 20:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705524921; cv=none; b=gi8cCrDPV9CAS2Jr0B9LvKg6EVDwBuW4eTsONQRSRn/ZEHGlkAddqb85y49Lb5l+sog9lFPw16d88EQO9cMDg+kIcTnLiKELDboCOek96bYaXIPPAkGJaQAzVgPycxTVNz82UwQH7se6/AKTr7PWDeN/IZ2WsnCe040y9pOuOfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705524921; c=relaxed/simple;
	bh=EpBaBH8kM3dr4eg+ds6ZaMKcVGqGy4vj6p93DyTJ6s8=;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id; b=brcFzEZpwoG8CD98Ur07fQ6yw1gpANzu6EAad5oiwJ80PkSC41eRzk+3H6Aw759N47sDuOw4kqV+v0l4c1v5mEaqaJm91ADpOQTKRGczN7R4Ejxaj5AMxXuIqc+uvET8MiBh4iMB5Sl5rnJciAggBAJGKVqNaB3O/r0bxwmgc9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gyiyZyCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gyiyZyCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C34C433C7;
	Wed, 17 Jan 2024 20:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705524921;
	bh=EpBaBH8kM3dr4eg+ds6ZaMKcVGqGy4vj6p93DyTJ6s8=;
	h=Date:To:From:Subject:From;
	b=gyiyZyCmotrdezL602tpfCs3eH5GkrieyDZhRxJwpcekVpHYIkvYVut36ydWXaA23
	 SB6aGQFbi1J/cOftxxIA8ETnzm3yx5D7TzraPp2TD68PpS0nex6aKBzkUPGcii5D9o
	 VPPQ55i4L4HlFdItugKXza8x3OKrmtnHODPjPo5U=
Date: Wed, 17 Jan 2024 12:55:18 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tj@kernel.org,shakeelb@google.com,schatzberg.dan@gmail.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-dont-throttle-dying-tasks-on-memoryhigh-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20240117205520.C4C34C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memcontrol-dont-throttle-dying-tasks-on-memoryhigh-v2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memcontrol-dont-throttle-dying-tasks-on-memoryhigh-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-dont-throttle-dying-tasks-on-memoryhigh-v2.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
mm-memcontrol-dont-throttle-dying-tasks-on-memoryhigh-v2.patch

