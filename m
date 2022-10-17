Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49354C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiJQATx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiJQATP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:19:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463253121C
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:19:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 091D2B80E28
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB9DC433D6;
        Mon, 17 Oct 2022 00:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665965946;
        bh=bQEx0YY0886HgpRfyqPIIUx9FLMRL0BWFvD7oJ1zrgQ=;
        h=Date:To:From:Subject:From;
        b=y3LrYVcJSYelUBczdm3C24EPRtVqiVpIQUiH2GJjI96l+RAVoYIZV2/asxqYJDQUs
         hgOJ9H66XRJyfBBtvFk5KXV2EY8MAnJuInMmL4iEqObxrv303LqbZy4ouIliSsfs0v
         Cdks3TXnrBVm8+o4o3fp7s1krpqidNDReabO1SxA=
Date:   Sun, 16 Oct 2022 17:19:05 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        willy@infradead.org, lyude@redhat.com, lkp@intel.com,
        kherbst@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        jgg@nvidia.com, jack@suse.cz, hch@lst.de, Felix.Kuehling@amd.com,
        djwong@kernel.org, david@fromorbit.com, daniel@ffwll.ch,
        christian.koenig@amd.com, bskeggs@redhat.com, apopple@nvidia.com,
        alexander.deucher@amd.com, airlied@linux.ie,
        dan.j.williams@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + devdax-add-pud-support-to-the-dax-mapping-infrastructure.patch added to mm-unstable branch
Message-Id: <20221017001906.9FB9DC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: devdax: add PUD support to the DAX mapping infrastructure
has been added to the -mm mm-unstable branch.  Its filename is
     devdax-add-pud-support-to-the-dax-mapping-infrastructure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/devdax-add-pud-support-to-the-dax-mapping-infrastructure.patch

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
Subject: devdax: add PUD support to the DAX mapping infrastructure
Date: Fri, 14 Oct 2022 16:58:54 -0700

In preparation for using the DAX mapping infrastructure for device-dax,
update the helpers to handle PUD entries.

In practice the code related to @size_downgrade will go unused for PUD
entries since only devdax creates DAX PUD entries and devdax enforces
aligned mappings.  The conversion is included for completeness.

The addition of PUD support to the common dax_insert_pfn_mkwrite()
requires a new stub for vmf_insert_pfn_pud() in the case where huge page
support and/or PUD support is not available.

Link: https://lkml.kernel.org/r/166579193481.2236710.2902634991178133192.stgit@dwillia2-xfh.jf.intel.com
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

 drivers/dax/mapping.c   |   50 ++++++++++++++++++++++++++++----------
 include/linux/dax.h     |   32 +++++++++++++++---------
 include/linux/huge_mm.h |   14 ++++++++--
 3 files changed, 70 insertions(+), 26 deletions(-)

--- a/drivers/dax/mapping.c~devdax-add-pud-support-to-the-dax-mapping-infrastructure
+++ a/drivers/dax/mapping.c
@@ -13,6 +13,7 @@
 #include <linux/pfn_t.h>
 #include <linux/sizes.h>
 #include <linux/pagemap.h>
+#include <linux/huge_mm.h>
 
 #include "dax-private.h"
 
