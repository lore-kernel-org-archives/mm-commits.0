Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF4833DEFC
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 17:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721034; cv=none; b=VKhQ5KscZ6WGRnzWaQ8cvehqUDmTzNihhYjPOIgOJA0FLcR9pianOpt4sT6CJwsuvIyMrzrtkg8zrsSosCsmqoHab+9l5CWLueTQ9R3IXHRlOdhMoqlYrGEK3gzjHPSx74x5nsfZlfBLDDYwPUepHpjjJpCjSIZjT10odF0ibyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721034; c=relaxed/simple;
	bh=omT0d7o0K5yoI7ECxJLb/1DDovBlYcuuKZQZNEfNVi0=;
	h=Date:To:From:Subject:Message-Id; b=p5x/2viEFJP6ZGQRoppHlKhwBameN0GzjzxT0DIfGw2GdEZhlB/HeLW+yc+ONCI4yWILab59DTlIVvoG0HBn7DLDAOwVUQF1XwgW7fifVaJU+rBWWuf4qFbYTJoW5+BIiGZ4IWjxVL4ZC0TuPtroEP403GQ5JcSTGwA/FPfRF9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gcfzMHxl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gcfzMHxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5A7C116C6;
	Tue,  6 Jan 2026 17:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767721033;
	bh=omT0d7o0K5yoI7ECxJLb/1DDovBlYcuuKZQZNEfNVi0=;
	h=Date:To:From:Subject:From;
	b=gcfzMHxl9amdduL1xA5tvXtysh0xpTfilKk3y2T5LvUA7gb2TWUKedhqEGHB9rxXG
	 k7qW/AuXknIa3nunTbdAGhLANABZkFNIYsh7C+MlwoC9v46QKO6TfiNS24Cuf8yFYI
	 O2QG7zNbcAhk9iGcf6pPolU05LyBMyk6mM4lBmQM=
Date: Tue, 06 Jan 2026 09:37:13 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,mhocko@suse.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,chriscli@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch added to mm-new branch
Message-Id: <20260106173713.9B5A7C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: allocate anon_vma_chain objects unlocked when possible
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch

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
Subject: mm/rmap: allocate anon_vma_chain objects unlocked when possible
Date: Tue, 6 Jan 2026 15:04:32 +0000

There is no reason to allocate the anon_vma_chain under the anon_vma write
lock when cloning - we can in fact assign these to the destination VMA
safely as we hold the exclusive mmap lock and therefore preclude anybody
else accessing these fields.

We only need take the anon_vma write lock when we link rbtree edges from
the anon_vma to the newly established AVCs.

