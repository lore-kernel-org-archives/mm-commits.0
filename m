Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21ED311CA9
	for <mm-commits@vger.kernel.org>; Wed, 22 Oct 2025 00:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761091729; cv=none; b=hphS0Qtd9uRwQUgmO4Zewg0UnkHt0Dem9eo7KFDtLnVtryYM4rV3+CBJiJnWaw/2g4XNAgjvDttlmK2mfC/CC2J3fQoercvyxDakmiUUTYvmXzN0Jal6pk04GpYF7Du21G7/ZgC9xp8jfANBp0qaM7vQq+yXoC4x5eS8gcCQ9SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761091729; c=relaxed/simple;
	bh=aPEZRMqchDE/SfiEVNOt4Aj4iphBejU/rpMQonxWTLc=;
	h=Date:To:From:Subject:Message-Id; b=Bujsa4aSxbB7wpvw/rxj2ZOc2wR9r0IdAYv13yRyz7nzp9AzDEouj/2BSz3VViPSiZUQT07HOPU+Ovn8kDU52Mol+8oHQs0Io8sjVXNqb0QNd3fajkiRzgkkdX+uxGo42YORfhtEMmhNQGyxTYoxTbC+upMZ+Jiw8hAOoJWyvzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M91diTRB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M91diTRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F9EC4CEF1;
	Wed, 22 Oct 2025 00:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761091728;
	bh=aPEZRMqchDE/SfiEVNOt4Aj4iphBejU/rpMQonxWTLc=;
	h=Date:To:From:Subject:From;
	b=M91diTRBAH2p0f2A1CNV78EpU0KSO2iM4kIJDZR5Rotx0BE49p4sB1yb+u7xmTqqO
	 4RN+e6l3z5Yhi2yG9JI8Xzj1k93f9ECI0/cDCY0VI2ABJ+/2+iLezw6ldeyYnc861e
	 VuR3c9eeccpJtVQn1wxQPcbaPF7ytsB7Po83BF4M=
Date: Tue, 21 Oct 2025 17:08:47 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-manually-uninline-__memcg_memory_event.patch added to mm-new branch
Message-Id: <20251022000848.91F9EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: manually uninline __memcg_memory_event
has been added to the -mm mm-new branch.  Its filename is
     memcg-manually-uninline-__memcg_memory_event.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-manually-uninline-__memcg_memory_event.patch

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

Link: https://lkml.kernel.org/r/20251021234425.1885471-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
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
+EXPORT_SYMBOL(__memcg_memory_event);
+
 static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 				     int order)
 {
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-net-track-network-throttling-due-to-memcg-memory-pressure.patch
memcg-manually-uninline-__memcg_memory_event.patch

