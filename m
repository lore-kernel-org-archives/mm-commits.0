Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC139155353
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 22:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723762057; cv=none; b=HHXduSX3WXazeABm6UxFJy/FmKJpz5ptyHPhCiPp7hPHWauIOeQYJUuwSCIaQos+eBEJFFp6wf1rHpkKJt54KGX9j7uZBWfRRjkbPvhI0aqwCiAT8PIgnlC8/0nhgFCLWkF8iqdb/ilyg4qxW57aceIFnh55n7Q4/z0meKKZ8V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723762057; c=relaxed/simple;
	bh=KQxSSfMCbMi6miK2fMBncQ4Za6Z2uET0YHgQr3yYawU=;
	h=Date:To:From:Subject:Message-Id; b=i/6EmTTpI9zLu/PAKZ0L58SOChf9KdZQpdMEcHwcTuhB0PXXSm78ELpxnknC0u90F7dV4vFswyNNgFje1WdRF+Om5vZuel3B5sWXUqx5OTDRaQSg43WARMmCmZ/ivPqaqrKwHarfwkA2JZqvld3vHMDFdvqroPCyKN6ImWo3XTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r5t8Ffwu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r5t8Ffwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756CEC32786;
	Thu, 15 Aug 2024 22:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723762057;
	bh=KQxSSfMCbMi6miK2fMBncQ4Za6Z2uET0YHgQr3yYawU=;
	h=Date:To:From:Subject:From;
	b=r5t8FfwuDoNY8xo34CNadRr0o2U34gHC7BA3dHUeVTZoKV18sGuAN9ks7IQjPQf8Y
	 F416KeHydANguJ/OSOAcydyDSwA2zw0gPPilbTMp9HasoVWb2J87UITQ1GgvQVSUIF
	 /oQF8NWlV166/XrtyamgkqBYEGgrHpLV7fl/UlHU=
Date: Thu, 15 Aug 2024 15:47:36 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-move-v1-events-and-statistics-code-to-v1-file.patch added to mm-unstable branch
Message-Id: <20240815224737.756CEC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: move v1 events and statistics code to v1 file
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-move-v1-events-and-statistics-code-to-v1-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-move-v1-events-and-statistics-code-to-v1-file.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: move v1 events and statistics code to v1 file
Date: Wed, 14 Aug 2024 22:04:50 -0700

Currently the common code path for charge commit, swapout and batched
uncharge are executing v1 only code which is completely useless for the v2
deployments where CONFIG_MEMCG_V1 is disabled.  In addition, it is mucking
with IRQs which might be slow on some architectures.  Let's move all of
this code to v1 only code and remove them from v2 only deployments.

Link: https://lkml.kernel.org/r/20240815050453.1298138-5-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |   37 +++++++++++++++++++++++++++++++++++++
 mm/memcontrol-v1.h |   14 ++++++++++++++
 mm/memcontrol.c    |   33 ++++-----------------------------
 3 files changed, 55 insertions(+), 29 deletions(-)

