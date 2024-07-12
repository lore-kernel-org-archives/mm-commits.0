Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4A81CF96
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824841; cv=none; b=pI//ToxXgHgSelmN8cklRy/Wd0Z6O2ZDZba+zjiOUoGq3dKFS5dt41IW44DfwUMh2wv7nWy6/vnW6wnm13A23Vu0GmguJG9XsqAPFu/+tJvDlZCDbvVGUKdbZX/T9TyG5EJ22RuBR8/y8z4y/vME+U2LMuq/QP39dja5hWuC2rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824841; c=relaxed/simple;
	bh=/1uMpbygKPUle58tHWNoWaE7VfVxrb8+VBhF07B6UBo=;
	h=Date:To:From:Subject:Message-Id; b=SrqZ5zaBexMOlErfTRz25PJjZ+C9qRMUzkhFupWXz+MpqcioA7+DXUccbP2WMpvxAgGdhp3reEZd8km+BoVXzrFRd1JIl4RaQfIPIj6O7VpEgHLbf4r1GnVrHh10svYZV78DvmBl+Bt19w5zQf/m0/kANsp1meTWp0tORHlNYKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MWRtVsjK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MWRtVsjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33722C4AF07;
	Fri, 12 Jul 2024 22:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824841;
	bh=/1uMpbygKPUle58tHWNoWaE7VfVxrb8+VBhF07B6UBo=;
	h=Date:To:From:Subject:From;
	b=MWRtVsjKuNESAQC/2WfU87pjawMbia2LWLTTJlpqFLAPXtCFgF0ls0Syu//WcZege
	 m8SJDgHRwA2T+9k8z1rdbOkButuEIUgJYvm9xyeznPFUa88UDCMVlmFM1pwWCkLGsC
	 cHxPd5342x/F3EzDDYRWR4dJGlib8xgfI+L+A2xA=
Date: Fri, 12 Jul 2024 15:54:00 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shuah@kernel.org,peterx@redhat.com,osalvador@suse.de,mike.kravetz@oracle.com,kraxel@redhat.com,junxiao.chang@intel.com,jgg@nvidia.com,hughd@google.com,hch@lst.de,hch@infradead.org,dongwon.kim@intel.com,david@redhat.com,daniel.vetter@ffwll.ch,arnd@arndb.de,airlied@redhat.com,vivek.kasireddy@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] udmabuf-use-vmf_insert_pfn-and-vm_pfnmap-for-handling-mmap.patch removed from -mm tree
Message-Id: <20240712225401.33722C4AF07@smtp.kernel.org>
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