@@ -56,6 +57,8 @@ static bool dax_is_zapped(void *entry)
 
 static unsigned int dax_entry_order(void *entry)
 {
+	if (xa_to_value(entry) & DAX_PUD)
+		return PUD_ORDER;
 	if (xa_to_value(entry) & DAX_PMD)
 		return PMD_ORDER;
 	return 0;
@@ -66,9 +69,14 @@ static unsigned long dax_is_pmd_entry(vo
 	return xa_to_value(entry) & DAX_PMD;
 }
 
+static unsigned long dax_is_pud_entry(void *entry)
+{
+	return xa_to_value(entry) & DAX_PUD;
+}
+
 static bool dax_is_pte_entry(void *entry)
 {
-	return !(xa_to_value(entry) & DAX_PMD);
+	return !(xa_to_value(entry) & (DAX_PMD|DAX_PUD));
 }
 
 static int dax_is_zero_entry(void *entry)
@@ -277,6 +285,8 @@ static unsigned long dax_entry_size(void
 		return 0;
 	else if (dax_is_pmd_entry(entry))
 		return PMD_SIZE;
+	else if (dax_is_pud_entry(entry))
+		return PUD_SIZE;
 	else
 		return PAGE_SIZE;
 }
@@ -561,11 +571,11 @@ void *dax_grab_mapping_entry(struct xa_s
 			     struct address_space *mapping, unsigned int order)
 {
 	unsigned long index = xas->xa_index;
-	bool pmd_downgrade; /* splitting PMD entry into PTE entries? */
+	bool size_downgrade; /* splitting entry into PTE entries? */
 	void *entry;
 
 retry:
-	pmd_downgrade = false;
+	size_downgrade = false;
 	xas_lock_irq(xas);
 	entry = get_unlocked_entry(xas, order);
 
@@ -578,15 +588,25 @@ retry:
 		}
 
 		if (order == 0) {
-			if (dax_is_pmd_entry(entry) &&
+			if (!dax_is_pte_entry(entry) &&
 			    (dax_is_zero_entry(entry) ||
 			     dax_is_empty_entry(entry))) {
-				pmd_downgrade = true;
+				size_downgrade = true;
 			}
 		}
 	}
 
-	if (pmd_downgrade) {
+	if (size_downgrade) {
+		unsigned long colour, nr;
+
+		if (dax_is_pmd_entry(entry)) {
+			colour = PG_PMD_COLOUR;
+			nr = PG_PMD_NR;
+		} else {
+			colour = PG_PUD_COLOUR;
+			nr = PG_PUD_NR;
+		}
+
 		/*
 		 * Make sure 'entry' remains valid while we drop
 		 * the i_pages lock.
@@ -600,9 +620,8 @@ retry:
 		 */
 		if (dax_is_zero_entry(entry)) {
 			xas_unlock_irq(xas);
-			unmap_mapping_pages(mapping,
-					    xas->xa_index & ~PG_PMD_COLOUR,
-					    PG_PMD_NR, false);
+			unmap_mapping_pages(mapping, xas->xa_index & ~colour,
+					    nr, false);
 			xas_reset(xas);
 			xas_lock_irq(xas);
 		}
@@ -610,7 +629,7 @@ retry:
 		dax_disassociate_entry(entry, mapping, false);
 		xas_store(xas, NULL); /* undo the PMD join */
 		dax_wake_entry(xas, entry, WAKE_ALL);
-		mapping->nrpages -= PG_PMD_NR;
+		mapping->nrpages -= nr;
 		entry = NULL;
 		xas_set(xas, index);
 	}
@@ -620,7 +639,9 @@ retry:
 	} else {
 		unsigned long flags = DAX_EMPTY;
 
-		if (order > 0)
+		if (order == PUD_SHIFT - PAGE_SHIFT)
+			flags |= DAX_PUD;
+		else if (order == PMD_SHIFT - PAGE_SHIFT)
 			flags |= DAX_PMD;
 		entry = dax_make_entry(pfn_to_pfn_t(0), flags);
 		dax_lock_entry(xas, entry);
@@ -864,7 +885,10 @@ vm_fault_t dax_insert_entry(struct xa_st
 	if (cow || (dax_is_zero_entry(entry) && !(flags & DAX_ZERO_PAGE))) {
 		unsigned long index = xas->xa_index;
 		/* we are replacing a zero page with block mapping */
-		if (dax_is_pmd_entry(entry))
+		if (dax_is_pud_entry(entry))
+			unmap_mapping_pages(mapping, index & ~PG_PUD_COLOUR,
+					    PG_PUD_NR, false);
+		else if (dax_is_pmd_entry(entry))
 			unmap_mapping_pages(mapping, index & ~PG_PMD_COLOUR,
 					PG_PMD_NR, false);
 		else /* pte entry */
@@ -1040,6 +1064,8 @@ vm_fault_t dax_insert_pfn_mkwrite(struct
 	else if (order == PMD_ORDER)
 		ret = vmf_insert_pfn_pmd(vmf, pfn, FAULT_FLAG_WRITE);
 #endif
+	else if (order == PUD_ORDER)
+		ret = vmf_insert_pfn_pud(vmf, pfn, FAULT_FLAG_WRITE);
 	else
 		ret = VM_FAULT_FALLBACK;
 	dax_unlock_entry(&xas, entry);
--- a/include/linux/dax.h~devdax-add-pud-support-to-the-dax-mapping-infrastructure
+++ a/include/linux/dax.h
@@ -300,22 +300,25 @@ static inline bool dax_mapping(struct ad
 }
 
 /*
- * DAX pagecache entries use XArray value entries so they can't be mistaken
- * for pages.  We use one bit for locking, one bit for the entry size (PMD)
- * and two more to tell us if the entry is a zero page or an empty entry that
- * is just used for locking.  In total four special bits.
+ * DAX pagecache entries use XArray value entries so they can't be
+ * mistaken for pages.  We use one bit for locking, two bits for the
+ * entry size (PMD, PUD) and two more to tell us if the entry is a zero
+ * page or an empty entry that is just used for locking.  In total 5
+ * special bits which limits the max pfn that can be stored as:
+ * (1UL << 57 - PAGE_SHIFT). 63 - DAX_SHIFT - 1 (for xa_mk_value()).
  *
- * If the PMD bit isn't set the entry has size PAGE_SIZE, and if the ZERO_PAGE
- * and EMPTY bits aren't set the entry is a normal DAX entry with a filesystem
- * block allocation.
+ * If the P{M,U}D bits are not set the entry has size PAGE_SIZE, and if
+ * the ZERO_PAGE and EMPTY bits aren't set the entry is a normal DAX
+ * entry with a filesystem block allocation.
  */
-#define DAX_SHIFT	(5)
+#define DAX_SHIFT	(6)
 #define DAX_MASK	((1UL << DAX_SHIFT) - 1)
 #define DAX_LOCKED	(1UL << 0)
 #define DAX_PMD		(1UL << 1)
-#define DAX_ZERO_PAGE	(1UL << 2)
-#define DAX_EMPTY	(1UL << 3)
-#define DAX_ZAP		(1UL << 4)
+#define DAX_PUD		(1UL << 2)
+#define DAX_ZERO_PAGE	(1UL << 3)
+#define DAX_EMPTY	(1UL << 4)
+#define DAX_ZAP		(1UL << 5)
 
 /*
  * These flags are not conveyed in Xarray value entries, they are just
@@ -339,6 +342,13 @@ int dax_writeback_one(struct xa_state *x
 /* The order of a PMD entry */
 #define PMD_ORDER (PMD_SHIFT - PAGE_SHIFT)
 
+/* The 'colour' (ie low bits) within a PUD of a page offset.  */
+#define PG_PUD_COLOUR ((PUD_SIZE >> PAGE_SHIFT) - 1)
+#define PG_PUD_NR (PUD_SIZE >> PAGE_SHIFT)
+
+/* The order of a PUD entry */
+#define PUD_ORDER (PUD_SHIFT - PAGE_SHIFT)
+
 static inline unsigned int pe_order(enum page_entry_size pe_size)
 {
 	if (pe_size == PE_SIZE_PTE)
--- a/include/linux/huge_mm.h~devdax-add-pud-support-to-the-dax-mapping-infrastructure
+++ a/include/linux/huge_mm.h
@@ -16,12 +16,22 @@ int copy_huge_pud(struct mm_struct *dst_
 		  pud_t *dst_pud, pud_t *src_pud, unsigned long addr,
 		  struct vm_area_struct *vma);
 
-#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
+	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
 void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud);
+vm_fault_t vmf_insert_pfn_pud_prot(struct vm_fault *vmf, pfn_t pfn,
+				   pgprot_t pgprot, bool write);
 #else
 static inline void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud)
 {
 }
+
+static inline vm_fault_t vmf_insert_pfn_pud_prot(struct vm_fault *vmf,
+						 pfn_t pfn, pgprot_t pgprot,
+						 bool write)
+{
+	return VM_FAULT_SIGBUS;
+}
 #endif
 
 vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf);
@@ -58,8 +68,6 @@ static inline vm_fault_t vmf_insert_pfn_
 {
 	return vmf_insert_pfn_pmd_prot(vmf, pfn, vmf->vma->vm_page_prot, write);
 }
-vm_fault_t vmf_insert_pfn_pud_prot(struct vm_fault *vmf, pfn_t pfn,
-				   pgprot_t pgprot, bool write);
 
 /**
  * vmf_insert_pfn_pud - insert a pud size pfn
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

