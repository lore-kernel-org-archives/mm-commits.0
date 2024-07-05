Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CA2C15B
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141653; cv=none; b=ItBneaTweBinH+HOl+yV+3IgVloIVX3Qgj49VP56MtOrFIWi/6n1lFKbedEIWEnoeNrGGDV6h0IYml7YHuKQymcYWfcUQkYV0nDTHolB6+hSlnf6ZsiSdTQqRtieqzZ/XXs8byx9fd3gDIMEDplNy4N3jt7C+pI/BXvM9kPr9jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141653; c=relaxed/simple;
	bh=/1uMpbygKPUle58tHWNoWaE7VfVxrb8+VBhF07B6UBo=;
	h=Date:To:From:Subject:Message-Id; b=az1b3hI9azcqidPOwZcS9TwDc0yD9qiQNe+6JWxeXVF996+0sqY2pTOLuPaNildzl7Lpj5xU3x2e7BPP9EIPW98IIwyjmicnGRnfLh5IVUKQLpfHEcNbDptQsYuVdnbwMCD6PtCD+EX7jFao8gnsM4FxEfBbHXUdLnbYkWqzRrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a1ENdyuv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a1ENdyuv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06DAC3277B;
	Fri,  5 Jul 2024 01:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141653;
	bh=/1uMpbygKPUle58tHWNoWaE7VfVxrb8+VBhF07B6UBo=;
	h=Date:To:From:Subject:From;
	b=a1ENdyuvM4O+a5XIk5eDe4c3U2YXcLcqBnwvY2yVSAnUUAdZtXCcV9axINcRFivfc
	 JnIYqetEzM+ZitE7qLpV4jMyvuuXVAOG1b6jzxeMdTohB1lqm60ou6CRjTC/cI6Mx0
	 E5rZPnYPADerT5LH3KrRbF5hXyClfZ2+g7X/Szjs=
Date: Thu, 04 Jul 2024 18:07:32 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shuah@kernel.org,peterx@redhat.com,osalvador@suse.de,mike.kravetz@oracle.com,kraxel@redhat.com,junxiao.chang@intel.com,jgg@nvidia.com,hughd@google.com,hch@lst.de,hch@infradead.org,dongwon.kim@intel.com,david@redhat.com,daniel.vetter@ffwll.ch,arnd@arndb.de,airlied@redhat.com,vivek.kasireddy@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] udmabuf-use-vmf_insert_pfn-and-vm_pfnmap-for-handling-mmap.patch removed from -mm tree
Message-Id: <20240705010732.E06DAC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: udmabuf: use vmf_insert_pfn and VM_PFNMAP for handling mmap
has been removed from the -mm tree.  Its filename was
     udmabuf-use-vmf_insert_pfn-and-vm_pfnmap-for-handling-mmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: udmabuf: use vmf_insert_pfn and VM_PFNMAP for handling mmap
Date: Sun, 23 Jun 2024 23:36:13 -0700

Add VM_PFNMAP to vm_flags in the mmap handler to ensure that the mappings
would be managed without using struct page.

And, in the vm_fault handler, use vmf_insert_pfn to share the page's pfn
to userspace instead of directly sharing the page (via struct page *).

Link: https://lkml.kernel.org/r/20240624063952.1572359-6-vivek.kasireddy@intel.com
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Dave Airlie <airlied@redhat.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Dongwon Kim <dongwon.kim@intel.com>
Cc: Junxiao Chang <junxiao.chang@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma-buf/udmabuf.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/dma-buf/udmabuf.c~udmabuf-use-vmf_insert_pfn-and-vm_pfnmap-for-handling-mmap
+++ a/drivers/dma-buf/udmabuf.c
@@ -35,12 +35,13 @@ static vm_fault_t udmabuf_vm_fault(struc
 	struct vm_area_struct *vma = vmf->vma;
 	struct udmabuf *ubuf = vma->vm_private_data;
 	pgoff_t pgoff = vmf->pgoff;
+	unsigned long pfn;
 
 	if (pgoff >= ubuf->pagecount)
 		return VM_FAULT_SIGBUS;
-	vmf->page = ubuf->pages[pgoff];
-	get_page(vmf->page);
-	return 0;
+
+	pfn = page_to_pfn(ubuf->pages[pgoff]);
+	return vmf_insert_pfn(vma, vmf->address, pfn);
 }
 
 static const struct vm_operations_struct udmabuf_vm_ops = {
@@ -56,6 +57,7 @@ static int mmap_udmabuf(struct dma_buf *
 
 	vma->vm_ops = &udmabuf_vm_ops;
 	vma->vm_private_data = ubuf;
+	vm_flags_set(vma, VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
 	return 0;
 }
 
_

Patches currently in -mm which might be from vivek.kasireddy@intel.com are


