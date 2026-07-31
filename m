Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD29C3321DE
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465802; cv=none; b=t7xi8JTSAFglEnUMGveJpFFRcGAnT3wFS+4Lv4BO87IvDD9Zb4ODNSk8bx0jJxUKbH+P9goChrCxHqNtGhNAmotXhAS5CTwGBCTDwvqmmGwosX4qi2MNNShS9FLPL2YLImB0dAq7HnLjbMLY6fA0tKXoWAwB6zDlIYCt6tHvybY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465802; c=relaxed/simple;
	bh=o9ZBpa63We1pr7Y512T51JyOj0+GyUTVQLj/mWQ+4b4=;
	h=Date:To:From:Subject:Message-Id; b=CR8kLmgp+4t2q1gzBibAD70aWX+LLGkbFUZUxqQQ+WqxWuQKZPUiDO4mZGIWH4FK/aZdGHnrNDtpDz60lCCP1/HM56ewUUmIx10vRouX/brPg8PqPndyhQO06aBINIbVdT5ZwADrku3B0nCTo5Nej+s8kmz+Vus7HaNY+AcNC98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2GfsOIoK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2GfsOIoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926FD1F000E9;
	Fri, 31 Jul 2026 02:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465800;
	bh=d7Xh5NoiLY3GebVE5UJh3VSHUP2teVXUw9bwITBne8o=;
	h=Date:To:From:Subject;
	b=2GfsOIoKBocWdHbD2LvPg2BQPWVpJSm3VBek1ntnCmT4iq1UkxZdm/TF64fPJ7Bnb
	 sIvR8BVOU2Ag0R4lSbEiVVUShVWLcELKqJZgJSyTG4gWG1InMCkxLTawAiO+lSbiZV
	 vclaXhL+G7CL05+KysMHjBwIL2Qaw7m6ZaQgWFFQ=
Date: Thu, 30 Jul 2026 19:43:20 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-unify-__alloc_frozen_pages_noprof.patch removed from -mm tree
Message-Id: <20260731024320.926FD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: unify __alloc_frozen_pages[_nolock]_noprof()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-unify-__alloc_frozen_pages_noprof.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: unify __alloc_frozen_pages[_nolock]_noprof()
Date: Fri, 03 Jul 2026 12:31:45 +0000

Currently the core allocator code is controlled by ALLOC_NOLOCK, but the
main entry point function is significantly different from the normal
__alloc_frozen_pages_nolock(), this is tiring when reading the code.

Plumb the ALLOC_NOLOCK control one layer up in the call stack: create an
alloc_flags argument to __alloc_frozen_pages_nolock() (which is only
exposed to mm/) and then turn the nolock variant into a thin wrapper that
just sets that flag (as well as handling NUMA_NO_NODE, similar to how some
of the wrappers in gfp.h do).

For consistency, set ALLOC_WMARK_MIN explicitly in fastpath_alloc_flags
for the new ALLOC_NOLOCK path.  This was already "done" silently in
__alloc_frozen_pages_nolock_noprof(): ALLOC_WMARK_MIN is 0.

Rationale that this doesn't change anything:

1. Simple bits: A bunch of the nolock-specific handling is just moved to
   the new alloc_order_allowed(), alloc_nolock_allowed() and
   gfp_nolock.

2. __alloc_frozen_pages_noprof() has some extra logic that wasn't
   previously in the nolock variant:

   a. Application of gfp_allowed_mask; this only affects early boot,
      only flags that affect the slowpath get changed here, and the
      nolock allocation path isn't allowed to the GFP_BOOT_MASK flags.

   b. Application of current_gfp_context() - also only affects the
      slowpath

3. The slowpath itself: this is now just explicitly skipped under
   !ALLOC_NOLOCK.

Ulterior motive: adding an alloc_flags arg to the allocator's mm-internal
entrypoint can later be used to do more allocation customisation without
needing to create new GFP flags.

No functional change intended.

Link: https://lore.kernel.org/20260703-alloc-trylock-v5-5-c87b714e19d3@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c    |    3 
 mm/mempolicy.c  |   10 +-
 mm/page_alloc.c |  186 ++++++++++++++++++++++++----------------------
 mm/page_alloc.h |    6 -
 mm/slub.c       |    6 -
 5 files changed, 114 insertions(+), 97 deletions(-)

--- a/mm/hugetlb.c~mm-page_alloc-unify-__alloc_frozen_pages_noprof
+++ a/mm/hugetlb.c
@@ -1790,7 +1790,8 @@ static struct folio *alloc_buddy_frozen_
 	if (alloc_try_hard)
 		gfp_mask |= __GFP_RETRY_MAYFAIL;
 
