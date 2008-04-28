From: akpm@linux-foundation.org
Subject: - mempolicy-rename-mpol_copy-to-mpol_dup.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:53:04 -0700
Message-ID: <200804282153.m3SLr4VX017835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934904AbYD1VxV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:53:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy: rename mpol_copy to mpol_dup
has been removed from the -mm tree.  Its filename was
     mempolicy-rename-mpol_copy-to-mpol_dup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: rename mpol_copy to mpol_dup
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

This patch renames mpol_copy() to mpol_dup() because, well, that's what it
does.  Like, e.g., strdup() for strings, mpol_dup() takes a pointer to an
existing mempolicy, allocates a new one and copies the contents.

In a later patch, I want to use the name mpol_copy() to copy the contents from
one mempolicy to another like, e.g., strcpy() does for strings.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |   14 +++++++-------
 kernel/cpuset.c           |    4 ++--
 kernel/fork.c             |    4 ++--
 mm/mempolicy.c            |    6 +++---
 mm/mmap.c                 |    4 ++--
 5 files changed, 16 insertions(+), 16 deletions(-)

diff -puN include/linux/mempolicy.h~mempolicy-rename-mpol_copy-to-mpol_dup include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mempolicy-rename-mpol_copy-to-mpol_dup
+++ a/include/linux/mempolicy.h
@@ -73,10 +73,10 @@ struct mm_struct;
  * Mempolicy objects are reference counted.  A mempolicy will be freed when
  * mpol_put() decrements the reference count to zero.
  *
- * Copying policy objects:
- * mpol_copy() allocates a new mempolicy and copies the specified mempolicy
+ * Duplicating policy objects:
+ * mpol_dup() allocates a new mempolicy and copies the specified mempolicy
  * to the new storage.  The reference count of the new object is initialized