--- a/mm/memcontrol.c~memcg-move-v1-events-and-statistics-code-to-v1-file
+++ a/mm/memcontrol.c
@@ -2396,11 +2396,7 @@ void mem_cgroup_commit_charge(struct fol
 {
 	css_get(&memcg->css);
 	commit_charge(folio, memcg);
-
-	local_irq_disable();
-	memcg1_charge_statistics(memcg, folio_nr_pages(folio));
-	memcg1_check_events(memcg, folio_nid(folio));
-	local_irq_enable();
+	memcg1_commit_charge(folio, memcg);
 }
 
 static inline void __mod_objcg_mlstate(struct obj_cgroup *objcg,
@@ -4622,8 +4618,6 @@ static inline void uncharge_gather_clear
 
 static void uncharge_batch(const struct uncharge_gather *ug)
 {
-	unsigned long flags;
-
 	if (ug->nr_memory) {
 		page_counter_uncharge(&ug->memcg->memory, ug->nr_memory);
 		if (do_memsw_account())
@@ -4635,11 +4629,7 @@ static void uncharge_batch(const struct
 		memcg1_oom_recover(ug->memcg);
 	}
 
-	local_irq_save(flags);
-	__count_memcg_events(ug->memcg, PGPGOUT, ug->pgpgout);
-	__this_cpu_add(ug->memcg->events_percpu->nr_page_events, ug->nr_memory);
-	memcg1_check_events(ug->memcg, ug->nid);
-	local_irq_restore(flags);
+	memcg1_uncharge_batch(ug->memcg, ug->pgpgout, ug->nr_memory, ug->nid);
 
 	/* drop reference from uncharge_folio */
 	css_put(&ug->memcg->css);
@@ -4747,7 +4737,6 @@ void mem_cgroup_replace_folio(struct fol
 {
 	struct mem_cgroup *memcg;
 	long nr_pages = folio_nr_pages(new);
-	unsigned long flags;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(old), old);
 	VM_BUG_ON_FOLIO(!folio_test_locked(new), new);
@@ -4775,11 +4764,7 @@ void mem_cgroup_replace_folio(struct fol
 
 	css_get(&memcg->css);
 	commit_charge(new, memcg);
-
-	local_irq_save(flags);
-	memcg1_charge_statistics(memcg, nr_pages);
-	memcg1_check_events(memcg, folio_nid(new));
-	local_irq_restore(flags);
+	memcg1_commit_charge(new, memcg);
 }
 
 /**
@@ -5015,17 +5000,7 @@ void mem_cgroup_swapout(struct folio *fo
 		page_counter_uncharge(&memcg->memsw, nr_entries);
 	}
 
-	/*
-	 * Interrupts should be disabled here because the caller holds the
-	 * i_pages lock which is taken with interrupts-off. It is
-	 * important here to have the interrupts disabled because it is the
-	 * only synchronisation we have for updating the per-CPU variables.
-	 */
-	memcg_stats_lock();
-	memcg1_charge_statistics(memcg, -nr_entries);
-	memcg_stats_unlock();
-	memcg1_check_events(memcg, folio_nid(folio));
-
+	memcg1_swapout(folio, memcg);
 	css_put(&memcg->css);
 }
 
--- a/mm/memcontrol-v1.c~memcg-move-v1-events-and-statistics-code-to-v1-file
+++ a/mm/memcontrol-v1.c
@@ -1502,6 +1502,43 @@ void memcg1_check_events(struct mem_cgro
 	}
 }
 
+void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	memcg1_charge_statistics(memcg, folio_nr_pages(folio));
+	memcg1_check_events(memcg, folio_nid(folio));
+	local_irq_restore(flags);
+}
+
+void memcg1_swapout(struct folio *folio, struct mem_cgroup *memcg)
+{
+	/*
+	 * Interrupts should be disabled here because the caller holds the
+	 * i_pages lock which is taken with interrupts-off. It is
+	 * important here to have the interrupts disabled because it is the
+	 * only synchronisation we have for updating the per-CPU variables.
+	 */
+	preempt_disable_nested();
+	VM_WARN_ON_IRQS_ENABLED();
+	memcg1_charge_statistics(memcg, -folio_nr_pages(folio));
+	preempt_enable_nested();
+	memcg1_check_events(memcg, folio_nid(folio));
+}
+
+void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
+			   unsigned long nr_memory, int nid)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__count_memcg_events(memcg, PGPGOUT, pgpgout);
+	__this_cpu_add(memcg->events_percpu->nr_page_events, nr_memory);
+	memcg1_check_events(memcg, nid);
+	local_irq_restore(flags);
+}
+
 static int compare_thresholds(const void *a, const void *b)
 {
 	const struct mem_cgroup_threshold *_a = a;
--- a/mm/memcontrol-v1.h~memcg-move-v1-events-and-statistics-code-to-v1-file
+++ a/mm/memcontrol-v1.h
@@ -118,6 +118,11 @@ void memcg1_oom_recover(struct mem_cgrou
 void memcg1_charge_statistics(struct mem_cgroup *memcg, int nr_pages);
 void memcg1_check_events(struct mem_cgroup *memcg, int nid);
 
+void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg);
+void memcg1_swapout(struct folio *folio, struct mem_cgroup *memcg);
+void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
+			   unsigned long nr_memory, int nid);
+
 void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s);
 
 void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages);
@@ -150,6 +155,15 @@ static inline void memcg1_oom_recover(st
 static inline void memcg1_charge_statistics(struct mem_cgroup *memcg, int nr_pages) {}
 static inline void memcg1_check_events(struct mem_cgroup *memcg, int nid) {}
 
+static inline void memcg1_commit_charge(struct folio *folio,
+					struct mem_cgroup *memcg) {}
+
+static inline void memcg1_swapout(struct folio *folio, struct mem_cgroup *memcg) {}
+
+static inline void memcg1_uncharge_batch(struct mem_cgroup *memcg,
+					 unsigned long pgpgout,
+					 unsigned long nr_memory, int nid) {}
+
 static inline void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s) {}
 
 static inline void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages) {}
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-increase-the-valid-index-range-for-memcg-stats.patch
memcg-replace-memcg-id-idr-with-xarray.patch
memcg-replace-memcg-id-idr-with-xarray-v2.patch
memcg-use-ratelimited-stats-flush-in-the-reclaim.patch
memcg-move-v1-only-percpu-stats-in-separate-struct.patch
memcg-move-mem_cgroup_event_ratelimit-to-v1-code.patch
memcg-move-mem_cgroup_charge_statistics-to-v1-code.patch
memcg-move-v1-events-and-statistics-code-to-v1-file.patch
memcg-make-v1-only-functions-static.patch
memcg-allocate-v1-event-percpu-only-on-v1-deployment.patch
memcg-make-pgpgin-and-pgpgout-v1-only.patch

