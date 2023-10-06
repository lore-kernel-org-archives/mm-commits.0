Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B628E94108
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbjJFTUb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbjJFTUR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:20:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E889E
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 12:20:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B517C433C9;
        Fri,  6 Oct 2023 19:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696620014;
        bh=Z9SCuU0KaGTkvUaxO34ulHgiaBLwAnem/XgH11/7yUo=;
        h=Date:To:From:Subject:From;
        b=iDc1Y/j30zprZqfLnQ7b99QxIfVl1YMss+6auUb9uI4fu1jM9PZvRVviZa9SiuS/2
         r1fmZmILAgHZ0wtbYQTMvJm8V7+FLXqmI239XsrT8DbioGXe2YlArUUGiz9Fid9hRv
         MZaDg9rCPcbRs/BnqPVIiH1bmbGlO3/FooCQZlHM=
Date:   Fri, 06 Oct 2023 12:20:12 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com, tj@kernel.org,
        shuah@kernel.org, shakeelb@google.com, roman.gushchin@linux.dev,
        riel@surriel.com, muchun.song@linux.dev, mike.kravetz@oracle.com,
        mhocko@suse.com, lizefan.x@bytedance.com, hannes@cmpxchg.org,
        fvdl@google.com, nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcontrol-add-helpers-for-hugetlb-memcg-accounting.patch added to mm-unstable branch
Message-Id: <20231006192014.7B517C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcontrol: add helpers for hugetlb memcg accounting
has been added to the -mm mm-unstable branch.  Its filename is
     memcontrol-add-helpers-for-hugetlb-memcg-accounting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcontrol-add-helpers-for-hugetlb-memcg-accounting.patch

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
From: Nhat Pham <nphamcs@gmail.com>
Subject: memcontrol: add helpers for hugetlb memcg accounting
Date: Fri, 6 Oct 2023 11:46:26 -0700

Patch series "hugetlb memcg accounting", v4.

Currently, hugetlb memory usage is not acounted for in the memory
controller, which could lead to memory overprotection for cgroups with
hugetlb-backed memory.  This has been observed in our production system.

For instance, here is one of our usecases: suppose there are two 32G
containers.  The machine is booted with hugetlb_cma=6G, and each container
may or may not use up to 3 gigantic page, depending on the workload within
it.  The rest is anon, cache, slab, etc.  We can set the hugetlb cgroup
limit of each cgroup to 3G to enforce hugetlb fairness.  But it is very
difficult to configure memory.max to keep overall consumption, including
anon, cache, slab etcetera fair.

What we have had to resort to is to constantly poll hugetlb usage and
readjust memory.max.  Similar procedure is done to other memory limits
(memory.low for e.g).  However, this is rather cumbersome and buggy. 
Furthermore, when there is a delay in memory limits correction, (for e.g
when hugetlb usage changes within consecutive runs of the userspace
agent), the system could be in an over/underprotected state.

This patch series rectifies this issue by charging the memcg when the
hugetlb folio is allocated, and uncharging when the folio is freed.  In
addition, a new selftest is added to demonstrate and verify this new
behavior.


This patch (of 4):

This patch exposes charge committing and cancelling as parts of the memory
controller interface.  These functionalities are useful when the
try_charge() and commit_charge() stages have to be separated by other
actions in between (which can fail).  One such example is the new hugetlb
accounting behavior in the following patch.

The patch also adds a helper function to obtain a reference to the
current task's memcg.

Link: https://lkml.kernel.org/r/20231006184629.155543-1-nphamcs@gmail.com
Link: https://lkml.kernel.org/r/20231006184629.155543-2-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun heo <tj@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   21 ++++++++++++
 mm/memcontrol.c            |   59 +++++++++++++++++++++++++++--------
 2 files changed, 68 insertions(+), 12 deletions(-)

--- a/include/linux/memcontrol.h~memcontrol-add-helpers-for-hugetlb-memcg-accounting
+++ a/include/linux/memcontrol.h
@@ -669,6 +669,8 @@ static inline bool mem_cgroup_below_min(
 		page_counter_read(&memcg->memory);
 }
 
