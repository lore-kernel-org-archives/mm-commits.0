From: akpm@linux-foundation.org
Subject: - mempolicy-rename-mpol_free-to-mpol_put.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:53:01 -0700
Message-ID: <200804282153.m3SLr1Fd017823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934799AbYD1VxT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:53:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy: rename mpol_free to mpol_put
has been removed from the -mm tree.  Its filename was
     mempolicy-rename-mpol_free-to-mpol_put.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: rename mpol_free to mpol_put
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

This is a change that was requested some time ago by Mel Gorman.  Makes sense
to me, so here it is.

Note: I retain the name "mpol_free_shared_policy()" because it actually does
free the shared_policy, which is NOT a reference counted object.  However, ...

The mempolicy object[s] referenced by the shared_policy are reference counted,
so mpol_put() is used to release the reference held by the shared_policy.  The
mempolicy might not be freed at this time, because some task attached to the
shared object associated with the shared policy may be in the process of
allocating a page based on the mempolicy.  In that case, the task performing
the allocation will hold a reference on the mempolicy, obtained via
mpol_shared_policy_lookup().  The mempolicy will be freed when all tasks
holding such a reference have called mpol_put() for the mempolicy.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |   10 +++++-----
 kernel/exit.c             |    2 +-
 kernel/fork.c             |    2 +-
 mm/hugetlb.c              |    2 +-
 mm/mempolicy.c            |   26 +++++++++++++-------------
 mm/mmap.c                 |    6 +++---
 mm/shmem.c                |    4 ++--
 7 files changed, 26 insertions(+), 26 deletions(-)

diff -puN include/linux/mempolicy.h~mempolicy-rename-mpol_free-to-mpol_put include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mempolicy-rename-mpol_free-to-mpol_put
+++ a/include/linux/mempolicy.h
@@ -71,7 +71,7 @@ struct mm_struct;
  *
  * Freeing policy:
  * Mempolicy objects are reference counted.  A mempolicy will be freed when
- * mpol_free() decrements the reference count to zero.
+ * mpol_put() decrements the reference count to zero.
  *
  * Copying policy objects:
  * mpol_copy() allocates a new mempolicy and copies the specified mempolicy
@@ -98,11 +98,11 @@ struct mempolicy {
  * The default fast path of a NULL MPOL_DEFAULT policy is always inlined.
  */
 
-extern void __mpol_free(struct mempolicy *pol);
-static inline void mpol_free(struct mempolicy *pol)
+extern void __mpol_put(struct mempolicy *pol);
+static inline void mpol_put(struct mempolicy *pol)
 {
 	if (pol)
-		__mpol_free(pol);
+		__mpol_put(pol);
 }
 
 extern struct mempolicy *__mpol_copy(struct mempolicy *pol);
@@ -190,7 +190,7 @@ static inline int mpol_equal(struct memp
 	return 1;
 }
 
-static inline void mpol_free(struct mempolicy *p)
+static inline void mpol_put(struct mempolicy *p)
 {
 }
 
diff -puN kernel/exit.c~mempolicy-rename-mpol_free-to-mpol_put kernel/exit.c
--- a/kernel/exit.c~mempolicy-rename-mpol_free-to-mpol_put
+++ a/kernel/exit.c
@@ -967,7 +967,7 @@ NORET_TYPE void do_exit(long code)
 	proc_exit_connector(tsk);
 	exit_notify(tsk, group_dead);
 #ifdef CONFIG_NUMA
-	mpol_free(tsk->mempolicy);
+	mpol_put(tsk->mempolicy);
 	tsk->mempolicy = NULL;
 #endif
 #ifdef CONFIG_FUTEX
diff -puN kernel/fork.c~mempolicy-rename-mpol_free-to-mpol_put kernel/fork.c
--- a/kernel/fork.c~mempolicy-rename-mpol_free-to-mpol_put
+++ a/kernel/fork.c
@@ -1374,7 +1374,7 @@ bad_fork_cleanup_security:
 	security_task_free(p);
 bad_fork_cleanup_policy:
 #ifdef CONFIG_NUMA
-	mpol_free(p->mempolicy);
+	mpol_put(p->mempolicy);
 bad_fork_cleanup_cgroup:
 #endif
 	cgroup_exit(p, cgroup_callbacks_done);
diff -puN mm/hugetlb.c~mempolicy-rename-mpol_free-to-mpol_put mm/hugetlb.c
--- a/mm/hugetlb.c~mempolicy-rename-mpol_free-to-mpol_put
+++ a/mm/hugetlb.c
@@ -116,7 +116,7 @@ static struct page *dequeue_huge_page_vm
 			break;
 		}
 	}
