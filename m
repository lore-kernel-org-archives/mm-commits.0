Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE166189B8C
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 21:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735247786; cv=none; b=CPJVW74m3OwUyBhq8FoCVKUle6UiXv07HU537G2ns/2IVfOhbU4V1Wur0aWqJRyeDYrhXSlD9knYNse3dBvDvNzR0W18IlSvG83P+p7ubr/apJPONFoU4dAy4+7nsOdy6CDm6pVHAzbS9YrHbWn7onQo2+jicEuahx/fJEqtdAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735247786; c=relaxed/simple;
	bh=uZOP9DtIQXqAEjuPh1IWNbiTC1wtqKe6Yld0rIhEjTc=;
	h=Date:To:From:Subject:Message-Id; b=qDsbRHc+CZ8lk5iy2ZL6dZiL4Nb4ymeQi4UMJkxVgFVnkSnZ73ij3vJJgWFlVbgPhel+8y5cbqZUv/GKKjub73pNqfUruk3b0TAcpoIOY+oEbnGN7Cr77+orPyjrcLCxt6RtXeS55RxhegU/ATsNueBrnc41xXXhdbmyFxpBlBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QofzrEcQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QofzrEcQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9F8C4CED1;
	Thu, 26 Dec 2024 21:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735247786;
	bh=uZOP9DtIQXqAEjuPh1IWNbiTC1wtqKe6Yld0rIhEjTc=;
	h=Date:To:From:Subject:From;
	b=QofzrEcQxlrngmvQwlVIbZ8tRLxJ9yPp2fPkbYAyDOzmRo36zLQt+rahw0M9bILnx
	 dQ/ziAbgmH7vVFGPns5pG5fSVp/0oxEjTXktOHvbcFLEXbxOlK1bym8C0AC4VZSf4h
	 HLAFFbUaJI8kRImzBut8t0QZRO8z2CzraM5knSCY=
Date: Thu, 26 Dec 2024 13:16:26 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oliver.sang@intel.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-vma-cache-slab_typesafe_by_rcu.patch added to mm-unstable branch
Message-Id: <20241226211626.9B9F8C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make vma cache SLAB_TYPESAFE_BY_RCU
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-vma-cache-slab_typesafe_by_rcu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-vma-cache-slab_typesafe_by_rcu.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: make vma cache SLAB_TYPESAFE_BY_RCU
Date: Thu, 26 Dec 2024 09:07:08 -0800

To enable SLAB_TYPESAFE_BY_RCU for vma cache we need to ensure that
object reuse before RCU grace period is over will be detected by
lock_vma_under_rcu(). Current checks are sufficient as long as vma
is detached before it is freed. Implement this guarantee by calling
vma_ensure_detached() before vma is freed and make vm_area_cachep
SLAB_TYPESAFE_BY_RCU. This will facilitate vm_area_struct reuse and
will minimize the number of call_rcu() calls.

Link: https://lkml.kernel.org/r/20241226170710.1159679-17-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h               |    2 -
 include/linux/mm_types.h         |   10 ++++++---
 include/linux/slab.h             |    6 -----
 kernel/fork.c                    |   31 ++++++++---------------------
 mm/mmap.c                        |    3 +-
 mm/vma.c                         |   10 ++-------
 mm/vma.h                         |    2 -
 tools/testing/vma/vma_internal.h |    7 ------
 8 files changed, 23 insertions(+), 48 deletions(-)