- * to 1, representing the caller of mpol_copy().
+ * to 1, representing the caller of mpol_dup().
  */
 struct mempolicy {
 	atomic_t refcnt;
@@ -105,11 +105,11 @@ static inline void mpol_put(struct mempo
 		__mpol_put(pol);
 }
 
-extern struct mempolicy *__mpol_copy(struct mempolicy *pol);
-static inline struct mempolicy *mpol_copy(struct mempolicy *pol)
+extern struct mempolicy *__mpol_dup(struct mempolicy *pol);
+static inline struct mempolicy *mpol_dup(struct mempolicy *pol)
 {
 	if (pol)
-		pol = __mpol_copy(pol);
+		pol = __mpol_dup(pol);
 	return pol;
 }
 
@@ -198,7 +198,7 @@ static inline void mpol_get(struct mempo
 {
 }
 
-static inline struct mempolicy *mpol_copy(struct mempolicy *old)
+static inline struct mempolicy *mpol_dup(struct mempolicy *old)
 {
 	return NULL;
 }
diff -puN kernel/cpuset.c~mempolicy-rename-mpol_copy-to-mpol_dup kernel/cpuset.c
--- a/kernel/cpuset.c~mempolicy-rename-mpol_copy-to-mpol_dup
+++ a/kernel/cpuset.c
@@ -941,7 +941,7 @@ static int update_nodemask(struct cpuset
 	cs->mems_generation = cpuset_mems_generation++;
 	mutex_unlock(&callback_mutex);
 
-	cpuset_being_rebound = cs;		/* causes mpol_copy() rebind */
+	cpuset_being_rebound = cs;		/* causes mpol_dup() rebind */
 
 	fudge = 10;				/* spare mmarray[] slots */
 	fudge += cpus_weight(cs->cpus_allowed);	/* imagine one fork-bomb/cpu */
@@ -992,7 +992,7 @@ static int update_nodemask(struct cpuset
 	 * rebind the vma mempolicies of each mm in mmarray[] to their
 	 * new cpuset, and release that mm.  The mpol_rebind_mm()
 	 * call takes mmap_sem, which we couldn't take while holding
-	 * tasklist_lock.  Forks can happen again now - the mpol_copy()
+	 * tasklist_lock.  Forks can happen again now - the mpol_dup()
 	 * cpuset_being_rebound check will catch such forks, and rebind
 	 * their vma mempolicies too.  Because we still hold the global
 	 * cgroup_mutex, we know that no other rebind effort will
diff -puN kernel/fork.c~mempolicy-rename-mpol_copy-to-mpol_dup kernel/fork.c
--- a/kernel/fork.c~mempolicy-rename-mpol_copy-to-mpol_dup
+++ a/kernel/fork.c
@@ -279,7 +279,7 @@ static int dup_mmap(struct mm_struct *mm
 		if (!tmp)
 			goto fail_nomem;
 		*tmp = *mpnt;
-		pol = mpol_copy(vma_policy(mpnt));
+		pol = mpol_dup(vma_policy(mpnt));
 		retval = PTR_ERR(pol);
 		if (IS_ERR(pol))
 			goto fail_nomem_policy;
@@ -1116,7 +1116,7 @@ static struct task_struct *copy_process(
 	p->audit_context = NULL;
 	cgroup_fork(p);
 #ifdef CONFIG_NUMA
- 	p->mempolicy = mpol_copy(p->mempolicy);
+	p->mempolicy = mpol_dup(p->mempolicy);
  	if (IS_ERR(p->mempolicy)) {
  		retval = PTR_ERR(p->mempolicy);
  		p->mempolicy = NULL;
diff -puN mm/mempolicy.c~mempolicy-rename-mpol_copy-to-mpol_dup mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-rename-mpol_copy-to-mpol_dup
+++ a/mm/mempolicy.c
@@ -1566,15 +1566,15 @@ struct page *alloc_pages_current(gfp_t g
 EXPORT_SYMBOL(alloc_pages_current);
 
 /*
- * If mpol_copy() sees current->cpuset == cpuset_being_rebound, then it
+ * If mpol_dup() sees current->cpuset == cpuset_being_rebound, then it
  * rebinds the mempolicy its copying by calling mpol_rebind_policy()
  * with the mems_allowed returned by cpuset_mems_allowed().  This
  * keeps mempolicies cpuset relative after its cpuset moves.  See
  * further kernel/cpuset.c update_nodemask().
  */
 
-/* Slow path of a mempolicy copy */
-struct mempolicy *__mpol_copy(struct mempolicy *old)
+/* Slow path of a mempolicy duplicate */
+struct mempolicy *__mpol_dup(struct mempolicy *old)
 {
 	struct mempolicy *new = kmem_cache_alloc(policy_cache, GFP_KERNEL);
 
diff -puN mm/mmap.c~mempolicy-rename-mpol_copy-to-mpol_dup mm/mmap.c
--- a/mm/mmap.c~mempolicy-rename-mpol_copy-to-mpol_dup
+++ a/mm/mmap.c
@@ -1810,7 +1810,7 @@ int split_vma(struct mm_struct * mm, str
 		new->vm_pgoff += ((addr - vma->vm_start) >> PAGE_SHIFT);
 	}
 
-	pol = mpol_copy(vma_policy(vma));
+	pol = mpol_dup(vma_policy(vma));
 	if (IS_ERR(pol)) {
 		kmem_cache_free(vm_area_cachep, new);
 		return PTR_ERR(pol);
@@ -2126,7 +2126,7 @@ struct vm_area_struct *copy_vma(struct v
 		new_vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 		if (new_vma) {
 			*new_vma = *vma;
-			pol = mpol_copy(vma_policy(vma));
+			pol = mpol_dup(vma_policy(vma));
 			if (IS_ERR(pol)) {
 				kmem_cache_free(vm_area_cachep, new_vma);
 				return NULL;
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

origin.patch
mm-add-nr_writeback_temp-counter-fix.patch

