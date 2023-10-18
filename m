Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A71ECDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235319AbjJRVhe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235322AbjJRVgv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2750F1B5
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC178C433C8;
        Wed, 18 Oct 2023 21:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664954;
        bh=FdH6EJefVP60mnLzp8bmZ69cVPHNY1Ybeq8wlfxQV+k=;
        h=Date:To:From:Subject:From;
        b=itGqqdW/Znzh307cmGSEmuzpgADbbM3FpVI/ztAFfmkuEbKqM4AX5TuzXUOORFayJ
         KneflYr6xRaYfmE4Pu0a0ruOWIfnHQ5XIJRKfusLUAqv3wzLo/SaDggYR8cqqPlHyw
         PkS7B9NHWmVRKuiMw1Qqc+HU+95o1JtIQUWWObQk=
Date:   Wed, 18 Oct 2023 14:35:54 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com, tj@kernel.org,
        shuah@kernel.org, shakeelb@google.com, roman.gushchin@linux.dev,
        riel@surriel.com, muchun.song@linux.dev, mike.kravetz@oracle.com,
        mhocko@suse.com, lizefan.x@bytedance.com, hannes@cmpxchg.org,
        fvdl@google.com, nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-memcg-account-hugetlb-backed-memory-in-memory-controller.patch removed from -mm tree
Message-Id: <20231018213554.AC178C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: memcg: account hugetlb-backed memory in memory controller
has been removed from the -mm tree.  Its filename was
     hugetlb-memcg-account-hugetlb-backed-memory-in-memory-controller.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: hugetlb: memcg: account hugetlb-backed memory in memory controller
Date: Fri, 6 Oct 2023 11:46:28 -0700

Currently, hugetlb memory usage is not acounted for in the memory
controller, which could lead to memory overprotection for cgroups with
hugetlb-backed memory.  This has been observed in our production system.

For instance, here is one of our usecases: suppose there are two 32G
containers.  The machine is booted with hugetlb_cma=6G, and each container
may or may not use up to 3 gigantic page, depending on the workload within
it.  The rest is anon, cache, slab, etc.  We can set the hugetlb cgroup
limit of each cgroup to 3G to enforce hugetlb fairness.  But it is very
difficult to configure memory.max to keep overall consumption, including
anon, cache, slab etc.  fair.

What we have had to resort to is to constantly poll hugetlb usage and
readjust memory.max.  Similar procedure is done to other memory limits
(memory.low for e.g).  However, this is rather cumbersome and buggy. 
Furthermore, when there is a delay in memory limits correction, (for e.g
when hugetlb usage changes within consecutive runs of the userspace
agent), the system could be in an over/underprotected state.

This patch rectifies this issue by charging the memcg when the hugetlb
folio is utilized, and uncharging when the folio is freed (analogous to
the hugetlb controller).  Note that we do not charge when the folio is
allocated to the hugetlb pool, because at this point it is not owned by
any memcg.

Some caveats to consider:
  * This feature is only available on cgroup v2.
  * There is no hugetlb pool management involved in the memory
    controller. As stated above, hugetlb folios are only charged towards
    the memory controller when it is used. Host overcommit management
    has to consider it when configuring hard limits.
  * Failure to charge towards the memcg results in SIGBUS. This could
    happen even if the hugetlb pool still has pages (but the cgroup
    limit is hit and reclaim attempt fails).
  * When this feature is enabled, hugetlb pages contribute to memory
    reclaim protection. low, min limits tuning must take into account
    hugetlb memory.
  * Hugetlb pages utilized while this option is not selected will not
    be tracked by the memory controller (even if cgroup v2 is remounted
    later on).

Link: https://lkml.kernel.org/r/20231006184629.155543-4-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Michal Hocko <mhocko@suse.com>
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

 Documentation/admin-guide/cgroup-v2.rst |   29 +++++++++++++++
 include/linux/cgroup-defs.h             |    5 ++
 include/linux/memcontrol.h              |    9 ++++
 kernel/cgroup/cgroup.c                  |   15 +++++++
 mm/hugetlb.c                            |   35 ++++++++++++++----
 mm/memcontrol.c                         |   42 +++++++++++++++++++++-
 mm/migrate.c                            |    3 -
 7 files changed, 127 insertions(+), 11 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~hugetlb-memcg-account-hugetlb-backed-memory-in-memory-controller
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -210,6 +210,35 @@ cgroup v2 currently supports the followi
         relying on the original semantics (e.g. specifying bogusly
         high 'bypass' protection values at higher tree levels).
 
