Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D505B1FB
	for <mm-commits@vger.kernel.org>; Sat,  7 Dec 2024 04:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733545771; cv=none; b=FbAPIqrUiyf2GrgzWvz18FzZQKbH5jm7/gs/ggJQqMYuQwPKpMS4iYMwJTFVZREJgxyPcOP4puCeeCqjaAlOW1q3JsNjHzf/fJdFWNwgi2l9fVqNipgROPKDzlZ9txPYf9SQHlNlx2PCPiKXLf75+IFRz5lkq/jqlWc6RLb4H0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733545771; c=relaxed/simple;
	bh=cOhyfh4Shj1Th6d9XFfsxnwx2YaRzeGxUDXNWJuimjk=;
	h=Date:To:From:Subject:Message-Id; b=FmKOWn0GUMzIehTh3TkvsyRAr72BaNsUEeBXiSX4Pj2Re/JX+++ucqyRUXt4j0kbqykOilQujLAg0xRgPJiRqnavmo3/LTz5QZnaTWVFMpkR65bHPvTJZCZa60NwtijeTdhpqJspz4nmH7l+8LYCHVAfVtfu0CgVujastjQ77Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z9E4ZmHN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z9E4ZmHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6627BC4CECD;
	Sat,  7 Dec 2024 04:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733545770;
	bh=cOhyfh4Shj1Th6d9XFfsxnwx2YaRzeGxUDXNWJuimjk=;
	h=Date:To:From:Subject:From;
	b=Z9E4ZmHNZzSTKrb6ehUcY5Zc66Pb+XkbgQ/3UpQuNm4me5J36tYs34zRBLJQsk21R
	 zm8yfUzci2gfulW36C/T+jcM3xeFwHKUDtxo5C90WjGp4IQYsnz9a2zObw10XVsgqL
	 dVv/dBIDTyYXKRDRhNS+G98/ZBeAV+1B3uYDKb2Q=
Date: Fri, 06 Dec 2024 20:29:29 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-vma-cache-slab_typesafe_by_rcu.patch added to mm-unstable branch
Message-Id: <20241207042930.6627BC4CECD@smtp.kernel.org>
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
Date: Fri, 6 Dec 2024 14:52:01 -0800

To enable SLAB_TYPESAFE_BY_RCU for vma cache we need to ensure that object
reuse before RCU grace period is over will be detected inside
lock_vma_under_rcu().

lock_vma_under_rcu() enters RCU read section, finds the vma at the given
address, locks the vma and checks if it got detached or remapped to cover
a different address range.  These last checks are there to ensure that the
vma was not modified after we found it but before locking it.

vma reuse introduces several new possibilities:

1. vma can be reused after it was found but before it is locked;

2. vma can be reused and reinitialized (including changing its vm_mm)
   while being locked in vma_start_read();

3. vma can be reused and reinitialized after it was found but before
   it is locked, then attached at a new address or to a new mm while
   read-locked;

For case #1 current checks will help detecting cases when:

- vma was reused but not yet added into the tree (detached check)

- vma was reused at a different address range (address check);

We are missing the check for vm_mm to ensure the reused vma was not
attached to a different mm.  This patch adds the missing check.  For case
#2, we pass mm to vma_start_read() to prevent access to unstable
vma->vm_mm.  This might lead to vma_start_read() returning a false locked
result but that's not critical if it's rare because it will only lead to a
retry under mmap_lock.

For case #3, we ensure the order in which vma->detached flag and
vm_start/vm_end/vm_mm are set and checked.  vma gets attached after
vm_start/vm_end/vm_mm were set and lock_vma_under_rcu() should check
vma->detached before checking vm_start/vm_end/vm_mm.  This is required
because attaching vma happens without vma write-lock, as opposed to vma
detaching, which requires vma write-lock.  This patch adds memory barriers
inside is_vma_detached() and vma_mark_attached() needed to order reads and
writes to vma->detached vs vm_start/vm_end/vm_mm.  After these provisions,
SLAB_TYPESAFE_BY_RCU is added to vm_area_cachep.  This will facilitate
vm_area_struct reuse and will minimize the number of call_rcu() calls.

