Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B84531619E
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486668; cv=none; b=rMDr2Jmi2qOy1HI/D20PnovhC7UmWvBemB9tTexGUGg8gEuvCkw3ze1qPvcU1oyir6WCOJw5lnrrcM9V1Zi3gLMnHxlu5uphPJrll8tMWaSZat/enhauHwPYhQLETqrLHa89nJWM5NzD+NtH1rm9zpZeuUwd/yVuOX/5z6VCmSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486668; c=relaxed/simple;
	bh=JKidN14Ygodo9Iw/2bEiAKGOhonXFSjyXgQu2oKIY+w=;
	h=Date:To:From:Subject:Message-Id; b=IOwKfmKvwD8l195hH9sm4Z2xJVw8B1NeikWAiVv+yj7Gx+SqO+D/Yr1v0j9aohkmTPlx4PAlUq7JmFk6rkDb6tmHqdOZAduHLBfj0zfYJFjXs9MYPR8ZLdsoo1N91PBdZ70ht7919xbtc7bDAWpZ5c55WOSk9YyM2WKqLDv6A5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KPP+egqe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KPP+egqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75E5C116C6;
	Tue, 27 Jan 2026 04:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486667;
	bh=JKidN14Ygodo9Iw/2bEiAKGOhonXFSjyXgQu2oKIY+w=;
	h=Date:To:From:Subject:From;
	b=KPP+egqeyPO5jcWThN0HSYVIFv+vT2eR7ZGjDD0CXkRI4Iqq+GVX4987LklC13v8m
	 DcyhvcDL8Xd6dzG5WkL/w1sofwzq3pkc8Cgo0jCoWcJQux0KUIZztjgCb3IUIty+qa
	 0yCS5GpbbrHCPldw2IfIWVYDvsqFByyJDeTF7Ksc=
Date: Mon, 26 Jan 2026 20:04:27 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,mhocko@suse.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,chriscli@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch removed from -mm tree
Message-Id: <20260127040427.D75E5C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: separate out fork-only logic on anon_vma_clone()
has been removed from the -mm tree.  Its filename was
     mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/rmap: separate out fork-only logic on anon_vma_clone()
Date: Sun, 18 Jan 2026 14:50:45 +0000

Specify which operation is being performed to anon_vma_clone(), which
allows us to do checks specific to each operation type, as well as to
separate out and make clear that the anon_vma reuse logic is absolutely
specific to fork only.

This opens the door to further refactorings and refinements later as we
have more information to work with.

Link: https://lkml.kernel.org/r/cf7da7a2d973cdc72a1b80dd9a73260519e8fa9f.1768746221.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chriscli@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h                    |   11 +++-
 mm/rmap.c                        |   74 +++++++++++++++++++----------
 mm/vma.c                         |    6 +-
 tools/testing/vma/vma_internal.h |   11 +++-
 4 files changed, 74 insertions(+), 28 deletions(-)

--- a/mm/internal.h~mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone
+++ a/mm/internal.h
@@ -244,7 +244,16 @@ static inline void anon_vma_unlock_read(
 
 struct anon_vma *folio_get_anon_vma(const struct folio *folio);
 
-int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src);
+/* Operations which modify VMAs. */
+enum vma_operation {
+	VMA_OP_SPLIT,
+	VMA_OP_MERGE_UNFAULTED,
+	VMA_OP_REMAP,
+	VMA_OP_FORK,
+};
+
+int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
+	enum vma_operation operation);
 int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma);
 int  __anon_vma_prepare(struct vm_area_struct *vma);
 void unlink_anon_vmas(struct vm_area_struct *vma);