This also allows us to eliminate the weird GFP_NOWAIT, GFP_KERNEL dance
introduced in commit dd34739c03f2 ("mm: avoid anon_vma_chain allocation
under anon_vma lock"), further simplifying this logic.

This should reduce lock anon_vma contention, and clarifies exactly where
the anon_vma lock is required.

We cannot adjust __anon_vma_prepare() in the same way as this is only
protected by VMA read lock, so we have to perform the allocation here
under the anon_vma write lock and page_table_lock (to protect against
racing threads), and we wish to retain the lock ordering.

With this change we can simplify cleanup_partial_anon_vmas() even further
- since we allocate AVC's without any lock taken and do not insert
anything into the interval tree until after the allocations are tried, we
can remove all logic pertaining to this and just free up AVC's only.

Link: https://lkml.kernel.org/r/ff2651a4d5b73c7cc8160c55d46d6e5385996e62.1767711638.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   76 +++++++++++++++++++++++-----------------------------
 1 file changed, 34 insertions(+), 42 deletions(-)

--- a/mm/rmap.c~mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible
+++ a/mm/rmap.c
@@ -147,14 +147,13 @@ static void anon_vma_chain_free(struct a
 	kmem_cache_free(anon_vma_chain_cachep, anon_vma_chain);
 }
 
-static void anon_vma_chain_link(struct vm_area_struct *vma,
-				struct anon_vma_chain *avc,
-				struct anon_vma *anon_vma)
+static void anon_vma_chain_assign(struct vm_area_struct *vma,
+				  struct anon_vma_chain *avc,
+				  struct anon_vma *anon_vma)
 {
 	avc->vma = vma;
 	avc->anon_vma = anon_vma;
 	list_add(&avc->same_vma, &vma->anon_vma_chain);
-	anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 }
 
 /**
@@ -211,7 +210,8 @@ int __anon_vma_prepare(struct vm_area_st
 	spin_lock(&mm->page_table_lock);
 	if (likely(!vma->anon_vma)) {
 		vma->anon_vma = anon_vma;
-		anon_vma_chain_link(vma, avc, anon_vma);
+		anon_vma_chain_assign(vma, avc, anon_vma);
+		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 		anon_vma->num_active_vmas++;
 		allocated = NULL;
 		avc = NULL;
@@ -292,21 +292,31 @@ int anon_vma_clone(struct vm_area_struct
 
 	check_anon_vma_clone(dst, src);
 
-	/* All anon_vma's share the same root. */
+	/*
+	 * Allocate AVCs. We don't need an anon_vma lock for this as we
+	 * are not updating the anon_vma rbtree nor are we changing
+	 * anon_vma statistics.
+	 *
+	 * We hold the exclusive mmap write lock so there's no possibliity of
+	 * the unlinked AVC's being observed yet.
+	 */
+	list_for_each_entry(pavc, &src->anon_vma_chain, same_vma) {
+		avc = anon_vma_chain_alloc(GFP_KERNEL);
+		if (!avc)
+			goto enomem_failure;
+
+		anon_vma_chain_assign(dst, avc, pavc->anon_vma);
+	}
+
+	/*
+	 * Now link the anon_vma's back to the newly inserted AVCs.
+	 * Note that all anon_vma's share the same root.
+	 */
 	anon_vma_lock_write(src->anon_vma);
-	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
-		struct anon_vma *anon_vma;
+	list_for_each_entry_reverse(avc, &dst->anon_vma_chain, same_vma) {
+		struct anon_vma *anon_vma = avc->anon_vma;
 
-		avc = anon_vma_chain_alloc(GFP_NOWAIT);
-		if (unlikely(!avc)) {
-			anon_vma_unlock_write(src->anon_vma);
-			avc = anon_vma_chain_alloc(GFP_KERNEL);
-			if (!avc)
-				goto enomem_failure;
-			anon_vma_lock_write(src->anon_vma);
-		}
-		anon_vma = pavc->anon_vma;
-		anon_vma_chain_link(dst, avc, anon_vma);
+		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 
 		/*
 		 * Reuse existing anon_vma if it has no vma and only one
@@ -322,7 +332,6 @@ int anon_vma_clone(struct vm_area_struct
 	}
 	if (dst->anon_vma)
 		dst->anon_vma->num_active_vmas++;
-
 	anon_vma_unlock_write(src->anon_vma);
 	return 0;
 
@@ -384,8 +393,10 @@ int anon_vma_fork(struct vm_area_struct
 	get_anon_vma(anon_vma->root);
 	/* Mark this anon_vma as the one where our new (COWed) pages go. */
 	vma->anon_vma = anon_vma;
+	anon_vma_chain_assign(vma, avc, anon_vma);
+	/* Now let rmap see it. */
 	anon_vma_lock_write(anon_vma);
-	anon_vma_chain_link(vma, avc, anon_vma);
+	anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 	anon_vma->parent->num_children++;
 	anon_vma_unlock_write(anon_vma);
 
@@ -402,34 +413,15 @@ int anon_vma_fork(struct vm_area_struct
  * In the unfortunate case of anon_vma_clone() failing to allocate memory we
  * have to clean things up.
  *
- * On clone we hold the exclusive mmap write lock, so we can't race
- * unlink_anon_vmas(). Since we're cloning, we know we can't have empty
- * anon_vma's, since existing anon_vma's are what we're cloning from.
- *
- * So this function needs only traverse the anon_vma_chain and free each
- * allocated anon_vma_chain.
+ * Since we allocate anon_vma_chain's before we insert them into the interval
+ * trees, we simply have to free up the AVC's and remove the entries from the
+ * VMA's anon_vma_chain.
  */
 static void cleanup_partial_anon_vmas(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc, *next;
-	bool locked = false;
-
-	/*
-	 * We exclude everybody else from being able to modify anon_vma's
-	 * underneath us.
-	 */
-	mmap_assert_locked(vma->vm_mm);
 
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
-		struct anon_vma *anon_vma = avc->anon_vma;
-
-		/* All anon_vma's share the same root. */
-		if (!locked) {
-			anon_vma_lock_write(anon_vma);
-			locked = true;
-		}
-
-		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
 		list_del(&avc->same_vma);
 		anon_vma_chain_free(avc);
 	}
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

