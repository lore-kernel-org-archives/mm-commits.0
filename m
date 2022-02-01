Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27DEAC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 19:53:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbiBATxn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Feb 2022 14:53:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51866 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbiBATxn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2022 14:53:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB87C6167B
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 19:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BE0C340EB;
        Tue,  1 Feb 2022 19:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643745222;
        bh=qJhcDFNKUp2poBTc+DZ04JJN0iB4ucZSLX/L8zj1k0g=;
        h=Date:To:From:Subject:From;
        b=NOHLW/FZohG+jaChboxOQyaMZJMr3O2ERZpekbPsTaJGx4stoIjPZ/EPXkbY6TUum
         Ux3+4aqRYi/4TPdgFtSlNjbyVG+qvBCTQN4U9PcBTH5TYa5DrbwWeHucTXN7Uns6PZ
         uJU/UMCmLIhPwtV7kEEoUY/EtjsTMYN4zZQas/Gg=
Received: by hp1 (sSMTP sendmail emulation); Tue, 01 Feb 2022 11:53:40 -0800
Date:   Tue, 01 Feb 2022 11:53:40 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rcampbell@nvidia.com, jglisse@redhat.com, jgg@nvidia.com,
        hch@lst.de, Felix.Kuehling@amd.com, apopple@nvidia.com,
        alex.sierra@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-zone-device-coherent-type-memory-support.patch added to -mm tree
Message-Id: <20220201195341.09BE0C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add zone device coherent type memory support
has been added to the -mm tree.  Its filename is
     mm-add-zone-device-coherent-type-memory-support.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-add-zone-device-coherent-type-memory-support.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-add-zone-device-coherent-type-memory-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Sierra <alex.sierra@amd.com>
Subject: mm: add zone device coherent type memory support

Patch series "Add MEMORY_DEVICE_COHERENT for coherent device memory mapping", v6.

This patch series introduces MEMORY_DEVICE_COHERENT, a type of memory
owned by a device that can be mapped into CPU page tables like
MEMORY_DEVICE_GENERIC and can also be migrated like MEMORY_DEVICE_PRIVATE.

the Tsuggestion to incorporate Ralph Campbells refcount cleanup patch into
our hardware page migration patchset originally came from Christoph, but
it proved impractical to do things in that order because the refcount
cleanup introduced a bug with wide ranging structural implications. 
Instead, we amended Ralph's patch so that it could be applied after
merging the migration work.  As we saw from the recent discussion, merging
the refcount work is going to take some time and cooperation between
multiple development groups, while the migration work is ready now and is
needed now.  So we propose to merge this patchset first and continue to
work with Ralph and others to merge the refcount cleanup separately, when
it is ready.

This patch series is mostly self-contained except for a few places where
it needs to update other subsystems to handle the new memory type.

System stability and performance are not affected according to our ongoing
testing, including xfstests.

How it works: The system BIOS advertises the GPU device memory (aka VRAM)
as SPM (special purpose memory) in the UEFI system address map.

The amdgpu driver registers the memory with devmap as
MEMORY_DEVICE_COHERENT using devm_memremap_pages.  The initial user for
this hardware page migration capability is the Frontier supercomputer
project.  This functionality is not AMD-specific.  We expect other GPU
vendors to find this functionality useful, and possibly other hardware
types in the future.

Our test nodes in the lab are similar to the Frontier configuration, with
.5 TB of system memory plus 256 GB of device memory split across 4 GPUs,
all in a single coherent address space.  Page migration is expected to
improve application efficiency significantly.  We will report empirical
results as they become available.

We extended hmm_test to cover migration of MEMORY_DEVICE_COHERENT.  This
patch set builds on HMM and our SVM memory manager already merged in 5.15.


This patch (of 10):

Device memory that is cache coherent from device and CPU point of view. 
This is used on platforms that have an advanced system bus (like CAPI or
CXL).  Any page of a process can be migrated to such memory.  However, no
one should be allowed to pin such memory so that it can always be evicted.

