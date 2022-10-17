Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10463C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiJQASc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiJQAS0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:18:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B824B2A439
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:18:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B686B80E28
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9C7C433D6;
        Mon, 17 Oct 2022 00:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665965902;
        bh=46YXpLQHw1pYq2YveUBa+o86yROsw32P0wJcFt9HyRU=;
        h=Date:To:From:Subject:From;
        b=bBklNw9gjxFDB0db4d14bCaFznoyUxx+lF5RIKmCXslxhQ2jag2RbmrXcR364RDFQ
         DqFTk2mjlwBDeTfRa/MuUY8oWVLWi0lO2inC00wV0xj4knoA/2LjbPRWpec7NXLwHZ
         BdxLX/QJnrX1z+kXbNfsRgS1BA+S5D8WF9OzctAU=
Date:   Sun, 16 Oct 2022 17:18:21 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        willy@infradead.org, lyude@redhat.com, lkp@intel.com,
        kherbst@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        jgg@nvidia.com, jack@suse.cz, hch@lst.de, Felix.Kuehling@amd.com,
        djwong@kernel.org, david@fromorbit.com, daniel@ffwll.ch,
        christian.koenig@amd.com, bskeggs@redhat.com, apopple@nvidia.com,
        alexander.deucher@amd.com, airlied@linux.ie,
        dan.j.williams@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fsdax-introduce-dax_zap_mappings.patch added to mm-unstable branch
Message-Id: <20221017001821.EE9C7C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fsdax: introduce dax_zap_mappings()
has been added to the -mm mm-unstable branch.  Its filename is
     fsdax-introduce-dax_zap_mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fsdax-introduce-dax_zap_mappings.patch

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
Subject: fsdax: introduce dax_zap_mappings()
Date: Fri, 14 Oct 2022 16:57:19 -0700

Typical pages take a reference at pte insertion and drop it at
zap_pte_range() time.  That reference management is missing for DAX
leading to a situation where DAX pages are mapped in user page tables, but
are not referenced.

Once fsdax decides it wants to unmap the page it can drop its reference,
but unlike typical pages it needs to maintain the association of the page
to the inode that arbitrated the access in the first instance.  It
maintains that association until explicit truncate(), or the implicit
truncate() that occurs at inode death, truncate_inode_pages_final().

The zapped state tracks whether the fsdax has dropped its interest in a
page, but still allows the associated i_pages entry to live until
truncate.  This facilitates inode lookup while awaiting any page pin users
to drop their pins.  For example, if memory_failure() is triggered on the
page after it has been unmapped, but before it has been truncated from the
inode, memory_failure() can still associate the event with the inode.

Once truncate begins fsdax unmaps the page to prevent any new references
from being taken without calling back into fsdax core to reestablish the
mapping.

This approach relies on all paths that call truncate_inode_pages() to
first call dax_zap_mappings().  For that another bandaid is needed to add
this 'zap' step to the truncate_inode_pages_final() path, but that is
saved for a follow-on patch.

Link: https://lkml.kernel.org/r/166579183976.2236710.17370760087488536715.stgit@dwillia2-xfh.jf.intel.com
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

 fs/dax.c            |   72 +++++++++++++++++++++++++++++-------------
 fs/ext4/inode.c     |    2 -
 fs/fuse/dax.c       |    4 +-
 fs/xfs/xfs_file.c   |    2 -
 fs/xfs/xfs_inode.c  |    4 +-
 include/linux/dax.h |   11 ++++--
 6 files changed, 63 insertions(+), 32 deletions(-)

--- a/fs/dax.c~fsdax-introduce-dax_zap_mappings
+++ a/fs/dax.c
@@ -74,11 +74,12 @@ fs_initcall(init_dax_wait_table);
  * and EMPTY bits aren't set the entry is a normal DAX entry with a filesystem
  * block allocation.
  */
-#define DAX_SHIFT	(4)
+#define DAX_SHIFT	(5)
 #define DAX_LOCKED	(1UL << 0)
 #define DAX_PMD		(1UL << 1)
 #define DAX_ZERO_PAGE	(1UL << 2)
 #define DAX_EMPTY	(1UL << 3)
