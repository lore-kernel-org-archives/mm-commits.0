Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D11A94A;
	Tue,  8 Oct 2024 00:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728349082; cv=none; b=XwetLdvTev7NYlZA5RmsTkmRVhp9A2m/j08h/1HzvFTErkkm6XYyK4nm18PUWgtVDIaH9qCRiWKHn593Tj42T+J9djRa6m5OBGZPd9S4JGjWWaYxfYbz7vFmcbvf4iA3OqYf+n6Ses21IjnQcfQ74bCJZJyv+3bjK/gPKHokn08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728349082; c=relaxed/simple;
	bh=whOBxWUZeejzqVwgL0Qi6ziLWsmjGZ7iVx0r3FA7/kE=;
	h=Date:To:From:Subject:Message-Id; b=FKrS8HM2LAuvDzY/4YqOcqqacpAvvNB3YPtZbkxgAREwGZW9oBOkb+brH4uTxEEyHeQKmn7eunCn9efIRkV9mMYBVbvBhh/HNZPZ94Ptr/eBOscUKLBJqkxMJNubw30M/cRwQw7IZyIpP1ZksC36c9XyfXEMbdUCvbJNNeuH/o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vbKvIAGr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vbKvIAGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59789C4CEC6;
	Tue,  8 Oct 2024 00:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728349081;
	bh=whOBxWUZeejzqVwgL0Qi6ziLWsmjGZ7iVx0r3FA7/kE=;
	h=Date:To:From:Subject:From;
	b=vbKvIAGrarwNmjbqGCgKivyqdEj3uWzp9YdYofWodXOGVTolo7RmTp+CStgXgVLey
	 wP3t+yKI4qVSfR4mnXy1uOBocgGUIyEfvwmpX1gi575Up2kDmPqD7gd5nXbX0WqP5g
	 snWuYfXq7sd4bws1Hbf+gTktzZs5RzL35+dRx2AA=
Date: Mon, 07 Oct 2024 17:58:00 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,hughd@google.com,david@redhat.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mremap-prevent-racing-change-of-old-pmd-type.patch removed from -mm tree
Message-Id: <20241008005801.59789C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: prevent racing change of old pmd type
has been removed from the -mm tree.  Its filename was
     mm-mremap-prevent-racing-change-of-old-pmd-type.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mm/mremap: prevent racing change of old pmd type
Date: Wed, 02 Oct 2024 23:07:06 +0200

Prevent move_normal_pmd() in mremap() from racing with
retract_page_tables() in MADVISE_COLLAPSE such that

    pmd_populate(mm, new_pmd, pmd_pgtable(pmd))

operates on an empty source pmd, causing creation of a new pmd which maps
physical address 0 as a page table.

This bug is only reachable if either CONFIG_READ_ONLY_THP_FOR_FS is set or
THP shmem is usable.  (Unprivileged namespaces can be used to set up a
tmpfs that can contain THP shmem pages with "huge=advise".)

If userspace triggers this bug *in multiple processes*, this could likely
be used to create stale TLB entries pointing to freed pages or cause
kernel UAF by breaking an invariant the rmap code relies on.

Fix it by moving the rmap locking up so that it covers the span from
reading the PMD entry to moving the page table.

Link: https://lkml.kernel.org/r/20241002-move_normal_pmd-vs-collapse-fix-v1-1-78290e5dece6@google.com
Fixes: 1d65b771bc08 ("mm/khugepaged: retract_page_tables() without mmap or vma lock")
Signed-off-by: Jann Horn <jannh@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   68 +++++++++++++++++++++++++++-----------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

--- a/mm/mremap.c~mm-mremap-prevent-racing-change-of-old-pmd-type
+++ a/mm/mremap.c
@@ -136,17 +136,17 @@ static pte_t move_soft_dirty_pte(pte_t p
 static int move_ptes(struct vm_area_struct *vma, pmd_t *old_pmd,
 		unsigned long old_addr, unsigned long old_end,
 		struct vm_area_struct *new_vma, pmd_t *new_pmd,
-		unsigned long new_addr, bool need_rmap_locks)
+		unsigned long new_addr)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *old_pte, *new_pte, pte;
 	spinlock_t *old_ptl, *new_ptl;
 	bool force_flush = false;
 	unsigned long len = old_end - old_addr;
-	int err = 0;
 
 	/*
-	 * When need_rmap_locks is true, we take the i_mmap_rwsem and anon_vma
+	 * When need_rmap_locks is true in the caller, we are holding the
+	 * i_mmap_rwsem and anon_vma
 	 * locks to ensure that rmap will always observe either the old or the
 	 * new ptes. This is the easiest way to avoid races with
 	 * truncate_pagecache(), page migration, etc...
@@ -163,23 +163,18 @@ static int move_ptes(struct vm_area_stru
 	 *   serialize access to individual ptes, but only rmap traversal
 	 *   order guarantees that we won't miss both the old and new ptes).
 	 */
-	if (need_rmap_locks)
-		take_rmap_locks(vma);
 
 	/*
 	 * We don't have to worry about the ordering of src and dst
 	 * pte locks because exclusive mmap_lock prevents deadlock.
 	 */
 	old_pte = pte_offset_map_lock(mm, old_pmd, old_addr, &old_ptl);
