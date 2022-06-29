Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A27CCA47C
	for <mm-commits@archiver.kernel.org>; Wed, 29 Jun 2022 23:34:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbiF2Xe2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Jun 2022 19:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbiF2XeP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jun 2022 19:34:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E305F403E8
        for <mm-commits@vger.kernel.org>; Wed, 29 Jun 2022 16:33:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3331B61E1E
        for <mm-commits@vger.kernel.org>; Wed, 29 Jun 2022 23:33:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843E1C34114;
        Wed, 29 Jun 2022 23:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656545622;
        bh=5829C0zGiPX0Tz137VxpCsObr7znUJjIw1WWSRuKvno=;
        h=Date:To:From:Subject:From;
        b=LhepRL9rY9Ig4c0MuQNML1kS0qsUrPulhrXoJbeFQUndTPk/x1RLMIjULD40CEUh0
         gElAkWQbYEXOLONmOfY5rC4wSod2ctlKNMyPb/Ie5C7TBljGsFT9+8WGFsSKvXp27F
         J+Be5I5OpICljIG1ZgCk2XfNGrDdvg4edffCZ7aI=
Date:   Wed, 29 Jun 2022 16:33:41 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rcampbell@nvidia.com, jglisse@redhat.com, jgg@nvidia.com,
        hch@lst.de, Felix.Kuehling@amd.com, david@redhat.com,
        apopple@nvidia.com, alex.sierra@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-zone-device-coherent-type-memory-support.patch added to mm-unstable branch
Message-Id: <20220629233342.843E1C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add zone device coherent type memory support
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-zone-device-coherent-type-memory-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-zone-device-coherent-type-memory-support.patch

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
From: Alex Sierra <alex.sierra@amd.com>
Subject: mm: add zone device coherent type memory support
Date: Tue, 28 Jun 2022 22:54:14 -0500

Device memory that is cache coherent from device and CPU point of view. 
This is used on platforms that have an advanced system bus (like CAPI or
CXL).  Any page of a process can be migrated to such memory.  However, no
one should be allowed to pin such memory so that it can always be evicted.

[hch@lst.de: rebased ontop of the refcount changes, removed is_dev_private_or_coherent_page]
Link: https://lkml.kernel.org/r/20220629035426.20013-3-alex.sierra@amd.com
Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memremap.h |   22 +++++++++++++++++++++-
 mm/memcontrol.c          |    7 ++++---
 mm/memory-failure.c      |    8 ++++++--
 mm/memremap.c            |   10 ++++++++++
 mm/migrate_device.c      |   16 +++++++---------
 mm/rmap.c                |    5 +++--
 6 files changed, 51 insertions(+), 17 deletions(-)

