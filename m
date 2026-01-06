Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528DD33D4E2
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 17:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721019; cv=none; b=EXVnzC6PPWpH1Y89x8wiVel8+mfD/649iePjNBBtCcoMjsALv53C7Cw4fSpWVg6wRqrUSO40aD76ZK4wdtb8lOlLSB1Zii9nw9Wca7e6cjLbmMR/o4ofg/4qWu7eJYahneNJCvTuEZ6bhNCm/X/6GrSnoOmKzWLLBYrXnhPMDGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721019; c=relaxed/simple;
	bh=boMX1Sr4pyyd0nO5kKdtKQF5uhR7cNJQF21JYrRpN5c=;
	h=Date:To:From:Subject:Message-Id; b=JUy2cd4uIGTVygJ5AavufiGnyHOESB/CPBYOUkmM4OQ7YIAyb5Jl/lJaF8amxweWRH+/yh56/RDcJvUtjalYR/tPHXlwSD0NS00GhSz1z9rmHNCFIMYAqNbxb4e5cyqRFj3hkRlz3YYm4zcdTTsj6UzlEXu3PLlM55Bng3CVnYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A+0Ro7fm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A+0Ro7fm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C825C116C6;
	Tue,  6 Jan 2026 17:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767721019;
	bh=boMX1Sr4pyyd0nO5kKdtKQF5uhR7cNJQF21JYrRpN5c=;
	h=Date:To:From:Subject:From;
	b=A+0Ro7fmHPZiIA3x0EgcHEBcWr8saDT9l48dRIXiGBfddxl0pr44v7fdolRDGHvqS
	 6nmQO6wYe36t47zePUd9cg+itam0I3GNf4szx/EQeaXNnS0DgwDyEylaGVFroj/DFS
	 b8HqPCbL1QzxrF82LRMH+PcPsVz1GXFuyiSRjQGA=
Date: Tue, 06 Jan 2026 09:36:58 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,mhocko@suse.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,chriscli@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts.patch added to mm-new branch
Message-Id: <20260106173659.0C825C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: improve anon_vma_clone(), unlink_anon_vmas() comments, add asserts
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts.patch

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
Subject: mm/rmap: improve anon_vma_clone(), unlink_anon_vmas() comments, add asserts
Date: Tue, 6 Jan 2026 15:04:26 +0000

Patch series "mm: clean up anon_vma implementation", v2.

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

We then makes use of these known conditions to directly skip unfaulted
VMAs (rather than implicitly via an empty vma->anon_vma_chain list).

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


This patch (of 8):

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

Link: https://lkml.kernel.org/r/cover.1767711638.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/5f55507a877028add5fdf8f207f5e333c7a3fc85.1767711638.git.lorenzo.stoakes@oracle.com
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

 mm/rmap.c |  128 +++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 103 insertions(+), 25 deletions(-)

--- a/mm/rmap.c~mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts
+++ a/mm/rmap.c
@@ -258,30 +258,62 @@ static inline void unlock_anon_vma_root(
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
+ * - VMA Merge, but only when @dst is unfaulted and @src is faulted - meaning we
+ *   clone @src into @dst.
+ * - VMA split.
+ * - VMA (m)remap.
+ * - Fork of faulted VMA.
+ *
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
 
@@ -315,14 +347,7 @@ int anon_vma_clone(struct vm_area_struct
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
 
@@ -393,11 +418,64 @@ int anon_vma_fork(struct vm_area_struct
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
+	bool locked = false;
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
+		if (!locked) {
+			anon_vma_lock_write(anon_vma);
+			locked = true;
+		}
+
+		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
+		list_del(&avc->same_vma);
+		anon_vma_chain_free(avc);
+	}
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

