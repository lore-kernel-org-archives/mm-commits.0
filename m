From: akpm@linux-foundation.org
Subject: [patch 034/102] mm: introduce memalloc_nofs_{save,restore}
 API
Date: Wed, 03 May 2017 14:53:15 -0700
Message-ID: <20170503215315.3NCigQOTV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48036 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751074AbdECVx1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:53:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bfoster@redhat.com, clm@fb.com, darrick.wong@oracle.com, david@fromorbit.com, dsterba@suse.cz, jack@suse.cz, mhocko@suse.com, mm-commits@vger.kernel.org, nborisov@suse.com, peterz@infradead.org, torvalds@linux-foundation.org, tytso@mit.edu, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: mm: introduce memalloc_nofs_{save,restore} API

GFP_NOFS context is used for the following 5 reasons currently
	- to prevent from deadlocks when the lock held by the allocation
	  context would be needed during the memory reclaim
	- to prevent from stack overflows during the reclaim because
	  the allocation is performed from a deep context already
	- to prevent lockups when the allocation context depends on
	  other reclaimers to make a forward progress indirectly
	- just in case because this would be safe from the fs POV
	- silence lockdep false positives

Unfortunately overuse of this allocation context brings some problems to
the MM.  Memory reclaim is much weaker (especially during heavy FS
metadata workloads), OOM killer cannot be invoked because the MM layer
doesn't have enough information about how much memory is freeable by the
FS layer.

In many cases it is far from clear why the weaker context is even used and
so it might be used unnecessarily.  We would like to get rid of those as
much as possible.  One way to do that is to use the flag in scopes rather
than isolated cases.  Such a scope is declared when really necessary,
tracked per task and all the allocation requests from within the context
will simply inherit the GFP_NOFS semantic.

Not only this is easier to understand and maintain because there are much
less problematic contexts than specific allocation requests, this also
helps code paths where FS layer interacts with other layers (e.g.  crypto,
security modules, MM etc...) and there is no easy way to convey the
allocation context between the layers.

Introduce memalloc_nofs_{save,restore} API to control the scope of
GFP_NOFS allocation context.  This is basically copying
memalloc_noio_{save,restore} API we have for other restricted allocation
context GFP_NOIO.  The PF_MEMALLOC_NOFS flag already exists and it is just
an alias for PF_FSTRANS which has been xfs specific until recently.  There
are no more PF_FSTRANS users anymore so let's just drop it.

PF_MEMALLOC_NOFS is now checked in the MM layer and drops __GFP_FS
implicitly same as PF_MEMALLOC_NOIO drops __GFP_IO.  memalloc_noio_flags
is renamed to current_gfp_context because it now cares about both
PF_MEMALLOC_NOFS and PF_MEMALLOC_NOIO contexts.  Xfs code paths preserve
their semantic.  kmem_flags_convert() doesn't need to evaluate the flag
anymore.

This patch shouldn't introduce any functional changes.

Let's hope that filesystems will drop direct GFP_NOFS (resp.  ~__GFP_FS)
usage as much as possible and only use a properly documented
memalloc_nofs_{save,restore} checkpoints where they are appropriate.

[akpm@linux-foundation.org: fix comment typo, reflow comment]
Link: http://lkml.kernel.org/r/20170306131408.9828-5-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Nikolay Borisov <nborisov@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/kmem.h            |    2 +-
 include/linux/gfp.h      |    8 ++++++++
 include/linux/sched.h    |    8 +++-----
 include/linux/sched/mm.h |   26 +++++++++++++++++++++++---
 kernel/locking/lockdep.c |    6 +++---
 mm/page_alloc.c          |   10 ++++++----
 mm/vmscan.c              |    6 +++---
 7 files changed, 47 insertions(+), 19 deletions(-)

diff -puN fs/xfs/kmem.h~mm-introduce-memalloc_nofs_saverestore-api fs/xfs/kmem.h
--- a/fs/xfs/kmem.h~mm-introduce-memalloc_nofs_saverestore-api
+++ a/fs/xfs/kmem.h
@@ -50,7 +50,7 @@ kmem_flags_convert(xfs_km_flags_t flags)
 		lflags = GFP_ATOMIC | __GFP_NOWARN;
 	} else {
 		lflags = GFP_KERNEL | __GFP_NOWARN;
-		if ((current->flags & PF_MEMALLOC_NOFS) || (flags & KM_NOFS))
+		if (flags & KM_NOFS)
 			lflags &= ~__GFP_FS;
 	}
 
diff -puN include/linux/gfp.h~mm-introduce-memalloc_nofs_saverestore-api include/linux/gfp.h
--- a/include/linux/gfp.h~mm-introduce-memalloc_nofs_saverestore-api
+++ a/include/linux/gfp.h
@@ -210,8 +210,16 @@ struct vm_area_struct;
  *
  * GFP_NOIO will use direct reclaim to discard clean pages or slab pages
  *   that do not require the starting of any physical IO.
