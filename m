From: akpm@linux-foundation.org
Subject: - mempolicy-rework-mempolicy-reference-counting.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:53:20 -0700
Message-ID: <200804282153.m3SLrKWp017860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932523AbYD1Vxg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:53:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy: rework mempolicy Reference Counting [yet again]
has been removed from the -mm tree.  Its filename was
     mempolicy-rework-mempolicy-reference-counting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: rework mempolicy Reference Counting [yet again]
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

After further discussion with Christoph Lameter, it has become clear that my
earlier attempts to clean up the mempolicy reference counting were a bit of
overkill in some areas, resulting in superflous ref/unref in what are usually
fast paths.  In other areas, further inspection reveals that I botched the
unref for interleave policies.

A separate patch, suitable for upstream/stable trees, fixes up the known
errors in the previous attempt to fix reference counting.

This patch reworks the memory policy referencing counting and, one hopes,
simplifies the code.  Maybe I'll get it right this time.

See the update to the numa_memory_policy.txt document for a discussion of
memory policy reference counting that motivates this patch.

Summary:

Lookup of mempolicy, based on (vma, address) need only add a reference for
shared policy, and we need only unref the policy when finished for shared
policies.  So, this patch backs out all of the unneeded extra reference
counting added by my previous attempt.  It then unrefs only shared policies
when we're finished with them, using the mpol_cond_put() [conditional put]
helper function introduced by this patch.

Note that shmem_swapin() calls read_swap_cache_async() with a dummy vma
containing just the policy.  read_swap_cache_async() can call alloc_page_vma()
multiple times, so we can't let alloc_page_vma() unref the shared policy in
this case.  To avoid this, we make a copy of any non-null shared policy and
remove the MPOL_F_SHARED flag from the copy.  This copy occurs before reading
a page [or multiple pages] from swap, so the overhead should not be an issue
here.

I introduced a new static inline function "mpol_cond_copy()" to copy the
shared policy to an on-stack policy and remove the flags that would require a
conditional free.  The current implementation of mpol_cond_copy() assumes that
the struct mempolicy contains no pointers to dynamically allocated structures
that must be duplicated or reference counted during copy.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/numa_memory_policy.txt |   68 ++++++++++
 include/linux/mempolicy.h               |   35 +++++
 ipc/shm.c                               |    5 
 mm/hugetlb.c                            |    2 
 mm/mempolicy.c                          |  146 +++++++++++-----------
 mm/shmem.c                              |   16 +-
 6 files changed, 195 insertions(+), 77 deletions(-)

diff -puN Documentation/vm/numa_memory_policy.txt~mempolicy-rework-mempolicy-reference-counting Documentation/vm/numa_memory_policy.txt
--- a/Documentation/vm/numa_memory_policy.txt~mempolicy-rework-mempolicy-reference-counting
+++ a/Documentation/vm/numa_memory_policy.txt
@@ -311,6 +311,74 @@ Components of Memory Policies
 	    MPOL_PREFERRED policies that were created with an empty nodemask
 	    (local allocation).
 