Link: https://lkml.kernel.org/r/20241206225204.4008261-5-surenb@google.com
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
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
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

 include/linux/mm.h               |   36 +++++-
 include/linux/mm_types.h         |   10 +
 include/linux/slab.h             |    6 -
 kernel/fork.c                    |  157 +++++++++++++++++++++++------
 mm/memory.c                      |   15 ++
 mm/vma.c                         |    2 
 tools/testing/vma/vma_internal.h |    7 -
 7 files changed, 179 insertions(+), 54 deletions(-)

--- a/include/linux/mm.h~mm-make-vma-cache-slab_typesafe_by_rcu
+++ a/include/linux/mm.h
@@ -257,7 +257,7 @@ struct vm_area_struct *vm_area_alloc(str
 struct vm_area_struct *vm_area_dup(struct vm_area_struct *);
 void vm_area_free(struct vm_area_struct *);
 /* Use only if VMA has no other users */
-void __vm_area_free(struct vm_area_struct *vma);
+void vm_area_free_unreachable(struct vm_area_struct *vma);
 
 #ifndef CONFIG_MMU
 extern struct rb_root nommu_region_tree;
@@ -706,8 +706,10 @@ static inline void vma_lock_init(struct
  * Try to read-lock a vma. The function is allowed to occasionally yield false
  * locked result to avoid performance overhead, in which case we fall back to
  * using mmap_lock. The function should never yield false unlocked result.
+ * False locked result is possible if mm_lock_seq overflows or if vma gets
+ * reused and attached to a different mm before we lock it.
  */
-static inline bool vma_start_read(struct vm_area_struct *vma)
+static inline bool vma_start_read(struct mm_struct *mm, struct vm_area_struct *vma)
 {
 	/*
 	 * Check before locking. A race might cause false locked result.
@@ -716,7 +718,7 @@ static inline bool vma_start_read(struct
 	 * we don't rely on for anything - the mm_lock_seq read against which we
 	 * need ordering is below.
 	 */
-	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(vma->vm_mm->mm_lock_seq.sequence))
+	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(mm->mm_lock_seq.sequence))
 		return false;
 
 	if (unlikely(down_read_trylock(&vma->vm_lock.lock) == 0))
@@ -733,7 +735,7 @@ static inline bool vma_start_read(struct
 	 * after it has been unlocked.
 	 * This pairs with RELEASE semantics in vma_end_write_all().
 	 */
-	if (unlikely(vma->vm_lock_seq == raw_read_seqcount(&vma->vm_mm->mm_lock_seq))) {
+	if (unlikely(vma->vm_lock_seq == raw_read_seqcount(&mm->mm_lock_seq))) {
 		up_read(&vma->vm_lock.lock);
 		return false;
 	}
@@ -822,7 +824,15 @@ static inline void vma_assert_locked(str
 
 static inline void vma_mark_attached(struct vm_area_struct *vma)
 {
-	vma->detached = false;
+	/*
+	 * This pairs with smp_rmb() inside is_vma_detached().
+	 * vma is marked attached after all vma modifications are done and it
+	 * got added into the vma tree. All prior vma modifications should be
+	 * made visible before marking the vma attached.
+	 */
+	smp_wmb();
+	/* This pairs with READ_ONCE() in is_vma_detached(). */
+	WRITE_ONCE(vma->detached, false);
 }
 
 static inline void vma_mark_detached(struct vm_area_struct *vma)
@@ -834,7 +844,18 @@ static inline void vma_mark_detached(str
 
 static inline bool is_vma_detached(struct vm_area_struct *vma)
 {
-	return vma->detached;
+	bool detached;
+
+	/* This pairs with WRITE_ONCE() in vma_mark_attached(). */
+	detached = READ_ONCE(vma->detached);
+	/*
+	 * This pairs with smp_wmb() inside vma_mark_attached() to ensure
+	 * vma->detached is read before vma attributes read later inside
+	 * lock_vma_under_rcu().
+	 */
+	smp_rmb();
+
+	return detached;
 }
 
 static inline void release_fault_lock(struct vm_fault *vmf)
@@ -859,7 +880,7 @@ struct vm_area_struct *lock_vma_under_rc
 #else /* CONFIG_PER_VMA_LOCK */
 
 static inline void vma_lock_init(struct vm_area_struct *vma) {}
-static inline bool vma_start_read(struct vm_area_struct *vma)
+static inline bool vma_start_read(struct mm_struct *mm, struct vm_area_struct *vma)
 		{ return false; }
 static inline void vma_end_read(struct vm_area_struct *vma) {}
 static inline void vma_start_write(struct vm_area_struct *vma) {}
@@ -893,6 +914,7 @@ static inline void assert_fault_locked(s
 
 extern const struct vm_operations_struct vma_dummy_vm_ops;
 
+/* Use on VMAs not created using vm_area_alloc() */
 static inline void vma_init(struct vm_area_struct *vma, struct mm_struct *mm)
 {
 	memset(vma, 0, sizeof(*vma));
--- a/include/linux/mm_types.h~mm-make-vma-cache-slab_typesafe_by_rcu
+++ a/include/linux/mm_types.h
@@ -544,6 +544,12 @@ static inline void *folio_get_private(st
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
@@ -657,9 +663,7 @@ struct vm_area_struct {
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
@@ -436,6 +436,98 @@ static struct kmem_cache *vm_area_cachep
 /* SLAB cache for mm_struct structures (tsk->mm) */
 static struct kmem_cache *mm_cachep;
 
+static void vm_area_ctor(void *data)
+{
+	struct vm_area_struct *vma = (struct vm_area_struct *)data;
+
+#ifdef CONFIG_PER_VMA_LOCK
+	/* vma is not locked, can't use vma_mark_detached() */
+	vma->detached = true;
+#endif
+	INIT_LIST_HEAD(&vma->anon_vma_chain);
+	vma_lock_init(vma);
+}
+
+#ifdef CONFIG_PER_VMA_LOCK
+
+static void vma_clear(struct vm_area_struct *vma, struct mm_struct *mm)
+{
+	vma->vm_mm = mm;
+	vma->vm_ops = &vma_dummy_vm_ops;
+	vma->vm_start = 0;
+	vma->vm_end = 0;
+	vma->anon_vma = NULL;
+	vma->vm_pgoff = 0;
+	vma->vm_file = NULL;
+	vma->vm_private_data = NULL;
+	vm_flags_init(vma, 0);
+	memset(&vma->vm_page_prot, 0, sizeof(vma->vm_page_prot));
+	memset(&vma->shared, 0, sizeof(vma->shared));
+	memset(&vma->vm_userfaultfd_ctx, 0, sizeof(vma->vm_userfaultfd_ctx));
+	vma_numab_state_init(vma);
+#ifdef CONFIG_ANON_VMA_NAME
+	vma->anon_name = NULL;
+#endif
+#ifdef CONFIG_SWAP
+	memset(&vma->swap_readahead_info, 0, sizeof(vma->swap_readahead_info));
+#endif
+#ifndef CONFIG_MMU
+	vma->vm_region = NULL;
+#endif
+#ifdef CONFIG_NUMA
+	vma->vm_policy = NULL;
+#endif
+}
+
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
+	memcpy(&dest->shared, &src->shared, sizeof(dest->shared));
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
+#else /* CONFIG_PER_VMA_LOCK */
+
+static void vma_clear(struct vm_area_struct *vma, struct mm_struct *mm)
+{
+	vma_init(vma, mm);
+}
+
+static void vma_copy(const struct vm_area_struct *src, struct vm_area_struct *dest)
+{
+	/*
+	 * orig->shared.rb may be modified concurrently, but the clone
+	 * will be reinitialized.
+	 */
+	data_race(memcpy(dest, src, sizeof(*dest)));
+}
+
+#endif /* CONFIG_PER_VMA_LOCK */
+
 struct vm_area_struct *vm_area_alloc(struct mm_struct *mm)
 {
 	struct vm_area_struct *vma;
@@ -444,7 +536,7 @@ struct vm_area_struct *vm_area_alloc(str
 	if (!vma)
 		return NULL;
 
-	vma_init(vma, mm);
+	vma_clear(vma, mm);
 
 	return vma;
 }
@@ -458,49 +550,46 @@ struct vm_area_struct *vm_area_dup(struc
 
 	ASSERT_EXCLUSIVE_WRITER(orig->vm_flags);
 	ASSERT_EXCLUSIVE_WRITER(orig->vm_file);
-	/*
-	 * orig->shared.rb may be modified concurrently, but the clone
-	 * will be reinitialized.
-	 */
-	data_race(memcpy(new, orig, sizeof(*new)));
-	vma_lock_init(new);
-	INIT_LIST_HEAD(&new->anon_vma_chain);
-#ifdef CONFIG_PER_VMA_LOCK
-	/* vma is not locked, can't use vma_mark_detached() */
-	new->detached = true;
-#endif
+	vma_copy(orig, new);
 	vma_numab_state_init(new);
 	dup_anon_vma_name(orig, new);
 
 	return new;
 }
 
-void __vm_area_free(struct vm_area_struct *vma)
+static void __vm_area_free(struct vm_area_struct *vma, bool unreachable)
 {
+#ifdef CONFIG_PER_VMA_LOCK
+	/*
+	 * With SLAB_TYPESAFE_BY_RCU, vma can be reused and we need
+	 * vma->detached to be set before vma is returned into the cache.
+	 * This way reused object won't be used by readers until it's
+	 * initialized and reattached.
+	 * If vma is unreachable, there can be no other users and we
+	 * can set vma->detached directly with no risk of a race.
+	 * If vma is reachable, then it should have been already detached
+	 * under vma write-lock or it was never attached.
+	 */
+	if (unreachable)
+		vma->detached = true;
+	else
+		VM_BUG_ON_VMA(!is_vma_detached(vma), vma);
+	vma->vm_lock_seq = UINT_MAX;
+#endif
+	VM_BUG_ON_VMA(!list_empty(&vma->anon_vma_chain), vma);
 	vma_numab_state_free(vma);
 	free_anon_vma_name(vma);
 	kmem_cache_free(vm_area_cachep, vma);
 }
 
-#ifdef CONFIG_PER_VMA_LOCK
-static void vm_area_free_rcu_cb(struct rcu_head *head)
+void vm_area_free(struct vm_area_struct *vma)
 {
-	struct vm_area_struct *vma = container_of(head, struct vm_area_struct,
-						  vm_rcu);
-
-	/* The vma should not be locked while being destroyed. */
-	VM_BUG_ON_VMA(rwsem_is_locked(&vma->vm_lock.lock), vma);
-	__vm_area_free(vma);
+	__vm_area_free(vma, false);
 }
-#endif
 
-void vm_area_free(struct vm_area_struct *vma)
+void vm_area_free_unreachable(struct vm_area_struct *vma)
 {
-#ifdef CONFIG_PER_VMA_LOCK
-	call_rcu(&vma->vm_rcu, vm_area_free_rcu_cb);
-#else
-	__vm_area_free(vma);
-#endif
+	__vm_area_free(vma, true);
 }
 
 static void account_kernel_stack(struct task_struct *tsk, int account)
@@ -3140,6 +3229,12 @@ void __init mm_cache_init(void)
 
 void __init proc_caches_init(void)
 {
+	struct kmem_cache_args args = {
+		.use_freeptr_offset = true,
+		.freeptr_offset = offsetof(struct vm_area_struct, vm_freeptr),
+		.ctor = vm_area_ctor,
+	};
+
 	sighand_cachep = kmem_cache_create("sighand_cache",
 			sizeof(struct sighand_struct), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_TYPESAFE_BY_RCU|
@@ -3156,9 +3251,11 @@ void __init proc_caches_init(void)
 			sizeof(struct fs_struct), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT,
 			NULL);
-	vm_area_cachep = KMEM_CACHE(vm_area_struct,
-			SLAB_HWCACHE_ALIGN|SLAB_NO_MERGE|SLAB_PANIC|
+	vm_area_cachep = kmem_cache_create("vm_area_struct",
+			sizeof(struct vm_area_struct), &args,
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_TYPESAFE_BY_RCU|
 			SLAB_ACCOUNT);
+
 	mmap_init();
 	nsproxy_cache_init();
 }
--- a/mm/memory.c~mm-make-vma-cache-slab_typesafe_by_rcu
+++ a/mm/memory.c
@@ -6346,10 +6346,16 @@ retry:
 	if (!vma)
 		goto inval;
 
-	if (!vma_start_read(vma))
+	if (!vma_start_read(mm, vma))
 		goto inval;
 
-	/* Check if the VMA got isolated after we found it */
+	/*
+	 * Check if the VMA got isolated after we found it.
+	 * Note: vma we found could have been recycled and is being reattached.
+	 * It's possible to attach a vma while it is read-locked, however a
+	 * read-locked vma can't be detached (detaching requires write-locking).
+	 * Therefore if this check passes, we have an attached and stable vma.
+	 */
 	if (is_vma_detached(vma)) {
 		vma_end_read(vma);
 		count_vm_vma_lock_event(VMA_LOCK_MISS);
@@ -6363,8 +6369,9 @@ retry:
 	 * fields are accessible for RCU readers.
 	 */
 
-	/* Check since vm_start/vm_end might change before we lock the VMA */
-	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
+	/* Check if the vma we locked is the right one. */
+	if (unlikely(vma->vm_mm != mm ||
+		     address < vma->vm_start || address >= vma->vm_end))
 		goto inval_end_read;
 
 	rcu_read_unlock();
--- a/mm/vma.c~mm-make-vma-cache-slab_typesafe_by_rcu
+++ a/mm/vma.c
@@ -414,7 +414,7 @@ void remove_vma(struct vm_area_struct *v
 		fput(vma->vm_file);
 	mpol_put(vma_policy(vma));
 	if (unreachable)
-		__vm_area_free(vma);
+		vm_area_free_unreachable(vma);
 	else
 		vm_area_free(vma);
 }
--- a/tools/testing/vma/vma_internal.h~mm-make-vma-cache-slab_typesafe_by_rcu
+++ a/tools/testing/vma/vma_internal.h
@@ -685,14 +685,15 @@ static inline void mpol_put(struct mempo
 {
 }
 
-static inline void __vm_area_free(struct vm_area_struct *vma)
+static inline void vm_area_free(struct vm_area_struct *vma)
 {
 	free(vma);
 }
 
-static inline void vm_area_free(struct vm_area_struct *vma)
+static inline void vm_area_free_unreachable(struct vm_area_struct *vma)
 {
-	__vm_area_free(vma);
+	vma->detached = true;
+	vm_area_free(vma);
 }
 
 static inline void lru_add_drain(void)
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-fix-module-allocation-tags-populated-area-calculation.patch
alloc_tag-fix-set_codetag_empty-when-config_mem_alloc_profiling_debug.patch
seqlock-add-raw_seqcount_try_begin.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculate_try_beginretry.patch
mm-introduce-vma_start_read_locked_nested-helpers.patch
mm-move-per-vma-lock-into-vm_area_struct.patch
mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
mm-slab-allow-freeptr_offset-to-be-used-with-ctor.patch
docs-mm-document-latest-changes-to-vm_lock.patch

