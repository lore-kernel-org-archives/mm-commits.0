Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3123AC39
	for <mm-commits@vger.kernel.org>; Mon, 22 Sep 2025 23:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758582359; cv=none; b=Yq/Sk7XRLMuW3fi451c+uzQE7b3T6IEXvavAoXDZdUlnjE4/siq6yfFQsCG0pz/OSM25CUmbeighOJ7Fj7mmMA8UJ/ZV0ZuiB9IaVeRT99UC6g/z8/foB9WpNT9seZc0NrwE8mZLa3rXYrmbh+4rRlq2YOij1Bl9KdER3FB9z3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758582359; c=relaxed/simple;
	bh=QN+OusFythIVBl/7Wl4d32X3Hlaw711ziEPUn0bXkxA=;
	h=Date:To:From:Subject:Message-Id; b=WBL0TqL/1hWAeb2LM4Y7qPj5kk9xxY1LgcgepqX4NmCMXlEbrp640K143oOnvnp9rINUDdsib5HI4WRtEyPJwD02sLoHv3QL1Kxccimv+8DzC+CWZ3EQTl/tEUOWtMmq7cdNa7GFzhUCEharpq07dzGJl0bYMIt7QUxfCbv6t0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hZqeg2Gm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hZqeg2Gm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88537C4CEF0;
	Mon, 22 Sep 2025 23:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758582358;
	bh=QN+OusFythIVBl/7Wl4d32X3Hlaw711ziEPUn0bXkxA=;
	h=Date:To:From:Subject:From;
	b=hZqeg2GmSVTltGFy2DUVIlz8iNemH+y60zuOuwgnJ/1njI5AFF87U5bnWgafpKDxw
	 PQ/b2b0y1sCdHWIPL4HpgyZHZP2IJtqqadtTbwPtXULBG88euMjFmAeXGSfAGGfmZD
	 ixcqodw76qCnA9W3lpYCr+gfo0NaM8h/HCGJXZLs=
Date: Mon, 22 Sep 2025 16:05:57 -0700
To: mm-commits@vger.kernel.org,yepeilin@google.com,tj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,memxor@gmail.com,hannes@cmpxchg.org,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-skip-cgroup_file_notify-if-spinning-is-not-allowed.patch added to mm-new branch
Message-Id: <20250922230558.88537C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: skip cgroup_file_notify if spinning is not allowed
has been added to the -mm mm-new branch.  Its filename is
     memcg-skip-cgroup_file_notify-if-spinning-is-not-allowed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-skip-cgroup_file_notify-if-spinning-is-not-allowed.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: skip cgroup_file_notify if spinning is not allowed
Date: Mon, 22 Sep 2025 15:02:03 -0700

Generally memcg charging is allowed from all the contexts including NMI
where even spinning on spinlock can cause locking issues.  However one
call chain was missed during the addition of memcg charging from any
context support.  That is try_charge_memcg() -> memcg_memory_event() ->
cgroup_file_notify().

The possible function call tree under cgroup_file_notify() can acquire
many different spin locks in spinning mode.  Some of them are
cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock.  So, let's
just skip cgroup_file_notify() from memcg charging if the context does not
allow spinning.

Alternative approach was also explored where instead of skipping
cgroup_file_notify(), we defer the memcg event processing to irq_work [1].
However it adds complexity and it was decided to keep things simple until
we need more memcg events with !allow_spinning requirement.

Link: https://lore.kernel.org/all/5qi2llyzf7gklncflo6gxoozljbm4h3tpnuv4u4ej4ztysvi6f@x44v7nz2wdzd/ [1]
Link: https://lkml.kernel.org/r/20250922220203.261714-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peilin Ye <yepeilin@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   26 +++++++++++++++++++-------
 mm/memcontrol.c            |    7 ++++---
 2 files changed, 23 insertions(+), 10 deletions(-)

--- a/include/linux/memcontrol.h~memcg-skip-cgroup_file_notify-if-spinning-is-not-allowed
+++ a/include/linux/memcontrol.h
@@ -993,22 +993,28 @@ static inline void count_memcg_event_mm(
 	count_memcg_events_mm(mm, idx, 1);
 }
 
-static inline void memcg_memory_event(struct mem_cgroup *memcg,
-				      enum memcg_memory_event event)
+static inline void __memcg_memory_event(struct mem_cgroup *memcg,
+					enum memcg_memory_event event,
+					bool allow_spinning)
 {
 	bool swap_event = event == MEMCG_SWAP_HIGH || event == MEMCG_SWAP_MAX ||
 			  event == MEMCG_SWAP_FAIL;
 
+	/* For now only MEMCG_MAX can happen with !allow_spinning context. */
+	VM_WARN_ON_ONCE(!allow_spinning && event != MEMCG_MAX);
+
 	atomic_long_inc(&memcg->memory_events_local[event]);
-	if (!swap_event)
+	if (!swap_event && allow_spinning)
 		cgroup_file_notify(&memcg->events_local_file);
 
 	do {
 		atomic_long_inc(&memcg->memory_events[event]);
-		if (swap_event)
-			cgroup_file_notify(&memcg->swap_events_file);
-		else
-			cgroup_file_notify(&memcg->events_file);
+		if (allow_spinning) {
+			if (swap_event)
+				cgroup_file_notify(&memcg->swap_events_file);
+			else
+				cgroup_file_notify(&memcg->events_file);
+		}
 
 		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 			break;
@@ -1018,6 +1024,12 @@ static inline void memcg_memory_event(st
 		 !mem_cgroup_is_root(memcg));
 }
 
+static inline void memcg_memory_event(struct mem_cgroup *memcg,
+				      enum memcg_memory_event event)
+{
+	__memcg_memory_event(memcg, event, true);
+}
+
 static inline void memcg_memory_event_mm(struct mm_struct *mm,
 					 enum memcg_memory_event event)
 {
--- a/mm/memcontrol.c~memcg-skip-cgroup_file_notify-if-spinning-is-not-allowed
+++ a/mm/memcontrol.c
@@ -2307,12 +2307,13 @@ static int try_charge_memcg(struct mem_c
 	bool drained = false;
 	bool raised_max_event = false;
 	unsigned long pflags;
+	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
 
 retry:
 	if (consume_stock(memcg, nr_pages))
 		return 0;
 
-	if (!gfpflags_allow_spinning(gfp_mask))
+	if (!allow_spinning)
 		/* Avoid the refill and flush of the older stock */
 		batch = nr_pages;
 
@@ -2348,7 +2349,7 @@ retry:
 	if (!gfpflags_allow_blocking(gfp_mask))
 		goto nomem;
 
-	memcg_memory_event(mem_over_limit, MEMCG_MAX);
+	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
 	raised_max_event = true;
 
 	psi_memstall_enter(&pflags);
@@ -2415,7 +2416,7 @@ force:
 	 * a MEMCG_MAX event.
 	 */
 	if (!raised_max_event)
-		memcg_memory_event(mem_over_limit, MEMCG_MAX);
+		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
 
 	/*
 	 * The allocation either can't fail or will lead to more memory
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-skip-cgroup_file_notify-if-spinning-is-not-allowed.patch

