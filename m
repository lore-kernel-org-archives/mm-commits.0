Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7264184109
	for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2024 21:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712784766; cv=none; b=orSpvlGGZjr++IjUL1LtwRfe1PM9bjzpBjXXdC258qhHzFbqXWqimaE8sQm2Rp2gX7OXQmm+qdeDQycOcQ7IZ43E0bHSmQIGfTi3fcG+41JqgN2XTwgfCar9Hd3dazSux2HW0N+VgSu5QxWB8+rd70yGlIz3UIV7Xb4tPJIzDwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712784766; c=relaxed/simple;
	bh=P8jCuKX+w5jjRt5jk/y3Z8bJy4rXZZQdCHwpi+qTDbs=;
	h=Date:To:From:Subject:Message-Id; b=WEBCyvS/yXyx1uodlrhceB09tdpN6OK+joHk8vJdvDKJamGP32OgfHnQGRGNe5emVlP0RV9PGNh66q3V4SbfBv1Xf0A8HOHZNG8/UONOwZoOXGE2P0k4fOW8autJsVKxIBLa8p7gTni8OsMLSQfcPJIheaXsouBn2UXFglQND8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tEd2SHj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tEd2SHj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEF7C433B1;
	Wed, 10 Apr 2024 21:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712784766;
	bh=P8jCuKX+w5jjRt5jk/y3Z8bJy4rXZZQdCHwpi+qTDbs=;
	h=Date:To:From:Subject:From;
	b=tEd2SHj6Ftin5x9USvJEm1bqYRXNogVVIYp9yzzSQ3U9gTfBXACys7zGWO0nDHHkR
	 a5WLOukncZ+13tqkk0VLybQAjuZoY3Rsbq5pCUg3mhxgveiAQyB3P9GohbDTGK0B4G
	 IQ3hkAuBc2Oyfy9G6nF7jkcHp0XXybMraR3V1fDo=
Date: Wed, 10 Apr 2024 14:32:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,lokeshgidra@google.com,Liam.Howlett@oracle.com,apopple@nvidia.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-always-sanity-check-anon_vma-first-for-per-vma-locks.patch removed from -mm tree
Message-Id: <20240410213246.2EEF7C433B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: Always sanity check anon_vma first for per-vma locks
has been removed from the -mm tree.  Its filename was
     mm-always-sanity-check-anon_vma-first-for-per-vma-locks.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: Always sanity check anon_vma first for per-vma locks
Date: Wed, 10 Apr 2024 13:06:21 -0400

anon_vma is a tricky object in the context of per-vma lock, because it's
racy to modify it in that context and mmap lock is needed if it's not
stable yet.

So far there are three places that sanity checks anon_vma for that:

  - lock_vma_under_rcu(): this is the major entrance of per-vma lock, where
    we have taken care of anon memory v.s. potential anon_vma allocations.

  - lock_vma(): even if it looks so generic as an API, it's only used in
    userfaultfd context to leverage per-vma locks.  It does extra check
    over MAP_PRIVATE file mappings for the same anon_vma issue.

  - vmf_anon_prepare(): it works for private file mapping faults just like
    what lock_vma() wanted to cover above.  One trivial difference is in
    some extremely corner case, the fault handler will still allow per-vma
    fault to happen, like a READ on a privately mapped file.

The question is whether that's intended to make it as complicated.  Per my
question in the thread, it is not intended, and Suren also seems to agree [1].

