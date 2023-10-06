Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25BBAE94125
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:48:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbjJFVsu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233773AbjJFVss (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:48:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABA6DF
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:48:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C5EC433C9;
        Fri,  6 Oct 2023 21:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628927;
        bh=oYdURQAelEa5OI/+87Zqx/Sc7OS+uyT94TXDV2VYGtQ=;
        h=Date:To:From:Subject:From;
        b=DWBkC9mRxIO87ke9843oWTxnoQLF2SSLfkciZyqhtMOU2TCp8Ehp24bA/IMk3HVCE
         L4ekK6ompWuiohtra20zneXZDgC9F85rQic7BQL7PrTFI4lKfPBxrA8sCCYoji+H9W
         2NX1eJMrS2RAxWQguEQ38RHRB5jY4PHsbImLfcwk=
Date:   Fri, 06 Oct 2023 14:48:44 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        sudeep.holla@arm.com, pasha.tatashin@soleen.com, mhocko@suse.com,
        mgorman@techsingularity.net, jweiner@redhat.com, david@redhat.com,
        dave.hansen@linux.intel.com, cl@linux.com, arjan@linux.intel.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] cacheinfo-calculate-per-cpu-data-cache-size.patch removed from -mm tree
Message-Id: <20231006214846.92C5EC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: cacheinfo: calculate per-CPU data cache size
has been removed from the -mm tree.  Its filename was
     cacheinfo-calculate-per-cpu-data-cache-size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

