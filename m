Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A26EC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiJQASr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiJQASf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:18:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9A42E9FA
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:18:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42BFC60EB7
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:18:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9096AC433C1;
        Mon, 17 Oct 2022 00:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665965912;
        bh=D0Y1VVa8c/7jXlUFTRhKxKdp38mfgiKmLGrTpwPSVTE=;
        h=Date:To:From:Subject:From;
        b=prM8oxrZ9IqMdlbU5U5HCTVyYSmYBFZ/TF/h5ynmjmTlVmkn9o4jUroSfZULeHX20
         pEDfqYAClfhqPySTpg8E0hBz995MuLqiARxAQkTez1OYGN+uUgl+dCl5aUeL1hRtCm
         SKHv1asJuzjmygC9kACqSgBuE5Sayjf2y8mrEkk8=
Date:   Sun, 16 Oct 2022 17:18:31 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        willy@infradead.org, lyude@redhat.com, lkp@intel.com,
        kherbst@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        jgg@nvidia.com, jack@suse.cz, hch@lst.de, Felix.Kuehling@amd.com,
        djwong@kernel.org, david@fromorbit.com, daniel@ffwll.ch,
        christian.koenig@amd.com, bskeggs@redhat.com, apopple@nvidia.com,
        alexander.deucher@amd.com, airlied@linux.ie,
        dan.j.williams@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fsdax-update-dax_insert_entry-calling-convention-to-return-an-error.patch added to mm-unstable branch
Message-Id: <20221017001832.9096AC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fsdax: update dax_insert_entry() calling convention to return an error
has been added to the -mm mm-unstable branch.  Its filename is
     fsdax-update-dax_insert_entry-calling-convention-to-return-an-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fsdax-update-dax_insert_entry-calling-convention-to-return-an-error.patch

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
Subject: fsdax: update dax_insert_entry() calling convention to return an error
Date: Fri, 14 Oct 2022 16:57:43 -0700

In preparation for teaching dax_insert_entry() to take live @pgmap
references, enable it to return errors.  Given the observation that all
callers overwrite the passed in entry with the return value, just update
@entry in place and convert the return code to a vm_fault_t status.

Link: https://lkml.kernel.org/r/166579186334.2236710.388332274317019999.stgit@dwillia2-xfh.jf.intel.com
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

 fs/dax.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

--- a/fs/dax.c~fsdax-update-dax_insert_entry-calling-convention-to-return-an-error
+++ a/fs/dax.c
@@ -907,14 +907,15 @@ static bool dax_fault_is_cow(const struc
  * already in the tree, we will skip the insertion and just dirty the PMD as
  * appropriate.
  */
-static void *dax_insert_entry(struct xa_state *xas, struct vm_fault *vmf,
-		const struct iomap_iter *iter, void *entry, pfn_t pfn,
-		unsigned long flags)
+static vm_fault_t dax_insert_entry(struct xa_state *xas, struct vm_fault *vmf,
+				   const struct iomap_iter *iter, void **pentry,
+				   pfn_t pfn, unsigned long flags)
 {
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	void *new_entry = dax_make_entry(pfn, flags);
 	bool dirty = !dax_fault_is_synchronous(iter, vmf->vma);
 	bool cow = dax_fault_is_cow(iter);
+	void *entry = *pentry;
 
 	if (dirty)
 		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
@@ -960,7 +961,9 @@ static void *dax_insert_entry(struct xa_
 		xas_set_mark(xas, PAGECACHE_TAG_TOWRITE);
 
 	xas_unlock_irq(xas);
-	return entry;
+
+	*pentry = entry;
+	return 0;
 }
 
 static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
@@ -1206,9 +1209,12 @@ static vm_fault_t dax_load_hole(struct x
 	pfn_t pfn = pfn_to_pfn_t(my_zero_pfn(vaddr));
 	vm_fault_t ret;
 
-	*entry = dax_insert_entry(xas, vmf, iter, *entry, pfn, DAX_ZERO_PAGE);
+	ret = dax_insert_entry(xas, vmf, iter, entry, pfn, DAX_ZERO_PAGE);
+	if (ret)
+		goto out;
 
 	ret = vmf_insert_mixed(vmf->vma, vaddr, pfn);
+out:
 	trace_dax_load_hole(inode, vmf, ret);
 	return ret;
 }
@@ -1225,6 +1231,7 @@ static vm_fault_t dax_pmd_load_hole(stru
 	struct page *zero_page;
 	spinlock_t *ptl;
 	pmd_t pmd_entry;
+	vm_fault_t ret;
 	pfn_t pfn;
 
 	zero_page = mm_get_huge_zero_page(vmf->vma->vm_mm);
@@ -1233,8 +1240,10 @@ static vm_fault_t dax_pmd_load_hole(stru
 		goto fallback;
 
 	pfn = page_to_pfn_t(zero_page);
-	*entry = dax_insert_entry(xas, vmf, iter, *entry, pfn,
-				  DAX_PMD | DAX_ZERO_PAGE);
+	ret = dax_insert_entry(xas, vmf, iter, entry, pfn,
+			       DAX_PMD | DAX_ZERO_PAGE);
+	if (ret)
+		return ret;
 
 	if (arch_needs_pgtable_deposit()) {
 		pgtable = pte_alloc_one(vma->vm_mm);
@@ -1590,6 +1599,7 @@ static vm_fault_t dax_fault_iter(struct
 	bool write = iter->flags & IOMAP_WRITE;
 	unsigned long entry_flags = pmd ? DAX_PMD : 0;
 	int err = 0, id;
+	vm_fault_t ret;
 	pfn_t pfn;
 	void *kaddr;
 
@@ -1616,8 +1626,10 @@ static vm_fault_t dax_fault_iter(struct
 		return pmd ? VM_FAULT_FALLBACK : dax_fault_return(err);
 	}
 
-	*entry = dax_insert_entry(xas, vmf, iter, *entry, pfn, entry_flags);
+	ret = dax_insert_entry(xas, vmf, iter, entry, pfn, entry_flags);
 	dax_read_unlock(id);
+	if (ret)
+		return ret;
 
 	if (write &&
 	    srcmap->type != IOMAP_HOLE && srcmap->addr != iomap->addr) {
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