--- a/include/linux/memremap.h~mm-add-zone-device-coherent-type-memory-support
+++ a/include/linux/memremap.h
@@ -41,6 +41,13 @@ struct vmem_altmap {
  * A more complete discussion of unaddressable memory may be found in
  * include/linux/hmm.h and Documentation/mm/hmm.rst.
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
@@ -61,6 +68,7 @@ struct vmem_altmap {
 enum memory_type {
 	/* 0 is reserved to catch uninitialized type fields */
 	MEMORY_DEVICE_PRIVATE = 1,
+	MEMORY_DEVICE_COHERENT,
 	MEMORY_DEVICE_FS_DAX,
 	MEMORY_DEVICE_GENERIC,
 	MEMORY_DEVICE_PCI_P2PDMA,
@@ -143,6 +151,17 @@ static inline bool folio_is_device_priva
 	return is_device_private_page(&folio->page);
 }
 
+static inline bool is_device_coherent_page(const struct page *page)
+{
+	return is_zone_device_page(page) &&
+		page->pgmap->type == MEMORY_DEVICE_COHERENT;
+}
+
+static inline bool folio_is_device_coherent(const struct folio *folio)
+{
+	return is_device_coherent_page(&folio->page);
+}
+
 static inline bool is_pci_p2pdma_page(const struct page *page)
 {
 	return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
@@ -160,7 +179,8 @@ static inline bool is_longterm_pinnable_
 	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
 		return false;
 #endif
-	return !(is_zone_movable_page(page) ||
+	return !(is_device_coherent_page(page) ||
+		 is_zone_movable_page(page) ||
 		 is_zero_pfn(page_to_pfn(page)));
 }
 #else
--- a/mm/memcontrol.c~mm-add-zone-device-coherent-type-memory-support
+++ a/mm/memcontrol.c
@@ -5716,8 +5716,8 @@ out:
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
@@ -5755,7 +5755,8 @@ static enum mc_target_type get_mctgt_typ
 		 */
 		if (page_memcg(page) == mc.from) {
 			ret = MC_TARGET_PAGE;
-			if (is_device_private_page(page))
+			if (is_device_private_page(page) ||
+			    is_device_coherent_page(page))
 				ret = MC_TARGET_DEVICE;
 			if (target)
 				target->page = page;
--- a/mm/memory-failure.c~mm-add-zone-device-coherent-type-memory-support
+++ a/mm/memory-failure.c
@@ -1685,12 +1685,16 @@ static int memory_failure_dev_pagemap(un
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
@@ -315,6 +315,16 @@ void *memremap_pages(struct dev_pagemap
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
 		if (IS_ENABLED(CONFIG_FS_DAX_LIMITED)) {
 			WARN(1, "File system DAX not supported\n");
--- a/mm/migrate_device.c~mm-add-zone-device-coherent-type-memory-support
+++ a/mm/migrate_device.c
@@ -518,7 +518,7 @@ EXPORT_SYMBOL(migrate_vma_setup);
  *     handle_pte_fault()
  *       do_anonymous_page()
  * to map in an anonymous zero page but the struct page will be a ZONE_DEVICE
- * private page.
+ * private or coherent page.
  */
 static void migrate_vma_insert_page(struct migrate_vma *migrate,
 				    unsigned long addr,
@@ -594,11 +594,8 @@ static void migrate_vma_insert_page(stru
 						page_to_pfn(page));
 		entry = swp_entry_to_pte(swp_entry);
 	} else {
-		/*
-		 * For now we only support migrating to un-addressable device
-		 * memory.
-		 */
-		if (is_zone_device_page(page)) {
+		if (is_zone_device_page(page) &&
+		    !is_device_coherent_page(page)) {
 			pr_warn_once("Unsupported ZONE_DEVICE page type.\n");
 			goto abort;
 		}
@@ -701,10 +698,11 @@ void migrate_vma_pages(struct migrate_vm
 
 		mapping = page_mapping(page);
 
-		if (is_device_private_page(newpage)) {
+		if (is_device_private_page(newpage) ||
+		    is_device_coherent_page(newpage)) {
 			/*
-			 * For now only support private anonymous when migrating
-			 * to un-addressable device memory.
+			 * For now only support anonymous memory migrating to
+			 * device private or coherent memory.
 			 */
 			if (mapping) {
 				migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
--- a/mm/rmap.c~mm-add-zone-device-coherent-type-memory-support
+++ a/mm/rmap.c
@@ -1972,7 +1972,7 @@ static bool try_to_migrate_one(struct fo
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
 
-		if (folio_is_zone_device(folio)) {
+		if (folio_is_device_private(folio)) {
 			unsigned long pfn = folio_pfn(folio);
 			swp_entry_t entry;
 			pte_t swp_pte;
@@ -2138,7 +2138,8 @@ void try_to_migrate(struct folio *folio,
 					TTU_SYNC)))
 		return;
 
-	if (folio_is_zone_device(folio) && !folio_is_device_private(folio))
+	if (folio_is_zone_device(folio) &&
+	    (!folio_is_device_private(folio) && !folio_is_device_coherent(folio)))
 		return;
 
 	/*
_

Patches currently in -mm which might be from alex.sierra@amd.com are

mm-rename-is_pinnable_pages-to-is_pinnable_longterm_pages.patch
mm-add-zone-device-coherent-type-memory-support.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages.patch
mm-add-device-coherent-vma-selection-for-memory-migration.patch
drm-amdkfd-add-spm-support-for-svm.patch
lib-test_hmm-add-ioctl-to-get-zone-device-type.patch
lib-test_hmm-add-module-param-for-zone-device-type.patch
lib-add-support-for-device-coherent-type-in-test_hmm.patch
tools-update-hmm-test-to-support-device-coherent-type.patch
tools-update-test_hmm-script-to-support-sp-config.patch
tools-add-hmm-gup-tests-for-device-coherent-type.patch
tools-add-selftests-to-hmm-for-cow-in-device-memory.patch

