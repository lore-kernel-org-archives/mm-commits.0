Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB2DAC433E0
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 20:23:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8478D2226A
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 20:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbhADUWr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jan 2021 15:22:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:34104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbhADUWr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 Jan 2021 15:22:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0257D221F8;
        Mon,  4 Jan 2021 20:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609791726;
        bh=z2L10slN5Fwswf+TiY5iL4AyXSDKlGWY3DRgxXvEUxU=;
        h=Date:From:To:Subject:From;
        b=KazuJ/Xj+dbmItyqb3ptJm3C82eiDyE3DxynyOEXAJqEsUgszdHqrLpF/6xD14NBF
         jfriSbofRl3t3a04za4h49NQPg9rfXn5pqCBdsm1Ksr452nRj584SgtdQZfEK6dq31
         OGzLL7RzRlelGw7w2/52Wr//KWEBewLAcFGzCYeg=
Date:   Mon, 04 Jan 2021 12:22:05 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, dave.hansen@intel.com, jgross@suse.com,
        jinyuqi@huawei.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, paul.burton@mips.com, rppt@linux.ibm.com,
        rusty@rustcorp.com.au, zhangshaokun@hisilicon.com
Subject:  + lib-optimize-cpumask_local_spread-v8.patch added to -mm
 tree
Message-ID: <20210104202205.ms7rlF6Up%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib-optimize-cpumask_local_spread-v8
has been added to the -mm tree.  Its filename is
     lib-optimize-cpumask_local_spread-v8.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-optimize-cpumask_local_spread-v8.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-optimize-cpumask_local_spread-v8.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yuqi Jin <jinyuqi@huawei.com>
Subject: lib-optimize-cpumask_local_spread-v8

    1. Fix confusing comments
    2. Improve the loop for choosing the nearest node.

Link: https://lkml.kernel.org/r/1609759109-62925-1-git-send-email-zhangshaokun@hisilicon.com
Signed-off-by: Yuqi Jin <jinyuqi@huawei.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Juergen Gross <jgross@suse.com>
Cc: Paul Burton <paul.burton@mips.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |    2 -
 lib/cpumask.c           |   61 +++++++++++++++++++-------------------
 2 files changed, 32 insertions(+), 31 deletions(-)

--- a/include/linux/cpumask.h~lib-optimize-cpumask_local_spread-v8
+++ a/include/linux/cpumask.h
@@ -189,7 +189,7 @@ static inline unsigned int cpumask_any_b
 	return 1;
 }
 
-static inline unsigned int cpumask_local_spread(unsigned int i, int node)
+static inline unsigned int cpumask_local_spread(unsigned int cpu_index, int node)
 {
 	return 0;
 }
--- a/lib/cpumask.c~lib-optimize-cpumask_local_spread-v8
+++ a/lib/cpumask.c
@@ -193,80 +193,81 @@ void __init free_bootmem_cpumask_var(cpu
 }
 #endif
 
-static int find_nearest_node(int node, bool *used)
+static int find_nearest_node(int node, nodemask_t nodes)
 {
 	int i, min_dist, node_id = -1;
 
 	/* Choose the first unused node to compare */
-	for (i = 0; i < nr_node_ids; i++) {
-		if (used[i] == false) {
+	for (i = 0; i < nr_node_ids; i++)
+		if (!node_isset(i, nodes)) {
 			min_dist = node_distance(node, i);
 			node_id = i;
 			break;
 		}
-	}
 
 	/* Compare and return the nearest node */
-	for (i = 0; i < nr_node_ids; i++) {
-		if (node_distance(node, i) < min_dist && used[i] == false) {
+	for (i = 0; i < nr_node_ids; i++)
+		if (!node_isset(i, nodes) &&
+			node_distance(node, i) < min_dist) {
 			min_dist = node_distance(node, i);
 			node_id = i;
 		}
-	}
 
 	return node_id;
 }
 
 /**
  * cpumask_local_spread - select the i'th cpu with local numa cpu's first
- * @i: index number
+ * @cpu_index: index number
  * @node: local numa_node
  *
  * This function selects an online CPU according to a numa aware policy;
- * local cpus are returned first, followed by the next one which is the
- * nearest unused NUMA node based on NUMA distance, then it wraps around.
+ * Loop through all the online CPUs on the system. Start with the CPUs on
+ * 'node', then fall back to CPUs on NUMA nodes which are increasingly far
+ * away.
  *
- * It's not very efficient, but useful for setup.
+ * This function is not very efficient, especially for large 'cpu_index'
+ * because it loops over the same CPUs on each call and does not remember
+ * its state from previous calls, but it is useful for setup.
  */
-unsigned int cpumask_local_spread(unsigned int i, int node)
+unsigned int cpumask_local_spread(unsigned int cpu_index, int node)
 {
-	static DEFINE_SPINLOCK(spread_lock);
-	static bool used[MAX_NUMNODES];
-	unsigned long flags;
-	int cpu, hk_flags, j, id;
+	int cpu, hk_flags, j, ncpus, id;
 	const struct cpumask *mask;
+	struct cpumask nmsk;
+	nodemask_t nodes_msk;
 
 	hk_flags = HK_FLAG_DOMAIN | HK_FLAG_MANAGED_IRQ;
 	mask = housekeeping_cpumask(hk_flags);
 	/* Wrap: we always want a cpu. */
-	i %= cpumask_weight(mask);
+	cpu_index %= cpumask_weight(mask);
 
 	if (node == NUMA_NO_NODE) {
 		for_each_cpu(cpu, mask) {
-			if (i-- == 0)
+			if (cpu_index-- == 0)
 				return cpu;
 		}
 	} else {
-		spin_lock_irqsave(&spread_lock, flags);
-		memset(used, 0, nr_node_ids * sizeof(bool));
 		/* select node according to the distance from local node */
+		nodes_clear(nodes_msk);
 		for (j = 0; j < nr_node_ids; j++) {
-			id = find_nearest_node(node, used);
+			id = find_nearest_node(node, nodes_msk);
 			if (id < 0)
 				break;
-
-			for_each_cpu_and(cpu, cpumask_of_node(id), mask)
-				if (i-- == 0) {
-					spin_unlock_irqrestore(&spread_lock,
-							       flags);
+			cpumask_and(&nmsk, mask, cpumask_of_node(id));
+			ncpus = cpumask_weight(&nmsk);
+			if (cpu_index >= ncpus) {
+				cpu_index -= ncpus;
+				node_set(id, nodes_msk);
+				continue;
+			}
+			for_each_cpu(cpu, &nmsk)
+				if (cpu_index-- == 0)
 					return cpu;
-				}
-			used[id] = true;
 		}
-		spin_unlock_irqrestore(&spread_lock, flags);
 
 		for_each_cpu(cpu, mask)
-			if (i-- == 0)
+			if (cpu_index-- == 0)
 				return cpu;
 	}
 	BUG();
_

Patches currently in -mm which might be from jinyuqi@huawei.com are

lib-optimize-cpumask_local_spread.patch
lib-optimize-cpumask_local_spread-v8.patch

