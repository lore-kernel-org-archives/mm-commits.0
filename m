Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28596328631
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 18:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779214092; cv=none; b=BF4x6dz1M1sYDFNDvu/D4RyQBmo5ptHJ7RUtc9c+bHAUykW8KFuBey0fdrQ+ZCZnhWzbk6zOzxgFQ5Xr3lidkTYBKUwUcqObg04SE0UpRisJQsMGJBu0aaD8L4LU4RW+/i9orMk2FSiYQazxQ/bNCzqmpDWVAPzYibolpkvjiFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779214092; c=relaxed/simple;
	bh=uZHrEqcd1Z4V3YKR+5SAMCrg3AsxSYxImG5XG1TtP8g=;
	h=Date:To:From:Subject:Message-Id; b=er7K/zwA250E3yLsAbVsVVK1Z4ZmbcaCB0m7ElgrCbgYGGhOuWezJGWjs9pw7c4zlo3mQRX4hJAsEkKHP5gVLVPjpbiDyE2Sc7csKgenMkHg4qI4URdcCeYUqlc+XvnRHWNleQg8P6t2wXPx810wa0i6JY60WXRTVcQMr4535EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wBkRMe4J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wBkRMe4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE199C2BCB3;
	Tue, 19 May 2026 18:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779214091;
	bh=uZHrEqcd1Z4V3YKR+5SAMCrg3AsxSYxImG5XG1TtP8g=;
	h=Date:To:From:Subject:From;
	b=wBkRMe4JXFd3CVWUcr3Fym9lv6tVyqjKpP2j+6YrcXBGBfys1pxCzCgZna7sGIudx
	 fJfCzc4Eu8LtLXvJY7z7VtmTr9dlBZ91yE/AtM2Aow2oe6s/fMfos65Qoc3rKsm28q
	 G0VxAWcgr1bBY4vo2pa7X6CuD6yVXENMUbm8yL8k=
Date: Tue, 19 May 2026 11:08:11 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,dakr@kernel.org,aliceryhl@google.com,shivamkalra98@zohomail.in,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-free-unused-pages-on-vrealloc-shrink.patch added to mm-new branch
Message-Id: <20260519180811.AE199C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: free unused pages on vrealloc() shrink
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-free-unused-pages-on-vrealloc-shrink.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-free-unused-pages-on-vrealloc-shrink.patch

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
Subject: mm/vmalloc: free unused pages on vrealloc() shrink
Date: Tue, 19 May 2026 17:42:17 +0530

When vrealloc() shrinks an allocation and the new size crosses a page
boundary, unmap and free the tail pages that are no longer needed.  This
reclaims physical memory that was previously wasted for the lifetime of
the allocation.

The heuristic is simple: always free when at least one full page becomes
unused.  Huge page allocations (page_order > 0) are skipped, as partial
freeing would require splitting.  Allocations with VM_FLUSH_RESET_PERMS
are also skipped, as their direct-map permissions must be reset before
pages are returned to the page allocator, which is handled by
vm_reset_perms() during vfree().

Additionally, allocations with VM_USERMAP are skipped because
remap_vmalloc_range_partial() validates mapping requests against the
unchanged vm->size; freeing tail pages would cause vmalloc_to_page() to
return NULL for the unmapped range.

To protect concurrent readers, the shrink path uses Node lock to
synchronize before freeing the pages.

Finally, we notify kmemleak of the reduced allocation size using
kmemleak_free_part() to prevent the kmemleak scanner from faulting on the
newly unmapped virtual addresses.

The virtual address reservation (vm->size / vmap_area) is intentionally
kept unchanged, preserving the address for potential future grow-in-place
support.

Link: https://lore.kernel.org/20260519-vmalloc-shrink-v14-4-70b96ee3e9c9@zohomail.in
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
Suggested-by: Danilo Krummrich <dakr@kernel.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   56 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 52 insertions(+), 4 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-free-unused-pages-on-vrealloc-shrink
+++ a/mm/vmalloc.c
@@ -4351,14 +4351,62 @@ void *vrealloc_node_align_noprof(const v
 		goto need_realloc;
 	}
 
-	/*
-	 * TODO: Shrink the vm_area, i.e. unmap and free unused pages. What
-	 * would be a good heuristic for when to shrink the vm_area?
-	 */
 	if (size <= old_size) {
+		unsigned int new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
+
 		/* Zero out "freed" memory, potentially for future realloc. */
 		if (want_init_on_free() || want_init_on_alloc(flags))
 			memset((void *)p + size, 0, old_size - size);
+
+		/*
+		 * Free tail pages when shrink crosses a page boundary.
+		 *
+		 * Skip huge page allocations (page_order > 0) as partial
+		 * freeing would require splitting.
+		 *
+		 * Skip VM_FLUSH_RESET_PERMS, as direct-map permissions must
+		 * be reset before pages are returned to the allocator.
+		 *
+		 * Skip VM_USERMAP, as remap_vmalloc_range_partial() validates
+		 * mapping requests against the unchanged vm->size; freeing
+		 * tail pages would cause vmalloc_to_page() to return NULL for
+		 * the unmapped range.
+		 *
+		 * Skip if either GFP_NOFS or GFP_NOIO are used.
+		 * kmemleak_free_part() internally allocates with
+		 * GFP_KERNEL, which could trigger a recursive deadlock
+		 * if we are under filesystem or I/O reclaim.
+		 */
+		if (new_nr_pages < vm->nr_pages && !vm_area_page_order(vm) &&
+		    !(vm->flags & (VM_FLUSH_RESET_PERMS | VM_USERMAP)) &&
+		    gfp_has_io_fs(flags)) {
+			unsigned long addr = (unsigned long)kasan_reset_tag(p);
+			unsigned int old_nr_pages = vm->nr_pages;
+
+			/*
+			 * Use the node lock to synchronize with concurrent
+			 * readers (vmalloc_info_show).
+			 */
+			struct vmap_node *vn = addr_to_node(addr);
+
+			spin_lock(&vn->busy.lock);
+			vm->nr_pages = new_nr_pages;
+			spin_unlock(&vn->busy.lock);
+
+			/* Notify kmemleak of the reduced allocation size before unmapping. */
+			kmemleak_free_part(
+				(void *)addr + ((unsigned long)new_nr_pages
+						<< PAGE_SHIFT),
+				(unsigned long)(old_nr_pages - new_nr_pages)
+					<< PAGE_SHIFT);
+
+			vunmap_range(addr + ((unsigned long)new_nr_pages
+					     << PAGE_SHIFT),
+				     addr + ((unsigned long)old_nr_pages
+					     << PAGE_SHIFT));
+
+			vm_area_free_pages(vm, new_nr_pages, old_nr_pages);
+		}
 		vm->requested_size = size;
 		kasan_vrealloc(p, old_size, size);
 		return (void *)p;
_

Patches currently in -mm which might be from shivamkalra98@zohomail.in are

mm-vmalloc-extract-vm_area_free_pages-helper-from-vfree.patch
mm-vmalloc-use-physical-page-count-for-vrealloc-grow-in-place-check.patch
mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas.patch
mm-vmalloc-free-unused-pages-on-vrealloc-shrink.patch
lib-test_vmalloc-add-vrealloc-test-case.patch

