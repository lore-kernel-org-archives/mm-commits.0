Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1689C33DEFC
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 17:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721036; cv=none; b=KNrsSTywOERuWTJWhe3QOhpmFQ4lu+0vegRhCMupytW9p9IxwqmTjagbk/1/L6qCOgDFifvbfT1lOTZHpBlXj9JmCJFRqHfuvGbZaeo6q5btgKcGiY9gRpBQ/MXH4PpVSE/6Qmai22myyQ8gQdn+wBQM7BxiLDSxeI7roil/zXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721036; c=relaxed/simple;
	bh=VMwsAJ9wLtkINeM4e/8SpSBybJl9xKD/bZj1DjiFQLA=;
	h=Date:To:From:Subject:Message-Id; b=Maou1we6ifAlB48NHJywDbdiIbl2BPEO+XjjV+EHnb4gpE72xCJbXqchhprPEqlxXlNNXHhs4F/afW7EzNfJDnJBBfJo3Hov3fj3J8Qv+BzZp/IdQ1eNSGxovj0H39wPZPPaB1CkcZOq58nInjYYLLg93wTfGQyez2feLMy7BIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kEoc8gWi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kEoc8gWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBDDC19423;
	Tue,  6 Jan 2026 17:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767721036;
	bh=VMwsAJ9wLtkINeM4e/8SpSBybJl9xKD/bZj1DjiFQLA=;
	h=Date:To:From:Subject:From;
	b=kEoc8gWiGOjzSoJwOLMzHbo1EkItbWb+KQSXLHtuge6xKhfydRVIgLAc604B6Z7+M
	 Bc39WJ1ysm6Q1La21/VQw7eCP9i8gFzrd2/0dlh94WvMkr+Ej+WsQSZ7OfEgCUELiu
	 TJgBziVj+opDaPqMQKZbd1MdHSyZ95eKOfWnAdVU=
Date: Tue, 06 Jan 2026 09:37:15 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,mhocko@suse.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,chriscli@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch added to mm-new branch
Message-Id: <20260106173715.DFBDDC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: separate out fork-only logic on anon_vma_clone()
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/rmap: separate out fork-only logic on anon_vma_clone()
Date: Tue, 6 Jan 2026 15:04:33 +0000

Specify which operation is being performed to anon_vma_clone(), which
allows us to do checks specific to each operation type, as well as to
separate out and make clear that the anon_vma reuse logic is absolutely
specific to fork only.

This opens the door to further refactorings and refinements later as we
have more information to work with.

Link: https://lkml.kernel.org/r/a4f87ba914697a47419f12901a995759fd977fdd.1767711638.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chriscli@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
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
@@ -233,12 +233,13 @@ int __anon_vma_prepare(struct vm_area_st
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
@@ -250,6 +251,40 @@ static void check_anon_vma_clone(struct
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
+static void try_to_reuse_anon_vma(struct vm_area_struct *dst,
+				  struct anon_vma *anon_vma)
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
@@ -259,6 +294,7 @@ static void cleanup_partial_anon_vmas(st
  * all of the anon_vma objects contained within @src anon_vma_chain's.
  * @dst: The destination VMA with an empty anon_vma_chain.
  * @src: The source VMA we wish to duplicate.
+ * @operation: The type of operation which resulted in the clone.
  *
  * This is the heart of the VMA side of the anon_vma implementation - we invoke
  * this function whenever we need to set up a new VMA's anon_vma state.
@@ -281,17 +317,17 @@ static void cleanup_partial_anon_vmas(st
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
@@ -317,22 +353,14 @@ int anon_vma_clone(struct vm_area_struct
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
+			try_to_reuse_anon_vma(dst, anon_vma);
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
@@ -362,7 +390,7 @@ int anon_vma_fork(struct vm_area_struct
 	 * First, attach the new VMA to the parent VMA's anon_vmas,
 	 * so rmap can find non-COWed pages in child processes.
 	 */
-	error = anon_vma_clone(vma, pvma);
+	error = anon_vma_clone(vma, pvma, VMA_OP_FORK);
 	if (error)
 		return error;
 
--- a/mm/vma.c~mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone
+++ a/mm/vma.c
@@ -528,7 +528,7 @@ __split_vma(struct vma_iterator *vmi, st
 	if (err)
 		goto out_free_vmi;
 
-	err = anon_vma_clone(new, vma);
+	err = anon_vma_clone(new, vma, VMA_OP_SPLIT);
 	if (err)
 		goto out_free_mpol;
 
@@ -626,7 +626,7 @@ static int dup_anon_vma(struct vm_area_s
 
 		vma_assert_write_locked(dst);
 		dst->anon_vma = src->anon_vma;
-		ret = anon_vma_clone(dst, src);
+		ret = anon_vma_clone(dst, src, VMA_OP_MERGE_UNFAULTED);
 		if (ret)
 			return ret;
 
@@ -1899,7 +1899,7 @@ struct vm_area_struct *copy_vma(struct v
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

mm-vma-fix-anon_vma-uaf-on-mremap-faulted-unfaulted-merge.patch
tools-testing-selftests-add-tests-for-tgt-src-mremap-merges.patch
mm-vma-enforce-vma-fork-limit-on-unfaultedfaulted-mremap-merge-too.patch
tools-testing-selftests-add-forked-un-faulted-vma-merge-tests.patch
tools-testing-selftests-fix-gup_longterm-for-unknown-fs.patch
mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts.patch
mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink.patch
mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap.patch
mm-rmap-remove-anon_vma_merge-function.patch
mm-rmap-make-anon_vma-functions-internal.patch
mm-mmap_lock-add-vma_is_attached-helper.patch
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch

