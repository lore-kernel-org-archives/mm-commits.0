Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05055A7B8
	for <mm-commits@vger.kernel.org>; Sat,  7 Dec 2024 04:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733545769; cv=none; b=JJsH/Du4NW+11czIPIcxJoEmewf6ixR1i9GbZegOZpFZjXApLs15ettyWz1PditUnf5RLDKP9oWqSxxewY6PYTbU5m4S3M4ewG1t0SP++UDoCvbTDVTnQp6pkjpRDSpidWxREobDfzEUCbxdFFedHHgom/vlyUMBYqtg4kV6Cyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733545769; c=relaxed/simple;
	bh=wXA8yeNWKAY+G1XbJ/l+tVkR1JGE80qHw1WFz2bKtr8=;
	h=Date:To:From:Subject:Message-Id; b=Rc07QN/OKWuYCgOvjebfzbIO1FHFwl+ofzf+nw+dayiqxHUN/hzqAolOtjpkVMQ3O+sjuhinY4briWVTGhPM8Ffm37ge/VZDi5F+SFKWFljG8tqmHBiwfdtq48WXcl9q93wNv8sTbvEmIDzptnT5OSHniseS9dxjZVRU7ecaB5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CIGYAS4y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CIGYAS4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5536EC4CEDC;
	Sat,  7 Dec 2024 04:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733545768;
	bh=wXA8yeNWKAY+G1XbJ/l+tVkR1JGE80qHw1WFz2bKtr8=;
	h=Date:To:From:Subject:From;
	b=CIGYAS4yT0vRxeMkn/qVF45jNfjWLoRKdHNrFvBtoGx1rdUxC0RfhpFVUERw9uF9s
	 amN9aBrnrEwh8T+8Y9qrUUpemFSnsfXPpDz0HtTBl+6Fzrkm9ewnxz9guvOK7Kuomv
	 rpBhr06ZektYASpO+IomRhyNpLtF6qKlSvQ6P/r8=
Date: Fri, 06 Dec 2024 20:29:27 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch added to mm-unstable branch
Message-Id: <20241207042928.5536EC4CEDC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mark vma as detached until it's added into vma tree
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch

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
Subject: mm: mark vma as detached until it's added into vma tree
Date: Fri, 6 Dec 2024 14:52:00 -0800

Current implementation does not set detached flag when a VMA is first
allocated.  This does not represent the real state of the VMA, which is
detached until it is added into mm's VMA tree.  Fix this by marking new
VMAs as detached and resetting detached flag only after VMA is added into
a tree.

Introduce vma_mark_attached() to make the API more readable and to
simplify possible future cleanup when vma->vm_mm might be used to indicate
detached vma and vma_mark_attached() will need an additional mm parameter.

Link: https://lkml.kernel.org/r/20241206225204.4008261-4-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h               |   27 ++++++++++++++++++++-------
 kernel/fork.c                    |    4 ++++
 mm/memory.c                      |    2 +-
 mm/vma.c                         |    6 +++---
 mm/vma.h                         |    2 ++
 tools/testing/vma/vma_internal.h |   17 ++++++++++++-----
 6 files changed, 42 insertions(+), 16 deletions(-)

--- a/include/linux/mm.h~mm-mark-vma-as-detached-until-its-added-into-vma-tree
+++ a/include/linux/mm.h
@@ -820,12 +820,21 @@ static inline void vma_assert_locked(str
 		vma_assert_write_locked(vma);
 }
 
-static inline void vma_mark_detached(struct vm_area_struct *vma, bool detached)
+static inline void vma_mark_attached(struct vm_area_struct *vma)
+{
+	vma->detached = false;
+}
+
+static inline void vma_mark_detached(struct vm_area_struct *vma)
 {
 	/* When detaching vma should be write-locked */
-	if (detached)
-		vma_assert_write_locked(vma);
-	vma->detached = detached;
+	vma_assert_write_locked(vma);
+	vma->detached = true;
+}
+
+static inline bool is_vma_detached(struct vm_area_struct *vma)
+{
+	return vma->detached;
 }
 
 static inline void release_fault_lock(struct vm_fault *vmf)
@@ -856,8 +865,8 @@ static inline void vma_end_read(struct v
 static inline void vma_start_write(struct vm_area_struct *vma) {}
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 		{ mmap_assert_write_locked(vma->vm_mm); }
-static inline void vma_mark_detached(struct vm_area_struct *vma,
-				     bool detached) {}
+static inline void vma_mark_attached(struct vm_area_struct *vma) {}
+static inline void vma_mark_detached(struct vm_area_struct *vma) {}
 
 static inline struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
 		unsigned long address)
@@ -890,7 +899,10 @@ static inline void vma_init(struct vm_ar
 	vma->vm_mm = mm;
 	vma->vm_ops = &vma_dummy_vm_ops;
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
-	vma_mark_detached(vma, false);
+#ifdef CONFIG_PER_VMA_LOCK
+	/* vma is not locked, can't use vma_mark_detached() */
+	vma->detached = true;
+#endif
 	vma_numab_state_init(vma);
 	vma_lock_init(vma);
 }
