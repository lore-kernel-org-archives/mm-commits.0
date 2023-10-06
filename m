Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75CB3E94130
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbjJFVsS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233769AbjJFVsR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:48:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6260FBD
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:48:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E697C433C7;
        Fri,  6 Oct 2023 21:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628896;
        bh=RKbJjEg9wuAhhg8Jk7KXSevwZYTE9LDCh6KHh2p2Izs=;
        h=Date:To:From:Subject:From;
        b=pD7evWisZ3IixIsS6pV+zTYUpq2ejePH4oIp4kblFwzMbt0utus0glJvy470aN8Gp
         FTJmbqe+qgxreRgMVZOyV0ODqla6KmA0XzENdLdFW1EMHHwNcitLKmVMXhUJZklid5
         jk7PVo6fFzd4ku4rCHTcbWLfet8fOu0KAR0c26l4=
Date:   Fri, 06 Oct 2023 14:48:13 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sched-numa-mm-make-numa-migrate-functions-to-take-a-folio.patch removed from -mm tree
Message-Id: <20231006214815.9E697C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sched/numa, mm: make numa migrate functions to take a folio
has been removed from the -mm tree.  Its filename was
     sched-numa-mm-make-numa-migrate-functions-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: sched/numa, mm: make numa migrate functions to take a folio
Date: Thu, 21 Sep 2023 15:44:17 +0800

The cpupid (or access time) is stored in the head page for THP, so it is
safely to make should_numa_migrate_memory() and numa_hint_fault_latency()
to take a folio.  This is in preparation for large folio numa balancing.

Link: https://lkml.kernel.org/r/20230921074417.24004-7-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/numa_balancing.h |    6 +++---
 kernel/sched/fair.c                  |   12 ++++++------
 mm/mempolicy.c                       |    2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

--- a/include/linux/sched/numa_balancing.h~sched-numa-mm-make-numa-migrate-functions-to-take-a-folio
+++ a/include/linux/sched/numa_balancing.h
@@ -20,8 +20,8 @@ extern void task_numa_fault(int last_nod
 extern pid_t task_numa_group_id(struct task_struct *p);
 extern void set_numabalancing_state(bool enabled);
 extern void task_numa_free(struct task_struct *p, bool final);
-extern bool should_numa_migrate_memory(struct task_struct *p, struct page *page,
-					int src_nid, int dst_cpu);
+bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
+				int src_nid, int dst_cpu);
 #else
 static inline void task_numa_fault(int last_node, int node, int pages,
 				   int flags)
@@ -38,7 +38,7 @@ static inline void task_numa_free(struct
 {
 }
 static inline bool should_numa_migrate_memory(struct task_struct *p,
-				struct page *page, int src_nid, int dst_cpu)
+				struct folio *folio, int src_nid, int dst_cpu)
 {
 	return true;
 }
--- a/kernel/sched/fair.c~sched-numa-mm-make-numa-migrate-functions-to-take-a-folio
+++ a/kernel/sched/fair.c
@@ -1722,12 +1722,12 @@ static bool pgdat_free_space_enough(stru
  * The smaller the hint page fault latency, the higher the possibility
  * for the page to be hot.
  */
-static int numa_hint_fault_latency(struct page *page)
+static int numa_hint_fault_latency(struct folio *folio)
 {
 	int last_time, time;
 
 	time = jiffies_to_msecs(jiffies);
-	last_time = xchg_page_access_time(page, time);
+	last_time = xchg_page_access_time(&folio->page, time);
 
 	return (time - last_time) & PAGE_ACCESS_TIME_MASK;
 }
@@ -1784,7 +1784,7 @@ static void numa_promotion_adjust_thresh
 	}
 }
 
-bool should_numa_migrate_memory(struct task_struct *p, struct page * page,
+bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 				int src_nid, int dst_cpu)
 {
 	struct numa_group *ng = deref_curr_numa_group(p);
@@ -1814,16 +1814,16 @@ bool should_numa_migrate_memory(struct t
 		numa_promotion_adjust_threshold(pgdat, rate_limit, def_th);
 
 		th = pgdat->nbp_threshold ? : def_th;
-		latency = numa_hint_fault_latency(page);
+		latency = numa_hint_fault_latency(folio);
 		if (latency >= th)
 			return false;
 
 		return !numa_promotion_rate_limit(pgdat, rate_limit,
-						  thp_nr_pages(page));
+						  folio_nr_pages(folio));
 	}
 
 	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
-	last_cpupid = page_cpupid_xchg_last(page, this_cpupid);
+	last_cpupid = page_cpupid_xchg_last(&folio->page, this_cpupid);
 
 	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
 	    !node_is_toptier(src_nid) && !cpupid_valid(last_cpupid))
--- a/mm/mempolicy.c~sched-numa-mm-make-numa-migrate-functions-to-take-a-folio
+++ a/mm/mempolicy.c
@@ -2642,7 +2642,7 @@ int mpol_misplaced(struct folio *folio,
 	if (pol->flags & MPOL_F_MORON) {
 		polnid = thisnid;
 
-		if (!should_numa_migrate_memory(current, &folio->page, curnid,
+		if (!should_numa_migrate_memory(current, folio, curnid,
 						thiscpu))
 			goto out;
 	}
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