-	if (!old_pte) {
-		err = -EAGAIN;
-		goto out;
-	}
+	if (!old_pte)
+		return -EAGAIN;
 	new_pte = pte_offset_map_nolock(mm, new_pmd, new_addr, &new_ptl);
 	if (!new_pte) {
 		pte_unmap_unlock(old_pte, old_ptl);
-		err = -EAGAIN;
-		goto out;
+		return -EAGAIN;
 	}
 	if (new_ptl != old_ptl)
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
@@ -217,10 +212,7 @@ static int move_ptes(struct vm_area_stru
 		spin_unlock(new_ptl);
 	pte_unmap(new_pte - 1);
 	pte_unmap_unlock(old_pte - 1, old_ptl);
-out:
-	if (need_rmap_locks)
-		drop_rmap_locks(vma);
-	return err;
+	return 0;
 }
 
 #ifndef arch_supports_page_table_move
@@ -447,17 +439,14 @@ static __always_inline unsigned long get
 /*
  * Attempts to speedup the move by moving entry at the level corresponding to
  * pgt_entry. Returns true if the move was successful, else false.
+ * rmap locks are held by the caller.
  */
 static bool move_pgt_entry(enum pgt_entry entry, struct vm_area_struct *vma,
 			unsigned long old_addr, unsigned long new_addr,
-			void *old_entry, void *new_entry, bool need_rmap_locks)
+			void *old_entry, void *new_entry)
 {
 	bool moved = false;
 
-	/* See comment in move_ptes() */
-	if (need_rmap_locks)
-		take_rmap_locks(vma);
-
 	switch (entry) {
 	case NORMAL_PMD:
 		moved = move_normal_pmd(vma, old_addr, new_addr, old_entry,
@@ -483,9 +472,6 @@ static bool move_pgt_entry(enum pgt_entr
 		break;
 	}
 
-	if (need_rmap_locks)
-		drop_rmap_locks(vma);
-
 	return moved;
 }
 
@@ -550,6 +536,7 @@ unsigned long move_page_tables(struct vm
 	struct mmu_notifier_range range;
 	pmd_t *old_pmd, *new_pmd;
 	pud_t *old_pud, *new_pud;
+	int move_res;
 
 	if (!len)
 		return 0;
@@ -573,6 +560,12 @@ unsigned long move_page_tables(struct vm
 				old_addr, old_end);
 	mmu_notifier_invalidate_range_start(&range);
 
+	/*
+	 * Hold rmap locks to ensure the type of the old PUD/PMD entry doesn't
+	 * change under us due to khugepaged or folio splitting.
+	 */
+	take_rmap_locks(vma);
+
 	for (; old_addr < old_end; old_addr += extent, new_addr += extent) {
 		cond_resched();
 		/*
@@ -590,14 +583,14 @@ unsigned long move_page_tables(struct vm
 		if (pud_trans_huge(*old_pud) || pud_devmap(*old_pud)) {
 			if (extent == HPAGE_PUD_SIZE) {
 				move_pgt_entry(HPAGE_PUD, vma, old_addr, new_addr,
-					       old_pud, new_pud, need_rmap_locks);
+					       old_pud, new_pud);
 				/* We ignore and continue on error? */
 				continue;
 			}
 		} else if (IS_ENABLED(CONFIG_HAVE_MOVE_PUD) && extent == PUD_SIZE) {
 
 			if (move_pgt_entry(NORMAL_PUD, vma, old_addr, new_addr,
-					   old_pud, new_pud, true))
+					   old_pud, new_pud))
 				continue;
 		}
 
@@ -613,7 +606,7 @@ again:
 		    pmd_devmap(*old_pmd)) {
 			if (extent == HPAGE_PMD_SIZE &&
 			    move_pgt_entry(HPAGE_PMD, vma, old_addr, new_addr,
-					   old_pmd, new_pmd, need_rmap_locks))
+					   old_pmd, new_pmd))
 				continue;
 			split_huge_pmd(vma, old_pmd, old_addr);
 		} else if (IS_ENABLED(CONFIG_HAVE_MOVE_PMD) &&
@@ -623,17 +616,32 @@ again:
 			 * moving at the PMD level if possible.
 			 */
 			if (move_pgt_entry(NORMAL_PMD, vma, old_addr, new_addr,
-					   old_pmd, new_pmd, true))
+					   old_pmd, new_pmd))
 				continue;
 		}
 		if (pmd_none(*old_pmd))
 			continue;
-		if (pte_alloc(new_vma->vm_mm, new_pmd))
+
+		/*
+		 * Temporarily drop the rmap locks while we do a potentially
+		 * slow move_ptes() operation, unless move_ptes() wants them
+		 * held (see comment inside there).
+		 */
+		if (!need_rmap_locks)
+			drop_rmap_locks(vma);
+		if (pte_alloc(new_vma->vm_mm, new_pmd)) {
+			if (!need_rmap_locks)
+				take_rmap_locks(vma);
 			break;
-		if (move_ptes(vma, old_pmd, old_addr, old_addr + extent,
-			      new_vma, new_pmd, new_addr, need_rmap_locks) < 0)
+		}
+		move_res = move_ptes(vma, old_pmd, old_addr, old_addr + extent,
+				     new_vma, new_pmd, new_addr);
+		if (!need_rmap_locks)
+			take_rmap_locks(vma);
+		if (move_res < 0)
 			goto again;
 	}
+	drop_rmap_locks(vma);
 
 	mmu_notifier_invalidate_range_end(&range);
 
_

Patches currently in -mm which might be from jannh@google.com are

mm-enforce-a-minimal-stack-gap-even-against-inaccessible-vmas.patch
mm-mremap-fix-move_normal_pmd-retract_page_tables-race.patch

