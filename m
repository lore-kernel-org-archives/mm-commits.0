Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B39138DE0
	for <mm-commits@vger.kernel.org>; Sat, 15 Feb 2025 00:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739580134; cv=none; b=MydushZba4D/gfGZFx/EI609ZuXiiU2P7dHWPzLDvx/VT3LBVFhWHrhaRyWFWKr+oLBU5RPxMuTK1NH+d4xMLphn69ANdbr3mqM+HTR+7vlEzTCBfSnjS2yIxrhh7PTroptcKzsw9TUNFiHMr5BdYdL0wMqfEZWOmGrgJzz0Gc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739580134; c=relaxed/simple;
	bh=Pt+B+5iGNKe15GyNS8ytlitTo4HnMZL6+9PJDDPkc+M=;
	h=Date:To:From:Subject:Message-Id; b=bk3UHfd+G70BexkMKoHnlNPSFgTMfeQrAKAO/IFSeQqGBJDUBXuyZpwLyi3iEeGZ0zyEKBQ6kG3xVrSDT5zoA0o++dUYmxaebu2QFmNRT3Gswg/pqDGFxDY40yU6zMCgNcnwmkWU7nxvj9vZpkRmBsaXuYkYZUhuaf75r8iMAms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=II/n4U0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="II/n4U0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F0FC4CED1;
	Sat, 15 Feb 2025 00:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739580134;
	bh=Pt+B+5iGNKe15GyNS8ytlitTo4HnMZL6+9PJDDPkc+M=;
	h=Date:To:From:Subject:From;
	b=II/n4U0jC2LShMyMlVDiUwocioesMhDrhaDkMf8uKZ24lVeOopQZWzDlKmM9j7t8L
	 AdBTI4skZqzz64vSqOI84R7IxaNZQFfxdZNt3iuz92WdBGkqi4Ol/dQAEhZMfYCmtI
	 F/62Iw6iLXEhkynYRpPG79L+00nF1x8wMHjVHsSY=
Date: Fri, 14 Feb 2025 16:42:13 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,souravpanda@google.com,shivankg@amd.com,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas.patch added to mm-unstable branch
Message-Id: <20250215004214.53F0FC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce vma_iter_store_attached() to use with attached vmas
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas.patch

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
Subject: mm: introduce vma_iter_store_attached() to use with attached vmas
Date: Thu, 13 Feb 2025 14:46:41 -0800

vma_iter_store() functions can be used both when adding a new vma and when
updating an existing one.  However for existing ones we do not need to
mark them attached as they are already marked that way.  With
vma->detached being a separate flag, double-marking a vmas as attached or
detached is not an issue because the flag will simply be overwritten with
the same value.  However once we fold this flag into the refcount later in
this series, re-attaching or re-detaching a vma becomes an issue since
these operations will be incrementing/decrementing a refcount.

Introduce vma_iter_store_new() and vma_iter_store_overwrite() to replace
vma_iter_store() and avoid re-attaching a vma during vma update.  Add
assertions in vma_mark_attached()/vma_mark_detached() to catch invalid
usage.  Update vma tests to check for vma detached state correctness.

Link: https://lkml.kernel.org/r/20250213224655.1680278-5-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
  Link: https://lkml.kernel.org/r/5e19ec93-8307-47c2-bb13-3ddf7150624e@amd.com
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h               |   14 +++++++++
 mm/nommu.c                       |    4 +-
 mm/vma.c                         |   12 ++++----
 mm/vma.h                         |   11 ++++++-
 tools/testing/vma/vma.c          |   42 ++++++++++++++++++++++-------
 tools/testing/vma/vma_internal.h |   10 ++++++
 6 files changed, 74 insertions(+), 19 deletions(-)

--- a/include/linux/mm.h~mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas
+++ a/include/linux/mm.h
@@ -821,8 +821,19 @@ static inline void vma_assert_locked(str
 		vma_assert_write_locked(vma);
 }
 
+static inline void vma_assert_attached(struct vm_area_struct *vma)
+{
+	WARN_ON_ONCE(vma->detached);
+}
+
+static inline void vma_assert_detached(struct vm_area_struct *vma)
+{
+	WARN_ON_ONCE(!vma->detached);
+}
+
 static inline void vma_mark_attached(struct vm_area_struct *vma)
 {
+	vma_assert_detached(vma);
 	vma->detached = false;
 }
 
