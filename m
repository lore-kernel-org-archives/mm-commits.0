Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB56C31079B
	for <mm-commits@vger.kernel.org>; Thu,  2 Apr 2026 04:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775103812; cv=none; b=njEGPcugXgPYWSFphJ8Kf11Ecub8ntQBlyJZxdoNs6jYXPrMA3urT3XYlAD/ypO0V3FbagPQUCwGSJ+0IqL/bBJVBgFGtJssaNuaO14LNVRlNYhq1IHVVomZMi0L9gxIzg61HAmpWdtSe2cb61CEecYGFCFg55pjptztP5R6r4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775103812; c=relaxed/simple;
	bh=KEATzNHQYcsmv8/q8TeSBhgrS+OVKYcgfqgdA13T1q8=;
	h=Date:To:From:Subject:Message-Id; b=Gb4iS8JV9AGfSSjJKw2PaNMPtWvS20gqIfw5e1XaovgSLQ58USofXMGQw2b5aF2U3uEvxyoodOHkwY+JpWbdTzBBgkQgSqQUSbszHUPvL/a7h7jpaOvs7ASRESnGYneD0pUSdlEYcPZE+0nlXp2sWYeCOtcUDAbn3/Cs+pL8py8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tih/c4n3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tih/c4n3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A0CC19423;
	Thu,  2 Apr 2026 04:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775103811;
	bh=KEATzNHQYcsmv8/q8TeSBhgrS+OVKYcgfqgdA13T1q8=;
	h=Date:To:From:Subject:From;
	b=Tih/c4n3tCUP2VTGWW/Ml5YijAjqLZzabfvN6XlJDWmj0ijGQZm+/lhKf2eTUBRUB
	 S+KQt+PuXn8Jp3+hKYeTwGT82HvpjZzERrJ8+kY/QkuduvaGlb7ThxZmRCki89EAEV
	 4E8qbo+jGGEy8tb8Mxd12O8tkm80EIaJoZRBugwg=
Date: Wed, 01 Apr 2026 21:23:31 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] userfaultfd-introduce-mfill_get_vma-and-mfill_put_vma.patch removed from -mm tree
Message-Id: <20260402042331.B7A0CC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: introduce mfill_get_vma() and mfill_put_vma()
has been removed from the -mm tree.  Its filename was
     userfaultfd-introduce-mfill_get_vma-and-mfill_put_vma.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: userfaultfd: introduce mfill_get_vma() and mfill_put_vma()
Date: Mon, 30 Mar 2026 13:11:05 +0300

Split the code that finds, locks and verifies VMA from mfill_atomic() into
a helper function.

This function will be used later during refactoring of
mfill_atomic_pte_copy().

Add a counterpart mfill_put_vma() helper that unlocks the VMA and releases
map_changing_lock.

[avagin@google.com: fix lock leak in mfill_get_vma()]
Link: https://lkml.kernel.org/r/20260316173829.1126728-1-avagin@google.com
Link: https://lkml.kernel.org/r/20260330101116.1117699-5-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrei Vagin <avagin@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nikita Kalyazin <kalyazin@amazon.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |  126 ++++++++++++++++++++++++++-------------------
 1 file changed, 75 insertions(+), 51 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-introduce-mfill_get_vma-and-mfill_put_vma
+++ a/mm/userfaultfd.c
@@ -157,6 +157,75 @@ static void uffd_mfill_unlock(struct vm_
 }
 #endif
 
