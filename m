Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA64170A11;
	Tue,  7 Oct 2025 21:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759870895; cv=none; b=IReAYsS2CREhU3nRzcHt7+wW+KPrIIFt6K1YeVhFV5r3qwoP2j8jTgy1j3R69jezSXk1yxnQh+S6AOxUINoJmQ9h8FUPRdI9t/+VOM1Mmxg/MXLTWAlR25KzjbXHzpv4QqGFXHARleyrgfuCaM8RXV+zyS7YgAzlTqljNHNfn9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759870895; c=relaxed/simple;
	bh=qlbm7w8e8Bw8y/TCGZNILZKJ9d2mCSxLI3Q95yl5z2Y=;
	h=Date:To:From:Subject:Message-Id; b=gEKa0RM7jcDEyPFtcGF44y9xR0sQ+SMHoiK/rS8bWznO3GbIlX4myr6BeLQi+3hS25du1yUHHeGLOelY6yRNgaNKqBZl2+YBbrIXMH/wfwIjIRmepo/kawtuBj0NqLoTvnBT/Uvz6vDpBd5A/5rKeRkbdExplzCZArxkq1IBkV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oRmbOB5h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oRmbOB5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5C6C4CEF1;
	Tue,  7 Oct 2025 21:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759870895;
	bh=qlbm7w8e8Bw8y/TCGZNILZKJ9d2mCSxLI3Q95yl5z2Y=;
	h=Date:To:From:Subject:From;
	b=oRmbOB5hX8V1957UVuDTqRXnxzVeq2MGKUUyVW/qKg9/zXJ1g1AtQqNV9TmrlwVDP
	 UeI+n+6UEG9ruemhVkPGUbZJLvXVyzO5pqthNeJFVNnp61QyI5M2uhVm6btKf8/HT4
	 IxQhfbiScpLABJsrWWtREXNIlxQjaskQF1PC7Lsk=
Date: Tue, 07 Oct 2025 14:01:34 -0700
To: mm-commits@vger.kernel.org,yepeilin@google.com,tj@kernel.org,stable@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,memxor@gmail.com,hannes@cmpxchg.org,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] memcg-skip-cgroup_file_notify-if-spinning-is-not-allowed.patch removed from -mm tree
Message-Id: <20251007210135.0B5C6C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: skip cgroup_file_notify if spinning is not allowed
has been removed from the -mm tree.  Its filename was
     memcg-skip-cgroup_file_notify-if-spinning-is-not-allowed.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Closes: https://lore.kernel.org/all/20250905061919.439648-1-yepeilin@google.com/
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peilin Ye <yepeilin@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   26 +++++++++++++++++++-------
 mm/memcontrol.c            |    7 ++++---
 2 files changed, 23 insertions(+), 10 deletions(-)

--- a/include/linux/memcontrol.h~memcg-skip-cgroup_file_notify-if-spinning-is-not-allowed
+++ a/include/linux/memcontrol.h
@@ -1001,22 +1001,28 @@ static inline void count_memcg_event_mm(
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
@@ -1026,6 +1032,12 @@ static inline void memcg_memory_event(st
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