+  memory_hugetlb_accounting
+        Count HugeTLB memory usage towards the cgroup's overall
+        memory usage for the memory controller (for the purpose of
+        statistics reporting and memory protetion). This is a new
+        behavior that could regress existing setups, so it must be
+        explicitly opted in with this mount option.
+
+        A few caveats to keep in mind:
+
+        * There is no HugeTLB pool management involved in the memory
+          controller. The pre-allocated pool does not belong to anyone.
+          Specifically, when a new HugeTLB folio is allocated to
+          the pool, it is not accounted for from the perspective of the
+          memory controller. It is only charged to a cgroup when it is
+          actually used (for e.g at page fault time). Host memory
+          overcommit management has to consider this when configuring
+          hard limits. In general, HugeTLB pool management should be
+          done via other mechanisms (such as the HugeTLB controller).
+        * Failure to charge a HugeTLB folio to the memory controller
+          results in SIGBUS. This could happen even if the HugeTLB pool
+          still has pages available (but the cgroup limit is hit and
+          reclaim attempt fails).
+        * Charging HugeTLB memory towards the memory controller affects
+          memory protection and reclaim dynamics. Any userspace tuning
+          (of low, min limits for e.g) needs to take this into account.
+        * HugeTLB pages utilized while this option is not selected
+          will not be tracked by the memory controller (even if cgroup
+          v2 is remounted later on).
+
 
 Organizing Processes and Threads
 --------------------------------
--- a/include/linux/cgroup-defs.h~hugetlb-memcg-account-hugetlb-backed-memory-in-memory-controller
+++ a/include/linux/cgroup-defs.h
@@ -115,6 +115,11 @@ enum {
 	 * Enable recursive subtree protection
 	 */
 	CGRP_ROOT_MEMORY_RECURSIVE_PROT = (1 << 18),
+
+	/*
+	 * Enable hugetlb accounting for the memory controller.
+	 */
+	 CGRP_ROOT_MEMORY_HUGETLB_ACCOUNTING = (1 << 19),
 };
 
 /* cftype->flags */
--- a/include/linux/memcontrol.h~hugetlb-memcg-account-hugetlb-backed-memory-in-memory-controller
+++ a/include/linux/memcontrol.h
@@ -678,6 +678,9 @@ static inline int mem_cgroup_charge(stru
 	return __mem_cgroup_charge(folio, mm, gfp);
 }
 
+int mem_cgroup_hugetlb_try_charge(struct mem_cgroup *memcg, gfp_t gfp,
+		long nr_pages);
+
 int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
 				  gfp_t gfp, swp_entry_t entry);
 void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry);
@@ -1257,6 +1260,12 @@ static inline int mem_cgroup_charge(stru
 {
 	return 0;
 }
+
+static inline int mem_cgroup_hugetlb_try_charge(struct mem_cgroup *memcg,
+		gfp_t gfp, long nr_pages)
+{
+	return 0;
+}
 
 static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
 			struct mm_struct *mm, gfp_t gfp, swp_entry_t entry)
--- a/kernel/cgroup/cgroup.c~hugetlb-memcg-account-hugetlb-backed-memory-in-memory-controller
+++ a/kernel/cgroup/cgroup.c
@@ -1902,6 +1902,7 @@ enum cgroup2_param {
 	Opt_favordynmods,
 	Opt_memory_localevents,
 	Opt_memory_recursiveprot,
+	Opt_memory_hugetlb_accounting,
 	nr__cgroup2_params
 };
 
@@ -1910,6 +1911,7 @@ static const struct fs_parameter_spec cg
 	fsparam_flag("favordynmods",		Opt_favordynmods),
 	fsparam_flag("memory_localevents",	Opt_memory_localevents),
 	fsparam_flag("memory_recursiveprot",	Opt_memory_recursiveprot),
+	fsparam_flag("memory_hugetlb_accounting", Opt_memory_hugetlb_accounting),
 	{}
 };
 
