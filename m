Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7352C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiJQASw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiJQASr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:18:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC0531202
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:18:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0566B80DAC
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2C2C433D6;
        Mon, 17 Oct 2022 00:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665965920;
        bh=VFZ9JVSILTUIJ6xyZCYs3/JRB4zEYzK9NlnVM7iE3tg=;
        h=Date:To:From:Subject:From;
        b=TqgQzXfW+VcrjD/H60AScrtR/dqhWy0jAfZ/mJIszFEQw9c1/1qEUrens/rhNeSLz
         4Fa6hHJurXrnLbY6sNeFJvhPB76T5dcYscURCyq9gq+YrT9QrG2M2Avf0nzOk7G8D6
         O8OeRj/6f+0nOxeRVYGrRwXKNYoi0jtgbOVDOzVs=
Date:   Sun, 16 Oct 2022 17:18:40 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        willy@infradead.org, lyude@redhat.com, lkp@intel.com,
        kherbst@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        jgg@nvidia.com, jack@suse.cz, hch@lst.de, Felix.Kuehling@amd.com,
        djwong@kernel.org, david@fromorbit.com, daniel@ffwll.ch,
        christian.koenig@amd.com, bskeggs@redhat.com, apopple@nvidia.com,
        alexander.deucher@amd.com, airlied@linux.ie,
        dan.j.williams@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fsdax-rework-dax_insert_entry-calling-convention.patch added to mm-unstable branch
Message-Id: <20221017001840.AD2C2C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fsdax: rework dax_insert_entry() calling convention
has been added to the -mm mm-unstable branch.  Its filename is
     fsdax-rework-dax_insert_entry-calling-convention.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fsdax-rework-dax_insert_entry-calling-convention.patch

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
Subject: fsdax: rework dax_insert_entry() calling convention
Date: Fri, 14 Oct 2022 16:58:01 -0700

Move the determination of @dirty and @cow in dax_insert_entry() to flags
(DAX_DIRTY and DAX_COW) that are passed in.  This allows
dax_insert_entry() to not require a 'struct iomap' which is a
pre-requisitie for reusing dax_insert_entry() for device-dax.

Link: https://lkml.kernel.org/r/166579188180.2236710.6959794790871279054.stgit@dwillia2-xfh.jf.intel.com
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

 fs/dax.c |   44 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 9 deletions(-)

--- a/fs/dax.c~fsdax-rework-dax_insert_entry-calling-convention
+++ a/fs/dax.c
@@ -75,12 +75,20 @@ fs_initcall(init_dax_wait_table);
  * block allocation.
  */
 #define DAX_SHIFT	(5)
+#define DAX_MASK	((1UL << DAX_SHIFT) - 1)
 #define DAX_LOCKED	(1UL << 0)
 #define DAX_PMD		(1UL << 1)
 #define DAX_ZERO_PAGE	(1UL << 2)
 #define DAX_EMPTY	(1UL << 3)
 #define DAX_ZAP		(1UL << 4)
 
+/*
+ * These flags are not conveyed in Xarray value entries, they are just
+ * modifiers to dax_insert_entry().
+ */
+#define DAX_DIRTY (1UL << (DAX_SHIFT + 0))
+#define DAX_COW   (1UL << (DAX_SHIFT + 1))
+
 static unsigned long dax_to_pfn(void *entry)
 {
 	return xa_to_value(entry) >> DAX_SHIFT;
@@ -88,7 +96,8 @@ static unsigned long dax_to_pfn(void *en
 
 static void *dax_make_entry(pfn_t pfn, unsigned long flags)
 {
-	return xa_mk_value(flags | (pfn_t_to_pfn(pfn) << DAX_SHIFT));
+	return xa_mk_value((flags & DAX_MASK) |
+			   (pfn_t_to_pfn(pfn) << DAX_SHIFT));
 }
 
 static bool dax_is_locked(void *entry)
@@ -932,6 +941,20 @@ static bool dax_fault_is_cow(const struc
 		(iter->iomap.flags & IOMAP_F_SHARED);
 }
 
+static unsigned long dax_iter_flags(const struct iomap_iter *iter,
+				    struct vm_fault *vmf)
+{
+	unsigned long flags = 0;
+
+	if (!dax_fault_is_synchronous(iter, vmf->vma))
+		flags |= DAX_DIRTY;
+
+	if (dax_fault_is_cow(iter))
+		flags |= DAX_COW;
+
+	return flags;
+}
+
 /*
  * By this point grab_mapping_entry() has ensured that we have a locked entry
  * of the appropriate size so we don't have to worry about downgrading PMDs to
@@ -940,13 +963,13 @@ static bool dax_fault_is_cow(const struc
  * appropriate.
  */
 static vm_fault_t dax_insert_entry(struct xa_state *xas, struct vm_fault *vmf,
-				   const struct iomap_iter *iter, void **pentry,
-				   pfn_t pfn, unsigned long flags)
+				   void **pentry, pfn_t pfn,
+				   unsigned long flags)
 {
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	void *new_entry = dax_make_entry(pfn, flags);
-	bool dirty = !dax_fault_is_synchronous(iter, vmf->vma);
-	bool cow = dax_fault_is_cow(iter);
+	bool dirty = flags & DAX_DIRTY;
+	bool cow = flags & DAX_COW;
 	void *entry = *pentry;
 	vm_fault_t ret = 0;
 
@@ -1245,7 +1268,8 @@ static vm_fault_t dax_load_hole(struct x
 	pfn_t pfn = pfn_to_pfn_t(my_zero_pfn(vaddr));
 	vm_fault_t ret;
 
-	ret = dax_insert_entry(xas, vmf, iter, entry, pfn, DAX_ZERO_PAGE);
+	ret = dax_insert_entry(xas, vmf, entry, pfn,
+			       DAX_ZERO_PAGE | dax_iter_flags(iter, vmf));
 	if (ret)
 		goto out;
 
@@ -1276,8 +1300,9 @@ static vm_fault_t dax_pmd_load_hole(stru
 		goto fallback;
 
 	pfn = page_to_pfn_t(zero_page);
-	ret = dax_insert_entry(xas, vmf, iter, entry, pfn,
-			       DAX_PMD | DAX_ZERO_PAGE);
+	ret = dax_insert_entry(xas, vmf, entry, pfn,
+			       DAX_PMD | DAX_ZERO_PAGE |
+				       dax_iter_flags(iter, vmf));
 	if (ret)
 		return ret;
 
@@ -1662,7 +1687,8 @@ static vm_fault_t dax_fault_iter(struct
 		return pmd ? VM_FAULT_FALLBACK : dax_fault_return(err);
 	}
 
-	ret = dax_insert_entry(xas, vmf, iter, entry, pfn, entry_flags);
+	ret = dax_insert_entry(xas, vmf, entry, pfn,
+			       entry_flags | dax_iter_flags(iter, vmf));
 	dax_read_unlock(id);
 	if (ret)
 		return ret;
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

