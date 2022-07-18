Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AEDEC43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbiGRAQd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiGRAQ2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:16:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B363A95BD
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:16:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4456360F1A
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F5DC341CA;
        Mon, 18 Jul 2022 00:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103386;
        bh=1ftJ+eN/T1zlLjfBw6ot0P6k1LdcSloDQU+g5RNT7LM=;
        h=Date:To:From:Subject:From;
        b=ww6Q0SXvv8dTgWhSBiGNLxKAdw8YRWj31w2h8ZHL1MUnhFk0BPDKYps+/NyLnst3R
         k6Tu0ob7RKEltXBZlboWVjl4ojYhf1pR5FVR3c1/NxTnM8hNq4hVieyFG95br0FUz6
         Z7u7RchP7ppmXPHmaxIitME6RgVMrDMIAinN1xUM=
Date:   Sun, 17 Jul 2022 17:16:25 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rcampbell@nvidia.com, jglisse@redhat.com, jgg@nvidia.com,
        hch@lst.de, Felix.Kuehling@amd.com, david@redhat.com,
        apopple@nvidia.com, alex.sierra@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-zone-device-coherent-type-memory-support.patch removed from -mm tree
Message-Id: <20220718001626.93F5DC341CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add zone device coherent type memory support
has been removed from the -mm tree.  Its filename was
     mm-add-zone-device-coherent-type-memory-support.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alex Sierra <alex.sierra@amd.com>
Subject: mm: add zone device coherent type memory support
Date: Fri, 15 Jul 2022 10:05:10 -0500

Device memory that is cache coherent from device and CPU point of view. 
This is used on platforms that have an advanced system bus (like CAPI or
CXL).  Any page of a process can be migrated to such memory.  However, no
one should be allowed to pin such memory so that it can always be evicted.

[hch@lst.de: rebased ontop of the refcount changes, remove is_dev_private_or_coherent_page]
Link: https://lkml.kernel.org/r/20220715150521.18165-4-alex.sierra@amd.com
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

 include/linux/memremap.h |   19 +++++++++++++++++++
 include/linux/mm.h       |    5 ++++-
 mm/memcontrol.c          |    7 ++++---
 mm/memory-failure.c      |    8 ++++++--
 mm/memremap.c            |   10 ++++++++++
 mm/migrate_device.c      |   16 +++++++---------
 mm/rmap.c                |    5 +++--
 7 files changed, 53 insertions(+), 17 deletions(-)

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
@@ -150,6 +158,17 @@ static inline bool is_pci_p2pdma_page(co
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
 #ifdef CONFIG_ZONE_DEVICE
 void *memremap_pages(struct dev_pagemap *pgmap, int nid);
 void memunmap_pages(struct dev_pagemap *pgmap);
--- a/include/linux/mm.h~mm-add-zone-device-coherent-type-memory-support
+++ a/include/linux/mm.h
@@ -28,6 +28,7 @@
 #include <linux/sched.h>
 #include <linux/pgtable.h>
 #include <linux/kasan.h>
+#include <linux/memremap.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -1537,7 +1538,9 @@ static inline bool is_longterm_pinnable_
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
@@ -1953,7 +1953,7 @@ static bool try_to_migrate_one(struct fo
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
 
-		if (folio_is_zone_device(folio)) {
+		if (folio_is_device_private(folio)) {
 			unsigned long pfn = folio_pfn(folio);
 			swp_entry_t entry;
 			pte_t swp_pte;
@@ -2124,7 +2124,8 @@ void try_to_migrate(struct folio *folio,
 					TTU_SYNC)))
 		return;
 
-	if (folio_is_zone_device(folio) && !folio_is_device_private(folio))
+	if (folio_is_zone_device(folio) &&
+	    (!folio_is_device_private(folio) && !folio_is_device_coherent(folio)))
 		return;
 
 	/*
_

Patches currently in -mm which might be from alex.sierra@amd.com are


