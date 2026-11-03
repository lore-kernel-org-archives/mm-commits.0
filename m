Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672135;
	b=m6QhIjT6BO89JS832u2H+356pW9z1+3HHN/zz875TTs/fpq7EHL2D98n6d8ffH/Kml7+
	 i5Dhoa+tymeo4lZesTdDkJVbM6AwwjF6e1bELh8ixGhxPISF29CTjoiVd/gBnZALbeTBP
	 vXzfV0hI/d/JO/DqOO2ZqPt7EO6LVqeCteDV69hm87iGZLpkU5riHp7Fi83WHTQWA+e9p
	 QTXgGOBAgZicu2gKkEYLGgT0W+VOdQbJvwmIr/5XbBNKCvdNff6idrIL3tfNxZKNBa2HK
	 dD8DrmtSWtPJ9+UaeYFS0JHE8Ibnt0v60OuPjjC7NkycpbkDADZ9ubyQ/s1ECP93otQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672135;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=d0KE9FRiDXklu+is89zxxemQV6g5/SGdbntGd/nFOzM=;
	b=Vp5LHJpWQM7E2Ens1bHIujnRFXyBlIp3F64qUuyprm8GdTTh8w3nR5cj9AxDlJgIEYBB
	 pJ8VJQ6S/q7QThkyq53Ys0jLR9uy98QOTvvUWOFKHDZuBTaPJTVcX0vdq6YIUgEGsqstJ
	 K0FoT3GE7bjGvKsWm/KektCxQj1qhs0KNQrwk3/Bg627A769s5ehHkW1UhxPsVUfW7MmA
	 76WxWfRNLThywIVhFiV9abbZa/8kuUeuvbBnv7O3k7zIJX3QPwqbP7u6ttqLaus0FmYqu
	 a0hixT1LyskNdGdpuDODEW4NzQceJHVhH89idWcwUvWor0oPFNzi1RhOf55rDxByRrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YiNR1crC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E86606A32F;
	Tue,  3 Nov 2026 02:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YiNR1crC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18211F000C1;
	Tue,  3 Nov 2026 02:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672134;
	bh=d0KE9FRiDXklu+is89zxxemQV6g5/SGdbntGd/nFOzM=;
	h=Date:To:From:Subject;
	b=YiNR1crCE58bVcJMVM/pEGLHkZyEpjp2CT1raH4cvIajbqXorp17t2wXozCBrFcHu
	 ro7T7H8LJuekrTIIuQjOnqgygkaU/nIznUE3SRrgqXnuuptIUrqElIr8fJ0kpK+l4A
	 7N4YWi1HzAiG7Rd1Tq0c8pbMfvSwIjyhvdt3wGrM=
Date: Mon, 02 Nov 2026 18:15:34 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	stable@vger.kernel.org,sj@kernel.org,rppt@kernel.org,pfalcato@suse.de,
	mhocko@suse.com,liam@infradead.org,kees@kernel.org,jannh@google.com,
	gourry@gourry.net,david@kernel.org,dave@stgolabs.net,ccross@google.com,
	ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vma-avoid-losing-atomic-vma-flags-when-setting-sticky-vma-flags.patch removed from -mm tree
Message-Id: <20261103021534.B18211F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/vma: avoid losing atomic VMA flags when setting sticky VMA flags
has been removed from the -mm tree.  Its filename was
     mm-vma-avoid-losing-atomic-vma-flags-when-setting-sticky-vma-flags.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/vma: avoid losing atomic VMA flags when setting sticky VMA flags
Date: Fri, 23 Oct 2026 14:47:30 +0100

vma_merge_existing_range() merges an existing VMA (middle) when its
attributes have changed to match those of one or both adjacent VMAs.

Sticky flags are propagated if they are set in any of the merged VMAs. They
are initialised from vmg->vma_flags, which is assumed to contain middle's
sticky flags when the function is invoked.

However, the VMA write lock is not held for middle when they are first
populated, so concurrent updates to atomic VMA flags may occur, which will
be lost upon merge.

This can result in fork failing to propagate guard region markers and (if
file-backed) THP collapse discarding them.

Resolve this by propagating the sticky flags after middle is locked.

Make life easier by factoring this into propagate_sticky_flags(), which
treats vmg->vma_flags as its base (in case any sticky flags are set there),
updating it as sticky flags are accumulated from merged VMAs.

Also update vma_expand() to use propagate_sticky_flags() so all merge paths
utilise it.

