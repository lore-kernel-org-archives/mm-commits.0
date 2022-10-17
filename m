Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 804C6C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiJQAUF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiJQAT0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:19:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B00D7
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:19:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38EF3B80E2A
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE561C433D7;
        Mon, 17 Oct 2022 00:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665965956;
        bh=DwTVVAE2MNeBfox9CkeYV3uYwb3CecbeF6Gbbeg3lqM=;
        h=Date:To:From:Subject:From;
        b=YYkfCZGBV6/1HuffTgSYvGbg+urxAppfhVIEKQ3bBuxwlquUtLSSQYW/wCWDzaDx0
         tYbJNXoIgJgGWaQlHNT0EHJLa1OKy/FOzNn67H6jugmbBcCRPJMCgQGNvRvkS0OCbk
         OLAps12ztIBLlNl7BetbwjxkNnAEltrSeBSjTyQU=
Date:   Sun, 16 Oct 2022 17:19:16 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        willy@infradead.org, lyude@redhat.com, lkp@intel.com,
        kherbst@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        jgg@nvidia.com, jack@suse.cz, hch@lst.de, Felix.Kuehling@amd.com,
        djwong@kernel.org, david@fromorbit.com, daniel@ffwll.ch,
        christian.koenig@amd.com, bskeggs@redhat.com, apopple@nvidia.com,
        alexander.deucher@amd.com, airlied@linux.ie,
        dan.j.williams@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memremap_pages-initialize-all-zone_device-pages-to-start-at-refcount-0.patch added to mm-unstable branch
Message-Id: <20221017001916.CE561C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memremap_pages: initialize all ZONE_DEVICE pages to start at refcount 0
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memremap_pages-initialize-all-zone_device-pages-to-start-at-refcount-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memremap_pages-initialize-all-zone_device-pages-to-start-at-refcount-0.patch

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
Subject: mm/memremap_pages: initialize all ZONE_DEVICE pages to start at refcount 0
Date: Fri, 14 Oct 2022 16:59:12 -0700

The initial memremap_pages() implementation inherited the
__init_single_page() default of pages starting life with an elevated
reference count.  This originally allowed for the page->pgmap pointer to
alias with the storage for page->lru since a page was only allowed to be
on an lru list when its reference count was zero.

Since then, 'struct page' definition cleanups have arranged for dedicated
space for the ZONE_DEVICE page metadata, the
MEMORY_DEVICE_{PRIVATE,COHERENT} work has arranged for the 1 -> 0
page->_refcount transition to route the page to free_zone_device_page()
and not the core-mm page-free, and MEMORY_DEVICE_{PRIVATE,COHERENT} now
arranges for its ZONE_DEVICE pages to start at _refcount 0.  With those
cleanups in place and with filesystem-dax and device-dax now converted to
take and drop references at map and truncate time, it is possible to start
MEMORY_DEVICE_FS_DAX and MEMORY_DEVICE_GENERIC reference counts at 0 as
well.

This conversion also unifies all @pgmap accounting to be relative to
pgmap_request_folio() and the paired folio_put() calls for those requested
folios.  This allows pgmap_release_folios() to be simplified to just a
folio_put() helper.

Link: https://lkml.kernel.org/r/166579195218.2236710.8731183545033177929.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
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

 drivers/dax/mapping.c    |    2 +-
 include/linux/dax.h      |    2 +-
 include/linux/memremap.h |    6 ++----
 mm/memremap.c            |   36 ++++++++++++++++--------------------
 mm/page_alloc.c          |    9 +--------
 5 files changed, 21 insertions(+), 34 deletions(-)

