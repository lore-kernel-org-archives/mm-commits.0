Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91A337DAA9
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 03:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783568508; cv=none; b=UGdWU//lrOo10HTAuTPSsfCChGqeykJQT1//QYNOujIVkE8IbwkiA9mMKhrEgSujE48qzGMSUhShMF3KAzirW9ksxzoUr9NNAgFcbyQGlmlSMQPMlDJDypcjmT+1vwl5IXu0rRT4M7U5430QW6RsTP7grtULnPYS4BYqRUbULtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783568508; c=relaxed/simple;
	bh=5mO0NzvcqXNMU8c2JVqnlp2LDrZOVX/4ZDnzJ0QxXs8=;
	h=Date:To:From:Subject:Message-Id; b=uo7AWIFeyv1XkcKfhK17bcJkx5h6nEgl5QVOzNfasWw27hygzYUf6A1zO5BwdzhNJBsvEOQUU8U/42hT8hvW+hBYtuWB7PFaeuvB3dOvHzpreniUqZC3GtdP7D3nwnKp7yM/Tu84iBrbwteBSGuLwhWNTWA1vlfKgHz1qgmrPBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0U7jd/F4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0U7jd/F4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788DA1F000E9;
	Thu,  9 Jul 2026 03:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783568506;
	bh=4PCQw7XbShkYd3VHLuRiXOlmVIJ13dWVkPZ8aFzRFt0=;
	h=Date:To:From:Subject;
	b=0U7jd/F4BF791mTmOMdKSHeDOMroDPdB8pi6XKYP0hbTAqvCKqz+TOwW16qtrFvnn
	 2ooyBGco6MVoVv8ypQ/IxjJd1QRgLIwLTMuXL62B1B0+5ZRxY7xtJuak2vw03/xLmQ
	 WaJKarQRVIJ3UBbNjqF/TURPpAvVEoiz4WaiHkAg=
Date: Wed, 08 Jul 2026 20:41:46 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,geert@linux-m68k.org,thehajime@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-nommu-fix-the-error-path-when-vma_iter_prealloc-fails.patch added to mm-new branch
Message-Id: <20260709034146.788DA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: nommu: fix the error path when vma_iter_prealloc() fails
has been added to the -mm mm-new branch.  Its filename is
     mm-nommu-fix-the-error-path-when-vma_iter_prealloc-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-nommu-fix-the-error-path-when-vma_iter_prealloc-fails.patch

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
From: Hajime Tazaki <thehajime@gmail.com>
Subject: mm: nommu: fix the error path when vma_iter_prealloc() fails
Date: Wed, 8 Jul 2026 17:38:29 +0900

When vma_iter_prealloc() fails in do_mmap(), it jumps to error_just_free
as a error path of this function, but there are several possible issues.

1) It jumps to error_just_free without updating ret to -ENOMEM, meaning
   do_mmap() will return 0 on failure.

2) The error path unconditionally frees the region struct.  Since the
   region was already added to the global nommu_region_tree via
   add_nommu_region(), leaving it makes a potential dangling pointer in
   the tree and may cause a use-after-free on the next tree walk.

3) If do_mmap() finds an existing overlapping shared region, it
   increments its usage, sets region to this existing pregion, and jumps
   to share:

	region = pregion;
	result = start;
	goto share;

   When vma_iter_prealloc() fails and jumps to error_just_free, the
   error path unconditionally frees the region:

error:
	...
	if (region->vm_file)
		fput(region->vm_file);
	kmem_cache_free(vm_region_jar, region);

   This potentially leaves a dangling pointer in nommu_region_tree and
   causes RB-tree corruption.

4) When establishing a new private mapping, do_mmap_private() allocates
   physical pages and assigns them to region->vm_start:

	base = alloc_pages_exact(total << PAGE_SHIFT, GFP_KERNEL);
	...
	region->vm_start = (unsigned long) base;

   If we later fail at vma_iter_prealloc() and jump to error_just_free,
   the region struct is freed, but the backing physical memory isn't freed
   via free_page_series().

