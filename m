Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743121990AE
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 06:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736317605; cv=none; b=g6Rx9tiOKa/LQ15SkfY4lUDJaicZbErY8qGcj8eZdAcfUeMWA6M9HEnzO1WdzpdGnwhJM0tQ/w9Vg5MSOJrwTWy/mqhTirTIkuonAyMZkfafkKW5fHz+BC+M7tvLzfnMI8aekQYLQQ/fyPWaDJfTqUOnL4AQXXWdDP6T6n0V5Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736317605; c=relaxed/simple;
	bh=Lt2VZf9yarxoyZdon98KimeZHH4PN3XiPa+TCDYaUkE=;
	h=Date:To:From:Subject:Message-Id; b=OvkOWRJrcvVroyoKqGjn5LFVCw/L61CcvD4XwA7M/20xxW7IAR3KNvswGHW7bpQ9GVZjhEVSkTlnOjIzAjsAL65UfyfuIiKntZK1DHZFbHGWxilXU+k8HIA+bcFRGBqPcFuo/BltW7Mt+EqI66+xrPaeE6V6le59P91KlMEPJCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0BL9rvPl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0BL9rvPl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1537C4CEDE;
	Wed,  8 Jan 2025 06:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736317605;
	bh=Lt2VZf9yarxoyZdon98KimeZHH4PN3XiPa+TCDYaUkE=;
	h=Date:To:From:Subject:From;
	b=0BL9rvPltLzEMDbO8xjsjstK2g5jsM1wr6B9/EmGHmYzyTCWGXFEjcoRhYXMc9k6W
	 /lp2ucrDsCT+4HwLekaa4KJnSdbx4JvqyhZsFwpZpNeiGARpRALraArS1KTrkQHsCQ
	 /grQZ/QRcilfntNjGzugiGIIfJxbTt1V3LMpGxPs=
Date: Tue, 07 Jan 2025 22:26:44 -0800
To: mm-commits@vger.kernel.org,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-dax-remove-page_mapping_dax_shared-mapping-flag.patch added to mm-unstable branch
Message-Id: <20250108062644.F1537C4CEDE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/dax: remove PAGE_MAPPING_DAX_SHARED mapping flag
has been added to the -mm mm-unstable branch.  Its filename is
     fs-dax-remove-page_mapping_dax_shared-mapping-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-dax-remove-page_mapping_dax_shared-mapping-flag.patch

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
Subject: fs/dax: remove PAGE_MAPPING_DAX_SHARED mapping flag
Date: Tue, 7 Jan 2025 14:42:24 +1100

PAGE_MAPPING_DAX_SHARED is the same as PAGE_MAPPING_ANON.  This isn't
currently a problem because FS DAX pages are treated specially.  However a
future change will make FS DAX pages more like normal pages, so
folio_test_anon() must not return true for a FS DAX page.

We could explicitly test for a FS DAX page in folio_test_anon(), etc. 
however the PAGE_MAPPING_DAX_SHARED flag isn't actually needed.  Instead
we can use the page->mapping field to implicitly track the first mapping
of a page.  If page->mapping is non-NULL it implies the page is associated
with a single mapping at page->index.  If the page is associated with a
second mapping clear page->mapping and set page->share to 1.

This is possible because a shared mapping implies the file-system
implements dax_holder_operations which makes the ->mapping and ->index,
which is a union with ->share, unused.

The page is considered shared when page->mapping == NULL and page->share >
0 or page->mapping != NULL, implying it is present in at least one address
space.  This also makes it easier for a future change to detect when a
page is first mapped into an address space which requires special
handling.

Link: https://lkml.kernel.org/r/792742e7339dcc088fcbfb0daa9b5ab82534f557.1736221254.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c                   |   45 ++++++++++++++++++++++-------------
 include/linux/page-flags.h |    6 ----
 2 files changed, 29 insertions(+), 22 deletions(-)

