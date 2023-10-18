Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09894CDB482
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjJRVg2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbjJRVgF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120AC12F
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF049C433BA;
        Wed, 18 Oct 2023 21:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664911;
        bh=VXBKrT4dUXTeIPrHEGN9ocRwHBf3KeyY5PSLxGyBQ4k=;
        h=Date:To:From:Subject:From;
        b=MWpNAwQvyx5HpLlGmqD1g9sDLDQTx9XQ0zutNV0HUgHYPEptHIEGWzH0Rtq5xPhVG
         Sto5MZPPk2/pOCXerhYRVGesx8XuYPR8okeE+brGLLCaYyI0mgUp+j3sC2ILtkv70B
         RsJCTnaP5q4oe7i7EvFpTHU23Py5DjkP2nMdOrNY=
Date:   Wed, 18 Oct 2023 14:35:10 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-call-wp_page_copy-under-the-vma-lock.patch removed from -mm tree
Message-Id: <20231018213510.DF049C433BA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: call wp_page_copy() under the VMA lock
has been removed from the -mm tree.  Its filename was
     mm-call-wp_page_copy-under-the-vma-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: call wp_page_copy() under the VMA lock
Date: Fri, 6 Oct 2023 20:53:14 +0100

It is usually safe to call wp_page_copy() under the VMA lock.  The only
unsafe situation is when no anon_vma has been allocated for this VMA, and
we have to look at adjacent VMAs to determine if their anon_vma can be
shared.  Since this happens only for the first COW of a page in this VMA,
the majority of calls to wp_page_copy() do not need to fall back to the
mmap_sem.

Add vmf_anon_prepare() as an alternative to anon_vma_prepare() which will
return RETRY if we currently hold the VMA lock and need to allocate an
anon_vma.  This lets us drop the check in do_wp_page().

Link: https://lkml.kernel.org/r/20231006195318.4087158-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

--- a/mm/memory.c~mm-call-wp_page_copy-under-the-vma-lock
+++ a/mm/memory.c
@@ -3042,6 +3042,21 @@ static inline void wp_page_reuse(struct
 	count_vm_event(PGREUSE);
 }
 
+static vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+
+	if (likely(vma->anon_vma))
+		return 0;
+	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
+		vma_end_read(vma);
+		return VM_FAULT_RETRY;
+	}
+	if (__anon_vma_prepare(vma))
+		return VM_FAULT_OOM;
+	return 0;
+}
+
 /*
  * Handle the case of a page which we actually need to copy to a new page,
  * either due to COW or unsharing.
@@ -3069,27 +3084,29 @@ static vm_fault_t wp_page_copy(struct vm
 	pte_t entry;
 	int page_copied = 0;
 	struct mmu_notifier_range range;
-	int ret;
+	vm_fault_t ret;
 
 	delayacct_wpcopy_start();
 
 	if (vmf->page)
 		old_folio = page_folio(vmf->page);
-	if (unlikely(anon_vma_prepare(vma)))
-		goto oom;
+	ret = vmf_anon_prepare(vmf);
+	if (unlikely(ret))
+		goto out;
 
 	if (is_zero_pfn(pte_pfn(vmf->orig_pte))) {
 		new_folio = vma_alloc_zeroed_movable_folio(vma, vmf->address);
 		if (!new_folio)
 			goto oom;
 	} else {
+		int err;
 		new_folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma,
 				vmf->address, false);
 		if (!new_folio)
 			goto oom;
 
-		ret = __wp_page_copy_user(&new_folio->page, vmf->page, vmf);
-		if (ret) {
+		err = __wp_page_copy_user(&new_folio->page, vmf->page, vmf);
+		if (err) {
 			/*
 			 * COW failed, if the fault was solved by other,
 			 * it's fine. If not, userspace would re-fault on
@@ -3102,7 +3119,7 @@ static vm_fault_t wp_page_copy(struct vm
 				folio_put(old_folio);
 
 			delayacct_wpcopy_end();
-			return ret == -EHWPOISON ? VM_FAULT_HWPOISON : 0;
+			return err == -EHWPOISON ? VM_FAULT_HWPOISON : 0;
 		}
 		kmsan_copy_page_meta(&new_folio->page, vmf->page);
 	}
@@ -3212,11 +3229,13 @@ static vm_fault_t wp_page_copy(struct vm
 oom_free_new:
 	folio_put(new_folio);
 oom:
+	ret = VM_FAULT_OOM;
+out:
 	if (old_folio)
 		folio_put(old_folio);
 
 	delayacct_wpcopy_end();
-	return VM_FAULT_OOM;
+	return ret;
 }
 
 /**
@@ -3458,12 +3477,6 @@ reuse:
 		return 0;
 	}
 copy:
-	if ((vmf->flags & FAULT_FLAG_VMA_LOCK) && !vma->anon_vma) {
-		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		vma_end_read(vmf->vma);
-		return VM_FAULT_RETRY;
-	}
-
 	/*
 	 * Ok, we need to copy. Oh, well..
 	 */
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

