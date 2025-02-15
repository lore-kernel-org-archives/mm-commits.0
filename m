Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE444C8F
	for <mm-commits@vger.kernel.org>; Sat, 15 Feb 2025 00:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739580130; cv=none; b=fpJ5fs4wjQa90bdBouVl86bWCJVQYfScMas7Wp5SCSqGRae6DbtzDsyeiM9sFzle/xvz4AhjYVTWk8xKmZ07Ne5wYQIc9/6qyZDqLCMpak3/pZLnKoiD3VI0atf2TbklFI5ecTCBYJ3A1/xSZE0gBXaC/h9ikMyKRfQCFqCY8To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739580130; c=relaxed/simple;
	bh=gtwMZWwMAbpErItVZnPiQU3PYGok8JikHYDiQptLSIc=;
	h=Date:To:From:Subject:Message-Id; b=ZYMVkjQndlYqWq5gciSzynq5CT7l21n290WFf3PkRkFwUEMk/Nd+ttFphQezhz+fc/NU+faYftDxPbUt3h9E0FhLGteHX9aERxtpRf+Y/3k3+N9fmF1Fb2XMxygUvfbpAj0uc8S36t0kw8qhgsPHccy7NALYSuLMcT0nBQi0n9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W0e4J19O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W0e4J19O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED366C4CED1;
	Sat, 15 Feb 2025 00:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739580129;
	bh=gtwMZWwMAbpErItVZnPiQU3PYGok8JikHYDiQptLSIc=;
	h=Date:To:From:Subject:From;
	b=W0e4J19O+0wq8mxSttGCDcgYIHwWeQZLfYHnhl6XShr2OOAfvE5uUzcGjURAAQft5
	 qGXofQtY7abDF2Is72Cnm+lS5nHHIHVYMl/cfTyqVDOgUlO3z8LvH+STUZ9E2LiscU
	 mUBE14O5ovQCyCDCZrxXFxpGMIJtsiZzOvkOc6fA=
Date: Fri, 14 Feb 2025 16:42:08 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,souravpanda@google.com,shivankg@amd.com,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-vma_start_read_locked_nested-helpers.patch added to mm-unstable branch
Message-Id: <20250215004208.ED366C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce vma_start_read_locked{_nested} helpers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-vma_start_read_locked_nested-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-vma_start_read_locked_nested-helpers.patch

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
Subject: mm: introduce vma_start_read_locked{_nested} helpers
Date: Thu, 13 Feb 2025 14:46:38 -0800

Patch series "reimplement per-vma lock as a refcount", v10.

Back when per-vma locks were introduces, vm_lock was moved out of
vm_area_struct in [1] because of the performance regression caused by
false cacheline sharing.  Recent investigation [2] revealed that the
regressions is limited to a rather old Broadwell microarchitecture and
even there it can be mitigated by disabling adjacent cacheline
prefetching, see [3].

Splitting single logical structure into multiple ones leads to more
complicated management, extra pointer dereferences and overall less
maintainable code.  When that split-away part is a lock, it complicates
things even further.  With no performance benefits, there are no reasons
for this split.  Merging the vm_lock back into vm_area_struct also allows
vm_area_struct to use SLAB_TYPESAFE_BY_RCU later in this patchset.

This patchset:

1. moves vm_lock back into vm_area_struct, aligning it at the
   cacheline boundary and changing the cache to be cacheline-aligned to
   minimize cacheline sharing;

2. changes vm_area_struct initialization to mark new vma as detached
   until it is inserted into vma tree;

3. replaces vm_lock and vma->detached flag with a reference counter;

4. regroups vm_area_struct members to fit them into 3 cachelines;

5. changes vm_area_struct cache to SLAB_TYPESAFE_BY_RCU to allow for
   their reuse and to minimize call_rcu() calls.

Pagefault microbenchmarks show performance improvement:
Hmean     faults/cpu-1    507926.5547 (   0.00%)   506519.3692 *  -0.28%*
Hmean     faults/cpu-4    479119.7051 (   0.00%)   481333.6802 *   0.46%*
Hmean     faults/cpu-7    452880.2961 (   0.00%)   455845.6211 *   0.65%*
Hmean     faults/cpu-12   347639.1021 (   0.00%)   352004.2254 *   1.26%*
Hmean     faults/cpu-21   200061.2238 (   0.00%)   229597.0317 *  14.76%*
Hmean     faults/cpu-30   145251.2001 (   0.00%)   164202.5067 *  13.05%*
Hmean     faults/cpu-48   106848.4434 (   0.00%)   120641.5504 *  12.91%*
Hmean     faults/cpu-56    92472.3835 (   0.00%)   103464.7916 *  11.89%*
Hmean     faults/sec-1    507566.1468 (   0.00%)   506139.0811 *  -0.28%*
Hmean     faults/sec-4   1880478.2402 (   0.00%)  1886795.6329 *   0.34%*
Hmean     faults/sec-7   3106394.3438 (   0.00%)  3140550.7485 *   1.10%*
Hmean     faults/sec-12  4061358.4795 (   0.00%)  4112477.0206 *   1.26%*
Hmean     faults/sec-21  3988619.1169 (   0.00%)  4577747.1436 *  14.77%*
Hmean     faults/sec-30  3909839.5449 (   0.00%)  4311052.2787 *  10.26%*
Hmean     faults/sec-48  4761108.4691 (   0.00%)  5283790.5026 *  10.98%*
Hmean     faults/sec-56  4885561.4590 (   0.00%)  5415839.4045 *  10.85%*


