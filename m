Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC31D51E
	for <mm-commits@vger.kernel.org>; Sun, 28 Jan 2024 08:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706431079; cv=none; b=aQa7dTOCCVuSfyJ7ZYJYLxx5rJP9oGauq1DgliaGz5I5TlZDFaMj1Gm0bsOOWLUY+qUZYzGftiZMdcas95sAFk5sNPlKDardyRTsNHXvGsNX7l1OK1Q+GgWsQenjgKbUqLRh2Io/hZwWoC/lFfAc9/FPNj0NmgXRdngkkM5Zl/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706431079; c=relaxed/simple;
	bh=OY7ud0hYCnOcSsmuGRbbbho2iB1GMhquSk57eQAZBVw=;
	h=Date:To:From:Subject:Message-Id; b=Gw4KOZsJgHyLC9cd1KdyI713M64PhLRAMIDN8vwbqFg8wFa+g2/WFOzUG1jRFlIi+2Qpz+xyLms2TJd4mVDXznljhj6wJtBO0KmgWHE4h81uFzGROvGmT1YSqTkE2eVa11rtwi3IdvJuGP+FXuFV3llCIWBhZsDMOneh8/Gw5HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iILTfNXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iILTfNXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C6EC433C7;
	Sun, 28 Jan 2024 08:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706431077;
	bh=OY7ud0hYCnOcSsmuGRbbbho2iB1GMhquSk57eQAZBVw=;
	h=Date:To:From:Subject:From;
	b=iILTfNXzm2KTni2KbWsjYgCRJ3rHlwmzUUt+7667RASR2r/kWojib0KsBP91XYeLJ
	 qk+StV8y6W2vFLmy/Xx1nexuBPmfOX9FlmK/2bZ+U7G1gOxyEb9oiz+JW3RiYBslAI
	 lFXPbwh5ehC6AhHoaVcd2aMM6hGPVcslaoDtfjec=
Date: Sun, 28 Jan 2024 00:37:54 -0800
To: mm-commits@vger.kernel.org,sudeep.holla@arm.com,mgorman@techsingularity.net,kyle.meyer@hpe.com,ying.huang@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-and-cache_info-remove-unnecessary-cpu-cache-info-update.patch added to mm-unstable branch
Message-Id: <20240128083756.B8C6EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm and cache_info: remove unnecessary CPU cache info update
has been added to the -mm mm-unstable branch.  Its filename is
     mm-and-cache_info-remove-unnecessary-cpu-cache-info-update.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-and-cache_info-remove-unnecessary-cpu-cache-info-update.patch

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
From: Huang Ying <ying.huang@intel.com>
Subject: mm and cache_info: remove unnecessary CPU cache info update
Date: Fri, 26 Jan 2024 16:19:44 +0800

For each CPU hotplug event, we will update per-CPU data slice size and
corresponding PCP configuration for every online CPU to make the
implementation simple.  But, Kyle reported that this takes tens seconds
during boot on a machine with 34 zones and 3840 CPUs.

So, in this patch, for each CPU hotplug event, we only update per-CPU data
slice size and corresponding PCP configuration for the CPUs that share
caches with the hotplugged CPU.  With the patch, the system boot time
reduces 67 seconds on the machine.

Link: https://lkml.kernel.org/r/20240126081944.414520-1-ying.huang@intel.com
Fixes: 362d37a106dd ("mm, pcp: reduce lock contention for draining high-order pages")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Originally-by: Kyle Meyer <kyle.meyer@hpe.com>
Reported-and-tested-by: Kyle Meyer <kyle.meyer@hpe.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/cacheinfo.c |   50 ++++++++++++++++++++++++++++++++-----
 include/linux/gfp.h      |    2 -
 mm/page_alloc.c          |   39 +++++++++++++---------------
 3 files changed, 63 insertions(+), 28 deletions(-)

--- a/drivers/base/cacheinfo.c~mm-and-cache_info-remove-unnecessary-cpu-cache-info-update
+++ a/drivers/base/cacheinfo.c
@@ -898,6 +898,37 @@ err:
 	return rc;
 }
 
