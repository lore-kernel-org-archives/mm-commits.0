Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94843C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiJQATz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiJQATQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:19:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FFE31DD8
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:19:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF54CB80E28
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96259C433C1;
        Mon, 17 Oct 2022 00:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665965949;
        bh=FMp+6dcVpe0W2HXol5pSI/6h6CeYqqVtjNGwiQ75ZnY=;
        h=Date:To:From:Subject:From;
        b=MwN2mvYzIOzHImj08b2oiqj34Y+ndY6ueeLINg76g/o69TbLBUYmNzeRfrT2FOERN
         ziOokX3KidY5CLyiXYT4Kdb3/s4nSrrHZcYwjQd5SjYEz0zQKSStx9Mgu9W+sfmFrP
         Vcm5FdTXZwUmQFCScvWkLl0RvJjG/ZPKQadUpaGM=
Date:   Sun, 16 Oct 2022 17:19:08 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        willy@infradead.org, lyude@redhat.com, lkp@intel.com,
        kherbst@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        jgg@nvidia.com, jack@suse.cz, hch@lst.de, Felix.Kuehling@amd.com,
        djwong@kernel.org, david@fromorbit.com, daniel@ffwll.ch,
        christian.koenig@amd.com, bskeggs@redhat.com, apopple@nvidia.com,
        alexander.deucher@amd.com, airlied@linux.ie,
        dan.j.williams@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + devdax-use-dax_insert_entry-dax_delete_mapping_entry.patch added to mm-unstable branch
Message-Id: <20221017001909.96259C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: devdax: use dax_insert_entry() + dax_delete_mapping_entry()
has been added to the -mm mm-unstable branch.  Its filename is
     devdax-use-dax_insert_entry-dax_delete_mapping_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/devdax-use-dax_insert_entry-dax_delete_mapping_entry.patch

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
From: Dan Williams <dan.j.williams@intel.com>
Subject: devdax: use dax_insert_entry() + dax_delete_mapping_entry()
Date: Fri, 14 Oct 2022 16:59:00 -0700

Track entries and take pgmap references at mapping insertion time.  Revoke
mappings (dax_zap_mappings()) and drop the associated pgmap references at
device destruction or inode eviction time.  With this in place, and the
fsdax equivalent already in place, the gup code no longer needs to
consider PTE_DEVMAP as an indicator to get a pgmap reference before taking
a page reference.

In other words, GUP takes additional references on mapped pages.  Until
now, DAX in all its forms was failing to take references at mapping time. 
With that fixed there is no longer a requirement for gup to manage @pgmap
references.  However, that cleanup is saved for a follow-on patch.

Link: https://lkml.kernel.org/r/166579194049.2236710.10922460534153863415.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/Kconfig   |    1 
 drivers/dax/bus.c     |    9 ++++
 drivers/dax/device.c  |   73 +++++++++++++++++++++++-----------------
 drivers/dax/mapping.c |   19 +++++++---
 include/linux/dax.h   |    3 +
 5 files changed, 68 insertions(+), 37 deletions(-)

