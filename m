Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72C71A287E
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 06:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736317609; cv=none; b=WY8WEWH36bEnE8C/l4c6VwFa4EGoIIDP2dRHJ7IOdLlUr9wovffGY9a3MEeZw/y2vcdgCH6FzyX4gYyvEPSK+YdKNZ26PoX5oyD8RJEnCEiCdtJuQaE8hD/nBQmiKaczMG/h5vuEAq5hmhjCwe3FRQ96ojc9oZeOwmxFP5lDntI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736317609; c=relaxed/simple;
	bh=MqQCtOdlFJ9nUBoIQMWxBP4f9fGDWMFQG52dEHg3MNA=;
	h=Date:To:From:Subject:Message-Id; b=bJ/UxBbCdLzQJrTBAJrOXG+vxUnl6HX5cpL/OYGPojMg6VniwmMvY1GMJJDSbxBOcp5IqBBbomhbSGmylcRhcsFnAsZRz2EcU5Q9JjvVxgKA7k95W4vBTmclE5CIAr18OfyGkLURFjlnTsARBZtWQSLayzQzebgPMH/tL/r5M/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PS4pNcwA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PS4pNcwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33989C4CED0;
	Wed,  8 Jan 2025 06:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736317609;
	bh=MqQCtOdlFJ9nUBoIQMWxBP4f9fGDWMFQG52dEHg3MNA=;
	h=Date:To:From:Subject:From;
	b=PS4pNcwAHard4DIupdufvswjSsdZgYjm4FWMkf8l+5UG5c/VB4jnTzPljSP4zqyMl
	 cIKFUB2p9HMSzL82TRwRTjEAr9fH2F3MMQBIlPvAFAYPhHFS2K6V5MyQn3iMVyEPyP
	 mXInhlxTlRpon1bSiWioYJpwpOC/5d2T14iPN6oo=
Date: Tue, 07 Jan 2025 22:26:48 -0800
To: mm-commits@vger.kernel.org,dan.j.williams@intel.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-move-p2pdma-page-refcount-initialisation-to-p2pdma.patch added to mm-unstable branch
Message-Id: <20250108062649.33989C4CED0@smtp.kernel.org>
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
Date: Tue, 7 Jan 2025 14:42:26 +1100

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

Link: https://lkml.kernel.org/r/09143f567302ccfe293972b7f20fc709fafdd8db.1736221254.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
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
rmap-add-support-for-pud-sized-mappings-to-rmap.patch
huge_memory-add-vmf_insert_folio_pud.patch
huge_memory-add-vmf_insert_folio_pmd.patch
memremap-add-is_devdax_page-and-is_fsdax_page-helpers.patch
mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages.patch
proc-task_mmu-mark-devdax-and-fsdax-pages-as-always-unpinned.patch
mm-mlock-skip-zone_device-pmds-during-mlock.patch
fs-dax-properly-refcount-fs-dax-pages.patch
device-dax-properly-refcount-device-dax-pages-when-mapping.patch
mm-remove-pxx_devmap-callers.patch
mm-remove-devmap-related-functions-and-page-table-bits.patch
revert-riscv-mm-add-support-for-zone_device.patch

