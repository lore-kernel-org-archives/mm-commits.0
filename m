Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F366031E825
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 18:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779214090; cv=none; b=Q1x7FRo7lRVvFznzQccFvlljP/OfHMHs3kU3rkSiWlOuiq+IJf6qSyjv/Pwjg7D8Rhn5MJf0P2oaOWXVL18IvPVNDNBeEsvhytPieb6Huf4fKxPdfLoDo5uWPdxoovpkNYMYcfzoxEaQJ7J5fnFi0UtVh3cLwF8/K/ox6wyNSbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779214090; c=relaxed/simple;
	bh=IjJUUBChdvh0SyHfy1akKRfRLbZJXHi39aJ7iyITKck=;
	h=Date:To:From:Subject:Message-Id; b=V3jaBAOsP+Ze7OtsFwJuAT4O+DiEIVgHRev6hnoOCWK+M+jYN1dZX3b0y98EtAey2FBzN9qi4NdjkF55xsL3M9ppdQU+l6vcZ5PpHUG2FZdCwjGKVocK6USGkuMuhHFiVvi1I72dYx+HN/JKG4+251v9pqF7jkdNF5OM2sBxf2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J7tgY+vf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J7tgY+vf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE00C2BCB3;
	Tue, 19 May 2026 18:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779214089;
	bh=IjJUUBChdvh0SyHfy1akKRfRLbZJXHi39aJ7iyITKck=;
	h=Date:To:From:Subject:From;
	b=J7tgY+vfHP3Q31QGSSXoVt6W+JsS9neLFN0mzRFA767WciUNZvOqGWNLzNXey+FGG
	 WxjUkIaQg1sFXKWUoPWeNKixZVHYDMyl5+IuzlO/EUU0QCWLwaq7Y9vfHmyyziMIds
	 N2Xlf9NOKPqLbdIrPGLFC4kgA40iZjfMc29Q/GFs=
Date: Tue, 19 May 2026 11:08:09 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,dakr@kernel.org,aliceryhl@google.com,shivamkalra98@zohomail.in,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas.patch added to mm-new branch
Message-Id: <20260519180809.7EE00C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: use physical page count in vread_iter() for VM_ALLOC areas
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Shivam Kalra <shivamkalra98@zohomail.in>
Subject: mm/vmalloc: use physical page count in vread_iter() for VM_ALLOC areas
Date: Tue, 19 May 2026 17:42:16 +0530

For VM_ALLOC areas in vread_iter(), derive the vm area size from
vm->nr_pages rather than get_vm_area_size().

Only VM_ALLOC areas are subject to vrealloc() shrinking, which frees pages
without reducing the virtual reservation size.  Switch to using
vm->nr_pages for VM_ALLOC areas so the reader remains correct once shrink
support is added.  Other mapping types (vmap, ioremap) do not initialize
nr_pages and will continue using get_vm_area_size().

Link: https://lore.kernel.org/20260519-vmalloc-shrink-v14-3-70b96ee3e9c9@zohomail.in
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas
+++ a/mm/vmalloc.c
@@ -4666,7 +4666,18 @@ long vread_iter(struct iov_iter *iter, c
 		smp_rmb();
 
 		vaddr = (char *) va->va_start;
-		size = vm ? get_vm_area_size(vm) : va_size(va);
+		if (vm)
+			/*
+			 * For VM_ALLOC areas, use nr_pages rather than
+			 * get_vm_area_size() because vrealloc() may shrink
+			 * the mapping without updating area->size. Other
+			 * mapping types (vmap, ioremap) don't set nr_pages.
+			 */
+			size = (vm->flags & VM_ALLOC) ?
+				       (vm->nr_pages << PAGE_SHIFT) :
+				       get_vm_area_size(vm);
+		else
+			size = va_size(va);
 
 		if (addr >= vaddr + size)
 			goto next_va;
_

Patches currently in -mm which might be from shivamkalra98@zohomail.in are

mm-vmalloc-extract-vm_area_free_pages-helper-from-vfree.patch
mm-vmalloc-use-physical-page-count-for-vrealloc-grow-in-place-check.patch
mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas.patch
mm-vmalloc-free-unused-pages-on-vrealloc-shrink.patch
lib-test_vmalloc-add-vrealloc-test-case.patch