5) In the error label of do_mmap(), the vm_area_struct allocated is
   freed by vm_area_free(vma) but not called after vma_close(), leaving
   potential memory leak which should be handled by a custom .close
   handler of vm_ops.

This commit fixes those issues by introducing new jump label,
error_vma_iter_prealloc, to correctly handle the error case of
vma_iter_prealloc(), updating ret value (1), and move the region updates
after the place that the allocation is finished (2).

Additionally, the commit removes the existing goto label, error, and
consolidates to error_just_free as existing `goto error;` code blocks
always release nommu_region_sem.

Moreover, it only frees region allocated in this request to avoid
freeing the shared, existing region shared by other processes (3), and
free physical memory when do_mmap_private() allocates (4). It also add
vma_close() before vm_area_free() to fix the potential leak (5).

Those issues are discovered by Sashiko, linked below.

Link: https://sashiko.dev/#/patchset/20260702012830.667205-1-thehajime%40gmail.com
Link: https://sashiko.dev/#/patchset/c8513ee5aa8444ec9bf6c276043c9f833016a2fa.1783304131.git.thehajime%40gmail.com
Link: https://sashiko.dev/#/patchset/20260707235137.498738-1-thehajime%40gmail.com
Link: https://lore.kernel.org/20260708083829.576036-1-thehajime@gmail.com
Fixes: b5df09226450 ("mm: set up vma iterator for vma_iter_prealloc() calls")
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |   36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

--- a/mm/nommu.c~mm-nommu-fix-the-error-path-when-vma_iter_prealloc-fails
+++ a/mm/nommu.c
@@ -1181,7 +1181,6 @@ unsigned long do_mmap(struct file *file,
 		ret = do_mmap_private(vma, region, len, capabilities);
 	if (ret < 0)
 		goto error_just_free;
-	add_nommu_region(region);
 
 	/* clear anonymous mappings that don't ask for uninitialized data */
 	if (!vma->vm_file &&
@@ -1199,7 +1198,9 @@ share:
 	BUG_ON(!vma->vm_region);
 	vma_iter_config(&vmi, vma->vm_start, vma->vm_end);
 	if (vma_iter_prealloc(&vmi, vma))
-		goto error_just_free;
+		goto error_vma_iter_prealloc;
+
+	add_nommu_region(region);
 
 	setup_vma_to_mm(vma, current->mm);
 	current->mm->map_count++;
@@ -1218,22 +1219,41 @@ share:
 	return result;
 
 error_just_free:
+	vma_close(vma);
+	/* if the error was from shared mapping/existing region, don't free the region.
+	 * this has to be before releasing semaphore.
+	 */
+	if (region->vm_usage == 1) {
+		if (region->vm_file)
+			fput(region->vm_file);
+		kmem_cache_free(vm_region_jar, region);
+
+	} else
+		region->vm_usage--;
+
 	up_write(&nommu_region_sem);
-error:
 	vma_iter_free(&vmi);
-	if (region->vm_file)
-		fput(region->vm_file);
-	kmem_cache_free(vm_region_jar, region);
+
 	if (vma->vm_file)
 		fput(vma->vm_file);
 	vm_area_free(vma);
 	return ret;
 
 sharing_violation:
-	up_write(&nommu_region_sem);
 	pr_warn("Attempt to share mismatched mappings\n");
 	ret = -EINVAL;
-	goto error;
+	goto error_just_free;
+
+error_vma_iter_prealloc:
+	pr_warn("Allocation of vma iterator for process %d failed\n", current->pid);
+	show_mem();
+	ret = -ENOMEM;
+
+	/* in case that the region is allocated via do_mmap_private() */
+	if ((region->vm_usage == 1) && (region->vm_flags & VM_MAPPED_COPY))
+		free_page_series(region->vm_start, region->vm_top);
+
+	goto error_just_free;
 
 error_getting_vma:
 	kmem_cache_free(vm_region_jar, region);
_

Patches currently in -mm which might be from thehajime@gmail.com are

mm-nommu-add-sysctl_max_map_count-check-for-do_mmap.patch
mm-nommu-point-to-the-write-iterator-upon-split_vma.patch
mm-nommu-fix-the-error-path-when-vma_iter_prealloc-fails.patch

