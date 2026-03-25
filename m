Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A7730BB83
	for <mm-commits@vger.kernel.org>; Wed, 25 Mar 2026 22:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774477779; cv=none; b=ETtpA/BdPKPzEpcYACTWvSDlrAAAUX5Srq6HDlt5Zu83hvovyIU7U7wzHLxilQE3CUufZ2gsihI41uAKmBvtJtO2WjkPng+ji04wJT8bzEnofPjtmWOMEX1EwHseUJ9D9nM8Ur8vC4rrAx9FEr1gMiKlEWiO9s41EKZpOafHko4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774477779; c=relaxed/simple;
	bh=ztaRa7Xx0JAxJiw0ngbnN0oLZaQTvSDToVT4y8BCSTo=;
	h=Date:To:From:Subject:Message-Id; b=FfN03eaTFsTJ323tbnj4OapyZ2rpwFrURA+sMebqRyJAMW1fgIbN+LEB60yW9b1Y4/sys8Aj2fxmWk382I6l6ZT0Z+Mfa35yQre4mZVg+p0UT2wzYNUo4AoShrkv412WdVJgDR7QmLvDp3BoRy9qiBh92DrP5l23GrrUi0Zpemo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=12v7tcnh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="12v7tcnh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA1CC4CEF7;
	Wed, 25 Mar 2026 22:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774477778;
	bh=ztaRa7Xx0JAxJiw0ngbnN0oLZaQTvSDToVT4y8BCSTo=;
	h=Date:To:From:Subject:From;
	b=12v7tcnhLhv6zNyPYe614POeht34xvZE8Itvl06wspJQNkQN4MrhE+zHJM9l3KIQk
	 9RPeW40+lK6KXsJYdMKxnLKj65yM6pL27W9mW0UESWCseEqwT0dJKt1vQhvq6nyAdW
	 049/6hBvxa7tYRKADpJFT2BRWJmMYBjfRf5b7NB4=
Date: Wed, 25 Mar 2026 15:29:37 -0700
To: mm-commits@vger.kernel.org,avagin@google.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-introduce-mfill_get_pmd-helper-fix.patch added to mm-unstable branch
Message-Id: <20260325222938.8AA1CC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd-introduce-mfill_get_pmd-helper-fix
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-introduce-mfill_get_pmd-helper-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-introduce-mfill_get_pmd-helper-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
userfaultfd-introduce-mfill_get_pmd-helper-fix.patch
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

