Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF3681728
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 21:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735247752; cv=none; b=dLltlB+rtjiBFMoHnILQfZsnkXqYtGHzIqVp1hSlw3SGH3/uUE9UDSZbU70KHl9DckhTb9l0118agSII/BPwYUkr8cDLsO7aBLXorKL/CP8vAySo9MzddX7+dzuCH9xvTfa/LBKiAKDdbRXw7h2sdsAbse50Dqm0nRziaxmF47o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735247752; c=relaxed/simple;
	bh=3LgIPVmBS3zkNb/3iV+zUZBxnixG3ieRQxZ6gIq32Rw=;
	h=Date:To:From:Subject:Message-Id; b=Ps7DZuok4u3rqBBubIgaV0HfAq3ALtgSRaHwC8SVBX/BTn9OlPZciBZ6gf+BADol2SoGnr4l6zzp/N26BA+Wto5C+o3TQOlIMw5dt7gihUEyC8FjWFeFAFwc4F/RFls99BF9MhO7IPwUpiaO4QmNpwN99G7oQKPgsM2gWbDwW6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TutC1GG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TutC1GG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB238C4CED1;
	Thu, 26 Dec 2024 21:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735247752;
	bh=3LgIPVmBS3zkNb/3iV+zUZBxnixG3ieRQxZ6gIq32Rw=;
	h=Date:To:From:Subject:From;
	b=TutC1GG3w9VV1uKWGJ/Ajk3l08C9UV4DGoc4BtOBhd4/8t48L9Y7ry3I4GvEVeTtx
	 Rk6ypS1rMdNiw4VQZGQGySmu48jr+33d5qi36YuMbd6mi7YRmTgnml3x3VcxLcPBe/
	 09yxV/eWjImSpg84Z08w8FICcrD0TV5uBGVtF/IQ=
Date: Thu, 26 Dec 2024 13:15:51 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oliver.sang@intel.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-modify-vma_iter_store_gfp-to-indicate-if-its-storing-a-new-vma.patch added to mm-unstable branch
Message-Id: <20241226211551.EB238C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: modify vma_iter_store{_gfp} to indicate if it's storing a new vma
has been added to the -mm mm-unstable branch.  Its filename is
     mm-modify-vma_iter_store_gfp-to-indicate-if-its-storing-a-new-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-modify-vma_iter_store_gfp-to-indicate-if-its-storing-a-new-vma.patch

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
Subject: mm: modify vma_iter_store{_gfp} to indicate if it's storing a new vma
Date: Thu, 26 Dec 2024 09:06:56 -0800

vma_iter_store() functions can be used both when adding a new vma and when
updating an existing one.  However for existing ones we do not need to
mark them attached as they are already marked that way.  Add a parameter
to distinguish the usage and skip vma_mark_attached() when not needed.

Link: https://lkml.kernel.org/r/20241226170710.1159679-5-surenb@google.com
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

 include/linux/mm.h |   12 ++++++++++++
 mm/nommu.c         |    4 ++--
 mm/vma.c           |   16 ++++++++--------
 mm/vma.h           |   13 +++++++++----
 4 files changed, 31 insertions(+), 14 deletions(-)

--- a/include/linux/mm.h~mm-modify-vma_iter_store_gfp-to-indicate-if-its-storing-a-new-vma
+++ a/include/linux/mm.h
@@ -821,6 +821,16 @@ static inline void vma_assert_locked(str
 		vma_assert_write_locked(vma);
 }
 
