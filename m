Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F41C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiJQATN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiJQASt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:18:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD482E9FA
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:18:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C4685CE0F80
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:18:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B39C433C1;
        Mon, 17 Oct 2022 00:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665965925;
        bh=PeTd3/m9jmwywYIErY4j2sQuZ9OaHQs0AfDW6Shoczk=;
        h=Date:To:From:Subject:From;
        b=fE2ECeJiBA6AXy27yoKdYs1mqdSXC9dFp9zDl4zRGZ2fagjJN+eakNCcvk8w5VFPB
         KLDmlhVygDBn+x0+xit6KrvIT3LvGQNElY6NVxR7lvqOO4pxnbL00UOfMunVpeBOAf
         YNwNGMow9eEf6SSuXKgJo9wwCS+JSqQF3DMnNp0U=
Date:   Sun, 16 Oct 2022 17:18:44 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        willy@infradead.org, lyude@redhat.com, lkp@intel.com,
        kherbst@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        jgg@nvidia.com, jack@suse.cz, hch@lst.de, Felix.Kuehling@amd.com,
        djwong@kernel.org, david@fromorbit.com, daniel@ffwll.ch,
        christian.koenig@amd.com, bskeggs@redhat.com, apopple@nvidia.com,
        alexander.deucher@amd.com, airlied@linux.ie,
        dan.j.williams@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + devdax-minor-warning-fixups.patch added to mm-unstable branch
Message-Id: <20221017001845.15B39C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: devdax: minor warning fixups
has been added to the -mm mm-unstable branch.  Its filename is
     devdax-minor-warning-fixups.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/devdax-minor-warning-fixups.patch

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
Subject: devdax: minor warning fixups
Date: Fri, 14 Oct 2022 16:58:14 -0700

Fix a missing prototype warning for dev_dax_probe(), and fix dax_holder()
comment block format.  These are holdover fixes that are now being
addressed as some fsdax infrastructure is being moved into the dax core.

Link: https://lkml.kernel.org/r/166579189421.2236710.9800883307049200257.stgit@dwillia2-xfh.jf.intel.com
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

 drivers/dax/dax-private.h |    1 +
 drivers/dax/super.c       |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/dax/dax-private.h~devdax-minor-warning-fixups
+++ a/drivers/dax/dax-private.h
@@ -87,6 +87,7 @@ static inline struct dax_mapping *to_dax
 }
 
 phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff, unsigned long size);
+int dev_dax_probe(struct dev_dax *dev_dax);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline bool dax_align_valid(unsigned long align)
--- a/drivers/dax/super.c~devdax-minor-warning-fixups
+++ a/drivers/dax/super.c
@@ -475,7 +475,7 @@ EXPORT_SYMBOL_GPL(put_dax);
 /**
  * dax_holder() - obtain the holder of a dax device
  * @dax_dev: a dax_device instance
-
+ *
  * Return: the holder's data which represents the holder if registered,
  * otherwize NULL.
  */
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