@@ -1936,6 +1938,9 @@ static int cgroup2_parse_param(struct fs
 	case Opt_memory_recursiveprot:
 		ctx->flags |= CGRP_ROOT_MEMORY_RECURSIVE_PROT;
 		return 0;
+	case Opt_memory_hugetlb_accounting:
+		ctx->flags |= CGRP_ROOT_MEMORY_HUGETLB_ACCOUNTING;
+		return 0;
 	}
 	return -EINVAL;
 }
@@ -1960,6 +1965,11 @@ static void apply_cgroup_root_flags(unsi
 			cgrp_dfl_root.flags |= CGRP_ROOT_MEMORY_RECURSIVE_PROT;
 		else
 			cgrp_dfl_root.flags &= ~CGRP_ROOT_MEMORY_RECURSIVE_PROT;
+
+		if (root_flags & CGRP_ROOT_MEMORY_HUGETLB_ACCOUNTING)
+			cgrp_dfl_root.flags |= CGRP_ROOT_MEMORY_HUGETLB_ACCOUNTING;
+		else
+			cgrp_dfl_root.flags &= ~CGRP_ROOT_MEMORY_HUGETLB_ACCOUNTING;
 	}
 }
 
@@ -1973,6 +1983,8 @@ static int cgroup_show_options(struct se
 		seq_puts(seq, ",memory_localevents");
 	if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_RECURSIVE_PROT)
 		seq_puts(seq, ",memory_recursiveprot");
+	if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_HUGETLB_ACCOUNTING)
+		seq_puts(seq, ",memory_hugetlb_accounting");
 	return 0;
 }
 
@@ -7050,7 +7062,8 @@ static ssize_t features_show(struct kobj
 			"nsdelegate\n"
 			"favordynmods\n"
 			"memory_localevents\n"
-			"memory_recursiveprot\n");
+			"memory_recursiveprot\n"
+			"memory_hugetlb_accounting\n");
 }
 static struct kobj_attribute cgroup_features_attr = __ATTR_RO(features);
 
--- a/mm/hugetlb.c~hugetlb-memcg-account-hugetlb-backed-memory-in-memory-controller
+++ a/mm/hugetlb.c
@@ -1927,6 +1927,7 @@ void free_huge_folio(struct folio *folio
 				     pages_per_huge_page(h), folio);
 	hugetlb_cgroup_uncharge_folio_rsvd(hstate_index(h),
 					  pages_per_huge_page(h), folio);
+	mem_cgroup_uncharge(folio);
 	if (restore_reserve)
 		h->resv_huge_pages++;
 
