From: akpm@linux-foundation.org
Subject: [merged] mm-optimize-put_mems_allowed-usage.patch removed from
 -mm tree
Date: Fri, 04 Apr 2014 12:30:58 -0700
Message-ID: <533f0872.L7icD4yGvxHOOsxX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbaDDTa6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:30:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, a.p.zijlstra@chello.nl, mgorman@suse.de

Subject: [merged] mm-optimize-put_mems_allowed-usage.patch removed from -mm tree
To: mgorman@suse.de,a.p.zijlstra@chello.nl,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:30:58 -0700


The patch titled
     Subject: mm: optimize put_mems_allowed() usage
has been removed from the -mm tree.  Its filename was
     mm-optimize-put_mems_allowed-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: optimize put_mems_allowed() usage

Since put_mems_allowed() is strictly optional, its a seqcount retry, we
don't need to evaluate the function if the allocation was in fact
successful, saving a smp_rmb some loads and comparisons on some relative
fast-paths.

Since the naming, get/put_mems_allowed() does suggest a mandatory
pairing, rename the interface, as suggested by Mel, to resemble the
seqcount interface.

This gives us: read_mems_allowed_begin() and read_mems_allowed_retry(),
where it is important to note that the return value of the latter call is
inverted from its previous incarnation.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h |   27 ++++++++++++++-------------
 kernel/cpuset.c        |    2 +-
 mm/filemap.c           |    4 ++--
 mm/hugetlb.c           |    4 ++--
 mm/mempolicy.c         |   12 ++++++------
 mm/page_alloc.c        |    8 ++++----
 mm/slab.c              |    4 ++--
 mm/slub.c              |   16 +++++++---------
 8 files changed, 38 insertions(+), 39 deletions(-)

diff -puN include/linux/cpuset.h~mm-optimize-put_mems_allowed-usage include/linux/cpuset.h
--- a/include/linux/cpuset.h~mm-optimize-put_mems_allowed-usage
+++ a/include/linux/cpuset.h
@@ -87,25 +87,26 @@ extern void rebuild_sched_domains(void);
 extern void cpuset_print_task_mems_allowed(struct task_struct *p);
 
 /*
- * get_mems_allowed is required when making decisions involving mems_allowed
- * such as during page allocation. mems_allowed can be updated in parallel
- * and depending on the new value an operation can fail potentially causing
- * process failure. A retry loop with get_mems_allowed and put_mems_allowed
- * prevents these artificial failures.
+ * read_mems_allowed_begin is required when making decisions involving
+ * mems_allowed such as during page allocation. mems_allowed can be updated in
+ * parallel and depending on the new value an operation can fail potentially
+ * causing process failure. A retry loop with read_mems_allowed_begin and
+ * read_mems_allowed_retry prevents these artificial failures.
  */
-static inline unsigned int get_mems_allowed(void)
+static inline unsigned int read_mems_allowed_begin(void)
 {
 	return read_seqcount_begin(&current->mems_allowed_seq);
 }
 
 /*
- * If this returns false, the operation that took place after get_mems_allowed
- * may have failed. It is up to the caller to retry the operation if
+ * If this returns true, the operation that took place after
+ * read_mems_allowed_begin may have failed artificially due to a concurrent
+ * update of mems_allowed. It is up to the caller to retry the operation if
  * appropriate.
  */
-static inline bool put_mems_allowed(unsigned int seq)
+static inline bool read_mems_allowed_retry(unsigned int seq)
 {
-	return !read_seqcount_retry(&current->mems_allowed_seq, seq);
+	return read_seqcount_retry(&current->mems_allowed_seq, seq);
 }
 
 static inline void set_mems_allowed(nodemask_t nodemask)
