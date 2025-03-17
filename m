Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3556215043
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188176; cv=none; b=l9BED159Fm7OqtRjuUtuLR+zjfS2BJiicKcSiWx1BTtkREYcJ1uft4Bw2AHHclUo+tcrBXVM778++nphj/44K3S7dtnmARnAMekOtID9/WV559D8sGE8DjlnjjIVlNY14Ij0h90W/DrlQ2ee+YMqS3pTMWqz5BlKwkdTnALppZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188176; c=relaxed/simple;
	bh=maaPZhsL9ngrKLRaPrJ3kvvgpaulIe/0mcVUSUrGC6k=;
	h=Date:To:From:Subject:Message-Id; b=f2+4qQ4z9ZGBQmrBUdHziNG4vhRhZdM7w2+4J2dCWOk214wnv9iBQqfbdk/ekaELWaGREPwwB8aUui/bKdbwcgWTCRQD0Od/DL8c6kv+0w0Lgn8RpcxC67/u2OsIGSfFDU1YP/+L9CR4Uk6txCzptYhJtjk6Ajsauksu7UeAVCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nor+uFLm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nor+uFLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4218FC4CEEC;
	Mon, 17 Mar 2025 05:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188175;
	bh=maaPZhsL9ngrKLRaPrJ3kvvgpaulIe/0mcVUSUrGC6k=;
	h=Date:To:From:Subject:From;
	b=Nor+uFLm05MhXj3zQFlgEo/7V4XKDcHBnLxUsExo2NlSjrgc1EmaFgfRPKj1XIkZZ
	 JcFCka1n0mmem6+083ZN4beVuEK4O0zaYmosYqAuKRdS2wUILjYT9hDMRmzW7dgytV
	 OX7bHN3AjIOLlDMFIsiGdz2WS9bF5+0O7byCQid4=
Date: Sun, 16 Mar 2025 22:09:34 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-move-stray-ratelimit-bits-to-v1.patch removed from -mm tree
Message-Id: <20250317050935.4218FC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: move stray ratelimit bits to v1
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-move-stray-ratelimit-bits-to-v1.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: move stray ratelimit bits to v1
Date: Thu, 23 Jan 2025 23:38:59 -0500

41213dd0f816 ("memcg: move mem_cgroup_event_ratelimit to v1 code") left
this one behind.  There are no v2 references.

Link: https://lkml.kernel.org/r/20250124043859.18808-2-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |   13 +++++++++++++
 mm/memcontrol-v1.h |   12 ------------
 2 files changed, 13 insertions(+), 12 deletions(-)

--- a/mm/memcontrol-v1.c~mm-memcontrol-move-stray-ratelimit-bits-to-v1
+++ a/mm/memcontrol-v1.c
@@ -490,6 +490,19 @@ static void mem_cgroup_threshold(struct
 }
 
 /* Cgroup1: threshold notifications & softlimit tree updates */
+
+/*
+ * Per memcg event counter is incremented at every pagein/pageout. With THP,
+ * it will be incremented by the number of pages. This counter is used
+ * to trigger some periodic events. This is straightforward and better
+ * than using jiffies etc. to handle periodic memcg event.
+ */
+enum mem_cgroup_events_target {
+	MEM_CGROUP_TARGET_THRESH,
+	MEM_CGROUP_TARGET_SOFTLIMIT,
+	MEM_CGROUP_NTARGETS,
+};
+
 struct memcg1_events_percpu {
 	unsigned long nr_page_events;
 	unsigned long targets[MEM_CGROUP_NTARGETS];
--- a/mm/memcontrol-v1.h~mm-memcontrol-move-stray-ratelimit-bits-to-v1
+++ a/mm/memcontrol-v1.h
@@ -28,18 +28,6 @@ static inline bool do_memsw_account(void
 	return !cgroup_subsys_on_dfl(memory_cgrp_subsys);
 }
 
-/*
- * Per memcg event counter is incremented at every pagein/pageout. With THP,
- * it will be incremented by the number of pages. This counter is used
- * to trigger some periodic events. This is straightforward and better
- * than using jiffies etc. to handle periodic memcg event.
- */
-enum mem_cgroup_events_target {
-	MEM_CGROUP_TARGET_THRESH,
-	MEM_CGROUP_TARGET_SOFTLIMIT,
-	MEM_CGROUP_NTARGETS,
-};
-
 unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
 
 void drain_all_stock(struct mem_cgroup *root_memcg);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-swap_cgroup-remove-double-initialization-of-locals.patch
mm-compaction-push-watermark-into-compaction_suitable-callers.patch
mm-page_alloc-trace-type-pollution-from-compaction-capturing.patch
mm-page_alloc-defrag_mode.patch
mm-page_alloc-defrag_mode-kswapd-kcompactd-assistance.patch
mm-page_alloc-defrag_mode-kswapd-kcompactd-watermarks.patch
mm-page_alloc-defrag_mode-kswapd-kcompactd-watermarks-fix.patch

