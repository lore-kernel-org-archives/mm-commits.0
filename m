Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093A642A9F
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247851; cv=none; b=DcJiMWSOKeavBc+gzCqTXNQa4wFXwcPuRf/bEZku9xwTkfieYriAQjVR9EipOA737w05rsUpaf91gAe+zBcJjAh9PxrUB0EjRaGCRIfb+0r+Yj8iEwDWGwxb7gm4Ek+o95jmKNdHKmLgJy6yEixJ+ouNGhtz5mAOgK6bAnUItOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247851; c=relaxed/simple;
	bh=Lw1fvzs9bEk+xCyK8jrDQztfwUQFhbU3sHMIZYIBYPM=;
	h=Date:To:From:Subject:Message-Id; b=E6Uwm0YElYMkW1ME3Bj/vcPYt8foYWdROen+/Xwx5A46L4P3e4PGX79vboIhnukeQziO1orkBk6ePVnMlLA4ZL6jhBKDzaXdDj1gADwwysvrqY2gI/f+JTz/y+zadsgBcUxoxxtL4XlcZkUQqlij0Awd0fhSu3xhWQa85mY5nVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0UXYoNdF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0UXYoNdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C55C4CEC2;
	Mon,  2 Sep 2024 03:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247850;
	bh=Lw1fvzs9bEk+xCyK8jrDQztfwUQFhbU3sHMIZYIBYPM=;
	h=Date:To:From:Subject:From;
	b=0UXYoNdFzwXMclZI4/tRyYLgcbzoERPLAalLUXjAa6HIfJN5NTBRYONmiHXAYCCkh
	 OT03ysLrjS36BuzLLsiw+OzS+nG1qnPkxO7mcTdvkqD6UfchBVhCVDnzdJYZUWbKfu
	 Lctlt3WTsECLcufRofhPTSGoV+K2no+iTd+eTgYI=
Date: Sun, 01 Sep 2024 20:30:50 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-move-mem_cgroup_charge_statistics-to-v1-code.patch removed from -mm tree
Message-Id: <20240902033050.D4C55C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: move mem_cgroup_charge_statistics to v1 code
has been removed from the -mm tree.  Its filename was
     memcg-move-mem_cgroup_charge_statistics-to-v1-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: move mem_cgroup_charge_statistics to v1 code
Date: Wed, 14 Aug 2024 22:04:49 -0700

There are no callers of mem_cgroup_charge_statistics() in the v2 code
base, so move it to the v1 only code and rename it to
memcg1_charge_statistics().

Link: https://lkml.kernel.org/r/20240815050453.1298138-4-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |   17 +++++++++++++++--
 mm/memcontrol-v1.h |    3 ++-
 mm/memcontrol.c    |   19 +++----------------
 3 files changed, 20 insertions(+), 19 deletions(-)

--- a/mm/memcontrol.c~memcg-move-mem_cgroup_charge_statistics-to-v1-code
+++ a/mm/memcontrol.c
@@ -840,19 +840,6 @@ unsigned long memcg_events_local(struct
 	return READ_ONCE(memcg->vmstats->events_local[i]);
 }
 