+void mem_cgroup_commit_charge(struct folio *folio, struct mem_cgroup *memcg);
+
 int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp);
 
 /**
@@ -720,6 +722,8 @@ static inline void mem_cgroup_uncharge_l
 	__mem_cgroup_uncharge_list(page_list);
 }
 
+void mem_cgroup_cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages);
+
 void mem_cgroup_migrate(struct folio *old, struct folio *new);
 
 /**
@@ -776,6 +780,8 @@ struct mem_cgroup *mem_cgroup_from_task(
 
 struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm);
 
+struct mem_cgroup *get_mem_cgroup_from_current(void);
+
 struct lruvec *folio_lruvec_lock(struct folio *folio);
 struct lruvec *folio_lruvec_lock_irq(struct folio *folio);
 struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
@@ -1261,6 +1267,11 @@ static inline bool mem_cgroup_below_min(
 	return false;
 }
 
+static inline void mem_cgroup_commit_charge(struct folio *folio,
+		struct mem_cgroup *memcg)
+{
+}
+
 static inline int mem_cgroup_charge(struct folio *folio,
 		struct mm_struct *mm, gfp_t gfp)
 {
@@ -1285,6 +1296,11 @@ static inline void mem_cgroup_uncharge_l
 {
 }
 
+static inline void mem_cgroup_cancel_charge(struct mem_cgroup *memcg,
+		unsigned int nr_pages)
+{
+}
+
 static inline void mem_cgroup_migrate(struct folio *old, struct folio *new)
 {
 }
@@ -1321,6 +1337,11 @@ static inline struct mem_cgroup *get_mem
 {
 	return NULL;
 }
+
+static inline struct mem_cgroup *get_mem_cgroup_from_current(void)
+{
+	return NULL;
+}
 
 static inline
 struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *css)
--- a/mm/memcontrol.c~memcontrol-add-helpers-for-hugetlb-memcg-accounting
+++ a/mm/memcontrol.c
@@ -1088,6 +1088,27 @@ struct mem_cgroup *get_mem_cgroup_from_m
 EXPORT_SYMBOL(get_mem_cgroup_from_mm);
 
 /**
+ * get_mem_cgroup_from_current - Obtain a reference on current task's memcg.
+ */
+struct mem_cgroup *get_mem_cgroup_from_current(void)
+{
+	struct mem_cgroup *memcg;
+
+	if (mem_cgroup_disabled())
+		return NULL;
+
+again:
+	rcu_read_lock();
+	memcg = mem_cgroup_from_task(current);
+	if (!css_tryget(&memcg->css)) {
+		rcu_read_unlock();
+		goto again;
+	}
+	rcu_read_unlock();
+	return memcg;
+}
+
+/**
  * mem_cgroup_iter - iterate over memory cgroup hierarchy
  * @root: hierarchy root
  * @prev: previously returned memcg, NULL on first invocation
@@ -2862,7 +2883,12 @@ static inline int try_charge(struct mem_
 	return try_charge_memcg(memcg, gfp_mask, nr_pages);
 }
 
-static inline void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
+/**
+ * mem_cgroup_cancel_charge() - cancel an uncommitted try_charge() call.
+ * @memcg: memcg previously charged.
+ * @nr_pages: number of pages previously charged.
+ */
+void mem_cgroup_cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	if (mem_cgroup_is_root(memcg))
 		return;
@@ -2887,6 +2913,22 @@ static void commit_charge(struct folio *
 	folio->memcg_data = (unsigned long)memcg;
 }
 
+/**
+ * mem_cgroup_commit_charge - commit a previously successful try_charge().
+ * @folio: folio to commit the charge to.
+ * @memcg: memcg previously charged.
+ */
+void mem_cgroup_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
+{
+	css_get(&memcg->css);
+	commit_charge(folio, memcg);
+
+	local_irq_disable();
+	mem_cgroup_charge_statistics(memcg, folio_nr_pages(folio));
+	memcg_check_events(memcg, folio_nid(folio));
+	local_irq_enable();
+}
+
 #ifdef CONFIG_MEMCG_KMEM
 /*
  * The allocated objcg pointers array is not accounted directly.
@@ -6211,7 +6253,7 @@ static void __mem_cgroup_clear_mc(void)
 
 	/* we must uncharge all the leftover precharges from mc.to */
 	if (mc.precharge) {
-		cancel_charge(mc.to, mc.precharge);
+		mem_cgroup_cancel_charge(mc.to, mc.precharge);
 		mc.precharge = 0;
 	}
 	/*
@@ -6219,7 +6261,7 @@ static void __mem_cgroup_clear_mc(void)
 	 * we must uncharge here.
 	 */
 	if (mc.moved_charge) {
-		cancel_charge(mc.from, mc.moved_charge);
+		mem_cgroup_cancel_charge(mc.from, mc.moved_charge);
 		mc.moved_charge = 0;
 	}
 	/* we must fixup refcnts and charges */
@@ -7175,20 +7217,13 @@ void mem_cgroup_calculate_protection(str
 static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
 			gfp_t gfp)
 {
-	long nr_pages = folio_nr_pages(folio);
 	int ret;
 
-	ret = try_charge(memcg, gfp, nr_pages);
+	ret = try_charge(memcg, gfp, folio_nr_pages(folio));
 	if (ret)
 		goto out;
 
-	css_get(&memcg->css);
-	commit_charge(folio, memcg);
-
-	local_irq_disable();
-	mem_cgroup_charge_statistics(memcg, nr_pages);
-	memcg_check_events(memcg, folio_nid(folio));
-	local_irq_enable();
+	mem_cgroup_commit_charge(folio, memcg);
 out:
 	return ret;
 }
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zswap-shrinks-zswap-pool-based-on-memory-pressure.patch
memcontrol-add-helpers-for-hugetlb-memcg-accounting.patch
memcontrol-only-transfer-the-memcg-data-for-migration.patch
hugetlb-memcg-account-hugetlb-backed-memory-in-memory-controller.patch
selftests-add-a-selftest-to-verify-hugetlb-usage-in-memcg.patch

