Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0345CB0
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714956991; cv=none; b=E6bsyknLH4eMbqkwwigsBQRlGEk3nv8idk1QTtZQwnJ8Q+QqTgW8hJWSlIlsb+jURGPSOqSGQglXU8drX/emjGryVaTLk0cRy0sVvj2nF1RevJfCENXeEkbB1b+Npy/D3cxiale3KpQ/yAUkihuTrGROSmtQSpRNeaxBoxviyts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714956991; c=relaxed/simple;
	bh=h1ZKLgyVVO6Hh2GDjQ2bOseRK4aEnzjqPxR4A5qBi14=;
	h=Date:To:From:Subject:Message-Id; b=QuT/0z343zHCgXiteHl486up3wvq3yeqdXfoAlQl34rcneo55UyTjpYxXqvWW3ncCc0iP1q63Jy0bk0spdxEW2WovvRlHq6HpB/FmNktgEoiAcjjxsVVtK+yeV29Px11rFcmbibpxaPploblOuIjKC5SegUVCm10Z0WOOErs2Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1yGqTNmU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1yGqTNmU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4D2C116B1;
	Mon,  6 May 2024 00:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714956991;
	bh=h1ZKLgyVVO6Hh2GDjQ2bOseRK4aEnzjqPxR4A5qBi14=;
	h=Date:To:From:Subject:From;
	b=1yGqTNmUKXbCJy0Th67wYKm53+fkAUflcAvCusjTKmR7xPyCDfiOqdn0uYmkY2OKi
	 jysU23sh0eKtyINUEcWtmnGPJwbQpy1w6ubpfIXJD9FBtFRO4A+fsJoU6cZZ/F0mNz
	 2jE8cg7tMvtlKr2vL2K5P3Og+SymnnNVLJpQ2s+E=
Date: Sun, 05 May 2024 17:56:30 -0700
To: mm-commits@vger.kernel.org,yonghua.huang@intel.com,seanjc@google.com,pbonzini@redhat.com,mingo@redhat.com,hch@lst.de,hca@linux.ibm.com,gerald.schaefer@linux.ibm.com,fei1.li@intel.com,alex.williamson@redhat.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drivers-virt-acrn-fix-pfnmap-pte-checks-in-acrn_vm_ram_map.patch removed from -mm tree
Message-Id: <20240506005631.2D4D2C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/virt/acrn: fix PFNMAP PTE checks in acrn_vm_ram_map()
has been removed from the -mm tree.  Its filename was
     drivers-virt-acrn-fix-pfnmap-pte-checks-in-acrn_vm_ram_map.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: drivers/virt/acrn: fix PFNMAP PTE checks in acrn_vm_ram_map()
Date: Wed, 10 Apr 2024 17:55:25 +0200

Patch series "mm: follow_pte() improvements and acrn follow_pte() fixes".

Patch #1 fixes a bunch of issues I spotted in the acrn driver.  It
compiles, that's all I know.  I'll appreciate some review and testing from
acrn folks.

Patch #2+#3 improve follow_pte(), passing a VMA instead of the MM, adding
more sanity checks, and improving the documentation.  Gave it a quick test
on x86-64 using VM_PAT that ends up using follow_pte().


This patch (of 3):

We currently miss handling various cases, resulting in a dangerous
follow_pte() (previously follow_pfn()) usage.

(1) We're not checking PTE write permissions.

Maybe we should simply always require pte_write() like we do for
pin_user_pages_fast(FOLL_WRITE)? Hard to tell, so let's check for
ACRN_MEM_ACCESS_WRITE for now.

(2) We're not rejecting refcounted pages.

As we are not using MMU notifiers, messing with refcounted pages is
dangerous and can result in use-after-free. Let's make sure to reject them.

(3) We are only looking at the first PTE of a bigger range.

We only lookup a single PTE, but memmap->len may span a larger area.
Let's loop over all involved PTEs and make sure the PFN range is
actually contiguous. Reject everything else: it couldn't have worked
either way, and rather made use access PFNs we shouldn't be accessing.

Link: https://lkml.kernel.org/r/20240410155527.474777-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240410155527.474777-2-david@redhat.com
Fixes: 8a6e85f75a83 ("virt: acrn: obtain pa from VMA with PFNMAP flag")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Fei Li <fei1.li@intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Yonghua Huang <yonghua.huang@intel.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virt/acrn/mm.c |   63 +++++++++++++++++++++++++++++----------
 1 file changed, 47 insertions(+), 16 deletions(-)