+static unsigned int cpu_map_shared_cache(bool online, unsigned int cpu,
+					 cpumask_t **map)
+{
+	struct cacheinfo *llc, *sib_llc;
+	unsigned int sibling;
+
+	if (!last_level_cache_is_valid(cpu))
+		return 0;
+
+	llc = per_cpu_cacheinfo_idx(cpu, cache_leaves(cpu) - 1);
+
+	if (llc->type != CACHE_TYPE_DATA && llc->type != CACHE_TYPE_UNIFIED)
+		return 0;
+
+	if (online) {
+		*map = &llc->shared_cpu_map;
+		return cpumask_weight(*map);
+	}
+
+	/* shared_cpu_map of offlined CPU will be cleared, so use sibling map */
+	for_each_cpu(sibling, &llc->shared_cpu_map) {
+		if (sibling == cpu || !last_level_cache_is_valid(sibling))
+			continue;
+		sib_llc = per_cpu_cacheinfo_idx(sibling, cache_leaves(sibling) - 1);
+		*map = &sib_llc->shared_cpu_map;
+		return cpumask_weight(*map);
+	}
+
+	return 0;
+}
+
 /*
  * Calculate the size of the per-CPU data cache slice.  This can be
  * used to estimate the size of the data cache slice that can be used
@@ -929,28 +960,31 @@ static void update_per_cpu_data_slice_si
 		ci->per_cpu_data_slice_size = llc->size / nr_shared;
 }
 
-static void update_per_cpu_data_slice_size(bool cpu_online, unsigned int cpu)
+static void update_per_cpu_data_slice_size(bool cpu_online, unsigned int cpu,
+					   cpumask_t *cpu_map)
 {
 	unsigned int icpu;
 
-	for_each_online_cpu(icpu) {
+	for_each_cpu(icpu, cpu_map) {
 		if (!cpu_online && icpu == cpu)
 			continue;
 		update_per_cpu_data_slice_size_cpu(icpu);
+		setup_pcp_cacheinfo(icpu);
 	}
 }
 
 static int cacheinfo_cpu_online(unsigned int cpu)
 {
 	int rc = detect_cache_attributes(cpu);
+	cpumask_t *cpu_map;
 
 	if (rc)
 		return rc;
 	rc = cache_add_dev(cpu);
 	if (rc)
 		goto err;
-	update_per_cpu_data_slice_size(true, cpu);
-	setup_pcp_cacheinfo();
+	if (cpu_map_shared_cache(true, cpu, &cpu_map))
+		update_per_cpu_data_slice_size(true, cpu, cpu_map);
 	return 0;
 err:
 	free_cache_attributes(cpu);
@@ -959,12 +993,16 @@ err:
 
 static int cacheinfo_cpu_pre_down(unsigned int cpu)
 {
+	cpumask_t *cpu_map;
+	unsigned int nr_shared;
+
+	nr_shared = cpu_map_shared_cache(false, cpu, &cpu_map);
 	if (cpumask_test_and_clear_cpu(cpu, &cache_dev_map))
 		cpu_cache_sysfs_exit(cpu);
 
 	free_cache_attributes(cpu);
-	update_per_cpu_data_slice_size(false, cpu);
-	setup_pcp_cacheinfo();
+	if (nr_shared > 1)
+		update_per_cpu_data_slice_size(false, cpu, cpu_map);
 	return 0;
 }
 
--- a/include/linux/gfp.h~mm-and-cache_info-remove-unnecessary-cpu-cache-info-update
+++ a/include/linux/gfp.h
@@ -334,7 +334,7 @@ void drain_all_pages(struct zone *zone);
 void drain_local_pages(struct zone *zone);
 
 void page_alloc_init_late(void);
-void setup_pcp_cacheinfo(void);
+void setup_pcp_cacheinfo(unsigned int cpu);
 
 /*
  * gfp_allowed_mask is set to GFP_BOOT_MASK during early boot to restrict what
--- a/mm/page_alloc.c~mm-and-cache_info-remove-unnecessary-cpu-cache-info-update
+++ a/mm/page_alloc.c
@@ -5578,37 +5578,34 @@ static void zone_pcp_update(struct zone
 	mutex_unlock(&pcp_batch_high_lock);
 }
 
-static void zone_pcp_update_cacheinfo(struct zone *zone)
+static void zone_pcp_update_cacheinfo(struct zone *zone, unsigned int cpu)
 {
-	int cpu;
 	struct per_cpu_pages *pcp;
 	struct cpu_cacheinfo *cci;
 
-	for_each_online_cpu(cpu) {
-		pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
-		cci = get_cpu_cacheinfo(cpu);
-		/*
-		 * If data cache slice of CPU is large enough, "pcp->batch"
-		 * pages can be preserved in PCP before draining PCP for
-		 * consecutive high-order pages freeing without allocation.
-		 * This can reduce zone lock contention without hurting
-		 * cache-hot pages sharing.
-		 */
-		spin_lock(&pcp->lock);
-		if ((cci->per_cpu_data_slice_size >> PAGE_SHIFT) > 3 * pcp->batch)
-			pcp->flags |= PCPF_FREE_HIGH_BATCH;
-		else
-			pcp->flags &= ~PCPF_FREE_HIGH_BATCH;
-		spin_unlock(&pcp->lock);
-	}
+	pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
+	cci = get_cpu_cacheinfo(cpu);
+	/*
+	 * If data cache slice of CPU is large enough, "pcp->batch"
+	 * pages can be preserved in PCP before draining PCP for
+	 * consecutive high-order pages freeing without allocation.
+	 * This can reduce zone lock contention without hurting
+	 * cache-hot pages sharing.
+	 */
+	spin_lock(&pcp->lock);
+	if ((cci->per_cpu_data_slice_size >> PAGE_SHIFT) > 3 * pcp->batch)
+		pcp->flags |= PCPF_FREE_HIGH_BATCH;
+	else
+		pcp->flags &= ~PCPF_FREE_HIGH_BATCH;
+	spin_unlock(&pcp->lock);
 }
 
-void setup_pcp_cacheinfo(void)
+void setup_pcp_cacheinfo(unsigned int cpu)
 {
 	struct zone *zone;
 
 	for_each_populated_zone(zone)
-		zone_pcp_update_cacheinfo(zone);
+		zone_pcp_update_cacheinfo(zone, cpu);
 }
 
 /*
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-and-cache_info-remove-unnecessary-cpu-cache-info-update.patch

