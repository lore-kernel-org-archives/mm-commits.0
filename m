Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB2A7E7F143
	for <mm-commits@archiver.kernel.org>; Tue, 26 Sep 2023 23:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbjIZXR5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Sep 2023 19:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbjIZXPz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Sep 2023 19:15:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB9517813
        for <mm-commits@vger.kernel.org>; Tue, 26 Sep 2023 15:17:23 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8B9C433C7;
        Tue, 26 Sep 2023 20:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695761963;
        bh=ftRhLcr4Gc7nSF0Jj6wD57UA+RuMoB0ocToq9lCQ1pU=;
        h=Date:To:From:Subject:From;
        b=K1215w3Ofih1sZJSToFriQmjqhIbs9qdeFNbxWOo85x/ltRfWqGYnFhVY1gSR7vMO
         nRMXh4MI/yQy9LCnHsR00tV/ffy2yPzNKk8J3fKESsly5oyO2vxau9jLFUHGOpyOE0
         TuLlNkA2soCbH3ecNWK3xqX5IynTSJqYdQDbwvBs=
Date:   Tue, 26 Sep 2023 13:59:21 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        sudeep.holla@arm.com, pasha.tatashin@soleen.com, mhocko@suse.com,
        mgorman@techsingularity.net, jweiner@redhat.com, david@redhat.com,
        dave.hansen@linux.intel.com, cl@linux.com, arjan@linux.intel.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + cacheinfo-calculate-per-cpu-data-cache-size.patch added to mm-unstable branch
Message-Id: <20230926205923.7A8B9C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cacheinfo: calculate per-CPU data cache size
has been added to the -mm mm-unstable branch.  Its filename is
     cacheinfo-calculate-per-cpu-data-cache-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cacheinfo-calculate-per-cpu-data-cache-size.patch

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
Subject: cacheinfo: calculate per-CPU data cache size
Date: Tue, 26 Sep 2023 14:09:03 +0800

Per-CPU data cache size is useful information.  For example, it can be
used to determine per-CPU cache size.  So, in this patch, the data cache
size for each CPU is calculated via data_cache_size / shared_cpu_weight.

A brute-force algorithm to iterate all online CPUs is used to avoid to
allocate an extra cpumask, especially in offline callback.

Link: https://lkml.kernel.org/r/20230926060911.266511-3-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
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

 drivers/base/cacheinfo.c  |   42 +++++++++++++++++++++++++++++++++++-
 include/linux/cacheinfo.h |    1 
 2 files changed, 42 insertions(+), 1 deletion(-)

--- a/drivers/base/cacheinfo.c~cacheinfo-calculate-per-cpu-data-cache-size
+++ a/drivers/base/cacheinfo.c
@@ -898,6 +898,41 @@ err:
 	return rc;
 }
 
+static void update_data_cache_size_cpu(unsigned int cpu)
+{
+	struct cpu_cacheinfo *ci;
+	struct cacheinfo *leaf;
+	unsigned int i, nr_shared;
+	unsigned int size_data = 0;
+
+	if (!per_cpu_cacheinfo(cpu))
+		return;
+
+	ci = ci_cacheinfo(cpu);
+	for (i = 0; i < cache_leaves(cpu); i++) {
+		leaf = per_cpu_cacheinfo_idx(cpu, i);
+		if (leaf->type != CACHE_TYPE_DATA &&
+		    leaf->type != CACHE_TYPE_UNIFIED)
+			continue;
+		nr_shared = cpumask_weight(&leaf->shared_cpu_map);
+		if (!nr_shared)
+			continue;
+		size_data += leaf->size / nr_shared;
+	}
+	ci->size_data = size_data;
+}
+
+static void update_data_cache_size(bool cpu_online, unsigned int cpu)
+{
+	unsigned int icpu;
+
+	for_each_online_cpu(icpu) {
+		if (!cpu_online && icpu == cpu)
+			continue;
+		update_data_cache_size_cpu(icpu);
+	}
+}
+
 static int cacheinfo_cpu_online(unsigned int cpu)
 {
 	int rc = detect_cache_attributes(cpu);
@@ -906,7 +941,11 @@ static int cacheinfo_cpu_online(unsigned
 		return rc;
 	rc = cache_add_dev(cpu);
 	if (rc)
-		free_cache_attributes(cpu);
+		goto err;
+	update_data_cache_size(true, cpu);
+	return 0;
+err:
+	free_cache_attributes(cpu);
 	return rc;
 }
 
@@ -916,6 +955,7 @@ static int cacheinfo_cpu_pre_down(unsign
 		cpu_cache_sysfs_exit(cpu);
 
 	free_cache_attributes(cpu);
+	update_data_cache_size(false, cpu);
 	return 0;
 }
 
--- a/include/linux/cacheinfo.h~cacheinfo-calculate-per-cpu-data-cache-size
+++ a/include/linux/cacheinfo.h
@@ -73,6 +73,7 @@ struct cacheinfo {
 
 struct cpu_cacheinfo {
 	struct cacheinfo *info_list;
+	unsigned int size_data;
 	unsigned int num_levels;
 	unsigned int num_leaves;
 	bool cpu_map_populated;
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-fix-draining-remote-pageset.patch
memory-tiering-add-abstract-distance-calculation-algorithms-management.patch
acpi-hmat-refactor-hmat_register_target_initiators.patch
acpi-hmat-calculate-abstract-distance-with-hmat.patch
dax-kmem-calculate-abstract-distance-with-general-interface.patch
mm-pcp-avoid-to-drain-pcp-when-process-exit.patch
cacheinfo-calculate-per-cpu-data-cache-size.patch
mm-pcp-reduce-lock-contention-for-draining-high-order-pages.patch
mm-restrict-the-pcp-batch-scale-factor-to-avoid-too-long-latency.patch
mm-page_alloc-scale-the-number-of-pages-that-are-batch-allocated.patch
mm-add-framework-for-pcp-high-auto-tuning.patch
mm-tune-pcp-high-automatically.patch
mm-pcp-decrease-pcp-high-if-free-pages-high-watermark.patch
mm-pcp-avoid-to-reduce-pcp-high-unnecessarily.patch
mm-pcp-reduce-detecting-time-of-consecutive-high-order-page-freeing.patch

