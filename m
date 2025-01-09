Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1B3143888
	for <mm-commits@vger.kernel.org>; Thu,  9 Jan 2025 05:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736401494; cv=none; b=sxGUJ0Z3nihtI69VpXszoHoTi83JdzxdVL1OaXnin8yXhYcQm9LRbQ5w3aACR4WVot+sVWHJ3QJ714P/5dYYjz85/s2MJ1gOKUVIPxboSiM1As8NO1h2gTe57P/r0aoy2Y151kFeOG+ho+4WrQoIhgwJNtAV82sFM0CaBIgmw4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736401494; c=relaxed/simple;
	bh=Y6xfUZJGnnitPcLlGirOW8SxFFChXRiyVz8ZpNhjoEI=;
	h=Date:To:From:Subject:Message-Id; b=iu7ZvMHuvQny2psbfH4VFiI9mRJhw60AdNCwByVtfZuCBp7xsTc4D0HTF4qgUUC2VnbFoDFczMAg9gLn55d58gMGWmhyXroqqOTZk18IQGTzkhlXCl7iJX5jMGesYVWMa09lh4zBqf4H7I468uEuN9wDFXHfyUQmzXkvGD2kXuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gyTq2B6m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gyTq2B6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B211AC4CED2;
	Thu,  9 Jan 2025 05:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736401493;
	bh=Y6xfUZJGnnitPcLlGirOW8SxFFChXRiyVz8ZpNhjoEI=;
	h=Date:To:From:Subject:From;
	b=gyTq2B6mT1sgtVzroY42rrV1/x/d0niS+tE/AZ8RTnwfV5DUJfToG16hKQLbTofff
	 rup+v5iYuwYperyyzllEccS3HlcHrPouMJxIlSNfljNcwh6CKsZroqE/pgKOLy6WSE
	 Q0y7ZdLTIhzm1ld4NYfEyDkCARI5EWuMPWwrfJdQ=
Date: Wed, 08 Jan 2025 21:44:53 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-vma-cache-slab_typesafe_by_rcu.patch added to mm-unstable branch
Message-Id: <20250109054453.B211AC4CED2@smtp.kernel.org>
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
Date: Wed, 8 Jan 2025 18:30:24 -0800

To enable SLAB_TYPESAFE_BY_RCU for vma cache we need to ensure that object
reuse before RCU grace period is over will be detected by
lock_vma_under_rcu().

Current checks are sufficient as long as vma is detached before it is
freed.  The only place this is not currently happening is in exit_mmap(). 
Add the missing vma_mark_detached() in exit_mmap().  Another issue which
might trick lock_vma_under_rcu() during vma reuse is vm_area_dup(), which
copies the entire content of the vma into a new one, overriding new vma's
vm_refcnt and temporarily making it appear as attached.  This might trick
a racing lock_vma_under_rcu() to operate on a reused vma if it found the
vma before it got reused.  To prevent this situation, we should ensure
that vm_refcnt stays at detached state (0) when it is copied and advances
to attached state only after it is added into the vma tree.  Introduce
vma_copy() which preserves new vma's vm_refcnt and use it in
vm_area_dup().  Since all vmas are in detached state with no current
readers when they are freed, lock_vma_under_rcu() will not be able to take
vm_refcnt after vma got detached even if vma is reused.

Finally, make vm_area_cachep SLAB_TYPESAFE_BY_RCU.  This will facilitate
vm_area_struct reuse and will minimize the number of call_rcu() calls.

Link: https://lkml.kernel.org/r/20250109023025.2242447-16-surenb@google.com
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
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h               |    2 
 include/linux/mm_types.h         |   10 ++--
 include/linux/slab.h             |    6 --
 kernel/fork.c                    |   72 ++++++++++++++++++-----------
 mm/mmap.c                        |    3 -
 mm/vma.c                         |   11 +---
 mm/vma.h                         |    2 
 tools/testing/vma/vma_internal.h |    7 --
 8 files changed, 59 insertions(+), 54 deletions(-)

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
@@ -449,6 +449,41 @@ struct vm_area_struct *vm_area_alloc(str
 	return vma;
 }
 