@@ -3026,11 +3027,20 @@ struct folio *alloc_hugetlb_folio(struct
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
 	struct folio *folio;
-	long map_chg, map_commit;
+	long map_chg, map_commit, nr_pages = pages_per_huge_page(h);
 	long gbl_chg;
-	int ret, idx;
+	int memcg_charge_ret, ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
+	struct mem_cgroup *memcg;
 	bool deferred_reserve;
+	gfp_t gfp = htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
+
+	memcg = get_mem_cgroup_from_current();
+	memcg_charge_ret = mem_cgroup_hugetlb_try_charge(memcg, gfp, nr_pages);
+	if (memcg_charge_ret == -ENOMEM) {
+		mem_cgroup_put(memcg);
+		return ERR_PTR(-ENOMEM);
+	}
 
 	idx = hstate_index(h);
 	/*
@@ -3039,8 +3049,12 @@ struct folio *alloc_hugetlb_folio(struct
 	 * code of zero indicates a reservation exists (no change).
 	 */
 	map_chg = gbl_chg = vma_needs_reservation(h, vma, addr);
-	if (map_chg < 0)
+	if (map_chg < 0) {
+		if (!memcg_charge_ret)
+			mem_cgroup_cancel_charge(memcg, nr_pages);
+		mem_cgroup_put(memcg);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	/*
 	 * Processes that did not create the mapping will have no
@@ -3051,10 +3065,8 @@ struct folio *alloc_hugetlb_folio(struct
 	 */
 	if (map_chg || avoid_reserve) {
 		gbl_chg = hugepage_subpool_get_pages(spool, 1);
-		if (gbl_chg < 0) {
-			vma_end_reservation(h, vma, addr);
-			return ERR_PTR(-ENOSPC);
-		}
+		if (gbl_chg < 0)
+			goto out_end_reservation;
 
 		/*
 		 * Even though there was no reservation in the region/reserve
@@ -3136,6 +3148,11 @@ struct folio *alloc_hugetlb_folio(struct
 			hugetlb_cgroup_uncharge_folio_rsvd(hstate_index(h),
 					pages_per_huge_page(h), folio);
 	}
+
+	if (!memcg_charge_ret)
+		mem_cgroup_commit_charge(folio, memcg);
+	mem_cgroup_put(memcg);
+
 	return folio;
 
 out_uncharge_cgroup:
@@ -3147,7 +3164,11 @@ out_uncharge_cgroup_reservation:
 out_subpool_put:
 	if (map_chg || avoid_reserve)
 		hugepage_subpool_put_pages(spool, 1);
+out_end_reservation:
 	vma_end_reservation(h, vma, addr);
+	if (!memcg_charge_ret)
+		mem_cgroup_cancel_charge(memcg, nr_pages);
+	mem_cgroup_put(memcg);
 	return ERR_PTR(-ENOSPC);
 }
 
--- a/mm/memcontrol.c~hugetlb-memcg-account-hugetlb-backed-memory-in-memory-controller
+++ a/mm/memcontrol.c
@@ -7097,6 +7097,41 @@ int __mem_cgroup_charge(struct folio *fo
 }
 
 /**
+ * mem_cgroup_hugetlb_try_charge - try to charge the memcg for a hugetlb folio
+ * @memcg: memcg to charge.
+ * @gfp: reclaim mode.
+ * @nr_pages: number of pages to charge.
+ *
+ * This function is called when allocating a huge page folio to determine if
+ * the memcg has the capacity for it. It does not commit the charge yet,
+ * as the hugetlb folio itself has not been obtained from the hugetlb pool.
+ *
+ * Once we have obtained the hugetlb folio, we can call
+ * mem_cgroup_commit_charge() to commit the charge. If we fail to obtain the
+ * folio, we should instead call mem_cgroup_cancel_charge() to undo the effect
+ * of try_charge().
+ *
+ * Returns 0 on success. Otherwise, an error code is returned.
+ */
+int mem_cgroup_hugetlb_try_charge(struct mem_cgroup *memcg, gfp_t gfp,
+			long nr_pages)
+{
+	/*
+	 * If hugetlb memcg charging is not enabled, do not fail hugetlb allocation,
+	 * but do not attempt to commit charge later (or cancel on error) either.
+	 */
+	if (mem_cgroup_disabled() || !memcg ||
+		!cgroup_subsys_on_dfl(memory_cgrp_subsys) ||
+		!(cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_HUGETLB_ACCOUNTING))
+		return -EOPNOTSUPP;
+
+	if (try_charge(memcg, gfp, nr_pages))
+		return -ENOMEM;
+
+	return 0;
+}
+
+/**
  * mem_cgroup_swapin_charge_folio - Charge a newly allocated folio for swapin.
  * @folio: folio to charge.
  * @mm: mm context of the victim
@@ -7365,7 +7400,12 @@ void mem_cgroup_migrate(struct folio *ol
 		return;
 
 	memcg = folio_memcg(old);
-	VM_WARN_ON_ONCE_FOLIO(!memcg, old);
+	/*
+	 * Note that it is normal to see !memcg for a hugetlb folio.
+	 * For e.g, itt could have been allocated when memory_hugetlb_accounting
+	 * was not selected.
+	 */
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(old) && !memcg, old);
 	if (!memcg)
 		return;
 
--- a/mm/migrate.c~hugetlb-memcg-account-hugetlb-backed-memory-in-memory-controller
+++ a/mm/migrate.c
@@ -633,8 +633,7 @@ void folio_migrate_flags(struct folio *n
 
 	folio_copy_owner(newfolio, folio);
 
-	if (!folio_test_hugetlb(folio))
-		mem_cgroup_migrate(folio, newfolio);
+	mem_cgroup_migrate(folio, newfolio);
 }
 EXPORT_SYMBOL(folio_migrate_flags);
 
_

Patches currently in -mm which might be from nphamcs@gmail.com are

mm-list_lru-allow-external-numa-node-and-cgroup-tracking.patch
zswap-shrinks-zswap-pool-based-on-memory-pressure.patch

