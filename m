Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FDB4218B4
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 17:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774544729; cv=none; b=TLHkerYY8S4eehDJuJad9bt0jgSXbAWGggc9npjPga30SmvPUnbQisoUSt6znWk7tHLd012KdE8BPqOvbopuyGWRjHKMZfhN/zhQV+lKWbwNQUOAaIYY8z9m9sKPRVVdTOlx6epmEAQE2TruBxNUW9Xu0mNzB79tcEPRXvBJjJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774544729; c=relaxed/simple;
	bh=4tWC7yYeULQHBg6HKmVaoYWzRZ9eA9wsnDX3K5By/9w=;
	h=Date:To:From:Subject:Message-Id; b=P69AA0DxTv4S/vzsijSwTgSxaPuZ65yDhM9cG6OKUX4G9b85nb7OzVmXRlS6mvQSQP3bAZ97nzn9lmchTaDMB6letF8N5dedsWg4uE/ANybk79t6fYQyDa+lrUn+WP6wkyv9KTiFB9AoJvkk0+vRKsVf0YwI6SCf1ZoTulLAHqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sdwjaI1a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sdwjaI1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFDAEC2BCB1;
	Thu, 26 Mar 2026 17:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774544728;
	bh=4tWC7yYeULQHBg6HKmVaoYWzRZ9eA9wsnDX3K5By/9w=;
	h=Date:To:From:Subject:From;
	b=sdwjaI1aSk45DdpyOVbEnvvW8CMZwN/CXxmvFElhjcv3iRfsI4o9LVodRl7Of9p0v
	 m8j0BtV+ordgtqprn2BbLx6C9rb/PUt7/rMfF32fhtjaldV8zqcnXUaK9nQYJ8a1Kz
	 KnPazt4eAWCUXg7EB0+QBh9KEvfIeEa6J0rFJgCQ=
Date: Thu, 26 Mar 2026 10:05:28 -0700
To: mm-commits@vger.kernel.org,avagin@google.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] userfaultfd-introduce-mfill_get_pmd-helper-fix.patch removed from -mm tree
Message-Id: <20260326170528.CFDAEC2BCB1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd-introduce-mfill_get_pmd-helper-fix
has been removed from the -mm tree.  Its filename was
     userfaultfd-introduce-mfill_get_pmd-helper-fix.patch

This patch was dropped because it was folded into userfaultfd-introduce-mfill_get_pmd-helper.patch

------------------------------------------------------
From: Mike Rapoport <rppt@kernel.org>
Subject: userfaultfd-introduce-mfill_get_pmd-helper-fix
Date: Wed, 25 Mar 2026 21:27:12 +0200

s/mfill_get_pmd/mfill_establish_pmd/, update ex-THP test

Link: https://lkml.kernel.org/r/acQ3EPSwizyClHKc@kernel.org
Signed-off-by: Mike Rapoport <rppt@kernel.org>
Cc: Andrei Vagin <avagin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-introduce-mfill_get_pmd-helper-fix
+++ a/mm/userfaultfd.c
@@ -178,11 +178,10 @@ static pmd_t *mm_alloc_pmd(struct mm_str
 	return pmd_alloc(mm, pud, address);
 }
 
-static int mfill_get_pmd(struct mfill_state *state)
+static int mfill_establish_pmd(struct mfill_state *state)
 {
 	struct mm_struct *dst_mm = state->ctx->mm;
-	pmd_t *dst_pmd;
-	pmd_t dst_pmdval;
+	pmd_t *dst_pmd, dst_pmdval;
 
 	dst_pmd = mm_alloc_pmd(dst_mm, state->dst_addr);
 	if (unlikely(!dst_pmd))
@@ -199,7 +198,7 @@ static int mfill_get_pmd(struct mfill_st
 	 * (This includes the case where the PMD used to be THP and
 	 * changed back to none after __pte_alloc().)
 	 */
-	if (unlikely(!pmd_present(dst_pmdval) || pmd_trans_huge(dst_pmdval)))
+	if (unlikely(!pmd_present(dst_pmdval) || pmd_leaf(dst_pmdval)))
 		return -EEXIST;
 	if (unlikely(pmd_bad(dst_pmdval)))
 		return -EFAULT;
@@ -838,7 +837,7 @@ retry:
 	while (state.src_addr < src_start + len) {
 		VM_WARN_ON_ONCE(state.dst_addr >= dst_start + len);
 
-		err = mfill_get_pmd(&state);
+		err = mfill_establish_pmd(&state);
 		if (err)
 			break;
 
_

Patches currently in -mm which might be from rppt@kernel.org are

userfaultfd-introduce-mfill_copy_folio_locked-helper.patch
userfaultfd-introduce-struct-mfill_state.patch
userfaultfd-introduce-mfill_get_pmd-helper.patch
userfaultfd-introduce-mfill_get_vma-and-mfill_put_vma.patch
userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy.patch
userfaultfd-move-vma_can_userfault-out-of-line.patch
userfaultfd-introduce-vm_uffd_ops.patch
userfaultfd-introduce-vm_uffd_ops-fix.patch
shmem-userfaultfd-use-a-vma-callback-to-handle-uffdio_continue.patch
userfaultfd-introduce-vm_uffd_ops-alloc_folio.patch
shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops.patch
userfaultfd-mfill_atomic-remove-retry-logic.patch
selftests-mm-pagemap_ioctl-remove-hungarian-notation.patch