--- a/drivers/dax/mapping.c~mm-memremap_pages-initialize-all-zone_device-pages-to-start-at-refcount-0
+++ a/drivers/dax/mapping.c
@@ -691,7 +691,7 @@ static struct page *dax_zap_pages(struct
 
 	dax_for_each_folio(entry, folio, i) {
 		if (zap)
-			pgmap_release_folios(folio_pgmap(folio), folio, 1);
+			pgmap_release_folios(folio, 1);
 		if (!ret && !dax_folio_idle(folio))
 			ret = folio_page(folio, 0);
 	}
--- a/include/linux/dax.h~mm-memremap_pages-initialize-all-zone_device-pages-to-start-at-refcount-0
+++ a/include/linux/dax.h
@@ -235,7 +235,7 @@ static inline void dax_unlock_mapping_en
  */
 static inline bool dax_page_idle(struct page *page)
 {
-	return page_ref_count(page) == 1;
+	return page_ref_count(page) == 0;
 }
 
 static inline bool dax_folio_idle(struct folio *folio)
--- a/include/linux/memremap.h~mm-memremap_pages-initialize-all-zone_device-pages-to-start-at-refcount-0
+++ a/include/linux/memremap.h
@@ -195,8 +195,7 @@ struct dev_pagemap *get_dev_pagemap(unsi
 				    struct dev_pagemap *pgmap);
 bool pgmap_request_folios(struct dev_pagemap *pgmap, struct folio *folio,
 			  int nr_folios);
-void pgmap_release_folios(struct dev_pagemap *pgmap, struct folio *folio,
-			  int nr_folios);
+void pgmap_release_folios(struct folio *folio, int nr_folios);
 bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
 
 unsigned long vmem_altmap_offset(struct vmem_altmap *altmap);
@@ -238,8 +237,7 @@ static inline bool pgmap_request_folios(
 	return false;
 }
 
-static inline void pgmap_release_folios(struct dev_pagemap *pgmap,
-					struct folio *folio, int nr_folios)
+static inline void pgmap_release_folios(struct folio *folio, int nr_folios)
 {
 }
 
--- a/mm/memremap.c~mm-memremap_pages-initialize-all-zone_device-pages-to-start-at-refcount-0
+++ a/mm/memremap.c
@@ -469,8 +469,10 @@ EXPORT_SYMBOL_GPL(get_dev_pagemap);
 
 void free_zone_device_page(struct page *page)
 {
-	if (WARN_ON_ONCE(!page->pgmap->ops || !page->pgmap->ops->page_free))
-		return;
+	struct dev_pagemap *pgmap = page->pgmap;
+
+	/* wake filesystem 'break dax layouts' waiters */
+	wake_up_var(page);
 
 	mem_cgroup_uncharge(page_folio(page));
 
@@ -505,17 +507,9 @@ void free_zone_device_page(struct page *
 	 * to clear page->mapping.
 	 */
 	page->mapping = NULL;
-	page->pgmap->ops->page_free(page);
-
-	if (page->pgmap->type != MEMORY_DEVICE_PRIVATE &&
-	    page->pgmap->type != MEMORY_DEVICE_COHERENT)
-		/*
-		 * Reset the page count to 1 to prepare for handing out the page
-		 * again.
-		 */
-		set_page_count(page, 1);
-	else
-		put_dev_pagemap(page->pgmap);
+	if (pgmap->ops && pgmap->ops->page_free)
+		pgmap->ops->page_free(page);
+	put_dev_pagemap(page->pgmap);
 }
 
 static bool folio_span_valid(struct dev_pagemap *pgmap, struct folio *folio,
@@ -576,17 +570,19 @@ bool pgmap_request_folios(struct dev_pag
 }
 EXPORT_SYMBOL_GPL(pgmap_request_folios);
 
-void pgmap_release_folios(struct dev_pagemap *pgmap, struct folio *folio, int nr_folios)
+/*
+ * A symmetric helper to undo the page references acquired by
+ * pgmap_request_folios(), but the caller can also just arrange
+ * folio_put() on all the folios it acquired previously for the same
+ * effect.
+ */
+void pgmap_release_folios(struct folio *folio, int nr_folios)
 {
 	struct folio *iter;
 	int i;
 
-	for (iter = folio, i = 0; i < nr_folios; iter = folio_next(iter), i++) {
-		if (!put_devmap_managed_page(&iter->page))
-			folio_put(iter);
-		if (!folio_ref_count(iter))
-			put_dev_pagemap(pgmap);
-	}
+	for (iter = folio, i = 0; i < nr_folios; iter = folio_next(folio), i++)
+		folio_put(iter);
 }
 
 #ifdef CONFIG_FS_DAX
--- a/mm/page_alloc.c~mm-memremap_pages-initialize-all-zone_device-pages-to-start-at-refcount-0
+++ a/mm/page_alloc.c
@@ -6791,6 +6791,7 @@ static void __ref __init_zone_device_pag
 {
 
 	__init_single_page(page, pfn, zone_idx, nid);
+	set_page_count(page, 0);
 
 	/*
 	 * Mark page reserved as it will need to wait for onlining
@@ -6823,14 +6824,6 @@ static void __ref __init_zone_device_pag
 		set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 		cond_resched();
 	}
-
-	/*
-	 * ZONE_DEVICE pages are released directly to the driver page allocator
-	 * which will set the page count to 1 when allocating the page.
-	 */
-	if (pgmap->type == MEMORY_DEVICE_PRIVATE ||
-	    pgmap->type == MEMORY_DEVICE_COHERENT)
-		set_page_count(page, 0);
 }
 
 /*
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

