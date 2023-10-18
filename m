Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3CACCDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:36:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235221AbjJRVgi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235252AbjJRVgG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712C5137
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CDDEC43215;
        Wed, 18 Oct 2023 21:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664915;
        bh=6py0jWTy+EsOpUnn8hCHxEURA5/wPiVgv44p4PB54uA=;
        h=Date:To:From:Subject:From;
        b=n1aeuTosZLZFsWk06v1+mwyePvAK85hMMe9ghEMA2oFFHMB2MTiPgSJb1cSCuph+F
         bpA4VxZpNrdffp8djpFK+i2XVivmq6vWXK4YsPvidCHENBTMOWtejXevMSHzr4bDb0
         sXrxnR62lWRtRSVQTqsUIjxYdl7884TNu2FuWskE=
Date:   Wed, 18 Oct 2023 14:35:14 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch removed from -mm tree
Message-Id: <20231018213515.2CDDEC43215@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: handle write faults to RO pages under the VMA lock
has been removed from the -mm tree.  Its filename was
     mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: handle write faults to RO pages under the VMA lock
Date: Fri, 6 Oct 2023 20:53:18 +0100

I think this is a pretty rare occurrence, but for consistency handle
faults with the VMA lock held the same way that we handle other faults
with the VMA lock held.

Link: https://lkml.kernel.org/r/20231006195318.4087158-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/memory.c~mm-handle-write-faults-to-ro-pages-under-the-vma-lock
+++ a/mm/memory.c
@@ -3301,10 +3301,9 @@ static vm_fault_t wp_pfn_shared(struct v
 		vm_fault_t ret;
 
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
-			vma_end_read(vmf->vma);
-			return VM_FAULT_RETRY;
-		}
+		ret = vmf_can_call_fault(vmf);
+		if (ret)
+			return ret;
 
 		vmf->flags |= FAULT_FLAG_MKWRITE;
 		ret = vma->vm_ops->pfn_mkwrite(vmf);
@@ -3328,10 +3327,10 @@ static vm_fault_t wp_page_shared(struct
 		vm_fault_t tmp;
 
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
+		tmp = vmf_can_call_fault(vmf);
+		if (tmp) {
 			folio_put(folio);
-			vma_end_read(vmf->vma);
-			return VM_FAULT_RETRY;
+			return tmp;
 		}
 
 		tmp = do_page_mkwrite(vmf, folio);
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