Link: https://lkml.kernel.org/r/20220201154901.7921-1-alex.sierra@amd.com
Link: https://lkml.kernel.org/r/20220201154901.7921-2-alex.sierra@amd.com
Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memremap.h |    8 ++++++
 include/linux/mm.h       |   16 +++++++++++++
 mm/memcontrol.c          |    6 ++--
 mm/memory-failure.c      |    8 ++++--
 mm/memremap.c            |   14 ++++++++++-
 mm/migrate.c             |   45 ++++++++++++++++++-------------------
 mm/rmap.c                |    5 ++--
 7 files changed, 71 insertions(+), 31 deletions(-)

--- a/include/linux/memremap.h~mm-add-zone-device-coherent-type-memory-support
+++ a/include/linux/memremap.h
@@ -39,6 +39,13 @@ struct vmem_altmap {
  * A more complete discussion of unaddressable memory may be found in
  * include/linux/hmm.h and Documentation/vm/hmm.rst.
  *
+ * MEMORY_DEVICE_COHERENT:
+ * Device memory that is cache coherent from device and CPU point of view. This
+ * is used on platforms that have an advanced system bus (like CAPI or CXL). A
+ * driver can hotplug the device memory using ZONE_DEVICE and with that memory
+ * type. Any page of a process can be migrated to such memory. However no one
+ * should be allowed to pin such memory so that it can always be evicted.
+ *
  * MEMORY_DEVICE_FS_DAX:
  * Host memory that has similar access semantics as System RAM i.e. DMA
  * coherent and supports page pinning. In support of coordinating page
@@ -59,6 +66,7 @@ struct vmem_altmap {
 enum memory_type {
 	/* 0 is reserved to catch uninitialized type fields */
 	MEMORY_DEVICE_PRIVATE = 1,
+	MEMORY_DEVICE_COHERENT,
 	MEMORY_DEVICE_FS_DAX,
 	MEMORY_DEVICE_GENERIC,
 	MEMORY_DEVICE_PCI_P2PDMA,
--- a/include/linux/mm.h~mm-add-zone-device-coherent-type-memory-support
+++ a/include/linux/mm.h
@@ -1101,6 +1101,7 @@ static inline bool page_is_devmap_manage
 		return false;
 	switch (page->pgmap->type) {
 	case MEMORY_DEVICE_PRIVATE:
+	case MEMORY_DEVICE_COHERENT:
 	case MEMORY_DEVICE_FS_DAX:
 		return true;
 	default:
@@ -1130,6 +1131,21 @@ static inline bool is_device_private_pag
 		page->pgmap->type == MEMORY_DEVICE_PRIVATE;
 }
 
+static inline bool is_device_coherent_page(const struct page *page)
+{
+	return IS_ENABLED(CONFIG_DEV_PAGEMAP_OPS) &&
+		is_zone_device_page(page) &&
+		page->pgmap->type == MEMORY_DEVICE_COHERENT;
+}
+
+static inline bool is_dev_private_or_coherent_page(const struct page *page)
+{
+	return IS_ENABLED(CONFIG_DEV_PAGEMAP_OPS) &&
+		is_zone_device_page(page) &&
+		(page->pgmap->type == MEMORY_DEVICE_PRIVATE ||
+		page->pgmap->type == MEMORY_DEVICE_COHERENT);
+}
+
 static inline bool is_pci_p2pdma_page(const struct page *page)
 {
 	return IS_ENABLED(CONFIG_DEV_PAGEMAP_OPS) &&
--- a/mm/memcontrol.c~mm-add-zone-device-coherent-type-memory-support
+++ a/mm/memcontrol.c
@@ -5681,8 +5681,8 @@ out:
  *   2(MC_TARGET_SWAP): if the swap entry corresponding to this pte is a
  *     target for charge migration. if @target is not NULL, the entry is stored
  *     in target->ent.
- *   3(MC_TARGET_DEVICE): like MC_TARGET_PAGE  but page is MEMORY_DEVICE_PRIVATE
- *     (so ZONE_DEVICE page and thus not on the lru).
+ *   3(MC_TARGET_DEVICE): like MC_TARGET_PAGE  but page is device memory and
+ *   thus not on the lru.
  *     For now we such page is charge like a regular page would be as for all
  *     intent and purposes it is just special memory taking the place of a
  *     regular page.
@@ -5716,7 +5716,7 @@ static enum mc_target_type get_mctgt_typ
 		 */
 		if (page_memcg(page) == mc.from) {
 			ret = MC_TARGET_PAGE;
-			if (is_device_private_page(page))
+			if (is_dev_private_or_coherent_page(page))
 				ret = MC_TARGET_DEVICE;
 			if (target)
 				target->page = page;
--- a/mm/memory-failure.c~mm-add-zone-device-coherent-type-memory-support
+++ a/mm/memory-failure.c
@@ -1619,12 +1619,16 @@ static int memory_failure_dev_pagemap(un
 		goto unlock;
 	}
 
-	if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
+	switch (pgmap->type) {
+	case MEMORY_DEVICE_PRIVATE:
+	case MEMORY_DEVICE_COHERENT:
 		/*
-		 * TODO: Handle HMM pages which may need coordination
+		 * TODO: Handle device pages which may need coordination
 		 * with device-side memory.
 		 */
 		goto unlock;
+	default:
+		break;
 	}
 
 	/*
--- a/mm/memremap.c~mm-add-zone-device-coherent-type-memory-support
+++ a/mm/memremap.c
@@ -44,6 +44,7 @@ EXPORT_SYMBOL(devmap_managed_key);
 static void devmap_managed_enable_put(struct dev_pagemap *pgmap)
 {
 	if (pgmap->type == MEMORY_DEVICE_PRIVATE ||
+	    pgmap->type == MEMORY_DEVICE_COHERENT ||
 	    pgmap->type == MEMORY_DEVICE_FS_DAX)
 		static_branch_dec(&devmap_managed_key);
 }
@@ -51,6 +52,7 @@ static void devmap_managed_enable_put(st
 static void devmap_managed_enable_get(struct dev_pagemap *pgmap)
 {
 	if (pgmap->type == MEMORY_DEVICE_PRIVATE ||
+	    pgmap->type == MEMORY_DEVICE_COHERENT ||
 	    pgmap->type == MEMORY_DEVICE_FS_DAX)
 		static_branch_inc(&devmap_managed_key);
 }
@@ -348,6 +350,16 @@ void *memremap_pages(struct dev_pagemap
 			return ERR_PTR(-EINVAL);
 		}
 		break;
+	case MEMORY_DEVICE_COHERENT:
+		if (!pgmap->ops->page_free) {
+			WARN(1, "Missing page_free method\n");
+			return ERR_PTR(-EINVAL);
+		}
+		if (!pgmap->owner) {
+			WARN(1, "Missing owner\n");
+			return ERR_PTR(-EINVAL);
+		}
+		break;
 	case MEMORY_DEVICE_FS_DAX:
 		if (!IS_ENABLED(CONFIG_ZONE_DEVICE) ||
 		    IS_ENABLED(CONFIG_FS_DAX_LIMITED)) {
@@ -490,7 +502,7 @@ EXPORT_SYMBOL_GPL(get_dev_pagemap);
 void free_devmap_managed_page(struct page *page)
 {
 	/* notify page idle for dax */
-	if (!is_device_private_page(page)) {
+	if (!is_dev_private_or_coherent_page(page)) {
 		wake_up_var(&page->_refcount);
 		return;
 	}
--- a/mm/migrate.c~mm-add-zone-device-coherent-type-memory-support
+++ a/mm/migrate.c
@@ -347,7 +347,7 @@ static int expected_page_refs(struct add
 	 * Device private pages have an extra refcount as they are
 	 * ZONE_DEVICE pages.
 	 */
-	expected_count += is_device_private_page(page);
+	expected_count += is_dev_private_or_coherent_page(page);
 	if (mapping)
 		expected_count += compound_nr(page) + page_has_private(page);
 
@@ -2612,7 +2612,7 @@ EXPORT_SYMBOL(migrate_vma_setup);
  *     handle_pte_fault()
  *       do_anonymous_page()
  * to map in an anonymous zero page but the struct page will be a ZONE_DEVICE
- * private page.
+ * private or coherent page.
  */
 static void migrate_vma_insert_page(struct migrate_vma *migrate,
 				    unsigned long addr,
@@ -2677,25 +2677,24 @@ static void migrate_vma_insert_page(stru
 	 */
 	__SetPageUptodate(page);
 
-	if (is_zone_device_page(page)) {
-		if (is_device_private_page(page)) {
-			swp_entry_t swp_entry;
+	if (is_device_private_page(page)) {
+		swp_entry_t swp_entry;
 
-			if (vma->vm_flags & VM_WRITE)
-				swp_entry = make_writable_device_private_entry(
-							page_to_pfn(page));
-			else
-				swp_entry = make_readable_device_private_entry(
-							page_to_pfn(page));
-			entry = swp_entry_to_pte(swp_entry);
-		} else {
-			/*
-			 * For now we only support migrating to un-addressable
-			 * device memory.
-			 */
-			pr_warn_once("Unsupported ZONE_DEVICE page type.\n");
-			goto abort;
-		}
+		if (vma->vm_flags & VM_WRITE)
+			swp_entry = make_writable_device_private_entry(
+						page_to_pfn(page));
+		else
+			swp_entry = make_readable_device_private_entry(
+						page_to_pfn(page));
+		entry = swp_entry_to_pte(swp_entry);
+	} else if (is_zone_device_page(page) &&
+		   !is_device_coherent_page(page)) {
+		/*
+		 * We support migrating to private and coherent types
+		 * for device zone memory.
+		 */
+		pr_warn_once("Unsupported ZONE_DEVICE page type.\n");
+		goto abort;
 	} else {
 		entry = mk_pte(page, vma->vm_page_prot);
 		if (vma->vm_flags & VM_WRITE)
@@ -2797,10 +2796,10 @@ void migrate_vma_pages(struct migrate_vm
 		mapping = page_mapping(page);
 
 		if (is_zone_device_page(newpage)) {
-			if (is_device_private_page(newpage)) {
+			if (is_dev_private_or_coherent_page(newpage)) {
 				/*
-				 * For now only support private anonymous when
-				 * migrating to un-addressable device memory.
+				 * For now only support private and coherent
+				 * anonymous when migrating to device memory.
 				 */
 				if (mapping) {
 					migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
--- a/mm/rmap.c~mm-add-zone-device-coherent-type-memory-support
+++ a/mm/rmap.c
@@ -1860,7 +1860,7 @@ static bool try_to_migrate_one(struct pa
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
 
-		if (is_zone_device_page(page)) {
+		if (is_device_private_page(page)) {
 			unsigned long pfn = page_to_pfn(page);
 			swp_entry_t entry;
 			pte_t swp_pte;
@@ -2005,7 +2005,8 @@ void try_to_migrate(struct page *page, e
 					TTU_SYNC)))
 		return;
 
-	if (is_zone_device_page(page) && !is_device_private_page(page))
+	if (is_zone_device_page(page) &&
+	    !is_dev_private_or_coherent_page(page))
 		return;
 
 	/*
_

Patches currently in -mm which might be from alex.sierra@amd.com are

mm-add-zone-device-coherent-type-memory-support.patch
mm-add-device-coherent-vma-selection-for-memory-migration.patch
mm-gup-fail-get_user_pages-for-longterm-dev-coherent-type.patch
drm-amdkfd-add-spm-support-for-svm.patch
drm-amdkfd-coherent-type-as-sys-mem-on-migration-to-ram.patch
lib-test_hmm-add-ioctl-to-get-zone-device-type.patch
lib-test_hmm-add-module-param-for-zone-device-type.patch
lib-add-support-for-device-coherent-type-in-test_hmm.patch
tools-update-hmm-test-to-support-device-coherent-type.patch
tools-update-test_hmm-script-to-support-sp-config.patch