So the trivial side effect of such patch is:

  - We may do slightly better on the first WRITE of a private file mapping,
  because we can retry earlier (in lock_vma_under_rcu(), rather than
  vmf_anon_prepare() later).

  - We may always use mmap lock for the initial READs on a private file
  mappings, while before this patch it _can_ (only when no WRITE ever
  happened... but it doesn't make much sense for a MAP_PRIVATE..) do the
  read fault with per-vma lock.

Then noted that right after any WRITE the anon_vma will be stablized, then
there will be no difference.  And I believe that should be the majority
cases too; I also did try to run a program, writting to MAP_PRIVATE file
memory (that I pre-headed in the page cache) and I can hardly measure a
difference in performance.

Let's simply ignore all those trivial corner cases and unify the anon_vma
check from three places into one.  I also didn't check the rest users of
lock_vma_under_rcu(), where in a !fault context it could even fix something
that used to race with private file mappings but I didn't check further.

I still left a WARN_ON_ONCE() in vmf_anon_prepare() to double check we're
all good.

[1] https://lore.kernel.org/r/CAJuCfpGj5xk-NxSwW6Mt8NGZcV9N__8zVPMGXDPAYKMcN9=Oig@mail.gmail.com

Link: https://lkml.kernel.org/r/20240410170621.2011171-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c      |   10 ++++------
 mm/userfaultfd.c |   13 ++-----------
 2 files changed, 6 insertions(+), 17 deletions(-)

--- a/mm/memory.c~mm-always-sanity-check-anon_vma-first-for-per-vma-locks
+++ a/mm/memory.c
@@ -3219,10 +3219,8 @@ vm_fault_t vmf_anon_prepare(struct vm_fa
 
 	if (likely(vma->anon_vma))
 		return 0;
-	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
-		vma_end_read(vma);
-		return VM_FAULT_RETRY;
-	}
+	/* We shouldn't try a per-vma fault at all if anon_vma isn't solid */
+	WARN_ON_ONCE(vmf->flags & FAULT_FLAG_VMA_LOCK);
 	if (__anon_vma_prepare(vma))
 		return VM_FAULT_OOM;
 	return 0;
@@ -5826,9 +5824,9 @@ retry:
 	 * find_mergeable_anon_vma uses adjacent vmas which are not locked.
 	 * This check must happen after vma_start_read(); otherwise, a
 	 * concurrent mremap() with MREMAP_DONTUNMAP could dissociate the VMA
-	 * from its anon_vma.
+	 * from its anon_vma.  This applies to both anon or private file maps.
 	 */
-	if (unlikely(vma_is_anonymous(vma) && !vma->anon_vma))
+	if (unlikely(!(vma->vm_flags & VM_SHARED) && !vma->anon_vma))
 		goto inval_end_read;
 
 	/* Check since vm_start/vm_end might change before we lock the VMA */
--- a/mm/userfaultfd.c~mm-always-sanity-check-anon_vma-first-for-per-vma-locks
+++ a/mm/userfaultfd.c
@@ -72,17 +72,8 @@ static struct vm_area_struct *lock_vma(s
 	struct vm_area_struct *vma;
 
 	vma = lock_vma_under_rcu(mm, address);
-	if (vma) {
-		/*
-		 * lock_vma_under_rcu() only checks anon_vma for private
-		 * anonymous mappings. But we need to ensure it is assigned in
-		 * private file-backed vmas as well.
-		 */
-		if (!(vma->vm_flags & VM_SHARED) && unlikely(!vma->anon_vma))
-			vma_end_read(vma);
-		else
-			return vma;
-	}
+	if (vma)
+		return vma;
 
 	mmap_read_lock(mm);
 	vma = find_vma_and_prepare_anon(mm, address);
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-allow-hugetlb-change-protection-upon-poison-entry.patch
mm-hmm-process-pud-swap-entry-without-pud_huge.patch
mm-gup-cache-p4d-in-follow_p4d_mask.patch
mm-gup-check-p4d-presence-before-going-on.patch
mm-x86-change-pxd_huge-behavior-to-exclude-swap-entries.patch
mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries.patch
mm-arm-use-macros-to-define-pmd-pud-helpers.patch
mm-arm-redefine-pmd_huge-with-pmd_leaf.patch
mm-arm64-merge-pxd_huge-and-pxd_leaf-definitions.patch
mm-powerpc-redefine-pxd_huge-with-pxd_leaf.patch
mm-gup-merge-pxd-huge-mapping-checks.patch
mm-treewide-replace-pxd_huge-with-pxd_leaf.patch
mm-treewide-remove-pxd_huge.patch
mm-arm-remove-pmd_thp_or_huge.patch
mm-document-pxd_leaf-api.patch
selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation.patch
selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation-fix.patch
mm-kconfig-config_pgtable_has_huge_leaves.patch
mm-hugetlb-declare-hugetlbfs_pagecache_present-non-static.patch
mm-make-hpage_pxd_-macros-even-if-thp.patch
mm-introduce-vma_pgtable_walk_beginend.patch
mm-arch-provide-pud_pfn-fallback.patch
mm-arch-provide-pud_pfn-fallback-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing.patch
mm-gup-refactor-record_subpages-to-find-1st-small-page.patch
mm-gup-handle-hugetlb-for-no_page_table.patch
mm-gup-cache-pudp-in-follow_pud_mask.patch
mm-gup-handle-huge-pud-for-follow_pud_mask.patch
mm-gup-handle-huge-pmd-for-follow_pmd_mask.patch
mm-gup-handle-huge-pmd-for-follow_pmd_mask-fix.patch
mm-gup-handle-hugepd-for-follow_page.patch
mm-gup-handle-hugetlb-in-the-generic-follow_page_mask-code.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages.patch