+ *   Please try to avoid using this flag directly and instead use
+ *   memalloc_noio_{save,restore} to mark the whole scope which cannot
+ *   perform any IO with a short explanation why. All allocation requests
+ *   will inherit GFP_NOIO implicitly.
  *
  * GFP_NOFS will use direct reclaim but will not use any filesystem interfaces.
+ *   Please try to avoid using this flag directly and instead use
+ *   memalloc_nofs_{save,restore} to mark the whole scope which cannot/shouldn't
+ *   recurse into the FS layer with a short explanation why. All allocation
+ *   requests will inherit GFP_NOFS implicitly.
  *
  * GFP_USER is for userspace allocations that also need to be directly
  *   accessibly by the kernel or hardware. It is typically used by hardware
diff -puN include/linux/sched.h~mm-introduce-memalloc_nofs_saverestore-api include/linux/sched.h
--- a/include/linux/sched.h~mm-introduce-memalloc_nofs_saverestore-api
+++ a/include/linux/sched.h
@@ -1224,9 +1224,9 @@ extern struct pid *cad_pid;
 #define PF_USED_ASYNC		0x00004000	/* Used async_schedule*(), used by module init */
 #define PF_NOFREEZE		0x00008000	/* This thread should not be frozen */
 #define PF_FROZEN		0x00010000	/* Frozen for system suspend */
-#define PF_FSTRANS		0x00020000	/* Inside a filesystem transaction */
-#define PF_KSWAPD		0x00040000	/* I am kswapd */
-#define PF_MEMALLOC_NOIO	0x00080000	/* Allocating memory without IO involved */
+#define PF_KSWAPD		0x00020000	/* I am kswapd */
+#define PF_MEMALLOC_NOFS	0x00040000	/* All allocation requests will inherit GFP_NOFS */
+#define PF_MEMALLOC_NOIO	0x00080000	/* All allocation requests will inherit GFP_NOIO */
 #define PF_LESS_THROTTLE	0x00100000	/* Throttle me less: I clean memory */
 #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
 #define PF_RANDOMIZE		0x00400000	/* Randomize virtual address space */
@@ -1237,8 +1237,6 @@ extern struct pid *cad_pid;
 #define PF_FREEZER_SKIP		0x40000000	/* Freezer should not count it as freezable */
 #define PF_SUSPEND_TASK		0x80000000      /* This thread called freeze_processes() and should not be frozen */
 
-#define PF_MEMALLOC_NOFS PF_FSTRANS	/* Transition to a more generic GFP_NOFS scope semantic */
-
 /*
  * Only the _current_ task can read/write to tsk->flags, but other
  * tasks can access tsk->flags in readonly mode for example
diff -puN include/linux/sched/mm.h~mm-introduce-memalloc_nofs_saverestore-api include/linux/sched/mm.h
--- a/include/linux/sched/mm.h~mm-introduce-memalloc_nofs_saverestore-api
+++ a/include/linux/sched/mm.h
@@ -149,13 +149,21 @@ static inline bool in_vfork(struct task_
 	return ret;
 }
 
-/* __GFP_IO isn't allowed if PF_MEMALLOC_NOIO is set in current->flags
- * __GFP_FS is also cleared as it implies __GFP_IO.
+/*
+ * Applies per-task gfp context to the given allocation flags.
+ * PF_MEMALLOC_NOIO implies GFP_NOIO
+ * PF_MEMALLOC_NOFS implies GFP_NOFS
  */
-static inline gfp_t memalloc_noio_flags(gfp_t flags)
+static inline gfp_t current_gfp_context(gfp_t flags)
 {
+	/*
+	 * NOIO implies both NOIO and NOFS and it is a weaker context
+	 * so always make sure it makes precendence
+	 */
 	if (unlikely(current->flags & PF_MEMALLOC_NOIO))
 		flags &= ~(__GFP_IO | __GFP_FS);
+	else if (unlikely(current->flags & PF_MEMALLOC_NOFS))
+		flags &= ~__GFP_FS;
 	return flags;
 }
 
@@ -171,4 +179,16 @@ static inline void memalloc_noio_restore
 	current->flags = (current->flags & ~PF_MEMALLOC_NOIO) | flags;
 }
 
+static inline unsigned int memalloc_nofs_save(void)
+{
+	unsigned int flags = current->flags & PF_MEMALLOC_NOFS;
+	current->flags |= PF_MEMALLOC_NOFS;
+	return flags;
+}
+
+static inline void memalloc_nofs_restore(unsigned int flags)
+{
+	current->flags = (current->flags & ~PF_MEMALLOC_NOFS) | flags;
+}
+
 #endif /* _LINUX_SCHED_MM_H */