+MEMORY POLICY REFERENCE COUNTING
+
+To resolve use/free races, struct mempolicy contains an atomic reference
+count field.  Internal interfaces, mpol_get()/mpol_put() increment and
+decrement this reference count, respectively.  mpol_put() will only free
+the structure back to the mempolicy kmem cache when the reference count
+goes to zero.
+
+When a new memory policy is allocated, it's reference count is initialized
+to '1', representing the reference held by the task that is installing the
+new policy.  When a pointer to a memory policy structure is stored in another
+structure, another reference is added, as the task's reference will be dropped
+on completion of the policy installation.
+
+During run-time "usage" of the policy, we attempt to minimize atomic operations
+on the reference count, as this can lead to cache lines bouncing between cpus
+and NUMA nodes.  "Usage" here means one of the following:
+
+1) querying of the policy, either by the task itself [using the get_mempolicy()
+   API discussed below] or by another task using the /proc/<pid>/numa_maps
+   interface.
+
+2) examination of the policy to determine the policy mode and associated node
+   or node lists, if any, for page allocation.  This is considered a "hot
+   path".  Note that for MPOL_BIND, the "usage" extends across the entire
+   allocation process, which may sleep during page reclaimation, because the
+   BIND policy nodemask is used, by reference, to filter ineligible nodes.
+
+We can avoid taking an extra reference during the usages listed above as
+follows:
+
+1) we never need to get/free the system default policy as this is never
+   changed nor freed, once the system is up and running.
+
+2) for querying the policy, we do not need to take an extra reference on the
+   target task's task policy nor vma policies because we always acquire the
+   task's mm's mmap_sem for read during the query.  The set_mempolicy() and
+   mbind() APIs [see below] always acquire the mmap_sem for write when
+   installing or replacing task or vma policies.  Thus, there is no possibility
+   of a task or thread freeing a policy while another task or thread is
+   querying it.
+
+3) Page allocation usage of task or vma policy occurs in the fault path where
+   we hold them mmap_sem for read.  Again, because replacing the task or vma
+   policy requires that the mmap_sem be held for write, the policy can't be
+   freed out from under us while we're using it for page allocation.
+
+4) Shared policies require special consideration.  One task can replace a
+   shared memory policy while another task, with a distinct mmap_sem, is
+   querying or allocating a page based on the policy.  To resolve this
+   potential race, the shared policy infrastructure adds an extra reference
+   to the shared policy during lookup while holding a spin lock on the shared
+   policy management structure.  This requires that we drop this extra
+   reference when we're finished "using" the policy.  We must drop the
+   extra reference on shared policies in the same query/allocation paths
+   used for non-shared policies.  For this reason, shared policies are marked
+   as such, and the extra reference is dropped "conditionally"--i.e., only
+   for shared policies.
+
+   Because of this extra reference counting, and because we must lookup
+   shared policies in a tree structure under spinlock, shared policies are
+   more expensive to use in the page allocation path.  This is expecially
+   true for shared policies on shared memory regions shared by tasks running
+   on different NUMA nodes.  This extra overhead can be avoided by always
+   falling back to task or system default policy for shared memory regions,
+   or by prefaulting the entire shared memory region into memory and locking
+   it down.  However, this might not be appropriate for all applications.
+
 MEMORY POLICY APIs
 
 Linux supports 3 system calls for controlling memory policy.  These APIS
diff -puN include/linux/mempolicy.h~mempolicy-rework-mempolicy-reference-counting include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mempolicy-rework-mempolicy-reference-counting
+++ a/include/linux/mempolicy.h
@@ -112,6 +112,31 @@ static inline void mpol_put(struct mempo
 		__mpol_put(pol);
 }
 