-	mpol_free(mpol);	/* unref if mpol !NULL */
+	mpol_put(mpol);	/* unref if mpol !NULL */
 	return page;
 }
 
diff -puN mm/mempolicy.c~mempolicy-rename-mpol_free-to-mpol_put mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-rename-mpol_free-to-mpol_put
+++ a/mm/mempolicy.c
@@ -529,7 +529,7 @@ static int policy_vma(struct vm_area_str
 	if (!err) {
 		mpol_get(new);
 		vma->vm_policy = new;
-		mpol_free(old);
+		mpol_put(old);
 	}
 	return err;
 }
@@ -595,7 +595,7 @@ static long do_set_mempolicy(unsigned sh
 	new = mpol_new(mode, flags, nodes);
 	if (IS_ERR(new))
 		return PTR_ERR(new);
-	mpol_free(current->mempolicy);
+	mpol_put(current->mempolicy);
 	current->mempolicy = new;
 	mpol_set_task_struct_flag();
 	if (new && new->policy == MPOL_INTERLEAVE &&
@@ -948,7 +948,7 @@ static long do_mbind(unsigned long start
 	}
 
 	up_write(&mm->mmap_sem);
-	mpol_free(new);
+	mpol_put(new);
 	return err;
 }
 
@@ -1446,14 +1446,14 @@ struct zonelist *huge_zonelist(struct vm
 		nid = interleave_nid(pol, vma, addr, HPAGE_SHIFT);
 		if (unlikely(pol != &default_policy &&
 				pol != current->mempolicy))
-			__mpol_free(pol);	/* finished with pol */
+			__mpol_put(pol);	/* finished with pol */
 		return node_zonelist(nid, gfp_flags);
 	}
 
 	zl = zonelist_policy(GFP_HIGHUSER, pol);
 	if (unlikely(pol != &default_policy && pol != current->mempolicy)) {
 		if (pol->policy != MPOL_BIND)
-			__mpol_free(pol);	/* finished with pol */
+			__mpol_put(pol);	/* finished with pol */
 		else
 			*mpol = pol;	/* unref needed after allocation */
 	}
@@ -1512,7 +1512,7 @@ alloc_page_vma(gfp_t gfp, struct vm_area
 		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT);
 		if (unlikely(pol != &default_policy &&
 				pol != current->mempolicy))
-			__mpol_free(pol);	/* finished with pol */
+			__mpol_put(pol);	/* finished with pol */
 		return alloc_page_interleave(gfp, 0, nid);
 	}
 	zl = zonelist_policy(gfp, pol);
@@ -1522,7 +1522,7 @@ alloc_page_vma(gfp_t gfp, struct vm_area
 		 */
 		struct page *page =  __alloc_pages_nodemask(gfp, 0,
 						zl, nodemask_policy(gfp, pol));
-		__mpol_free(pol);
+		__mpol_put(pol);
 		return page;
 	}
 	/*
@@ -1624,7 +1624,7 @@ int __mpol_equal(struct mempolicy *a, st
 }
 
 /* Slow path of a mpol destructor. */