--- a/include/linux/mm.h~mm-make-vma-cache-slab_typesafe_by_rcu
+++ a/include/linux/mm.h
@@ -258,8 +258,6 @@ void setup_initial_init_mm(void *start_c
 struct vm_area_struct *vm_area_alloc(struct mm_struct *);
 struct vm_area_struct *vm_area_dup(struct vm_area_struct *);
 void vm_area_free(struct vm_area_struct *);
-/* Use only if VMA has no other users */
-void __vm_area_free(struct vm_area_struct *vma);
 
 #ifndef CONFIG_MMU
 extern struct rb_root nommu_region_tree;
--- a/include/linux/mm_types.h~mm-make-vma-cache-slab_typesafe_by_rcu
+++ a/include/linux/mm_types.h
@@ -575,6 +575,12 @@ static inline void *folio_get_private(st
 typedef unsigned long vm_flags_t;
 
 /*
+ * freeptr_t represents a SLUB freelist pointer, which might be encoded
+ * and not dereferenceable if CONFIG_SLAB_FREELIST_HARDENED is enabled.
+ */
+typedef struct { unsigned long v; } freeptr_t;
+
+/*
  * A region containing a mapping of a non-memory backed file under NOMMU
  * conditions.  These are held in a global tree and are pinned by the VMAs that
  * map parts of them.
@@ -687,9 +693,7 @@ struct vm_area_struct {
 			unsigned long vm_start;
 			unsigned long vm_end;
 		};
-#ifdef CONFIG_PER_VMA_LOCK
-		struct rcu_head vm_rcu;	/* Used for deferred freeing. */
-#endif
+		freeptr_t vm_freeptr; /* Pointer used by SLAB_TYPESAFE_BY_RCU */
 	};
 
 	/*
--- a/include/linux/slab.h~mm-make-vma-cache-slab_typesafe_by_rcu
+++ a/include/linux/slab.h
@@ -235,12 +235,6 @@ enum _slab_flag_bits {
 #endif
 
 /*
- * freeptr_t represents a SLUB freelist pointer, which might be encoded
- * and not dereferenceable if CONFIG_SLAB_FREELIST_HARDENED is enabled.
- */
-typedef struct { unsigned long v; } freeptr_t;
-
-/*
  * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
  *
  * Dereferencing ZERO_SIZE_PTR will lead to a distinct access fault.
--- a/kernel/fork.c~mm-make-vma-cache-slab_typesafe_by_rcu
+++ a/kernel/fork.c
@@ -471,7 +471,7 @@ struct vm_area_struct *vm_area_dup(struc
 	return new;
 }
 
-void __vm_area_free(struct vm_area_struct *vma)
+void vm_area_free(struct vm_area_struct *vma)
 {
 	/* The vma should be detached while being destroyed. */
 	vma_assert_detached(vma);
@@ -480,25 +480,6 @@ void __vm_area_free(struct vm_area_struc
 	kmem_cache_free(vm_area_cachep, vma);
 }
 
-#ifdef CONFIG_PER_VMA_LOCK
-static void vm_area_free_rcu_cb(struct rcu_head *head)
-{
-	struct vm_area_struct *vma = container_of(head, struct vm_area_struct,
-						  vm_rcu);
-
-	__vm_area_free(vma);
-}
-#endif
-
-void vm_area_free(struct vm_area_struct *vma)
-{
-#ifdef CONFIG_PER_VMA_LOCK
-	call_rcu(&vma->vm_rcu, vm_area_free_rcu_cb);
-#else
-	__vm_area_free(vma);
-#endif
-}
-
 static void account_kernel_stack(struct task_struct *tsk, int account)
 {
 	if (IS_ENABLED(CONFIG_VMAP_STACK)) {
@@ -3144,6 +3125,11 @@ void __init mm_cache_init(void)
 
 void __init proc_caches_init(void)
 {
+	struct kmem_cache_args args = {
+		.use_freeptr_offset = true,
+		.freeptr_offset = offsetof(struct vm_area_struct, vm_freeptr),
+	};
+
 	sighand_cachep = kmem_cache_create("sighand_cache",
 			sizeof(struct sighand_struct), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_TYPESAFE_BY_RCU|
@@ -3160,8 +3146,9 @@ void __init proc_caches_init(void)
 			sizeof(struct fs_struct), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT,
 			NULL);
-	vm_area_cachep = KMEM_CACHE(vm_area_struct,
-			SLAB_HWCACHE_ALIGN|SLAB_NO_MERGE|SLAB_PANIC|
+	vm_area_cachep = kmem_cache_create("vm_area_struct",
+			sizeof(struct vm_area_struct), &args,
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_TYPESAFE_BY_RCU|
 			SLAB_ACCOUNT);
 	mmap_init();
 	nsproxy_cache_init();
--- a/mm/mmap.c~mm-make-vma-cache-slab_typesafe_by_rcu
+++ a/mm/mmap.c
@@ -1364,7 +1364,8 @@ void exit_mmap(struct mm_struct *mm)
 	do {
 		if (vma->vm_flags & VM_ACCOUNT)
 			nr_accounted += vma_pages(vma);
-		remove_vma(vma, /* unreachable = */ true);
+		vma_mark_detached(vma);
+		remove_vma(vma);
 		count++;
 		cond_resched();
 		vma = vma_next(&vmi);
--- a/mm/vma.c~mm-make-vma-cache-slab_typesafe_by_rcu
+++ a/mm/vma.c
@@ -406,18 +406,14 @@ static bool can_vma_merge_right(struct v
 /*
  * Close a vm structure and free it.
  */
-void remove_vma(struct vm_area_struct *vma, bool unreachable)
+void remove_vma(struct vm_area_struct *vma)
 {
 	might_sleep();
 	vma_close(vma);
 	if (vma->vm_file)
 		fput(vma->vm_file);
 	mpol_put(vma_policy(vma));
-	if (unreachable) {
-		vma_mark_detached(vma);
-		__vm_area_free(vma);
-	} else
-		vm_area_free(vma);
+	vm_area_free(vma);
 }
 
 /*
@@ -1199,7 +1195,7 @@ static void vms_complete_munmap_vmas(str
 	/* Remove and clean up vmas */
 	mas_set(mas_detach, 0);
 	mas_for_each(mas_detach, vma, ULONG_MAX)
-		remove_vma(vma, /* unreachable = */ false);
+		remove_vma(vma);
 
 	vm_unacct_memory(vms->nr_accounted);
 	validate_mm(mm);
--- a/mm/vma.h~mm-make-vma-cache-slab_typesafe_by_rcu
+++ a/mm/vma.h
@@ -173,7 +173,7 @@ int do_vmi_munmap(struct vma_iterator *v
 		  unsigned long start, size_t len, struct list_head *uf,
 		  bool unlock);
 
-void remove_vma(struct vm_area_struct *vma, bool unreachable);
+void remove_vma(struct vm_area_struct *vma);
 
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 		struct vm_area_struct *prev, struct vm_area_struct *next);
--- a/tools/testing/vma/vma_internal.h~mm-make-vma-cache-slab_typesafe_by_rcu
+++ a/tools/testing/vma/vma_internal.h
@@ -693,14 +693,9 @@ static inline void mpol_put(struct mempo
 {
 }
 
-static inline void __vm_area_free(struct vm_area_struct *vma)
-{
-	free(vma);
-}
-
 static inline void vm_area_free(struct vm_area_struct *vma)
 {
-	__vm_area_free(vma);
+	free(vma);
 }
 
 static inline void lru_add_drain(void)
_

Patches currently in -mm which might be from surenb@google.com are

seqlock-add-raw_seqcount_try_begin.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculate_try_beginretry.patch
mm-introduce-vma_start_read_locked_nested-helpers.patch
mm-move-per-vma-lock-into-vm_area_struct.patch
mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch
mm-modify-vma_iter_store_gfp-to-indicate-if-its-storing-a-new-vma.patch
mm-mark-vmas-detached-upon-exit.patch
mm-nommu-fix-the-last-places-where-vma-is-not-locked-before-being-attached.patch
types-move-struct-rcuwait-into-typesh.patch
mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail.patch
mm-move-mmap_init_lock-out-of-the-header-file.patch
mm-uninline-the-main-body-of-vma_start_write.patch
refcount-introduce-__refcount_addinc_not_zero_limited.patch
mm-replace-vm_lock-and-detached-flag-with-a-reference-count.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma-fix.patch
mm-remove-extra-vma_numab_state_init-call.patch
mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
docs-mm-document-latest-changes-to-vm_lock.patch

