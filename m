Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C95FDC433FE
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiJQASq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiJQASf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:18:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74CF2A701
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:18:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A197EB80DAC
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B948C433D6;
        Mon, 17 Oct 2022 00:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665965910;
        bh=PFjuWf0kcJQw6RbTUwG4G27lI5mO9f7qYW7APcnUvAo=;
        h=Date:To:From:Subject:From;
        b=GPZEydYMwk+BKXL8Q8BhStdzNaO3ppWJJN+YZ2HvgqRwpsw0itQOpUpwenoRJg68A
         eq9VQnkS34EnWIznfspjhLBFHTS0BzbWqKJTt9akbPkko5ZFhFuIea5V/BpsBFXJI7
         0B44ea7NmrOW5WD8UyQXMtZoG0twif1nLivSBQS4=
Date:   Sun, 16 Oct 2022 17:18:29 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        willy@infradead.org, lyude@redhat.com, lkp@intel.com,
        kherbst@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        jgg@nvidia.com, jack@suse.cz, hch@lst.de, Felix.Kuehling@amd.com,
        djwong@kernel.org, david@fromorbit.com, daniel@ffwll.ch,
        christian.koenig@amd.com, bskeggs@redhat.com, apopple@nvidia.com,
        alexander.deucher@amd.com, airlied@linux.ie,
        dan.j.williams@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fsdax-hold-dax-lock-over-mapping-insertion.patch added to mm-unstable branch
Message-Id: <20221017001830.5B948C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fsdax: hold dax lock over mapping insertion
has been added to the -mm mm-unstable branch.  Its filename is
     fsdax-hold-dax-lock-over-mapping-insertion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fsdax-hold-dax-lock-over-mapping-insertion.patch

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
Subject: fsdax: hold dax lock over mapping insertion
Date: Fri, 14 Oct 2022 16:57:37 -0700

In preparation for dax_insert_entry() to start taking page and pgmap
references ensure that page->pgmap is valid by holding the dax_read_lock()
over both dax_direct_access() and dax_insert_entry().

I.e.  the code that wants to elevate the reference count of a pgmap page
from 0 -> 1 must ensure that the pgmap is not exiting and will not start
exiting until the proper references have been taken.

Link: https://lkml.kernel.org/r/166579185727.2236710.8711235794537270051.stgit@dwillia2-xfh.jf.intel.com
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

 fs/dax.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/dax.c~fsdax-hold-dax-lock-over-mapping-insertion
+++ a/fs/dax.c
@@ -1107,10 +1107,9 @@ static int dax_iomap_direct_access(const
 		size_t size, void **kaddr, pfn_t *pfnp)
 {
 	pgoff_t pgoff = dax_iomap_pgoff(iomap, pos);
-	int id, rc = 0;
 	long length;
+	int rc = 0;
 
-	id = dax_read_lock();
 	length = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size),
 				   DAX_ACCESS, kaddr, pfnp);
 	if (length < 0) {
@@ -1135,7 +1134,6 @@ out_check_addr:
 	if (!*kaddr)
 		rc = -EFAULT;
 out:
-	dax_read_unlock(id);
 	return rc;
 }
 
@@ -1591,7 +1589,7 @@ static vm_fault_t dax_fault_iter(struct
 	loff_t pos = (loff_t)xas->xa_index << PAGE_SHIFT;
 	bool write = iter->flags & IOMAP_WRITE;
 	unsigned long entry_flags = pmd ? DAX_PMD : 0;
-	int err = 0;
+	int err = 0, id;
 	pfn_t pfn;
 	void *kaddr;
 
@@ -1611,11 +1609,15 @@ static vm_fault_t dax_fault_iter(struct
 		return pmd ? VM_FAULT_FALLBACK : VM_FAULT_SIGBUS;
 	}
 
+	id = dax_read_lock();
 	err = dax_iomap_direct_access(iomap, pos, size, &kaddr, &pfn);
-	if (err)
+	if (err) {
+		dax_read_unlock(id);
 		return pmd ? VM_FAULT_FALLBACK : dax_fault_return(err);
+	}
 
 	*entry = dax_insert_entry(xas, vmf, iter, *entry, pfn, entry_flags);
+	dax_read_unlock(id);
 
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