-void __mpol_free(struct mempolicy *p)
+void __mpol_put(struct mempolicy *p)
 {
 	if (!atomic_dec_and_test(&p->refcnt))
 		return;
@@ -1720,7 +1720,7 @@ static void sp_delete(struct shared_poli
 {
 	pr_debug("deleting %lx-l%lx\n", n->start, n->end);
 	rb_erase(&n->nd, &sp->root);
-	mpol_free(n->policy);
+	mpol_put(n->policy);
 	kmem_cache_free(sn_cache, n);
 }
 
@@ -1780,7 +1780,7 @@ restart:
 		sp_insert(sp, new);
 	spin_unlock(&sp->lock);
 	if (new2) {
-		mpol_free(new2->policy);
+		mpol_put(new2->policy);
 		kmem_cache_free(sn_cache, new2);
 	}
 	return 0;
@@ -1805,7 +1805,7 @@ void mpol_shared_policy_init(struct shar
 			/* Policy covers entire file */
 			pvma.vm_end = TASK_SIZE;
 			mpol_set_shared_policy(info, &pvma, newpol);
-			mpol_free(newpol);
+			mpol_put(newpol);
 		}
 	}
 }
@@ -1848,7 +1848,7 @@ void mpol_free_shared_policy(struct shar
 		n = rb_entry(next, struct sp_node, nd);
 		next = rb_next(&n->nd);
 		rb_erase(&n->nd, &p->root);
-		mpol_free(n->policy);
+		mpol_put(n->policy);
 		kmem_cache_free(sn_cache, n);
 	}
 	spin_unlock(&p->lock);
@@ -2068,7 +2068,7 @@ int show_numa_map(struct seq_file *m, vo
 	 * unref shared or other task's mempolicy
 	 */
 	if (pol != &default_policy && pol != current->mempolicy)
-		__mpol_free(pol);
+		__mpol_put(pol);
 
 	seq_printf(m, "%08lx %s", vma->vm_start, buffer);
 
diff -puN mm/mmap.c~mempolicy-rename-mpol_free-to-mpol_put mm/mmap.c
--- a/mm/mmap.c~mempolicy-rename-mpol_free-to-mpol_put
+++ a/mm/mmap.c
@@ -232,7 +232,7 @@ static struct vm_area_struct *remove_vma
 		vma->vm_ops->close(vma);
 	if (vma->vm_file)
 		fput(vma->vm_file);
-	mpol_free(vma_policy(vma));
+	mpol_put(vma_policy(vma));
 	kmem_cache_free(vm_area_cachep, vma);
 	return next;
 }
@@ -626,7 +626,7 @@ again:			remove_next = 1 + (end > next->
 		if (file)
 			fput(file);
 		mm->map_count--;
-		mpol_free(vma_policy(next));
+		mpol_put(vma_policy(next));
 		kmem_cache_free(vm_area_cachep, next);
 		/*
 		 * In mprotect's case 6 (see comments on vma_merge),
@@ -1182,7 +1182,7 @@ munmap_back:
 
 	if (file && vma_merge(mm, prev, addr, vma->vm_end,
 			vma->vm_flags, NULL, file, pgoff, vma_policy(vma))) {
-		mpol_free(vma_policy(vma));
+		mpol_put(vma_policy(vma));
 		kmem_cache_free(vm_area_cachep, vma);
 		fput(file);
 	} else {
diff -puN mm/shmem.c~mempolicy-rename-mpol_free-to-mpol_put mm/shmem.c
--- a/mm/shmem.c~mempolicy-rename-mpol_free-to-mpol_put
+++ a/mm/shmem.c
@@ -1196,7 +1196,7 @@ static struct page *shmem_swapin(swp_ent
 	pvma.vm_ops = NULL;
 	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, idx);
 	page = swapin_readahead(entry, gfp, &pvma, 0);
-	mpol_free(pvma.vm_policy);
+	mpol_put(pvma.vm_policy);
 	return page;
 }
 
@@ -1212,7 +1212,7 @@ static struct page *shmem_alloc_page(gfp
 	pvma.vm_ops = NULL;
 	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, idx);
 	page = alloc_page_vma(gfp, &pvma, 0);
-	mpol_free(pvma.vm_policy);
+	mpol_put(pvma.vm_policy);
 	return page;
 }
 #else /* !CONFIG_NUMA */
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

origin.patch
mm-add-nr_writeback_temp-counter-fix.patch

