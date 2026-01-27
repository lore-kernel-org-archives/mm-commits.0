Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDEB318ED7
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486666; cv=none; b=DWNaRQeefhp+mDvpwBiDbpcE1hwZu612S3aA3y82oNbA4HePORO7HRSxPW/5beaCJCeVtn8XeKLU1pZ4eMVRGStNwefhfRhOT755u2leAgCKFWfm/X6I+P5m6JlRDonmIWrnYUbClxj6songb/t0KrxCbygZQ+SqRO2/idl0NBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486666; c=relaxed/simple;
	bh=NwsUri7b4gK1csRkkkBwB8u/NPArhwwFEl+73Z+KOHk=;
	h=Date:To:From:Subject:Message-Id; b=Tt6jrt0cYyM//ef07r+bDm/E4H12QebrqewZenSiEgDrL8JTUyp1TRHAFx/eWD35qfVFdVEeiKtcn7CkbHnbv3Kv9j2rCMNGY/Q1DN3x0+7FISCRu1oHwD6vYQMU/LKHxEz68UalB8lgwnQIHwDa7sl67f///ZJfWUcKKwekJ0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RFwRbBR8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RFwRbBR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358B4C116C6;
	Tue, 27 Jan 2026 04:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486666;
	bh=NwsUri7b4gK1csRkkkBwB8u/NPArhwwFEl+73Z+KOHk=;
	h=Date:To:From:Subject:From;
	b=RFwRbBR8qkswqy9DgKHwba1YDYZfayWNGJCh5CWzptdsm9aDrTejXVMsX3b0Rt0Xh
	 i3IGAJu/kv92h8XL+lJuPzR1/meQUs0rnXiPggNl090yvDysKkhwmBRpRQt7+OPFok
	 jD/tvMFhb87qwBthaSo6WZs/m1oWD+Jk8IJp5tnI=
Date: Mon, 26 Jan 2026 20:04:25 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,mhocko@suse.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,chriscli@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch removed from -mm tree
Message-Id: <20260127040426.358B4C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: allocate anon_vma_chain objects unlocked when possible
has been removed from the -mm tree.  Its filename was
     mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/rmap: allocate anon_vma_chain objects unlocked when possible
Date: Sun, 18 Jan 2026 14:50:44 +0000

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

Link: https://lkml.kernel.org/r/624bf1ac0bde4871fcfca2c8c8e294b6d8f7ae7b.1768746221.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   81 +++++++++++++++++++++++-----------------------------
 1 file changed, 36 insertions(+), 45 deletions(-)

--- a/mm/rmap.c~mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible
+++ a/mm/rmap.c
@@ -146,14 +146,13 @@ static void anon_vma_chain_free(struct a
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
@@ -210,7 +209,8 @@ int __anon_vma_prepare(struct vm_area_st
 	spin_lock(&mm->page_table_lock);
 	if (likely(!vma->anon_vma)) {
 		vma->anon_vma = anon_vma;
-		anon_vma_chain_link(vma, avc, anon_vma);
+		anon_vma_chain_assign(vma, avc, anon_vma);
+		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 		anon_vma->num_active_vmas++;
 		allocated = NULL;
 		avc = NULL;
@@ -291,21 +291,33 @@ int anon_vma_clone(struct vm_area_struct
 
 	check_anon_vma_clone(dst, src);
 
-	/* All anon_vma's share the same root. */
+	/*
+	 * Allocate AVCs. We don't need an anon_vma lock for this as we
+	 * are not updating the anon_vma rbtree nor are we changing
+	 * anon_vma statistics.
+	 *
+	 * Either src, dst have the same mm for which we hold an exclusive mmap
+	 * write lock, or we are forking and we hold it on src->vm_mm and dst is
+	 * not yet accessible to other threads so there's no possibliity of the
+	 * unlinked AVC's being observed yet.
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
@@ -321,7 +333,6 @@ int anon_vma_clone(struct vm_area_struct
 	}
 	if (dst->anon_vma)
 		dst->anon_vma->num_active_vmas++;
-
 	anon_vma_unlock_write(src->anon_vma);
 	return 0;
 
@@ -391,8 +402,10 @@ int anon_vma_fork(struct vm_area_struct
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
 
@@ -403,40 +416,18 @@ int anon_vma_fork(struct vm_area_struct
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
-	struct anon_vma *root = NULL;
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
-		if (!root) {
-			root = anon_vma->root;
-			anon_vma_lock_write(root);
-		}
-
-		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
 		list_del(&avc->same_vma);
 		anon_vma_chain_free(avc);
 	}
-
-	if (root)
-		anon_vma_unlock_write(root);
 }
 
 /**
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