This patch (of 18):

Introduce helper functions which can be used to read-lock a VMA when
holding mmap_lock for read.  Replace direct accesses to vma->vm_lock with
these new helpers.

Link: https://lkml.kernel.org/r/20250213224655.1680278-1-surenb@google.com
Link: https://lkml.kernel.org/r/20250213224655.1680278-2-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Tested-by: Shivank Garg <shivankg@amd.com>
  Link: https://lkml.kernel.org/r/5e19ec93-8307-47c2-bb13-3ddf7150624e@amd.com
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
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
Cc: Sourav Panda <souravpanda@google.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   24 ++++++++++++++++++++++++
 mm/userfaultfd.c   |   22 +++++-----------------
 2 files changed, 29 insertions(+), 17 deletions(-)

--- a/include/linux/mm.h~mm-introduce-vma_start_read_locked_nested-helpers
+++ a/include/linux/mm.h
@@ -735,6 +735,30 @@ static inline bool vma_start_read(struct
 	return true;
 }
 
+/*
+ * Use only while holding mmap read lock which guarantees that locking will not
+ * fail (nobody can concurrently write-lock the vma). vma_start_read() should
+ * not be used in such cases because it might fail due to mm_lock_seq overflow.
+ * This functionality is used to obtain vma read lock and drop the mmap read lock.
+ */
+static inline void vma_start_read_locked_nested(struct vm_area_struct *vma, int subclass)
+{
+	mmap_assert_locked(vma->vm_mm);
+	down_read_nested(&vma->vm_lock->lock, subclass);
+}
+
+/*
+ * Use only while holding mmap read lock which guarantees that locking will not
+ * fail (nobody can concurrently write-lock the vma). vma_start_read() should
+ * not be used in such cases because it might fail due to mm_lock_seq overflow.
+ * This functionality is used to obtain vma read lock and drop the mmap read lock.
+ */
+static inline void vma_start_read_locked(struct vm_area_struct *vma)
+{
+	mmap_assert_locked(vma->vm_mm);
+	down_read(&vma->vm_lock->lock);
+}
+
 static inline void vma_end_read(struct vm_area_struct *vma)
 {
 	rcu_read_lock(); /* keeps vma alive till the end of up_read */
--- a/mm/userfaultfd.c~mm-introduce-vma_start_read_locked_nested-helpers
+++ a/mm/userfaultfd.c
@@ -84,16 +84,8 @@ static struct vm_area_struct *uffd_lock_
 
 	mmap_read_lock(mm);
 	vma = find_vma_and_prepare_anon(mm, address);
-	if (!IS_ERR(vma)) {
-		/*
-		 * We cannot use vma_start_read() as it may fail due to
-		 * false locked (see comment in vma_start_read()). We
-		 * can avoid that by directly locking vm_lock under
-		 * mmap_lock, which guarantees that nobody can lock the
-		 * vma for write (vma_start_write()) under us.
-		 */
-		down_read(&vma->vm_lock->lock);
-	}
+	if (!IS_ERR(vma))
+		vma_start_read_locked(vma);
 
 	mmap_read_unlock(mm);
 	return vma;
@@ -1491,14 +1483,10 @@ static int uffd_move_lock(struct mm_stru
 	mmap_read_lock(mm);
 	err = find_vmas_mm_locked(mm, dst_start, src_start, dst_vmap, src_vmap);
 	if (!err) {
-		/*
-		 * See comment in uffd_lock_vma() as to why not using
-		 * vma_start_read() here.
-		 */
-		down_read(&(*dst_vmap)->vm_lock->lock);
+		vma_start_read_locked(*dst_vmap);
 		if (*dst_vmap != *src_vmap)
-			down_read_nested(&(*src_vmap)->vm_lock->lock,
-					 SINGLE_DEPTH_NESTING);
+			vma_start_read_locked_nested(*src_vmap,
+						SINGLE_DEPTH_NESTING);
 	}
 	mmap_read_unlock(mm);
 	return err;
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

