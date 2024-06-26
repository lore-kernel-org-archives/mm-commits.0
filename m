Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDAD18FDDE
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 20:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719435205; cv=none; b=srdho0IwPBpkYL4+iByNrHZiaT8dEhxPeBUlAzOmtkDOG0o/ORSdbNwzWeMJMwep04n0+9rldwsHh7MWGS0P3ZvTPkBOS/zr5TWr+T83FeoJeqR0ZtdKvYMSjkCXmAQenoxHWt1nInzLpe6kInUUpcrmxbBzKtlUcH2oT0vK//g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719435205; c=relaxed/simple;
	bh=6hTSdSq4lQti+KbXNY74obCCMH+OZJEByQe3eVnbhzc=;
	h=Date:To:From:Subject:Message-Id; b=f5WzP9cF636nv0MUglb9BsWEQAfCChHVxmh2lc4SyvMXCGZjSOPgjQxD1Rl+kegmH6+qUzFbRP1pLlUk7+xfiedj/zKXlZ+yTEJ1eavGV+XMw89b15U42nr4ZREJoMA/U4KpXb7wKrKOaSmDLyT+WtM0F/M113KyO2SRYza5Csw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M2PDt4DN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M2PDt4DN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B25C116B1;
	Wed, 26 Jun 2024 20:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719435204;
	bh=6hTSdSq4lQti+KbXNY74obCCMH+OZJEByQe3eVnbhzc=;
	h=Date:To:From:Subject:From;
	b=M2PDt4DNLvXC96t6a+C5mHE0Pgwfhu8+xdxkZviF7nYm+TNhvYNEODeiiwDeugcsw
	 cM3PwjV3z14UZ+QiUnCWZFVI8/A2Yi+m6qleSMPqpZn6bm4OH8Oy98l5io77JfFnJ+
	 LrkUR+/Vwlq69Ca+c3LJM6VCGvD+Vb6QdK1htloc=
Date: Wed, 26 Jun 2024 13:53:24 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shuah@kernel.org,peterx@redhat.com,osalvador@suse.de,mike.kravetz@oracle.com,kraxel@redhat.com,junxiao.chang@intel.com,jgg@nvidia.com,hughd@google.com,hch@lst.de,hch@infradead.org,dongwon.kim@intel.com,david@redhat.com,daniel.vetter@ffwll.ch,arnd@arndb.de,airlied@redhat.com,vivek.kasireddy@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + udmabuf-use-vmf_insert_pfn-and-vm_pfnmap-for-handling-mmap.patch added to mm-unstable branch
Message-Id: <20240626205324.B5B25C116B1@smtp.kernel.org>
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

mm-gup-introduce-unpin_folio-unpin_folios-helpers.patch
mm-gup-introduce-check_and_migrate_movable_folios.patch
mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios.patch
udmabuf-use-vmf_insert_pfn-and-vm_pfnmap-for-handling-mmap.patch
udmabuf-add-back-support-for-mapping-hugetlb-pages.patch
udmabuf-convert-udmabuf-driver-to-use-folios.patch
udmabuf-pin-the-pages-using-memfd_pin_folios-api.patch
selftests-udmabuf-add-tests-to-verify-data-after-page-migration.patch