-	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
+	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask,
+						     ALLOC_DEFAULT);
 
 	/*
 	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
--- a/mm/mempolicy.c~mm-page_alloc-unify-__alloc_frozen_pages_noprof
+++ a/mm/mempolicy.c
@@ -2426,9 +2426,11 @@ static struct page *alloc_pages_preferre
 	 */
 	preferred_gfp = gfp | __GFP_NOWARN;
 	preferred_gfp &= ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
-	page = __alloc_frozen_pages_noprof(preferred_gfp, order, nid, nodemask);
+	page = __alloc_frozen_pages_noprof(preferred_gfp, order, nid, nodemask,
+					   ALLOC_DEFAULT);
 	if (!page)
-		page = __alloc_frozen_pages_noprof(gfp, order, nid, NULL);
+		page = __alloc_frozen_pages_noprof(gfp, order, nid, NULL,
+						   ALLOC_DEFAULT);
 
 	return page;
 }
@@ -2476,7 +2478,7 @@ static struct page *alloc_pages_mpol(gfp
 			 */
 			page = __alloc_frozen_pages_noprof(
 				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
-				nid, NULL);
+				nid, NULL, ALLOC_DEFAULT);
 			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
 				return page;
 			/*
@@ -2488,7 +2490,7 @@ static struct page *alloc_pages_mpol(gfp
 		}
 	}
 
-	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask);
+	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask, ALLOC_DEFAULT);
 
 	if (unlikely(pol->mode == MPOL_INTERLEAVE ||
 		     pol->mode == MPOL_WEIGHTED_INTERLEAVE) && page) {
--- a/mm/page_alloc.c~mm-page_alloc-unify-__alloc_frozen_pages_noprof
+++ a/mm/page_alloc.c
@@ -5222,7 +5222,7 @@ retry_this_zone:
 		}
 		nr_account++;
 
-		prep_new_page(page, 0, gfp, 0);
+		prep_new_page(page, 0, gfp, ALLOC_DEFAULT);
 		set_page_refcounted(page);
 		page_array[nr_populated++] = page;
 	}
@@ -5271,24 +5271,99 @@ void free_pages_bulk(struct page **page_
 	}
 }
 
+static inline bool alloc_order_allowed(gfp_t gfp, unsigned int order,
+				       unsigned int alloc_flags)
+{
+	if (alloc_flags & ALLOC_NOLOCK)
+		return pcp_allowed_order(order);
+
+	/*
+	 * There are several places where we assume that the order value is sane
+	 * so bail out early if the request is out of bound.
+	 */
+	return !(WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp));
+}
+
+static inline bool alloc_nolock_allowed(void)
+{
+	/*
+	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
+	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the current
+	 * task may be waiting for one rt_spin_lock, but rt_spin_trylock() will
+	 * mark the task as the owner of another rt_spin_lock which will
+	 * confuse PI logic, so return immediately if called from hard IRQ or
+	 * NMI.
+	 *
+	 * Note, irqs_disabled() case is ok. This function can be called
+	 * from raw_spin_lock_irqsave region.
+	 */
+	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
+		return false;
+
+	/* On UP, spin_trylock() always succeeds even when it is locked */
+	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
+		return false;
+
+	/* Bailout, since _deferred_grow_zone() needs to take a lock */
+	if (deferred_pages_enabled())
+		return false;
+
+	return true;
+}
+
+/*
+ * GFP flags to set for ALLOC_NOLOCK i.e. alloc_pages_nolock().
+ *
+ * Do not specify __GFP_DIRECT_RECLAIM, since direct claim is not allowed.
+ * Do not specify __GFP_KSWAPD_RECLAIM either, since wake up of kswapd
+ * is not safe in arbitrary context.
+ *
+ * These two are the conditions for gfpflags_allow_spinning() being true.
+ *
+ * Specify __GFP_NOWARN since failing alloc_pages_nolock() is not a reason
+ * to warn. Also warn would trigger printk() which is unsafe from
+ * various contexts. We cannot use printk_deferred_enter() to mitigate,
+ * since the running context is unknown.
+ *
+ * Specify __GFP_ZERO to make sure that call to kmsan_alloc_page() below
+ * is safe in any context. Also zeroing the page is mandatory for
+ * BPF use cases.
+ *
+ * Though __GFP_NOMEMALLOC is not checked in the code path below,
+ * specify it here to highlight that alloc_pages_nolock()
+ * doesn't want to deplete reserves.
+ */
+static const gfp_t gfp_nolock = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC |
+				__GFP_COMP;
+
 /*
  * This is the 'heart' of the zoned buddy allocator.
  */
 struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