propagate_sticky_flags() also asserts that the VMA write lock is held for
the VMA whose sticky flags are being read, with a comment explaining why.

Another means by which atomic VMA flags can fail to be observed is when the
merge is finalised in commit_merge().

rmap locks are dropped in vma_complete() before the sticky flags are
written, meaning an rmap walker can observe the VMA without sticky flags
set, which can also result in retract_page_tables() discarding guard
markers.

Resolve this by assigning the sticky flags before dropping rmap locks,
factored into commit_sticky_flags() with a write assert on the VMA being
written to.

Also remove the vma_set_flags_mask() invocation at the end of
vma_merge_existing_range() as this was introduced by commit
64212ba02e66 ("mm: implement sticky VMA flags") to propagate sticky flags,
which is now redundant with the introduction of commit_sticky_flags().

The vma_set_flags_mask() invocation at the end of vma_expand() setting
sticky flags only is also removed for the same reason.

Also update vma_merge_existing_range()'s comment to reflect the fact that
vmg->vma_flags gets updated.

Finally, update the userland VMA tests to reflect a previously missed
const-ification in vma_assert_write_locked() which would otherwise cause a
warning when building them.

Link: https://lore.kernel.org/20261023-fix-vma-atomic-v1-4-8ff4fae1fc85@kernel.org
Fixes: 2ab7f1bbafc9 ("mm/madvise: allow guard page install/remove under VMA lock")
Fixes: 49e14dabed7a ("mm: set the VM_MAYBE_GUARD flag on guard region install")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jann Horn <jannh@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: SJ Park <sj@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Colin Cross <ccross@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/vma.c                          |   55 +++++++++++++++-------------
 tools/testing/vma/include/dup.h   |    2 -
 tools/testing/vma/include/stubs.h |    2 -
 3 files changed, 32 insertions(+), 27 deletions(-)

--- a/mm/vma.c~mm-vma-avoid-losing-atomic-vma-flags-when-setting-sticky-vma-flags
+++ a/mm/vma.c
@@ -783,6 +783,27 @@ static void vmg_adjust_set_range(struct
 	}
 }
 
+static void propagate_sticky_flags(struct vma_merge_struct *vmg,
+		const struct vm_area_struct *vma)
+{
+	const vma_flags_t sticky =
+		vma_flags_and_mask(&vma->flags, VMA_STICKY_FLAGS);
+
+	/* Write lock prevents concurrent atomic VMA flag updates. */
+	vma_assert_write_locked(vma);
+	vma_flags_set_mask(&vmg->vma_flags, sticky);
+}
+
+static void commit_sticky_flags(struct vma_merge_struct *vmg)
+{
+	const vma_flags_t sticky =
+		vma_flags_and_mask(&vmg->vma_flags, VMA_STICKY_FLAGS);
+	struct vm_area_struct *target = vmg->target;
+
+	vma_assert_write_locked(target);
+	vma_set_flags_mask(target, sticky);
+}
+
 /*
  * Actually perform the VMA merge operation.
  *
@@ -818,6 +839,8 @@ static int commit_merge(struct vma_merge
 		return -ENOMEM;
 
 	vma_prepare(&vp);
+	/* Must be made visible before vma_complete() for rmap walkers. */
+	commit_sticky_flags(vmg);
 	/*
 	 * THP pages may need to do additional splits if we increase
 	 * middle->vm_start.
@@ -857,8 +880,8 @@ static bool can_merge_remove_vma(struct
  * merge.
  *
  * As part of this operation, if a merge occurs, the @vmg object will have its
- * vma, start, end, and pgoff fields modified to execute the merge. Subsequent
- * calls to this function should reset these fields.
+ * vma, start, end, pgoff and vma_flags fields modified to execute the merge.
+ * Subsequent calls to this function should reset these fields.
  *
  * Returns: The merged VMA if merge succeeds, or NULL otherwise.
  *
@@ -872,8 +895,6 @@ static bool can_merge_remove_vma(struct
 static __must_check struct vm_area_struct *vma_merge_existing_range(
 		struct vma_merge_struct *vmg)
 {
-	vma_flags_t sticky_flags = vma_flags_and_mask(&vmg->vma_flags,
-						      VMA_STICKY_FLAGS);
 	struct vm_area_struct *middle = vmg->middle;
 	struct vm_area_struct *prev = vmg->prev;
 	struct vm_area_struct *next;
@@ -966,24 +987,18 @@ static __must_check struct vm_area_struc
 
 	/* No matter what happens, we will be adjusting middle. */
 	vma_start_write(middle);
