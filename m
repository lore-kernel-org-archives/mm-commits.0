Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE1D3C0A1F
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439124; cv=none; b=SDs6PhHAkUrOvrPDbf1d/swXG0v1HSjpMiP6oG2swaCPQt+ME3mQL8rRLsFt9SYCvhRxDxDSNq/qcppH8wjWG3446qrxR2OIJMAlRQLWKI226sx6+PM6oby9Mcqbhgy/wnSzMGXLC7ikJlkg4z7y+KH7o2aQudmbWHB1eq8jziM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439124; c=relaxed/simple;
	bh=ctGXQomcXY8dO78YbDKnaESoH5pnDrf+7RoO9gQsUEI=;
	h=Date:To:From:Subject:Message-Id; b=LLgaY22j/M+VFSK+9MfwCSlfKSQ3uSgyMG0Mt0Cyt8rErNUIg4xsfN5wkekOxSfSZMTYE1sEA5m79m37B6kX/owvGPmTyuZklwpYnsveg8gtYe78dY/qWqKGKh6sMj/W/IqB1XBvylx5h9igPfmzgFtbiNQbzv91pYJP7p5l8wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gFnFuT1S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gFnFuT1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946721F00898;
	Tue,  2 Jun 2026 22:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439123;
	bh=ddTEZIsBHWbpy0lsFk/p3tiZ3WypICcnup1wN3hvJYk=;
	h=Date:To:From:Subject;
	b=gFnFuT1S2V4gu6DHQTkdfGs1C2p2u9Ov5hXGzg8gd+9qXpLiWz/8qnZMYwhnaBMZa
	 QZYo8ro4MPDECLALKuDOD5yFTDiB5KI8niK8lnV4pW1ZEJXe+2DahqAfzMTh+gyMPJ
	 xX9CHjvU7c1fNDmGNQ+sJ9AlNMgHT46JVm0E/CKY=
Date: Tue, 02 Jun 2026 15:25:23 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,dakr@kernel.org,aliceryhl@google.com,shivamkalra98@zohomail.in,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-free-unused-pages-on-vrealloc-shrink.patch removed from -mm tree
Message-Id: <20260602222523.946721F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: free unused pages on vrealloc() shrink
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-free-unused-pages-on-vrealloc-shrink.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


