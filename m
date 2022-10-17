Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72168C43217
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiJQASs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiJQASq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:18:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF762A950
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:18:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B159B80D5C
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61A3C433D6;
        Mon, 17 Oct 2022 00:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665965914;
        bh=MaUBphdxY8a8FCsIzeob0g/sGJdh5+xUDEccGyCHj0E=;
        h=Date:To:From:Subject:From;
        b=yRz/D7+wvtUK5NK7Jjtff6BFrpuvnTcoVeI00eig8HKTLWUbTuYhMeqWVPZi9pYfY
         ETtTw4kFLiq6AaumFRpbnNo0VzUTMMF4Xb/vPsWtyhw6LBDwzvH5yRcXI1Vr7yOw0A
         Q9vvv+D47nzmIZLBIOoZeVJtlN2GksseANXJCNbo=
Date:   Sun, 16 Oct 2022 17:18:34 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        willy@infradead.org, lyude@redhat.com, lkp@intel.com,
        kherbst@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        jgg@nvidia.com, jack@suse.cz, hch@lst.de, Felix.Kuehling@amd.com,
        djwong@kernel.org, david@fromorbit.com, daniel@ffwll.ch,
        christian.koenig@amd.com, bskeggs@redhat.com, apopple@nvidia.com,
        alexander.deucher@amd.com, airlied@linux.ie,
        dan.j.williams@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fsdax-rework-for_each_mapped_pfn-to-dax_for_each_folio.patch added to mm-unstable branch
Message-Id: <20221017001834.D61A3C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fsdax: rework for_each_mapped_pfn() to dax_for_each_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     fsdax-rework-for_each_mapped_pfn-to-dax_for_each_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fsdax-rework-for_each_mapped_pfn-to-dax_for_each_folio.patch

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
Subject: fsdax: rework for_each_mapped_pfn() to dax_for_each_folio()
Date: Fri, 14 Oct 2022 16:57:49 -0700

In preparation for requesting folios from a pgmap, rework
for_each_mapped_pfn() to operate in terms of folios.

Link: https://lkml.kernel.org/r/166579186941.2236710.1345776454315696392.stgit@dwillia2-xfh.jf.intel.com
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

 .clang-format       |    1 
 fs/dax.c            |  102 ++++++++++++++++++++++++------------------
 include/linux/dax.h |    5 ++
 3 files changed, 66 insertions(+), 42 deletions(-)

--- a/.clang-format~fsdax-rework-for_each_mapped_pfn-to-dax_for_each_folio
+++ a/.clang-format
@@ -136,6 +136,7 @@ ForEachMacros:
   - 'data__for_each_file'
   - 'data__for_each_file_new'
   - 'data__for_each_file_start'
+  - 'dax_for_each_folio'
   - 'device_for_each_child_node'
   - 'displayid_iter_for_each'
   - 'dma_fence_array_for_each'
--- a/fs/dax.c~fsdax-rework-for_each_mapped_pfn-to-dax_for_each_folio
+++ a/fs/dax.c
@@ -327,18 +327,41 @@ static unsigned long dax_entry_size(void
 		return PAGE_SIZE;
 }
 
-static unsigned long dax_end_pfn(void *entry)
+/*
+ * Until fsdax constructs compound folios it needs to be prepared to
+ * support multiple folios per entry where each folio is a single page
+ */
+static struct folio *dax_entry_to_folio(void *entry, int idx)
 {
-	return dax_to_pfn(entry) + dax_entry_size(entry) / PAGE_SIZE;
+	unsigned long pfn, size = dax_entry_size(entry);
+	struct page *page;
+	struct folio *folio;
+
+	if (!size)
+		return NULL;
+
+	pfn = dax_to_pfn(entry);
+	page = pfn_to_page(pfn);
+	folio = page_folio(page);
+
+	/*
+	 * Are there multiple folios per entry, and has the iterator
+	 * passed the end of that set?
+	 */
+	if (idx >= size / folio_size(folio))
+		return NULL;
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(size, folio_size(folio)));
+
+	return page_folio(page + idx);
 }
 
 /*
- * Iterate through all mapped pfns represented by an entry, i.e. skip
- * 'empty' and 'zero' entries.
+ * Iterate through all folios associated with a given entry
  */
