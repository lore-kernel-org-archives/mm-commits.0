Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC52229992B
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 21:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769547983; cv=none; b=jnQ5pMmzR687Ab3s1tpvyc3FOF4KMm+ZwMjtm5KfWOValXOkyKmwPEJBai6X3p6xNtxPGPMtDrFUZcGBqM5IxCKsdX7Ds4+21NlPprobn+29b3wpCY80RXiy6tCyRbsTOiUYmIJKLYEZMuGCeldrrQJpTPebeaRLRblErkjltQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769547983; c=relaxed/simple;
	bh=8Fy95Sm8hjOKQto1QIA+QNyXun19SjbLr7gOcIDP0PE=;
	h=Date:To:From:Subject:Message-Id; b=nK3oIboJMfSJSY7VpXojarEMw5I1QuiIr0Z24dWyx1c0iqipIwYN8M5hDEWwP64OES2HMSLFWQ2UUD4WSJzAjy64Ll66LeklW8QSiZj9cEzz4cRLie02jJQrqJWKgN0kEpeFKU3UMlCjA9ibG1ES1y1aCm6Lo2LnQ7WcKlp2hx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m89mVr6V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m89mVr6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE7FC116C6;
	Tue, 27 Jan 2026 21:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769547983;
	bh=8Fy95Sm8hjOKQto1QIA+QNyXun19SjbLr7gOcIDP0PE=;
	h=Date:To:From:Subject:From;
	b=m89mVr6VXusWCT92TMmViyOqyiDVO1Ku0jXNc+m5Ofl3OS4fundDK1XdBnCBvpe/U
	 T0MqYZM+CuEkUZ15Y/9IVVO0JQ4Vrs/TN4WhT2hAiHRKcK28ZNB/UkYD0K9VmdEhD0
	 maezN1bAdwQUePkxaSxoxzEssbR/3DLCg3vSri9w=
Date: Tue, 27 Jan 2026 13:06:22 -0800
To: mm-commits@vger.kernel.org,oliver.sang@intel.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-vma-separate-out-vma_internalh-into-logical-headers-fix.patch added to mm-unstable branch
Message-Id: <20260127210623.2EE7FC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools-testing-vma-separate-out-vma_internalh-into-logical-headers-fix
has been added to the -mm mm-unstable branch.  Its filename is
     tools-testing-vma-separate-out-vma_internalh-into-logical-headers-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-vma-separate-out-vma_internalh-into-logical-headers-fix.patch

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
Subject: tools-testing-vma-separate-out-vma_internalh-into-logical-headers-fix
Date: Tue, 27 Jan 2026 10:02:00 +0000

avoid a duplicate struct define

Link: https://lkml.kernel.org/r/1e032732-61c3-485c-9aa7-6a09016fefc1@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202601271308.b8d3fcb6-lkp@intel.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/include/dup.h |   12 ------------
 1 file changed, 12 deletions(-)

--- a/tools/testing/vma/include/dup.h~tools-testing-vma-separate-out-vma_internalh-into-logical-headers-fix
+++ a/tools/testing/vma/include/dup.h
@@ -1327,15 +1327,3 @@ static inline void vma_set_file(struct v
 	swap(vma->vm_file, file);
 	fput(file);
 }
-
-struct unmap_desc {
-	struct  ma_state *mas;        /* the maple state point to the first vma */
-	struct vm_area_struct *first; /* The first vma */
-	unsigned long pg_start;       /* The first pagetable address to free (floor) */
-	unsigned long pg_end;         /* The last pagetable address to free (ceiling) */
-	unsigned long vma_start;      /* The min vma address */
-	unsigned long vma_end;        /* The max vma address */
-	unsigned long tree_end;       /* Maximum for the vma tree search */
-	unsigned long tree_reset;     /* Where to reset the vma tree walk */
-	bool mm_wr_locked;            /* If the mmap write lock is held */
-};
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
tools-testing-vma-separate-out-vma_internalh-into-logical-headers-fix.patch
tools-testing-vma-add-vma-userland-tests-for-vma-flag-functions.patch

