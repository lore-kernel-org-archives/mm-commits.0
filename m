Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1BA3FBB3
	for <mm-commits@vger.kernel.org>; Sat, 15 Feb 2025 00:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739580139; cv=none; b=mIuh7nYwS+jCdiT9FDChihFMv/sSgAuiDaV8aBYtuMtS7Vzl5sn8imoijSgpS9p4qptAhN2DwGHlm1L1UkpmfWi9ZVEX8aCuhiXai8X5buGGPJyfgLel/bbKJjD9LdyVXDacxwSh3DctQg3F9ZGhPjZE4P1TLGMvd38APvCcbGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739580139; c=relaxed/simple;
	bh=/WJ3jk3eOSvzQqyrNIMyP6im6ZjCfqWBDJL48iskZVc=;
	h=Date:To:From:Subject:Message-Id; b=ZWwuJ34+bL9YxSEridR5SiiCaChViPWswznp3zzJLzFWF7MDfpif891udli60t8Ys7XiWjBVk83tNYXwvOzrHgA9TNipWzAOwAmJHkmII2BYEbswN9bPAqgjmw2ge4g8aHT/NOgzvyscW9moVPfHR7rHT9JhRMsa5hOa98Mf9G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m4w8Qj1p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m4w8Qj1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15947C4CED1;
	Sat, 15 Feb 2025 00:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739580139;
	bh=/WJ3jk3eOSvzQqyrNIMyP6im6ZjCfqWBDJL48iskZVc=;
	h=Date:To:From:Subject:From;
	b=m4w8Qj1pRU6lsWFkgJKqtlVEp+sd/nJL4/J7gOhGlg1Z7wanqCR/Xn08nQXZwCU9+
	 f2RTt5GhEHdX2D/nyT1F+godZW8TNVrJe4u0Vr7rsXERUQOkymNmVb+YluzelBCmcL
	 HNVue44vyWrdQoShCe9oHguffvQAvIrkWPz99GuA=
Date: Fri, 14 Feb 2025 16:42:18 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,souravpanda@google.com,shivankg@amd.com,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail.patch added to mm-unstable branch
Message-Id: <20250215004219.15947C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: allow vma_start_read_locked/vma_start_read_locked_nested to fail
has been added to the -mm mm-unstable branch.  Its filename is
     mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail.patch

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
Subject: mm: allow vma_start_read_locked/vma_start_read_locked_nested to fail
Date: Thu, 13 Feb 2025 14:46:44 -0800

With upcoming replacement of vm_lock with vm_refcnt, we need to handle a
possibility of vma_start_read_locked/vma_start_read_locked_nested failing
due to refcount overflow.  Prepare for such possibility by changing these
APIs and adjusting their users.

Link: https://lkml.kernel.org/r/20250213224655.1680278-8-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
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

 include/linux/mm.h |    6 ++++--
 mm/userfaultfd.c   |   30 +++++++++++++++++++++++-------
 2 files changed, 27 insertions(+), 9 deletions(-)

--- a/include/linux/mm.h~mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail
+++ a/include/linux/mm.h
@@ -747,10 +747,11 @@ static inline bool vma_start_read(struct
  * not be used in such cases because it might fail due to mm_lock_seq overflow.
  * This functionality is used to obtain vma read lock and drop the mmap read lock.
  */
-static inline void vma_start_read_locked_nested(struct vm_area_struct *vma, int subclass)
+static inline bool vma_start_read_locked_nested(struct vm_area_struct *vma, int subclass)
 {
 	mmap_assert_locked(vma->vm_mm);
 	down_read_nested(&vma->vm_lock.lock, subclass);
+	return true;
 }
 
 /*
@@ -759,10 +760,11 @@ static inline void vma_start_read_locked
  * not be used in such cases because it might fail due to mm_lock_seq overflow.
  * This functionality is used to obtain vma read lock and drop the mmap read lock.
  */
-static inline void vma_start_read_locked(struct vm_area_struct *vma)
+static inline bool vma_start_read_locked(struct vm_area_struct *vma)
 {
 	mmap_assert_locked(vma->vm_mm);
 	down_read(&vma->vm_lock.lock);
+	return true;
 }
 
 static inline void vma_end_read(struct vm_area_struct *vma)
--- a/mm/userfaultfd.c~mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail
+++ a/mm/userfaultfd.c
@@ -84,8 +84,12 @@ static struct vm_area_struct *uffd_lock_
 
 	mmap_read_lock(mm);
 	vma = find_vma_and_prepare_anon(mm, address);
-	if (!IS_ERR(vma))
-		vma_start_read_locked(vma);
+	if (!IS_ERR(vma)) {
+		bool locked = vma_start_read_locked(vma);
+
+		if (!locked)
+			vma = ERR_PTR(-EAGAIN);
+	}
 
 	mmap_read_unlock(mm);
 	return vma;
@@ -1482,12 +1486,24 @@ static int uffd_move_lock(struct mm_stru
 
 	mmap_read_lock(mm);
 	err = find_vmas_mm_locked(mm, dst_start, src_start, dst_vmap, src_vmap);
-	if (!err) {
-		vma_start_read_locked(*dst_vmap);
-		if (*dst_vmap != *src_vmap)
-			vma_start_read_locked_nested(*src_vmap,
-						SINGLE_DEPTH_NESTING);
+	if (err)
+		goto out;
+
+	if (!vma_start_read_locked(*dst_vmap)) {
+		err = -EAGAIN;
+		goto out;
 	}
+
+	/* Nothing further to do if both vmas are locked. */
+	if (*dst_vmap == *src_vmap)
+		goto out;
+
+	if (!vma_start_read_locked_nested(*src_vmap, SINGLE_DEPTH_NESTING)) {
+		/* Undo dst_vmap locking if src_vmap failed to lock */
+		vma_end_read(*dst_vmap);
+		err = -EAGAIN;
+	}
+out:
 	mmap_read_unlock(mm);
 	return err;
 }
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

