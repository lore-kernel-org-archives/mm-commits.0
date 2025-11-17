Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86DE22D7B0
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343211; cv=none; b=djgbU4AGBqzD5BssYiYOI0Sk3Ea8PwGvLprEeSS1fNMUKptmDjqp7wxzDG09V3akvVbuOwtNyO6iV/xRnAMEAsaxmI1YDmyVmkRg7PMILR2/XfUO0/Sgd+Ac1P/8Wb6yTNv4833wsQtwIVjSYHxj5DqiL4yKSLaP0vRSeY4nnc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343211; c=relaxed/simple;
	bh=mksBsfuDzKu/jg08wrFwUOzhNGddShRecBrNWZVUcgY=;
	h=Date:To:From:Subject:Message-Id; b=fy0exOde8vmNWWMlSfPMhc37FznLRa2EDzMGtSspeYnzbIMOIx+HjLuQMgMGl/y0SofpMLv9HYB2l+4fXEfOeWQqf4UiAdqYvQZkEPhAjlvay8ATIsiNTYMU6Zw/XtIk8OXoYjkA/ChQzo7Hjuzug9K1lEqNeyy3PoRsTQdLTa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MjTOi3S2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MjTOi3S2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAEAC4CEF1;
	Mon, 17 Nov 2025 01:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343211;
	bh=mksBsfuDzKu/jg08wrFwUOzhNGddShRecBrNWZVUcgY=;
	h=Date:To:From:Subject:From;
	b=MjTOi3S2uSJDQN6i/g17vut8jlF6w+BrdkKnJw9d3ihxYKE/S0a1edgEDZIVlGI4F
	 v+gRiTO7X7m5Xeqi+Rx7h3wFzbQWoNE3x9wpAsYoCwpr0SqGjAPygkKZvvy80QoDjn
	 tI4oaiFVKM1bAg5zgrdhq3cxbPiC4saLVcx+wgs0=
Date: Sun, 16 Nov 2025 17:33:31 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hch@infradead.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-manually-uninline-__memcg_memory_event.patch removed from -mm tree
Message-Id: <20251117013331.8AAEAC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: manually uninline __memcg_memory_event
has been removed from the -mm tree.  Its filename was
     memcg-manually-uninline-__memcg_memory_event.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: manually uninline __memcg_memory_event
Date: Tue, 21 Oct 2025 16:44:25 -0700

__memcg_memory_event() has been unnecessarily marked inline even when it
is not really performance critical.  It is usually called to track extreme
conditions.  Over the time, it has evolved to include more functionality
and inlining it is causing more harm.

Before the patch:
$ size mm/memcontrol.o net/ipv4/tcp_input.o net/ipv4/tcp_output.o
   text    data     bss     dec     hex filename
  35645   10574    4192   50411    c4eb mm/memcontrol.o
  54738    1658       0   56396    dc4c net/ipv4/tcp_input.o
  34644    1065       0   35709    8b7d net/ipv4/tcp_output.o

After the patch:
$ size mm/memcontrol.o net/ipv4/tcp_input.o net/ipv4/tcp_output.o
   text    data     bss     dec     hex filename
  35137   10446    4192   49775    c26f mm/memcontrol.o
  54322    1562       0   55884    da4c net/ipv4/tcp_input.o
  34492    1017       0   35509    8ab5 net/ipv4/tcp_output.o

[akpm@linux-foundation.org: use EXPORT_SYMBOL_GPL for __memcg_memory_event, per Michal and Christoph]
Link: https://lkml.kernel.org/r/20251021234425.1885471-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   32 ++------------------------------
 mm/memcontrol.c            |   31 +++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 30 deletions(-)

--- a/include/linux/memcontrol.h~memcg-manually-uninline-__memcg_memory_event
+++ a/include/linux/memcontrol.h
@@ -1002,36 +1002,8 @@ static inline void count_memcg_event_mm(
 	count_memcg_events_mm(mm, idx, 1);
 }
 
-static inline void __memcg_memory_event(struct mem_cgroup *memcg,
-					enum memcg_memory_event event,
-					bool allow_spinning)
-{
-	bool swap_event = event == MEMCG_SWAP_HIGH || event == MEMCG_SWAP_MAX ||
-			  event == MEMCG_SWAP_FAIL;
-
-	/* For now only MEMCG_MAX can happen with !allow_spinning context. */
-	VM_WARN_ON_ONCE(!allow_spinning && event != MEMCG_MAX);
-
-	atomic_long_inc(&memcg->memory_events_local[event]);
-	if (!swap_event && allow_spinning)
-		cgroup_file_notify(&memcg->events_local_file);
-
-	do {
-		atomic_long_inc(&memcg->memory_events[event]);
-		if (allow_spinning) {
-			if (swap_event)
-				cgroup_file_notify(&memcg->swap_events_file);
-			else
-				cgroup_file_notify(&memcg->events_file);
-		}
-
-		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
-			break;
-		if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
-			break;
-	} while ((memcg = parent_mem_cgroup(memcg)) &&
-		 !mem_cgroup_is_root(memcg));
-}
+void __memcg_memory_event(struct mem_cgroup *memcg,
+			  enum memcg_memory_event event, bool allow_spinning);
 
 static inline void memcg_memory_event(struct mem_cgroup *memcg,
 				      enum memcg_memory_event event)
--- a/mm/memcontrol.c~memcg-manually-uninline-__memcg_memory_event
+++ a/mm/memcontrol.c
@@ -1626,6 +1626,37 @@ unsigned long mem_cgroup_size(struct mem
 	return page_counter_read(&memcg->memory);
 }
 
+void __memcg_memory_event(struct mem_cgroup *memcg,
+			  enum memcg_memory_event event, bool allow_spinning)
+{
+	bool swap_event = event == MEMCG_SWAP_HIGH || event == MEMCG_SWAP_MAX ||
+			  event == MEMCG_SWAP_FAIL;
+
+	/* For now only MEMCG_MAX can happen with !allow_spinning context. */
+	VM_WARN_ON_ONCE(!allow_spinning && event != MEMCG_MAX);
+
+	atomic_long_inc(&memcg->memory_events_local[event]);
+	if (!swap_event && allow_spinning)
+		cgroup_file_notify(&memcg->events_local_file);
+
+	do {
+		atomic_long_inc(&memcg->memory_events[event]);
+		if (allow_spinning) {
+			if (swap_event)
+				cgroup_file_notify(&memcg->swap_events_file);
+			else
+				cgroup_file_notify(&memcg->events_file);
+		}
+
+		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+			break;
+		if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
+			break;
+	} while ((memcg = parent_mem_cgroup(memcg)) &&
+		 !mem_cgroup_is_root(memcg));
+}
+EXPORT_SYMBOL_GPL(__memcg_memory_event);
+
 static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 				     int order)
 {
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-memcg-dump-memcg-protection-info-on-oom-or-alloc-failures.patch

