Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF623C1F
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 04:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739854076; cv=none; b=rrKE4tTH5QmLTZHoZrUHMlMQ8Fgx2br00Y0YAwVuNnz9UYXfVkYAXj39kJ0rEYlRhcJ6I3ssL8EngtYGouwaT16WBoL9MUZ/VCx3u2X1cv0AuhT2qv50JriX3lkd32QWec5ApsrOnm5NB3LVU6FPJicF+gdwUzI+ESSZ5jcLnE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739854076; c=relaxed/simple;
	bh=DDsyd0vLvtY2wmwR9DgQPMmpGTrzBAcroSuCzzew8vk=;
	h=Date:To:From:Subject:Message-Id; b=hefXZck5Gr8GJpYI/37axJJzaO1o9hiSfmP9gZldVs+iXbX9nynYjPV9qYY0C/PCL8odz2VyyK7TVV/il21vvlcCakRYKpERyAn5k3dhTr6PBqTJ7RFTGBeEeb22RujAqxr9CYM1NvF4fW/xOmjyWFrKNo9CWoIrDYKCoxJycTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XuRd/LaU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XuRd/LaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A940C4CEE2;
	Tue, 18 Feb 2025 04:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739854076;
	bh=DDsyd0vLvtY2wmwR9DgQPMmpGTrzBAcroSuCzzew8vk=;
	h=Date:To:From:Subject:From;
	b=XuRd/LaU/J7+Cn1sp7Ni8T3WQwGvAlUL50/qz3RYb1M9RQpQYcDKEM1bhZXbKS9Vo
	 Fo289evLX9iXvmbSeoDU/tZaxu6bfA6TTiImyw69+zZXFq9ku1ymwaol2m1gw5Dph8
	 FEg6Aa6O/w26Lu70PMJ4xm724rJgFtTYoyOcCCDw=
Date: Mon, 17 Feb 2025 20:47:55 -0800
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,balbirs@nvidia.com,alison.schofield@intel.com,agordeev@linux.ibm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-move-p2pdma-page-refcount-initialisation-to-p2pdma.patch added to mm-unstable branch
Message-Id: <20250218044756.2A940C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init: move p2pdma page refcount initialisation to p2pdma
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_init-move-p2pdma-page-refcount-initialisation-to-p2pdma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-move-p2pdma-page-refcount-initialisation-to-p2pdma.patch

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
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/mm_init: move p2pdma page refcount initialisation to p2pdma
Date: Tue, 18 Feb 2025 14:55:26 +1100

Currently ZONE_DEVICE page reference counts are initialised by core memory
management code in __init_zone_device_page() as part of the memremap()
call which driver modules make to obtain ZONE_DEVICE pages.  This
initialises page refcounts to 1 before returning them to the driver.

This was presumably done because it drivers had a reference of sorts on
the page.  It also ensured the page could always be mapped with
vm_insert_page() for example and would never get freed (ie.  have a zero
refcount), freeing drivers of manipulating page reference counts.

However it complicates figuring out whether or not a page is free from the
mm perspective because it is no longer possible to just look at the
refcount.  Instead the page type must be known and if GUP is used a
secondary pgmap reference is also sometimes needed.

To simplify this it is desirable to remove the page reference count for
the driver, so core mm can just use the refcount without having to account
for page type or do other types of tracking.  This is possible because
drivers can always assume the page is valid as core kernel will never
offline or remove the struct page.

This means it is now up to drivers to initialise the page refcount as
required.  P2PDMA uses vm_insert_page() to map the page, and that requires
a non-zero reference count when initialising the page so set that when the
page is first mapped.

Link: https://lkml.kernel.org/r/6aedb0ac2886dcc4503cb705273db5b3863a0b66.1739850794.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Asahi Lina <lina@asahilina.net>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/p2pdma.c |   13 +++++++++++--
 mm/memremap.c        |   17 +++++++++++++----
 mm/mm_init.c         |   22 ++++++++++++++++++----
 3 files changed, 42 insertions(+), 10 deletions(-)