+/*
+ * Does mempolicy pol need explicit unref after use?
+ * Currently only needed for shared policies.
+ */
+static inline int mpol_needs_cond_ref(struct mempolicy *pol)
+{
+	return (pol && (pol->flags & MPOL_F_SHARED));
+}
+
+static inline void mpol_cond_put(struct mempolicy *pol)
+{
+	if (mpol_needs_cond_ref(pol))
+		__mpol_put(pol);
+}
+
+extern struct mempolicy *__mpol_cond_copy(struct mempolicy *tompol,
+					  struct mempolicy *frompol);
+static inline struct mempolicy *mpol_cond_copy(struct mempolicy *tompol,
+						struct mempolicy *frompol)
+{
+	if (!frompol)
+		return frompol;
+	return __mpol_cond_copy(tompol, frompol);
+}
+
 extern struct mempolicy *__mpol_dup(struct mempolicy *pol);
 static inline struct mempolicy *mpol_dup(struct mempolicy *pol)
 {
@@ -201,6 +226,16 @@ static inline void mpol_put(struct mempo
 {
 }
 
+static inline void mpol_cond_put(struct mempolicy *pol)
+{
+}
+
+static inline struct mempolicy *mpol_cond_copy(struct mempolicy *to,
+						struct mempolicy *from)
+{
+	return from;
+}
+
 static inline void mpol_get(struct mempolicy *pol)
 {
 }
diff -puN ipc/shm.c~mempolicy-rework-mempolicy-reference-counting ipc/shm.c
--- a/ipc/shm.c~mempolicy-rework-mempolicy-reference-counting
+++ a/ipc/shm.c
@@ -271,10 +271,9 @@ static struct mempolicy *shm_get_policy(
 
 	if (sfd->vm_ops->get_policy)
 		pol = sfd->vm_ops->get_policy(vma, addr);
-	else if (vma->vm_policy) {
+	else if (vma->vm_policy)
 		pol = vma->vm_policy;
-		mpol_get(pol);	/* get_vma_policy() expects this */
-	}
+
 	return pol;
 }
 #endif
diff -puN mm/hugetlb.c~mempolicy-rework-mempolicy-reference-counting mm/hugetlb.c
--- a/mm/hugetlb.c~mempolicy-rework-mempolicy-reference-counting
+++ a/mm/hugetlb.c
@@ -116,7 +116,7 @@ static struct page *dequeue_huge_page_vm
 			break;
 		}
 	}
-	mpol_put(mpol);	/* unref if mpol !NULL */
+	mpol_cond_put(mpol);
 	return page;
 }
 
diff -puN mm/mempolicy.c~mempolicy-rework-mempolicy-reference-counting mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-rework-mempolicy-reference-counting
+++ a/mm/mempolicy.c
@@ -241,6 +241,15 @@ static struct mempolicy *mpol_new(unsign
 	return policy;
 }
 
+/* Slow path of a mpol destructor. */
+void __mpol_put(struct mempolicy *p)
+{
+	if (!atomic_dec_and_test(&p->refcnt))
+		return;
+	p->mode = MPOL_DEFAULT;
+	kmem_cache_free(policy_cache, p);
+}
+
 static void mpol_rebind_default(struct mempolicy *pol, const nodemask_t *nodes)
 {
 }
