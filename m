Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D13FDC433FE
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiJQASZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiJQASS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:18:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792FC2A439
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:18:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC1B760EAE
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAB7C433C1;
        Mon, 17 Oct 2022 00:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665965896;
        bh=4cyZlJ222Slo+R8ikkfJuzlAuOsZrVMzbxguwbQuDhs=;
        h=Date:To:From:Subject:From;
        b=acMlzew8Mfc2N+IsyUOkadwxktzRGvSWzrCVWFBAi+MB37Lk4hMZsegAjMuZo9NBM
         ploqKCc88rLaYmUOdBRHhcidvcpVaZgTr3K7fpDPOGtPTDQyKy8MT39blBeMr7bPRk
         xuLsayNVGOKy7D8fIe1sCTNNY+8X0UI6FGCXhlq4=
Date:   Sun, 16 Oct 2022 17:18:15 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        willy@infradead.org, lyude@redhat.com, lkp@intel.com,
        kherbst@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        jgg@nvidia.com, jack@suse.cz, hch@lst.de, Felix.Kuehling@amd.com,
        djwong@kernel.org, david@fromorbit.com, daniel@ffwll.ch,
        christian.koenig@amd.com, bskeggs@redhat.com, apopple@nvidia.com,
        alexander.deucher@amd.com, airlied@linux.ie,
        dan.j.williams@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fsdax-use-dax_page_idle-to-document-dax-busy-page-checking.patch added to mm-unstable branch
Message-Id: <20221017001816.3EAB7C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fsdax: use dax_page_idle() to document DAX busy page checking
has been added to the -mm mm-unstable branch.  Its filename is
     fsdax-use-dax_page_idle-to-document-dax-busy-page-checking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fsdax-use-dax_page_idle-to-document-dax-busy-page-checking.patch

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
Subject: fsdax: use dax_page_idle() to document DAX busy page checking
Date: Fri, 14 Oct 2022 16:57:08 -0700

In advance of converting DAX pages to be 0-based, use a new
dax_page_idle() helper to both simplify that future conversion, but also
document all the kernel locations that are watching for DAX page idle
events.

Link: https://lkml.kernel.org/r/166579182839.2236710.16461867548859813784.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
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

 fs/dax.c            |    4 ++--
 fs/ext4/inode.c     |    3 +--
 fs/fuse/dax.c       |    5 ++---
 fs/xfs/xfs_file.c   |    5 ++---
 include/linux/dax.h |    9 +++++++++
 5 files changed, 16 insertions(+), 10 deletions(-)

--- a/fs/dax.c~fsdax-use-dax_page_idle-to-document-dax-busy-page-checking
+++ a/fs/dax.c
@@ -395,7 +395,7 @@ static void dax_disassociate_entry(void
 	for_each_mapped_pfn(entry, pfn) {
 		struct page *page = pfn_to_page(pfn);
 
-		WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
+		WARN_ON_ONCE(trunc && !dax_page_idle(page));
 		if (dax_mapping_is_cow(page->mapping)) {
 			/* keep the CoW flag if this page is still shared */
 			if (page->index-- > 0)
@@ -414,7 +414,7 @@ static struct page *dax_busy_page(void *
 	for_each_mapped_pfn(entry, pfn) {
 		struct page *page = pfn_to_page(pfn);
 
-		if (page_ref_count(page) > 1)
+		if (!dax_page_idle(page))
 			return page;
 	}
 	return NULL;
--- a/fs/ext4/inode.c~fsdax-use-dax_page_idle-to-document-dax-busy-page-checking
+++ a/fs/ext4/inode.c
@@ -3968,8 +3968,7 @@ int ext4_break_layouts(struct inode *ino
 		if (!page)
 			return 0;
 
-		error = ___wait_var_event(page,
-					  atomic_read(&page->_refcount) == 1,
+		error = ___wait_var_event(page, dax_page_idle(page),
 					  TASK_INTERRUPTIBLE, 0, 0,
 					  ext4_wait_dax_page(inode));
 	} while (error == 0);
--- a/fs/fuse/dax.c~fsdax-use-dax_page_idle-to-document-dax-busy-page-checking
+++ a/fs/fuse/dax.c
@@ -676,9 +676,8 @@ static int __fuse_dax_break_layouts(stru
 		return 0;
 
 	*retry = true;
-	return ___wait_var_event(page, atomic_read(&page->_refcount) == 1,
-				 TASK_INTERRUPTIBLE, 0, 0,
-				 fuse_wait_dax_page(inode));
+	return ___wait_var_event(page, dax_page_idle(page), TASK_INTERRUPTIBLE,
+				 0, 0, fuse_wait_dax_page(inode));
 }
 
 /* dmap_end == 0 leads to unmapping of whole file */
--- a/fs/xfs/xfs_file.c~fsdax-use-dax_page_idle-to-document-dax-busy-page-checking
+++ a/fs/xfs/xfs_file.c
@@ -827,9 +827,8 @@ xfs_break_dax_layouts(
 		return 0;
 
 	*retry = true;
-	return ___wait_var_event(page, atomic_read(&page->_refcount) == 1,
-				 TASK_INTERRUPTIBLE, 0, 0,
-				 xfs_wait_dax_page(inode));
+	return ___wait_var_event(page, dax_page_idle(page), TASK_INTERRUPTIBLE,
+				 0, 0, xfs_wait_dax_page(inode));
 }
 
 int
--- a/include/linux/dax.h~fsdax-use-dax_page_idle-to-document-dax-busy-page-checking
+++ a/include/linux/dax.h
@@ -210,6 +210,15 @@ int dax_zero_range(struct inode *inode,
 int dax_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
 		const struct iomap_ops *ops);
 
+/*
+ * Document all the code locations that want know when a dax page is
+ * unreferenced.
+ */
+static inline bool dax_page_idle(struct page *page)
+{
+	return page_ref_count(page) == 1;
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