@@ -1085,6 +1097,7 @@ static inline int vma_iter_bulk_store(st
 	if (unlikely(mas_is_err(&vmi->mas)))
 		return -ENOMEM;
 
+	vma_mark_attached(vma);
 	return 0;
 }
 
--- a/kernel/fork.c~mm-mark-vma-as-detached-until-its-added-into-vma-tree
+++ a/kernel/fork.c
@@ -465,6 +465,10 @@ struct vm_area_struct *vm_area_dup(struc
 	data_race(memcpy(new, orig, sizeof(*new)));
 	vma_lock_init(new);
 	INIT_LIST_HEAD(&new->anon_vma_chain);
+#ifdef CONFIG_PER_VMA_LOCK
+	/* vma is not locked, can't use vma_mark_detached() */
+	new->detached = true;
+#endif
 	vma_numab_state_init(new);
 	dup_anon_vma_name(orig, new);
 
--- a/mm/memory.c~mm-mark-vma-as-detached-until-its-added-into-vma-tree
+++ a/mm/memory.c
@@ -6350,7 +6350,7 @@ retry:
 		goto inval;
 
 	/* Check if the VMA got isolated after we found it */
-	if (vma->detached) {
+	if (is_vma_detached(vma)) {
 		vma_end_read(vma);
 		count_vm_vma_lock_event(VMA_LOCK_MISS);
 		/* The area was replaced with another one */
--- a/mm/vma.c~mm-mark-vma-as-detached-until-its-added-into-vma-tree
+++ a/mm/vma.c
@@ -327,7 +327,7 @@ static void vma_complete(struct vma_prep
 
 	if (vp->remove) {
 again:
-		vma_mark_detached(vp->remove, true);
+		vma_mark_detached(vp->remove);
 		if (vp->file) {
 			uprobe_munmap(vp->remove, vp->remove->vm_start,
 				      vp->remove->vm_end);
@@ -1220,7 +1220,7 @@ static void reattach_vmas(struct ma_stat
 
 	mas_set(mas_detach, 0);
 	mas_for_each(mas_detach, vma, ULONG_MAX)
-		vma_mark_detached(vma, false);
+		vma_mark_attached(vma);
 
 	__mt_destroy(mas_detach->tree);
 }
@@ -1295,7 +1295,7 @@ static int vms_gather_munmap_vmas(struct
 		if (error)
 			goto munmap_gather_failed;
 
-		vma_mark_detached(next, true);
+		vma_mark_detached(next);
 		nrpages = vma_pages(next);
 
 		vms->nr_pages += nrpages;
--- a/mm/vma.h~mm-mark-vma-as-detached-until-its-added-into-vma-tree
+++ a/mm/vma.h
@@ -156,6 +156,7 @@ static inline int vma_iter_store_gfp(str
 	if (unlikely(mas_is_err(&vmi->mas)))
 		return -ENOMEM;
 
+	vma_mark_attached(vma);
 	return 0;
 }
 
@@ -385,6 +386,7 @@ static inline void vma_iter_store(struct
 
 	__mas_set_range(&vmi->mas, vma->vm_start, vma->vm_end - 1);
 	mas_store_prealloc(&vmi->mas, vma);
+	vma_mark_attached(vma);
 }
 
 static inline unsigned long vma_iter_addr(struct vma_iterator *vmi)
--- a/tools/testing/vma/vma_internal.h~mm-mark-vma-as-detached-until-its-added-into-vma-tree
+++ a/tools/testing/vma/vma_internal.h
@@ -465,13 +465,17 @@ static inline void vma_lock_init(struct
 	vma->vm_lock_seq = UINT_MAX;
 }
 
+static inline void vma_mark_attached(struct vm_area_struct *vma)
+{
+	vma->detached = false;
+}
+
 static inline void vma_assert_write_locked(struct vm_area_struct *);
-static inline void vma_mark_detached(struct vm_area_struct *vma, bool detached)
+static inline void vma_mark_detached(struct vm_area_struct *vma)
 {
 	/* When detaching vma should be write-locked */
-	if (detached)
-		vma_assert_write_locked(vma);
-	vma->detached = detached;
+	vma_assert_write_locked(vma);
+	vma->detached = true;
 }
 
 extern const struct vm_operations_struct vma_dummy_vm_ops;
@@ -484,7 +488,8 @@ static inline void vma_init(struct vm_ar
 	vma->vm_mm = mm;
 	vma->vm_ops = &vma_dummy_vm_ops;
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
-	vma_mark_detached(vma, false);
+	/* vma is not locked, can't use vma_mark_detached() */
+	vma->detached = true;
 	vma_lock_init(vma);
 }
 
@@ -510,6 +515,8 @@ static inline struct vm_area_struct *vm_
 	memcpy(new, orig, sizeof(*new));
 	vma_lock_init(new);
 	INIT_LIST_HEAD(&new->anon_vma_chain);
+	/* vma is not locked, can't use vma_mark_detached() */
+	new->detached = true;
 
 	return new;
 }
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

