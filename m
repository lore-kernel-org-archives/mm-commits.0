Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9B846430
	for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2024 20:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711397731; cv=none; b=QR6zmkVLfu4co70RO0Ht5y7wajOexNx3njL0ykkHAE+HznyLxgkh2zklFT7T0v+/2XtdkStjVjWQE3RkFppscIRB5HcHBMqGdcnI1k4o2x3byCV0EW2ua8UEd0267Ws74d1JbBCxcNIA6u/vyu+al5R9tg2GgU+27/YteiHkuUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711397731; c=relaxed/simple;
	bh=v4AJFJ4dX6ycyI2O0Eovf5D6GyvvqRO2bRcBY04Wsis=;
	h=Date:To:From:Subject:Message-Id; b=ayWSx4MJbPpIoBsQS7VYFPRRqcX+WkXNVzZf7anBjX/S0kAzAbU+z1H36HEHnWEuQY3n1ZIQNhGeEKxZgqdLd4icD3e+sAyGRKtcX8CZpllBwPi/yiyWXn3eTjUls4op1BGAgGuIjwyXZYrsSGe7i8IFLuvWilbgpgLucBhVkD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dakx6yZM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dakx6yZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7326DC433F1;
	Mon, 25 Mar 2024 20:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711397730;
	bh=v4AJFJ4dX6ycyI2O0Eovf5D6GyvvqRO2bRcBY04Wsis=;
	h=Date:To:From:Subject:From;
	b=dakx6yZMENYBAfTruXe8lZ/lsb7+yIRO+WsdZ4IAcP74aV+acLJrvDvY3IJu5+3+R
	 B+/I1794dXpkUj86dNLZEKv8M7z2Yza9YUVB/MvsbWXJzwmCOsr3tFeMWYiXHtxeeU
	 p1hd1mE/qaDbGH0H6w+DEISMYEjDeQ5v8DpeTmm0=
Date: Mon, 25 Mar 2024 13:15:29 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,mingo@kernel.org,luto@kernel.org,fei1.li@intel.com,david@redhat.com,dave.hansen@linux.intel.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + virt-acrn-stop-using-follow_pfn.patch added to mm-unstable branch
Message-Id: <20240325201530.7326DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: virt: acrn: stop using follow_pfn
has been added to the -mm mm-unstable branch.  Its filename is
     virt-acrn-stop-using-follow_pfn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/virt-acrn-stop-using-follow_pfn.patch

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

virt-acrn-stop-using-follow_pfn.patch
mm-remove-follow_pfn.patch
mm-move-follow_phys-to-arch-x86-mm-pat-memtypec.patch

