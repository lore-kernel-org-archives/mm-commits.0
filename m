Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE90133987D
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 17:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721023; cv=none; b=D09us5eXUJmBdsjRdvWBUqhD+lU2DZ8YMl3ih0TTP2xiK5nXOb1mSsnHttJvCift8Kx7/5eXLNvo0plI1aQk8z9ZdZNjyH4m1+Ta/IOzPPyZBfdpd0DgSAqWxF2Q/psng8JXWPE2iGRhWyHavJEm8QKxIbbtJnXgJHlxMzP1Jq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721023; c=relaxed/simple;
	bh=zPHntQyu/zQ38AfGApZuXds09yaOztgNVWFjxK6BaZA=;
	h=Date:To:From:Subject:Message-Id; b=BVxj9F7jssmzieh8r/bJ1JUVYweTa6aEPwD5IYDR8VLD1FoREs7nYUwOm/xHoITBpl766MoomcV56kKJPT+DHWayothBqTPY4VF6wDPrCzCy0zy2alcpm3ARvirpEypW8xG+vfdP/jEljh03z1rT2MqFavZtOrRQsj8xfQE/xOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e68v81q+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e68v81q+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEEEC116C6;
	Tue,  6 Jan 2026 17:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767721023;
	bh=zPHntQyu/zQ38AfGApZuXds09yaOztgNVWFjxK6BaZA=;
	h=Date:To:From:Subject:From;
	b=e68v81q+No5hJ/ymTx7x/XMhK0qVzoi6M+Uvo3qFIX0D4Lukx16K9D7QW7qidiej8
	 wl6a9j9cwRB6v6KUNg3Ar4EeMV23hT1L1eUQZqTC03hxZjXFmmsRfqY9Bb59jaEk66
	 fZ/83ugrV7mu8C+S0U3H6sYgCVasm3FO1QpJb8Rc=
Date: Tue, 06 Jan 2026 09:37:03 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,mhocko@suse.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,chriscli@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap.patch added to mm-new branch
Message-Id: <20260106173703.ABEEEC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: remove unnecessary root lock dance in anon_vma clone, unmap
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap.patch

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
Subject: mm/rmap: remove unnecessary root lock dance in anon_vma clone, unmap
Date: Tue, 6 Jan 2026 15:04:28 +0000

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

Link: https://lkml.kernel.org/r/9b5a438237e4ea3b19a986a4f8fddb8848cba54a.1767711638.git.lorenzo.stoakes@oracle.com
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

 mm/rmap.c |   51 +++++++++++++++------------------------------------
 1 file changed, 15 insertions(+), 36 deletions(-)

--- a/mm/rmap.c~mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap
+++ a/mm/rmap.c
@@ -232,32 +232,6 @@ int __anon_vma_prepare(struct vm_area_st
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
@@ -310,26 +284,28 @@ static void cleanup_partial_anon_vmas(st
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
@@ -346,7 +322,8 @@ int anon_vma_clone(struct vm_area_struct
 	}
 	if (dst->anon_vma)
 		dst->anon_vma->num_active_vmas++;
-	unlock_anon_vma_root(root);
+
+	anon_vma_unlock_write(src->anon_vma);
 	return 0;
 
  enomem_failure:
@@ -471,17 +448,19 @@ static void cleanup_partial_anon_vmas(st
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
@@ -489,7 +468,6 @@ void unlink_anon_vmas(struct vm_area_str
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-		root = lock_anon_vma_root(root, anon_vma);
 		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
 
 		/*
@@ -505,13 +483,14 @@ void unlink_anon_vmas(struct vm_area_str
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

