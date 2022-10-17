Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7599C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiJQASc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiJQASa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:18:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D316630F43
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:18:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20346B80D5C
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:18:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18DDC433D7;
        Mon, 17 Oct 2022 00:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665965905;
        bh=58jLfAV+5GPvm5P6CZ+27+8GPbb+FMJgIqjep6Uhzoc=;
        h=Date:To:From:Subject:From;
        b=T5Q1Z07kCCgkfv3GwNS6jSDGRMXY5DoxQxlPluUTKzpmnJyz6FfJuZyi7iVcwQ1t2
         M7D5qpsws12nr8enTQG8EvTgpDyZBCaR+JrHR4Gue9AOjzChg3PzxrDQ3LorgPG8zd
         hU4bXujpav8eQw4AQkb3oKhfexjNnQfPXFh8unAA=
Date:   Sun, 16 Oct 2022 17:18:25 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        willy@infradead.org, lyude@redhat.com, lkp@intel.com,
        kherbst@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        jgg@nvidia.com, jack@suse.cz, hch@lst.de, Felix.Kuehling@amd.com,
        djwong@kernel.org, david@fromorbit.com, daniel@ffwll.ch,
        christian.koenig@amd.com, bskeggs@redhat.com, apopple@nvidia.com,
        alexander.deucher@amd.com, airlied@linux.ie,
        dan.j.williams@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fsdax-wait-for-pinned-pages-during-truncate_inode_pages_final.patch added to mm-unstable branch
Message-Id: <20221017001825.D18DDC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fsdax: wait for pinned pages during truncate_inode_pages_final()
has been added to the -mm mm-unstable branch.  Its filename is
     fsdax-wait-for-pinned-pages-during-truncate_inode_pages_final.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fsdax-wait-for-pinned-pages-during-truncate_inode_pages_final.patch

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
Subject: fsdax: wait for pinned pages during truncate_inode_pages_final()
Date: Fri, 14 Oct 2022 16:57:25 -0700

The fsdax truncate vs page pinning solution is incomplete.  The initial
solution landed in v4.17 and covered typical truncate invoked through
truncate(2) and fallocate(2), i.e.  the truncate_inode_pages() called on
open files.  However, that enabling left truncate_inode_pages_final(),
called after iput_final() to free the inode, unprotected.  Thankfully that
v4.17 enabling also left a warning in place to fire if any truncate is
attempted while a DAX page is still pinned:

commit d2c997c0f145 ("fs, dax: use page->mapping to warn if truncate collides with a busy page")

While a lore search indicates no reports of that firing, the hole is there
nonetheless.  The concern is that if/when that warning fires it indicates
a use-after-free condition whereby the filesystem has lost the ability to
arbitrate access to its storage blocks.  For example, in the worst case,
DMA may be ongoing while the filesystem thinks the block is free to be
reallocated to another inode.

This patch is based on an observation from Dave that during iput_final()
there is no need to hold filesystem locks like the explicit truncate path.
The wait can occur from within dax_delete_mapping_entry() called by
truncate_folio_batch_exceptionals().

This solution trades off fixing the use-after-free with a theoretical
deadlock scenario.  If the agent holding the page pin triggers inode
reclaim and that reclaim waits for the pin to drop it will deadlock.  Two
observations make this approach still worth pursuing:

1/ Any existing scenarios where that happens would have triggered the
   warning referenced above which has shipped upstream for ~5 years
   without a bug report on lore.

2/ Most I/O drivers only hold page pins in their fast paths and new
   __GFP_FS allocations are unlikely in a driver fast path. I.e. if the
   deadlock triggers the likely fix would be in the offending driver, not
   new band-aids in fsdax.

So, update the DAX core to notice that the inode->i_mapping is in the
exiting state and use that as a signal that the inode is unreferenced
await page-pins to drain.

Link: https://lkml.kernel.org/r/166579184544.2236710.791897642091142558.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Dave Chinner <david@fromorbit.com>
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
Cc: David Airlie <airlied@linux.ie>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

--- a/fs/dax.c~fsdax-wait-for-pinned-pages-during-truncate_inode_pages_final
+++ a/fs/dax.c
@@ -804,12 +804,36 @@ out:
 }
 
 /*
+ * wait indefinitely for all pins to drop, the alternative to waiting is
+ * a potential use-after-free scenario
+ */
+static void dax_break_layout(struct address_space *mapping, pgoff_t index)
+{
+	/* To do this without locks, the inode needs to be unreferenced */
+	WARN_ON(atomic_read(&mapping->host->i_count));
+	do {
+		struct page *page;
+
+		page = dax_zap_mappings_range(mapping, index << PAGE_SHIFT,
+					      (index + 1) << PAGE_SHIFT);
+		if (!page)
+			return;
+		wait_var_event(page, dax_page_idle(page));
+	} while (true);
+}
+
+/*
  * Delete DAX entry at @index from @mapping.  Wait for it
  * to be unlocked before deleting it.
  */
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index)
 {
-	int ret = __dax_invalidate_entry(mapping, index, true);
+	int ret;
+
+	if (mapping_exiting(mapping))
+		dax_break_layout(mapping, index);
+
+	ret = __dax_invalidate_entry(mapping, index, true);
 
 	/*
 	 * This gets called from truncate / punch_hole path. As such, the caller
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

