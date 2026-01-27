Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9908031619E
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486654; cv=none; b=hjhT5dCvA+MvhqtNgSLx3EsgJDj59OnMkGALdPSOd+ei6qnv/JSICfYq0pYztMKmRq7vb2q/v4rhmJsv5CSqqlpyUZvi80EYcJGPkJkA2fNdW62i6I5mecSoG/411M8+tVLAK1phMDxZCCMp5Gb8MN8Ha63oYGkNInihtyIeGO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486654; c=relaxed/simple;
	bh=sJfSTVxtgvTvX2wz59++CVmhuKzuuIeFvkjgZSir7LY=;
	h=Date:To:From:Subject:Message-Id; b=iuJxXXXjIygMcT9NSi4GkOvnnO8yjDWOC5bislKk8oERCoBcnHinSvxYLboSnt6VkzwyMYNZgzzxtgDdE78uPI667h5dia61qOaRIJ6JCXNrTpipId0RPLQ1AYLeJRIJcP99IdastKzskIRXSINXiXkfnvHFBMkpF1r8+olie2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M9ku0Rcu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M9ku0Rcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704B9C116C6;
	Tue, 27 Jan 2026 04:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486654;
	bh=sJfSTVxtgvTvX2wz59++CVmhuKzuuIeFvkjgZSir7LY=;
	h=Date:To:From:Subject:From;
	b=M9ku0Rcup8bIVDUo5mlyqScbP8NUuzCwg8wY5OiJXABGCJjzOR30knqJEHxgfQAIb
	 A06L9EbU5qfDwwETlWN1712S0gINtSYzr/2EjcCScNU1DjTB2TYHMCvc60fYFil7TP
	 6ghMfRr6sUJkVQ2n4VsP3L+DEtRZ+3Y6K/avbjU4=
Date: Mon, 26 Jan 2026 20:04:13 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,mhocko@suse.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,chriscli@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts.patch removed from -mm tree
Message-Id: <20260127040414.704B9C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: improve anon_vma_clone(), unlink_anon_vmas() comments, add asserts
has been removed from the -mm tree.  Its filename was
     mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/rmap: improve anon_vma_clone(), unlink_anon_vmas() comments, add asserts
Date: Sun, 18 Jan 2026 14:50:37 +0000

Patch series "mm: clean up anon_vma implementation", v3.

The anon_vma logic is hugely confusing and, much like a bundle of wires
entangled with one another, pulling on one thread seems only to lead to
more entanglement elsewhere.

There is a mish-mash of the core implementation, how that implementation
is invoked, how helper functions are invoked and concepts such as adjacent
anon_vma merge and anon_vma object reuse.

This series tries to improve the situation somewhat.

It starts by establishing some invariants in the core anon_vma_clone() and
unlink_anon_vmas() functions, largely expressed via VM_WARN_ON_ONCE()
asserts.

These act as some form of self-documentation as to the conditions we find
ourselves in when invoking these functions.

We also add kdoc comments for anon_vma_clone() and unlink_anon_vmas().

We then update anon_vma_fork() to avoid passing a partially set up (and
thus invalid) VMA to unlink_anon_vmas() - functions which are used both
for partially set up and valid data types has historically been the source
of a lot of confusion and bugs.

We then makes use of the established known conditions to directly skip
unfaulted VMAs (rather than implicitly via an empty vma->anon_vma_chain
list).

We remove the confusing anon_vma_merge() function (we already have a
concept of anon_vma merge in that we merge anon_vma's that would otherwise
be compatible except for attributes that mprotect() could change - which
anon_vma_merge() has nothing to do with).

We make the anon_vma functions internal to mm as they do not need to be
used by any other part of the kernel, which allows for future abstraction
without concern about this.

We then reduce the time over which we hold the anon rmap lock in
anon_vma_clone(), as it turns out we can allocate anon_vma_chain objects
without holding this lock, since the objects are not yet accessible from
the rmap.

This should reduce anon_vma lock contention.

This additionally allows us to remove a confusing GFP_NOWAIT, GFP_KERNEL
allocation fallback strategy.

Finally, we explicitly indicate which operation is being performed upon
anon_vma_clone(), and separate out fork-only logic to make it very clear
that anon_vma reuse only occurs on fork.


