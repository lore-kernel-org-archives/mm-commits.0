Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C383043CF
	for <mm-commits@vger.kernel.org>; Wed,  1 Apr 2026 17:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775065514; cv=none; b=iZ4hwBX6e036EMpyWMBp98yijXz1qIaBOO1ojlbUg64sFSGfVV58bFZXy0Dq9TIpBEaJ20sdEGvTkCtOziQlu/SOUAzYanAP3JEf2VghdvitCUnP0lLqj8z5kTgK0wDqSbSygJRcKFe7W3bCT3cpPx9dsUamNa2dlMmhvGXspuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775065514; c=relaxed/simple;
	bh=0Xz5mfcjmAgTs0CKU/Y/8cmjwAnLxl7Kfwb1/yyQUCU=;
	h=Date:To:From:Subject:Message-Id; b=PoTB1Iq9YMTfo4wjXOWrLRlUcKkSeg2nv5V6Ijm5lqiMaUBflkm+10Cpxi58SrNOAsrKdMb2FXxFyqgESheOjEX9vFA+6fBpAy8ZTdf3K++ReP8Mh2gpfwC3id8/VqXsUyS3fBqJQiMTTL/sJgNYf7MavRXQKBG4f+++Ci3lKfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mz2vBnea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mz2vBnea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD04AC4CEF7;
	Wed,  1 Apr 2026 17:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775065514;
	bh=0Xz5mfcjmAgTs0CKU/Y/8cmjwAnLxl7Kfwb1/yyQUCU=;
	h=Date:To:From:Subject:From;
	b=Mz2vBneaoo2krexO5zW8dy7LD2LFQy9siEmOhUTqBc2Uk5zbE+9fz1fTJbTNsuVex
	 6j2C968pCCNbyfpBkHZO4YbMp+ZnBMe3mbyfC3juIzIJsXbAHHBgx1QcdM+hCCtjex
	 W9E44okn2SqCdDg5ITCOPzlgrmEKfCrpubgzIQT4=
Date: Wed, 01 Apr 2026 10:45:13 -0700
To: mm-commits@vger.kernel.org,harry@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] userfaultfd-introduce-struct-mfill_state-fix.patch removed from -mm tree
Message-Id: <20260401174513.DD04AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd-introduce-struct-mfill_state-fix
has been removed from the -mm tree.  Its filename was
     userfaultfd-introduce-struct-mfill_state-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Mike Rapoport <rppt@kernel.org>
Subject: userfaultfd-introduce-struct-mfill_state-fix
Date: Wed, 1 Apr 2026 10:36:03 +0300

fix bisection hole, per Harry

Link: https://lkml.kernel.org/r/aczK4-vrULRiTvyh@kernel.org
Signed-off-by: Mike Rapoport <rppt@kernel.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |  231 +++++++++++++++++++++++++--------------------
 1 file changed, 129 insertions(+), 102 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-introduce-struct-mfill_state-fix
+++ a/mm/userfaultfd.c
@@ -157,6 +157,125 @@ static void uffd_mfill_unlock(struct vm_
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
+static pmd_t *mm_alloc_pmd(struct mm_struct *mm, unsigned long address)
+{
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
+
+	pgd = pgd_offset(mm, address);
+	p4d = p4d_alloc(mm, pgd, address);
+	if (!p4d)
+		return NULL;
+	pud = pud_alloc(mm, p4d, address);
+	if (!pud)
+		return NULL;
+	/*
+	 * Note that we didn't run this because the pmd was
+	 * missing, the *pmd may be already established and in
+	 * turn it may also be a trans_huge_pmd.
+	 */
+	return pmd_alloc(mm, pud, address);
+}
+
+static int mfill_establish_pmd(struct mfill_state *state)
+{
+	struct mm_struct *dst_mm = state->ctx->mm;
+	pmd_t *dst_pmd, dst_pmdval;
+
+	dst_pmd = mm_alloc_pmd(dst_mm, state->dst_addr);
+	if (unlikely(!dst_pmd))
+		return -ENOMEM;
+
+	dst_pmdval = pmdp_get_lockless(dst_pmd);
+	if (unlikely(pmd_none(dst_pmdval)) &&
+	    unlikely(__pte_alloc(dst_mm, dst_pmd)))
+		return -ENOMEM;
+
+	dst_pmdval = pmdp_get_lockless(dst_pmd);
+	/*
+	 * If the dst_pmd is THP don't override it and just be strict.
+	 * (This includes the case where the PMD used to be THP and
+	 * changed back to none after __pte_alloc().)
+	 */
+	if (unlikely(!pmd_present(dst_pmdval) || pmd_leaf(dst_pmdval)))
+		return -EEXIST;
+	if (unlikely(pmd_bad(dst_pmdval)))
+		return -EFAULT;
+
+	state->pmd = dst_pmd;
+	return 0;
+}
+
 /* Check if dst_addr is outside of file's size. Must be called with ptl held. */
 static bool mfill_file_over_size(struct vm_area_struct *dst_vma,
 				 unsigned long dst_addr)
@@ -489,27 +608,6 @@ out:
 	return ret;
 }
 
