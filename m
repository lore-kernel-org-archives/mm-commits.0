Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92376E7D0BE
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 01:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjIVBit (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Sep 2023 21:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjIVBir (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Sep 2023 21:38:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A08102
        for <mm-commits@vger.kernel.org>; Thu, 21 Sep 2023 18:38:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0858C433C7;
        Fri, 22 Sep 2023 01:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695346721;
        bh=8BzggXkLzXyRrC3GEbIqPCrZh5aS1dU7TCU+0BpMQso=;
        h=Date:To:From:Subject:From;
        b=QFS95WK/wdi/KVa5EPtLJSbR2fmqrVFvyNKwGD9cfbNcLrAdr+C3QrFfaNV7ertCP
         SWj888TJubvdoKLk6XdST/NitjLTKig36zoNUy0KtaMw5Zd/GLuuQflq/QckiBaCDX
         teIPrcIinKoxPWqMv0ktufpY8KGF7094usD5r32k=
Date:   Thu, 21 Sep 2023 18:38:40 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sched-numa-mm-make-numa-migrate-functions-to-take-a-folio.patch added to mm-unstable branch
Message-Id: <20230922013840.E0858C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sched/numa, mm: make numa migrate functions to take a folio
has been added to the -mm mm-unstable branch.  Its filename is
     sched-numa-mm-make-numa-migrate-functions-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sched-numa-mm-make-numa-migrate-functions-to-take-a-folio.patch

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
@@ -2646,7 +2646,7 @@ int mpol_misplaced(struct folio *folio,
 	if (pol->flags & MPOL_F_MORON) {
 		polnid = thisnid;
 
-		if (!should_numa_migrate_memory(current, &folio->page, curnid,
+		if (!should_numa_migrate_memory(current, folio, curnid,
 						thiscpu))
 			goto out;
 	}
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-migrate-remove-pagetranshuge-check-in-numamigrate_isolate_page.patch
mm-migrate-remove-thp-mapcount-check-in-numamigrate_isolate_page.patch
mm-migrate-convert-numamigrate_isolate_page-to-numamigrate_isolate_folio.patch
mm-migrate-convert-migrate_misplaced_page-to-migrate_misplaced_folio.patch
mm-migrate-use-__folio_test_movable.patch
mm-migrate-use-a-folio-in-add_page_for_migration.patch
mm-migrate-remove-pagehead-check-for-hugetlb-in-add_page_for_migration.patch
mm-migrate-remove-isolated-variable-in-add_page_for_migration.patch
mm-memory-add-vm_normal_folio_pmd.patch
mm-huge_memory-use-a-folio-in-do_huge_pmd_numa_page.patch
mm-memory-use-a-folio-in-do_numa_page.patch
mm-memory-make-numa_migrate_prep-to-take-a-folio.patch
mm-mempolicy-make-mpol_misplaced-to-take-a-folio.patch
sched-numa-mm-make-numa-migrate-functions-to-take-a-folio.patch