This patch (of 9):

Add kdoc comments and describe exactly what these functions are used for
in detail, pointing out importantly that the anon_vma_clone()
!dst->anon_vma && src->anon_vma dance is ONLY for fork.

Both are confusing functions that will be refactored in a subsequent patch
but the first stage is establishing documentation and some invariants.

Add some basic CONFIG_DEBUG_VM asserts that help document expected state,
specifically:

anon_vma_clone()
- mmap write lock held.
- We do nothing if src VMA is not faulted.
- The destination VMA has no anon_vma_chain yet.
- We are always operating on the same active VMA (i.e. vma->anon_vma).
- If not forking, must operate on the same mm_struct.

unlink_anon_vmas()
- mmap lock held (write lock except when freeing page tables).
- That unfaulted VMAs are no-ops.

We are presented with a special case when anon_vma_clone() fails to
allocate memory, where we have a VMA with partially set up anon_vma state.
Since we hold the exclusive mmap write lock, and since we are cloning
from a source VMA which consequently can't also have its anon_vma state
modified, we know no anon_vma referenced can be empty.

This allows us to significantly simplify this case and just remove
anon_vma_chain objects associated with the VMA, so we add a specific
partial cleanup path for this scenario.

This also allows us to drop the hack of setting vma->anon_vma to NULL
before unlinking anon_vma state in this scenario.

Link: https://lkml.kernel.org/r/cover.1768746221.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/8644e89369be0cc89d7ac57443dff9e822803c91.1768746221.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
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
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |  131 ++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 106 insertions(+), 25 deletions(-)

--- a/mm/rmap.c~mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts
+++ a/mm/rmap.c
@@ -257,30 +257,62 @@ static inline void unlock_anon_vma_root(
 		up_write(&root->rwsem);
 }
 