--- a/fs/dax.c~fs-dax-remove-page_mapping_dax_shared-mapping-flag
+++ a/fs/dax.c
@@ -351,38 +351,41 @@ static unsigned long dax_end_pfn(void *e
 	for (pfn = dax_to_pfn(entry); \
 			pfn < dax_end_pfn(entry); pfn++)
 
+/*
+ * A DAX page is considered shared if it has no mapping set and ->share (which
+ * shares the ->index field) is non-zero. Note this may return false even if the
+ * page if shared between multiple files but has not yet actually been mapped
+ * into multiple address spaces.
+ */
 static inline bool dax_page_is_shared(struct page *page)
 {
-	return page->mapping == PAGE_MAPPING_DAX_SHARED;
+	return !page->mapping && page->share;
 }
 
 /*
- * Set the page->mapping with PAGE_MAPPING_DAX_SHARED flag, increase the
- * refcount.
+ * Increase the page share refcount, warning if the page is not marked as shared.
  */
 static inline void dax_page_share_get(struct page *page)
 {
-	if (page->mapping != PAGE_MAPPING_DAX_SHARED) {
-		/*
-		 * Reset the index if the page was already mapped
-		 * regularly before.
-		 */
-		if (page->mapping)
-			page->share = 1;
-		page->mapping = PAGE_MAPPING_DAX_SHARED;
-	}
+	WARN_ON_ONCE(!page->share);
+	WARN_ON_ONCE(page->mapping);
 	page->share++;
 }
 
 static inline unsigned long dax_page_share_put(struct page *page)
 {
+	WARN_ON_ONCE(!page->share);
 	return --page->share;
 }
 
 /*
- * When it is called in dax_insert_entry(), the shared flag will indicate that
- * whether this entry is shared by multiple files.  If so, set the page->mapping
- * PAGE_MAPPING_DAX_SHARED, and use page->share as refcount.
+ * When it is called in dax_insert_entry(), the shared flag will indicate
+ * whether this entry is shared by multiple files. If the page has not
+ * previously been associated with any mappings the ->mapping and ->index
+ * fields will be set. If it has already been associated with a mapping
+ * the mapping will be cleared and the share count set. It's then up the
+ * file-system to track which mappings contain which pages, ie. by implementing
+ * dax_holder_operations.
  */
 static void dax_associate_entry(void *entry, struct address_space *mapping,
 		struct vm_area_struct *vma, unsigned long address, bool shared)
@@ -397,7 +400,17 @@ static void dax_associate_entry(void *en
 	for_each_mapped_pfn(entry, pfn) {
 		struct page *page = pfn_to_page(pfn);
 
-		if (shared) {
+		if (shared && page->mapping && page->share) {
+			if (page->mapping) {
+				page->mapping = NULL;
+
+				/*
+				 * Page has already been mapped into one address
+				 * space so set the share count.
+				 */
+				page->share = 1;
+			}
+
 			dax_page_share_get(page);
 		} else {
 			WARN_ON_ONCE(page->mapping);
--- a/include/linux/page-flags.h~fs-dax-remove-page_mapping_dax_shared-mapping-flag
+++ a/include/linux/page-flags.h
@@ -673,12 +673,6 @@ PAGEFLAG_FALSE(VmemmapSelfHosted, vmemma
 #define PAGE_MAPPING_KSM	(PAGE_MAPPING_ANON | PAGE_MAPPING_MOVABLE)
 #define PAGE_MAPPING_FLAGS	(PAGE_MAPPING_ANON | PAGE_MAPPING_MOVABLE)
 
-/*
- * Different with flags above, this flag is used only for fsdax mode.  It
- * indicates that this page->mapping is now under reflink case.
- */
-#define PAGE_MAPPING_DAX_SHARED	((void *)0x1)
-
 static __always_inline bool folio_mapping_flags(const struct folio *folio)
 {
 	return ((unsigned long)folio->mapping & PAGE_MAPPING_FLAGS) != 0;
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