--- a/drivers/pci/p2pdma.c~mm-mm_init-move-p2pdma-page-refcount-initialisation-to-p2pdma
+++ a/drivers/pci/p2pdma.c
@@ -140,13 +140,22 @@ static int p2pmem_alloc_mmap(struct file
 	rcu_read_unlock();
 
 	for (vaddr = vma->vm_start; vaddr < vma->vm_end; vaddr += PAGE_SIZE) {
-		ret = vm_insert_page(vma, vaddr, virt_to_page(kaddr));
+		struct page *page = virt_to_page(kaddr);
+
+		/*
+		 * Initialise the refcount for the freshly allocated page. As
+		 * we have just allocated the page no one else should be
+		 * using it.
+		 */
+		VM_WARN_ON_ONCE_PAGE(!page_ref_count(page), page);
+		set_page_count(page, 1);
+		ret = vm_insert_page(vma, vaddr, page);
 		if (ret) {
 			gen_pool_free(p2pdma->pool, (uintptr_t)kaddr, len);
 			return ret;
 		}
 		percpu_ref_get(ref);
-		put_page(virt_to_page(kaddr));
+		put_page(page);
 		kaddr += PAGE_SIZE;
 		len -= PAGE_SIZE;
 	}
--- a/mm/memremap.c~mm-mm_init-move-p2pdma-page-refcount-initialisation-to-p2pdma
+++ a/mm/memremap.c
@@ -488,15 +488,24 @@ void free_zone_device_folio(struct folio
 	folio->mapping = NULL;
 	folio->page.pgmap->ops->page_free(folio_page(folio, 0));
 
-	if (folio->page.pgmap->type != MEMORY_DEVICE_PRIVATE &&
-	    folio->page.pgmap->type != MEMORY_DEVICE_COHERENT)
+	switch (folio->page.pgmap->type) {
+	case MEMORY_DEVICE_PRIVATE:
+	case MEMORY_DEVICE_COHERENT:
+		put_dev_pagemap(folio->page.pgmap);
+		break;
+
+	case MEMORY_DEVICE_FS_DAX:
+	case MEMORY_DEVICE_GENERIC:
 		/*
 		 * Reset the refcount to 1 to prepare for handing out the page
 		 * again.
 		 */
 		folio_set_count(folio, 1);
-	else
-		put_dev_pagemap(folio->page.pgmap);
+		break;
+
+	case MEMORY_DEVICE_PCI_P2PDMA:
+		break;
+	}
 }
 
 void zone_device_page_init(struct page *page)
--- a/mm/mm_init.c~mm-mm_init-move-p2pdma-page-refcount-initialisation-to-p2pdma
+++ a/mm/mm_init.c
@@ -1017,12 +1017,26 @@ static void __ref __init_zone_device_pag
 	}
 
 	/*
-	 * ZONE_DEVICE pages are released directly to the driver page allocator
-	 * which will set the page count to 1 when allocating the page.
+	 * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC and
+	 * MEMORY_TYPE_FS_DAX pages are released directly to the driver page
+	 * allocator which will set the page count to 1 when allocating the
+	 * page.
+	 *
+	 * MEMORY_TYPE_GENERIC and MEMORY_TYPE_FS_DAX pages automatically have
+	 * their refcount reset to one whenever they are freed (ie. after
+	 * their refcount drops to 0).
 	 */
-	if (pgmap->type == MEMORY_DEVICE_PRIVATE ||
-	    pgmap->type == MEMORY_DEVICE_COHERENT)
+	switch (pgmap->type) {
+	case MEMORY_DEVICE_PRIVATE:
+	case MEMORY_DEVICE_COHERENT:
+	case MEMORY_DEVICE_PCI_P2PDMA:
 		set_page_count(page, 0);
+		break;
+
+	case MEMORY_DEVICE_FS_DAX:
+	case MEMORY_DEVICE_GENERIC:
+		break;
+	}
 }
 
 /*
_

Patches currently in -mm which might be from apopple@nvidia.com are

fuse-fix-dax-truncate-punch_hole-fault-path.patch
fs-dax-return-unmapped-busy-pages-from-dax_layout_busy_page_range.patch
fs-dax-dont-skip-locked-entries-when-scanning-entries.patch
fs-dax-refactor-wait-for-dax-idle-page.patch
fs-dax-create-a-common-implementation-to-break-dax-layouts.patch
fs-dax-always-remove-dax-page-cache-entries-when-breaking-layouts.patch
fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount.patch
fs-dax-remove-page_mapping_dax_shared-mapping-flag.patch
mm-gup-remove-redundant-check-for-pci-p2pdma-page.patch
mm-mm_init-move-p2pdma-page-refcount-initialisation-to-p2pdma.patch
mm-allow-compound-zone-device-pages.patch
mm-memory-enhance-insert_page_into_pte_locked-to-create-writable-mappings.patch
mm-memory-add-vmf_insert_page_mkwrite.patch
mm-rmap-add-support-for-pud-sized-mappings-to-rmap.patch
mm-huge_memory-add-vmf_insert_folio_pud.patch
mm-huge_memory-add-vmf_insert_folio_pmd.patch
mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages.patch
fs-dax-properly-refcount-fs-dax-pages.patch
device-dax-properly-refcount-device-dax-pages-when-mapping.patch