-#define for_each_mapped_pfn(entry, pfn) \
-	for (pfn = dax_to_pfn(entry); \
-			pfn < dax_end_pfn(entry); pfn++)
+#define dax_for_each_folio(entry, folio, i)                      \
+	for (i = 0, folio = dax_entry_to_folio(entry, i); folio; \
+	     folio = dax_entry_to_folio(entry, ++i))
 
 static inline bool dax_mapping_is_cow(struct address_space *mapping)
 {
@@ -348,18 +371,18 @@ static inline bool dax_mapping_is_cow(st
 /*
  * Set the page->mapping with FS_DAX_MAPPING_COW flag, increase the refcount.
  */
-static inline void dax_mapping_set_cow(struct page *page)
+static inline void dax_mapping_set_cow(struct folio *folio)
 {
-	if ((uintptr_t)page->mapping != PAGE_MAPPING_DAX_COW) {
+	if ((uintptr_t)folio->mapping != PAGE_MAPPING_DAX_COW) {
 		/*
-		 * Reset the index if the page was already mapped
+		 * Reset the index if the folio was already mapped
 		 * regularly before.
 		 */
-		if (page->mapping)
-			page->index = 1;
-		page->mapping = (void *)PAGE_MAPPING_DAX_COW;
+		if (folio->mapping)
+			folio->index = 1;
+		folio->mapping = (void *)PAGE_MAPPING_DAX_COW;
 	}
-	page->index++;
+	folio->index++;
 }
 
 /*
@@ -370,48 +393,45 @@ static inline void dax_mapping_set_cow(s
 static void dax_associate_entry(void *entry, struct address_space *mapping,
 		struct vm_area_struct *vma, unsigned long address, bool cow)
 {
-	unsigned long size = dax_entry_size(entry), pfn, index;
-	int i = 0;
+	unsigned long size = dax_entry_size(entry), index;
+	struct folio *folio;
+	int i;
 
 	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
 		return;
 
 	index = linear_page_index(vma, address & ~(size - 1));
-	for_each_mapped_pfn(entry, pfn) {
-		struct page *page = pfn_to_page(pfn);
-
+	dax_for_each_folio(entry, folio, i)
 		if (cow) {
-			dax_mapping_set_cow(page);
+			dax_mapping_set_cow(folio);
 		} else {
-			WARN_ON_ONCE(page->mapping);
-			page->mapping = mapping;
-			page->index = index + i++;
+			WARN_ON_ONCE(folio->mapping);
+			folio->mapping = mapping;
+			folio->index = index + i;
 		}
-	}
 }
 
 static void dax_disassociate_entry(void *entry, struct address_space *mapping,
 		bool trunc)
 {
-	unsigned long pfn;
+	struct folio *folio;
+	int i;
 
 	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
 		return;
 
-	for_each_mapped_pfn(entry, pfn) {
-		struct page *page = pfn_to_page(pfn);
-
-		if (dax_mapping_is_cow(page->mapping)) {
-			/* keep the CoW flag if this page is still shared */
-			if (page->index-- > 0)
+	dax_for_each_folio(entry, folio, i) {
+		if (dax_mapping_is_cow(folio->mapping)) {
+			/* keep the CoW flag if this folio is still shared */
+			if (folio->index-- > 0)
 				continue;
 		} else {
 			WARN_ON_ONCE(trunc && !dax_is_zapped(entry));
-			WARN_ON_ONCE(trunc && !dax_page_idle(page));
-			WARN_ON_ONCE(page->mapping && page->mapping != mapping);
+			WARN_ON_ONCE(trunc && !dax_folio_idle(folio));
+			WARN_ON_ONCE(folio->mapping && folio->mapping != mapping);
 		}
-		page->mapping = NULL;
-		page->index = 0;
+		folio->mapping = NULL;
+		folio->index = 0;
 	}
 }
 
@@ -673,20 +693,18 @@ static void *dax_zap_entry(struct xa_sta
 static struct page *dax_zap_pages(struct xa_state *xas, void *entry)
 {
 	struct page *ret = NULL;
-	unsigned long pfn;
+	struct folio *folio;
 	bool zap;
+	int i;
 
 	if (!dax_entry_size(entry))
 		return NULL;
 
 	zap = !dax_is_zapped(entry);
 
-	for_each_mapped_pfn(entry, pfn) {
-		struct page *page = pfn_to_page(pfn);
-
-		if (!ret && !dax_page_idle(page))
-			ret = page;
-	}
+	dax_for_each_folio(entry, folio, i)
+		if (!ret && !dax_folio_idle(folio))
+			ret = folio_page(folio, 0);
 
 	if (zap)
 		dax_zap_entry(xas, entry);
--- a/include/linux/dax.h~fsdax-rework-for_each_mapped_pfn-to-dax_for_each_folio
+++ a/include/linux/dax.h
@@ -222,6 +222,11 @@ static inline bool dax_page_idle(struct
 	return page_ref_count(page) == 1;
 }
 
+static inline bool dax_folio_idle(struct folio *folio)
+{
+	return dax_page_idle(folio_page(folio, 0));
+}
+
 #if IS_ENABLED(CONFIG_DAX)
 int dax_read_lock(void);
 void dax_read_unlock(int id);
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

