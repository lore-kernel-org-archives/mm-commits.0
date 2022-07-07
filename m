Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC91C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jul 2022 19:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236301AbiGGTyP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jul 2022 15:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235918AbiGGTyL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jul 2022 15:54:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD472326F8
        for <mm-commits@vger.kernel.org>; Thu,  7 Jul 2022 12:54:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7666CB823F9
        for <mm-commits@vger.kernel.org>; Thu,  7 Jul 2022 19:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1849BC3411E;
        Thu,  7 Jul 2022 19:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657223648;
        bh=U0e0vY4h7jpyYiFqSf22BkuavdPi7HmjkEUxyU5+4Ww=;
        h=Date:To:From:Subject:From;
        b=H5Rz9+OHKEhCdiSijjZUjZa/aZEcWRzrY8rGwZOdkQboSGBf6pGn2BWWKb0AxS8vv
         F8oYBfIiabPyxtoQU9Y6V/l4RKT3ec+gaPi2wkrH3Db5ffJlD9EsjN1zHJLd6mqP0i
         apjLfHm5iLR8c9W6Xk4xai4HPN4xYn0WJKbbQayo=
Date:   Thu, 07 Jul 2022 12:54:07 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rcampbell@nvidia.com, jglisse@redhat.com, jgg@nvidia.com,
        hch@lst.de, Felix.Kuehling@amd.com, david@redhat.com,
        apopple@nvidia.com, alex.sierra@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-zone-device-coherent-type-memory-support.patch added to mm-unstable branch
Message-Id: <20220707195408.1849BC3411E@smtp.kernel.org>
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
Date: Thu, 7 Jul 2022 14:03:37 -0500

Device memory that is cache coherent from device and CPU point of view. 
This is used on platforms that have an advanced system bus (like CAPI or
CXL).  Any page of a process can be migrated to such memory.  However, no
one should be allowed to pin such memory so that it can always be evicted.

[hch@lst.de: rebased ontop of the refcount changes, removed is_dev_private_or_coherent_page]
Link: https://lkml.kernel.org/r/20220707190349.9778-4-alex.sierra@amd.com
Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h        |    4 +++-
 include/linux/page_zone.h |   19 +++++++++++++++++++
 mm/memcontrol.c           |    7 ++++---
 mm/memory-failure.c       |    8 ++++++--
 mm/memremap.c             |   10 ++++++++++
 mm/migrate_device.c       |   16 +++++++---------
 mm/rmap.c                 |    5 +++--
 7 files changed, 52 insertions(+), 17 deletions(-)

--- a/include/linux/mm.h~mm-add-zone-device-coherent-type-memory-support
+++ a/include/linux/mm.h
@@ -1573,7 +1573,9 @@ static inline bool is_longterm_pinnable_
 	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
 		return false;
 #endif
-	return !is_zone_movable_page(page) || is_zero_pfn(page_to_pfn(page));
+	return !(is_device_coherent_page(page) ||
+		 is_zone_movable_page(page) ||
+		 is_zero_pfn(page_to_pfn(page)));
 }
 #else
 static inline bool is_longterm_pinnable_page(struct page *page)
--- a/include/linux/page_zone.h~mm-add-zone-device-coherent-type-memory-support
+++ a/include/linux/page_zone.h
@@ -59,6 +59,13 @@
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
@@ -79,6 +86,7 @@
 enum memory_type {
 	/* 0 is reserved to catch uninitialized type fields */
 	MEMORY_DEVICE_PRIVATE = 1,
+	MEMORY_DEVICE_COHERENT,
 	MEMORY_DEVICE_FS_DAX,
 	MEMORY_DEVICE_GENERIC,
 	MEMORY_DEVICE_PCI_P2PDMA,
@@ -191,4 +199,15 @@ static inline bool is_pci_p2pdma_page(co
 		page->pgmap->type == MEMORY_DEVICE_PCI_P2PDMA;
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
 #endif /* _PAGE_ZONE_H_ */
--- a/mm/memcontrol.c~mm-add-zone-device-coherent-type-memory-support
+++ a/mm/memcontrol.c
@@ -5715,8 +5715,8 @@ out:
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
@@ -5754,7 +5754,8 @@ static enum mc_target_type get_mctgt_typ
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
@@ -1686,12 +1686,16 @@ static int memory_failure_dev_pagemap(un
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
@@ -1968,7 +1968,7 @@ static bool try_to_migrate_one(struct fo
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
 
-		if (folio_is_zone_device(folio)) {
+		if (folio_is_device_private(folio)) {
 			unsigned long pfn = folio_pfn(folio);
 			swp_entry_t entry;
 			pte_t swp_pte;
@@ -2131,7 +2131,8 @@ void try_to_migrate(struct folio *folio,
 					TTU_SYNC)))
 		return;
 
-	if (folio_is_zone_device(folio) && !folio_is_device_private(folio))
+	if (folio_is_zone_device(folio) &&
+	    (!folio_is_device_private(folio) && !folio_is_device_coherent(folio)))
 		return;
 
 	/*
_

Patches currently in -mm which might be from alex.sierra@amd.com are

mm-rename-is_pinnable_pages-to-is_longterm_pinnable_pages.patch
mm-move-page-zone-helpers-into-new-header-specific-file.patch
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