--- a/mm/rmap.c~mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone
+++ a/mm/rmap.c
@@ -232,12 +232,13 @@ int __anon_vma_prepare(struct vm_area_st
 }
 
 static void check_anon_vma_clone(struct vm_area_struct *dst,
-				 struct vm_area_struct *src)
+				 struct vm_area_struct *src,
+				 enum vma_operation operation)
 {
 	/* The write lock must be held. */
 	mmap_assert_write_locked(src->vm_mm);
-	/* If not a fork (implied by dst->anon_vma) then must be on same mm. */
-	VM_WARN_ON_ONCE(dst->anon_vma && dst->vm_mm != src->vm_mm);
+	/* If not a fork then must be on same mm. */
+	VM_WARN_ON_ONCE(operation != VMA_OP_FORK && dst->vm_mm != src->vm_mm);
 
 	/* If we have anything to do src->anon_vma must be provided. */
 	VM_WARN_ON_ONCE(!src->anon_vma && !list_empty(&src->anon_vma_chain));
@@ -249,6 +250,40 @@ static void check_anon_vma_clone(struct
 	 * must be the same across dst and src.
 	 */
 	VM_WARN_ON_ONCE(dst->anon_vma && dst->anon_vma != src->anon_vma);
+	/*
+	 * Essentially equivalent to above - if not a no-op, we should expect
+	 * dst->anon_vma to be set for everything except a fork.
+	 */
+	VM_WARN_ON_ONCE(operation != VMA_OP_FORK && src->anon_vma &&
+			!dst->anon_vma);
+	/* For the anon_vma to be compatible, it can only be singular. */
+	VM_WARN_ON_ONCE(operation == VMA_OP_MERGE_UNFAULTED &&
+			!list_is_singular(&src->anon_vma_chain));
+#ifdef CONFIG_PER_VMA_LOCK
+	/* Only merging an unfaulted VMA leaves the destination attached. */
+	VM_WARN_ON_ONCE(operation != VMA_OP_MERGE_UNFAULTED &&
+			vma_is_attached(dst));
+#endif
+}
+
+static void maybe_reuse_anon_vma(struct vm_area_struct *dst,
+		struct anon_vma *anon_vma)
+{
+	/* If already populated, nothing to do.*/
+	if (dst->anon_vma)
+		return;
+
+	/*
+	 * We reuse an anon_vma if any linking VMAs were unmapped and it has
+	 * only a single child at most.
+	 */
+	if (anon_vma->num_active_vmas > 0)
+		return;
+	if (anon_vma->num_children > 1)
+		return;
+
+	dst->anon_vma = anon_vma;
+	anon_vma->num_active_vmas++;
 }
 
 static void cleanup_partial_anon_vmas(struct vm_area_struct *vma);
@@ -258,6 +293,7 @@ static void cleanup_partial_anon_vmas(st
  * all of the anon_vma objects contained within @src anon_vma_chain's.
  * @dst: The destination VMA with an empty anon_vma_chain.
  * @src: The source VMA we wish to duplicate.
+ * @operation: The type of operation which resulted in the clone.
  *
  * This is the heart of the VMA side of the anon_vma implementation - we invoke
  * this function whenever we need to set up a new VMA's anon_vma state.
@@ -280,17 +316,17 @@ static void cleanup_partial_anon_vmas(st
  *
  * Returns: 0 on success, -ENOMEM on failure.
  */
-int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
+int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
+		   enum vma_operation operation)
 {
 	struct anon_vma_chain *avc, *pavc;
+	struct anon_vma *active_anon_vma = src->anon_vma;
 
-	check_anon_vma_clone(dst, src);
+	check_anon_vma_clone(dst, src, operation);
 
-	if (!src->anon_vma)
+	if (!active_anon_vma)
 		return 0;
 
-	check_anon_vma_clone(dst, src);
-
 	/*
 	 * Allocate AVCs. We don't need an anon_vma lock for this as we
 	 * are not updating the anon_vma rbtree nor are we changing
@@ -318,22 +354,14 @@ int anon_vma_clone(struct vm_area_struct
 		struct anon_vma *anon_vma = avc->anon_vma;
 
 		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
-
-		/*
-		 * Reuse existing anon_vma if it has no vma and only one
-		 * anon_vma child.
-		 *
-		 * Root anon_vma is never reused:
-		 * it has self-parent reference and at least one child.
-		 */
-		if (!dst->anon_vma && src->anon_vma &&
-		    anon_vma->num_children < 2 &&
-		    anon_vma->num_active_vmas == 0)
-			dst->anon_vma = anon_vma;
+		if (operation == VMA_OP_FORK)
+			maybe_reuse_anon_vma(dst, anon_vma);
 	}
-	if (dst->anon_vma)
+
+	if (operation != VMA_OP_FORK)
 		dst->anon_vma->num_active_vmas++;
-	anon_vma_unlock_write(src->anon_vma);
+
+	anon_vma_unlock_write(active_anon_vma);
 	return 0;
 
  enomem_failure:
@@ -372,7 +400,7 @@ int anon_vma_fork(struct vm_area_struct
 	 * First, attach the new VMA to the parent VMA's anon_vmas,
 	 * so rmap can find non-COWed pages in child processes.
 	 */
-	rc = anon_vma_clone(vma, pvma);
+	rc = anon_vma_clone(vma, pvma, VMA_OP_FORK);
 	/* An error arose or an existing anon_vma was reused, all done then. */
 	if (rc || vma->anon_vma) {
 		put_anon_vma(anon_vma);
--- a/mm/vma.c~mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone
+++ a/mm/vma.c
@@ -530,7 +530,7 @@ __split_vma(struct vma_iterator *vmi, st
 	if (err)
 		goto out_free_vmi;
 
-	err = anon_vma_clone(new, vma);
+	err = anon_vma_clone(new, vma, VMA_OP_SPLIT);
 	if (err)
 		goto out_free_mpol;
 
@@ -628,7 +628,7 @@ static int dup_anon_vma(struct vm_area_s
 
 		vma_assert_write_locked(dst);
 		dst->anon_vma = src->anon_vma;
-		ret = anon_vma_clone(dst, src);
+		ret = anon_vma_clone(dst, src, VMA_OP_MERGE_UNFAULTED);
 		if (ret)
 			return ret;
 
@@ -1901,7 +1901,7 @@ struct vm_area_struct *copy_vma(struct v
 		vma_set_range(new_vma, addr, addr + len, pgoff);
 		if (vma_dup_policy(vma, new_vma))
 			goto out_free_vma;
-		if (anon_vma_clone(new_vma, vma))
+		if (anon_vma_clone(new_vma, vma, VMA_OP_REMAP))
 			goto out_free_mempol;
 		if (new_vma->vm_file)
 			get_file(new_vma->vm_file);
--- a/tools/testing/vma/vma_internal.h~mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone
+++ a/tools/testing/vma/vma_internal.h
@@ -600,6 +600,14 @@ struct mmap_action {
 	bool hide_from_rmap_until_complete :1;
 };
 
+/* Operations which modify VMAs. */
+enum vma_operation {
+	VMA_OP_SPLIT,
+	VMA_OP_MERGE_UNFAULTED,
+	VMA_OP_REMAP,
+	VMA_OP_FORK,
+};
+
 /*
  * Describes a VMA that is about to be mmap()'ed. Drivers may choose to
  * manipulate mutable fields which will cause those fields to be updated in the
@@ -1157,7 +1165,8 @@ static inline int vma_dup_policy(struct
 	return 0;
 }
 
-static inline int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
+static inline int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
+				 enum vma_operation operation)
 {
 	/* For testing purposes. We indicate that an anon_vma has been cloned. */
 	if (src->anon_vma != NULL) {
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

selftests-mm-remove-virtual_address_range-test.patch
mm-vma-rename-vma_lock_offset-to-vm_refcnt_exclude_readers_flag.patch
mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment.patch
mm-vma-rename-is_vma_write_only-separate-out-shared-refcount-put.patch
mm-vma-adduse-vma-lockdep-acquire-release-defines.patch
mm-vma-de-duplicate-__vma_enter_locked-error-path.patch
mm-vma-clean-up-__vma_enter-exit_locked.patch
mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns.patch
mm-vma-improve-and-document-__is_vma_write_locked.patch
mm-vma-improve-and-document-__is_vma_write_locked-fix.patch
mm-vma-update-vma_assert_locked-to-use-lockdep.patch
mm-vma-update-vma_assert_locked-to-use-lockdep-fix.patch
mm-vma-add-and-use-vma_assert_stabilised.patch
mm-vma-remove-__private-sparse-decoration-from-vma_flags_t.patch
mm-rename-vma_flag_test-set_atomic-to-vma_test-set_atomic_flag.patch
mm-add-mk_vma_flags-bitmap-flag-macro-helper.patch
tools-bitmap-add-missing-bitmap_.patch
mm-add-basic-vma-flag-operation-helper-functions.patch
mm-update-hugetlbfs-to-use-vma-flags-on-mmap_prepare.patch
mm-update-secretmem-to-use-vma-flags-on-mmap_prepare.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t.patch
mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t.patch
mm-make-vm_area_desc-utilise-vma_flags_t-only.patch
tools-testing-vma-separate-vma-userland-tests-into-separate-files.patch
tools-testing-vma-separate-out-vma_internalh-into-logical-headers.patch
tools-testing-vma-add-vma-userland-tests-for-vma-flag-functions.patch

