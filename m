Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689FE2C1586
	for <mm-commits@vger.kernel.org>; Wed, 28 Jan 2026 18:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769624938; cv=none; b=EJY/D3OQbZFB++iawn5625TcH0WzcQ3vK/d05TyWiiMvyXYtXkJbmumdi/ZHBso/Sum9YtVuJqt/qF7bRdnt64V6rXGoFshO6mQctSqyMUnsYPTgNv0IRfOXzfKiJcCtM9kD3Rd3pEcrVlPBxCxdj6x2FlWPmM1UkzZUQJNfy78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769624938; c=relaxed/simple;
	bh=NJ5LFdzLdvDAjq01614W0g4Nz0BbA8CYEtWZ3+Kv58w=;
	h=Date:To:From:Subject:Message-Id; b=qOeNoCPdFInKjf3a4NPYhJ9unxVgAbrCHedHgGeTVFa2fAPHjBNk9WSqUbhbMjfSsgcoAuoVArwEhalnjbIfTq1QDJmE8wpR2AMcR8/+aUqTkgDR4r2DLnPKgHrSEdaFJiM6DhRVGUpfD2UWzZuZfky0XNwyLkxxi0FPThSRvoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yyvbr/nL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yyvbr/nL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F4FC4CEF1;
	Wed, 28 Jan 2026 18:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769624938;
	bh=NJ5LFdzLdvDAjq01614W0g4Nz0BbA8CYEtWZ3+Kv58w=;
	h=Date:To:From:Subject:From;
	b=Yyvbr/nLl3cQwY0DJXSdLSElI/yEbYAehgdnSCBYh0B53B1spIPCh/fDUwOmoL/nL
	 mAz+p7fxQHMC/yCdw9Jxitus25xfvnuIYVmhWU1qMAZu8ixrWTvCqWL4udr+v0cAYV
	 ZsvhU07o1sOCgGISdGY7hjikyXXqyXF1GfAcZiwo=
Date: Wed, 28 Jan 2026 10:28:57 -0800
To: mm-commits@vger.kernel.org,clm@fb.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-update-secretmem-to-use-vma-flags-on-mmap_prepare-fix.patch added to mm-unstable branch
Message-Id: <20260128182858.04F4FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-update-secretmem-to-use-vma-flags-on-mmap_prepare-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-update-secretmem-to-use-vma-flags-on-mmap_prepare-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-update-secretmem-to-use-vma-flags-on-mmap_prepare-fix.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm-update-secretmem-to-use-vma-flags-on-mmap_prepare-fix
Date: Wed, 28 Jan 2026 16:41:55 +0000

fix check_brk_limits(), per Chris

Link: https://lkml.kernel.org/r/3aab9ab1-74b4-405e-9efb-08fc2500c06e@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Chris Mason <clm@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mmap.c~mm-update-secretmem-to-use-vma-flags-on-mmap_prepare-fix
+++ a/mm/mmap.c
@@ -108,7 +108,8 @@ static int check_brk_limits(unsigned lon
 	if (IS_ERR_VALUE(mapped_addr))
 		return mapped_addr;
 
-	return mlock_future_ok(current->mm, current->mm->def_flags, len)
+	return mlock_future_ok(current->mm,
+			      current->mm->def_flags & VM_LOCKED, len)
 		? 0 : -EAGAIN;
 }
 
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
mm-update-secretmem-to-use-vma-flags-on-mmap_prepare-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t.patch
mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t.patch
mm-make-vm_area_desc-utilise-vma_flags_t-only.patch
tools-testing-vma-separate-vma-userland-tests-into-separate-files.patch
tools-testing-vma-separate-out-vma_internalh-into-logical-headers.patch
tools-testing-vma-separate-out-vma_internalh-into-logical-headers-fix.patch
tools-testing-vma-add-vma-userland-tests-for-vma-flag-functions.patch