+static void vma_copy(const struct vm_area_struct *src, struct vm_area_struct *dest)
+{
+	dest->vm_mm = src->vm_mm;
+	dest->vm_ops = src->vm_ops;
+	dest->vm_start = src->vm_start;
+	dest->vm_end = src->vm_end;
+	dest->anon_vma = src->anon_vma;
+	dest->vm_pgoff = src->vm_pgoff;
+	dest->vm_file = src->vm_file;
+	dest->vm_private_data = src->vm_private_data;
+	vm_flags_init(dest, src->vm_flags);
+	memcpy(&dest->vm_page_prot, &src->vm_page_prot,
+	       sizeof(dest->vm_page_prot));
+	/*
+	 * src->shared.rb may be modified concurrently, but the clone
+	 * will be reinitialized.
+	 */
+	data_race(memcpy(&dest->shared, &src->shared, sizeof(dest->shared)));
+	memcpy(&dest->vm_userfaultfd_ctx, &src->vm_userfaultfd_ctx,
+	       sizeof(dest->vm_userfaultfd_ctx));
+#ifdef CONFIG_ANON_VMA_NAME
+	dest->anon_name = src->anon_name;
+#endif
+#ifdef CONFIG_SWAP
+	memcpy(&dest->swap_readahead_info, &src->swap_readahead_info,
+	       sizeof(dest->swap_readahead_info));
+#endif
+#ifndef CONFIG_MMU
+	dest->vm_region = src->vm_region;
+#endif
+#ifdef CONFIG_NUMA
+	dest->vm_policy = src->vm_policy;
+#endif
+}
+
 struct vm_area_struct *vm_area_dup(struct vm_area_struct *orig)
 {
 	struct vm_area_struct *new = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
@@ -458,11 +493,7 @@ struct vm_area_struct *vm_area_dup(struc
 
 	ASSERT_EXCLUSIVE_WRITER(orig->vm_flags);
 	ASSERT_EXCLUSIVE_WRITER(orig->vm_file);
-	/*
-	 * orig->shared.rb may be modified concurrently, but the clone
-	 * will be reinitialized.
-	 */
-	data_race(memcpy(new, orig, sizeof(*new)));
+	vma_copy(orig, new);
 	vma_lock_init(new, true);
 	INIT_LIST_HEAD(&new->anon_vma_chain);
 	vma_numab_state_init(new);
@@ -471,7 +502,7 @@ struct vm_area_struct *vm_area_dup(struc
 	return new;
 }
 
-void __vm_area_free(struct vm_area_struct *vma)
+void vm_area_free(struct vm_area_struct *vma)
 {
 	/* The vma should be detached while being destroyed. */
 	vma_assert_detached(vma);
@@ -480,25 +511,6 @@ void __vm_area_free(struct vm_area_struc
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
@@ -3144,6 +3156,11 @@ void __init mm_cache_init(void)
 
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
@@ -3160,8 +3177,9 @@ void __init proc_caches_init(void)
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
@@ -406,19 +406,14 @@ static bool can_vma_merge_right(struct v
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
-	} else {
-		vm_area_free(vma);
-	}
+	vm_area_free(vma);
 }
 
 /*
@@ -1200,7 +1195,7 @@ static void vms_complete_munmap_vmas(str
 	/* Remove and clean up vmas */
 	mas_set(mas_detach, 0);
 	mas_for_each(mas_detach, vma, ULONG_MAX)
-		remove_vma(vma, /* unreachable = */ false);
+		remove_vma(vma);
 
 	vm_unacct_memory(vms->nr_accounted);
 	validate_mm(mm);
--- a/mm/vma.h~mm-make-vma-cache-slab_typesafe_by_rcu
+++ a/mm/vma.h
@@ -170,7 +170,7 @@ int do_vmi_munmap(struct vma_iterator *v
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

alloc_tag-skip-pgalloc_tag_swap-if-profiling-is-disabled.patch
tools-fix-atomic_set-definition-to-set-the-value-correctly.patch
seqlock-add-raw_seqcount_try_begin.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculate_try_beginretry.patch
mm-introduce-vma_start_read_locked_nested-helpers.patch
mm-move-per-vma-lock-into-vm_area_struct.patch
mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch
mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas.patch
mm-mark-vmas-detached-upon-exit.patch
types-move-struct-rcuwait-into-typesh.patch
mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail.patch
mm-move-mmap_init_lock-out-of-the-header-file.patch
mm-uninline-the-main-body-of-vma_start_write.patch
refcount-introduce-__refcount_addinc_not_zero_limited.patch
mm-replace-vm_lock-and-detached-flag-with-a-reference-count.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch
mm-remove-extra-vma_numab_state_init-call.patch
mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
docs-mm-document-latest-changes-to-vm_lock.patch
alloc_tag-avoid-current-alloc_tag-manipulations-when-profiling-is-disabled.patch

