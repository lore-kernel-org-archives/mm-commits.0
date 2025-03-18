Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7D925771
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274513; cv=none; b=EKkuB+QmZyfHRxvz3h7ZwanTw/PAhwyijc6et0RXO3w+fiVMjhWPzW1OlmkcuSH39Jo+zMRRGRAV+AI2KcVtkGpkSKCRuthZ8ovEK6gk6inJwo5EYJZzXoeAQ0DFzQ8N9mzFMn0PBppaDEkmUPixAb1im2p6bObLCkFe9qVU7iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274513; c=relaxed/simple;
	bh=c7sDPx8NYs63ePtSegSJFamHa0dFzLqtocw1af8wvLc=;
	h=Date:To:From:Subject:Message-Id; b=bwo2EHZNh/ZU2hplmoZi+Q7UBwGlFd1XkDmsQGWV6A0FM+vdcW7Hf+Yh/E0mV0jElXEW7nFdvToPPH0lcQJ8AiUn2eNQinOVJ20wgtYnXMRllifXDZcbLRCY4ygdavTvaGsdbJi2j2AVfth5ZwpxDiuFZAUJdzYXBJW8hzu30lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CRz7RiZt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CRz7RiZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C25C4CEDD;
	Tue, 18 Mar 2025 05:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274513;
	bh=c7sDPx8NYs63ePtSegSJFamHa0dFzLqtocw1af8wvLc=;
	h=Date:To:From:Subject:From;
	b=CRz7RiZt0IJ5WmmOy3JSSyb0jZH3z1+a/uopwk0H6MVBdrOl3/P+qYXSlc8opPob0
	 dnymXtPOZ8KSkFyiqLJcjMF+6mSk7grfjtl9syQ4EaHg66dheNbMzk9A16ooHdjhgi
	 ygYxgTTMJgL8gy8GqRyJADHaq4Z1gDxXCgHOL2y0=
Date: Mon, 17 Mar 2025 22:08:32 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,balbirs@nvidia.com,alison.schofield@intel.com,agordeev@linux.ibm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] device-dax-properly-refcount-device-dax-pages-when-mapping.patch removed from -mm tree
Message-Id: <20250318050832.E2C25C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: device/dax: properly refcount device dax pages when mapping
has been removed from the -mm tree.  Its filename was
     device-dax-properly-refcount-device-dax-pages-when-mapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: device/dax: properly refcount device dax pages when mapping
Date: Fri, 28 Feb 2025 14:31:15 +1100

Device DAX pages are currently not reference counted when mapped, instead
relying on the devmap PTE bit to ensure mapping code will not get/put
references.  This requires special handling in various page table walkers,
particularly GUP, to manage references on the underlying pgmap to ensure
the pages remain valid.

However there is no reason these pages can't be refcounted properly at map
time.  Doning so eliminates the need for the devmap PTE bit, freeing up a
precious PTE bit.  It also simplifies GUP as it no longer needs to manage
the special pgmap references and can instead just treat the pages normally
as defined by vm_normal_page().

Link: https://lkml.kernel.org/r/968d3a8e9157e7492e85d065765c027e525f9fc9.1740713401.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Asahi Lina <lina@asahilina.net>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Dan Wiliams <dan.j.williams@intel.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
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

 drivers/dax/device.c |   15 +++++++++------
 mm/memremap.c        |   14 +++++++-------
 2 files changed, 16 insertions(+), 13 deletions(-)

--- a/drivers/dax/device.c~device-dax-properly-refcount-device-dax-pages-when-mapping
+++ a/drivers/dax/device.c
@@ -125,11 +125,12 @@ static vm_fault_t __dev_dax_pte_fault(st
 		return VM_FAULT_SIGBUS;
 	}
 
-	pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
+	pfn = phys_to_pfn_t(phys, 0);
 
 	dax_set_mapping(vmf, pfn, fault_size);
 
-	return vmf_insert_mixed(vmf->vma, vmf->address, pfn);
+	return vmf_insert_page_mkwrite(vmf, pfn_t_to_page(pfn),
+					vmf->flags & FAULT_FLAG_WRITE);
 }
 
 static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
@@ -168,11 +169,12 @@ static vm_fault_t __dev_dax_pmd_fault(st
 		return VM_FAULT_SIGBUS;
 	}
 
-	pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
+	pfn = phys_to_pfn_t(phys, 0);
 
 	dax_set_mapping(vmf, pfn, fault_size);
 
-	return vmf_insert_pfn_pmd(vmf, pfn, vmf->flags & FAULT_FLAG_WRITE);
+	return vmf_insert_folio_pmd(vmf, page_folio(pfn_t_to_page(pfn)),
+				vmf->flags & FAULT_FLAG_WRITE);
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
@@ -213,11 +215,12 @@ static vm_fault_t __dev_dax_pud_fault(st
 		return VM_FAULT_SIGBUS;
 	}
 
-	pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
+	pfn = phys_to_pfn_t(phys, 0);
 
 	dax_set_mapping(vmf, pfn, fault_size);
 
-	return vmf_insert_pfn_pud(vmf, pfn, vmf->flags & FAULT_FLAG_WRITE);
+	return vmf_insert_folio_pud(vmf, page_folio(pfn_t_to_page(pfn)),
+				vmf->flags & FAULT_FLAG_WRITE);
 }
 #else
 static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
--- a/mm/memremap.c~device-dax-properly-refcount-device-dax-pages-when-mapping
+++ a/mm/memremap.c
@@ -460,11 +460,7 @@ void free_zone_device_folio(struct folio
 {
 	struct dev_pagemap *pgmap = folio->pgmap;
 
-	if (WARN_ON_ONCE(!pgmap->ops))
-		return;
-
-	if (WARN_ON_ONCE(pgmap->type != MEMORY_DEVICE_FS_DAX &&
-			 !pgmap->ops->page_free))
+	if (WARN_ON_ONCE(!pgmap))
 		return;
 
 	mem_cgroup_uncharge(folio);
@@ -494,12 +490,15 @@ void free_zone_device_folio(struct folio
 	 * zero which indicating the page has been removed from the file
 	 * system mapping.
 	 */
-	if (pgmap->type != MEMORY_DEVICE_FS_DAX)
+	if (pgmap->type != MEMORY_DEVICE_FS_DAX &&
+	    pgmap->type != MEMORY_DEVICE_GENERIC)
 		folio->mapping = NULL;
 
 	switch (pgmap->type) {
 	case MEMORY_DEVICE_PRIVATE:
 	case MEMORY_DEVICE_COHERENT:
+		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->page_free))
+			break;
 		pgmap->ops->page_free(folio_page(folio, 0));
 		put_dev_pagemap(pgmap);
 		break;
@@ -509,7 +508,6 @@ void free_zone_device_folio(struct folio
 		 * Reset the refcount to 1 to prepare for handing out the page
 		 * again.
 		 */
-		pgmap->ops->page_free(folio_page(folio, 0));
 		folio_set_count(folio, 1);
 		break;
 
@@ -518,6 +516,8 @@ void free_zone_device_folio(struct folio
 		break;
 
 	case MEMORY_DEVICE_PCI_P2PDMA:
+		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->page_free))
+			break;
 		pgmap->ops->page_free(folio_page(folio, 0));
 		break;
 	}
_

Patches currently in -mm which might be from apopple@nvidia.com are


