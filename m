Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 101ABC27C47
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbjJYXsu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232946AbjJYXsV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4631B3
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0F9C433C9;
        Wed, 25 Oct 2023 23:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277697;
        bh=YXjg5Yf+yPaDh/j3Kz7QyuJWQHDmp19IUHCtbVw3ShY=;
        h=Date:To:From:Subject:From;
        b=zyhHPJ3K/S3NO1uOAf3CbIRH49v9F28LdPHdsj3cC/SKZSsJqJwnQqI4J17FbnhnZ
         8Rvxa2aHO/F4R5ujW8df9XtWlMvFVQA+TinTX1J5kVTM6Od9fe6BigfLMesRqMtott
         6HAkHQdx7+l79jKcKAorR3hHPGKPj2Az4OyhISJY=
Date:   Wed, 25 Oct 2023 16:48:15 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        sudeep.holla@arm.com, pasha.tatashin@soleen.com, mhocko@suse.com,
        mgorman@techsingularity.net, jweiner@redhat.com, david@redhat.com,
        dave.hansen@linux.intel.com, cl@linux.com, arjan@linux.intel.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] cacheinfo-calculate-size-of-per-cpu-data-cache-slice.patch removed from -mm tree
Message-Id: <20231025234817.9D0F9C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: cacheinfo: calculate size of per-CPU data cache slice
has been removed from the -mm tree.  Its filename was
     cacheinfo-calculate-size-of-per-cpu-data-cache-slice.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: cacheinfo: calculate size of per-CPU data cache slice
Date: Mon, 16 Oct 2023 13:29:55 +0800

This can be used to estimate the size of the data cache slice that can be
used by one CPU under ideal circumstances.  Both DATA caches and UNIFIED
caches are used in calculation.  So, the users need to consider the impact
of the code cache usage.

Because the cache inclusive/non-inclusive information isn't available now,
we just use the size of the per-CPU slice of LLC to make the result more
predictable across architectures.  This may be improved when more cache
information is available in the future.

A brute-force algorithm to iterate all online CPUs is used to avoid to
allocate an extra cpumask, especially in offline callback.

Link: https://lkml.kernel.org/r/20231016053002.756205-3-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/cacheinfo.c  |   49 +++++++++++++++++++++++++++++++++++-
 include/linux/cacheinfo.h |    1 
 2 files changed, 49 insertions(+), 1 deletion(-)

--- a/drivers/base/cacheinfo.c~cacheinfo-calculate-size-of-per-cpu-data-cache-slice
+++ a/drivers/base/cacheinfo.c
@@ -898,6 +898,48 @@ err:
 	return rc;
 }
 
+/*
+ * Calculate the size of the per-CPU data cache slice.  This can be
+ * used to estimate the size of the data cache slice that can be used
+ * by one CPU under ideal circumstances.  UNIFIED caches are counted
+ * in addition to DATA caches.  So, please consider code cache usage
+ * when use the result.
+ *
+ * Because the cache inclusive/non-inclusive information isn't
+ * available, we just use the size of the per-CPU slice of LLC to make
+ * the result more predictable across architectures.
+ */
+static void update_per_cpu_data_slice_size_cpu(unsigned int cpu)
+{
+	struct cpu_cacheinfo *ci;
+	struct cacheinfo *llc;
+	unsigned int nr_shared;
+
+	if (!last_level_cache_is_valid(cpu))
+		return;
+
+	ci = ci_cacheinfo(cpu);
+	llc = per_cpu_cacheinfo_idx(cpu, cache_leaves(cpu) - 1);
+
+	if (llc->type != CACHE_TYPE_DATA && llc->type != CACHE_TYPE_UNIFIED)
+		return;
+
+	nr_shared = cpumask_weight(&llc->shared_cpu_map);
+	if (nr_shared)
+		ci->per_cpu_data_slice_size = llc->size / nr_shared;
+}
+
+static void update_per_cpu_data_slice_size(bool cpu_online, unsigned int cpu)
+{
+	unsigned int icpu;
+
+	for_each_online_cpu(icpu) {
+		if (!cpu_online && icpu == cpu)
+			continue;
+		update_per_cpu_data_slice_size_cpu(icpu);
+	}
+}
+
 static int cacheinfo_cpu_online(unsigned int cpu)
 {
 	int rc = detect_cache_attributes(cpu);
@@ -906,7 +948,11 @@ static int cacheinfo_cpu_online(unsigned
 		return rc;
 	rc = cache_add_dev(cpu);
 	if (rc)
-		free_cache_attributes(cpu);
+		goto err;
+	update_per_cpu_data_slice_size(true, cpu);
+	return 0;
+err:
+	free_cache_attributes(cpu);
 	return rc;
 }
 
@@ -916,6 +962,7 @@ static int cacheinfo_cpu_pre_down(unsign
 		cpu_cache_sysfs_exit(cpu);
 
 	free_cache_attributes(cpu);
+	update_per_cpu_data_slice_size(false, cpu);
 	return 0;
 }
 
--- a/include/linux/cacheinfo.h~cacheinfo-calculate-size-of-per-cpu-data-cache-slice
+++ a/include/linux/cacheinfo.h
@@ -73,6 +73,7 @@ struct cacheinfo {
 
 struct cpu_cacheinfo {
 	struct cacheinfo *info_list;
+	unsigned int per_cpu_data_slice_size;
 	unsigned int num_levels;
 	unsigned int num_leaves;
 	bool cpu_map_populated;
_

Patches currently in -mm which might be from ying.huang@intel.com are