@@ -225,14 +226,14 @@ static inline void set_mems_allowed(node
 {
 }
 
-static inline unsigned int get_mems_allowed(void)
+static inline unsigned int read_mems_allowed_begin(void)
 {
 	return 0;
 }
 
-static inline bool put_mems_allowed(unsigned int seq)
+static inline bool read_mems_allowed_retry(unsigned int seq)
 {
-	return true;
+	return false;
 }
 
 #endif /* !CONFIG_CPUSETS */
diff -puN kernel/cpuset.c~mm-optimize-put_mems_allowed-usage kernel/cpuset.c
--- a/kernel/cpuset.c~mm-optimize-put_mems_allowed-usage
+++ a/kernel/cpuset.c
@@ -1022,7 +1022,7 @@ static void cpuset_change_task_nodemask(
 	task_lock(tsk);
 	/*
 	 * Determine if a loop is necessary if another thread is doing
-	 * get_mems_allowed().  If at least one node remains unchanged and
+	 * read_mems_allowed_begin().  If at least one node remains unchanged and
 	 * tsk does not have a mempolicy, then an empty nodemask will not be
 	 * possible when mems_allowed is larger than a word.
 	 */
diff -puN mm/filemap.c~mm-optimize-put_mems_allowed-usage mm/filemap.c
--- a/mm/filemap.c~mm-optimize-put_mems_allowed-usage
+++ a/mm/filemap.c
@@ -520,10 +520,10 @@ struct page *__page_cache_alloc(gfp_t gf
 	if (cpuset_do_page_mem_spread()) {
 		unsigned int cpuset_mems_cookie;
 		do {
-			cpuset_mems_cookie = get_mems_allowed();
+			cpuset_mems_cookie = read_mems_allowed_begin();
 			n = cpuset_mem_spread_node();
 			page = alloc_pages_exact_node(n, gfp, 0);
-		} while (!put_mems_allowed(cpuset_mems_cookie) && !page);
+		} while (!page && read_mems_allowed_retry(cpuset_mems_cookie));
 
 		return page;
 	}
diff -puN mm/hugetlb.c~mm-optimize-put_mems_allowed-usage mm/hugetlb.c
--- a/mm/hugetlb.c~mm-optimize-put_mems_allowed-usage
+++ a/mm/hugetlb.c
@@ -540,7 +540,7 @@ static struct page *dequeue_huge_page_vm
 		goto err;
 
 retry_cpuset:
-	cpuset_mems_cookie = get_mems_allowed();
+	cpuset_mems_cookie = read_mems_allowed_begin();
 	zonelist = huge_zonelist(vma, address,
 					htlb_alloc_mask(h), &mpol, &nodemask);
 
@@ -562,7 +562,7 @@ retry_cpuset:
 	}
 
 	mpol_cond_put(mpol);
-	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 	return page;
 
diff -puN mm/mempolicy.c~mm-optimize-put_mems_allowed-usage mm/mempolicy.c
--- a/mm/mempolicy.c~mm-optimize-put_mems_allowed-usage
+++ a/mm/mempolicy.c
@@ -1899,7 +1899,7 @@ int node_random(const nodemask_t *maskp)
  * If the effective policy is 'BIND, returns a pointer to the mempolicy's
  * @nodemask for filtering the zonelist.
  *
- * Must be protected by get_mems_allowed()
+ * Must be protected by read_mems_allowed_begin()
  */
 struct zonelist *huge_zonelist(struct vm_area_struct *vma, unsigned long addr,
 				gfp_t gfp_flags, struct mempolicy **mpol,
@@ -2063,7 +2063,7 @@ alloc_pages_vma(gfp_t gfp, int order, st
 
 retry_cpuset:
 	pol = get_vma_policy(current, vma, addr);
-	cpuset_mems_cookie = get_mems_allowed();
+	cpuset_mems_cookie = read_mems_allowed_begin();
 
 	if (unlikely(pol->mode == MPOL_INTERLEAVE)) {
 		unsigned nid;
@@ -2071,7 +2071,7 @@ retry_cpuset:
 		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT + order);
 		mpol_cond_put(pol);
 		page = alloc_page_interleave(gfp, order, nid);
-		if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+		if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 			goto retry_cpuset;
 
 		return page;
@@ -2081,7 +2081,7 @@ retry_cpuset:
 				      policy_nodemask(gfp, pol));
 	if (unlikely(mpol_needs_cond_ref(pol)))
 		__mpol_put(pol);
-	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 	return page;
 }
@@ -2115,7 +2115,7 @@ struct page *alloc_pages_current(gfp_t g
 		pol = &default_policy;
 
 retry_cpuset:
-	cpuset_mems_cookie = get_mems_allowed();
+	cpuset_mems_cookie = read_mems_allowed_begin();
 
 	/*
 	 * No reference counting needed for current->mempolicy
@@ -2128,7 +2128,7 @@ retry_cpuset:
 				policy_zonelist(gfp, pol, numa_node_id()),
 				policy_nodemask(gfp, pol));
 
-	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 
 	return page;
diff -puN mm/page_alloc.c~mm-optimize-put_mems_allowed-usage mm/page_alloc.c
--- a/mm/page_alloc.c~mm-optimize-put_mems_allowed-usage
+++ a/mm/page_alloc.c
@@ -2739,7 +2739,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 		return NULL;
 
 retry_cpuset:
-	cpuset_mems_cookie = get_mems_allowed();
+	cpuset_mems_cookie = read_mems_allowed_begin();
 
 	/* The preferred zone is used for statistics later */
 	first_zones_zonelist(zonelist, high_zoneidx,
@@ -2777,7 +2777,7 @@ out:
 	 * the mask is being updated. If a page allocation is about to fail,
 	 * check if the cpuset changed during allocation and if so, retry.
 	 */
-	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 
 	memcg_kmem_commit_charge(page, memcg, order);
@@ -3045,9 +3045,9 @@ bool skip_free_areas_node(unsigned int f
 		goto out;
 
 	do {
-		cpuset_mems_cookie = get_mems_allowed();
+		cpuset_mems_cookie = read_mems_allowed_begin();
 		ret = !node_isset(nid, cpuset_current_mems_allowed);
-	} while (!put_mems_allowed(cpuset_mems_cookie));
+	} while (read_mems_allowed_retry(cpuset_mems_cookie));
 out:
 	return ret;
 }
diff -puN mm/slab.c~mm-optimize-put_mems_allowed-usage mm/slab.c
--- a/mm/slab.c~mm-optimize-put_mems_allowed-usage
+++ a/mm/slab.c
@@ -3073,7 +3073,7 @@ static void *fallback_alloc(struct kmem_
 	local_flags = flags & (GFP_CONSTRAINT_MASK|GFP_RECLAIM_MASK);
 
 retry_cpuset:
-	cpuset_mems_cookie = get_mems_allowed();
+	cpuset_mems_cookie = read_mems_allowed_begin();
 	zonelist = node_zonelist(slab_node(), flags);
 
 retry:
@@ -3131,7 +3131,7 @@ retry:
 		}
 	}
 
-	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !obj))
+	if (unlikely(!obj && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 	return obj;
 }
diff -puN mm/slub.c~mm-optimize-put_mems_allowed-usage mm/slub.c
--- a/mm/slub.c~mm-optimize-put_mems_allowed-usage
+++ a/mm/slub.c
@@ -1684,7 +1684,7 @@ static void *get_any_partial(struct kmem
 		return NULL;
 
 	do {
-		cpuset_mems_cookie = get_mems_allowed();
+		cpuset_mems_cookie = read_mems_allowed_begin();
 		zonelist = node_zonelist(slab_node(), flags);
 		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 			struct kmem_cache_node *n;
@@ -1696,19 +1696,17 @@ static void *get_any_partial(struct kmem
 				object = get_partial_node(s, n, c, flags);
 				if (object) {
 					/*
-					 * Return the object even if
-					 * put_mems_allowed indicated that
-					 * the cpuset mems_allowed was
-					 * updated in parallel. It's a
-					 * harmless race between the alloc
-					 * and the cpuset update.
+					 * Don't check read_mems_allowed_retry()
+					 * here - if mems_allowed was updated in
+					 * parallel, that was a harmless race
+					 * between allocation and the cpuset
+					 * update
 					 */
-					put_mems_allowed(cpuset_mems_cookie);
 					return object;
 				}
 			}
 		}
-	} while (!put_mems_allowed(cpuset_mems_cookie));
+	} while (read_mems_allowed_retry(cpuset_mems_cookie));
 #endif
 	return NULL;
 }
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-numa-recheck-for-transhuge-pages-under-lock-during-protection-changes.patch
mm-numa-recheck-for-transhuge-pages-under-lock-during-protection-changes-fix.patch
mm-vmscan-restore-sc-gfp_mask-after-promoting-it-to-__gfp_highmem.patch
mm-vmscan-do-not-check-compaction_ready-on-promoted-zones.patch
mm-exclude-memory-less-nodes-from-zone_reclaim.patch
mm-compaction-disallow-high-order-page-for-migration-target.patch
mm-compaction-do-not-call-suitable_migration_target-on-every-page.patch
mm-compaction-change-the-timing-to-check-to-drop-the-spinlock.patch
mm-compaction-check-pageblock-suitability-once-per-pageblock.patch
mm-compaction-clean-up-code-on-success-of-ballon-isolation.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags-ignore-madv_hugepage-on-s390-to-prevent-sigsegv-in-qemu.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
mm-introduce-vm_ops-map_pages.patch
mm-implement-map_pages-for-page-cache.patch
mm-cleanup-size-checks-in-filemap_fault-and-filemap_map_pages.patch
mm-add-debugfs-tunable-for-fault_around_order.patch
mm-implement-map_pages-for-shmem-tmpfs.patch
fork-collapse-copy_flags-into-copy_process.patch
mm-mempolicy-rename-slab_node-for-clarity.patch
mm-mempolicy-remove-per-process-flag.patch
res_counter-remove-interface-for-locked-charging-and-uncharging.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-compaction-determine-isolation-mode-only-once.patch
mm-page_alloc-spill-to-remote-nodes-before-waking-kswapd.patch
mm-try_to_unmap_cluster-should-lock_page-before-mlocking.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

