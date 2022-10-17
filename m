Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BF8AC43219
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:18:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiJQASu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiJQASq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:18:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F3A30576
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:18:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AFFA60E8C
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF42BC433C1;
        Mon, 17 Oct 2022 00:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665965917;
        bh=ih0sfw6sQbRoDQsCq2gduiGC21VgItb9bGdGKFatcwQ=;
        h=Date:To:From:Subject:From;
        b=LpYud3YZUApgT9z6Gss4FgCgj4NLTBgvJdjWasFPEKr5Mhti4XyYbrgMfN/kadDfZ
         EkCM6XtITNTcKTpczPYAxmhiscdOABQx/2sZzsfwGJgIZ3EAcUbvXixa8/Gn3acSIE
         GJTyoECBN+LyblFPbp9ppYzuM8UqOrdDpOTshgoM=
Date:   Sun, 16 Oct 2022 17:18:37 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        willy@infradead.org, lyude@redhat.com, lkp@intel.com,
        kherbst@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        jgg@nvidia.com, jack@suse.cz, hch@lst.de, Felix.Kuehling@amd.com,
        djwong@kernel.org, david@fromorbit.com, daniel@ffwll.ch,
        christian.koenig@amd.com, bskeggs@redhat.com, apopple@nvidia.com,
        alexander.deucher@amd.com, airlied@linux.ie,
        dan.j.williams@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fsdax-introduce-pgmap_request_folios.patch added to mm-unstable branch
Message-Id: <20221017001837.BF42BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fsdax: introduce pgmap_request_folios()
has been added to the -mm mm-unstable branch.  Its filename is
     fsdax-introduce-pgmap_request_folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fsdax-introduce-pgmap_request_folios.patch

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
Subject: fsdax: introduce pgmap_request_folios()
Date: Fri, 14 Oct 2022 16:57:55 -0700

The next step in sanitizing DAX page and pgmap lifetime is to take page
references when a pgmap user maps a page or otherwise puts it into use. 
Unlike the page allocator where the it picks the page/folio, ZONE_DEVICE
users know in advance which folio they want to access.  Additionally,
ZONE_DEVICE implementations know when the pgmap is alive.  Introduce
pgmap_request_folios() that pins @nr_folios folios at a time provided they
are contiguous and of the same folio_order().

Some WARN assertions are added to document expectations and catch bugs in
future kernel work, like a potential conversion of fsdax to use multi-page
folios, but they otherwise are not expected to fire.

Note that the paired pgmap_release_folios() implementation temporarily, in
this path, takes an @pgmap argument to drop pgmap references.  A follow-on
patch arranges for free_zone_device_page() to drop pgmap references in all
cases.  In other words, the intent is that only put_folio() (on each folio
requested pgmap_request_folio()) is needed to to undo
pgmap_request_folios().

The intent is that this also replaces zone_device_page_init(), but that
too requires some more preparatory reworks to unify the various
MEMORY_DEVICE_* types.

Link: https://lkml.kernel.org/r/166579187573.2236710.10151157417629496558.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
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

 fs/dax.c                 |   32 +++++++++++++---
 include/linux/memremap.h |   17 ++++++++
 mm/memremap.c            |   70 +++++++++++++++++++++++++++++++++++++
 3 files changed, 111 insertions(+), 8 deletions(-)

--- a/fs/dax.c~fsdax-introduce-pgmap_request_folios
+++ a/fs/dax.c
@@ -385,20 +385,27 @@ static inline void dax_mapping_set_cow(s
 	folio->index++;
 }
 
+static struct dev_pagemap *folio_pgmap(struct folio *folio)
+{
+	return folio_page(folio, 0)->pgmap;
+}
+
 /*
  * When it is called in dax_insert_entry(), the cow flag will indicate that
  * whether this entry is shared by multiple files.  If so, set the page->mapping
  * FS_DAX_MAPPING_COW, and use page->index as refcount.
  */