@@ -719,6 +728,7 @@ static long do_get_mempolicy(int *policy
 		get_zonemask(pol, nmask);
 
  out:
+	mpol_cond_put(pol);
 	if (vma)
 		up_read(&current->mm->mmap_sem);
 	return err;
@@ -1257,16 +1267,18 @@ asmlinkage long compat_sys_mbind(compat_
  *
  * Returns effective policy for a VMA at specified address.
  * Falls back to @task or system default policy, as necessary.
- * Returned policy has extra reference count if shared, vma,
- * or some other task's policy [show_numa_maps() can pass
- * @task != current].  It is the caller's responsibility to
- * free the reference in these cases.
+ * Current or other task's task mempolicy and non-shared vma policies
+ * are protected by the task's mmap_sem, which must be held for read by
+ * the caller.
+ * Shared policies [those marked as MPOL_F_SHARED] require an extra reference
+ * count--added by the get_policy() vm_op, as appropriate--to protect against
+ * freeing by another task.  It is the caller's responsibility to free the
+ * extra reference for shared policies.
  */
 static struct mempolicy *get_vma_policy(struct task_struct *task,
 		struct vm_area_struct *vma, unsigned long addr)
 {
 	struct mempolicy *pol = task->mempolicy;
-	int shared_pol = 0;
 
 	if (vma) {
 		if (vma->vm_ops && vma->vm_ops->get_policy) {
@@ -1274,20 +1286,20 @@ static struct mempolicy *get_vma_policy(
 									addr);
 			if (vpol)
 				pol = vpol;
-			shared_pol = 1;	/* if pol non-NULL, add ref below */
 		} else if (vma->vm_policy &&
 				vma->vm_policy->mode != MPOL_DEFAULT)
 			pol = vma->vm_policy;
 	}
 	if (!pol)
 		pol = &default_policy;
-	else if (!shared_pol && pol != current->mempolicy)
-		mpol_get(pol);	/* vma or other task's policy */
 	return pol;
 }
 
-/* Return a nodemask representing a mempolicy */
-static nodemask_t *nodemask_policy(gfp_t gfp, struct mempolicy *policy)
+/*
+ * Return a nodemask representing a mempolicy for filtering nodes for
+ * page allocation
+ */
+static nodemask_t *policy_nodemask(gfp_t gfp, struct mempolicy *policy)
 {
 	/* Lower zones don't get a nodemask applied for MPOL_BIND */
 	if (unlikely(policy->mode == MPOL_BIND) &&
@@ -1298,8 +1310,8 @@ static nodemask_t *nodemask_policy(gfp_t
 	return NULL;
 }
 
-/* Return a zonelist representing a mempolicy */
-static struct zonelist *zonelist_policy(gfp_t gfp, struct mempolicy *policy)
+/* Return a zonelist indicated by gfp for node representing a mempolicy */
+static struct zonelist *policy_zonelist(gfp_t gfp, struct mempolicy *policy)
 {
 	int nd;
 
@@ -1311,10 +1323,10 @@ static struct zonelist *zonelist_policy(
 		break;
 	case MPOL_BIND:
 		/*
-		 * Normally, MPOL_BIND allocations node-local are node-local
-		 * within the allowed nodemask. However, if __GFP_THISNODE is
-		 * set and the current node is part of the mask, we use the
-		 * the zonelist for the first node in the mask instead.
+		 * Normally, MPOL_BIND allocations are node-local within the
+		 * allowed nodemask.  However, if __GFP_THISNODE is set and the
+		 * current node is part of the mask, we use the zonelist for
+		 * the first node in the mask instead.
 		 */
 		nd = numa_node_id();
 		if (unlikely(gfp & __GFP_THISNODE) &&
@@ -1350,6 +1362,10 @@ static unsigned interleave_nodes(struct 
 /*
  * Depending on the memory policy provide a node from which to allocate the
  * next slab entry.
+ * @policy must be protected by freeing by the caller.  If @policy is
+ * the current task's mempolicy, this protection is implicit, as only the
+ * task can change it's policy.  The system default policy requires no
+ * such protection.
  */
 unsigned slab_node(struct mempolicy *policy)
 {
@@ -1435,43 +1451,27 @@ static inline unsigned interleave_nid(st
  * @mpol = pointer to mempolicy pointer for reference counted mempolicy
  * @nodemask = pointer to nodemask pointer for MPOL_BIND nodemask
  *
- * Returns a zonelist suitable for a huge page allocation.
- * If the effective policy is 'BIND, returns pointer to local node's zonelist,
- * and a pointer to the mempolicy's @nodemask for filtering the zonelist.
- * If it is also a policy for which get_vma_policy() returns an extra
- * reference, we must hold that reference until after the allocation.
- * In that case, return policy via @mpol so hugetlb allocation can drop
- * the reference. For non-'BIND referenced policies, we can/do drop the
- * reference here, so the caller doesn't need to know about the special case
- * for default and current task policy.
+ * Returns a zonelist suitable for a huge page allocation and a pointer
+ * to the struct mempolicy for conditional unref after allocation.
+ * If the effective policy is 'BIND, returns a pointer to the mempolicy's
+ * @nodemask for filtering the zonelist.
  */
 struct zonelist *huge_zonelist(struct vm_area_struct *vma, unsigned long addr,
 				gfp_t gfp_flags, struct mempolicy **mpol,
 				nodemask_t **nodemask)
 {
-	struct mempolicy *pol = get_vma_policy(current, vma, addr);
 	struct zonelist *zl;
 
-	*mpol = NULL;		/* probably no unref needed */
+	*mpol = get_vma_policy(current, vma, addr);
 	*nodemask = NULL;	/* assume !MPOL_BIND */
-	if (pol->mode == MPOL_BIND) {
-			*nodemask = &pol->v.nodes;
-	} else if (pol->mode == MPOL_INTERLEAVE) {
-		unsigned nid;
-
-		nid = interleave_nid(pol, vma, addr, HPAGE_SHIFT);
-		if (unlikely(pol != &default_policy &&
-				pol != current->mempolicy))
-			__mpol_put(pol);	/* finished with pol */
-		return node_zonelist(nid, gfp_flags);
-	}
 
-	zl = zonelist_policy(GFP_HIGHUSER, pol);
-	if (unlikely(pol != &default_policy && pol != current->mempolicy)) {
-		if (pol->mode != MPOL_BIND)
-			__mpol_put(pol);	/* finished with pol */
-		else
-			*mpol = pol;	/* unref needed after allocation */
+	if (unlikely((*mpol)->mode == MPOL_INTERLEAVE)) {
+		zl = node_zonelist(interleave_nid(*mpol, vma, addr,
+						HPAGE_SHIFT), gfp_flags);
+	} else {
+		zl = policy_zonelist(gfp_flags, *mpol);
+		if ((*mpol)->mode == MPOL_BIND)
+			*nodemask = &(*mpol)->v.nodes;
 	}
 	return zl;
 }
@@ -1526,25 +1526,23 @@ alloc_page_vma(gfp_t gfp, struct vm_area
 		unsigned nid;
 
 		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT);
-		if (unlikely(pol != &default_policy &&
-				pol != current->mempolicy))
-			__mpol_put(pol);	/* finished with pol */
+		mpol_cond_put(pol);
 		return alloc_page_interleave(gfp, 0, nid);
 	}
-	zl = zonelist_policy(gfp, pol);
-	if (pol != &default_policy && pol != current->mempolicy) {
+	zl = policy_zonelist(gfp, pol);
+	if (unlikely(mpol_needs_cond_ref(pol))) {
 		/*
-		 * slow path: ref counted policy -- shared or vma
+		 * slow path: ref counted shared policy
 		 */
 		struct page *page =  __alloc_pages_nodemask(gfp, 0,
-						zl, nodemask_policy(gfp, pol));
+						zl, policy_nodemask(gfp, pol));
 		__mpol_put(pol);
 		return page;
 	}
 	/*
 	 * fast path:  default or task policy
 	 */
-	return __alloc_pages_nodemask(gfp, 0, zl, nodemask_policy(gfp, pol));
+	return __alloc_pages_nodemask(gfp, 0, zl, policy_nodemask(gfp, pol));
 }
 
 /**
@@ -1574,10 +1572,15 @@ struct page *alloc_pages_current(gfp_t g
 		cpuset_update_task_memory_state();
 	if (!pol || in_interrupt() || (gfp & __GFP_THISNODE))
 		pol = &default_policy;
+
+	/*
+	 * No reference counting needed for current->mempolicy
+	 * nor system default_policy
+	 */
 	if (pol->mode == MPOL_INTERLEAVE)
 		return alloc_page_interleave(gfp, order, interleave_nodes(pol));
 	return __alloc_pages_nodemask(gfp, order,
-			zonelist_policy(gfp, pol), nodemask_policy(gfp, pol));
+			policy_zonelist(gfp, pol), policy_nodemask(gfp, pol));
 }
 EXPORT_SYMBOL(alloc_pages_current);
 
@@ -1605,6 +1608,28 @@ struct mempolicy *__mpol_dup(struct memp
 	return new;
 }
 
+/*
+ * If *frompol needs [has] an extra ref, copy *frompol to *tompol ,
+ * eliminate the * MPOL_F_* flags that require conditional ref and
+ * [NOTE!!!] drop the extra ref.  Not safe to reference *frompol directly
+ * after return.  Use the returned value.
+ *
+ * Allows use of a mempolicy for, e.g., multiple allocations with a single
+ * policy lookup, even if the policy needs/has extra ref on lookup.
+ * shmem_readahead needs this.
+ */
+struct mempolicy *__mpol_cond_copy(struct mempolicy *tompol,
+						struct mempolicy *frompol)
+{
+	if (!mpol_needs_cond_ref(frompol))
+		return frompol;
+
+	*tompol = *frompol;
+	tompol->flags &= ~MPOL_F_SHARED;	/* copy doesn't need unref */
+	__mpol_put(frompol);
+	return tompol;
+}
+
 static int mpol_match_intent(const struct mempolicy *a,
 			     const struct mempolicy *b)
 {
@@ -1639,15 +1664,6 @@ int __mpol_equal(struct mempolicy *a, st
 	}
 }
 
-/* Slow path of a mpol destructor. */
-void __mpol_put(struct mempolicy *p)
-{
-	if (!atomic_dec_and_test(&p->refcnt))
-		return;
-	p->mode = MPOL_DEFAULT;
-	kmem_cache_free(policy_cache, p);
-}
-
 /*
  * Shared memory backing store policy support.
  *
@@ -2081,11 +2097,7 @@ int show_numa_map(struct seq_file *m, vo
 
 	pol = get_vma_policy(priv->task, vma, vma->vm_start);
 	mpol_to_str(buffer, sizeof(buffer), pol);
-	/*
-	 * unref shared or other task's mempolicy
-	 */
-	if (pol != &default_policy && pol != current->mempolicy)
-		__mpol_put(pol);
+	mpol_cond_put(pol);
 
 	seq_printf(m, "%08lx %s", vma->vm_start, buffer);
 
diff -puN mm/shmem.c~mempolicy-rework-mempolicy-reference-counting mm/shmem.c
--- a/mm/shmem.c~mempolicy-rework-mempolicy-reference-counting
+++ a/mm/shmem.c
@@ -1187,16 +1187,19 @@ static void shmem_show_mpol(struct seq_f
 static struct page *shmem_swapin(swp_entry_t entry, gfp_t gfp,
 			struct shmem_inode_info *info, unsigned long idx)
 {
+	struct mempolicy mpol, *spol;
 	struct vm_area_struct pvma;
 	struct page *page;
 
+	spol = mpol_cond_copy(&mpol,
+				mpol_shared_policy_lookup(&info->policy, idx));
+
 	/* Create a pseudo vma that just contains the policy */
 	pvma.vm_start = 0;
 	pvma.vm_pgoff = idx;
 	pvma.vm_ops = NULL;
-	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, idx);
+	pvma.vm_policy = spol;
 	page = swapin_readahead(entry, gfp, &pvma, 0);
-	mpol_put(pvma.vm_policy);
 	return page;
 }
 
@@ -1204,16 +1207,17 @@ static struct page *shmem_alloc_page(gfp
 			struct shmem_inode_info *info, unsigned long idx)
 {
 	struct vm_area_struct pvma;
-	struct page *page;
 
 	/* Create a pseudo vma that just contains the policy */
 	pvma.vm_start = 0;
 	pvma.vm_pgoff = idx;
 	pvma.vm_ops = NULL;
 	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, idx);
-	page = alloc_page_vma(gfp, &pvma, 0);
-	mpol_put(pvma.vm_policy);
-	return page;
+
+	/*
+	 * alloc_page_vma() will drop the shared policy reference
+	 */
+	return alloc_page_vma(gfp, &pvma, 0);
 }
 #else /* !CONFIG_NUMA */
 #ifdef CONFIG_TMPFS
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

origin.patch
mm-add-nr_writeback_temp-counter-fix.patch

