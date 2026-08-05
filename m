Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71F83BED23
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896646; cv=none; b=q4xpN1PpjjY/YJrh22xHxmPA9jNwpFSWyIkMdCIjMMCWwdL8o7mq3sZyF84tJQQaQ7QgJ5JIQQjTTFeHMPFElsOPBfhjYPHULVIuPDtfKybgqgk5q8BoRF39T7ShBwmLXrriSPEra29Vx+Q7n3OGPlhLV5/UBCwmYNWUENkN4t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896646; c=relaxed/simple;
	bh=Z8Oz54iMgyxlTS+WjnueZATlVyDAKawa7LHuOY7/3JY=;
	h=Date:To:From:Subject:Message-Id; b=uSJAEmxS6eVf5qCQ7bR2UNgvUQXUvFzuf1Rd+ux7YDuzNHQ8qc353BmW/0drYkYP0aoETiRZgQZXbKHA43c2pgLUEJmYOuT08Li5pPCfplRKnBE3iqMSiiuKzETH7WB8njw/SsH0U01bT74CnvbTjszWK04GMpdxGZG5tybQJPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hinGsXdU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hinGsXdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BE91F00A3A;
	Wed,  5 Aug 2026 02:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896644;
	bh=b8myD367R0fkzPiGfU5GhB+oW8FYMZO3TBBRznXIzv0=;
	h=Date:To:From:Subject;
	b=hinGsXdUU1C4kUmAnawdrq0xbFDU2avYMD3Z6EDjEeRQdM0+X2Gn1saOuvVo6kbgt
	 xfGBu8Hs+8n4N+TBdXX6pXG+ZNXjBuNbJsbLbFkyQtK6Ibdd9z0UVuptssN/fyuH+1
	 a5uNONyOY3WB9DzICkwbBnZLHHyvqf4Da8ZoKADA=
Date: Tue, 04 Aug 2026 19:24:04 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,geert@linux-m68k.org,thehajime@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-nommu-fix-the-error-path-when-vma_iter_prealloc-fails.patch removed from -mm tree
Message-Id: <20260805022404.A0BE91F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: nommu: fix the error path when vma_iter_prealloc() fails
has been removed from the -mm tree.  Its filename was
     mm-nommu-fix-the-error-path-when-vma_iter_prealloc-fails.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/20260708083829.576036-1-thehajime@gmail.com
Link: https://sashiko.dev/#/patchset/20260702012830.667205-1-thehajime%40gmail.com
Link: https://sashiko.dev/#/patchset/c8513ee5aa8444ec9bf6c276043c9f833016a2fa.1783304131.git.thehajime%40gmail.com
Link: https://sashiko.dev/#/patchset/20260707235137.498738-1-thehajime%40gmail.com
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

mm-nommu-point-to-the-write-iterator-upon-split_vma.patch