--- a/drivers/virt/acrn/mm.c~drivers-virt-acrn-fix-pfnmap-pte-checks-in-acrn_vm_ram_map
+++ a/drivers/virt/acrn/mm.c
@@ -156,23 +156,29 @@ int acrn_vm_memseg_unmap(struct acrn_vm
 int acrn_vm_ram_map(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
 {
 	struct vm_memory_region_batch *regions_info;
-	int nr_pages, i = 0, order, nr_regions = 0;
+	int nr_pages, i, order, nr_regions = 0;
 	struct vm_memory_mapping *region_mapping;
 	struct vm_memory_region_op *vm_region;
 	struct page **pages = NULL, *page;
 	void *remap_vaddr;
 	int ret, pinned;
 	u64 user_vm_pa;
-	unsigned long pfn;
 	struct vm_area_struct *vma;
 
 	if (!vm || !memmap)
 		return -EINVAL;
 
+	/* Get the page number of the map region */
+	nr_pages = memmap->len >> PAGE_SHIFT;
+	if (!nr_pages)
+		return -EINVAL;
+
 	mmap_read_lock(current->mm);
 	vma = vma_lookup(current->mm, memmap->vma_base);
 	if (vma && ((vma->vm_flags & VM_PFNMAP) != 0)) {
+		unsigned long start_pfn, cur_pfn;
 		spinlock_t *ptl;
+		bool writable;
 		pte_t *ptep;
 
 		if ((memmap->vma_base + memmap->len) > vma->vm_end) {
@@ -180,25 +186,53 @@ int acrn_vm_ram_map(struct acrn_vm *vm,
 			return -EINVAL;
 		}
 
-		ret = follow_pte(vma->vm_mm, memmap->vma_base, &ptep, &ptl);
-		if (ret < 0) {
-			mmap_read_unlock(current->mm);
+		for (i = 0; i < nr_pages; i++) {
+			ret = follow_pte(vma->vm_mm,
+					 memmap->vma_base + i * PAGE_SIZE,
+					 &ptep, &ptl);
+			if (ret)
+				break;
+
+			cur_pfn = pte_pfn(ptep_get(ptep));
+			if (i == 0)
+				start_pfn = cur_pfn;
+			writable = !!pte_write(ptep_get(ptep));
+			pte_unmap_unlock(ptep, ptl);
+
+			/* Disallow write access if the PTE is not writable. */
+			if (!writable &&
+			    (memmap->attr & ACRN_MEM_ACCESS_WRITE)) {
+				ret = -EFAULT;
+				break;
+			}
+
+			/* Disallow refcounted pages. */
+			if (pfn_valid(cur_pfn) &&
+			    !PageReserved(pfn_to_page(cur_pfn))) {
+				ret = -EFAULT;
+				break;
+			}
+
+			/* Disallow non-contiguous ranges. */
+			if (cur_pfn != start_pfn + i) {
+				ret = -EINVAL;
+				break;
+			}
+		}
+		mmap_read_unlock(current->mm);
+
+		if (ret) {
 			dev_dbg(acrn_dev.this_device,
 				"Failed to lookup PFN at VMA:%pK.\n", (void *)memmap->vma_base);
 			return ret;
 		}
-		pfn = pte_pfn(ptep_get(ptep));
-		pte_unmap_unlock(ptep, ptl);
-		mmap_read_unlock(current->mm);
 
 		return acrn_mm_region_add(vm, memmap->user_vm_pa,
-			 PFN_PHYS(pfn), memmap->len,
+			 PFN_PHYS(start_pfn), memmap->len,
 			 ACRN_MEM_TYPE_WB, memmap->attr);
 	}
 	mmap_read_unlock(current->mm);
 
-	/* Get the page number of the map region */
-	nr_pages = memmap->len >> PAGE_SHIFT;
 	pages = vzalloc(array_size(nr_pages, sizeof(*pages)));
 	if (!pages)
 		return -ENOMEM;
@@ -242,12 +276,11 @@ int acrn_vm_ram_map(struct acrn_vm *vm,
 	mutex_unlock(&vm->regions_mapping_lock);
 
 	/* Calculate count of vm_memory_region_op */
-	while (i < nr_pages) {
+	for (i = 0; i < nr_pages; i += 1 << order) {
 		page = pages[i];
 		VM_BUG_ON_PAGE(PageTail(page), page);
 		order = compound_order(page);
 		nr_regions++;
-		i += 1 << order;
 	}
 
 	/* Prepare the vm_memory_region_batch */
@@ -264,8 +297,7 @@ int acrn_vm_ram_map(struct acrn_vm *vm,
 	regions_info->vmid = vm->vmid;
 	regions_info->regions_gpa = virt_to_phys(vm_region);
 	user_vm_pa = memmap->user_vm_pa;
-	i = 0;
-	while (i < nr_pages) {
+	for (i = 0; i < nr_pages; i += 1 << order) {
 		u32 region_size;
 
 		page = pages[i];
@@ -281,7 +313,6 @@ int acrn_vm_ram_map(struct acrn_vm *vm,
 
 		vm_region++;
 		user_vm_pa += region_size;
-		i += 1 << order;
 	}
 
 	/* Inform the ACRN Hypervisor to set up EPT mappings */
_

Patches currently in -mm which might be from david@redhat.com are