+static inline void vma_assert_attached(struct vm_area_struct *vma)
+{
+	VM_BUG_ON_VMA(vma->detached, vma);
+}
+
+static inline void vma_assert_detached(struct vm_area_struct *vma)
+{
+	VM_BUG_ON_VMA(!vma->detached, vma);
+}
+
 static inline void vma_mark_attached(struct vm_area_struct *vma)
 {
 	vma->detached = false;
@@ -866,6 +876,8 @@ static inline void vma_end_read(struct v
 static inline void vma_start_write(struct vm_area_struct *vma) {}
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 		{ mmap_assert_write_locked(vma->vm_mm); }
+static inline void vma_assert_attached(struct vm_area_struct *vma) {}
+static inline void vma_assert_detached(struct vm_area_struct *vma) {}
 static inline void vma_mark_attached(struct vm_area_struct *vma) {}
 static inline void vma_mark_detached(struct vm_area_struct *vma) {}
 
--- a/mm/nommu.c~mm-modify-vma_iter_store_gfp-to-indicate-if-its-storing-a-new-vma
+++ a/mm/nommu.c
@@ -1191,7 +1191,7 @@ share:
 	setup_vma_to_mm(vma, current->mm);
 	current->mm->map_count++;
 	/* add the VMA to the tree */
-	vma_iter_store(&vmi, vma);
+	vma_iter_store(&vmi, vma, true);
 
 	/* we flush the region from the icache only when the first executable
 	 * mapping of it is made  */
@@ -1356,7 +1356,7 @@ static int split_vma(struct vma_iterator
 
 	setup_vma_to_mm(vma, mm);
 	setup_vma_to_mm(new, mm);
-	vma_iter_store(vmi, new);
+	vma_iter_store(vmi, new, true);
 	mm->map_count++;
 	return 0;
 
--- a/mm/vma.c~mm-modify-vma_iter_store_gfp-to-indicate-if-its-storing-a-new-vma
+++ a/mm/vma.c
@@ -306,7 +306,7 @@ static void vma_complete(struct vma_prep
 		 * us to insert it before dropping the locks
 		 * (it may either follow vma or precede it).
 		 */
-		vma_iter_store(vmi, vp->insert);
+		vma_iter_store(vmi, vp->insert, true);
 		mm->map_count++;
 	}
 
@@ -660,14 +660,14 @@ static int commit_merge(struct vma_merge
 	vma_set_range(vmg->vma, vmg->start, vmg->end, vmg->pgoff);
 
 	if (expanded)
-		vma_iter_store(vmg->vmi, vmg->vma);
+		vma_iter_store(vmg->vmi, vmg->vma, false);
 
 	if (adj_start) {
 		adjust->vm_start += adj_start;
 		adjust->vm_pgoff += PHYS_PFN(adj_start);
 		if (adj_start < 0) {
 			WARN_ON(expanded);
-			vma_iter_store(vmg->vmi, adjust);
+			vma_iter_store(vmg->vmi, adjust, false);
 		}
 	}
 
@@ -1689,7 +1689,7 @@ int vma_link(struct mm_struct *mm, struc
 		return -ENOMEM;
 
 	vma_start_write(vma);
-	vma_iter_store(&vmi, vma);
+	vma_iter_store(&vmi, vma, true);
 	vma_link_file(vma);
 	mm->map_count++;
 	validate_mm(mm);
@@ -2368,7 +2368,7 @@ static int __mmap_new_vma(struct mmap_st
 
 	/* Lock the VMA since it is modified after insertion into VMA tree */
 	vma_start_write(vma);
-	vma_iter_store(vmi, vma);
+	vma_iter_store(vmi, vma, true);
 	map->mm->map_count++;
 	vma_link_file(vma);
 
@@ -2542,7 +2542,7 @@ int do_brk_flags(struct vma_iterator *vm
 	vm_flags_init(vma, flags);
 	vma->vm_page_prot = vm_get_page_prot(flags);
 	vma_start_write(vma);
-	if (vma_iter_store_gfp(vmi, vma, GFP_KERNEL))
+	if (vma_iter_store_gfp(vmi, vma, GFP_KERNEL, true))
 		goto mas_store_fail;
 
 	mm->map_count++;
@@ -2785,7 +2785,7 @@ int expand_upwards(struct vm_area_struct
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_end = address;
 				/* Overwrite old entry in mtree. */
-				vma_iter_store(&vmi, vma);
+				vma_iter_store(&vmi, vma, false);
 				anon_vma_interval_tree_post_update_vma(vma);
 
 				perf_event_mmap(vma);
@@ -2865,7 +2865,7 @@ int expand_downwards(struct vm_area_stru
 				vma->vm_start = address;
 				vma->vm_pgoff -= grow;
 				/* Overwrite old entry in mtree. */
-				vma_iter_store(&vmi, vma);
+				vma_iter_store(&vmi, vma, false);
 				anon_vma_interval_tree_post_update_vma(vma);
 
 				perf_event_mmap(vma);
--- a/mm/vma.h~mm-modify-vma_iter_store_gfp-to-indicate-if-its-storing-a-new-vma
+++ a/mm/vma.h
@@ -145,7 +145,7 @@ __must_check int vma_shrink(struct vma_i
 		unsigned long start, unsigned long end, pgoff_t pgoff);
 
 static inline int vma_iter_store_gfp(struct vma_iterator *vmi,
-			struct vm_area_struct *vma, gfp_t gfp)
+			struct vm_area_struct *vma, gfp_t gfp, bool new_vma)
 
 {
 	if (vmi->mas.status != ma_start &&
@@ -157,7 +157,10 @@ static inline int vma_iter_store_gfp(str
 	if (unlikely(mas_is_err(&vmi->mas)))
 		return -ENOMEM;
 
-	vma_mark_attached(vma);
+	if (new_vma)
+		vma_mark_attached(vma);
+	vma_assert_attached(vma);
+
 	return 0;
 }
 
@@ -366,7 +369,7 @@ static inline struct vm_area_struct *vma
 
 /* Store a VMA with preallocated memory */
 static inline void vma_iter_store(struct vma_iterator *vmi,
-				  struct vm_area_struct *vma)
+				  struct vm_area_struct *vma, bool new_vma)
 {
 
 #if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
@@ -390,7 +393,9 @@ static inline void vma_iter_store(struct
 
 	__mas_set_range(&vmi->mas, vma->vm_start, vma->vm_end - 1);
 	mas_store_prealloc(&vmi->mas, vma);
-	vma_mark_attached(vma);
+	if (new_vma)
+		vma_mark_attached(vma);
+	vma_assert_attached(vma);
 }
 
 static inline unsigned long vma_iter_addr(struct vma_iterator *vmi)
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