+#define DAX_ZAP		(1UL << 4)
 
 static unsigned long dax_to_pfn(void *entry)
 {
@@ -95,6 +96,11 @@ static bool dax_is_locked(void *entry)
 	return xa_to_value(entry) & DAX_LOCKED;
 }
 
+static bool dax_is_zapped(void *entry)
+{
+	return xa_to_value(entry) & DAX_ZAP;
+}
+
 static unsigned int dax_entry_order(void *entry)
 {
 	if (xa_to_value(entry) & DAX_PMD)
@@ -407,19 +413,6 @@ static void dax_disassociate_entry(void
 	}
 }
 
-static struct page *dax_busy_page(void *entry)
-{
-	unsigned long pfn;
-
-	for_each_mapped_pfn(entry, pfn) {
-		struct page *page = pfn_to_page(pfn);
-
-		if (!dax_page_idle(page))
-			return page;
-	}
-	return NULL;
-}
-
 /*
  * dax_lock_page - Lock the DAX entry corresponding to a page
  * @page: The page whose entry we want to lock
@@ -664,8 +657,43 @@ fallback:
 	return xa_mk_internal(VM_FAULT_FALLBACK);
 }
 
+static void *dax_zap_entry(struct xa_state *xas, void *entry)
+{
+	unsigned long v = xa_to_value(entry);
+
+	return xas_store(xas, xa_mk_value(v | DAX_ZAP));
+}
+
+/**
+ * Return NULL if the entry is zapped and all pages in the entry are
+ * idle, otherwise return the non-idle page in the entry
+ */
+static struct page *dax_zap_pages(struct xa_state *xas, void *entry)
+{
+	struct page *ret = NULL;
+	unsigned long pfn;
+	bool zap;
+
+	if (!dax_entry_size(entry))
+		return NULL;
+
+	zap = !dax_is_zapped(entry);
+
+	for_each_mapped_pfn(entry, pfn) {
+		struct page *page = pfn_to_page(pfn);
+
+		if (!ret && !dax_page_idle(page))
+			ret = page;
+	}
+
+	if (zap)
+		dax_zap_entry(xas, entry);
+
+	return ret;
+}
+
 /**
- * dax_layout_busy_page_range - find first pinned page in @mapping
+ * dax_zap_mappings_range - find first pinned page in @mapping
  * @mapping: address space to scan for a page with ref count > 1
  * @start: Starting offset. Page containing 'start' is included.
  * @end: End offset. Page containing 'end' is included. If 'end' is LLONG_MAX,
@@ -682,8 +710,8 @@ fallback:
  * to be able to run unmap_mapping_range() and subsequently not race
  * mapping_mapped() becoming true.
  */