--- a/drivers/dax/bus.c~devdax-use-dax_insert_entry-dax_delete_mapping_entry
+++ a/drivers/dax/bus.c
@@ -382,9 +382,16 @@ void kill_dev_dax(struct dev_dax *dev_da
 {
 	struct dax_device *dax_dev = dev_dax->dax_dev;
 	struct inode *inode = dax_inode(dax_dev);
+	struct address_space *mapping = inode->i_mapping;
 
 	kill_dax(dax_dev);
-	unmap_mapping_range(inode->i_mapping, 0, 0, 1);
+
+	/*
+	 * The dax device inode can outlive the next reuse of the memory
+	 * fronted by this device, force it idle now.
+	 */
+	dax_break_layouts(mapping, 0, ULONG_MAX >> PAGE_SHIFT);
+	truncate_inode_pages(mapping, 0);
 
 	/*
 	 * Dynamic dax region have the pgmap allocated via dev_kzalloc()
--- a/drivers/dax/device.c~devdax-use-dax_insert_entry-dax_delete_mapping_entry
+++ a/drivers/dax/device.c
@@ -73,38 +73,15 @@ __weak phys_addr_t dax_pgoff_to_phys(str
 	return -1;
 }
 
-static void dax_set_mapping(struct vm_fault *vmf, pfn_t pfn,
-			      unsigned long fault_size)
-{
-	unsigned long i, nr_pages = fault_size / PAGE_SIZE;
-	struct file *filp = vmf->vma->vm_file;
-	struct dev_dax *dev_dax = filp->private_data;
-	pgoff_t pgoff;
-
-	/* mapping is only set on the head */
-	if (dev_dax->pgmap->vmemmap_shift)
-		nr_pages = 1;
-
-	pgoff = linear_page_index(vmf->vma,
-			ALIGN(vmf->address, fault_size));
-
-	for (i = 0; i < nr_pages; i++) {
-		struct page *page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
-
-		page = compound_head(page);
-		if (page->mapping)
-			continue;
-
-		page->mapping = filp->f_mapping;
-		page->index = pgoff + i;
-	}
-}
-
 static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
 				struct vm_fault *vmf)
 {
+	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
+	XA_STATE(xas, &mapping->i_pages, vmf->pgoff);
 	struct device *dev = &dev_dax->dev;
 	phys_addr_t phys;
+	vm_fault_t ret;
+	void *entry;
 	pfn_t pfn;
 	unsigned int fault_size = PAGE_SIZE;
 
@@ -128,7 +105,16 @@ static vm_fault_t __dev_dax_pte_fault(st
 
 	pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
-	dax_set_mapping(vmf, pfn, fault_size);
+	entry = dax_grab_mapping_entry(&xas, mapping, 0);
+	if (is_dax_err(entry))
+		return dax_err_to_vmfault(entry);
+
+	ret = dax_insert_entry(&xas, vmf, &entry, pfn, 0);
+
+	dax_unlock_entry(&xas, entry);
+
+	if (ret)
+		return ret;
 
 	return vmf_insert_mixed(vmf->vma, vmf->address, pfn);
 }
@@ -136,10 +122,14 @@ static vm_fault_t __dev_dax_pte_fault(st
 static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
 				struct vm_fault *vmf)
 {
+	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	unsigned long pmd_addr = vmf->address & PMD_MASK;
+	XA_STATE(xas, &mapping->i_pages, vmf->pgoff);
 	struct device *dev = &dev_dax->dev;
 	phys_addr_t phys;
+	vm_fault_t ret;
 	pgoff_t pgoff;
+	void *entry;
 	pfn_t pfn;
 	unsigned int fault_size = PMD_SIZE;
 
@@ -171,7 +161,16 @@ static vm_fault_t __dev_dax_pmd_fault(st
 
 	pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
-	dax_set_mapping(vmf, pfn, fault_size);
+	entry = dax_grab_mapping_entry(&xas, mapping, PMD_ORDER);
+	if (is_dax_err(entry))
+		return dax_err_to_vmfault(entry);
+
+	ret = dax_insert_entry(&xas, vmf, &entry, pfn, DAX_PMD);
+
+	dax_unlock_entry(&xas, entry);
+
+	if (ret)
+		return ret;
 
 	return vmf_insert_pfn_pmd(vmf, pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
@@ -180,10 +179,14 @@ static vm_fault_t __dev_dax_pmd_fault(st
 static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
 				struct vm_fault *vmf)
 {
+	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	unsigned long pud_addr = vmf->address & PUD_MASK;
+	XA_STATE(xas, &mapping->i_pages, vmf->pgoff);
 	struct device *dev = &dev_dax->dev;
 	phys_addr_t phys;
+	vm_fault_t ret;
 	pgoff_t pgoff;
+	void *entry;
 	pfn_t pfn;
 	unsigned int fault_size = PUD_SIZE;
 
@@ -216,7 +219,16 @@ static vm_fault_t __dev_dax_pud_fault(st
 
 	pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
-	dax_set_mapping(vmf, pfn, fault_size);
+	entry = dax_grab_mapping_entry(&xas, mapping, PUD_ORDER);
+	if (xa_is_internal(entry))
+		return xa_to_internal(entry);
+
+	ret = dax_insert_entry(&xas, vmf, &entry, pfn, DAX_PUD);
+
+	dax_unlock_entry(&xas, entry);
+
+	if (ret)
+		return ret;
 
 	return vmf_insert_pfn_pud(vmf, pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
@@ -494,3 +506,4 @@ MODULE_LICENSE("GPL v2");
 module_init(dax_init);
 module_exit(dax_exit);
 MODULE_ALIAS_DAX_DEVICE(0);
+MODULE_IMPORT_NS(DAX);
--- a/drivers/dax/Kconfig~devdax-use-dax_insert_entry-dax_delete_mapping_entry
+++ a/drivers/dax/Kconfig
@@ -9,6 +9,7 @@ if DAX
 config DEV_DAX
 	tristate "Device DAX: direct access mapping device"
 	depends on TRANSPARENT_HUGEPAGE
+	depends on !FS_DAX_LIMITED
 	help
 	  Support raw access to differentiated (persistence, bandwidth,
 	  latency...) memory via an mmap(2) capable character
--- a/drivers/dax/mapping.c~devdax-use-dax_insert_entry-dax_delete_mapping_entry
+++ a/drivers/dax/mapping.c
@@ -266,6 +266,7 @@ void dax_unlock_entry(struct xa_state *x
 	WARN_ON(!dax_is_locked(old));
 	dax_wake_entry(xas, entry, WAKE_NEXT);
 }
+EXPORT_SYMBOL_NS_GPL(dax_unlock_entry, DAX);
 
 /*
  * Return: The entry stored at this location before it was locked.
@@ -663,6 +664,7 @@ fallback:
 	xas_unlock_irq(xas);
 	return vmfault_to_dax_err(VM_FAULT_FALLBACK);
 }
+EXPORT_SYMBOL_NS_GPL(dax_grab_mapping_entry, DAX);
 
 static void *dax_zap_entry(struct xa_state *xas, void *entry)
 {
@@ -814,15 +816,21 @@ out:
  * wait indefinitely for all pins to drop, the alternative to waiting is
  * a potential use-after-free scenario
  */
-static void dax_break_layout(struct address_space *mapping, pgoff_t index)
+void dax_break_layouts(struct address_space *mapping, pgoff_t index,
+		       pgoff_t end)
 {
-	/* To do this without locks, the inode needs to be unreferenced */
-	WARN_ON(atomic_read(&mapping->host->i_count));
+	struct inode *inode = mapping->host;
+
+	/*
+	 * To do this without filesystem locks, the inode needs to be
+	 * unreferenced, or device-dax.
+	 */
+	WARN_ON(atomic_read(&inode->i_count) && !S_ISCHR(inode->i_mode));
 	do {
 		struct page *page;
 
 		page = dax_zap_mappings_range(mapping, index << PAGE_SHIFT,
-					      (index + 1) << PAGE_SHIFT);
+					      end << PAGE_SHIFT);
 		if (!page)
 			return;
 		wait_var_event(page, dax_page_idle(page));
@@ -838,7 +846,7 @@ int dax_delete_mapping_entry(struct addr
 	int ret;
 
 	if (mapping_exiting(mapping))
-		dax_break_layout(mapping, index);
+		dax_break_layouts(mapping, index, index + 1);
 
 	ret = __dax_invalidate_entry(mapping, index, true);
 
@@ -932,6 +940,7 @@ out:
 
 	return ret;
 }
+EXPORT_SYMBOL_NS_GPL(dax_insert_entry, DAX);
 
 int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 		      struct address_space *mapping, void *entry) __must_hold(xas)
--- a/include/linux/dax.h~devdax-use-dax_insert_entry-dax_delete_mapping_entry
+++ a/include/linux/dax.h
@@ -181,7 +181,6 @@ dax_entry_t dax_lock_mapping_entry(struc
 		unsigned long index, struct page **page);
 void dax_unlock_mapping_entry(struct address_space *mapping,
 		unsigned long index, dax_entry_t cookie);
-void dax_break_layouts(struct inode *inode);
 struct page *dax_zap_mappings(struct address_space *mapping);
 struct page *dax_zap_mappings_range(struct address_space *mapping, loff_t start,
 				    loff_t end);
@@ -286,6 +285,8 @@ void dax_unlock_entry(struct xa_state *x
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 				      pgoff_t index);
+void dax_break_layouts(struct address_space *mapping, pgoff_t index,
+		       pgoff_t end);
 int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 				  struct inode *dest, loff_t destoff,
 				  loff_t len, bool *is_same,
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

fsdax-wait-on-page-not-page-_refcount.patch
fsdax-use-dax_page_idle-to-document-dax-busy-page-checking.patch
fsdax-include-unmapped-inodes-for-page-idle-detection.patch
fsdax-introduce-dax_zap_mappings.patch
fsdax-wait-for-pinned-pages-during-truncate_inode_pages_final.patch
fsdax-validate-dax-layouts-broken-before-truncate.patch
fsdax-hold-dax-lock-over-mapping-insertion.patch
fsdax-update-dax_insert_entry-calling-convention-to-return-an-error.patch
fsdax-rework-for_each_mapped_pfn-to-dax_for_each_folio.patch
fsdax-introduce-pgmap_request_folios.patch
fsdax-rework-dax_insert_entry-calling-convention.patch
fsdax-cleanup-dax_associate_entry.patch
devdax-minor-warning-fixups.patch
devdax-fix-sparse-lock-imbalance-warning.patch
libnvdimm-pmem-support-pmem-block-devices-without-dax.patch
devdax-move-address_space-helpers-to-the-dax-core.patch
devdax-sparse-fixes-for-xarray-locking.patch
devdax-sparse-fixes-for-vmfault_t-dax-entry-conversions.patch
devdax-sparse-fixes-for-vm_fault_t-in-tracepoints.patch
devdax-add-pud-support-to-the-dax-mapping-infrastructure.patch
devdax-use-dax_insert_entry-dax_delete_mapping_entry.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios.patch
mm-memremap_pages-initialize-all-zone_device-pages-to-start-at-refcount-0.patch
mm-meremap_pages-delete-put_devmap_managed_page_refs.patch
mm-gup-drop-dax-pgmap-accounting.patch

