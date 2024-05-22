Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8036BA3F
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 22:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716415667; cv=none; b=N3q8FTVE0CJQy+zeti8sFplsuIrpyAQLTc0tIrdPQUd4oQSJTDlUkbHeLTKgwQcMqfEgWRdyJnklAYMipTyujYk569fvpqi/oYvaaNdKx52LPr6h/PSZunfi+E5H8e0MYATL5owPQwkKA2a7ELooVLeqTKAXW+BiBDWO9JnAVaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716415667; c=relaxed/simple;
	bh=ycOXJLF2JCTqTqRSXYyaPJmX734iXXH/ukESYHjBKqA=;
	h=Date:To:From:Subject:Message-Id; b=Q2ngG2wm1bJuRFfBTV8XZJ1DLsu5BVfcGZtvTlg4hRC+7tN+PipU/tb0DSgxUSnc8VJw2mr1a7vr/6bCQoIZGz8PYWFmsOaiCK9vVJV+Fwbh8j0RwsiN/3p7OhXUQWwPKWgBG8wYegTllHa2nlcCtRqU8A2lsVSfEiTxvtqax98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tN+kLIaG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tN+kLIaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7104C2BBFC;
	Wed, 22 May 2024 22:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716415667;
	bh=ycOXJLF2JCTqTqRSXYyaPJmX734iXXH/ukESYHjBKqA=;
	h=Date:To:From:Subject:From;
	b=tN+kLIaGRFlMk4XyguJ6s2sSteIHdpLTAlZYYgKnpQQSIpnI6AG4jaROrqxDdk7LA
	 OwZ8FeIFwpx4I/REeNlxrkY+5nkL2VnmaEWsU2PoeQowADHc2OxdEpWecXTIHd7P6A
	 4SB5tmMxILQ4yF9fbW9vEAkMotkfTO3jhng/9/IU=
Date: Wed, 22 May 2024 15:07:46 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shuah@kernel.org,peterx@redhat.com,mike.kravetz@oracle.com,kraxel@redhat.com,junxiao.chang@intel.com,jgg@nvidia.com,hughd@google.com,hch@lst.de,hch@infradead.org,dongwon.kim@intel.com,david@redhat.com,daniel.vetter@ffwll.ch,vivek.kasireddy@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + udmabuf-use-vmf_insert_pfn-and-vm_pfnmap-for-handling-mmap.patch added to mm-unstable branch
Message-Id: <20240522220746.E7104C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: udmabuf: use vmf_insert_pfn and VM_PFNMAP for handling mmap
has been added to the -mm mm-unstable branch.  Its filename is
     udmabuf-use-vmf_insert_pfn-and-vm_pfnmap-for-handling-mmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/udmabuf-use-vmf_insert_pfn-and-vm_pfnmap-for-handling-mmap.patch

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
From: Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: udmabuf: use vmf_insert_pfn and VM_PFNMAP for handling mmap
Date: Wed, 10 Apr 2024 23:59:40 -0700

Add VM_PFNMAP to vm_flags in the mmap handler to ensure that the mappings
would be managed without using struct page.

And, in the vm_fault handler, use vmf_insert_pfn to share the page's pfn
to userspace instead of directly sharing the page (via struct page *).

Link: https://lkml.kernel.org/r/20240411070157.3318425-5-vivek.kasireddy@intel.com
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Dongwon Kim <dongwon.kim@intel.com>
Cc: Junxiao Chang <junxiao.chang@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
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

mm-gup-introduce-unpin_folio-unpin_folios-helpers.patch
mm-gup-introduce-check_and_migrate_movable_folios.patch
mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios.patch
udmabuf-use-vmf_insert_pfn-and-vm_pfnmap-for-handling-mmap.patch
udmabuf-add-back-support-for-mapping-hugetlb-pages.patch
udmabuf-convert-udmabuf-driver-to-use-folios.patch
udmabuf-pin-the-pages-using-memfd_pin_folios-api.patch
selftests-udmabuf-add-tests-to-verify-data-after-page-migration.patch

