Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111397604D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104007; cv=none; b=D8zYVUTAc232exLJ6lxsMmfOPnnPIcF6dN4EkFtUP86UTwrWtoDdSFCHY1rbK6+U/UHEIpHTZK25iFqaYbmmU4zdEb9E4HPrZrCKs5AzKZ8y/1z5pzvepg3+pCG8LnDYhxtWjx077hlZGQtgZ6KUz82MgHV0PKL0v+bAXFV5R/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104007; c=relaxed/simple;
	bh=2g/kGiIEchL5tDcDM7b9yGCSTFTETocCBaXuBCiroC0=;
	h=Date:To:From:Subject:Message-Id; b=BeLUczKs0uhF71MqO46KK4rwzihp1OswP2GBzD+VxQw/IH8AHB1MNyB/Z95KTzLv2SCNsZum/kPmi1ZWV9L6FFZ59AGaHKSLRsj5zF5TOPl+OZZ0RbGlfrnbZXtLVMRpG6W8xuQTC8nLZJlqPTIMT5vM3ZOyf3wkOEEG/SV9oT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WAp+TQ50; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WAp+TQ50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA7DC113CD;
	Fri, 26 Apr 2024 04:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104006;
	bh=2g/kGiIEchL5tDcDM7b9yGCSTFTETocCBaXuBCiroC0=;
	h=Date:To:From:Subject:From;
	b=WAp+TQ50XSZDnzMaX/pqXrJzwWCkDdV8yPBqlIJuOEGtLZxgCvA0bbBjh5p3uMWnD
	 VEkI+xk7TTiiFIuB6ZPJSlHVXwlbQ/h2O4/yEHShnspid7COTWOjmvrQYNadmPFEFV
	 XXWObmyPyt27jJGBhi4xnZNpQCIDxpvY0gj9UhcE=
Date: Thu, 25 Apr 2024 21:00:06 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,mingo@kernel.org,luto@kernel.org,fei1.li@intel.com,david@redhat.com,dave.hansen@linux.intel.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] virt-acrn-stop-using-follow_pfn.patch removed from -mm tree
Message-Id: <20240426040006.CDA7DC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: virt: acrn: stop using follow_pfn
has been removed from the -mm tree.  Its filename was
     virt-acrn-stop-using-follow_pfn.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: virt: acrn: stop using follow_pfn
Date: Mon, 25 Mar 2024 07:45:40 +0800

Patch series "remove follow_pfn".

This series open codes follow_pfn in the only remaining caller, although
the code there remains questionable.  It then also moves follow_phys into
the only user and simplifies it a bit.


This patch (of 3):

Switch from follow_pfn to follow_pte so that we can get rid of follow_pfn.
Note that this doesn't fix any of the pre-existing raciness and lack of
permission checking in the code.

Link: https://lkml.kernel.org/r/20240324234542.2038726-1-hch@lst.de
Link: https://lkml.kernel.org/r/20240324234542.2038726-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Fei Li <fei1.li@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virt/acrn/mm.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/virt/acrn/mm.c~virt-acrn-stop-using-follow_pfn
+++ a/drivers/virt/acrn/mm.c
@@ -172,18 +172,24 @@ int acrn_vm_ram_map(struct acrn_vm *vm,
 	mmap_read_lock(current->mm);
 	vma = vma_lookup(current->mm, memmap->vma_base);
 	if (vma && ((vma->vm_flags & VM_PFNMAP) != 0)) {
+		spinlock_t *ptl;
+		pte_t *ptep;
+
 		if ((memmap->vma_base + memmap->len) > vma->vm_end) {
 			mmap_read_unlock(current->mm);
 			return -EINVAL;
 		}
 
-		ret = follow_pfn(vma, memmap->vma_base, &pfn);
-		mmap_read_unlock(current->mm);
+		ret = follow_pte(vma->vm_mm, memmap->vma_base, &ptep, &ptl);
 		if (ret < 0) {
+			mmap_read_unlock(current->mm);
 			dev_dbg(acrn_dev.this_device,
 				"Failed to lookup PFN at VMA:%pK.\n", (void *)memmap->vma_base);
 			return ret;
 		}
+		pfn = pte_pfn(ptep_get(ptep));
+		pte_unmap_unlock(ptep, ptl);
+		mmap_read_unlock(current->mm);
 
 		return acrn_mm_region_add(vm, memmap->user_vm_pa,
 			 PFN_PHYS(pfn), memmap->len,
_

Patches currently in -mm which might be from hch@lst.de are


