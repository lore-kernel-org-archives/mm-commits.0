Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4437156861
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 22:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723762060; cv=none; b=WIAQI5PS05VfREDMw0bgjAxoWRb2d45taZpUWOZO+0crLyaHnkeNK3JImByS7AgpJPlOUXxyAqo28HDjFoSGzxMKm3EfAG9yLagoXt6vZ4Pfxz/2aYIAWGeDyxfQ5XfgqcokJrX+Hp8PxGj05E/tMhmL1QOloy84PLOB3tRjFco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723762060; c=relaxed/simple;
	bh=APaIcR5PZAKIMcEqsXYYZ2EUIuy+C7hHRZ8TyzET2QY=;
	h=Date:To:From:Subject:Message-Id; b=AyjyV3A4h7lKA09sHxuA5VvpMqPohwMH80SyYnibLLiF0A+D9xjjsLwJXmoBBDruX5owUplh7+ssiHgKYlTBs6krOXgjWMKihf8TDFzYCKmo1V9vf5rJ6Vrirt1i/qifOzrxKqldaDNV+SMWzIajp4mZ+IYo9KS+n5b2HSC2QpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n8e/aTce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n8e/aTce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EE5C32786;
	Thu, 15 Aug 2024 22:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723762060;
	bh=APaIcR5PZAKIMcEqsXYYZ2EUIuy+C7hHRZ8TyzET2QY=;
	h=Date:To:From:Subject:From;
	b=n8e/aTceK+ibQSXFOLRCxMkC1fqmFL2Jydg5dhWXobwwa/6qymB6eyR1q/VFUhpr9
	 NXfUWm4k6lTHPcU+2GN5b8jGrAkg8CLqAq0WdCnRXluwqLx5sddlOKFuU/w+F2Op30
	 Q3PBFtilDx8DgTjN/O1C4G88GxjD87nt3xCcRtak=
Date: Thu, 15 Aug 2024 15:47:40 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-allocate-v1-event-percpu-only-on-v1-deployment.patch added to mm-unstable branch
Message-Id: <20240815224740.A1EE5C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: allocate v1 event percpu only on v1 deployment
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-allocate-v1-event-percpu-only-on-v1-deployment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-allocate-v1-event-percpu-only-on-v1-deployment.patch

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
Subject: memcg: allocate v1 event percpu only on v1 deployment
Date: Wed, 14 Aug 2024 22:04:52 -0700

Currently memcg->events_percpu gets allocated on v2 deployments.  Let's
move the allocation to v1 only codebase.  This is not needed in v2.

Link: https://lkml.kernel.org/r/20240815050453.1298138-7-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    3 ++-
 mm/memcontrol-v1.c         |   19 +++++++++++++++++++
 mm/memcontrol-v1.h         |   26 +++++++-------------------
 3 files changed, 28 insertions(+), 20 deletions(-)

--- a/include/linux/memcontrol.h~memcg-allocate-v1-event-percpu-only-on-v1-deployment
+++ a/include/linux/memcontrol.h
@@ -255,7 +255,6 @@ struct mem_cgroup {
 	struct list_head objcg_list;
 
 	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
-	struct memcg1_events_percpu __percpu *events_percpu;
 
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct list_head cgwb_list;
@@ -277,6 +276,8 @@ struct mem_cgroup {
 	struct page_counter kmem;		/* v1 only */
 	struct page_counter tcpmem;		/* v1 only */
 
+	struct memcg1_events_percpu __percpu *events_percpu;
+
 	unsigned long soft_limit;
 
 	/* protected by memcg_oom_lock */
--- a/mm/memcontrol-v1.c~memcg-allocate-v1-event-percpu-only-on-v1-deployment
+++ a/mm/memcontrol-v1.c
@@ -1442,6 +1442,12 @@ static void mem_cgroup_threshold(struct
 	}
 }
 
+/* Cgroup1: threshold notifications & softlimit tree updates */
+struct memcg1_events_percpu {
+	unsigned long nr_page_events;
+	unsigned long targets[MEM_CGROUP_NTARGETS];
+};
+
 static void memcg1_charge_statistics(struct mem_cgroup *memcg, int nr_pages)
 {
 	/* pagein of a big page is an event. So, ignore page size */
@@ -3030,6 +3036,19 @@ bool memcg1_charge_skmem(struct mem_cgro
 	return false;
 }
 
+bool memcg1_alloc_events(struct mem_cgroup *memcg)
+{
+	memcg->events_percpu = alloc_percpu_gfp(struct memcg1_events_percpu,
+						GFP_KERNEL_ACCOUNT);
+	return !!memcg->events_percpu;
+}
+
+void memcg1_free_events(struct mem_cgroup *memcg)
+{
+	if (memcg->events_percpu)
+		free_percpu(memcg->events_percpu);
+}
+
 static int __init memcg1_init(void)
 {
 	int node;
--- a/mm/memcontrol-v1.h~memcg-allocate-v1-event-percpu-only-on-v1-deployment
+++ a/mm/memcontrol-v1.h
@@ -55,12 +55,6 @@ enum mem_cgroup_events_target {
 	MEM_CGROUP_NTARGETS,
 };
 
-/* Cgroup1: threshold notifications & softlimit tree updates */
-struct memcg1_events_percpu {
-	unsigned long nr_page_events;
-	unsigned long targets[MEM_CGROUP_NTARGETS];
-};
-
 unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
 
 void drain_all_stock(struct mem_cgroup *root_memcg);
@@ -72,21 +66,12 @@ unsigned long memcg_page_state_output(st
 unsigned long memcg_page_state_local_output(struct mem_cgroup *memcg, int item);
 int memory_stat_show(struct seq_file *m, void *v);
 
-static inline bool memcg1_alloc_events(struct mem_cgroup *memcg)
-{
-	memcg->events_percpu = alloc_percpu_gfp(struct memcg1_events_percpu,
-						GFP_KERNEL_ACCOUNT);
-	return !!memcg->events_percpu;
-}
-
-static inline void memcg1_free_events(struct mem_cgroup *memcg)
-{
-	if (memcg->events_percpu)
-		free_percpu(memcg->events_percpu);
-}
-
 /* Cgroup v1-specific declarations */
 #ifdef CONFIG_MEMCG_V1
+
+bool memcg1_alloc_events(struct mem_cgroup *memcg);
+void memcg1_free_events(struct mem_cgroup *memcg);
+
 void memcg1_memcg_init(struct mem_cgroup *memcg);
 void memcg1_remove_from_trees(struct mem_cgroup *memcg);
 
@@ -139,6 +124,9 @@ extern struct cftype mem_cgroup_legacy_f
 
 #else	/* CONFIG_MEMCG_V1 */
 
+static inline bool memcg1_alloc_events(struct mem_cgroup *memcg) { return true; }
+static inline void memcg1_free_events(struct mem_cgroup *memcg) {}
+
 static inline void memcg1_memcg_init(struct mem_cgroup *memcg) {}
 static inline void memcg1_remove_from_trees(struct mem_cgroup *memcg) {}
 static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg) {}
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

