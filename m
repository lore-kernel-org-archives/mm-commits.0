From: akpm@linux-foundation.org
Subject: + mm-optimize-put_mems_allowed-usage.patch added to -mm tree
Date: Thu, 17 May 2012 13:16:53 -0700
Message-ID: <20120517201654.824F5A00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:33806 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965962Ab2EQUQ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 May 2012 16:16:57 -0400
Received: by faaa25 with SMTP id a25so114479faa.1
        for <mm-commits@vger.kernel.org>; Thu, 17 May 2012 13:16:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, cl@linux.com, mgorman@suse.de, miaox@cn.fujitsu.com, penberg@cs.helsinki.fi, rientjes@google.com, tj@kernel.org


The patch titled
     Subject: mm: Optimize put_mems_allowed() usage
has been added to the -mm tree.  Its filename is
     mm-optimize-put_mems_allowed-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: mm: Optimize put_mems_allowed() usage

Since put_mems_allowed() is strictly optional - it is a seqcount retry -
we don't need to evaluate the function if the allocation was in fact
successful, saving a smp_rmb() and some loads and comparisons on some
relative fast-paths.

Since the naming get/put_mems_allowed() does suggest a mandatory pairing,
rename the interface as suggested by Mel, to resemble the seqcount
interface.

This gives us: read_mems_allowed_begin() and read_mems_allowed_retry(),
where it is important to note that the return value of the latter call is
inverted from its previous incarnation.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h |   27 ++++++++++++++-------------
 kernel/cpuset.c        |    2 +-
 mm/filemap.c           |    4 ++--
 mm/hugetlb.c           |    4 ++--
 mm/mempolicy.c         |   14 +++++++-------
 mm/page_alloc.c        |    8 ++++----
 mm/slab.c              |    4 ++--
 mm/slub.c              |   16 +++-------------
 8 files changed, 35 insertions(+), 44 deletions(-)