-/*
- * Attach the anon_vmas from src to dst.
- * Returns 0 on success, -ENOMEM on failure.
+static void check_anon_vma_clone(struct vm_area_struct *dst,
+				 struct vm_area_struct *src)
+{
+	/* The write lock must be held. */
+	mmap_assert_write_locked(src->vm_mm);
+	/* If not a fork (implied by dst->anon_vma) then must be on same mm. */
+	VM_WARN_ON_ONCE(dst->anon_vma && dst->vm_mm != src->vm_mm);
+
+	/* If we have anything to do src->anon_vma must be provided. */
+	VM_WARN_ON_ONCE(!src->anon_vma && !list_empty(&src->anon_vma_chain));
+	VM_WARN_ON_ONCE(!src->anon_vma && dst->anon_vma);
+	/* We are establishing a new anon_vma_chain. */
+	VM_WARN_ON_ONCE(!list_empty(&dst->anon_vma_chain));
+	/*
+	 * On fork, dst->anon_vma is set NULL (temporarily). Otherwise, anon_vma
+	 * must be the same across dst and src.
+	 */
+	VM_WARN_ON_ONCE(dst->anon_vma && dst->anon_vma != src->anon_vma);
+}
+
+static void cleanup_partial_anon_vmas(struct vm_area_struct *vma);
+
+/**
+ * anon_vma_clone - Establishes new anon_vma_chain objects in @dst linking to
+ * all of the anon_vma objects contained within @src anon_vma_chain's.
+ * @dst: The destination VMA with an empty anon_vma_chain.
+ * @src: The source VMA we wish to duplicate.
+ *
+ * This is the heart of the VMA side of the anon_vma implementation - we invoke
+ * this function whenever we need to set up a new VMA's anon_vma state.
+ *
+ * This is invoked for:
+ *
+ * - VMA Merge, but only when @dst is unfaulted and @src is faulted - meaning we
+ *   clone @src into @dst.
+ * - VMA split.
+ * - VMA (m)remap.
+ * - Fork of faulted VMA.
  *
- * anon_vma_clone() is called by vma_expand(), vma_merge(), __split_vma(),
- * copy_vma() and anon_vma_fork(). The first four want an exact copy of src,
- * while the last one, anon_vma_fork(), may try to reuse an existing anon_vma to
- * prevent endless growth of anon_vma. Since dst->anon_vma is set to NULL before
- * call, we can identify this case by checking (!dst->anon_vma &&
- * src->anon_vma).
- *
- * If (!dst->anon_vma && src->anon_vma) is true, this function tries to find
- * and reuse existing anon_vma which has no vmas and only one child anon_vma.
- * This prevents degradation of anon_vma hierarchy to endless linear chain in
- * case of constantly forking task. On the other hand, an anon_vma with more
- * than one child isn't reused even if there was no alive vma, thus rmap
- * walker has a good chance of avoiding scanning the whole hierarchy when it
- * searches where page is mapped.
+ * In all cases other than fork this is simply a duplication. Fork additionally
+ * adds a new active anon_vma.
+ *
+ * ONLY in the case of fork do we try to 'reuse' existing anon_vma's in an
+ * anon_vma hierarchy, reusing anon_vma's which have no VMA associated with them
+ * but do have a single child. This is to avoid waste of memory when repeatedly
+ * forking.
+ *
+ * Returns: 0 on success, -ENOMEM on failure.
  */
 int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 {
 	struct anon_vma_chain *avc, *pavc;
 	struct anon_vma *root = NULL;
 
+	check_anon_vma_clone(dst, src);
+
 	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma;
 
@@ -314,14 +346,7 @@ int anon_vma_clone(struct vm_area_struct
 	return 0;
 
  enomem_failure:
-	/*
-	 * dst->anon_vma is dropped here otherwise its num_active_vmas can
-	 * be incorrectly decremented in unlink_anon_vmas().
-	 * We can safely do this because callers of anon_vma_clone() don't care
-	 * about dst->anon_vma if anon_vma_clone() failed.
-	 */
-	dst->anon_vma = NULL;
-	unlink_anon_vmas(dst);
+	cleanup_partial_anon_vmas(dst);
 	return -ENOMEM;
 }
 
@@ -392,11 +417,67 @@ int anon_vma_fork(struct vm_area_struct
 	return -ENOMEM;
 }
 
+/*
+ * In the unfortunate case of anon_vma_clone() failing to allocate memory we
+ * have to clean things up.
+ *
+ * On clone we hold the exclusive mmap write lock, so we can't race
+ * unlink_anon_vmas(). Since we're cloning, we know we can't have empty
+ * anon_vma's, since existing anon_vma's are what we're cloning from.
+ *
+ * So this function needs only traverse the anon_vma_chain and free each
+ * allocated anon_vma_chain.
+ */
+static void cleanup_partial_anon_vmas(struct vm_area_struct *vma)
+{
+	struct anon_vma_chain *avc, *next;
+	struct anon_vma *root = NULL;
+
+	/*
+	 * We exclude everybody else from being able to modify anon_vma's
+	 * underneath us.
+	 */
+	mmap_assert_locked(vma->vm_mm);
+
+	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
+		struct anon_vma *anon_vma = avc->anon_vma;
+
+		/* All anon_vma's share the same root. */
+		if (!root) {
+			root = anon_vma->root;
+			anon_vma_lock_write(root);
+		}
+
+		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
+		list_del(&avc->same_vma);
+		anon_vma_chain_free(avc);
+	}
+
+	if (root)
+		anon_vma_unlock_write(root);
+}
+
+/**
+ * unlink_anon_vmas() - remove all links between a VMA and anon_vma's, freeing
+ * anon_vma_chain objects.
+ * @vma: The VMA whose links to anon_vma objects is to be severed.
+ *
+ * As part of the process anon_vma_chain's are freed,
+ * anon_vma->num_children,num_active_vmas is updated as required and, if the
+ * relevant anon_vma references no further VMAs, its reference count is
+ * decremented.
+ */
 void unlink_anon_vmas(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc, *next;
 	struct anon_vma *root = NULL;
 
+	/* Always hold mmap lock, read-lock on unmap possibly. */
+	mmap_assert_locked(vma->vm_mm);
+
+	/* Unfaulted is a no-op. */
+	VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_chain));
+
 	/*
 	 * Unlink each anon_vma chained to the VMA.  This list is ordered
 	 * from newest to oldest, ensuring the root anon_vma gets freed last.
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