+	propagate_sticky_flags(vmg, middle);
 
 	if (merge_right) {
-		vma_flags_t next_sticky;
-
 		vma_start_write(next);
 		vmg->target = next;
-		next_sticky = vma_flags_and_mask(&next->flags, VMA_STICKY_FLAGS);
-		vma_flags_set_mask(&sticky_flags, next_sticky);
+		propagate_sticky_flags(vmg, next);
 	}
 
 	if (merge_left) {
-		vma_flags_t prev_sticky;
-
 		vma_start_write(prev);
 		vmg->target = prev;
-
-		prev_sticky = vma_flags_and_mask(&prev->flags, VMA_STICKY_FLAGS);
-		vma_flags_set_mask(&sticky_flags, prev_sticky);
+		propagate_sticky_flags(vmg, prev);
 	}
 
 	if (merge_both) {
@@ -1054,7 +1069,6 @@ static __must_check struct vm_area_struc
 	if (err || commit_merge(vmg))
 		goto abort;
 
-	vma_set_flags_mask(vmg->target, sticky_flags);
 	khugepaged_enter_vma(vmg->target, vmg->vm_flags);
 	vmg->state = VMA_MERGE_SUCCESS;
 	return vmg->target;
@@ -1241,16 +1255,11 @@ int vma_expand(struct vma_merge_struct *
 	struct vm_area_struct *target = vmg->target;
 	struct vm_area_struct *next = vmg->next;
 	bool remove_next = false;
-	vma_flags_t sticky_flags =
-		vma_flags_and_mask(&vmg->vma_flags, VMA_STICKY_FLAGS);
-	vma_flags_t target_sticky;
 	int ret = 0;
 
 	mmap_assert_write_locked(vmg->mm);
 	vma_start_write(target);
 
-	target_sticky = vma_flags_and_mask(&target->flags, VMA_STICKY_FLAGS);
-
 	if (next && target != next && vmg->end == next->vm_end)
 		remove_next = true;
 
@@ -1265,7 +1274,7 @@ int vma_expand(struct vma_merge_struct *
 	VM_WARN_ON_VMG(target->vm_start < vmg->start ||
 		       target->vm_end > vmg->end, vmg);
 
-	vma_flags_set_mask(&sticky_flags, target_sticky);
+	propagate_sticky_flags(vmg, target);
 
 	/*
 	 * If we are removing the next VMA or copying from a VMA
@@ -1282,18 +1291,14 @@ int vma_expand(struct vma_merge_struct *
 		return ret;
 
 	if (remove_next) {
-		vma_flags_t next_sticky;
-
 		vma_start_write(next);
 		vmg->__remove_next = true;
 
-		next_sticky = vma_flags_and_mask(&next->flags, VMA_STICKY_FLAGS);
-		vma_flags_set_mask(&sticky_flags, next_sticky);
+		propagate_sticky_flags(vmg, next);
 	}
 	if (commit_merge(vmg))
 		goto nomem;
 
-	vma_set_flags_mask(target, sticky_flags);
 	return 0;
 
 nomem:
--- a/tools/testing/vma/include/dup.h~mm-vma-avoid-losing-atomic-vma-flags-when-setting-sticky-vma-flags
+++ a/tools/testing/vma/include/dup.h
@@ -1212,7 +1212,7 @@ static inline void vma_assert_detached(s
 	WARN_ON_ONCE(vma_is_attached(vma));
 }
 
-static inline void vma_assert_write_locked(struct vm_area_struct *);
+static inline void vma_assert_write_locked(const struct vm_area_struct *);
 static inline void vma_mark_attached(struct vm_area_struct *vma)
 {
 	vma_assert_write_locked(vma);
--- a/tools/testing/vma/include/stubs.h~mm-vma-avoid-losing-atomic-vma-flags-when-setting-sticky-vma-flags
+++ a/tools/testing/vma/include/stubs.h
@@ -320,7 +320,7 @@ static inline void anon_vma_lock_write(s
 {
 }
 
-static inline void vma_assert_write_locked(struct vm_area_struct *vma)
+static inline void vma_assert_write_locked(const struct vm_area_struct *vma)
 {
 }
 
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-read-anon_vma-carefully-in-validate_mm.patch