@@ -830,6 +841,7 @@ static inline void vma_mark_detached(str
 {
 	/* When detaching vma should be write-locked */
 	vma_assert_write_locked(vma);
+	vma_assert_attached(vma);
 	vma->detached = true;
 }
 
@@ -866,6 +878,8 @@ static inline void vma_end_read(struct v
 static inline void vma_start_write(struct vm_area_struct *vma) {}
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 		{ mmap_assert_write_locked(vma->vm_mm); }
+static inline void vma_assert_attached(struct vm_area_struct *vma) {}
+static inline void vma_assert_detached(struct vm_area_struct *vma) {}
 static inline void vma_mark_attached(struct vm_area_struct *vma) {}
 static inline void vma_mark_detached(struct vm_area_struct *vma) {}
 
--- a/mm/nommu.c~mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas
+++ a/mm/nommu.c
@@ -1191,7 +1191,7 @@ share:
 	setup_vma_to_mm(vma, current->mm);
 	current->mm->map_count++;
 	/* add the VMA to the tree */
-	vma_iter_store(&vmi, vma);
+	vma_iter_store_new(&vmi, vma);
 
 	/* we flush the region from the icache only when the first executable
 	 * mapping of it is made  */
@@ -1356,7 +1356,7 @@ static int split_vma(struct vma_iterator
 
 	setup_vma_to_mm(vma, mm);
 	setup_vma_to_mm(new, mm);
-	vma_iter_store(vmi, new);
+	vma_iter_store_new(vmi, new);
 	mm->map_count++;
 	return 0;
 
--- a/mm/vma.c~mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas
+++ a/mm/vma.c
@@ -320,7 +320,7 @@ static void vma_complete(struct vma_prep
 		 * us to insert it before dropping the locks
 		 * (it may either follow vma or precede it).
 		 */
-		vma_iter_store(vmi, vp->insert);
+		vma_iter_store_new(vmi, vp->insert);
 		mm->map_count++;
 	}
 
@@ -700,7 +700,7 @@ static int commit_merge(struct vma_merge
 			      vmg->__adjust_middle_start ? vmg->middle : NULL);
 	vma_set_range(vma, vmg->start, vmg->end, vmg->pgoff);
 	vmg_adjust_set_range(vmg);
-	vma_iter_store(vmg->vmi, vmg->target);
+	vma_iter_store_overwrite(vmg->vmi, vmg->target);
 
 	vma_complete(&vp, vmg->vmi, vma->vm_mm);
 
@@ -1707,7 +1707,7 @@ int vma_link(struct mm_struct *mm, struc
 		return -ENOMEM;
 
 	vma_start_write(vma);
-	vma_iter_store(&vmi, vma);
+	vma_iter_store_new(&vmi, vma);
 	vma_link_file(vma);
 	mm->map_count++;
 	validate_mm(mm);
@@ -2386,7 +2386,7 @@ static int __mmap_new_vma(struct mmap_st
 
 	/* Lock the VMA since it is modified after insertion into VMA tree */
 	vma_start_write(vma);
-	vma_iter_store(vmi, vma);
+	vma_iter_store_new(vmi, vma);
 	map->mm->map_count++;
 	vma_link_file(vma);
 
@@ -2862,7 +2862,7 @@ int expand_upwards(struct vm_area_struct
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_end = address;
 				/* Overwrite old entry in mtree. */
-				vma_iter_store(&vmi, vma);
+				vma_iter_store_overwrite(&vmi, vma);
 				anon_vma_interval_tree_post_update_vma(vma);
 
 				perf_event_mmap(vma);
@@ -2942,7 +2942,7 @@ int expand_downwards(struct vm_area_stru
 				vma->vm_start = address;
 				vma->vm_pgoff -= grow;
 				/* Overwrite old entry in mtree. */
-				vma_iter_store(&vmi, vma);
+				vma_iter_store_overwrite(&vmi, vma);
 				anon_vma_interval_tree_post_update_vma(vma);
 
 				perf_event_mmap(vma);
--- a/mm/vma.h~mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas
+++ a/mm/vma.h
@@ -413,9 +413,10 @@ static inline struct vm_area_struct *vma
 }
 
 /* Store a VMA with preallocated memory */
-static inline void vma_iter_store(struct vma_iterator *vmi,
-				  struct vm_area_struct *vma)
+static inline void vma_iter_store_overwrite(struct vma_iterator *vmi,
+					    struct vm_area_struct *vma)
 {
+	vma_assert_attached(vma);
 
 #if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
 	if (MAS_WARN_ON(&vmi->mas, vmi->mas.status != ma_start &&
@@ -438,7 +439,13 @@ static inline void vma_iter_store(struct
 
 	__mas_set_range(&vmi->mas, vma->vm_start, vma->vm_end - 1);
 	mas_store_prealloc(&vmi->mas, vma);
+}
+
+static inline void vma_iter_store_new(struct vma_iterator *vmi,
+				      struct vm_area_struct *vma)
+{
 	vma_mark_attached(vma);
+	vma_iter_store_overwrite(vmi, vma);
 }
 
 static inline unsigned long vma_iter_addr(struct vma_iterator *vmi)
--- a/tools/testing/vma/vma.c~mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas
+++ a/tools/testing/vma/vma.c
@@ -74,11 +74,23 @@ static struct vm_area_struct *alloc_vma(
 	ret->vm_end = end;
 	ret->vm_pgoff = pgoff;
 	ret->__vm_flags = flags;
+	vma_assert_detached(ret);
 
 	return ret;
 }
 
 /* Helper function to allocate a VMA and link it to the tree. */
+static int attach_vma(struct mm_struct *mm, struct vm_area_struct *vma)
+{
+	int res;
+
+	res = vma_link(mm, vma);
+	if (!res)
+		vma_assert_attached(vma);
+	return res;
+}
+
+/* Helper function to allocate a VMA and link it to the tree. */
 static struct vm_area_struct *alloc_and_link_vma(struct mm_struct *mm,
 						 unsigned long start,
 						 unsigned long end,
@@ -90,7 +102,7 @@ static struct vm_area_struct *alloc_and_
 	if (vma == NULL)
 		return NULL;
 
-	if (vma_link(mm, vma)) {
+	if (attach_vma(mm, vma)) {
 		vm_area_free(vma);
 		return NULL;
 	}
@@ -108,6 +120,7 @@ static struct vm_area_struct *alloc_and_
 /* Helper function which provides a wrapper around a merge new VMA operation. */
 static struct vm_area_struct *merge_new(struct vma_merge_struct *vmg)
 {
+	struct vm_area_struct *vma;
 	/*
 	 * For convenience, get prev and next VMAs. Which the new VMA operation
 	 * requires.
@@ -116,7 +129,11 @@ static struct vm_area_struct *merge_new(
 	vmg->prev = vma_prev(vmg->vmi);
 	vma_iter_next_range(vmg->vmi);
 
-	return vma_merge_new_range(vmg);
+	vma = vma_merge_new_range(vmg);
+	if (vma)
+		vma_assert_attached(vma);
+
+	return vma;
 }
 
 /*
@@ -125,7 +142,12 @@ static struct vm_area_struct *merge_new(
  */
 static struct vm_area_struct *merge_existing(struct vma_merge_struct *vmg)
 {
-	return vma_merge_existing_range(vmg);
+	struct vm_area_struct *vma;
+
+	vma = vma_merge_existing_range(vmg);
+	if (vma)
+		vma_assert_attached(vma);
+	return vma;
 }
 
 /*
@@ -260,8 +282,8 @@ static bool test_simple_merge(void)
 		.pgoff = 1,
 	};
 
-	ASSERT_FALSE(vma_link(&mm, vma_left));
-	ASSERT_FALSE(vma_link(&mm, vma_right));
+	ASSERT_FALSE(attach_vma(&mm, vma_left));
+	ASSERT_FALSE(attach_vma(&mm, vma_right));
 
 	vma = merge_new(&vmg);
 	ASSERT_NE(vma, NULL);
@@ -285,7 +307,7 @@ static bool test_simple_modify(void)
 	struct vm_area_struct *init_vma = alloc_vma(&mm, 0, 0x3000, 0, flags);
 	VMA_ITERATOR(vmi, &mm, 0x1000);
 
-	ASSERT_FALSE(vma_link(&mm, init_vma));
+	ASSERT_FALSE(attach_vma(&mm, init_vma));
 
 	/*
 	 * The flags will not be changed, the vma_modify_flags() function
@@ -351,7 +373,7 @@ static bool test_simple_expand(void)
 		.pgoff = 0,
 	};
 
-	ASSERT_FALSE(vma_link(&mm, vma));
+	ASSERT_FALSE(attach_vma(&mm, vma));
 
 	ASSERT_FALSE(expand_existing(&vmg));
 
@@ -372,7 +394,7 @@ static bool test_simple_shrink(void)
 	struct vm_area_struct *vma = alloc_vma(&mm, 0, 0x3000, 0, flags);
 	VMA_ITERATOR(vmi, &mm, 0);
 
-	ASSERT_FALSE(vma_link(&mm, vma));
+	ASSERT_FALSE(attach_vma(&mm, vma));
 
 	ASSERT_FALSE(vma_shrink(&vmi, vma, 0, 0x1000, 0));
 
@@ -1522,11 +1544,11 @@ static bool test_copy_vma(void)
 
 	vma = alloc_and_link_vma(&mm, 0x3000, 0x5000, 3, flags);
 	vma_new = copy_vma(&vma, 0, 0x2000, 0, &need_locks);
-
 	ASSERT_NE(vma_new, vma);
 	ASSERT_EQ(vma_new->vm_start, 0);
 	ASSERT_EQ(vma_new->vm_end, 0x2000);
 	ASSERT_EQ(vma_new->vm_pgoff, 0);
+	vma_assert_attached(vma_new);
 
 	cleanup_mm(&mm, &vmi);
 
@@ -1535,6 +1557,7 @@ static bool test_copy_vma(void)
 	vma = alloc_and_link_vma(&mm, 0, 0x2000, 0, flags);
 	vma_next = alloc_and_link_vma(&mm, 0x6000, 0x8000, 6, flags);
 	vma_new = copy_vma(&vma, 0x4000, 0x2000, 4, &need_locks);
+	vma_assert_attached(vma_new);
 
 	ASSERT_EQ(vma_new, vma_next);
 
@@ -1576,6 +1599,7 @@ static bool test_expand_only_mode(void)
 	ASSERT_EQ(vma->vm_pgoff, 3);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(vma_iter_addr(&vmi), 0x3000);
+	vma_assert_attached(vma);
 
 	cleanup_mm(&mm, &vmi);
 	return true;
--- a/tools/testing/vma/vma_internal.h~mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas
+++ a/tools/testing/vma/vma_internal.h
@@ -470,6 +470,16 @@ static inline void vma_lock_init(struct
 	vma->vm_lock_seq = UINT_MAX;
 }
 
+static inline void vma_assert_attached(struct vm_area_struct *vma)
+{
+	WARN_ON_ONCE(vma->detached);
+}
+
+static inline void vma_assert_detached(struct vm_area_struct *vma)
+{
+	WARN_ON_ONCE(!vma->detached);
+}
+
 static inline void vma_assert_write_locked(struct vm_area_struct *);
 static inline void vma_mark_attached(struct vm_area_struct *vma)
 {
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-work-around-clang-14-issue-with-__builtin_object_size.patch
mm-avoid-extra-mem_alloc_profiling_enabled-checks.patch
alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-slab-allocator.patch
alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-page-allocator.patch
mm-introduce-vma_start_read_locked_nested-helpers.patch
mm-move-per-vma-lock-into-vm_area_struct.patch
mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch
mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas.patch
mm-mark-vmas-detached-upon-exit.patch
types-move-struct-rcuwait-into-typesh.patch
mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail.patch
mm-move-mmap_init_lock-out-of-the-header-file.patch
mm-uninline-the-main-body-of-vma_start_write.patch
refcount-provide-ops-for-cases-when-objects-memory-can-be-reused.patch
refcount-introduce-__refcount_addinc_not_zero_limited_acquire.patch
mm-replace-vm_lock-and-detached-flag-with-a-reference-count.patch
mm-move-lesser-used-vma_area_struct-members-into-the-last-cacheline.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch
mm-remove-extra-vma_numab_state_init-call.patch
mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
docs-mm-document-latest-changes-to-vm_lock.patch

