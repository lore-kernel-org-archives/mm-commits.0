Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3365DD27D
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141605; cv=none; b=LEbln3pqVye5CzZH3qL+KTi95wYLp0ji3o8OSuYK6NnQbO3yzPKisjGLlAauQK2TIak5xmisI8L7JUnLl8mCGv7mfsiw1SdXqtAWFB6FZiYKGX6v2r2uzAgSs8LcIx1Yw8k+5MCN66vNHJ7/Vskk38XNIVgmoTHv/UEjgNPYSrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141605; c=relaxed/simple;
	bh=BWu4W9VYbnKSLoJDFe2BgaJBmWwsGQ6ualf8srM12e4=;
	h=Date:To:From:Subject:Message-Id; b=J7Vk3tkzq2VupxreGcu5IaXfVzc2U69vTZdbrLCTJ0lstIvdjcAJMLWA8XA3ivIUR/UDTuAumHzlvZtQ32PvrtLc0aMuhtF2F7y1DZP/ZfddHmv1Nb/SPGgVM+INvQL/B6eqyiRTvFhcnsGbxnQIgB4btpfxMmCGats69ESPmPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HGAz47z3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HGAz47z3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C48C4AF07;
	Fri,  5 Jul 2024 01:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141605;
	bh=BWu4W9VYbnKSLoJDFe2BgaJBmWwsGQ6ualf8srM12e4=;
	h=Date:To:From:Subject:From;
	b=HGAz47z3vlvg6dhKU0MOEbTbOjAWe0NJsfadyWb+k0SIJPB/4PLi3noe1yHUxuje7
	 PgonviNf1DfyenOuZAtbFCI92OjHsz8pJ6+A+/0TM2+RdzfRozv5bl3tCyAjJllQqc
	 DMM4ynn6SpWcWHCHUJvsINr+BMWicoTDZTQYNTA4=
Date: Thu, 04 Jul 2024 18:06:44 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-rename-memcg_check_events.patch removed from -mm tree
Message-Id: <20240705010645.04C48C4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: rename memcg_check_events()
has been removed from the -mm tree.  Its filename was
     mm-memcg-rename-memcg_check_events.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg: rename memcg_check_events()
Date: Mon, 24 Jun 2024 17:58:59 -0700

Rename memcg_check_events() into memcg1_check_events() for consistency
with other cgroup v1-specific functions.

Link: https://lkml.kernel.org/r/20240625005906.106920-8-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    6 +++---
 mm/memcontrol-v1.h |    2 +-
 mm/memcontrol.c    |    8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-rename-memcg_check_events
+++ a/mm/memcontrol.c
@@ -2630,7 +2630,7 @@ void mem_cgroup_commit_charge(struct fol
 
 	local_irq_disable();
 	mem_cgroup_charge_statistics(memcg, folio_nr_pages(folio));
-	memcg_check_events(memcg, folio_nid(folio));
+	memcg1_check_events(memcg, folio_nid(folio));
 	local_irq_enable();
 }
 
@@ -5662,7 +5662,7 @@ static void uncharge_batch(const struct
 	local_irq_save(flags);
 	__count_memcg_events(ug->memcg, PGPGOUT, ug->pgpgout);
 	__this_cpu_add(ug->memcg->vmstats_percpu->nr_page_events, ug->nr_memory);
-	memcg_check_events(ug->memcg, ug->nid);
+	memcg1_check_events(ug->memcg, ug->nid);
 	local_irq_restore(flags);
 
 	/* drop reference from uncharge_folio */
@@ -5801,7 +5801,7 @@ void mem_cgroup_replace_folio(struct fol
 
 	local_irq_save(flags);
 	mem_cgroup_charge_statistics(memcg, nr_pages);
-	memcg_check_events(memcg, folio_nid(new));
+	memcg1_check_events(memcg, folio_nid(new));
 	local_irq_restore(flags);
 }
 
@@ -6070,7 +6070,7 @@ void mem_cgroup_swapout(struct folio *fo
 	memcg_stats_lock();
 	mem_cgroup_charge_statistics(memcg, -nr_entries);
 	memcg_stats_unlock();
-	memcg_check_events(memcg, folio_nid(folio));
+	memcg1_check_events(memcg, folio_nid(folio));
 
 	css_put(&memcg->css);
 }
--- a/mm/memcontrol-v1.c~mm-memcg-rename-memcg_check_events
+++ a/mm/memcontrol-v1.c
@@ -835,9 +835,9 @@ static int mem_cgroup_move_account(struc
 
 	local_irq_disable();
 	mem_cgroup_charge_statistics(to, nr_pages);
-	memcg_check_events(to, nid);
+	memcg1_check_events(to, nid);
 	mem_cgroup_charge_statistics(from, -nr_pages);
-	memcg_check_events(from, nid);
+	memcg1_check_events(from, nid);
 	local_irq_enable();
 out:
 	return ret;
@@ -1424,7 +1424,7 @@ static void mem_cgroup_threshold(struct
  * Check events in order.
  *
  */
-void memcg_check_events(struct mem_cgroup *memcg, int nid)
+void memcg1_check_events(struct mem_cgroup *memcg, int nid)
 {
 	if (IS_ENABLED(CONFIG_PREEMPT_RT))
 		return;
--- a/mm/memcontrol-v1.h~mm-memcg-rename-memcg_check_events
+++ a/mm/memcontrol-v1.h
@@ -12,7 +12,7 @@ static inline void memcg1_soft_limit_res
 }
 
 void mem_cgroup_charge_statistics(struct mem_cgroup *memcg, int nr_pages);
-void memcg_check_events(struct mem_cgroup *memcg, int nid);
+void memcg1_check_events(struct mem_cgroup *memcg, int nid);
 void memcg_oom_recover(struct mem_cgroup *memcg);
 int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		     unsigned int nr_pages);
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup.patch
mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node.patch

