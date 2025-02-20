Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382471DE896
	for <mm-commits@vger.kernel.org>; Thu, 20 Feb 2025 20:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740083597; cv=none; b=iYsNHJUvwbGji/J7IIcd/JnHDZUIXbZXpzaDHXyMVDCbZulOvp+Row+MO3iev3RFQ6UR4Eg9sKzC+Lh0/nArnlSJt66F6MxfWov6MTmafIaKPNCubSvnkJjiO2nRO5ZaHNyaCNiFZnTqqGHk4vcyllQLnZ9RCy46ky03DU8616Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740083597; c=relaxed/simple;
	bh=qcmfUPcPi0n3tRaOQrBks2tWBWTjwBjZhbH/lwKVcDk=;
	h=Date:To:From:Subject:Message-Id; b=sPBj8Ufe1V67Qyrxgh7r4TkHxDrW/M9/hW3snKqThrqyyxVwuEeWUJLSo6XUdxbLg83v1pS/tYGVOwrLZyUwyxuTbZFn1/PoNXme2vxikFbmPAFZR5ZlSjNBcEaT8FR+FoGmN3aadZL0//Utc8XKozvbApmwAnJ0z50CTsXEaV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N8Cn/TGz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N8Cn/TGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF8CC4CED1;
	Thu, 20 Feb 2025 20:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740083596;
	bh=qcmfUPcPi0n3tRaOQrBks2tWBWTjwBjZhbH/lwKVcDk=;
	h=Date:To:From:Subject:From;
	b=N8Cn/TGzdC4ZpZekXNks5zqktAAIOeoLhOCtXEJKErOCRw2DqPsCem8LF/pXlYzyK
	 Or0mtSgsI5/6wIqBvGEEk/S4HsI8l7k0KzaOB58jFiUEy5CthVdxjL0YY67JIFwcAc
	 ekFYvlC2W+fThEsdwxEoOtlwrccGgk/PqBvcJvzI=
Date: Thu, 20 Feb 2025 12:33:16 -0800
To: mm-commits@vger.kernel.org,hca@linux.ibm.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-vm_lock-and-detached-flag-with-a-reference-count-fix.patch added to mm-unstable branch
Message-Id: <20250220203316.8AF8CC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix a crash due to vma_end_read() that should have been removed
has been added to the -mm mm-unstable branch.  Its filename is
     mm-replace-vm_lock-and-detached-flag-with-a-reference-count-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-replace-vm_lock-and-detached-flag-with-a-reference-count-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: fix a crash due to vma_end_read() that should have been removed
Date: Thu, 20 Feb 2025 12:02:08 -0800

Handling a vma lock failure due to vma being detached from under us got
changed but vma_end_read() in that path was left untouched while it should
have been removed.  Remove it.

Link: https://lkml.kernel.org/r/20250220200208.323769-1-surenb@google.com
Fixes: 758f7664c3d1 ("mm: replace vm_lock and detached flag with a reference count")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Heiko Carstens <hca@linux.ibm.com>
Closes: https://lore.kernel.org/all/20250220185304.8313A7d-hca@linux.ibm.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memory.c~mm-replace-vm_lock-and-detached-flag-with-a-reference-count-fix
+++ a/mm/memory.c
@@ -6451,7 +6451,6 @@ retry:
 	if (IS_ERR_OR_NULL(vma)) {
 		/* Check if the VMA got isolated after we found it */
 		if (PTR_ERR(vma) == -EAGAIN) {
-			vma_end_read(vma);
 			count_vm_vma_lock_event(VMA_LOCK_MISS);
 			/* The area was replaced with another one */
 			goto retry;
_

Patches currently in -mm which might be from surenb@google.com are

mm-avoid-extra-mem_alloc_profiling_enabled-checks.patch
alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-slab-allocator.patch
alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-page-allocator.patch
mm-introduce-vma_start_read_locked_nested-helpers.patch
mm-move-per-vma-lock-into-vm_area_struct.patch
mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch
mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas.patch
mm-mark-vmas-detached-upon-exit.patch
types-move-struct-rcuwait-into-typesh.patch
mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail.patch
mm-move-mmap_init_lock-out-of-the-header-file.patch
mm-uninline-the-main-body-of-vma_start_write.patch
refcount-provide-ops-for-cases-when-objects-memory-can-be-reused.patch
refcount-provide-ops-for-cases-when-objects-memory-can-be-reused-fix.patch
refcount-introduce-__refcount_addinc_not_zero_limited_acquire.patch
mm-replace-vm_lock-and-detached-flag-with-a-reference-count.patch
mm-replace-vm_lock-and-detached-flag-with-a-reference-count-fix.patch
mm-move-lesser-used-vma_area_struct-members-into-the-last-cacheline.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch
mm-remove-extra-vma_numab_state_init-call.patch
mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
mm-make-vma-cache-slab_typesafe_by_rcu-fix.patch
docs-mm-document-latest-changes-to-vm_lock.patch