-struct page *dax_layout_busy_page_range(struct address_space *mapping,
-					loff_t start, loff_t end)
+struct page *dax_zap_mappings_range(struct address_space *mapping, loff_t start,
+				    loff_t end)
 {
 	void *entry;
 	unsigned int scanned = 0;
@@ -727,7 +755,7 @@ struct page *dax_layout_busy_page_range(
 		if (unlikely(dax_is_locked(entry)))
 			entry = get_unlocked_entry(&xas, 0);
 		if (entry)
-			page = dax_busy_page(entry);
+			page = dax_zap_pages(&xas, entry);
 		put_unlocked_entry(&xas, entry, WAKE_NEXT);
 		if (page)
 			break;
@@ -742,13 +770,13 @@ struct page *dax_layout_busy_page_range(
 	xas_unlock_irq(&xas);
 	return page;
 }
-EXPORT_SYMBOL_GPL(dax_layout_busy_page_range);
+EXPORT_SYMBOL_GPL(dax_zap_mappings_range);
 
-struct page *dax_layout_busy_page(struct address_space *mapping)
+struct page *dax_zap_mappings(struct address_space *mapping)
 {
-	return dax_layout_busy_page_range(mapping, 0, LLONG_MAX);
+	return dax_zap_mappings_range(mapping, 0, LLONG_MAX);
 }
-EXPORT_SYMBOL_GPL(dax_layout_busy_page);
+EXPORT_SYMBOL_GPL(dax_zap_mappings);
 
 static int __dax_invalidate_entry(struct address_space *mapping,
 					  pgoff_t index, bool trunc)
--- a/fs/ext4/inode.c~fsdax-introduce-dax_zap_mappings
+++ a/fs/ext4/inode.c
@@ -3964,7 +3964,7 @@ int ext4_break_layouts(struct inode *ino
 		return -EINVAL;
 
 	do {
-		page = dax_layout_busy_page(inode->i_mapping);
+		page = dax_zap_mappings(inode->i_mapping);
 		if (!page)
 			return 0;
 
--- a/fs/fuse/dax.c~fsdax-introduce-dax_zap_mappings
+++ a/fs/fuse/dax.c
@@ -443,7 +443,7 @@ static int fuse_setup_new_dax_mapping(st
 
 	/*
 	 * Can't do inline reclaim in fault path. We call
-	 * dax_layout_busy_page() before we free a range. And
+	 * dax_zap_mappings() before we free a range. And
 	 * fuse_wait_dax_page() drops mapping->invalidate_lock and requires it.
 	 * In fault path we enter with mapping->invalidate_lock held and can't
 	 * drop it. Also in fault path we hold mapping->invalidate_lock shared
@@ -671,7 +671,7 @@ static int __fuse_dax_break_layouts(stru
 {
 	struct page *page;
 
-	page = dax_layout_busy_page_range(inode->i_mapping, start, end);
+	page = dax_zap_mappings_range(inode->i_mapping, start, end);
 	if (!page)
 		return 0;
 
--- a/fs/xfs/xfs_file.c~fsdax-introduce-dax_zap_mappings
+++ a/fs/xfs/xfs_file.c
@@ -822,7 +822,7 @@ xfs_break_dax_layouts(
 
 	ASSERT(xfs_isilocked(XFS_I(inode), XFS_MMAPLOCK_EXCL));
 
-	page = dax_layout_busy_page(inode->i_mapping);
+	page = dax_zap_mappings(inode->i_mapping);
 	if (!page)
 		return 0;
 
--- a/fs/xfs/xfs_inode.c~fsdax-introduce-dax_zap_mappings
+++ a/fs/xfs/xfs_inode.c
@@ -3480,8 +3480,8 @@ again:
 	 * need to unlock & lock the XFS_MMAPLOCK_EXCL which is not suitable
 	 * for this nested lock case.
 	 */
-	page = dax_layout_busy_page(VFS_I(ip2)->i_mapping);
-	if (page && page_ref_count(page) != 1) {
+	page = dax_zap_mappings(VFS_I(ip2)->i_mapping);
+	if (page) {
 		xfs_iunlock(ip2, XFS_MMAPLOCK_EXCL);
 		xfs_iunlock(ip1, XFS_MMAPLOCK_EXCL);
 		goto again;
--- a/include/linux/dax.h~fsdax-introduce-dax_zap_mappings
+++ a/include/linux/dax.h
@@ -157,8 +157,9 @@ static inline void fs_put_dax(struct dax
 int dax_writeback_mapping_range(struct address_space *mapping,
 		struct dax_device *dax_dev, struct writeback_control *wbc);
 
-struct page *dax_layout_busy_page(struct address_space *mapping);
-struct page *dax_layout_busy_page_range(struct address_space *mapping, loff_t start, loff_t end);
+struct page *dax_zap_mappings(struct address_space *mapping);
+struct page *dax_zap_mappings_range(struct address_space *mapping, loff_t start,
+				    loff_t end);
 dax_entry_t dax_lock_page(struct page *page);
 void dax_unlock_page(struct page *page, dax_entry_t cookie);
 dax_entry_t dax_lock_mapping_entry(struct address_space *mapping,
@@ -166,12 +167,14 @@ dax_entry_t dax_lock_mapping_entry(struc
 void dax_unlock_mapping_entry(struct address_space *mapping,
 		unsigned long index, dax_entry_t cookie);
 #else
-static inline struct page *dax_layout_busy_page(struct address_space *mapping)
+static inline struct page *dax_zap_mappings(struct address_space *mapping)
 {
 	return NULL;
 }
 
-static inline struct page *dax_layout_busy_page_range(struct address_space *mapping, pgoff_t start, pgoff_t nr_pages)
+static inline struct page *dax_zap_mappings_range(struct address_space *mapping,
+						  pgoff_t start,
+						  pgoff_t nr_pages)
 {
 	return NULL;
 }
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

