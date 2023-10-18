Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 882FDC41513
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:36:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235305AbjJRVg1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232387AbjJRVgF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4938C131
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA606C433B8;
        Wed, 18 Oct 2023 21:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664912;
        bh=Qm+hF8dHZkXiJ9oJQwVz2PrP6ZmT10mEH/AldMGP3IM=;
        h=Date:To:From:Subject:From;
        b=PXXQQjpC84wgaz+Q6lnfNl18y/zLaL7HIz8RtZzjfmU+TtoGijaWNCtE0NZAs5Rjk
         Pl9GBAtP++fnLbof8PmfAuvtTJutHOKljD8O10J+qQaIoLHlGLzOFHFkL3pnE3ILBm
         Ybr6du+sUsTTJsXTUWPi8dYinQLgQvW7/j+DKldM=
Date:   Wed, 18 Oct 2023 14:35:11 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-handle-shared-faults-under-the-vma-lock.patch removed from -mm tree
Message-Id: <20231018213511.EA606C433B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: handle shared faults under the VMA lock
has been removed from the -mm tree.  Its filename was
     mm-handle-shared-faults-under-the-vma-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: handle shared faults under the VMA lock
Date: Fri, 6 Oct 2023 20:53:15 +0100

There are many implementations of ->fault and some of them depend on
mmap_lock being held.  All vm_ops that implement ->map_pages() end up
calling filemap_fault(), which I have audited to be sure it does not rely
on mmap_lock.  So (for now) key off ->map_pages existing as a flag to
indicate that it's safe to call ->fault while only holding the vma lock.

Link: https://lkml.kernel.org/r/20231006195318.4087158-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-handle-shared-faults-under-the-vma-lock
+++ a/mm/memory.c
@@ -3042,6 +3042,21 @@ static inline void wp_page_reuse(struct
 	count_vm_event(PGREUSE);
 }
 
+/*
+ * We could add a bitflag somewhere, but for now, we know that all
+ * vm_ops that have a ->map_pages have been audited and don't need
+ * the mmap_lock to be held.
+ */
+static inline vm_fault_t vmf_can_call_fault(const struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+
+	if (vma->vm_ops->map_pages || !(vmf->flags & FAULT_FLAG_VMA_LOCK))
+		return 0;
+	vma_end_read(vma);
+	return VM_FAULT_RETRY;
+}
+
 static vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
@@ -4669,10 +4684,9 @@ static vm_fault_t do_shared_fault(struct
 	vm_fault_t ret, tmp;
 	struct folio *folio;
 
-	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
-		vma_end_read(vma);
-		return VM_FAULT_RETRY;
-	}
+	ret = vmf_can_call_fault(vmf);
+	if (ret)
+		return ret;
 
 	ret = __do_fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-make-folio_create_empty_buffers-return-a-buffer_head.patch
mpage-convert-map_buffer_to_folio-to-folio_create_empty_buffers.patch
ext4-convert-to-folio_create_empty_buffers.patch
buffer-add-get_nth_bh.patch
gfs2-convert-inode-unstuffing-to-use-a-folio.patch
gfs2-convert-gfs2_getbuf-to-folios.patch
gfs2-convert-gfs2_getjdatabuf-to-use-a-folio.patch
gfs2-convert-gfs2_write_buf_to_page-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_freeze_buffer-to-use-a-folio.patch
nilfs2-convert-nilfs_grab_buffer-to-use-a-folio.patch
nilfs2-convert-nilfs_copy_page-to-nilfs_copy_folio.patch
nilfs2-convert-nilfs_mdt_forget_block-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_get_frozen_buffer-to-use-a-folio.patch
nilfs2-remove-nilfs_page_get_nth_block.patch
nilfs2-convert-nilfs_lookup_dirty_data_buffers-to-use-folio_create_empty_buffers.patch
ntfs-convert-ntfs_read_block-to-use-a-folio.patch
ntfs-convert-ntfs_writepage-to-use-a-folio.patch
ntfs-convert-ntfs_prepare_pages_for_non_resident_write-to-folios.patch
ntfs3-convert-ntfs_zero_range-to-use-a-folio.patch
ocfs2-convert-ocfs2_map_page_blocks-to-use-a-folio.patch
reiserfs-convert-writepage-to-use-a-folio.patch
ufs-add-ufs_get_locked_folio-and-ufs_put_locked_folio.patch
ufs-use-ufs_get_locked_folio-in-ufs_alloc_lastblock.patch
ufs-convert-ufs_change_blocknr-to-use-folios.patch
ufs-remove-ufs_get_locked_page.patch
buffer-remove-folio_create_empty_buffers.patch

