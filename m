Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B92D31619E
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486659; cv=none; b=MFR6moZ556OGaRW3SfSi1flYpeHDINUdc13yEWs/WVH/cPrNwKmUSpfVA/nuxnXcKRP1sz1JPtEIS4U+K7TXLzfiQEInh0JzPVEMhkJG7Rf92TGRyPJTAniObMDkcvR5QnOrlNH8t7JZtNtpxLmLH1nIPhtgiH+28L+r3L4NMqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486659; c=relaxed/simple;
	bh=O8PcdF0Vxu5LDfm4I2JwuiUj9CEz5BFilqA3rbyXSxY=;
	h=Date:To:From:Subject:Message-Id; b=EkejfKL2tHSuTGc8MCMaQUNnawtUuf1pgd7if7crTZx4P9wuRtA1KISPeaI2taiB1coxCbgi3n1YGDLgJBBbFzSzoBj8KfhLQKf9Qr1od14GcWSRhMAfh1f1tS+qd3rywyzsB4u2o1oQzOxA+59xBfGmQd1om1zUsyCXkT9QudE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tqpVaULl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tqpVaULl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF2EC116C6;
	Tue, 27 Jan 2026 04:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486659;
	bh=O8PcdF0Vxu5LDfm4I2JwuiUj9CEz5BFilqA3rbyXSxY=;
	h=Date:To:From:Subject:From;
	b=tqpVaULlNoF8BBL8T6oFHOF3alsdQAspGZfrB8H7JiKLei6f+aDc8LgG7GheKBZ1T
	 c8WlpMYQHPK96OTCoLW0GxC8TV0EnPYwfwvI/t8k4KPQyU+R2W/ebulA09RHSZ+jgf
	 teGgmBgsodJYACwWrbgBxmF7GYxp7bnmtXhYHQII=
Date: Mon, 26 Jan 2026 20:04:18 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,mhocko@suse.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,chriscli@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap.patch removed from -mm tree
Message-Id: <20260127040419.5AF2EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: remove unnecessary root lock dance in anon_vma clone, unmap
has been removed from the -mm tree.  Its filename was
     mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/rmap: remove unnecessary root lock dance in anon_vma clone, unmap
Date: Sun, 18 Jan 2026 14:50:40 +0000

The root anon_vma of all anon_vma's linked to a VMA must by definition be
the same - a VMA and all of its descendants/ancestors must exist in the
same CoW chain.

Commit bb4aa39676f7 ("mm: avoid repeated anon_vma lock/unlock sequences in
anon_vma_clone()") introduced paranoid checking of the root anon_vma
remaining the same throughout all AVC's in 2011.

I think 15 years later we can safely assume that this is always the case.

Additionally, since unfaulted VMAs being cloned from or unlinked are
no-op's, we can simply lock the anon_vma's associated with this rather
than doing any specific dance around this.

This removes unnecessary checks and makes it clear that the root anon_vma
is shared between all anon_vma's in a given VMA's anon_vma_chain.

Link: https://lkml.kernel.org/r/838030d2f0772b99fa99ff4b4fd571353f14a1a9.1768746221.git.lorenzo.stoakes@oracle.com
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

 mm/rmap.c |   51 +++++++++++++++------------------------------------
 1 file changed, 15 insertions(+), 36 deletions(-)

--- a/mm/rmap.c~mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap
+++ a/mm/rmap.c
@@ -231,32 +231,6 @@ int __anon_vma_prepare(struct vm_area_st
 	return -ENOMEM;
 }
 
-/*
- * This is a useful helper function for locking the anon_vma root as
- * we traverse the vma->anon_vma_chain, looping over anon_vma's that
- * have the same vma.
- *
- * Such anon_vma's should have the same root, so you'd expect to see
- * just a single mutex_lock for the whole traversal.
- */
-static inline struct anon_vma *lock_anon_vma_root(struct anon_vma *root, struct anon_vma *anon_vma)
-{
-	struct anon_vma *new_root = anon_vma->root;
-	if (new_root != root) {
-		if (WARN_ON_ONCE(root))
-			up_write(&root->rwsem);
-		root = new_root;
-		down_write(&root->rwsem);
-	}
-	return root;
-}
-
-static inline void unlock_anon_vma_root(struct anon_vma *root)
-{
-	if (root)
-		up_write(&root->rwsem);
-}
-
 static void check_anon_vma_clone(struct vm_area_struct *dst,
 				 struct vm_area_struct *src)
 {
@@ -309,26 +283,28 @@ static void cleanup_partial_anon_vmas(st
 int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 {
 	struct anon_vma_chain *avc, *pavc;
-	struct anon_vma *root = NULL;
 
 	check_anon_vma_clone(dst, src);
 
 	if (!src->anon_vma)
 		return 0;
 
+	check_anon_vma_clone(dst, src);
+
+	/* All anon_vma's share the same root. */
+	anon_vma_lock_write(src->anon_vma);
 	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma;
 
 		avc = anon_vma_chain_alloc(GFP_NOWAIT);
 		if (unlikely(!avc)) {
-			unlock_anon_vma_root(root);
-			root = NULL;
+			anon_vma_unlock_write(src->anon_vma);
 			avc = anon_vma_chain_alloc(GFP_KERNEL);
 			if (!avc)
 				goto enomem_failure;
+			anon_vma_lock_write(src->anon_vma);
 		}
 		anon_vma = pavc->anon_vma;
-		root = lock_anon_vma_root(root, anon_vma);
 		anon_vma_chain_link(dst, avc, anon_vma);
 
 		/*
@@ -345,7 +321,8 @@ int anon_vma_clone(struct vm_area_struct
 	}
 	if (dst->anon_vma)
 		dst->anon_vma->num_active_vmas++;
-	unlock_anon_vma_root(root);
+
+	anon_vma_unlock_write(src->anon_vma);
 	return 0;
 
  enomem_failure:
@@ -475,17 +452,19 @@ static void cleanup_partial_anon_vmas(st
 void unlink_anon_vmas(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc, *next;
-	struct anon_vma *root = NULL;
+	struct anon_vma *active_anon_vma = vma->anon_vma;
 
 	/* Always hold mmap lock, read-lock on unmap possibly. */
 	mmap_assert_locked(vma->vm_mm);
 
 	/* Unfaulted is a no-op. */
-	if (!vma->anon_vma) {
+	if (!active_anon_vma) {
 		VM_WARN_ON_ONCE(!list_empty(&vma->anon_vma_chain));
 		return;
 	}
 
+	anon_vma_lock_write(active_anon_vma);
+
 	/*
 	 * Unlink each anon_vma chained to the VMA.  This list is ordered
 	 * from newest to oldest, ensuring the root anon_vma gets freed last.
@@ -493,7 +472,6 @@ void unlink_anon_vmas(struct vm_area_str
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-		root = lock_anon_vma_root(root, anon_vma);
 		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
 
 		/*
@@ -509,13 +487,14 @@ void unlink_anon_vmas(struct vm_area_str
 		anon_vma_chain_free(avc);
 	}
 
-	vma->anon_vma->num_active_vmas--;
+	active_anon_vma->num_active_vmas--;
 	/*
 	 * vma would still be needed after unlink, and anon_vma will be prepared
 	 * when handle fault.
 	 */
 	vma->anon_vma = NULL;
-	unlock_anon_vma_root(root);
+	anon_vma_unlock_write(active_anon_vma);
+
 
 	/*
 	 * Iterate the list once more, it now only contains empty and unlinked
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

