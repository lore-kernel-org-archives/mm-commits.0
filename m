Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0B51A9B4D
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274495; cv=none; b=ux7fx+0HSOGZ4kkWsmflPn+apXAnPkUA0PnKX1paRmnTxY0rQJKXVJ4K5Tgvd2DjaLrdjeOE+K/AfXgFVuT5ZlafDhKfABaQ3F+iK2bnqNtGb11tHv2W0Q1cPW7/saNaoqylWaccBFtnqEclyqh5mLZ2+ZylJiXg0I5/bxgxwWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274495; c=relaxed/simple;
	bh=T4AprXPqvvEBAxB7YWe+Oq9BV8wsoy8VnmC1y6fM+nw=;
	h=Date:To:From:Subject:Message-Id; b=W7K1qbCYteYEEuYI4egxqD2SlDcLhjmP3iDtDNDFACUPFn+7Q/7gPxmJ3o6fqLabA5yUR950O5L7bEVtwxcy2p44Pw5gGIcXbLBuiVafC5mJoU3uWp/gsfhms3d2O6cFZhnl8KnGmh8tuN2TpIMj554Sm7aimndZjh3YO52csLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cJ7yud9r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cJ7yud9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE43C4CEDD;
	Tue, 18 Mar 2025 05:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274495;
	bh=T4AprXPqvvEBAxB7YWe+Oq9BV8wsoy8VnmC1y6fM+nw=;
	h=Date:To:From:Subject:From;
	b=cJ7yud9rh76jc7jQENBAGpJG2N0cZFDAfUgoKpGxFMwPP37c1uMAtTlIQhZ79RxSh
	 6W1BOkFDU02N8yCo+3PfKSpJUWdhlmsptMhpDzmWsg0ikkvGRzuVqXBU2BLRg/RzWS
	 fJjrhGFr6V43Utz6MT7DKbqCrNjqoxN5lPzIXWtw=
Date: Mon, 17 Mar 2025 22:08:14 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,balbirs@nvidia.com,alison.schofield@intel.com,agordeev@linux.ibm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_init-move-p2pdma-page-refcount-initialisation-to-p2pdma.patch removed from -mm tree
Message-Id: <20250318050815.1FE43C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: move p2pdma page refcount initialisation to p2pdma
has been removed from the -mm tree.  Its filename was
     mm-mm_init-move-p2pdma-page-refcount-initialisation-to-p2pdma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/mm_init: move p2pdma page refcount initialisation to p2pdma
Date: Fri, 28 Feb 2025 14:31:05 +1100

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

Link: https://lkml.kernel.org/r/6aedb0ac2886dcc4503cb705273db5b3863a0b66.1740713401.git-series.apopple@nvidia.com
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
Cc: linmiaohe <linmiaohe@huawei.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michael "Camp Drill Sergeant" Ellerman <mpe@ellerman.id.au>
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
@@ -1026,12 +1026,26 @@ static void __ref __init_zone_device_pag
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