diff -puN include/linux/cpuset.h~mm-optimize-put_mems_allowed-usage include/linux/cpuset.h
--- a/include/linux/cpuset.h~mm-optimize-put_mems_allowed-usage
+++ a/include/linux/cpuset.h
@@ -89,25 +89,26 @@ extern void rebuild_sched_domains(void);
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
@@ -223,14 +224,14 @@ static inline void set_mems_allowed(node
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
@@ -976,7 +976,7 @@ static void cpuset_change_task_nodemask(
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
@@ -500,10 +500,10 @@ struct page *__page_cache_alloc(gfp_t gf
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
@@ -544,7 +544,7 @@ static struct page *dequeue_huge_page_vm
 	unsigned int cpuset_mems_cookie;
 
 retry_cpuset:
-	cpuset_mems_cookie = get_mems_allowed();
+	cpuset_mems_cookie = read_mems_allowed_begin();
 	zonelist = huge_zonelist(vma, address,
 					htlb_alloc_mask, &mpol, &nodemask);
 	/*
@@ -573,7 +573,7 @@ retry_cpuset:
 	}
 
 	mpol_cond_put(mpol);
-	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 	return page;
 
diff -puN mm/mempolicy.c~mm-optimize-put_mems_allowed-usage mm/mempolicy.c
--- a/mm/mempolicy.c~mm-optimize-put_mems_allowed-usage
+++ a/mm/mempolicy.c
@@ -1715,7 +1715,7 @@ int node_random(const nodemask_t *maskp)
  * If the effective policy is 'BIND, returns a pointer to the mempolicy's
  * @nodemask for filtering the zonelist.
  *
- * Must be protected by get_mems_allowed()
+ * Must be protected by read_mems_allowed_begin()
  */
 struct zonelist *huge_zonelist(struct vm_area_struct *vma, unsigned long addr,
 				gfp_t gfp_flags, struct mempolicy **mpol,
@@ -1880,7 +1880,7 @@ alloc_pages_vma(gfp_t gfp, int order, st
 
 retry_cpuset:
 	pol = get_vma_policy(current, vma, addr);
-	cpuset_mems_cookie = get_mems_allowed();
+	cpuset_mems_cookie = read_mems_allowed_begin();
 
 	if (unlikely(pol->mode == MPOL_INTERLEAVE)) {
 		unsigned nid;
@@ -1888,7 +1888,7 @@ retry_cpuset:
 		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT + order);
 		mpol_cond_put(pol);
 		page = alloc_page_interleave(gfp, order, nid);
-		if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+		if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 			goto retry_cpuset;
 
 		return page;
@@ -1901,7 +1901,7 @@ retry_cpuset:
 		struct page *page =  __alloc_pages_nodemask(gfp, order,
 						zl, policy_nodemask(gfp, pol));
 		__mpol_put(pol);
-		if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+		if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 			goto retry_cpuset;
 		return page;
 	}
@@ -1910,7 +1910,7 @@ retry_cpuset:
 	 */
 	page = __alloc_pages_nodemask(gfp, order, zl,
 				      policy_nodemask(gfp, pol));
-	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 	return page;
 }
@@ -1944,7 +1944,7 @@ struct page *alloc_pages_current(gfp_t g
 		pol = &default_policy;
 
 retry_cpuset:
-	cpuset_mems_cookie = get_mems_allowed();
+	cpuset_mems_cookie = read_mems_allowed_begin();
 
 	/*
 	 * No reference counting needed for current->mempolicy
@@ -1957,7 +1957,7 @@ retry_cpuset:
 				policy_zonelist(gfp, pol, numa_node_id()),
 				policy_nodemask(gfp, pol));
 
-	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 
 	return page;
diff -puN mm/page_alloc.c~mm-optimize-put_mems_allowed-usage mm/page_alloc.c
--- a/mm/page_alloc.c~mm-optimize-put_mems_allowed-usage
+++ a/mm/page_alloc.c
@@ -2497,7 +2497,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 		return NULL;
 
 retry_cpuset:
-	cpuset_mems_cookie = get_mems_allowed();
+	cpuset_mems_cookie = read_mems_allowed_begin();
 
 	/* The preferred zone is used for statistics later */
 	first_zones_zonelist(zonelist, high_zoneidx,
@@ -2524,7 +2524,7 @@ out:
 	 * the mask is being updated. If a page allocation is about to fail,
 	 * check if the cpuset changed during allocation and if so, retry.
 	 */
-	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
+	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 
 	return page;
@@ -2746,9 +2746,9 @@ bool skip_free_areas_node(unsigned int f
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
@@ -3367,7 +3367,7 @@ static void *fallback_alloc(struct kmem_
 	local_flags = flags & (GFP_CONSTRAINT_MASK|GFP_RECLAIM_MASK);
 
 retry_cpuset:
-	cpuset_mems_cookie = get_mems_allowed();
+	cpuset_mems_cookie = read_mems_allowed_begin();
 	zonelist = node_zonelist(slab_node(current->mempolicy), flags);
 
 retry:
@@ -3423,7 +3423,7 @@ retry:
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
@@ -1614,7 +1614,7 @@ static struct page *get_any_partial(stru
 		return NULL;
 
 	do {
-		cpuset_mems_cookie = get_mems_allowed();
+		cpuset_mems_cookie = read_mems_allowed_begin();
 		zonelist = node_zonelist(slab_node(current->mempolicy), flags);
 		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 			struct kmem_cache_node *n;
@@ -1624,21 +1624,11 @@ static struct page *get_any_partial(stru
 			if (n && cpuset_zone_allowed_hardwall(zone, flags) &&
 					n->nr_partial > s->min_partial) {
 				object = get_partial_node(s, n, c);
-				if (object) {
-					/*
-					 * Return the object even if
-					 * put_mems_allowed indicated that
-					 * the cpuset mems_allowed was
-					 * updated in parallel. It's a
-					 * harmless race between the alloc
-					 * and the cpuset update.
-					 */
-					put_mems_allowed(cpuset_mems_cookie);
+				if (object)
 					return object;
-				}
 			}
 		}
-	} while (!put_mems_allowed(cpuset_mems_cookie));
+	} while (read_mems_allowed_retry(cpuset_mems_cookie));
 #endif
 	return NULL;
 }
_
Subject: Subject: mm: Optimize put_mems_allowed() usage

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

linux-next.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm-fork-fix-overflow-in-vma-length-when-copying-mmap-on-clone.patch
mm-optimize-put_mems_allowed-usage.patch
mm-optimize-put_mems_allowed-usage-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch
vsprintf-fix-%ps-on-non-symbols-when-using-kallsyms.patch
spinlock_debug-print-kallsyms-name-for-lock.patch
kmod-unexport-call_usermodehelper_freeinfo.patch
kmod-convert-two-call-sites-to-call_usermodehelper_fns.patch
kmod-move-call_usermodehelper_fns-to-c-file-and-unexport-all-its-helpers.patch
cpu-introduce-clear_tasks_mm_cpumask-helper.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch
ipc-semc-alternatives-to-preempt_disable.patch