-void mem_cgroup_charge_statistics(struct mem_cgroup *memcg, int nr_pages)
-{
-	/* pagein of a big page is an event. So, ignore page size */
-	if (nr_pages > 0)
-		__count_memcg_events(memcg, PGPGIN, 1);
-	else {
-		__count_memcg_events(memcg, PGPGOUT, 1);
-		nr_pages = -nr_pages; /* for event */
-	}
-
-	__this_cpu_add(memcg->events_percpu->nr_page_events, nr_pages);
-}
-
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
 {
 	/*
@@ -2366,7 +2353,7 @@ void mem_cgroup_commit_charge(struct fol
 	commit_charge(folio, memcg);
 
 	local_irq_disable();
-	mem_cgroup_charge_statistics(memcg, folio_nr_pages(folio));
+	memcg1_charge_statistics(memcg, folio_nr_pages(folio));
 	memcg1_check_events(memcg, folio_nid(folio));
 	local_irq_enable();
 }
@@ -4742,7 +4729,7 @@ void mem_cgroup_replace_folio(struct fol
 	commit_charge(new, memcg);
 
 	local_irq_save(flags);
-	mem_cgroup_charge_statistics(memcg, nr_pages);
+	memcg1_charge_statistics(memcg, nr_pages);
 	memcg1_check_events(memcg, folio_nid(new));
 	local_irq_restore(flags);
 }
@@ -4987,7 +4974,7 @@ void mem_cgroup_swapout(struct folio *fo
 	 * only synchronisation we have for updating the per-CPU variables.
 	 */
 	memcg_stats_lock();
-	mem_cgroup_charge_statistics(memcg, -nr_entries);
+	memcg1_charge_statistics(memcg, -nr_entries);
 	memcg_stats_unlock();
 	memcg1_check_events(memcg, folio_nid(folio));
 
--- a/mm/memcontrol-v1.c~memcg-move-mem_cgroup_charge_statistics-to-v1-code
+++ a/mm/memcontrol-v1.c
@@ -853,9 +853,9 @@ static int mem_cgroup_move_account(struc
 	nid = folio_nid(folio);
 
 	local_irq_disable();
-	mem_cgroup_charge_statistics(to, nr_pages);
+	memcg1_charge_statistics(to, nr_pages);
 	memcg1_check_events(to, nid);
-	mem_cgroup_charge_statistics(from, -nr_pages);
+	memcg1_charge_statistics(from, -nr_pages);
 	memcg1_check_events(from, nid);
 	local_irq_enable();
 out:
@@ -1439,6 +1439,19 @@ static void mem_cgroup_threshold(struct
 	}
 }
 
+void memcg1_charge_statistics(struct mem_cgroup *memcg, int nr_pages)
+{
+	/* pagein of a big page is an event. So, ignore page size */
+	if (nr_pages > 0)
+		__count_memcg_events(memcg, PGPGIN, 1);
+	else {
+		__count_memcg_events(memcg, PGPGOUT, 1);
+		nr_pages = -nr_pages; /* for event */
+	}
+
+	__this_cpu_add(memcg->events_percpu->nr_page_events, nr_pages);
+}
+
 #define THRESHOLDS_EVENTS_TARGET 128
 #define SOFTLIMIT_EVENTS_TARGET 1024
 
--- a/mm/memcontrol-v1.h~memcg-move-mem_cgroup_charge_statistics-to-v1-code
+++ a/mm/memcontrol-v1.h
@@ -7,7 +7,6 @@
 
 /* Cgroup v1 and v2 common declarations */
 
-void mem_cgroup_charge_statistics(struct mem_cgroup *memcg, int nr_pages);
 int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		     unsigned int nr_pages);
 
@@ -116,6 +115,7 @@ bool memcg1_oom_prepare(struct mem_cgrou
 void memcg1_oom_finish(struct mem_cgroup *memcg, bool locked);
 void memcg1_oom_recover(struct mem_cgroup *memcg);
 
+void memcg1_charge_statistics(struct mem_cgroup *memcg, int nr_pages);
 void memcg1_check_events(struct mem_cgroup *memcg, int nid);
 
 void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s);
@@ -147,6 +147,7 @@ static inline bool memcg1_oom_prepare(st
 static inline void memcg1_oom_finish(struct mem_cgroup *memcg, bool locked) {}
 static inline void memcg1_oom_recover(struct mem_cgroup *memcg) {}
 
+static inline void memcg1_charge_statistics(struct mem_cgroup *memcg, int nr_pages) {}
 static inline void memcg1_check_events(struct mem_cgroup *memcg, int nid) {}
 
 static inline void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s) {}
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