diff -puN kernel/locking/lockdep.c~mm-introduce-memalloc_nofs_saverestore-api kernel/locking/lockdep.c
--- a/kernel/locking/lockdep.c~mm-introduce-memalloc_nofs_saverestore-api
+++ a/kernel/locking/lockdep.c
@@ -2877,7 +2877,7 @@ static void __lockdep_trace_alloc(gfp_t
 	if (unlikely(!debug_locks))
 		return;
 
-	gfp_mask = memalloc_noio_flags(gfp_mask);
+	gfp_mask = current_gfp_context(gfp_mask);
 
 	/* no reclaim without waiting on it */
 	if (!(gfp_mask & __GFP_DIRECT_RECLAIM))
@@ -2888,7 +2888,7 @@ static void __lockdep_trace_alloc(gfp_t
 		return;
 
 	/* We're only interested __GFP_FS allocations for now */
-	if (!(gfp_mask & __GFP_FS))
+	if (!(gfp_mask & __GFP_FS) || (curr->flags & PF_MEMALLOC_NOFS))
 		return;
 
 	/*
@@ -3954,7 +3954,7 @@ EXPORT_SYMBOL_GPL(lock_unpin_lock);
 
 void lockdep_set_current_reclaim_state(gfp_t gfp_mask)
 {
-	current->lockdep_reclaim_gfp = memalloc_noio_flags(gfp_mask);
+	current->lockdep_reclaim_gfp = current_gfp_context(gfp_mask);
 }
 
 void lockdep_clear_current_reclaim_state(void)
diff -puN mm/page_alloc.c~mm-introduce-memalloc_nofs_saverestore-api mm/page_alloc.c
--- a/mm/page_alloc.c~mm-introduce-memalloc_nofs_saverestore-api
+++ a/mm/page_alloc.c
@@ -3951,10 +3951,12 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 		goto out;
 
 	/*
-	 * Runtime PM, block IO and its error handling path can deadlock
-	 * because I/O on the device might not complete.
+	 * Apply scoped allocation constraints. This is mainly about GFP_NOFS
+	 * resp. GFP_NOIO which has to be inherited for all allocation requests
+	 * from a particular context which has been marked by
+	 * memalloc_no{fs,io}_{save,restore}.
 	 */
-	alloc_mask = memalloc_noio_flags(gfp_mask);
+	alloc_mask = current_gfp_context(gfp_mask);
 	ac.spread_dirty_pages = false;
 
 	/*
@@ -7408,7 +7410,7 @@ int alloc_contig_range(unsigned long sta
 		.zone = page_zone(pfn_to_page(start)),
 		.mode = MIGRATE_SYNC,
 		.ignore_skip_hint = true,
-		.gfp_mask = memalloc_noio_flags(gfp_mask),
+		.gfp_mask = current_gfp_context(gfp_mask),
 	};
 	INIT_LIST_HEAD(&cc.migratepages);
 
diff -puN mm/vmscan.c~mm-introduce-memalloc_nofs_saverestore-api mm/vmscan.c
--- a/mm/vmscan.c~mm-introduce-memalloc_nofs_saverestore-api
+++ a/mm/vmscan.c
@@ -2915,7 +2915,7 @@ unsigned long try_to_free_pages(struct z
 	unsigned long nr_reclaimed;
 	struct scan_control sc = {
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
-		.gfp_mask = (gfp_mask = memalloc_noio_flags(gfp_mask)),
+		.gfp_mask = (gfp_mask = current_gfp_context(gfp_mask)),
 		.reclaim_idx = gfp_zone(gfp_mask),
 		.order = order,
 		.nodemask = nodemask,
@@ -2995,7 +2995,7 @@ unsigned long try_to_free_mem_cgroup_pag
 	int nid;
 	struct scan_control sc = {
 		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
-		.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
+		.gfp_mask = (current_gfp_context(gfp_mask) & GFP_RECLAIM_MASK) |
 				(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
 		.reclaim_idx = MAX_NR_ZONES - 1,
 		.target_mem_cgroup = memcg,
@@ -3702,7 +3702,7 @@ static int __node_reclaim(struct pglist_
 	int classzone_idx = gfp_zone(gfp_mask);
 	struct scan_control sc = {
 		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
-		.gfp_mask = (gfp_mask = memalloc_noio_flags(gfp_mask)),
+		.gfp_mask = (gfp_mask = current_gfp_context(gfp_mask)),
 		.order = order,
 		.priority = NODE_RECLAIM_PRIORITY,
 		.may_writepage = !!(node_reclaim_mode & RECLAIM_WRITE),
_
