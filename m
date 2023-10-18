Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B8EECDB484
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbjJRVg3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235220AbjJRVgF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D97C132
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C337C433CC;
        Wed, 18 Oct 2023 21:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664913;
        bh=5l8qTw79YoaiocEVk+ZYO+bQkT+Oce4fxOBfUu+Wgvs=;
        h=Date:To:From:Subject:From;
        b=HLrPEu9vpCrjGi6I48OSHNg/jE67CLkU6urQ8CBUfv+At9MTcMbHJwG0J6inFeJaj
         XJdwH8RRZACYQWtfrvrLX5d85t3mzL/R5Xs+wmS/MDjUvl2INxTQpluyeyo0qcBk+H
         8AM5osm9lqXE5Q8WH1DnnPmMTve8o/WnNNP7BvvQ=
Date:   Wed, 18 Oct 2023 14:35:12 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-handle-cow-faults-under-the-vma-lock.patch removed from -mm tree
Message-Id: <20231018213513.0C337C433CC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: handle COW faults under the VMA lock
has been removed from the -mm tree.  Its filename was
     mm-handle-cow-faults-under-the-vma-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: handle COW faults under the VMA lock
Date: Fri, 6 Oct 2023 20:53:16 +0100

If the page is not currently present in the page tables, we need to call
the page fault handler to find out which page we're supposed to COW, so we
need to both check that there is already an anon_vma and that the fault
handler doesn't need the mmap_lock.

Link: https://lkml.kernel.org/r/20231006195318.4087158-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/memory.c~mm-handle-cow-faults-under-the-vma-lock
+++ a/mm/memory.c
@@ -4639,13 +4639,11 @@ static vm_fault_t do_cow_fault(struct vm
 	struct vm_area_struct *vma = vmf->vma;
 	vm_fault_t ret;
 
-	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
-		vma_end_read(vma);
-		return VM_FAULT_RETRY;
-	}
-
-	if (unlikely(anon_vma_prepare(vma)))
-		return VM_FAULT_OOM;
+	ret = vmf_can_call_fault(vmf);
+	if (!ret)
+		ret = vmf_anon_prepare(vmf);
+	if (ret)
+		return ret;
 
 	vmf->cow_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vmf->address);
 	if (!vmf->cow_page)
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

