Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEF5CC433FE
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:19:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiJQATR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiJQASw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:18:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7AE2A950
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:18:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CCB960EBC
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25D6C433C1;
        Mon, 17 Oct 2022 00:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665965929;
        bh=FcUE7UuqwayseuWlnlJRCx8w/8ZStRCFh9A+RJZC6Z0=;
        h=Date:To:From:Subject:From;
        b=Tl4dX7KOXRYqlOMALZ58oUQ0iOAa2b02KJAB7in1nSyiUAxKk08nWEiglNfwWlkps
         boDKzb/j1kCzc9nrpDXjAKlq/SwsYCWjWUzOO8eBazao0xLDJWXfZaDdEEC5JURHWk
         2478gTBxw71bXfj7vXNsOLn1ZE6Isyi6Ur/OUoRw=
Date:   Sun, 16 Oct 2022 17:18:49 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        willy@infradead.org, lyude@redhat.com, lkp@intel.com,
        kherbst@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        jgg@nvidia.com, jack@suse.cz, hch@lst.de, Felix.Kuehling@amd.com,
        djwong@kernel.org, david@fromorbit.com, daniel@ffwll.ch,
        christian.koenig@amd.com, bskeggs@redhat.com, apopple@nvidia.com,
        alexander.deucher@amd.com, airlied@linux.ie,
        dan.j.williams@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + libnvdimm-pmem-support-pmem-block-devices-without-dax.patch added to mm-unstable branch
Message-Id: <20221017001849.B25D6C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: libnvdimm/pmem: support pmem block devices without dax
has been added to the -mm mm-unstable branch.  Its filename is
     libnvdimm-pmem-support-pmem-block-devices-without-dax.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/libnvdimm-pmem-support-pmem-block-devices-without-dax.patch

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
Subject: libnvdimm/pmem: support pmem block devices without dax
Date: Fri, 14 Oct 2022 16:58:26 -0700

In preparation for CONFIG_DAX growing a CONFIG_MMU dependency add support
for pmem to skip dax-device registration in the CONFIG_DAX=n case.

alloc_dax() returns NULL in the CONFIG_DAX=n case, ERR_PTR() in the
failure case, and a dax-device in the success case.

dax_remove_host(), kill_dax() and put_dax() are safe to call if
setup_dax() returns 0 because it suceeded, or 0 because CONFIG_DAX=n.

Link: https://lkml.kernel.org/r/166579190607.2236710.1230996282258115812.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
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
Cc: kernel test robot <lkp@intel.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nvdimm/Kconfig |    2 -
 drivers/nvdimm/pmem.c  |   47 ++++++++++++++++++++++++---------------
 2 files changed, 31 insertions(+), 18 deletions(-)

--- a/drivers/nvdimm/Kconfig~libnvdimm-pmem-support-pmem-block-devices-without-dax
+++ a/drivers/nvdimm/Kconfig
@@ -19,7 +19,7 @@ if LIBNVDIMM
 config BLK_DEV_PMEM
 	tristate "PMEM: Persistent memory block device support"
 	default LIBNVDIMM
-	select DAX
+	select DAX if MMU
 	select ND_BTT if BTT
 	select ND_PFN if NVDIMM_PFN
 	help
--- a/drivers/nvdimm/pmem.c~libnvdimm-pmem-support-pmem-block-devices-without-dax
+++ a/drivers/nvdimm/pmem.c
@@ -468,6 +468,32 @@ static const struct dev_pagemap_ops fsda
 	.memory_failure		= pmem_pagemap_memory_failure,
 };
 
+static int setup_dax(struct pmem_device *pmem, struct gendisk *disk,
+		     struct nd_region *nd_region)
+{
+	struct dax_device *dax_dev;
+	int rc;
+
+	dax_dev = alloc_dax(pmem, &pmem_dax_ops);
+	if (IS_ERR(dax_dev))
+		return PTR_ERR(dax_dev);
+	if (!dax_dev)
+		return 0;
+	set_dax_nocache(dax_dev);
+	set_dax_nomc(dax_dev);
+	if (is_nvdimm_sync(nd_region))
+		set_dax_synchronous(dax_dev);
+	rc = dax_add_host(dax_dev, disk);
+	if (rc) {
+		kill_dax(dax_dev);
+		put_dax(dax_dev);
+		return rc;
+	}
+	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
+	pmem->dax_dev = dax_dev;
+	return 0;
+}
+
 static int pmem_attach_disk(struct device *dev,
 		struct nd_namespace_common *ndns)
 {
@@ -477,7 +503,6 @@ static int pmem_attach_disk(struct devic
 	struct resource *res = &nsio->res;
 	struct range bb_range;
 	struct nd_pfn *nd_pfn = NULL;
-	struct dax_device *dax_dev;
 	struct nd_pfn_sb *pfn_sb;
 	struct pmem_device *pmem;
 	struct request_queue *q;
@@ -578,24 +603,13 @@ static int pmem_attach_disk(struct devic
 	nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_range);
 	disk->bb = &pmem->bb;
 
-	dax_dev = alloc_dax(pmem, &pmem_dax_ops);
-	if (IS_ERR(dax_dev)) {
-		rc = PTR_ERR(dax_dev);
-		goto out;
-	}
-	set_dax_nocache(dax_dev);
-	set_dax_nomc(dax_dev);
-	if (is_nvdimm_sync(nd_region))
-		set_dax_synchronous(dax_dev);
-	rc = dax_add_host(dax_dev, disk);
+	rc = setup_dax(pmem, disk, nd_region);
 	if (rc)
-		goto out_cleanup_dax;
-	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
-	pmem->dax_dev = dax_dev;
+		goto out;
 
 	rc = device_add_disk(dev, disk, pmem_attribute_groups);
 	if (rc)
-		goto out_remove_host;
+		goto out_dax;
 	if (devm_add_action_or_reset(dev, pmem_release_disk, pmem))
 		return -ENOMEM;
 
@@ -607,9 +621,8 @@ static int pmem_attach_disk(struct devic
 		dev_warn(dev, "'badblocks' notification disabled\n");
 	return 0;
 
-out_remove_host:
+out_dax:
 	dax_remove_host(pmem->disk);
-out_cleanup_dax:
 	kill_dax(pmem->dax_dev);
 	put_dax(pmem->dax_dev);
 out:
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

