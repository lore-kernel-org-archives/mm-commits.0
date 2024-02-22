Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B196DA929
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560108; cv=none; b=tADF7So+2LioIplIeitMcdQyYHNL4o0TyzW4UyNHpht9couNC2VBj9SkRrdAN5JdUbmnQvBmi50bCPPhzJGeMkLGFsl446gwk+dG0GY9ctK3Ix4FjlcBZ/kf6nNmX55HWIvFMUWkWqOxN18N1Fqme/dmD6UHeKq00G+eZBrcZr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560108; c=relaxed/simple;
	bh=R5z1fe+v1TWLXHo7DXZnOhV1z4oRZAH218LHZN1lTIA=;
	h=Date:To:From:Subject:Message-Id; b=NWW8yip4pshrwg3xsHyOnay+omv/GcOedItC513WtQ2H9Hv7ERq2v45z6v290bknmjZba2g6rmX8MRV0BSxZFEBjXlUooHcGXInQe3RlzKJ434I1kJ3d51iY+So9GI6UmXdt3zCrtaI8tUck/24ITLF/RuAIIArNkTF57uh1AnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oss6hJkY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oss6hJkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82745C43390;
	Thu, 22 Feb 2024 00:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560108;
	bh=R5z1fe+v1TWLXHo7DXZnOhV1z4oRZAH218LHZN1lTIA=;
	h=Date:To:From:Subject:From;
	b=oss6hJkYP4XxhKkh04WkCzhWZdyA/ps+4jPqOKwJtCrmAOBgglGAW+GIhBIkbSdci
	 VvWE8aj7tBuocu4GifF0KJAKReoxdcTNBDN0KKJjZi3xN2p+kqO4UBJuQQVIc0IhJf
	 WiamoClA6bKps0ZJLSsXpGhve6THBhm01wmy4sIs=
Date: Wed, 21 Feb 2024 16:01:47 -0800
To: mm-commits@vger.kernel.org,sudeep.holla@arm.com,mgorman@techsingularity.net,kyle.meyer@hpe.com,ying.huang@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-and-cache_info-remove-unnecessary-cpu-cache-info-update.patch removed from -mm tree
Message-Id: <20240222000148.82745C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm and cache_info: remove unnecessary CPU cache info update
has been removed from the -mm tree.  Its filename was
     mm-and-cache_info-remove-unnecessary-cpu-cache-info-update.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -5572,37 +5572,34 @@ static void zone_pcp_update(struct zone
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


