Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8686DC43219
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiJQATd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiJQATM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:19:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC6430F7D
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:19:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95F33B80E2A
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC98C433D6;
        Mon, 17 Oct 2022 00:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665965941;
        bh=KgYAV/GzS+r2w+xvSe9wb6NZA71FmeVPketXibfuYoQ=;
        h=Date:To:From:Subject:From;
        b=CFwCIyHOunYABxS/woWdqDfVp83ZBKPsbENuR4/M726tmWV/Ozr+Ei3ppuftPn1U5
         Bm2RUzcwn1L/1m+Ekdwj4JABn2QoQexHxvxUWakwlzLdZ95dXBkgKPiVpYfvPJj/MN
         42wnhIRQma3GhuXhvBKMy63+YV+U6sPfl4qzUA7o=
Date:   Sun, 16 Oct 2022 17:19:00 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        willy@infradead.org, lyude@redhat.com, lkp@intel.com,
        kherbst@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        jgg@nvidia.com, jack@suse.cz, hch@lst.de, Felix.Kuehling@amd.com,
        djwong@kernel.org, david@fromorbit.com, daniel@ffwll.ch,
        christian.koenig@amd.com, bskeggs@redhat.com, apopple@nvidia.com,
        alexander.deucher@amd.com, airlied@linux.ie,
        dan.j.williams@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + devdax-sparse-fixes-for-vmfault_t-dax-entry-conversions.patch added to mm-unstable branch
Message-Id: <20221017001901.4FC98C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: devdax: sparse fixes for vmfault_t/dax-entry conversions
has been added to the -mm mm-unstable branch.  Its filename is
     devdax-sparse-fixes-for-vmfault_t-dax-entry-conversions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/devdax-sparse-fixes-for-vmfault_t-dax-entry-conversions.patch

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
Subject: devdax: sparse fixes for vmfault_t/dax-entry conversions
Date: Fri, 14 Oct 2022 16:58:43 -0700

Now that the dax-mapping-entry code has moved to a common location take
the opportunity to fixup some long standing sparse warnings.  In this case
conveying vm_fault_t codes through Xarray internal values was missing some
forced casts.  Add some helpers, is_dax_err(), dax_err_to_vmfault(), and
vmfault_to_dax_err() to handle the conversions.

Link: https://lkml.kernel.org/r/166579192360.2236710.14796211268184430654.stgit@dwillia2-xfh.jf.intel.com
Fixes:
drivers/dax/mapping.c:637:39: sparse: warning: incorrect type in argument 1 (different base types)
drivers/dax/mapping.c:637:39: sparse:    expected unsigned long v
drivers/dax/mapping.c:637:39: sparse:    got restricted vm_fault_t
drivers/dax/mapping.c:639:39: sparse: warning: incorrect type in argument 1 (different base types)
drivers/dax/mapping.c:639:39: sparse:    expected unsigned long v
drivers/dax/mapping.c:639:39: sparse:    got restricted vm_fault_t
drivers/dax/mapping.c:643:31: sparse: warning: incorrect type in argument 1 (different base types)
drivers/dax/mapping.c:643:31: sparse:    expected unsigned long v
drivers/dax/mapping.c:643:31: sparse:    got restricted vm_fault_t

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
  Link: http://lore.kernel.org/r/202210091141.cHaQEuCs-lkp@intel.com
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/mapping.c |    6 +++---
 fs/dax.c              |    8 ++++----
 include/linux/dax.h   |   16 ++++++++++++++++
 3 files changed, 23 insertions(+), 7 deletions(-)

--- a/drivers/dax/mapping.c~devdax-sparse-fixes-for-vmfault_t-dax-entry-conversions
+++ a/drivers/dax/mapping.c
@@ -634,13 +634,13 @@ out_unlock:
 	if (xas_nomem(xas, mapping_gfp_mask(mapping) & ~__GFP_HIGHMEM))
 		goto retry;
 	if (xas->xa_node == XA_ERROR(-ENOMEM))
-		return xa_mk_internal(VM_FAULT_OOM);
+		return vmfault_to_dax_err(VM_FAULT_OOM);
 	if (xas_error(xas))
-		return xa_mk_internal(VM_FAULT_SIGBUS);
+		return vmfault_to_dax_err(VM_FAULT_SIGBUS);
 	return entry;
 fallback:
 	xas_unlock_irq(xas);
-	return xa_mk_internal(VM_FAULT_FALLBACK);
+	return vmfault_to_dax_err(VM_FAULT_FALLBACK);
 }
 
 static void *dax_zap_entry(struct xa_state *xas, void *entry)
--- a/fs/dax.c~devdax-sparse-fixes-for-vmfault_t-dax-entry-conversions
+++ a/fs/dax.c
@@ -710,8 +710,8 @@ static vm_fault_t dax_iomap_pte_fault(st
 		iter.flags |= IOMAP_WRITE;
 
 	entry = dax_grab_mapping_entry(&xas, mapping, 0);
-	if (xa_is_internal(entry)) {
-		ret = xa_to_internal(entry);
+	if (is_dax_err(entry)) {
+		ret = dax_err_to_vmfault(entry);
 		goto out;
 	}
 
@@ -832,8 +832,8 @@ static vm_fault_t dax_iomap_pmd_fault(st
 	 * VM_FAULT_FALLBACK.
 	 */
 	entry = dax_grab_mapping_entry(&xas, mapping, PMD_ORDER);
-	if (xa_is_internal(entry)) {
-		ret = xa_to_internal(entry);
+	if (is_dax_err(entry)) {
+		ret = dax_err_to_vmfault(entry);
 		goto fallback;
 	}
 
--- a/include/linux/dax.h~devdax-sparse-fixes-for-vmfault_t-dax-entry-conversions
+++ a/include/linux/dax.h
@@ -264,6 +264,22 @@ vm_fault_t dax_iomap_fault(struct vm_fau
 		    pfn_t *pfnp, int *errp, const struct iomap_ops *ops);
 vm_fault_t dax_finish_sync_fault(struct vm_fault *vmf,
 		enum page_entry_size pe_size, pfn_t pfn);
+
+static inline bool is_dax_err(void *entry)
+{
+	return xa_is_internal(entry);
+}
+
+static inline vm_fault_t dax_err_to_vmfault(void *entry)
+{
+	return (vm_fault_t __force)(xa_to_internal(entry));
+}
+
+static inline void *vmfault_to_dax_err(vm_fault_t error)
+{
+	return xa_mk_internal((unsigned long __force)error);
+}
+
 void *dax_grab_mapping_entry(struct xa_state *xas,
 			     struct address_space *mapping, unsigned int order);
 void dax_unlock_entry(struct xa_state *xas, void *entry);
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