-		int preferred_nid, nodemask_t *nodemask)
+		int preferred_nid, nodemask_t *nodemask, unsigned int alloc_flags)
 {
 	struct page *page;
-	unsigned int fastpath_alloc_flags = ALLOC_WMARK_LOW;
 	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
 	struct alloc_context ac = { };
+	unsigned int fastpath_alloc_flags = alloc_flags;
 
-	/*
-	 * There are several places where we assume that the order value is sane
-	 * so bail out early if the request is out of bound.
-	 */
-	if (WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp))
+	/* Other flags could be supported later if needed. */
+	if (WARN_ON(alloc_flags & ~ALLOC_NOLOCK))
+		return NULL;
+
+	if (!alloc_order_allowed(gfp, order, alloc_flags))
 		return NULL;
 
+	if (alloc_flags & ALLOC_NOLOCK) {
+		VM_WARN_ON_ONCE(gfp & ~__GFP_ACCOUNT);
+		if (!alloc_nolock_allowed())
+			return NULL;
+		gfp |= gfp_nolock;
+		fastpath_alloc_flags |= ALLOC_WMARK_MIN;
+	} else {
+		fastpath_alloc_flags |= ALLOC_WMARK_LOW;
+	}
+
 	gfp &= gfp_allowed_mask;
 	/*
 	 * Apply scoped allocation constraints. This is mainly about GFP_NOFS
@@ -5303,16 +5378,19 @@ struct page *__alloc_frozen_pages_noprof
 			&alloc_gfp, &fastpath_alloc_flags))
 		return NULL;
 
-	/*
-	 * Forbid the first pass from falling back to types that fragment
-	 * memory until all local zones are considered.
-	 */
-	fastpath_alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp);
+	if (!(alloc_flags & ALLOC_NOLOCK)) {
+		/*
+		 * Forbid the first pass from falling back to types that
+		 * fragment memory until all local zones are considered.
+		 */
+		fastpath_alloc_flags |= alloc_flags_nofragment(
+			zonelist_zone(ac.preferred_zoneref), gfp);
+	}
 	fastpath_alloc_flags |= alloc_flags_nonblocking(gfp, order) & ALLOC_HIGHATOMIC;
 
-	/* First allocation attempt */
+	/* First allocation attempt (or, for nolock, only attempt) */
 	page = get_page_from_freelist(alloc_gfp, order, fastpath_alloc_flags, &ac);
-	if (likely(page))
+	if (likely(page) || (alloc_flags & ALLOC_NOLOCK))
 		goto out;
 
 	alloc_gfp = gfp;
@@ -5329,7 +5407,8 @@ struct page *__alloc_frozen_pages_noprof
 out:
 	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT) && page &&
 	    unlikely(__memcg_kmem_charge_page(page, gfp, order) != 0)) {
-		free_frozen_pages(page, order);
+		__free_frozen_pages(page, order,
+				    alloc_flags & ALLOC_NOLOCK ? FPI_TRYLOCK : 0);
 		page = NULL;
 	}
 