+static void mfill_put_vma(struct mfill_state *state)
+{
+	if (!state->vma)
+		return;
+
+	up_read(&state->ctx->map_changing_lock);
+	uffd_mfill_unlock(state->vma);
+	state->vma = NULL;
+}
+
+static int mfill_get_vma(struct mfill_state *state)
+{
+	struct userfaultfd_ctx *ctx = state->ctx;
+	uffd_flags_t flags = state->flags;
+	struct vm_area_struct *dst_vma;
+	int err;
+
+	/*
+	 * Make sure the vma is not shared, that the dst range is
+	 * both valid and fully within a single existing vma.
+	 */
+	dst_vma = uffd_mfill_lock(ctx->mm, state->dst_start, state->len);
+	if (IS_ERR(dst_vma))
+		return PTR_ERR(dst_vma);
+
+	/*
+	 * If memory mappings are changing because of non-cooperative
+	 * operation (e.g. mremap) running in parallel, bail out and
+	 * request the user to retry later
+	 */
+	down_read(&ctx->map_changing_lock);
+	state->vma = dst_vma;
+	err = -EAGAIN;
+	if (atomic_read(&ctx->mmap_changing))
+		goto out_unlock;
+
+	err = -EINVAL;
+
+	/*
+	 * shmem_zero_setup is invoked in mmap for MAP_ANONYMOUS|MAP_SHARED but
+	 * it will overwrite vm_ops, so vma_is_anonymous must return false.
+	 */
+	if (WARN_ON_ONCE(vma_is_anonymous(dst_vma) &&
+	    dst_vma->vm_flags & VM_SHARED))
+		goto out_unlock;
+
+	/*
+	 * validate 'mode' now that we know the dst_vma: don't allow
+	 * a wrprotect copy if the userfaultfd didn't register as WP.
+	 */
+	if ((flags & MFILL_ATOMIC_WP) && !(dst_vma->vm_flags & VM_UFFD_WP))
+		goto out_unlock;
+
+	if (is_vm_hugetlb_page(dst_vma))
+		return 0;
+
+	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
+		goto out_unlock;
+	if (!vma_is_shmem(dst_vma) &&
+	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
+		goto out_unlock;
+
+	return 0;
+
+out_unlock:
+	mfill_put_vma(state);
+	return err;
+}
+
 static pmd_t *mm_alloc_pmd(struct mm_struct *mm, unsigned long address)
 {
 	pgd_t *pgd;
@@ -767,8 +836,6 @@ static __always_inline ssize_t mfill_ato
 		.src_addr = src_start,
 		.dst_addr = dst_start,
 	};
-	struct mm_struct *dst_mm = ctx->mm;
-	struct vm_area_struct *dst_vma;
 	long copied = 0;
 	ssize_t err;
 
@@ -783,57 +850,17 @@ static __always_inline ssize_t mfill_ato
 	VM_WARN_ON_ONCE(dst_start + len <= dst_start);
 
 retry:
-	/*
-	 * Make sure the vma is not shared, that the dst range is
-	 * both valid and fully within a single existing vma.
-	 */
-	dst_vma = uffd_mfill_lock(dst_mm, dst_start, len);
-	if (IS_ERR(dst_vma)) {
-		err = PTR_ERR(dst_vma);
+	err = mfill_get_vma(&state);
+	if (err)
 		goto out;
-	}
-
-	/*
-	 * If memory mappings are changing because of non-cooperative
-	 * operation (e.g. mremap) running in parallel, bail out and
-	 * request the user to retry later
-	 */
-	down_read(&ctx->map_changing_lock);
-	err = -EAGAIN;
-	if (atomic_read(&ctx->mmap_changing))
-		goto out_unlock;
-
-	err = -EINVAL;
-	/*
-	 * shmem_zero_setup is invoked in mmap for MAP_ANONYMOUS|MAP_SHARED but
-	 * it will overwrite vm_ops, so vma_is_anonymous must return false.
-	 */
-	if (WARN_ON_ONCE(vma_is_anonymous(dst_vma) &&
-	    dst_vma->vm_flags & VM_SHARED))
-		goto out_unlock;
-
-	/*
-	 * validate 'mode' now that we know the dst_vma: don't allow
-	 * a wrprotect copy if the userfaultfd didn't register as WP.
-	 */
-	if ((flags & MFILL_ATOMIC_WP) && !(dst_vma->vm_flags & VM_UFFD_WP))
-		goto out_unlock;
 
 	/*
 	 * If this is a HUGETLB vma, pass off to appropriate routine
 	 */
-	if (is_vm_hugetlb_page(dst_vma))
-		return  mfill_atomic_hugetlb(ctx, dst_vma, dst_start,
+	if (is_vm_hugetlb_page(state.vma))
+		return  mfill_atomic_hugetlb(ctx, state.vma, dst_start,
 					     src_start, len, flags);
 
-	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
-		goto out_unlock;
-	if (!vma_is_shmem(dst_vma) &&
-	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
-		goto out_unlock;
-
-	state.vma = dst_vma;
-
 	while (state.src_addr < src_start + len) {
 		VM_WARN_ON_ONCE(state.dst_addr >= dst_start + len);
 
@@ -852,8 +879,7 @@ retry:
 		if (unlikely(err == -ENOENT)) {
 			void *kaddr;
 
-			up_read(&ctx->map_changing_lock);
-			uffd_mfill_unlock(state.vma);
+			mfill_put_vma(&state);
 			VM_WARN_ON_ONCE(!state.folio);
 
 			kaddr = kmap_local_folio(state.folio, 0);
@@ -882,9 +908,7 @@ retry:
 			break;
 	}
 
-out_unlock:
-	up_read(&ctx->map_changing_lock);
-	uffd_mfill_unlock(state.vma);
+	mfill_put_vma(&state);
 out:
 	if (state.folio)
 		folio_put(state.folio);
_

Patches currently in -mm which might be from rppt@kernel.org are

userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy.patch
userfaultfd-move-vma_can_userfault-out-of-line.patch
userfaultfd-introduce-vm_uffd_ops.patch
shmem-userfaultfd-use-a-vma-callback-to-handle-uffdio_continue.patch
userfaultfd-introduce-vm_uffd_ops-alloc_folio.patch
shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops.patch
userfaultfd-mfill_atomic-remove-retry-logic.patch