-static void dax_associate_entry(void *entry, struct address_space *mapping,
-		struct vm_area_struct *vma, unsigned long address, bool cow)
+static vm_fault_t dax_associate_entry(void *entry,
+				      struct address_space *mapping,
+				      struct vm_area_struct *vma,
+				      unsigned long address, bool cow)
 {
 	unsigned long size = dax_entry_size(entry), index;
 	struct folio *folio;
 	int i;
 
 	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
-		return;
+		return 0;
 
 	index = linear_page_index(vma, address & ~(size - 1));
 	dax_for_each_folio(entry, folio, i)
@@ -406,9 +413,13 @@ static void dax_associate_entry(void *en
 			dax_mapping_set_cow(folio);
 		} else {
 			WARN_ON_ONCE(folio->mapping);
+			if (!pgmap_request_folios(folio_pgmap(folio), folio, 1))
+				return VM_FAULT_SIGBUS;
 			folio->mapping = mapping;
 			folio->index = index + i;
 		}
+
+	return 0;
 }
 
 static void dax_disassociate_entry(void *entry, struct address_space *mapping,
@@ -702,9 +713,12 @@ static struct page *dax_zap_pages(struct
 
 	zap = !dax_is_zapped(entry);
 
-	dax_for_each_folio(entry, folio, i)
+	dax_for_each_folio(entry, folio, i) {
+		if (zap)
+			pgmap_release_folios(folio_pgmap(folio), folio, 1);
 		if (!ret && !dax_folio_idle(folio))
 			ret = folio_page(folio, 0);
+	}
 
 	if (zap)
 		dax_zap_entry(xas, entry);
@@ -934,6 +948,7 @@ static vm_fault_t dax_insert_entry(struc
 	bool dirty = !dax_fault_is_synchronous(iter, vmf->vma);
 	bool cow = dax_fault_is_cow(iter);
 	void *entry = *pentry;
+	vm_fault_t ret = 0;
 
 	if (dirty)
 		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
@@ -954,8 +969,10 @@ static vm_fault_t dax_insert_entry(struc
 		void *old;
 
 		dax_disassociate_entry(entry, mapping, false);
-		dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address,
+		ret = dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address,
 				cow);
+		if (ret)
+			goto out;
 		/*
 		 * Only swap our new entry into the page cache if the current
 		 * entry is a zero page or an empty entry.  If a normal PTE or
@@ -978,10 +995,11 @@ static vm_fault_t dax_insert_entry(struc
 	if (cow)
 		xas_set_mark(xas, PAGECACHE_TAG_TOWRITE);
 
+	*pentry = entry;
+out:
 	xas_unlock_irq(xas);
 
-	*pentry = entry;
-	return 0;
+	return ret;
 }
 
 static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
--- a/include/linux/memremap.h~fsdax-introduce-pgmap_request_folios
+++ a/include/linux/memremap.h
@@ -193,7 +193,11 @@ void memunmap_pages(struct dev_pagemap *
 void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
 void devm_memunmap_pages(struct device *dev, struct dev_pagemap *pgmap);
 struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
-		struct dev_pagemap *pgmap);
+				    struct dev_pagemap *pgmap);
+bool pgmap_request_folios(struct dev_pagemap *pgmap, struct folio *folio,
+			  int nr_folios);
+void pgmap_release_folios(struct dev_pagemap *pgmap, struct folio *folio,
+			  int nr_folios);
 bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
 
 unsigned long vmem_altmap_offset(struct vmem_altmap *altmap);
@@ -223,6 +227,17 @@ static inline struct dev_pagemap *get_de
 	return NULL;
 }
 
+static inline bool pgmap_request_folios(struct dev_pagemap *pgmap,
+					struct folio *folio, int nr_folios)
+{
+	return false;
+}
+
+static inline void pgmap_release_folios(struct dev_pagemap *pgmap,
+					struct folio *folio, int nr_folios)
+{
+}
+
 static inline bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn)
 {
 	return false;
--- a/mm/memremap.c~fsdax-introduce-pgmap_request_folios
+++ a/mm/memremap.c
@@ -530,6 +530,76 @@ void zone_device_page_init(struct page *
 }
 EXPORT_SYMBOL_GPL(zone_device_page_init);
 
+static bool folio_span_valid(struct dev_pagemap *pgmap, struct folio *folio,
+			     int nr_folios)
+{
+	unsigned long pfn_start, pfn_end;
+
+	pfn_start = page_to_pfn(folio_page(folio, 0));
+	pfn_end = pfn_start + (1 << folio_order(folio)) * nr_folios - 1;
+
+	if (pgmap != xa_load(&pgmap_array, pfn_start))
+		return false;
+
+	if (pfn_end > pfn_start && pgmap != xa_load(&pgmap_array, pfn_end))
+		return false;
+
+	return true;
+}
+
+/**
+ * pgmap_request_folios - activate an contiguous span of folios in @pgmap
+ * @pgmap: host page map for the folio array
+ * @folio: start of the folio list, all subsequent folios have same folio_size()
+ *
+ * Caller is responsible for @pgmap remaining live for the duration of
+ * this call. Caller is also responsible for not racing requests for the
+ * same folios.
+ */
+bool pgmap_request_folios(struct dev_pagemap *pgmap, struct folio *folio,
+			  int nr_folios)
+{
+	struct folio *iter;
+	int i;
+
+	/*
+	 * All of the WARNs below are for catching bugs in future
+	 * development that changes the assumptions of:
+	 * 1/ uniform folios in @pgmap
+	 * 2/ @pgmap death does not race this routine.
+	 */
+	VM_WARN_ON_ONCE(!folio_span_valid(pgmap, folio, nr_folios));
+
+	if (WARN_ON_ONCE(percpu_ref_is_dying(&pgmap->ref)))
+		return false;
+
+	for (iter = folio_next(folio), i = 1; i < nr_folios;
+	     iter = folio_next(folio), i++)
+		if (WARN_ON_ONCE(folio_order(iter) != folio_order(folio)))
+			return false;
+
+	for (iter = folio, i = 0; i < nr_folios; iter = folio_next(iter), i++) {
+		folio_ref_inc(iter);
+		if (folio_ref_count(iter) == 1)
+			percpu_ref_tryget(&pgmap->ref);
+	}
+
+	return true;
+}
+
+void pgmap_release_folios(struct dev_pagemap *pgmap, struct folio *folio, int nr_folios)
+{
+	struct folio *iter;
+	int i;
+
+	for (iter = folio, i = 0; i < nr_folios; iter = folio_next(iter), i++) {
+		if (!put_devmap_managed_page(&iter->page))
+			folio_put(iter);
+		if (!folio_ref_count(iter))
+			put_dev_pagemap(pgmap);
+	}
+}
+
 #ifdef CONFIG_FS_DAX
 bool __put_devmap_managed_page_refs(struct page *page, int refs)
 {
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