@@ -5345,7 +5424,8 @@ struct page *__alloc_pages_noprof(gfp_t
 {
 	struct page *page;
 
-	page = __alloc_frozen_pages_noprof(gfp, order, preferred_nid, nodemask);
+	page = __alloc_frozen_pages_noprof(gfp, order, preferred_nid, nodemask,
+					   ALLOC_DEFAULT);
 	if (page)
 		set_page_refcounted(page);
 	return page;
@@ -7875,80 +7955,10 @@ static bool __free_unaccepted(struct pag
 
 struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned int order)
 {
-	/*
-	 * Do not specify __GFP_DIRECT_RECLAIM, since direct claim is not allowed.
-	 * Do not specify __GFP_KSWAPD_RECLAIM either, since wake up of kswapd
-	 * is not safe in arbitrary context.
-	 *
-	 * These two are the conditions for gfpflags_allow_spinning() being true.
-	 *
-	 * Specify __GFP_NOWARN since failing alloc_pages_nolock() is not a reason
-	 * to warn. Also warn would trigger printk() which is unsafe from
-	 * various contexts. We cannot use printk_deferred_enter() to mitigate,
-	 * since the running context is unknown.
-	 *
-	 * Specify __GFP_ZERO to make sure that call to kmsan_alloc_page() below
-	 * is safe in any context. Also zeroing the page is mandatory for
-	 * BPF use cases.
-	 *
-	 * Though __GFP_NOMEMALLOC is not checked in the code path below,
-	 * specify it here to highlight that alloc_pages_nolock()
-	 * doesn't want to deplete reserves.
-	 */
-	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC | __GFP_COMP
-			| gfp_flags;
-	unsigned int alloc_flags = ALLOC_NOLOCK;
-	struct alloc_context ac = { };
-	struct page *page;
-
-	VM_WARN_ON_ONCE(gfp_flags & ~__GFP_ACCOUNT);
-	/*
-	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
-	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the current
-	 * task may be waiting for one rt_spin_lock, but rt_spin_trylock() will
-	 * mark the task as the owner of another rt_spin_lock which will
-	 * confuse PI logic, so return immediately if called from hard IRQ or
-	 * NMI.
-	 *
-	 * Note, irqs_disabled() case is ok. This function can be called
-	 * from raw_spin_lock_irqsave region.
-	 */
-	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
-		return NULL;
-
-	/* On UP, spin_trylock() always succeeds even when it is locked */
-	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
-		return NULL;
-
-	if (!pcp_allowed_order(order))
-		return NULL;
-
-	/* Bailout, since _deferred_grow_zone() needs to take a lock */
-	if (deferred_pages_enabled())
-		return NULL;
-
 	if (nid == NUMA_NO_NODE)
 		nid = numa_node_id();
 
-	prepare_alloc_pages(alloc_gfp, order, nid, NULL, &ac,
-			    &alloc_gfp, &alloc_flags);
-
-	/*
-	 * Best effort allocation from percpu free list.
-	 * If it's empty attempt to spin_trylock zone->lock.
-	 */
-	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
-
-	/* Unlike regular alloc_pages() there is no __alloc_pages_slowpath(). */
-
-	if (memcg_kmem_online() && page && (gfp_flags & __GFP_ACCOUNT) &&
-	    unlikely(__memcg_kmem_charge_page(page, alloc_gfp, order) != 0)) {
-		__free_frozen_pages(page, order, FPI_TRYLOCK);
-		page = NULL;
-	}
-	trace_mm_page_alloc(page, order, alloc_gfp, ac.migratetype);
-	kmsan_alloc_page(page, order, alloc_gfp);
-	return page;
+	return __alloc_frozen_pages_noprof(gfp_flags, order, nid, NULL, ALLOC_NOLOCK);
 }
 /**
  * alloc_pages_nolock - opportunistic reentrant allocation from any context
--- a/mm/page_alloc.h~mm-page_alloc-unify-__alloc_frozen_pages_noprof
+++ a/mm/page_alloc.h
@@ -11,6 +11,7 @@
 #include <linux/nodemask.h>
 #include <linux/types.h>
 
+#define ALLOC_DEFAULT		0
 /* The ALLOC_WMARK bits are used as an index to zone->watermark */
 #define ALLOC_WMARK_MIN		WMARK_MIN
 #define ALLOC_WMARK_LOW		WMARK_LOW
@@ -219,7 +220,7 @@ extern bool free_pages_prepare(struct pa
 extern int user_min_free_kbytes;
 
 struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order, int nid,
-		nodemask_t *nodemask);
+		nodemask_t *nodemask, unsigned int alloc_flags);
 #define __alloc_frozen_pages(...) \
 	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
 void free_frozen_pages(struct page *page, unsigned int order);
@@ -230,7 +231,8 @@ struct page *alloc_frozen_pages_noprof(g
 #else
 static inline struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order)
 {
-	return __alloc_frozen_pages_noprof(gfp, order, numa_node_id(), NULL);
+	return __alloc_frozen_pages_noprof(gfp, order, numa_node_id(), NULL,
+					   ALLOC_DEFAULT);
 }
 #endif
 
--- a/mm/slub.c~mm-page_alloc-unify-__alloc_frozen_pages_noprof
+++ a/mm/slub.c
@@ -3264,7 +3264,8 @@ static inline struct slab *alloc_slab_pa
 	else if (node == NUMA_NO_NODE)
 		page = alloc_frozen_pages(flags, order);
 	else
-		page = __alloc_frozen_pages(flags, order, node, NULL);
+		page = __alloc_frozen_pages(flags, order, node, NULL,
+					    ALLOC_DEFAULT);
 
 	if (!page)
 		return NULL;
@@ -5274,7 +5275,8 @@ static void *___kmalloc_large_node(size_
 	if (node == NUMA_NO_NODE)
 		page = alloc_frozen_pages_noprof(flags, order);
 	else
-		page = __alloc_frozen_pages_noprof(flags, order, node, NULL);
+		page = __alloc_frozen_pages_noprof(flags, order, node, NULL,
+						   ALLOC_DEFAULT);
 
 	if (page) {
 		ptr = page_address(page);
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-secretmem-dont-allow-highmem-folios.patch
mm-page_alloc-dont-spin_trylock-in-nmi-on-up.patch
mm-page_alloc-dont-spin_trylock-when-disallowed-in-free_one_page.patch
mm-page_alloc-rename-fpi_trylock-fpi_nolock.patch
cgroup-cpuset-update-some-comments-about-the-page-allocator.patch
mm-page_alloc-fixup-alloc_pages_nolock_noprof-comment.patch
mm-page_alloc-remove-a-couple-of-vm_bug_onst.patch