-static pmd_t *mm_alloc_pmd(struct mm_struct *mm, unsigned long address)
-{
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-
-	pgd = pgd_offset(mm, address);
-	p4d = p4d_alloc(mm, pgd, address);
-	if (!p4d)
-		return NULL;
-	pud = pud_alloc(mm, p4d, address);
-	if (!pud)
-		return NULL;
-	/*
-	 * Note that we didn't run this because the pmd was
-	 * missing, the *pmd may be already established and in
-	 * turn it may also be a trans_huge_pmd.
-	 */
-	return pmd_alloc(mm, pud, address);
-}
-
 #ifdef CONFIG_HUGETLB_PAGE
 /*
  * mfill_atomic processing for HUGETLB vmas.  Note that this routine is
@@ -738,11 +836,8 @@ static __always_inline ssize_t mfill_ato
 		.src_addr = src_start,
 		.dst_addr = dst_start,
 	};
-	struct mm_struct *dst_mm = ctx->mm;
-	struct vm_area_struct *dst_vma;
 	long copied = 0;
 	ssize_t err;
-	pmd_t *dst_pmd;
 
 	/*
 	 * Sanitize the command parameters:
@@ -755,103 +850,37 @@ static __always_inline ssize_t mfill_ato
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
+	state.vma = dst_vma;
 
 	/*
 	 * If this is a HUGETLB vma, pass off to appropriate routine
 	 */
-	if (is_vm_hugetlb_page(dst_vma))
-		return  mfill_atomic_hugetlb(ctx, dst_vma, dst_start,
-					     src_start, len, flags);
-
-	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
-		goto out_unlock;
-	if (!vma_is_shmem(dst_vma) &&
-	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
-		goto out_unlock;
-
-	state.vma = dst_vma;
+	if (is_vm_hugetlb_page(state.vma))
+		return mfill_atomic_hugetlb(ctx, state.vma, dst_start,
+					    src_start, len, flags);
 
 	while (state.src_addr < src_start + len) {
 		VM_WARN_ON_ONCE(state.dst_addr >= dst_start + len);
 
-		pmd_t dst_pmdval;
-
-		dst_pmd = mm_alloc_pmd(dst_mm, state.dst_addr);
-		if (unlikely(!dst_pmd)) {
-			err = -ENOMEM;
+		err = mfill_establish_pmd(&state);
+		if (err)
 			break;
-		}
 
-		dst_pmdval = pmdp_get_lockless(dst_pmd);
-		if (unlikely(pmd_none(dst_pmdval)) &&
-		    unlikely(__pte_alloc(dst_mm, dst_pmd))) {
-			err = -ENOMEM;
-			break;
-		}
-		dst_pmdval = pmdp_get_lockless(dst_pmd);
-		/*
-		 * If the dst_pmd is THP don't override it and just be strict.
-		 * (This includes the case where the PMD used to be THP and
-		 * changed back to none after __pte_alloc().)
-		 */
-		if (unlikely(!pmd_present(dst_pmdval) ||
-				pmd_trans_huge(dst_pmdval))) {
-			err = -EEXIST;
-			break;
-		}
-		if (unlikely(pmd_bad(dst_pmdval))) {
-			err = -EFAULT;
-			break;
-		}
 		/*
 		 * For shmem mappings, khugepaged is allowed to remove page
 		 * tables under us; pte_offset_map_lock() will deal with that.
 		 */
 
-		state.pmd = dst_pmd;
 		err = mfill_atomic_pte(&state);
 		cond_resched();
 
 		if (unlikely(err == -ENOENT)) {
 			void *kaddr;
 
-			up_read(&ctx->map_changing_lock);
-			uffd_mfill_unlock(state.vma);
+			mfill_put_vma(&state);
 			VM_WARN_ON_ONCE(!state.folio);
 
 			kaddr = kmap_local_folio(state.folio, 0);
@@ -880,9 +909,7 @@ retry:
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

userfaultfd-introduce-mfill_copy_folio_locked-helper.patch
userfaultfd-introduce-struct-mfill_state.patch
userfaultfd-introduce-mfill_establish_pmd-helper.patch
userfaultfd-introduce-mfill_get_vma-and-mfill_put_vma.patch
userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy.patch
userfaultfd-move-vma_can_userfault-out-of-line.patch
userfaultfd-introduce-vm_uffd_ops.patch
shmem-userfaultfd-use-a-vma-callback-to-handle-uffdio_continue.patch
userfaultfd-introduce-vm_uffd_ops-alloc_folio.patch
shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops.patch
userfaultfd-mfill_atomic-remove-retry-logic.patch

